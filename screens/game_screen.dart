import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_state.dart';
import '../services/game_logic.dart';
import '../widgets/game_pad.dart';
import '../widgets/score_display.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState gameState = GameState();
  List<int> userSequence = [];
  int activeIndex = -1;
  Timer? sequenceTimer;
  final AudioPlayer audioPlayer = AudioPlayer();

  final List<Color> padColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      gameState = GameLogic.startNewGame();
      userSequence = [];
    });
    showSequence();
  }

  void showSequence() async {
    setState(() {
      gameState = gameState.copyWith(isShowingSequence: true);
    });

    final soundFiles = ['red.wav', 'green.wav', 'blue.wav', 'yellow.wav'];

    for (int i = 0; i < gameState.sequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() {
        activeIndex = gameState.sequence[i];
      });
      
      // Play sound for the active pad
      audioPlayer.play(AssetSource('sounds/${soundFiles[gameState.sequence[i]]}'));
      
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() {
        activeIndex = -1;
      });
    }

    setState(() {
      gameState = gameState.copyWith(isShowingSequence: false);
    });
  }

  void onPadTap(int padIndex) {
    if (gameState.isShowingSequence || gameState.isGameOver) return;

    setState(() {
      activeIndex = padIndex;
      userSequence.add(padIndex);
    });

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        activeIndex = -1;
      });
    });

    if (!GameLogic.validateInput(userSequence, gameState.sequence)) {
      gameOver();
      return;
    }

    if (userSequence.length == gameState.sequence.length) {
      Timer(const Duration(milliseconds: 500), () {
        nextLevel();
      });
    }
  }

  void nextLevel() {
    setState(() {
      gameState = GameLogic.nextLevel(gameState);
      userSequence = [];
    });
    showSequence();
  }

  void gameOver() {
    setState(() {
      gameState = GameLogic.gameOver(gameState);
    });
    
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(
            finalScore: gameState.score,
            finalLevel: gameState.currentLevel,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ScoreDisplay(
            score: gameState.score,
            level: gameState.currentLevel,
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GamePad(
                        color: padColors[0],
                        isActive: activeIndex == 0,
                        onTap: () => onPadTap(0),
                        padIndex: 0,
                      ),
                      const SizedBox(width: 20),
                      GamePad(
                        color: padColors[1],
                        isActive: activeIndex == 1,
                        onTap: () => onPadTap(1),
                        padIndex: 1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GamePad(
                        color: padColors[2],
                        isActive: activeIndex == 2,
                        onTap: () => onPadTap(2),
                        padIndex: 2,
                      ),
                      const SizedBox(width: 20),
                      GamePad(
                        color: padColors[3],
                        isActive: activeIndex == 3,
                        onTap: () => onPadTap(3),
                        padIndex: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  void dispose() {
    sequenceTimer?.cancel();
    super.dispose();
  }
}