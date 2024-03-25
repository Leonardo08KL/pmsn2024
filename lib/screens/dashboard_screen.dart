import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/network/sessionid_tmdb.dart';
import 'package:pmsn2024/settings/app_value_notifier.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/500'),
              ),
              accountName: Text('Leonardo Covarrubias Lemus'),
              accountEmail: Text('19031645@itcelaya.edu.mx'),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text("Práctica 1"),
              subtitle: Text("Aqui iria la descripcion si tuviera una XDD"),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text("Mi despensa"),
              subtitle: const Text("Relacion de productos que no voy a usar"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/despensa"),
            ),
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text("Mi despensa 2"),
              subtitle: const Text("Relacion de productos que no voy a usar"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/despensa"),
            ),
            ListTile(
              //Se utiliza para manejar titulos y subtitulos en cada elemento, ademas de tener cosas a los lados
              leading: Icon(Icons.movie),
              title: Text("Moviles app"),
              subtitle: Text("Consulta de peliculas particulares"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                SessionID().getSessionId();
                Navigator.pushNamed(context, "/movies");
              },
            ),
            ListTile(
              //Se utiliza para manejar titulos y subtitulos en cada elemento, ademas de tener cosas a los lados
              leading: Icon(Icons.movie),
              title: Text("Session"),
              subtitle: Text("Consulta de peliculas particulares"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                SessionID().getSessionId();
                Navigator.pushNamed(context, "/sesion");
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Salir"),
              subtitle: const Text("Hasta luego"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100, left: 100),
              child: DayNightSwitcher(
                isDarkModeEnabled: AppValueNotifier.banTheme.value,
                onStateChanged: (isDarkModeEnabled) {
                  AppValueNotifier.banTheme.value = isDarkModeEnabled;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
