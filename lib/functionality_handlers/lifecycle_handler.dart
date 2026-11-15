import 'package:flutter/material.dart';

import 'nfc_scan_handler.dart';


class LifecycleHandler extends StatefulWidget {
  // Flutter got some wacky notation, but here is the props passable in
  final NfcInteractionHandler _tagStreamHandler;

  // Requiring the named param of handleScan to be included
  const LifecycleHandler({super.key, required this._tagStreamHandler});

  @override
  _LifecycleHandler createState() => _LifecycleHandler();
}

class _LifecycleHandler extends State<LifecycleHandler>
    with WidgetsBindingObserver {
  late NfcInteractionHandler _tagStreamHandler;

  // On the creation of the Main Screen, creates an observer to watch the whole app
  @override
  void initState() {
    // Letting Flutter set up the widget
    super.initState();

    // Passing in the handleScan prop
    _tagStreamHandler = widget._tagStreamHandler;

    // On the creation of the Main Screen, creates an observer to watch the whole app
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
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
      _tagStreamHandler.startSession();
    } else {
      // App is closed, end the NFC session
      _tagStreamHandler.endSession();
    }
  }

  // Only needs to exist hidden within the tree
  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 0);
  }
}
