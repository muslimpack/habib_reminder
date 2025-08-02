// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:habib_reminder/src/features/home/data/models/audio_model.dart';
import 'package:habib_reminder/src/features/home/presentation/components/audio_list_tile.dart';

class AudioListView extends StatefulWidget {
  final List<AudioModel> audioList;
  const AudioListView({super.key, required this.audioList});

  @override
  State<AudioListView> createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Animate initial items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < widget.audioList.length; i++) {
        Future.delayed(Duration(milliseconds: 100 * i), () {
          _listKey.currentState?.insertItem(i);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAnimatedList(
          key: _listKey,
          initialItemCount: 0,
          itemBuilder: (context, index, animation) {
            final item = widget.audioList[index];
            return SizeTransition(
              sizeFactor: animation,
              child: AudioListTile(item: item),
            );
          },
        ),
      ],
    );
  }
}
