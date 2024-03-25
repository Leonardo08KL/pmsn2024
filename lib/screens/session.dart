import 'package:flutter/material.dart';
import 'package:pmsn2024/model/session_tmdb_model.dart';

class Sesion extends StatelessWidget {
  const Sesion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? sessionId = SessionManager().getSessionId();
    return Container(
      child: Text("El sesionID es: $sessionId"),
    );
  }
}
