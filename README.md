# Asian Chicken

Asian Chicken is a 2D endless runner game built with Flutter and the Flame game engine. Guide your chicken (and other characters) through a side-scrolling world, avoid obstacles, and compete for the highest score!

## Features
- Multiple playable characters
- Several enemy types (cat girl, witch, bat, etc.)
- Parallax scrolling backgrounds (Pine Forest, Forest 1, Classic)
- Sound effects and background music
- Pause, settings, and level selection menus
- High score tracking
- Responsive controls (swipe and tap)

## Screenshots

Game screenshots can be found in the [assets/Asian chicken directory on GitHub](https://github.com/Onnesok/asian_chicken/tree/main/assets/Asian%20chicken).

Below are some example screenshots from the game:

| ![1](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/1.jpg) | ![2](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/2.jpg) | ![3](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/3.jpg) | ![4](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/4.jpg) |
|---|---|---|---|
| ![5](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/5.jpg) | ![6](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/6.jpg) | ![7](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/7.jpg) | ![8](https://github.com/Onnesok/asian_chicken/raw/main/assets/Asian%20chicken/8.jpg) |

> For more screenshots, see the [assets/Asian chicken folder](https://github.com/Onnesok/asian_chicken/tree/main/assets/Asian%20chicken) in the repository.

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.5.0 or higher recommended)
- Dart SDK (comes with Flutter)

### Installation
1. **Clone the repository:**
   ```sh
   git clone https://github.com/Onnesok/asian_chicken.git
   cd asian_chicken
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

```
asian_chicken/
│
├── lib/
│   ├── main.dart                # App entry point, sets up providers and launches the game
│   │
│   ├── game/                    # Core game logic and components
│   │   ├── asian_chicken_game.dart   # Main game class, handles game loop, parallax, and state
│   │   ├── enemy_manager.dart        # Spawns and manages enemies
│   │   ├── enemy.dart                # Enemy component and behavior
│   │   └── chicken.dart              # Player character logic and animation
│   │
│   ├── screens/                 # UI/game screens
│   │   ├── welcome_screen.dart         # Main menu and welcome screen
│   │   ├── game_over_screen.dart       # Game over UI
│   │   ├── level_screen.dart           # Level/difficulty selection
│   │   └── character_selection_screen.dart # Character selection UI
│   │
│   ├── widgets/                 # Reusable UI widgets and overlays
│   │   ├── pause_button.dart            # Pause button widget
│   │   ├── pause_menu_bracu.dart        # Pause menu overlay
│   │   ├── settings_menu_bracu.dart     # Settings menu overlay
│   │   └── loading_overlay.dart         # Loading overlay widget
│   │
│   ├── models/                  # Data models
│   │   └── enemy_data.dart              # Enemy data structure
│   │
│   └── providers/               # State management (using Provider)
│       ├── score_provider.dart          # Score and high score logic
│       ├── music_provider.dart          # Music and sound settings
│       ├── level_provider.dart          # Level/difficulty state
│       └── background_provider.dart     # Background selection state
│
├── assets/
│   ├── images/                  # All game images and sprites
│   │   ├── cat_girl/                    # Cat girl enemy sprites
│   │   ├── witch/                       # Witch enemy sprites
│   │   ├── Bat/, Rino/, AngryPig/       # Other enemy sprites
│   │   ├── ChickBoy/, chicken/          # Player character sprites
│   │   └── parallax/                    # Parallax backgrounds
│   │       ├── PineForestParallax/      # Pine forest background layers
│   │       └── forest1/                 # Forest 1 background layers
│   │       └── plx-*.png                # Classic background layers
│   │
│   ├── audio/                   # Sound effects and background music
│   │   ├── 8BitPlatformerLoop.wav       # Main background music
│   │   ├── jump14.wav, hurt7.wav        # Sound effects
│   │   └── readme.md                    # Audio credits and licenses
│   └── Icon/                    # App icons for mobile/desktop
│
├── test/
│   └── widget_test.dart         # Example widget test
│
├── pubspec.yaml                 # Project configuration, dependencies, and asset registration
└── README.md                    # Project documentation (this file)
```

---

### Directory Highlights

- **lib/game/**: All core game logic, including the main game loop, player, and enemy logic.
- **lib/screens/**: All major UI screens, such as menus and overlays.
- **lib/widgets/**: Reusable UI components and overlays for pause, settings, and loading.
- **lib/providers/**: State management for score, music, level, and background.
- **assets/images/parallax/**: Contains all parallax background layers, organized by theme.
- **assets/audio/**: Contains all music and sound effects, with credits in `readme.md`.

---

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
- Audio and some assets from [Tim Beek](https://timbeek.itch.io/),  [mikiz](https://mikiz.itch.io/) and [Arks](https://arks.itch.io/)
