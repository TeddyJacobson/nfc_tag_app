import 'dart:async';

import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

import '/dataconnect_generated/generated.dart';
import '/local_database/database.dart';

import '../firebase_functions.dart';

// TODO: Construct messages for failed scans
final String _failToScan = 'This is a placeholder String. The tag failed :)';

// A class for controlling the operations of NFC scans
class NfcInteractionHandler {
  // Stream handling
  final StreamController<TagResponse> controller =
      StreamController<TagResponse>();
  Stream<TagResponse> get stream => controller.stream;
  bool scanning = false;

  // Setting up for NFC interaction with a systems local database
  final AppDatabase systemDatabase;
  NfcInteractionHandler(this.systemDatabase);

  void updateNFCStream(NfcTag tag) async {
    TagResponse response = await getTagInfo(tag);
    if (response.tagInfo == null && response.message == null) {
      // Things went all wrong. Freak out.
    } else {
      // A tag response was
      controller.sink.add(response);
    }
  }

  // Start scanning for NFC tags
  void startSession() {
    print("Session begun");
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: updateNFCStream,
    );
  }

  // Stop scanning for NFC tags
  void endSession() {
    print("Session ended");
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

    if (tagNDEF != null) {
      // SUCCESS
      // Get the text stored within the tag
      final List<NdefRecord> nDefRecords = tagNDEF.cachedMessage!.records;
      String tagID = "";

      // Start reading message at 3 cause NFC adds extra letters
      for (int i = 3; i < nDefRecords[0].payload.length; i++) {
        int uniCode = nDefRecords[0].payload[i];
        tagID += String.fromCharCode(uniCode);
      }

      // Verify tag is 32 hex digits before looking up
      if (isTagIdFormatValid(tagID)) {
        if (scanning) {
          try {
            // Attempting to get the tag from the external firebase database
            final tagData = await getTagById(tagID);
            // Saving result to the systems internal sqlite database
            await systemDatabase.insertTag(tagData);
            // TODO: Remove this test print
            systemDatabase.printCurrentList();

            return TagResponse(tagData, null);
          } on IdNotFoundException catch (e) {
            // TODO: Remove this test print
            systemDatabase.printCurrentList();
            // TODO: This hasn't been tested in a while and should be again
            return TagResponse(null, "That is an invalid ID code");
          }
        } else {
          // TODO: Remove this test print
          systemDatabase.printCurrentList();
          return TagResponse(
            null,
            "You should try clicking the scan button :)",
          );
        }
      }
      // Tag ID wasn't valid
      else {
        // TODO: Remove this test print
        systemDatabase.printCurrentList();
        return TagResponse(null, _failToScan);
      }
    } else {
      // TODO: Remove this test print
      systemDatabase.printCurrentList();
      // This should never occur
      return TagResponse(null, _failToScan);
    }
  }
}

// Represents a concluded response from checking tag validity
class TagResponse {
  GetTagByIdTag? tagInfo;
  String? message;
  TagResponse(this.tagInfo, this.message);
}
