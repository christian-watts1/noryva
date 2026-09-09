import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import 'identity_client.dart';

abstract interface class SessionStore {
  Future<String?> read();
  Future<void> write(String value);
  Future<void> clear();
}

class SecureSessionStore implements SessionStore {
  const SecureSessionStore();
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  static const _key = 'noryva.identity.session.v1';
  @override
  Future<String?> read() => _storage.read(key: _key);
  @override
  Future<void> write(String value) => _storage.write(key: _key, value: value);
  @override
  Future<void> clear() => _storage.delete(key: _key);
}

class AccountState {
  const AccountState({
    this.accountId,
    this.deviceId,
    this.busy = false,
    this.message,
    this.challenge = false,
  });
  final String? accountId, deviceId, message;
  final bool busy, challenge;
  bool get signedIn => accountId != null;
}

final identityProvider = Provider<EmailIdentityProvider>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return NoryvaEmailIdentity(
    client,
    const String.fromEnvironment('NORYVA_API_URL'),
  );
});
final accountApiProvider = Provider<AccountApi>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return NoryvaAccountApi(
    client,
    const String.fromEnvironment('NORYVA_API_URL'),
    platform: Platform.isIOS ? 'ios' : 'android',
    metadata: () async {
      final result = await const MethodChannel(
        'noryva/identity_metadata',
      ).invokeMapMethod<String, dynamic>('get');
      if (result?['osMajor'] is! int || result?['appVersion'] is! String) {
        throw const IdentityFailure();
      }
      return (
        osMajor: result!['osMajor'] as int,
        appVersion: result['appVersion'] as String,
      );
    },
  );
});
final sessionStoreProvider = Provider<SessionStore>(
  (_) => const SecureSessionStore(),
);
final accountControllerProvider =
    StateNotifierProvider<AccountController, AccountState>(
      (ref) => AccountController(
        ref.read(databaseProvider),
        ref.read(identityProvider),
        ref.read(accountApiProvider),
        ref.read(sessionStoreProvider),
      ),
    );

class AccountController extends StateNotifier<AccountState> {
  AccountController(this.database, this.identity, this.api, this.store)
    : super(const AccountState());
  final AppDatabase database;
  final EmailIdentityProvider identity;
  final AccountApi api;
  final SessionStore store;
  LoginToken? _token;
  bool get configured => identity.configured && api.configured;
  Future<void> restore() async {
    if (state.busy) return;
    state = const AccountState(busy: true);
    try {
      final raw = await store.read();
      if (raw == null) {
        state = const AccountState();
        return;
      }
      final value = jsonDecode(raw) as Map<String, dynamic>;
      final workspace = await database.workspaceIdentity();
      final expiry = DateTime.parse(value['expiresAt'] as String);
      if (workspace == null ||
          workspace.accountId != value['accountId'] ||
          !expiry.isAfter(DateTime.now())) {
        await store.clear();
        state = const AccountState();
        return;
      }
      _token = LoginToken(value['accessToken'] as String, expiry);
      state = AccountState(
        accountId: workspace.accountId,
        deviceId: value['deviceId'] as String,
        message: 'Session saved on this device. No backup or sync is active.',
      );
    } catch (_) {
      _token = null;
      state = const AccountState(
        message: 'Account storage is unavailable. Local tracking still works.',
      );
    }
  }

  Future<void> begin(String email, {required bool create}) async {
    if (state.busy || state.signedIn) return;
    if (!configured) {
      state = const AccountState(
        message:
            'Account sign-in is not configured in this build. You can keep using Noryva without an account.',
      );
      return;
    }
    state = const AccountState(busy: true);
    try {
      await identity.begin(email, create: create);
      state = const AccountState(
        challenge: true,
        message:
            'If this account action is available, enter the code sent to your mailbox.',
      );
    } catch (_) {
      state = const AccountState(
        message: 'Unable to continue. Check your details or try again later.',
      );
    }
  }

  Future<void> confirm(String code) async {
    if (state.busy || !state.challenge) return;
    state = const AccountState(busy: true, challenge: true);
    try {
      final token = await identity.confirm(code);
      if (token == null) {
        state = const AccountState(
          challenge: true,
          message: 'Email confirmed. Enter the new sign-in code.',
        );
        return;
      }
      final accountId = await api.session(token.accessToken);
      final workspace = await database.workspaceIdentity();
      if (workspace != null && workspace.accountId != accountId) {
        await store.clear();
        _token = null;
        state = const AccountState(
          message:
              'This local workspace is attached to a different account. Sign in with that account. Switching or merging is not available.',
        );
        return;
      }
      final publicId = workspace?.devicePublicId ?? const Uuid().v4();
      // Persist the owner before storing a session. Partial failure cannot reassign it.
      await database.attachWorkspace(accountId, publicId);
      final deviceId = await api.register(token.accessToken, publicId);
      await store.write(
        jsonEncode({
          'accountId': accountId,
          'deviceId': deviceId,
          'accessToken': token.accessToken,
          'expiresAt': token.expiresAt.toIso8601String(),
        }),
      );
      _token = token;
      state = AccountState(
        accountId: accountId,
        deviceId: deviceId,
        message:
            'Signed in. Your profile and diary have not been uploaded. Backup and sync are off.',
      );
    } catch (_) {
      _token = null;
      state = const AccountState(
        message: 'Unable to sign in safely. Local data has not changed.',
      );
    }
  }

  Future<void> signOut() async {
    if (state.busy) return;
    final deviceId = state.deviceId;
    final token = _token;
    state = AccountState(
      accountId: state.accountId,
      deviceId: deviceId,
      busy: true,
    );
    bool revoked = false;
    try {
      if (token != null && deviceId != null) {
        await api.revoke(token.accessToken, deviceId);
        revoked = true;
      }
    } catch (_) {
      /* offline sign-out still clears local session */
    }
    try {
      await store.clear();
      _token = null;
      state = AccountState(
        message: revoked
            ? 'Signed out. Local profile and diary retained. Other devices need fresh sign-in.'
            : 'Signed out locally. Local profile and diary retained. Remote revocation could not be confirmed.',
      );
    } catch (_) {
      _token = null;
      state = AccountState(
        accountId: state.accountId,
        deviceId: deviceId,
        message:
            'Secure session removal failed. Retry sign-out before sharing this device.',
      );
    }
  }
}
