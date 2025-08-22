import 'package:flutter/material.dart';

class Player {
  final String name;
  final PlayerRole role;
  final String word;

  Player({
    required this.name,
    required this.role,
    required this.word,
  });
}

enum PlayerRole {
  citizen,
  undercover,
}

class WordPair {
  final String citizenWord;
  final String undercoverWord;

  WordPair({
    required this.citizenWord,
    required this.undercoverWord,
  });
}

final List<WordPair> wordPairs = [
  WordPair(citizenWord: "Cat", undercoverWord: "Tiger"),
  WordPair(citizenWord: "Coffee", undercoverWord: "Tea"),
  WordPair(citizenWord: "Ship", undercoverWord: "Boat"),
  WordPair(citizenWord: "Pizza", undercoverWord: "Burger"),
  WordPair(citizenWord: "Book", undercoverWord: "Magazine"),
  WordPair(citizenWord: "Rain", undercoverWord: "Snow"),
  WordPair(citizenWord: "Guitar", undercoverWord: "Piano"),
  WordPair(citizenWord: "Apple", undercoverWord: "Orange"),
  WordPair(citizenWord: "Beach", undercoverWord: "Mountain"),
  WordPair(citizenWord: "Car", undercoverWord: "Bike"),
];

void main() {
  runApp(const UndercoverApp());
}

