import 'package:flutter/material.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';

// Widget to display info constructed from dialog handler
class StreamedDialog extends StreamBuilder {
  final DialogHandler _dialogHandler;
  final NfcInteractionHandler _tagInteractionHandler;

  StreamedDialog(this._dialogHandler, this._tagInteractionHandler, {super.key})
    : super(
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
      );
}
