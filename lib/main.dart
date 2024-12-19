import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/home_screen.dart';
import 'models/word_card.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      await Hive.initFlutter('hive_db');
    } else {
      // Получаем путь к директории приложения
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    }

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WordCardAdapter());
    }

    await Hive.openBox<WordCard>('wordCards',
      // Убираем явное указание пути
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 20,
    );

    runApp(const FlashcardsApp());

  } catch (e, stackTrace) {
    if (kDebugMode) {
      print('Error initializing app: $e');
      print(stackTrace);
    }
  }
}


class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Изучение слов',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Customize button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}