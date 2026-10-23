import 'package:flutter/material.dart';

import 'package:nfc_manager/nfc_manager.dart';


class LifecycleHandler extends StatefulWidget {
  // Flutter got some wacky notation, but here is the props passable in
  final Function(NfcTag tag) _handleScan;

  // Requiring the named param of handleScan to be included
  const LifecycleHandler({super.key, required this._handleScan});

  _LifecycleHandler createState() => _LifecycleHandler();
}

class _LifecycleHandler extends State<LifecycleHandler>
    with WidgetsBindingObserver {
  late Function(NfcTag tag) _handleScan;

  // On the creation of the Main Screen, creates an observer to watch the whole app
  @override
  void initState() {
    // Letting Flutter set up the widget
    super.initState();

    // Passing in the handleScan prop
    _handleScan = widget._handleScan;

    // On the creation of the Main Screen, creates an observer to watch the whole app
    WidgetsBinding.instance.addObserver(this);

    //TODO: Remove this
    print("Initialized the observer");
  }

  @override
  void dispose() {
    //TODO: Removed this
    print("Removed the observer");

    // Removing the lifecyle observer to avoid memory leaks
    // Shouldn't be relevant since the lifecycle widget will 
    // remain in the tree till complete app termination.
    WidgetsBinding.instance.removeObserver(this);

    // Letting Flutter do typical widget disposal
    super.dispose();
  }

  // Handling changes in the app lifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      //TODO: Removed this
      print("Start session");
      // App was opened, start a new NFC session
      NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        onDiscovered: _handleScan,
      );
    } else {
      //TODO: Removed this
      print("End session");
      // App is closed, end the NFC session
      NfcManager.instance.stopSession();
    }
  }

  // Only needs to exist hidden within the tree
  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 0);
  }
}
