import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/word_card.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _unfocusFields() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _saveWord() async {
    _unfocusFields();
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final wordCard = WordCard(
        word: _wordController.text.trim(),
        translation: _translationController.text.trim(),
        category: _categoryController.text.trim(),
        lastReviewed: DateTime.now(),
      );

      final box = Hive.box<WordCard>('wordCards');
      
      if (kDebugMode) {
        print('Attempting to save word: ${wordCard.word}');
        print('Box length before save: ${box.length}');
      }

      final index = await box.add(wordCard);

      if (kDebugMode) {
        print('Word saved at index: $index');
        print('Box length after save: ${box.length}');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Слово успешно добавлено'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error saving word: $e');
        print('Stack trace: $stackTrace');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка при сохранении слова'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusFields,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Добавить слово'),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _wordController,
                      decoration: const InputDecoration(
                        labelText: 'Слово',
                        border: OutlineInputBorder(),
                        helperText: 'Введите слово для изучения',
                      ),
                      autofillHints: const [AutofillHints.username],
                      textInputAction: TextInputAction.next,
                      enabled: !_isSubmitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Пожалуйста, введите слово';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _translationController,
                      decoration: const InputDecoration(
                        labelText: 'Перевод',
                        border: OutlineInputBorder(),
                        helperText: 'Введите перевод слова',
                      ),
                      textInputAction: TextInputAction.next,
                      enabled: !_isSubmitting,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Пожалуйста, введите перевод';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                        border: OutlineInputBorder(),
                        helperText: 'Введите категорию слова',
                      ),
                      textInputAction: TextInputAction.done,
                      enabled: !_isSubmitting,
                      onFieldSubmitted: (_) => _saveWord(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Пожалуйста, введите категорию';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _saveWord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                        ),
                        child: _isSubmitting
                            ? const SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Сохранить',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}