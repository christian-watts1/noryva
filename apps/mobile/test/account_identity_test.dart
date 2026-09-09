import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:noryva_mobile/core/database/app_database.dart';
import 'package:noryva_mobile/features/account/account_controller.dart';
import 'package:noryva_mobile/features/account/account_screen.dart';
import 'package:noryva_mobile/features/account/identity_client.dart';
import 'package:noryva_mobile/features/diary/domain/diary_entry.dart';
import 'package:noryva_mobile/features/settings/presentation/me_screen.dart';

const a = '11111111-1111-4111-8111-111111111111';
const b = '22222222-2222-4222-8222-222222222222';
const device = '33333333-3333-4333-8333-333333333333';

class MemoryStore implements SessionStore {
  String? value;
  bool failClear = false;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String value) async {
    this.value = value;
  }

  @override
  Future<void> clear() async {
    if (failClear) throw const IdentityFailure();
    value = null;
  }
}

class FakeEmail implements EmailIdentityProvider {
  @override
  bool configured = true;
  @override
  Future<void> begin(String email, {required bool create}) async {}
  @override
  Future<LoginToken?> confirm(String code) async => LoginToken(
    'synthetic-access-token',
    DateTime.now().add(const Duration(minutes: 5)),
  );
}

class FakeApi implements AccountApi {
  String account = a;
  int registrations = 0;
  bool offline = false;
  @override
  bool configured = true;
  @override
  Future<String> session(String token) async => account;
  @override
  Future<String> register(String token, String publicId) async {
    registrations++;
    return device;
  }

  @override
  Future<void> revoke(String token, String deviceId) async {
    if (offline) throw const IdentityFailure();
  }
}

