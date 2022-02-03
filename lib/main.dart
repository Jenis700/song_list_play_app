import 'package:flutter/material.dart';
import 'package:song_list_app/Screens/create_remove.dart';
import 'package:song_list_app/Screens/albums.dart';
import 'package:song_list_app/Screens/artist.dart';
import 'package:song_list_app/Screens/genres.dart';
import 'package:song_list_app/Screens/songs.dart';
import 'package:rounded_tabbar_widget/rounded_tabbar_widget.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoundedTabbarWidget(
        itemNormalColor: Colors.white,
        itemSelectedColor: Colors.amber.shade700,
        tabBarBackgroundColor: Colors.black,
        tabIcons: const [
          Icons.audiotrack,
          Icons.photo_album_rounded,
          Icons.playlist_add_check_sharp,
          Icons.local_activity,
          Icons.article_sharp,
        ],
        pages: const [
          Songs(),
          Albums(),
          Artist(),
          Genrels(),
          CreateRemove(),
        ],
        selectedIndex: 0,
        onTabItemIndexChanged: (int index) {
          print('Index: $index');
        },
      ),
    ),
  );
}
