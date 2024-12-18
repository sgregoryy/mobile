import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/word_card.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> with SingleTickerProviderStateMixin {
  bool showTranslation = false;
  int currentIndex = 0;
  late Box<WordCard> wordBox;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    wordBox = Hive.box<WordCard>('wordCards');
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextCard() {
    setState(() {
      if (currentIndex < wordBox.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      showTranslation = false;
    });
    _controller.forward(from: 0);
  }

  void toggleTranslation() {
    setState(() {
      showTranslation = !showTranslation;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (wordBox.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Изучение'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_books, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Нет слов для изучения',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Добавить слова'),
              ),
            ],
          ),
        ),
      );
    }

    final wordCard = wordBox.getAt(currentIndex)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Изучение'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Progress indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / wordBox.length,
              backgroundColor: Colors.grey[200],
            ),
            Text(
              'Карточка ${currentIndex + 1} из ${wordBox.length}',
              style: const TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_animation.value * 0.2),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                wordCard.word,
                                style: Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              if (showTranslation) ...[
                                const Divider(),
                                Text(
                                  wordCard.translation,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              const SizedBox(height: 20),
                              Text(
                                'Категория: ${wordCard.category}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: toggleTranslation,
                    icon: Icon(showTranslation ? Icons.visibility_off : Icons.visibility),
                    label: Text(showTranslation ? 'Скрыть перевод' : 'Показать перевод'),
                  ),
                  ElevatedButton.icon(
                    onPressed: nextCard,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Следующее'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}