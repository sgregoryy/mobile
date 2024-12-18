import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'screens/home_screen.dart';
import 'models/word_card.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    if (kIsWeb) {
      // Специальная инициализация для веб
      await Hive.initFlutter('hive_db');
    } else {
      await Hive.initFlutter();
    }
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WordCardAdapter());
    }
    
    await Hive.openBox<WordCard>('wordCards',
      path: kIsWeb ? null : 'wordcards_db',
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