import 'package:flutter/material.dart';
import '../game/asian_chicken_game.dart';
import 'package:provider/provider.dart';
import '../providers/control_buttons_provider.dart';

class ControlButtons extends StatelessWidget {
  final AsianChickenGame game;
  final VoidCallback? onJump;
  final VoidCallback? onLeft;
  final VoidCallback? onRight;
  final VoidCallback? onDown;
  static const String id = 'ControlButtons';
  const ControlButtons({
    Key? key,
    required this.game,
    this.onJump,
    this.onLeft,
    this.onRight,
    this.onDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controlProvider = Provider.of<ControlButtonsProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Left Button
        if (controlProvider.leftEnabled)
          Positioned(
            left: controlProvider.leftPosition.dx * screenSize.width - 34,
            top: controlProvider.leftPosition.dy * screenSize.height - 34,
            child: _modernButton(
              icon: Icons.keyboard_arrow_left,
              onPressed: onLeft,
              tooltip: 'Left',
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        // Right Button
        if (controlProvider.rightEnabled)
          Positioned(
            left: controlProvider.rightPosition.dx * screenSize.width - 34,
            top: controlProvider.rightPosition.dy * screenSize.height - 34,
            child: _modernButton(
              icon: Icons.keyboard_arrow_right,
              onPressed: onRight,
              tooltip: 'Right',
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        // Jump Button
        if (controlProvider.jumpEnabled)
          Positioned(
            left: controlProvider.jumpPosition.dx * screenSize.width - 34,
            top: controlProvider.jumpPosition.dy * screenSize.height - 34,
            child: _modernButton(
              icon: Icons.keyboard_arrow_up,
              onPressed: onJump,
              tooltip: 'Jump',
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        // Down Button
        if (controlProvider.downEnabled)
          Positioned(
            left: controlProvider.downPosition.dx * screenSize.width - 34,
            top: controlProvider.downPosition.dy * screenSize.height - 34,
            child: _modernButton(
              icon: Icons.keyboard_arrow_down,
              onPressed: onDown,
              tooltip: 'Down',
              color: Colors.white.withOpacity(0.4),
            ),
          ),
      ],
    );
  }

  Widget _modernButton({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              color: color?.withOpacity(0.35) ?? Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              width: 68,
              height: 68,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 38,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
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