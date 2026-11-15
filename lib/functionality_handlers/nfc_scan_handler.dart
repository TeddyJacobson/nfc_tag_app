import 'dart:async';
import 'dart:developer';

import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

import '/dataconnect_generated/generated.dart';
import '/local_database/database.dart';

import '../firebase_functions.dart';

const String _invalidScan =
    "Looks like you just tried to scan an NFC tag that isn't used for the K Scavenger Hunt... Please close the app if you want to use a tag for something else!";
const String _notScanning =
    "Looks like you just tried to scan a valid NFC tag... Please press the NFC search button in the center of the navigation bar below!";

// A class for controlling the operations of NFC scans
class NfcInteractionHandler {
  // Stream handling
  final StreamController<TagResponse> controller =
      StreamController<TagResponse>();
  Stream<TagResponse> get stream => controller.stream;

  bool isSessionActive = false;
  bool scanning = false;

  // Setting up for NFC interaction with a systems local database
  final AppDatabase systemDatabase;
  NfcInteractionHandler(this.systemDatabase);

  void updateNFCStream(NfcTag tag) async {
    TagResponse response = await getTagInfo(tag);
    if (response.tagInfo == null && response.message == null) {
      // Things went all wrong. Freak out.
    } else {
      // Add the valid tag response
      controller.sink.add(response);
    }
  }

  void simulateTextNfcScan(String text) async {
    TagResponse response = await _getTagResponseById(text);
    if (response.tagInfo == null && response.message == null) {
      // Things went all wrong. Freak out.
    } else {
      // Add the valid tag response
      controller.sink.add(response);
    }
  }

  // TODO: Set an instance variable that tracks whether a session is active
  /// Start scanning for NFC tags
  Future<void> startSession() async {
    NfcAvailability nfcAvailability = await NfcManager.instance
        .checkAvailability();

    if (nfcAvailability == NfcAvailability.enabled) {
      print("NFC session begun");
      NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        onDiscovered: updateNFCStream,
      );
      isSessionActive = true;
    } else {
      log(
        'NFC interaction is not enabled. Availability: $nfcAvailability.',
        level: 900, // Level 900 is warning; ideally we would use package:logging in production code
      );
    }
  }

  /// Stop scanning for NFC tags
  void endSession() {
    print("NFC session ended");
    NfcManager.instance.stopSession();
  }

  /*
  Takes a tag and returns what a dialogue box should say about it.
  There are four possible response, represented by TagResponse:
    1. The tag is legal and the scan button was pressed = Scanned tag data, null.
    2. The tag isn't legal and the scan button was pressed = Null, message explaining issue.
    3. The tag is legal and the scan button wasn't pressed = Null, message explaining issue.
    4. The tag isn't legal and the scan button wasn't pressed = Null, message explaining issue.
*/
  Future<TagResponse> getTagInfo(NfcTag tag) async {
    // Getting the exchange format info if provided
    
    final Ndef? tagNDEF = Ndef.from(tag);

    if (tagNDEF != null && tagNDEF.cachedMessage != null) {
      // SUCCESS
      // Get the text stored within the tag
      final List<NdefRecord> nDefRecords = tagNDEF.cachedMessage!.records;
      String tagId = "";

      // Start reading message at 3 cause NFC adds extra letters
      for (int i = 3; i < nDefRecords[0].payload.length; i++) {
        int uniCode = nDefRecords[0].payload[i];
        tagId += String.fromCharCode(uniCode);
      }

      return _getTagResponseById(tagId);
    } else {
      // Occurs on null scans
      return TagResponse(null, _invalidScan);
    }
  }

  Future<TagResponse> _getTagResponseById(String tagId) async {
    // Verify tag is 32 hex digits before looking up
    if (isTagIdFormatValid(tagId)) {
      if (scanning) {
        try {
          // Attempting to get the tag from the external firebase database
          final tagData = await getTagById(tagId);
          // Saving result to the systems internal sqlite database
          await systemDatabase.insertTag(tagData);
          // TODO: Remove this test print
          systemDatabase.printCurrentList();

          return TagResponse(tagData, null);
        } on IdNotFoundException catch (e) {
          // TODO: Remove this test print
          systemDatabase.printCurrentList();
          // TODO: This hasn't been tested in a while and should be again
          return TagResponse(null, "You tried to scan an invalid ID code. Please try a different tag.");
        }
      } else {
        // TODO: Remove this test print
        systemDatabase.printCurrentList();
        return TagResponse(null, _notScanning);
      }
    }
    // Tag ID wasn't valid
    else {
      // TODO: Remove this test print
      systemDatabase.printCurrentList();
      return TagResponse(null, _invalidScan);
    }
  }
}

// Represents a concluded response from checking tag validity
class TagResponse {
  GetTagByIdTag? tagInfo;
  String? message;
  TagResponse(this.tagInfo, this.message);
}
