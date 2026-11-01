import 'package:flutter/material.dart';

class BottomScanButton extends IgnorePointer {
  BottomScanButton(
    bool showScanButton,
    bool scanButtonHovered,
    bool showRealScanButton,
    bool scanButtonPressed,
    bool removeScanButton,
    bool mounted,
    void Function(void Function()) setState,
    void Function(int index) changePage,
  ) : super(
        ignoring: !showScanButton,
        child: MouseRegion(
          onEnter: (_) => setState(() => scanButtonHovered = true),
          onExit: (_) => setState(() => scanButtonHovered = false),
          child: AnimatedSlide(
            offset: scanButtonPressed ? const Offset(0, -4) : Offset.zero,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            onEnd: () {
              if (scanButtonPressed && showScanButton) {
                setState(() {
                  showScanButton = false;
                  showRealScanButton = true;
                });

                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    setState(() {
                      removeScanButton = true;
                    });
                  }
                });
              }
            },
            child: AnimatedScale(
              // TODO: Use some switch functionality if possible
              scale: scanButtonPressed ? 2.5 : (scanButtonHovered ? 1.25 : 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Opacity(
                opacity: showScanButton ? 1.0 : 0.0,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    setState(() {
                      scanButtonPressed = true;
                    });
                    changePage(1);
                  },
                  child: const Icon(Icons.nfc, size: 32),
                ),
              ),
            ),
          ),
        ),
      );
}
