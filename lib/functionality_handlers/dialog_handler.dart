import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_tap_app/dataconnect_generated/generated.dart';

import 'nfc_scan_handler.dart';

/// Object that contains all of the states a dialog box can be in
class DialogHandler {
  final DialogOps dialogOps = DialogOps();

  TagResponse? currentlyHeldTag;

  DialogHandler();

  void startTagSearching(
    BuildContext context,
    NfcInteractionHandler tagInteractionHandler,
  ) {
    dialogOps.currentlyScanning = true;
    tagInteractionHandler.scanning = true;

    // Provide the UI for the user to see the popup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (tagInteractionHandler.isSessionActive) {
          return _ScanDialog(
            context: context,
            tagInteractionHandler: tagInteractionHandler,
            dialogOps: dialogOps,
          );
        } else if (kDebugMode) {
          return _DebugScanDialog(
            context: context,
            tagInteractionHandler: tagInteractionHandler,
            textEditingController: TextEditingController(),
          );
        } else {
          return _FailedScanDialog(context: context);
        }
      },
    );
  }

  void showScannedTagDetails(
    BuildContext context,
    NfcInteractionHandler tagInteractionHandler,
  ) {
    TagResponse tagRes = currentlyHeldTag!;

    // Closing the existing popup if it exists
    if (dialogOps.currentlyScanning) {
      Navigator.of(context).pop();
      dialogOps.currentlyScanning = false;
    }

    tagInteractionHandler.scanning = false;

    // The user scanned a tag when they were suppose to
    if (tagRes.tagInfo != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValidTagDialog(
            context: context,
            tagInfo: tagRes.tagInfo as GetTagByIdTag,
          );
        },
      ).then((unusedVal) {
        // Cleaning up when a dialog box is closed
        dialogOps.tagShouldShowDialog = false;
        dialogOps.tagCurrentlyDisplayed = false;
      });
    }
    // Handling all the other invalid popups
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _InvalidTagDialog(
            context: context,
            failMessage: tagRes.message as String,
          );
        },
      ).then((unusedVal) {
        // Cleaning up when a dialog box is closed
        dialogOps.tagShouldShowDialog = false;
        dialogOps.tagCurrentlyDisplayed = false;
      });
    }
  }
}

/// A class for making an singleton object to handle dialog operations
class DialogOps {
  /// Is the dialog currently looking for tags
  bool currentlyScanning = false;

  /// Hasn't shown dialog for current tag
  bool tagShouldShowDialog = true;

  /// Is currently displaying the dialog box
  bool tagCurrentlyDisplayed = false;

  DialogOps();
}

class _ScanDialog extends AlertDialog {
  final BuildContext context;
  final NfcInteractionHandler tagInteractionHandler;
  final DialogOps dialogOps;

  _ScanDialog({
    required this.context,
    required this.tagInteractionHandler,
    required this.dialogOps,
    super.key,
  }) : super(
         title: Center(
           child: Text(
             'Currently Scanning',
             style: GoogleFonts.huninn(fontSize: 24),
           ),
         ),
         // content: const Text('Scannning...'),
         actions: <Widget>[
           TextButton(
             child: Text('Cancel', style: GoogleFonts.huninn(fontSize: 16)),
             onPressed: () {
               Navigator.of(context).pop(); // Closes the popup
               tagInteractionHandler.scanning = false;
               dialogOps.currentlyScanning = false;
             },
           ),
         ],
       );
}

class _DebugScanDialog extends AlertDialog {
  final BuildContext context;
  final NfcInteractionHandler tagInteractionHandler;

  static void _scanText(
    String text,
    NfcInteractionHandler tagInteractionHandler,
  ) {
    tagInteractionHandler.simulateTextNfcScan(text);
  }

  _DebugScanDialog({
    required this.context,
    required this.tagInteractionHandler,
    required TextEditingController textEditingController,
    super.key,
  }) : super(
         title: Center(
           child: Text(
             'Simulating Scanning',
             style: GoogleFonts.huninn(color: Colors.teal, fontSize: 24),
           ),
         ),
         content: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding: EdgeInsets.only(bottom: 12),
                 child: Text(
                   'You are seeing this dialog because NFC is not enabled and you are in debug mode.',
                   style: GoogleFonts.huninn(fontSize: 16),
                 ),
               ),
               TextField(
                 onSubmitted: (text) {
                   _scanText(text, tagInteractionHandler);
                 },
                 controller: textEditingController,
                 decoration: InputDecoration(
                   border: OutlineInputBorder(),
                   hint: Text(
                     'Enter simulated NFC text',
                     style: GoogleFonts.huninn(fontSize: 16),
                   ),
                 ),
               ),
             ],
           ),
         ),
         actions: [
           TextButton(
             onPressed: () {
               _scanText(textEditingController.text, tagInteractionHandler);
             },
             child: Text(
               'Simulate Scan',
               style: GoogleFonts.huninn(fontSize: 16),
             ),
           ),
           TextButton(
             onPressed: () {
               Navigator.of(context).pop();
             },
             child: Text('Close', style: GoogleFonts.huninn(fontSize: 16)),
           ),
         ],
       );
}

class _FailedScanDialog extends AlertDialog {
  final BuildContext context;

  _FailedScanDialog({required this.context, super.key})
    : super(
        title: Center(
          child: Text(
            'Oops!',
            style: GoogleFonts.huninn(color: Colors.teal, fontSize: 24),
          ),
        ),
        content: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: .25,
          child: SingleChildScrollView(
            child: Text(
              'NFC scanning technology appears to be disabled or unavailable on this device! Please enable it in your settings if possible.',
              style: GoogleFonts.huninn(fontSize: 16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: GoogleFonts.huninn(fontSize: 16)),
          ),
        ],
      );
}

class ValidTagDialog extends AlertDialog {
  final BuildContext context;
  final GetTagByIdTag tagInfo;

  ValidTagDialog({required this.context, required this.tagInfo, super.key})
    : super(
        title: Center(
          child: Text(
            tagInfo.title,
            style: GoogleFonts.huninn(color: Colors.teal, fontSize: 24),
          ),
        ),
        content: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: .75,
          child: SingleChildScrollView(
            child: Text(
              'Location: ${tagInfo.latitude}, ${tagInfo.longitude}\n\n${tagInfo.description}',
              style: GoogleFonts.huninn(fontSize: 16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close', style: GoogleFonts.huninn(fontSize: 16)),
          ),
        ],
      );
}

class _InvalidTagDialog extends AlertDialog {
  final BuildContext context;
  final String failMessage;

  _InvalidTagDialog({
    required this.context,
    required this.failMessage,
    super.key,
  }) : super(
         title: Center(
           child: Text(
             'Oops!',
             style: GoogleFonts.huninn(color: Colors.teal, fontSize: 24),
           ),
         ),
         content: FractionallySizedBox(
           widthFactor: 1,
           heightFactor: .25,
           child: SingleChildScrollView(
             child: Text(failMessage, style: GoogleFonts.huninn(fontSize: 16)),
           ),
         ),
         actions: [
           TextButton(
             onPressed: () {
               Navigator.of(context).pop();
             },
             child: Text('Close', style: GoogleFonts.huninn(fontSize: 16)),
           ),
         ],
       );
}
