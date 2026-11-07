import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_core/firebase_core.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/lifecycle_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';

import 'local_database/database.dart';

import 'streamed_dialog.dart';
import 'navigation_bar.dart';
import 'scan_button.dart';
import 'map_display.dart';

import 'firebase_options.dart';

NFCApp _nfcApp = NFCApp();

// Accessing the systems local database
final AppDatabase database = AppDatabase();
Stream<List<TagTableData>>? persistentStorageOutput;

// One stop shop for accessing tag info
final NfcInteractionHandler _tagInteractionHandler = NfcInteractionHandler(database);

void main() async {
  // Ensuring binding is initialized before the app is ran
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup a stream to watch
  persistentStorageOutput = await database.getStream();

  // Start an NFC session
  await NfcManager.instance.checkAvailability();
  _tagInteractionHandler.startSession();

  // Run the app
  runApp(_nfcApp);
}

class NFCApp extends StatelessWidget {
  NFCApp({super.key});
  final MaterialApp _materialApp = MaterialApp(
    title: 'NFC App',
    //light mode
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.light,
      ),
    ),
    //dark mode
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
    ),
    themeMode: ThemeMode.system,
    home: const MainScreen(),
  );

  @override
  Widget build(BuildContext context) {
    return _materialApp;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final ScanState _scanState = ScanState();
  final DialogHandler _dialogHandler = DialogHandler();

  // TODO: Rename and refactor menu items into classes
  void _changePage(int index) {
    setState(() {
      _currentIndex = index; //the index of what page the user is looking at
      if (_currentIndex != 1) {
        _scanState.setToShowState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          StreamedDialog(_dialogHandler, _tagInteractionHandler),

          LifecycleHandler(tagStreamHandler: _tagInteractionHandler),

          MainNavigationBar.navigation_pages[_currentIndex],

          if (_currentIndex == 1 && _scanState.showRealScanButton)
            RealScanButton(
              _scanState,
              _dialogHandler,
              _tagInteractionHandler,
              context,
            ),
          
          if(_currentIndex == 0)
            MapPlaceHolder(persistentStorageOutput!)
        ],
      ),
      bottomNavigationBar: MainNavigationBar(_currentIndex, _changePage),
      floatingActionButton: _scanState.removeScanButton
          ? null
          : BottomScanButton(_scanState, mounted, setState, _changePage),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
