import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';

// Tracking the availability of the NFC
bool isNFCAvailable = false;

void main() {
  // Ensuring binding is initialized before the app is ran
  // (idk what this actually does: StackOverflow just said it fixed binding errors I was getting)
  WidgetsFlutterBinding.ensureInitialized();

  // Ensuring the device works with NFC
  NfcManager.instance.checkAvailability().then((NfcAvailability avail) {
    if (avail == NfcAvailability.enabled) {
      isNFCAvailable = true;
    } else {
      print("failed to access NFC");
    }
  });

  // Creating the root Widget
  runApp(NFCApp());
}

class NFCApp extends StatelessWidget {
  const NFCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  //all the pages in the app
  final List<Widget> _pages = [
    Center(child: Text('Leaderboard', style: GoogleFonts.huninn(fontSize: 24))),
    Center(child: Text('Scan Tag', style: GoogleFonts.huninn(fontSize: 24))),
    Center(child: Text('My Tags', style: GoogleFonts.huninn(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; //the index of what page the user is looking at
      if (_currentIndex != 1) {
        _scanButtonHovered = false;
        _scanButtonPressed = false;
        _showScanButton = true;
        _removeScanButton = false;
        _showRealScanButton = false;
      }
    });
  }

  // TODO: the following 3 methods should be placed in their own file as the NFC pipeline

  // Handles end user scan of an NFC tag
  void _scanTag() async {
    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
      }, 
      onDiscovered: (NfcTag tag) async {
        print(tag);

        _verifyTag();

        // Stop the session when no longer needed.
        await NfcManager.instance.stopSession();
      },
    );
  }

  // Verifies that the NFC is in the DB
  void _verifyTag() async {
    // STUB
  }

  // Displays a verified and scanned NFC tag
  void _displayTag() {
    // STUB
    // Idk, there gotta be some way to pass a widget back into the widget tree
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
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
                      onPressed: () => _scanTag(),
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
            ),
            SizedBox(
              width: 40,
            ), //this is a space for the button in the middle of the bottom bar
            IconButton(
              icon: Icon(Icons.style, size: 28),
              onPressed: () => _onItemTapped(2),
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
