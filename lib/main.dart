import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'shared/audio/audio_service.dart';
import 'shared/progress/progress_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait-only as per UX guidelines.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final progressService = ProgressService();
  await progressService.init();

  final audioService = TtsAudioService();
  await audioService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProgressService>.value(value: progressService),
        Provider<AudioService>.value(value: audioService),
      ],
      child: const KidsReadApp(),
    ),
  );
}

class KidsReadApp extends StatelessWidget {
  const KidsReadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KidsRead',
      debugShowCheckedModeBanner: false,
      theme: KidsReadTheme.themeData,
      routerConfig: appRouter,
    );
  }
}
