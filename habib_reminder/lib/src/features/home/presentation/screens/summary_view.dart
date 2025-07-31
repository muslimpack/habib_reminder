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

              // Countdown Timer Card
              if (state.isRunning)
                Card(
                  color: Colors.green.withAlpha(100),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 10,
                      children: [
                        Icon(Icons.access_time, size: 50, color: Colors.green),
                        Text(
                          'الوقت المتبقي للعب التالي:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.read<HabibCubit>().formatTimeRemaining(
                            state.timeRemainingInSeconds,
                          ),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
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
