import 'package:flutter/material.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';

/// Widget to display info constructed from dialog handler
class StreamedDialog extends StreamBuilder {

  StreamedDialog(DialogHandler dialogHandler, NfcInteractionHandler tagInteractionHandler, {super.key})
    : super(
        stream: tagInteractionHandler.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.connectionState != ConnectionState.none) {
            if (dialogHandler.currentlyHeldTag != snapshot.data) {
              dialogHandler.dialogOps.tagShouldShowDialog = true;
              dialogHandler.currentlyHeldTag = snapshot.data;
            }

            if (dialogHandler.dialogOps.tagShouldShowDialog &&
                !dialogHandler.dialogOps.tagCurrentlyDisplayed) {
              dialogHandler.dialogOps.tagCurrentlyDisplayed = true;
              // Due to the terrible nature of ShowDialog, scheduling a dialog popup
              // after the current frame is drawn
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dialogHandler.showScannedTagDetails(
                  context,
                  tagInteractionHandler,
                );
              });
            }
          }
          // Satisfying the Flutter Build conditions
          return Opacity(opacity: 0);
        },
      );
}
