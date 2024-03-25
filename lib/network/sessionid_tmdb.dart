import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pmsn2024/model/session_tmdb_model.dart';

class SessionID {
  final String apiKey = 'ffd8be5351749ce48cc2865081436b30';
  final String username = 'LeonardoKL';
  final String password = '12345';
  SessionManager sessionManager = SessionManager();

  String? sessionId;

  Future<void> getSessionId() async {
    final responseToken = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/authentication/token/new?api_key=$apiKey'));
    final tokenJson = json.decode(responseToken.body);
    final String requestToken = tokenJson['request_token'];

    final responseLogin = await http.post(
      Uri.parse(
          'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey'),
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );
    final loginJson = json.decode(responseLogin.body);
    final bool? loginSuccess = loginJson['success'];

    if (loginSuccess == true) {
      final responseSession = await http.post(
        Uri.parse(
            'https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey'),
        body: {
          'request_token': requestToken,
        },
      );
      final sessionJson = json.decode(responseSession.body);
      sessionId = sessionJson['session_id'];
      sessionManager.setSessionId(sessionId!);
    }
  }
}
