import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/local_database/database.dart';

class MyTags extends StreamBuilder {
  MyTags(Stream<List<TagTableData>> stream, {super.key})
    : super(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting &&
              snapshot.connectionState != ConnectionState.none) {
            List<TagTableData> tags = snapshot.data;

            return Scaffold(
              appBar: AppBar(title: const Text('My Scanned Tags')),
              body: tags.isEmpty
                  ? Text(
                      "It looks like you don't have any tags yet...\n"
                      "Try using the NFC search button.",
                    )
                  : TagsListView(tags: tags),
            );
          }
          // Satisfying the Flutter Build conditions
          // With how lists are relayed through streams, this should never show
          return Text('Map info will go here');
        },
      );
}

class TagsListView extends ListView {
  TagsListView({required List<TagTableData> tags, super.key})
    : super(
        children: tags.map((tagData) => TagCard(tagData: tagData)).toList(),
      );
}

class TagCard extends Card {
  TagCard({required TagTableData tagData, super.key})
    : super(
        child: ListTile(
          title: Text(tagData.title, style: GoogleFonts.huninn(fontSize: 24)),
          subtitle: tagData.description == null
              ? null
              : Text(
                  _truncateWithEllipsis(tagData.description as String, 200),
                  style: GoogleFonts.huninn(fontSize: 16),
                ),
        ),
      );
}

/// Source - https://stackoverflow.com/a/56187365
/// Posted by Nick
/// Retrieved 2026-11-15, License - CC BY-SA 4.0
/// Modified by Juniper Pasternak:
///   Change parameter order and names.
///   Place ellipsis 3 before the maxLength, so that the string never exceeds maxLength.
String _truncateWithEllipsis(String myString, int maxLength) {
  if (myString.length <= maxLength) {
    return myString;
  } else {
    return '${myString.substring(0, maxLength - 3)}...';
  }
}
