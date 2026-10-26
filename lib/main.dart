import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'database_functions.dart';

import 'lifecycle_handler.dart';

NFCApp _nfcApp = NFCApp();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String testTag =
    '{"id":"abc123","latitude":42.2917,"longitude":-85.5872,"title":"Test Tag Location","description":"Test tag description goes here","creationTimestamp":"2026-10-26T13:00:00.000"}';
void main() async {
  // Ensuring binding is initialized before the app is ran
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Starting an NFC session
  NfcManager.instance.checkAvailability().then((NfcAvailability avail) {
    // Handling NFC scans
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: _handleTagInfo,
    );

    // Running the app
    runApp(_nfcApp);
  });

  //TODO: the session needs to end at some point... maybe when app is paused/stopped?
}

void _handleTagInfo(NfcTag tag) async {
  // Get the text stored within the tag
  final List<NdefRecord>? nDefRecords = Ndef.from(tag)!.cachedMessage!.records;

  if (nDefRecords != null) {
    // SUCCESS
    String tagID = "";

    // Start reading message at 3 cause NFC adds extra letters
    for (int i = 3; i < nDefRecords[0].payload.length; i++) {
      int uniCode = nDefRecords[0].payload[i];
      tagID += String.fromCharCode(uniCode);
    }

    // TODO: Delete this
    print(tagID);

    // Verify tag is 32 hex digits before looking up
    if (isTagIdFormatValid(tagID)) {
      // TODO: IF in scanning screen
      try {
        final tagData = await getTagById(tagID);
        final context = navigatorKey.currentContext;
        if (context == null) return;
        _showScannedTagDetails(tagData.toJson(), context);
        print(tagData.toJson());
      } on IdNotFoundException catch (e) {
        print(e); // TODO: Display a tag ID not found popup
      }
      // TODO: Display tag information
      // ELSE
      // TODO: Advise the user that they should use the scan tag tab and button
    }
    // Tag ID wasn't valid
    else {
      // TODO: provide popup when invalid scan occurs
    }
  } else {
    // FAILED
  }
}

void _showScannedTagDetails(
  Map<String, dynamic> tagDetails,
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text('Tag Details', style: GoogleFonts.huninn(fontSize: 24)),
        ),
        content: SizedBox(
          width: 300,
          height: 500,
          child: Text(
            'ID: ${tagDetails['id']}, Latitude: ${tagDetails['latitude']}, Longitude: ${tagDetails['longitude']}, Title: ${tagDetails['title']}, Description: ${tagDetails['description']}, Creation Timestamp: ${tagDetails['creationTimestamp']}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      );
    },
  );
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
    navigatorKey: navigatorKey,
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
  bool _currentlyScanning = false;
  bool _displayTagDetails = false;

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
        _showScanButton = true;
        _scanButtonHovered = false;
        _scanButtonPressed = false;
        _removeScanButton = false;
        _showRealScanButton = false;
      }
    });
  }

  void _scanTag() {
    // Provide the UI for the user to see the popup
    setState(() {
      _currentlyScanning = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Currently Scanning'),
            // content: const Text('Scannning...'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the popup
                  _cancelScanning();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _cancelScanning() {
    setState(() {
      _currentlyScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LifecycleHandler(handleScan: _handleTagInfo),
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