class UndercoverApp extends StatelessWidget {
  const UndercoverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Undercover Party Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SetupScreen(),
    );
  }
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _playerCount = 3;
  final List<TextEditingController> _nameControllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<String> _playerNames = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Auto-focus the first field after the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty && mounted) {
        // Add a small delay to ensure proper focus on web
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _focusNodes.isNotEmpty) {
            _focusNodes[0].requestFocus();
          }
        });
      }
    });
  }

  void _initializeControllers() {
    // Save existing names before clearing
    List<String> existingNames = [];
    for (int i = 0; i < _nameControllers.length; i++) {
      existingNames.add(_nameControllers[i].text.trim());
    }

    // Clear controllers and focus nodes, dispose of them properly
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _nameControllers.clear();
    _focusNodes.clear();
    _playerNames.clear();

    // Create new controllers, focus nodes and restore existing names
    for (int i = 0; i < _playerCount; i++) {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      // Restore existing name if available
      if (i < existingNames.length && existingNames[i].isNotEmpty) {
        controller.text = existingNames[i];
      }

      _nameControllers.add(controller);
      _focusNodes.add(focusNode);
      _playerNames.add('');
    }
  }

  void _updatePlayerCount(int newCount) {
    setState(() {
      _playerCount = newCount;
      _initializeControllers();
    });
  }

  bool _areAllNamesValid() {
    for (int i = 0; i < _playerCount; i++) {
      if (_nameControllers[i].text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  void _startGame() {
    if (!_areAllNamesValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter names for all players'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Collect player names
    List<String> playerNames = [];
    for (int i = 0; i < _playerCount; i++) {
      playerNames.add(_nameControllers[i].text.trim());
    }

    // Navigate to role distribution screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoleDistributionScreen(playerNames: playerNames),
      ),
    );
  }

  void _moveToNextField(int currentIndex) {
    if (currentIndex < _playerCount - 1) {
      // Move to next field
      _focusNodes[currentIndex + 1].requestFocus();
    } else {
      // Last field, remove focus (close keyboard)
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Undercover Game Setup',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Game description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.group,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Welcome to Undercover!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'A social deduction game where Citizens must find the Undercover player through word descriptions and voting.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Player count selection
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Number of Players',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _playerCount > 3
                                ? () => _updatePlayerCount(_playerCount - 1)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                            iconSize: 32,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_playerCount',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _playerCount < 12
                                ? () => _updatePlayerCount(_playerCount + 1)
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Minimum 3 players, Maximum 12 players',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Player names input
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Player Names',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            children: List.generate(_playerCount, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _nameControllers[index],
                                    focusNode: _focusNodes[index],
                                    decoration: InputDecoration(
                                      labelText: 'Player ${index + 1}',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: index < _playerCount - 1
                                        ? TextInputAction.next
                                        : TextInputAction.done,
                                    onFieldSubmitted: (value) =>
                                        _moveToNextField(index),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Start game button
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _startGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Start Game',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Role Distribution Screen
class RoleDistributionScreen extends StatefulWidget {
  final List<String> playerNames;

  const RoleDistributionScreen({
    super.key,
    required this.playerNames,
  });

  @override
  State<RoleDistributionScreen> createState() => _RoleDistributionScreenState();
}

class _RoleDistributionScreenState extends State<RoleDistributionScreen> {
  List<Player> players = [];
  WordPair? selectedWordPair;
  int currentPlayerIndex = 0;
  bool showingRole = false;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    // Select a random word pair
    selectedWordPair =
        wordPairs[DateTime.now().millisecondsSinceEpoch % wordPairs.length];

    // Randomly select one player to be the undercover
    final random = DateTime.now().millisecondsSinceEpoch;
    final undercoverIndex = random % widget.playerNames.length;

    // Create player objects with roles and words
    players = widget.playerNames.asMap().entries.map((entry) {
      final index = entry.key;
      final name = entry.value;
      final isUndercover = index == undercoverIndex;

      return Player(
        name: name,
        role: isUndercover ? PlayerRole.undercover : PlayerRole.citizen,
        word: isUndercover
            ? selectedWordPair!.undercoverWord
            : selectedWordPair!.citizenWord,
      );
    }).toList();
  }

  void _showNextPlayer() {
    if (currentPlayerIndex < players.length) {
      setState(() {
        showingRole = true;
      });
    }
  }

  void _hideRole() {
    setState(() {
      showingRole = false;
      currentPlayerIndex++;
    });
  }

  void _startGameRounds() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameRoundsScreen(
          players: players,
          wordPair: selectedWordPair!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentPlayerIndex >= players.length) {
      // All players have seen their roles
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Ready to Play!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'All Players Ready!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Everyone has received their secret role and word.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _startGameRounds,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Start Game Rounds',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentPlayer = players[currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Role Distribution (${currentPlayerIndex + 1}/${players.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: showingRole
              ? _buildRoleReveal(currentPlayer)
              : _buildPlayerReady(currentPlayer),
        ),
      ),
    );
  }

  Widget _buildPlayerReady(Player player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(
                  Icons.person,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Get ready, ${player.name}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You are about to see your secret role and word.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Make sure other players cannot see your screen!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _showNextPlayer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility, size: 24),
              SizedBox(width: 8),
              Text(
                'Show My Role',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleReveal(Player player) {
    final isUndercover = player.role == PlayerRole.undercover;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          color: isUndercover ? Colors.red[50] : Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(
                  isUndercover ? Icons.security : Icons.shield,
                  size: 64,
                  color: isUndercover ? Colors.red : Colors.blue,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hello, ${player.name}!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUndercover ? Colors.red[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Role:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isUndercover ? 'UNDERCOVER' : 'CITIZEN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              isUndercover ? Colors.red[700] : Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Secret Word:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        player.word,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isUndercover
                      ? 'Blend in with the Citizens! Describe your word without revealing you\'re different.'
                      : 'Find the Undercover! They have a related but different word.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _hideRole,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.visibility_off, size: 24),
              const SizedBox(width: 8),
              Text(
                currentPlayerIndex < players.length - 1
                    ? 'Next Player'
                    : 'Continue to Game',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Game Rounds Screen
class GameRoundsScreen extends StatefulWidget {
  final List<Player> players;
  final WordPair wordPair;

  const GameRoundsScreen({
    super.key,
    required this.players,
    required this.wordPair,
  });

  @override
  State<GameRoundsScreen> createState() => _GameRoundsScreenState();
}

class _GameRoundsScreenState extends State<GameRoundsScreen> {
  int currentRound = 1;
  int currentPlayerIndex = 0;
  GamePhase currentPhase = GamePhase.description;
  List<Player> alivePlayers = [];
  List<String> descriptions = [];
  Map<String, String> votes = {}; // voter name -> voted player name
  List<String> eliminatedPlayers = [];
  bool showWord = false; // Track whether to show the secret word

  @override
  void initState() {
    super.initState();
    alivePlayers = List.from(widget.players);
  }

  void _nextPlayer() {
    setState(() {
      if (currentPhase == GamePhase.description) {
        showWord = false; // Reset word visibility for next player
        currentPlayerIndex++;
        if (currentPlayerIndex >= alivePlayers.length) {
          // All players have given descriptions, move to discussion
          currentPhase = GamePhase.discussion;
          currentPlayerIndex = 0;
        }
      }
    });
  }

  void _toggleWordVisibility() {
    setState(() {
      showWord = !showWord;
    });
  }

  void _startVoting() {
    setState(() {
      currentPhase = GamePhase.voting;
      currentPlayerIndex = 0;
      votes.clear();
    });
  }

  void _castVote(String voterName, String votedPlayerName) {
    setState(() {
      votes[voterName] = votedPlayerName;
      currentPlayerIndex++;

      if (currentPlayerIndex >= alivePlayers.length) {
        // All votes cast, show results
        currentPhase = GamePhase.results;
      }
    });
  }

  void _processVoteResults() {
    // Count votes
    Map<String, int> voteCount = {};
    for (String votedPlayer in votes.values) {
      voteCount[votedPlayer] = (voteCount[votedPlayer] ?? 0) + 1;
    }

    // Find player(s) with most votes and check for ties
    String? eliminatedPlayer;
    int maxVotes = 0;
    List<String> playersWithMaxVotes = [];

    for (var entry in voteCount.entries) {
      if (entry.value > maxVotes) {
        maxVotes = entry.value;
        playersWithMaxVotes = [entry.key];
        eliminatedPlayer = entry.key;
      } else if (entry.value == maxVotes) {
        playersWithMaxVotes.add(entry.key);
      }
    }

    // Check if there's a tie (more than one player with max votes)
    bool isTie = playersWithMaxVotes.length > 1;

    if (isTie) {
      // No elimination due to tie, proceed to next round
      eliminatedPlayer = null;
    }

    setState(() {
      if (eliminatedPlayer != null && !isTie) {
        // Normal elimination
        alivePlayers.removeWhere((player) => player.name == eliminatedPlayer);
        eliminatedPlayers.add(eliminatedPlayer);
      }

      // Check win conditions (only if someone was eliminated)
      if (!isTie && _checkWinCondition()) {
        currentPhase = GamePhase.gameOver;
      } else {
        // Start next round (whether due to tie or normal progression)
        currentRound++;
        currentPhase = GamePhase.description;
        currentPlayerIndex = 0;
        descriptions.clear();
      }
    });
  }

  bool _checkWinCondition() {
    int undercoverCount =
        alivePlayers.where((p) => p.role == PlayerRole.undercover).length;
    int citizenCount =
        alivePlayers.where((p) => p.role == PlayerRole.citizen).length;

    // Undercover wins if they equal or outnumber citizens
    // Citizens win if all undercover are eliminated
    return undercoverCount == 0 || undercoverCount >= citizenCount;
  }

  String _getWinner() {
    int undercoverCount =
        alivePlayers.where((p) => p.role == PlayerRole.undercover).length;
    return undercoverCount == 0 ? 'Citizens' : 'Undercover';
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPhase) {
      case GamePhase.description:
        return _buildDescriptionPhase();
      case GamePhase.discussion:
        return _buildDiscussionPhase();
      case GamePhase.voting:
        return _buildVotingPhase();
      case GamePhase.results:
        return _buildResultsPhase();
      case GamePhase.gameOver:
        return _buildGameOverPhase();
    }
  }

  Widget _buildDescriptionPhase() {
    Player currentPlayer = alivePlayers[currentPlayerIndex];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Round $currentRound - Descriptions',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.record_voice_over,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${currentPlayer.name}\'s Turn',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Describe your word without saying it!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (showWord) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Text(
                              'Your word: ${currentPlayer.word}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        ElevatedButton(
                          onPressed: _toggleWordVisibility,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                showWord ? Colors.grey[600] : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                showWord
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                showWord ? 'Hide Word' : 'Show My Word',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Player ${currentPlayerIndex + 1} of ${alivePlayers.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextPlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    currentPlayerIndex < alivePlayers.length - 1
                        ? Icons.arrow_forward
                        : Icons.forum,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currentPlayerIndex < alivePlayers.length - 1
                        ? 'Next Player'
                        : 'Start Discussion',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionPhase() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Round $currentRound - Discussion',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.forum,
                          size: 64,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Discussion Time!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Discuss the descriptions and try to figure out who the undercover player is.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Players remaining: ${alivePlayers.length}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startVoting,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.how_to_vote, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Start Voting',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVotingPhase() {
    Player currentVoter = alivePlayers[currentPlayerIndex];
    List<Player> votableOptions =
        alivePlayers.where((p) => p.name != currentVoter.name).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Round $currentRound - Voting',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.how_to_vote,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${currentVoter.name}\'s Vote',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Who do you think is the undercover player?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: votableOptions.length,
                itemBuilder: (context, index) {
                  Player option = votableOptions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          option.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      title: Text(
                        option.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _castVote(currentVoter.name, option.name),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Voter ${currentPlayerIndex + 1} of ${alivePlayers.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsPhase() {
    // Count votes
    Map<String, int> voteCount = {};
    Map<String, List<String>> votersByCandidate = {};

    for (var entry in votes.entries) {
      String voter = entry.key;
      String candidate = entry.value;
      voteCount[candidate] = (voteCount[candidate] ?? 0) + 1;
      votersByCandidate[candidate] = (votersByCandidate[candidate] ?? [])
        ..add(voter);
    }

    // Find eliminated player and check for ties
    String? eliminatedPlayer;
    int maxVotes = 0;
    List<String> playersWithMaxVotes = [];

    for (var entry in voteCount.entries) {
      if (entry.value > maxVotes) {
        maxVotes = entry.value;
        playersWithMaxVotes = [entry.key];
        eliminatedPlayer = entry.key;
      } else if (entry.value == maxVotes) {
        playersWithMaxVotes.add(entry.key);
      }
    }

    // Check if there's a tie
    bool isTie = playersWithMaxVotes.length > 1;
    if (isTie) {
      eliminatedPlayer = null; // No elimination due to tie
    }

    Player? eliminatedPlayerObj;
    try {
      eliminatedPlayerObj =
          alivePlayers.firstWhere((p) => p.name == eliminatedPlayer);
    } catch (e) {
      eliminatedPlayerObj = null;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Round $currentRound - Results',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.poll,
                          size: 64,
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Voting Results',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isTie) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'It\'s a Tie!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${playersWithMaxVotes.join(', ')} are tied with $maxVotes vote${maxVotes > 1 ? 's' : ''} each',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No elimination this round!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ] else if (eliminatedPlayer != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            '$eliminatedPlayer was eliminated!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'They were a ${eliminatedPlayerObj?.role == PlayerRole.citizen ? 'Citizen' : 'Undercover'}!',
                            style: TextStyle(
                              fontSize: 16,
                              color: eliminatedPlayerObj?.role ==
                                      PlayerRole.citizen
                                  ? Colors.blue[700]
                                  : Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: voteCount.length,
                itemBuilder: (context, index) {
                  String playerName = voteCount.keys.elementAt(index);
                  int votes = voteCount[playerName]!;
                  List<String> voters = votersByCandidate[playerName] ?? [];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isTie && playersWithMaxVotes.contains(playerName)
                        ? Colors.orange[50]
                        : playerName == eliminatedPlayer
                            ? Colors.red[50]
                            : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isTie && playersWithMaxVotes.contains(playerName)
                                ? Colors.orange[200]
                                : playerName == eliminatedPlayer
                                    ? Colors.red[200]
                                    : Colors.grey[200],
                        child: Text(
                          votes.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        playerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isTie && playersWithMaxVotes.contains(playerName)
                                  ? Colors.orange[700]
                                  : playerName == eliminatedPlayer
                                      ? Colors.red[700]
                                      : null,
                        ),
                      ),
                      subtitle: Text(
                        'Voted by: ${voters.join(', ')}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _processVoteResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: isTie
                    ? Colors.orange
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_forward, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    isTie ? 'Next Round' : 'Continue',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverPhase() {
    String winner = _getWinner();
    List<Player> winners = alivePlayers
        .where((p) =>
            (winner == 'Citizens' && p.role == PlayerRole.citizen) ||
            (winner == 'Undercover' && p.role == PlayerRole.undercover))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Game Over',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 64,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$winner Win!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Winners:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...winners.map((player) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                '${player.name} (${player.role == PlayerRole.citizen ? 'Citizen' : 'Undercover'})',
                                style: const TextStyle(fontSize: 16),
                              ),
                            )),
                        const SizedBox(height: 16),
                        Text(
                          'Word Pair: ${widget.wordPair.citizenWord} / ${widget.wordPair.undercoverWord}',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetupScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, size: 20),
                      SizedBox(width: 8),
                      Text('New Game'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Game Phase enum
enum GamePhase {
  description,
  discussion,
  voting,
  results,
  gameOver,
}
