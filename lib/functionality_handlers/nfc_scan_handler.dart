import 'dart:async';

import 'package:nfc_manager/ndef_record.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';
import 'package:nfc_tap_app/dataconnect_generated/generated.dart';

import '../database_functions.dart';

// TODO: Construct messages for failed scans
final String _failToScan = 'This is a placeholder String. The tag failed :)';

// A class for controlling the output of NFC tag scans as a steady stream
class NfcInteractionHandler {
  final controller = StreamController<TagResponse>();
  Stream<TagResponse> get stream => controller.stream;
  // TODO: This will be used to tell the handler if it cares to search the DB.
  bool scanning = false;

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
    3. The tag is legal and the scan button wasn't pressed = Null, message explaining issue..
    4. The tag isn't legal and the scan button wasn't pressed = Null, message explaining issue.
*/
  Future<TagResponse> getTagInfo(NfcTag tag) async {
    // Get the text stored within the tag
    final List<NdefRecord>? nDefRecords = Ndef.from(tag)!
        .cachedMessage!
        .records;

    if (nDefRecords != null) {
      // SUCCESS
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
            final tagData = await getTagById(tagID);
            return TagResponse(tagData, null);
          } on IdNotFoundException catch (e) {
            return TagResponse(null, "That is an invalid ID code");
          }
        }
        else{
          return TagResponse(null, "You should try clicking the scan button :)");
        }
      }
      // Tag ID wasn't valid
      else {
        return TagResponse(null, _failToScan);
      }
    } else {
      // This should never occur
      return TagResponse(
        null,
        "Something went wrong. Please try closing app and re-opening it.",
      );
    }
  }
}

// Represents a concluded response from checking tag validity
class TagResponse {
  GetTagByIdTag? tagInfo;
  String? message;
  TagResponse(this.tagInfo, this.message);
}
