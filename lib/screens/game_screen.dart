import 'dart:async';
import 'package:flutter/material.dart';
import '../games/game_interface.dart';
import '../games/game_factory.dart';
import '../models/game_type.dart';
import '../models/game_mode.dart';
import '../models/high_score.dart';
import '../services/high_score_service.dart';
import '../widgets/custom_keyboard.dart';
import '../widgets/number_input.dart';
import '../widgets/matrix_input.dart';
import '../models/matrix2x2.dart';

class GameScreen extends StatefulWidget {
  final GameType gameType;
  final GameMode gameMode;

  const GameScreen({
    super.key,
    required this.gameType,
    required this.gameMode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late MathGame _game;
  dynamic _currentInput;
  int _selectedMatrixPosition = 0;
  int _score = 0;
  int _questionCount = 0;
  Timer? _timer;
  int _timeLeft = 30; // 30 seconds for speed mode
  bool _gameFinished = false;

  @override
  void initState() {
    super.initState();
    _game = GameFactory.createGame(widget.gameType);
    _startNewQuestion();
    if (widget.gameMode == GameMode.speed) {
      _startTimer();
    }
  }

  void _startNewQuestion() {
    _game.generateQuestion();
    setState(() {
      if (widget.gameType == GameType.addMatrices) {
        _currentInput = ['0', '0', '0', '0'];
      } else {
        _currentInput = '';
      }
      _selectedMatrixPosition = 0;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _timer?.cancel();
          _handleGameFinish();
        }
      });
    });
  }

  void _handleKeyPressed(String key) {
    if (widget.gameType == GameType.addNumbers || widget.gameType == GameType.determinant) {
      setState(() {
        if (key == '-') {
          if (_currentInput.isEmpty) {
            _currentInput = '-';
          } else if (_currentInput.startsWith('-')) {
            _currentInput = _currentInput.substring(1);
          } else {
            _currentInput = '-$_currentInput';
          }
        } else {
          _currentInput = _currentInput + key;
        }
      });
    } else if (widget.gameType == GameType.addMatrices) {
      setState(() {
        final newValues = List<String>.from(_currentInput);
        final currentVal = newValues[_selectedMatrixPosition];
        
        if (key == '-') {
          // Toggle negative sign
          if (currentVal.isEmpty || currentVal == '0') {
            newValues[_selectedMatrixPosition] = '-';
          } else if (currentVal.startsWith('-')) {
            // Remove negative sign
            newValues[_selectedMatrixPosition] = currentVal.substring(1);
          } else {
            // Add negative sign
            newValues[_selectedMatrixPosition] = '-$currentVal';
          }
        } else {
          // Number key pressed
          if (currentVal.isEmpty || currentVal == '0') {
            // Replace empty or zero with the number
            newValues[_selectedMatrixPosition] = key;
          } else if (currentVal == '-') {
            // Current is just '-', add number after it
            newValues[_selectedMatrixPosition] = '-$key';
          } else if (currentVal.startsWith('-')) {
            // Already negative with digits, append the number
            newValues[_selectedMatrixPosition] = '$currentVal$key';
          } else {
            // Positive number, append
            newValues[_selectedMatrixPosition] = '$currentVal$key';
          }
        }
        _currentInput = newValues;
      });
    }
  }

  void _handleClearPressed() {
    setState(() {
      if (widget.gameType == GameType.addNumbers || widget.gameType == GameType.determinant) {
        _currentInput = '';
      } else if (widget.gameType == GameType.addMatrices) {
        final newValues = List<String>.from(_currentInput);
        newValues[_selectedMatrixPosition] = '0';
        _currentInput = newValues;
      }
    });
  }

  void _handleEnterPressed() {
    bool isCorrect = false;
    if (widget.gameType == GameType.addNumbers || widget.gameType == GameType.determinant) {
      isCorrect = _game.checkAnswer(int.tryParse(_currentInput) ?? 0);
    } else if (widget.gameType == GameType.addMatrices) {
      final matrix = Matrix2x2(
        topLeft: int.tryParse(_currentInput[0]) ?? 0,
        topRight: int.tryParse(_currentInput[1]) ?? 0,
        bottomLeft: int.tryParse(_currentInput[2]) ?? 0,
        bottomRight: int.tryParse(_currentInput[3]) ?? 0,
      );
      isCorrect = _game.checkAnswer(matrix);
    }

    setState(() {
      if (isCorrect) _score++;
      _questionCount++;
    });

    if ((widget.gameMode == GameMode.accuracy && _questionCount >= 10) ||
        (widget.gameMode == GameMode.speed && _timeLeft <= 0)) {
      _handleGameFinish();
    } else {
      _startNewQuestion();
    }
  }

  Future<void> _handleGameFinish() async {
    if (widget.gameMode == GameMode.speed) {
      await _checkHighScore();
    }
    setState(() {
      _gameFinished = true;
    });
  }

  Future<void> _checkHighScore() async {
    if (widget.gameMode != GameMode.speed) return;
    
    final service = HighScoreService();
    final isHigh = await service.isHighScore(widget.gameType.name, _score);
    
    if (isHigh && mounted) {
      await _showNameEntryDialog();
    }
  }

  Future<void> _showNameEntryDialog() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('New High Score!'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter your name',
            hintText: 'Leave empty for "-"',
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('-'),
            child: const Text('No Name'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text.isEmpty ? '-' : controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    
    if (name != null) {
      final service = HighScoreService();
      await service.saveHighScore(
        widget.gameType.name,
        HighScore(
          name: name,
          score: _score,
          timeInSeconds: 30 - _timeLeft,
          gameType: widget.gameType.name,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_gameFinished) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameType.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _timer?.cancel();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          _buildScoreBar(),
          const SizedBox(height: 20),
          Expanded(
            child: _game.buildInputWidget(
              context: context,
              currentInput: _currentInput,
              onInputChanged: (input) => setState(() => _currentInput = input),
              onSubmit: _handleEnterPressed,
            ),
          ),
          if (widget.gameType == GameType.addMatrices)
            MatrixInput(
              values: _currentInput,
              selectedPosition: _selectedMatrixPosition,
              onPositionSelected: (pos) =>
                  setState(() => _selectedMatrixPosition = pos),
            ),
          const SizedBox(height: 20),
          CustomKeyboard(
            onKeyPressed: _handleKeyPressed,
            onEnterPressed: _handleEnterPressed,
            onClearPressed: _handleClearPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Score: $_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (widget.gameMode == GameMode.speed)
            Text('Time: $_timeLeft', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          else
            Text('Question: $_questionCount/10', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Game Over!', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Score: $_score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            if (widget.gameMode == GameMode.accuracy)
              Text('Out of 10', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}