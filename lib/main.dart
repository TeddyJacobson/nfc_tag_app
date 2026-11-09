import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/lifecycle_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';
import 'functionality_handlers/navigation_handler.dart';

import 'local_database/database.dart';

import 'streamed_dialog.dart';
import 'navigation_bar.dart';
import 'scan_button.dart';
import 'map_display.dart';

import 'firebase_options.dart';

// Accessing the systems local database
final AppDatabase database = AppDatabase();
Stream<List<TagTableData>>? _persistentStorageOutput;

// One stop shop for accessing tag info
final NfcInteractionHandler _tagInteractionHandler = NfcInteractionHandler(
  database,
);

void main() async {
  // Ensuring binding is initialized before the app is ran
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup a stream to watch
  _persistentStorageOutput = await database.getStream();

  // Start an NFC session
  await _tagInteractionHandler.startSession();

  // Run the app
  runApp(NFCApp());
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
  final ScanState _scanState = ScanState();
  final DialogHandler _dialogHandler = DialogHandler();
  late final NavigationHandler _navigationHandler;

  // Use constructor to initialize _navigationHandler with _scanState
  _MainScreenState() {
    _navigationHandler = NavigationHandler(
      setState,
      _scanState,
      _persistentStorageOutput!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          StreamedDialog(_dialogHandler, _tagInteractionHandler),

          LifecycleHandler(tagStreamHandler: _tagInteractionHandler),

          _navigationHandler.pageWidget,

          if (_navigationHandler.currentPage == NavigationPage.scan &&
              _scanState.showRealScanButton)
            RealScanButton(
              _scanState,
              _dialogHandler,
              _tagInteractionHandler,
              context,
            ),
        ],
      ),
      bottomNavigationBar: MainNavigationBar(_navigationHandler),
      floatingActionButton: _scanState.removeScanButton
          ? null
          : BottomScanButton(setState, _scanState, mounted, _navigationHandler),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
