# Undercover Party Game

A mobile multiplayer party game built with Flutter based on the social deduction game Undercover. Players are assigned secret roles and words, and must guess who the Undercover is through word descriptions and voting.

##  Game Overview

**Undercover** is a social deduction game where:
- **Citizens** receive one word from a pair (e.g., "Cat")
- **The Undercover** receives the related word (e.g., "Tiger")  
- Players describe their words without saying them directly
- Everyone votes to eliminate suspected Undercover players
- **Citizens win** if they eliminate the Undercover
- **Undercover wins** if only 2 players remain

##  Getting Started

### Prerequisites

1. **Flutter SDK installed** - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. **Flutter added to your system PATH**
3. **VS Code with Flutter extension** (recommended)

### Installation & Setup

1. **Clone or download this project**
2. **Navigate to the project directory:**
   ```bash
   cd "Flutter App"
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   # For Android device/emulator
   flutter run
   ```

## Features Implemented

### Player Setup Screen
- Input number of players (3-12)
- Enter player names with validation
- Start Game button

###  Role Distribution System
- Randomly assigns 1 Undercover and rest as Citizens
- 10 predefined word pairs (Cat/Tiger, Coffee/Tea, etc.)
- Private role reveal for each player
- Secure word assignment system

## 🏗️ App Structure

```
lib/
└── main.dart                 # Complete app implementation
    ├── UndercoverApp        # Root app widget
    ├── SetupScreen          # Player setup screen  
    ├── RoleDistributionScreen # Role assignment and reveal
    ├── GameRoundsScreen     # Complete game rounds implementation
    ├── Player               # Player data model
    ├── PlayerRole           # Role enumeration (citizen/undercover)
    ├── WordPair             # Word pair data model
    └── GamePhase            # Game phase enumeration

android/                      # Android platform configuration
```

##  Game Flow

1. **Setup Screen** 
   - Choose player count
   - Enter player names
   
2. **Role Distribution** 
   - Randomly assign roles (1 Undercover, rest Citizens)
   - Show roles privately to each player
   - Assign word pairs from predefined list
   - Citizens get one word, Undercover gets related word
   
3. **Game Rounds** 
   - Description phase (each player describes their word)
   - Voting phase (vote for suspected Undercover)
   - Elimination or tie handling
   
4. **Win Detection** 
   - Check win conditions after each round
   - Show game results

##  Design Features

- **Material Design 3** 
- **Mobile-responsive layout**
- **Intuitive touch interface** 
- **Card-based design** 
- **Color scheme** with indigo theme

## Technical Details

- **Flutter Framework:** Latest stable version
- **State Management:** Built-in setState (suitable for game scope)
- **Platform Support:** Android