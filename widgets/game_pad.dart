import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GamePad extends StatefulWidget {
  final Color color;
  final bool isActive;
  final VoidCallback onTap;
  final int padIndex;

  const GamePad({
    super.key,
    required this.color,
    required this.isActive,
    required this.onTap,
    required this.padIndex,
  });

  @override
  State<GamePad> createState() => _GamePadState();
}

class _GamePadState extends State<GamePad> {
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  void playSound() {
    final soundFiles = ['red.wav', 'green.wav', 'blue.wav', 'yellow.wav'];
    audioPlayer.play(AssetSource('sounds/${soundFiles[widget.padIndex]}'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playSound();
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: widget.isActive ? widget.color.withOpacity(1.0) : widget.color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: widget.isActive
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ]
              : [],
        ),
      ),
    );
  }
}