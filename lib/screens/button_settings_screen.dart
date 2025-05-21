import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/control_buttons_provider.dart';

class ButtonSettingsScreen extends StatefulWidget {
  @override
  State<ButtonSettingsScreen> createState() => _ButtonSettingsScreenState();
}

class _ButtonSettingsScreenState extends State<ButtonSettingsScreen> with SingleTickerProviderStateMixin {
  // Temporary positions for editing
  late Offset jumpPos;
  late Offset leftPos;
  late Offset rightPos;
  late Offset downPos;

  String? draggingButton;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ControlButtonsProvider>(context, listen: false);
    jumpPos = provider.jumpPosition;
    leftPos = provider.leftPosition;
    rightPos = provider.rightPosition;
    downPos = provider.downPosition;
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onDrag(String button, Offset localPosition, Size areaSize) {
    final dx = (localPosition.dx / areaSize.width).clamp(0.0, 1.0);
    final dy = (localPosition.dy / areaSize.height).clamp(0.0, 1.0);
    setState(() {
      switch (button) {
        case 'Jump':
          jumpPos = Offset(dx, dy);
          break;
        case 'Left':
          leftPos = Offset(dx, dy);
          break;
        case 'Right':
          rightPos = Offset(dx, dy);
          break;
        case 'Down':
          downPos = Offset(dx, dy);
          break;
      }
    });
  }

  void _savePositions(BuildContext context) {
    setState(() {}); // ensure latest positions are used
    final provider = Provider.of<ControlButtonsProvider>(context, listen: false);
    provider.setJumpPosition(jumpPos);
    provider.setLeftPosition(leftPos);
    provider.setRightPosition(rightPos);
    provider.setDownPosition(downPos);
    provider.savePositions();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Button positions saved!')),
    );
  }

  void _resetToDefault() {
    setState(() {
      leftPos = const Offset(0.08, 0.82);
      rightPos = const Offset(0.18, 0.82);
      jumpPos = const Offset(0.88, 0.60);
      downPos = const Offset(0.88, 0.82);
    });
    final provider = Provider.of<ControlButtonsProvider>(context, listen: false);
    provider.setJumpPosition(jumpPos);
    provider.setLeftPosition(leftPos);
    provider.setRightPosition(rightPos);
    provider.setDownPosition(downPos);
    provider.savePositions();
  }

  @override
  Widget build(BuildContext context) {
    final controlProvider = Provider.of<ControlButtonsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeController,
        child: Stack(
          children: [
            // Fullscreen drag area
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final areaSize = Size(constraints.maxWidth, constraints.maxHeight);
                    return Stack(
                      children: [
                        // Info tip centered at the top
                        Positioned(
                          top: 24,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow.shade100.withOpacity(0.93),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.brown.shade200),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.brown.withOpacity(0.13),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.info_outline, color: Colors.brown, size: 18),
                                          SizedBox(width: 7),
                                          Text('Drag the buttons. Tap Save or Reset.', style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.save, size: 20),
                                    label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.85),
                                      foregroundColor: Colors.brown,
                                      elevation: 4,
                                      shadowColor: Colors.brown.withOpacity(0.18),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => _savePositions(context),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.refresh, size: 20, color: Colors.brown),
                                    label: const Text('Reset', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.brown.withOpacity(0.5), width: 2),
                                      backgroundColor: Colors.white.withOpacity(0.7),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      shadowColor: Colors.brown.withOpacity(0.10),
                                      elevation: 2,
                                    ),
                                    onPressed: _resetToDefault,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Floating back button (top left) with border and blur
                        Positioned(
                          top: 18,
                          left: 18,
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Material(
                                color: Colors.white.withOpacity(0.4),
                                shape: const CircleBorder(),
                                elevation: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.arrow_back, color: Colors.brown, size: 26),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Draggable buttons with animation
                        _draggableButton('Jump', jumpPos, areaSize, Icons.keyboard_arrow_up, Colors.blue),
                        _draggableButton('Left', leftPos, areaSize, Icons.keyboard_arrow_left, Colors.green),
                        _draggableButton('Right', rightPos, areaSize, Icons.keyboard_arrow_right, Colors.orange),
                        _draggableButton('Down', downPos, areaSize, Icons.keyboard_arrow_down, Colors.red),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _draggableButton(String label, Offset pos, Size areaSize, IconData icon, Color color) {
    final isDragging = draggingButton == label;
    return Positioned(
      left: pos.dx * areaSize.width - 34,
      top: pos.dy * areaSize.height - 34,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() => draggingButton = label);
        },
        onPanEnd: (_) {
          setState(() => draggingButton = null);
        },
        onPanUpdate: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final local = box.globalToLocal(details.globalPosition);
          _onDrag(label, local, areaSize);
        },
        child: AnimatedScale(
          scale: isDragging ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Material(
                  color: Colors.white.withOpacity(0.4),
                  shape: const CircleBorder(),
                  elevation: 8,
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: Icon(icon, color: Colors.white, size: 38),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 