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
                            Text(
                              'الصوت: ${(state.globalVolume * 100).toStringAsFixed(0)}',
                            ),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress indicator
                      if (state.isRunning)
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: state.timeRemainingInSeconds > 0
                                ? state.timeRemainingInSeconds /
                                      (state.audioIntervalInMinutes * 60)
                                : 0.0,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              state.timeRemainingInSecondsColor,
                            ),
                          ),
                        ),

                      // Play/Stop button
                      IconButton(
                        onPressed: () {
                          if (state.isRunning) {
                            context.read<HabibCubit>().stopReminder();
                          } else {
                            context.read<HabibCubit>().startReminder();
                          }
                        },
                        icon: Icon(
                          state.isRunning
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          size: 200,
                          color: state.isRunning ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  Icon(Icons.access_time, size: 24, color: Colors.green),
                  Text(
                    context.read<HabibCubit>().formatTimeRemaining(
                      state.timeRemainingInSeconds,
                    ),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: state.timeRemainingInSecondsColor,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