Future<void> login(AccountController controller) async {
  await controller.begin('synthetic@example.invalid', create: false);
  await controller.confirm('123456');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('secure storage adapter uses the platform secret channel', () async {
    const channel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return call.method == 'read' ? 'synthetic-secret' : null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );
    const store = SecureSessionStore();
    await store.write('synthetic-secret');
    expect(await store.read(), 'synthetic-secret');
    await store.clear();
    expect(calls.map((c) => c.method), ['write', 'read', 'delete']);
    expect((calls.first.arguments as Map)['key'], 'noryva.identity.session.v1');
  });
  test(
    'sign-in and sign-out preserve all local rows and durable workspace owner',
    () async {
      final db = await AppDatabase.memory();
      addTearDown(db.close);
      final store = MemoryStore(), api = FakeApi();
      final controller = AccountController(db, FakeEmail(), api, store);
      addTearDown(controller.dispose);
      final food = (await db.searchFoods('')).first;
      await db.logFood(
        food: food,
        canonicalQuantity: 100,
        servingDescription: '100 g',
        meal: MealType.lunch,
        loggedAt: DateTime.utc(2026, 9, 9),
      );
      final beforeProfile = await db.profile();
      final beforeDiary =
          (await db.customSelect('SELECT * FROM diary_entries').get())
              .map((r) => r.data)
              .toList();
      expect(await db.workspaceIdentity(), isNull);
      await login(controller);
      expect(controller.state.signedIn, isTrue);
      expect((await db.workspaceIdentity())!.accountId, a);
      expect(await db.profile(), beforeProfile);
      expect(
        (await db.customSelect('SELECT * FROM diary_entries').get())
            .map((r) => r.data)
            .toList(),
        beforeDiary,
      );
      expect(store.value, contains('synthetic-access-token'));
      await controller.signOut();
      expect(store.value, isNull);
      expect(
        (await db.customSelect('SELECT * FROM diary_entries').get())
            .map((r) => r.data)
            .toList(),
        beforeDiary,
      );
      expect(controller.state.signedIn, isFalse);
      expect(await db.profile(), beforeProfile);
      expect((await db.workspaceIdentity())!.accountId, a);
      await login(controller);
      expect(controller.state.signedIn, isTrue);
      await controller.signOut();
      api.account = b;
      await login(controller);
      expect(controller.state.signedIn, isFalse);
      expect(controller.state.message, contains('different account'));
      expect(api.registrations, 2);
      expect((await db.workspaceIdentity())!.accountId, a);
      expect(await db.profile(), beforeProfile);
    },
  );
  test(
    'offline sign-out clears secrets; failed secure deletion remains retryable',
    () async {
      final db = await AppDatabase.memory();
      addTearDown(db.close);
      final store = MemoryStore(), api = FakeApi();
      final c = AccountController(db, FakeEmail(), api, store);
      addTearDown(c.dispose);
      await login(c);
      api.offline = true;
      store.failClear = true;
      await c.signOut();
      expect(store.value, isNotNull);
      expect(c.state.message, contains('removal failed'));
      store.failClear = false;
      await c.signOut();
      expect(store.value, isNull);
      expect((await db.workspaceIdentity())!.accountId, a);
    },
  );
  test(
    'session restores only for matching workspace; expiry clears token without owner loss',
    () async {
      final db = await AppDatabase.memory();
      addTearDown(db.close);
      final store = MemoryStore(), api = FakeApi();
      final c = AccountController(db, FakeEmail(), api, store);
      addTearDown(c.dispose);
      await login(c);
      final restored = AccountController(db, FakeEmail(), api, store);
      addTearDown(restored.dispose);
      await restored.restore();
      expect(restored.state.accountId, a);
      final value = jsonDecode(store.value!) as Map<String, dynamic>;
      value['expiresAt'] = DateTime.now()
          .subtract(const Duration(seconds: 1))
          .toIso8601String();
      store.value = jsonEncode(value);
      await restored.restore();
      expect(restored.state.signedIn, isFalse);
      expect(store.value, isNull);
      expect((await db.workspaceIdentity())!.accountId, a);
    },
  );
  test(
    'v3 upgrade and reopen retain profile and workspace binding without raw session data',
    () async {
      final dir = Directory.systemTemp.createTempSync('noryva_identity_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final file = File('${dir.path}/test.sqlite');
      var db = await AppDatabase.open(file: file);
      final before = await db.profile();
      await db.customStatement('DROP TABLE workspace_identity');
      await db.customStatement('PRAGMA user_version=3');
      await db.close();
      db = await AppDatabase.open(file: file);
      expect(await db.profile(), before);
      await db.attachWorkspace(a, device);
      await db.close();
      db = await AppDatabase.open(file: file);
      expect((await db.workspaceIdentity())!.accountId, a);
      expect(await db.profile(), before);
      await expectLater(db.attachWorkspace(b, device), throwsStateError);
      await db.close();
    },
  );
  test(
    'native passwordless client sends only identity challenge data; no password',
    () async {
      final operations = <String>[];
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          'https://api.example.invalid/v1/auth/email',
        );
        final envelope = jsonDecode(request.body) as Map;
        final op = envelope['operation'] as String;
        operations.add(op);
        final body = envelope['body'] as Map;
        expect(body.containsKey('ClientId'), isFalse);
        expect(body.containsKey('Password'), isFalse);
        expect(body.containsKey('diary'), isFalse);
        expect(request.followRedirects, isFalse);
        if (op == 'InitiateAuth') {
          return http.Response(
            jsonEncode({
              'ChallengeName': 'EMAIL_OTP',
              'Session': 'challenge',
              'ChallengeParameters': {'USERNAME': 'synthetic'},
            }),
            200,
          );
        }
        if (op == 'RespondToAuthChallenge') {
          return http.Response(
            jsonEncode({
              'AuthenticationResult': {
                'AccessToken': 'synthetic-token',
                'ExpiresIn': 300,
                'RefreshToken': 'discard-me',
              },
            }),
            200,
          );
        }
        return http.Response('{}', 200);
      });
      final provider = NoryvaEmailIdentity(
        client,
        'https://api.example.invalid',
      );
      await provider.begin('synthetic@example.invalid', create: true);
      expect(await provider.confirm('123456'), isNull);
      final token = await provider.confirm('123456');
      expect(token!.accessToken, 'synthetic-token');
      expect(token.toString(), isNot(contains('synthetic-token')));
      expect(operations, [
        'SignUp',
        'ConfirmSignUp',
        'InitiateAuth',
        'RespondToAuthChallenge',
      ]);
    },
  );
  test(
    'Noryva transport has identity endpoints only and never transmits local records',
    () async {
      final paths = <String>[];
      final api = NoryvaAccountApi(
        MockClient((request) async {
          paths.add(request.url.path);
          final body = jsonDecode(request.body) as Map;
          expect(
            body.keys.every(
              (key) => [
                'devicePublicId',
                'platform',
                'osMajor',
                'appVersion',
              ].contains(key),
            ),
            isTrue,
          );
          expect(request.followRedirects, isFalse);
          return http.Response(
            jsonEncode({
              'accountId': a,
              'deviceId': device,
              'status': 'active',
            }),
            200,
          );
        }),
        'https://api.example.invalid',
        platform: 'android',
        metadata: () async => (osMajor: 16, appVersion: '0.1.0'),
      );
      await api.session('token');
      await api.register('token', device);
      await api.revoke('token', device);
      expect(paths, [
        '/v1/account/session',
        '/v1/devices/register',
        '/v1/devices/$device/revoke',
      ]);
    },
  );
  testWidgets(
    'Me offers optional account; disabled configuration leaves local UI usable',
    (tester) async {
      final db = await AppDatabase.memory();
      addTearDown(db.close);
      final email = FakeEmail()..configured = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            identityProvider.overrideWithValue(email),
            accountApiProvider.overrideWithValue(FakeApi()),
            sessionStoreProvider.overrideWithValue(MemoryStore()),
          ],
          child: const MaterialApp(home: MeScreen()),
        ),
      );
      expect(find.text('Local profile'), findsOneWidget);
      await tester.tap(find.text('Optional account'));
      await tester.pumpAndSettle();
      expect(find.textContaining('not configured'), findsOneWidget);
      expect(find.text('Continue without account'), findsOneWidget);
    },
  );
  testWidgets('optional sign-in and sign-out UI do not replace local profile', (
    tester,
  ) async {
    final db = await AppDatabase.memory();
    addTearDown(db.close);
    final before = await db.profile();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          identityProvider.overrideWithValue(FakeEmail()),
          accountApiProvider.overrideWithValue(FakeApi()),
          sessionStoreProvider.overrideWithValue(MemoryStore()),
        ],
        child: const MaterialApp(home: AccountScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'synthetic@example.invalid',
    );
    await tester.tap(find.text('Sign in with email code'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Email code'),
      '123456',
    );
    await tester.tap(find.text('Confirm code'));
    await tester.pumpAndSettle();
    expect(find.text('Signed in'), findsOneWidget);
    expect(await db.profile(), before);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Signed in'), findsNothing);
    expect(await db.profile(), before);
  });
}
