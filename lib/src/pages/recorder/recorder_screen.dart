import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:voice_of_mtuci/src/features/recorder/di.dart';
import 'package:voice_of_mtuci/src/features/recorder/entities/recorder_states.dart';
import 'package:voice_of_mtuci/src/features/uploader/models/record_model.dart';
import 'package:voice_of_mtuci/src/pages/recorder/widgets/inactive_record.dart';
import 'package:voice_of_mtuci/src/pages/recorder/widgets/need_permissions.dart';

import '../../features/uploader/di.dart';
import 'widgets/active_record.dart';

class RecorderScreen extends ConsumerWidget {
  const RecorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordEntity = ref.watch(recorderState);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'SpeechX',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 100),
                      Center(
                        child: Builder(
                          builder: (context) {
                            switch (recordEntity) {
                              case RecorderState.permissionRequired:
                                return const NeedPermissions();
                              case RecorderState.inactive:
                                return const InactiveRecord();
                              case RecorderState.paused:
                              case RecorderState.active:
                                return const ActiveRecord();
                              case RecorderState.loading:
                                return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
