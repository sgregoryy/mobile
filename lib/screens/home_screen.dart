import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/word_card.dart';
import 'study_screen.dart';
import 'add_word_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изучение слов'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<WordCard>('wordCards').listenable(),
        builder: (context, Box<WordCard> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Добавьте новые слова для изучения'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final wordCard = box.getAt(index);
              return ListTile(
                title: Text(wordCard!.word),
                subtitle: Text(wordCard.translation),
                trailing: Text(wordCard.category),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'study',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudyScreen(),
                ),
              );
            },
            child: const Icon(Icons.school),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddWordScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}