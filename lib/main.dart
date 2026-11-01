import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nfc_tap_app/bottom_scan_button.dart';
import 'package:nfc_tap_app/navigation_bar.dart';
import 'package:nfc_tap_app/real_scan_button.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/lifecycle_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';
import 'firebase_options.dart';
import 'navigation_pages.dart';

NFCApp _nfcApp = NFCApp();

// One stop shop for accessing tag info
final NfcInteractionHandler _tagInteractionHandler = NfcInteractionHandler();

void main() async {
  // Ensuring binding is initialized before the app is ran
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
  bool _scanButtonHovered = false;
  bool _scanButtonPressed = false;
  bool _showScanButton = true;
  bool _removeScanButton = false;
  bool _showRealScanButton = false;
  DialogHandler _dialogHandler = DialogHandler();

  // TODO: Rename and refactor menu items into classes
  void _changePage(int index) {
    setState(() {
      _currentIndex = index; //the index of what page the user is looking at
      if (_currentIndex != 1) {
        _showScanButton = true;
        _scanButtonHovered = false;
        _scanButtonPressed = false;
        _removeScanButton = false;
        _showRealScanButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder(
            stream: _tagInteractionHandler.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting &&
                  snapshot.connectionState != ConnectionState.none) {
                if (_dialogHandler.currentlyHeldTag != snapshot.data) {
                  _dialogHandler.shouldShowDialog = true;
                  _dialogHandler.currentlyHeldTag = snapshot.data;
                }

                if (_dialogHandler.shouldShowDialog &&
                    !_dialogHandler.currentlyDisplayed) {
                  _dialogHandler.currentlyDisplayed = true;
                  // Due to the terrible nature of ShowDialog, scheduling a dialog popup
                  // after the current frame is drawn
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _dialogHandler.showScannedTagDetails(
                      context,
                      _tagInteractionHandler,
                    );
                  });
                }
              }
              // Satisfying the Flutter Build conditions
              return Opacity(opacity: 0);
            },
          ),

          LifecycleHandler(tagStreamHandler: _tagInteractionHandler),

          pages[_currentIndex],

          if (_currentIndex == 1 && _showRealScanButton)
            RealScanButton(
              _showRealScanButton,
              _dialogHandler,
              _tagInteractionHandler,
              context,
            ),
        ],
      ),
      bottomNavigationBar: MainNavigationBar(_currentIndex, _changePage),
      floatingActionButton: _removeScanButton
          ? null
          : BottomScanButton(
              _showScanButton,
              _scanButtonHovered,
              _showRealScanButton,
              _scanButtonPressed,
              _removeScanButton,
              mounted,
              setState,
              _changePage,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
