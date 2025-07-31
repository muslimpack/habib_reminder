import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habib_reminder/src/features/home/data/models/audio_model.dart';
import 'package:habib_reminder/src/features/home/presentation/controller/cubit/habib_cubit.dart';

class AudioListTile extends StatelessWidget {
  const AudioListTile({super.key, required this.item});

  final AudioModel item;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: item.play,
      title: Text(item.name),
      subtitle: Text(item.author),
      secondary: IconButton(
        onPressed: () {
          context.read<HabibCubit>().playPreview(audio: item);
        },
        icon: Icon(Icons.play_arrow),
      ),
      onChanged: (value) {
        context.read<HabibCubit>().toggleAudio(item);
      },
    );
  }
}
