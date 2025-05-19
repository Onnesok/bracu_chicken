# Bracu Chicken

Bracu Chicken is a 2D endless runner game built with Flutter and the Flame game engine. Guide your chicken (and other characters) through a side-scrolling world, avoid obstacles, and compete for the highest score!

## Features
- Multiple playable characters
- Several enemy types (cat girl, witch, bat, etc.)
- Parallax scrolling backgrounds (Pine Forest, Forest 1, Classic)
- Sound effects and background music
- Pause, settings, and level selection menus
- High score tracking
- Responsive controls (swipe and tap)

## Screenshots
*Add your screenshots here!*

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.5.0 or higher recommended)
- Dart SDK (comes with Flutter)

### Installation
1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd bracu_chicken
   ```
2. **Get dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the game:**
   ```sh
   flutter run
   ```
   > The game is optimized for landscape mode.

## Project Structure

- `lib/`
  - `main.dart` - App entry point
  - `game/` - Core game logic (game loop, enemy manager, player, etc.)
  - `screens/` - UI screens (welcome, game over, level select, character select)
  - `widgets/` - Custom widgets (pause button, menus, overlays)
  - `models/` - Data models (e.g., `enemy_data.dart`)
  - `providers/` - State management (score, music, level, background)
- `assets/`
  - `images/` - Sprites, backgrounds, parallax layers
  - `audio/` - Sound effects and background music
  - `Icon/` - App icons

## Assets
- **Images:**
  - Sprites for chicken, cat girl, witch, bat, and more
  - Parallax backgrounds: PineForestParallax, forest1, classic
- **Audio:**
  - Background music: 8BitPlatformerLoop.wav ([Tim Beek](https://timbeek.itch.io/royalty-free-music-pack))
  - SFX: jump14.wav, hurt7.wav ([mikiz](https://mikiz.itch.io/mega-music-pack-v2-over-160-sounds))
  - See `assets/audio/readme.md` for full credits

## Dependencies
- [Flame](https://pub.dev/packages/flame)
- [Provider](https://pub.dev/packages/provider)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Flame Audio](https://pub.dev/packages/flame_audio)
- [Hive](https://pub.dev/packages/hive)
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)

## Customization
- **Backgrounds:** Change in settings or via `BackgroundProvider`
- **Characters:** Select from the character selection screen
- **Levels:** Choose difficulty/level from the level selection screen

## Testing
- Basic widget test included in `test/widget_test.dart`

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
*Specify your license here.*

## Acknowledgements
- [Flame Engine](https://flame-engine.org/)
- [Flutter](https://flutter.dev/)
- Audio and some assets from [Tim Beek](https://timbeek.itch.io/) and [mikiz](https://mikiz.itch.io/)
