import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:firebase_core/firebase_core.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/lifecycle_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';
import 'firebase_options.dart';

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

  //all the pages in the app
  final List<Widget> _pages = [
    Center(child: Text('Leaderboard', style: GoogleFonts.huninn(fontSize: 24))),
    Center(child: Text('Scan Tag', style: GoogleFonts.huninn(fontSize: 24))),
    Center(child: Text('My Tags', style: GoogleFonts.huninn(fontSize: 24))),
  ];

  // TODO: Rename and refactor menu items into classes
  void _onItemTapped(int index) {
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

          _pages[_currentIndex],

          if (_currentIndex == 1 && _showRealScanButton)
            Center(
              child: Transform.translate(
                offset: const Offset(0, 96),
                child: AnimatedOpacity(
                  opacity: _showRealScanButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedScale(
                    scale: _showRealScanButton ? 2.5 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: FloatingActionButton(
                      heroTag: 'realScanButton',
                      shape: const CircleBorder(),
                      onPressed: () => _dialogHandler.startTagSearching(
                        context,
                        _tagInteractionHandler,
                      ),
                      child: const Icon(Icons.nfc, size: 32),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.leaderboard, size: 28),
              onPressed: () => _onItemTapped(0),
              color: _currentIndex == 0 ? Colors.teal : Colors.grey,
            ),
            SizedBox(
              width: 40,
            ), //this is a space for the button in the middle of the bottom bar
            IconButton(
              icon: Icon(Icons.style, size: 28),
              onPressed: () => _onItemTapped(2),
              color: _currentIndex == 2 ? Colors.teal : Colors.grey,
            ),
            //possible icons we might wanna use: collections, bookmarks, edit_square, hourglass, label, library books, loyalty, local_offer,
            // map, more_outlined, qr_code, report, sell, sensors, style
          ],
        ),
      ),
      floatingActionButton: _removeScanButton
          ? null
          : IgnorePointer(
              ignoring: !_showScanButton,
              child: MouseRegion(
                onEnter: (_) => setState(() => _scanButtonHovered = true),
                onExit: (_) => setState(() => _scanButtonHovered = false),
                child: AnimatedSlide(
                  offset: _scanButtonPressed
                      ? const Offset(0, -4)
                      : Offset.zero,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  onEnd: () {
                    if (_scanButtonPressed && _showScanButton) {
                      setState(() {
                        _showScanButton = false;
                        _showRealScanButton = true;
                      });

                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (mounted) {
                          setState(() {
                            _removeScanButton = true;
                          });
                        }
                      });
                    }
                  },
                  child: AnimatedScale(
                    // TODO: Use some switch functionality if possible
                    scale: _scanButtonPressed
                        ? 2.5
                        : (_scanButtonHovered ? 1.25 : 1.0),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Opacity(
                      opacity: _showScanButton ? 1.0 : 0.0,
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          setState(() {
                            _scanButtonPressed = true;
                          });
                          _onItemTapped(1);
                        },
                        child: const Icon(Icons.nfc, size: 32),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
