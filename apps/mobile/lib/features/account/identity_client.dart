import 'dart:convert';
import 'package:http/http.dart' as http;

class IdentityFailure implements Exception {
  const IdentityFailure();
  @override
  String toString() => 'Account action unavailable';
}

class LoginToken {
  const LoginToken(this.accessToken, this.expiresAt);
  final String accessToken;
  final DateTime expiresAt;
  @override
  String toString() => 'LoginToken(redacted)';
}

abstract interface class EmailIdentityProvider {
  bool get configured;
  Future<void> begin(String email, {required bool create});
  Future<LoginToken?> confirm(String code);
}

// Noryva proxies the bounded native Cognito email flow; no direct AWS calls.
class NoryvaEmailIdentity implements EmailIdentityProvider {
  NoryvaEmailIdentity(this.client, this.baseUrl);
  final http.Client client;
  final String baseUrl;
  String? _email, _session, _username;
  bool _signup = false;
  @override
  bool get configured =>
      Uri.tryParse(baseUrl)?.scheme == 'https' &&
      Uri.tryParse(baseUrl)?.host.isNotEmpty == true;
  Future<Map<String, dynamic>> _call(
    String operation,
    Map<String, dynamic> body,
  ) async {
    if (!configured) throw const IdentityFailure();
    try {
      final request = http.Request('POST', Uri.parse('$baseUrl/v1/auth/email'))
        ..followRedirects = false
        ..headers.addAll({'content-type': 'application/json'})
        ..body = jsonEncode({'operation': operation, 'body': body});
      final response = await client
          .send(request)
          .timeout(const Duration(seconds: 10));
      final bytes = await response.stream.toBytes().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200 || bytes.length > 32768) {
        throw const IdentityFailure();
      }
      return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    } catch (_) {
      throw const IdentityFailure();
    }
  }

  @override
  Future<void> begin(String email, {required bool create}) async {
    if (email.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      throw const IdentityFailure();
    }
    _email = email;
    _signup = create;
    _session = null;
    _username = null;
    if (create) {
      await _call('SignUp', {
        'Username': email,
        'UserAttributes': [
          {'Name': 'email', 'Value': email},
        ],
      });
    } else {
      final result = await _call('InitiateAuth', {
        'AuthFlow': 'USER_AUTH',
        'AuthParameters': {
          'USERNAME': email,
          'PREFERRED_CHALLENGE': 'EMAIL_OTP',
        },
      });
      if (result['ChallengeName'] != 'EMAIL_OTP') throw const IdentityFailure();
      _session = result['Session'] as String?;
      _username =
          (result['ChallengeParameters'] as Map?)?['USERNAME'] as String? ??
          email;
      if (_session == null) throw const IdentityFailure();
    }
  }

  @override
  Future<LoginToken?> confirm(String code) async {
    if (!RegExp(r'^\d{6}$').hasMatch(code) || _email == null) {
      throw const IdentityFailure();
    }
    if (_signup) {
      await _call('ConfirmSignUp', {
        'Username': _email,
        'ConfirmationCode': code,
      });
      await begin(_email!, create: false);
      return null; // Sign-up confirmation is followed by a separate sign-in OTP.
    }
    final result = await _call('RespondToAuthChallenge', {
      'ChallengeName': 'EMAIL_OTP',
      'Session': _session,
      'ChallengeResponses': {'USERNAME': _username, 'EMAIL_OTP_CODE': code},
    });
    final auth = result['AuthenticationResult'] as Map?;
    if (auth?['AccessToken'] is! String || auth?['ExpiresIn'] is! int) {
      throw const IdentityFailure();
    }
    final seconds = auth!['ExpiresIn'] as int;
    if (seconds < 1 || seconds > 3600) throw const IdentityFailure();
    final token = LoginToken(
      auth['AccessToken'] as String,
      DateTime.now().toUtc().add(Duration(seconds: seconds)),
    );
    // No refresh/id tokens retained; fresh email verification is required on expiry.
    _email = null;
    _username = null;
    _session = null;
    return token;
  }
}

abstract interface class AccountApi {
  bool get configured;
  Future<String> session(String token);
  Future<String> register(String token, String publicId);
  Future<void> revoke(String token, String deviceId);
}

class NoryvaAccountApi implements AccountApi {
  NoryvaAccountApi(
    this.client,
    this.baseUrl, {
    required this.platform,
    required this.metadata,
  });
  final http.Client client;
  final String baseUrl, platform;
  final Future<({int osMajor, String appVersion})> Function() metadata;
  @override
  bool get configured =>
      Uri.tryParse(baseUrl)?.scheme == 'https' &&
      Uri.tryParse(baseUrl)?.host.isNotEmpty == true;
  Future<Map<String, dynamic>> _post(
    String path,
    String token,
    Map<String, dynamic> body, {
    String? device,
  }) async {
    if (!configured) throw const IdentityFailure();
    try {
      final request = http.Request('POST', Uri.parse('$baseUrl$path'))
        ..followRedirects = false
        ..headers.addAll({
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
          'x-noryva-device': ?device,
        })
        ..body = jsonEncode(body);
      final response = await client
          .send(request)
          .timeout(const Duration(seconds: 10));
      final bytes = await response.stream.toBytes().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200 || bytes.length > 16384) {
        throw const IdentityFailure();
      }
      return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    } catch (_) {
      throw const IdentityFailure();
    }
  }

  String _id(Object? value) {
    if (value is! String ||
        !RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ).hasMatch(value)) {
      throw const IdentityFailure();
    }
    return value;
  }

  @override
  Future<String> session(String token) async =>
      _id((await _post('/v1/account/session', token, {}))['accountId']);
  @override
  Future<String> register(String token, String publicId) async {
    final info = await metadata();
    return _id(
      (await _post('/v1/devices/register', token, {
        'devicePublicId': publicId,
        'platform': platform,
        'osMajor': info.osMajor,
        'appVersion': info.appVersion,
      }))['deviceId'],
    );
  }

  @override
  Future<void> revoke(String token, String deviceId) async {
    await _post(
      '/v1/devices/${_id(deviceId)}/revoke',
      token,
      {},
      device: deviceId,
    );
  }
}
