import 'package:flutter/material.dart';

import 'functionality_handlers/dialog_handler.dart';
import 'functionality_handlers/nfc_scan_handler.dart';
import 'functionality_handlers/navigation_handler.dart';

class RealScanButton extends Center {
  RealScanButton(
    ScanState scanState,
    DialogHandler dialogHandler,
    NfcInteractionHandler tagInteractionHandler,
    BuildContext context,
  ) : super(
        child: Transform.translate(
          offset: const Offset(0, 96),
          child: AnimatedOpacity(
            opacity: scanState.showRealScanButton ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: scanState.showRealScanButton ? 2.5 : 0.5,
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

class BottomScanButton extends IgnorePointer {
  BottomScanButton(
    void Function(void Function()) setState,
    ScanState scanState,
    bool mounted,
    NavigationHandler navigationHandler,
  ) : super(
        ignoring: !scanState.showScanButton,
        child: MouseRegion(
          onEnter: (_) => setState(() => scanState.scanButtonHovered = true),
          onExit: (_) => setState(() => scanState.scanButtonHovered = false),
          child: AnimatedSlide(
            offset: scanState.scanButtonPressed ? const Offset(0, -4) : Offset.zero,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            onEnd: () {
              if (scanState.scanButtonPressed && scanState.showScanButton) {
                setState(() {
                  scanState.showScanButton = false;
                  scanState.showRealScanButton = true;
                });

                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    setState(() {
                      scanState.removeScanButton = true;
                    });
                  }
                });
              }
            },
            child: AnimatedScale(
              // TODO: Use some switch functionality if possible
              scale: scanState.scanButtonPressed ? 2.5 : (scanState.scanButtonHovered ? 1.25 : 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Opacity(
                opacity: scanState.showScanButton ? 1.0 : 0.0,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    setState(() {
                      scanState.scanButtonPressed = true;
                    });
                    navigationHandler.currentPage = NavigationPage.scan;
                  },
                  child: const Icon(Icons.nfc, size: 32),
                ),
              ),
            ),
          ),
        ),
      );
}

class ScanState {
  bool scanButtonHovered = false;
  bool scanButtonPressed = false;
  bool showScanButton = true;
  bool removeScanButton = false;
  bool showRealScanButton = false;

  void showBottomButton() {
    showScanButton = true;
    scanButtonHovered = false;
    scanButtonPressed = false;
    removeScanButton = false;
    showRealScanButton = false;
  }
}
