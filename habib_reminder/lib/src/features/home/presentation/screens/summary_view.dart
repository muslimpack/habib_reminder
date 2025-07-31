import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habib_reminder/src/features/home/presentation/controller/cubit/habib_cubit.dart';

class SummaryView extends StatelessWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabibCubit, HabibState>(
      builder: (context, state) {
        if (state is! HabibLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blue.withAlpha(100),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 10,
                          children: [
                            Icon(Icons.volume_up, size: 50),
                            Text('الصوت: ${state.globalVolume}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.amber.withAlpha(100),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 10,
                          children: [
                            Icon(Icons.timer, size: 50),
                            Text(
                              'الفاصل: ${state.audioIntervalInMinutes} دقائق',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      if (state.isRunning) {
                        context.read<HabibCubit>().stop();
                      } else {
                        context.read<HabibCubit>().play();
                      }
                    },
                    icon: Icon(
                      state.isRunning
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      size: 200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
