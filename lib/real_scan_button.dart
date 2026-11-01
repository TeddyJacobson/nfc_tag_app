import 'package:flutter/material.dart';
import 'package:nfc_tap_app/functionality_handlers/dialog_handler.dart';
import 'package:nfc_tap_app/functionality_handlers/nfc_scan_handler.dart';

class RealScanButton extends Center {
  RealScanButton(
    bool showRealScanButton,
    DialogHandler dialogHandler,
    NfcInteractionHandler tagInteractionHandler,
    BuildContext context,
  ) : super(
        child: Transform.translate(
          offset: const Offset(0, 96),
          child: AnimatedOpacity(
            opacity: showRealScanButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: showRealScanButton ? 2.5 : 0.5,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: FloatingActionButton(
                heroTag: 'realScanButton',
                shape: const CircleBorder(),
                onPressed: () => dialogHandler.startTagSearching(
                  context,
                  tagInteractionHandler,
                ),
                child: const Icon(Icons.nfc, size: 32),
              ),
            ),
          ),
        ),
      );
}
