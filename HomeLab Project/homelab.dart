import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'WeatherApp/weatherwidget.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const Homelab());
}

class Homelab extends StatelessWidget {
  const Homelab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Homelab App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 23, 23, 23)),
        ),
        home: const HomelabInit(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  void openSpotify() async {
          try {
            await LaunchApp.openApp(
              androidPackageName: 'com.spotify.music',
              openStore: false,
            );
          } catch (e) {
            print('No se pudo abrir Spotify: $e');
          }
  }
  
}

class HomelabInit extends StatefulWidget {
  const HomelabInit({super.key});

  @override
  State<HomelabInit> createState() => _HomelabInitState();
}

class _HomelabInitState extends State<HomelabInit> {
  int _selectedIndex = 0;

  void _onNavigationRailDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const MyApp(); // open Weather app
        break;
      case 1:
      Provider.of<MyAppState>(context, listen: false).openSpotify();
        page = Container(); // Open Spotify
        break;
         // Your Weatherapp widget
      default:
        throw UnimplementedError('No widget for $_selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              backgroundColor: const Color.fromARGB(255, 46, 46, 46),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onNavigationRailDestinationSelected,
              destinations: const [

                NavigationRailDestination(
                  icon: Icon(Icons.home, 
                  color: Color.fromARGB(255, 255, 255, 255),),
                  selectedIcon: Icon(Icons.home, 
                    color: Color.fromARGB(255, 0, 0, 0),),
                  label: Text('Home'),
                ),

                NavigationRailDestination(
                  icon: Icon(Icons.music_note, 
                  color: Color.fromARGB(255, 255, 255, 255),),
                  selectedIcon: Icon(Icons.music_note, 
                    color: Color.fromARGB(255, 0, 0, 0),),
                  label: Text('Home'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 23, 23, 23),
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}