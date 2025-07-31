import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/features/home/presentation/components/audio_list_tile.dart';
import 'package:habib_reminder/src/features/home/presentation/controller/cubit/habib_cubit.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HabibCubit, HabibState>(
      builder: (context, state) {
        if (state is! HabibLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CheckboxListTile(
                  secondary: Icon(Icons.launch),
                  value: state.launchAtStartup,
                  title: const Text('بدء التشغيل مع النظام'),
                  subtitle: Text('تشغيل التطبيق تلقائيا مع بداية تشغيل النظام'),
                  onChanged: (value) async {
                    await context.read<HabibCubit>().toggleLaunchAtStartup();
                  },
                ),
              ),
              if (PlatformExtension.isDesktop)
                SliverToBoxAdapter(
                  child: CheckboxListTile(
                    secondary: Icon(Icons.flip_to_back_sharp),
                    value: state.launchMinimized,
                    title: const Text('التشغيل في الخلفية'),
                    onChanged: (value) async {
                      await context.read<HabibCubit>().toggleLaunchMinimized();
                    },
                  ),
                ),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: Divider()),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  leading: const Icon(Icons.volume_up),
                  title: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'الصوت: ${(state.globalVolume * 100).toStringAsFixed(0)}',
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: state.globalVolume * 100,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: (state.globalVolume * 100).toStringAsFixed(0),
                          onChanged: (value) {
                            context.read<HabibCubit>().changeGlobalVolume(
                              (value / 100),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListTile(
                  leading: const Icon(Icons.timer),
                  title: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'الفاصل: ${state.audioIntervalInMinutes} دقائق',
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: state.audioIntervalInMinutes.toDouble(),
                          min: 1,
                          max: 60,
                          divisions: 59,
                          label: state.audioIntervalInMinutes.toString(),
                          onChanged: (value) {
                            context.read<HabibCubit>().changeInterval(
                              value.toInt(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: Divider()),
              ),
              SliverAnimatedList(
                initialItemCount: state.audioList.length,
                itemBuilder: (context, index, animation) {
                  final item = state.audioList[index];
                  return FadeTransition(
                    opacity: animation,
                    child: AudioListTile(item: item),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
