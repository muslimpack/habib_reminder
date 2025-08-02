// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habib_reminder/src/core/extension/extension_platform.dart';
import 'package:habib_reminder/src/features/home/presentation/components/audio_list_view.dart';
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
        return CustomScrollView(
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
                        padding: EdgeInsets.zero,
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
                        padding: EdgeInsets.zero,
                        value: state.audioIntervalInMinutes.toDouble(),
                        min: 1,
                        max: 15,
                        divisions: 14,
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
            SliverFillRemaining(
              child: AudioListView(audioList: state.audioList),
            ),
          ],
        );
      },
    );
  }
}
