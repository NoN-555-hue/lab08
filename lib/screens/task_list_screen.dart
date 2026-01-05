import 'package:flutter/material.dart';

class Team {
  String id;
  int rank;
  String name;
  final String logoUrl;
  int points;

  Team({
    required this.id,
    required this.rank,
    required this.name,
    required this.logoUrl,
    required this.points,
  });
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Team> _teams;

  @override
  void initState() {
    super.initState();
    _teams = [
      Team(
        id: 'mc',
        rank: 1,
        name: 'Manchester City',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/en/thumb/e/eb/Manchester_City_FC_badge.svg/120px-Manchester_City_FC_badge.svg.png',
        points: 86,
      ),
      Team(
        id: 'ars',
        rank: 2,
        name: 'Arsenal',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/en/thumb/5/53/Arsenal_FC.svg/120px-Arsenal_FC.svg.png',
        points: 83,
      ),
      Team(
        id: 'mu',
        rank: 3,
        name: 'Manchester United',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Manchester_United_FC_crest.svg/120px-Manchester_United_FC_crest.svg.png',
        points: 75,
      ),
      Team(
        id: 'liv',
        rank: 4,
        name: 'Liverpool',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Liverpool_FC.svg/120px-Liverpool_FC.svg.png',
        points: 72,
      ),
      Team(
        id: 'chel',
        rank: 5,
        name: 'Chelsea',
        logoUrl:
            'https://upload.wikimedia.org/wikipedia/en/thumb/c/cc/Chelsea_FC.svg/120px-Chelsea_FC.svg.png',
        points: 68,
      ),
    ];
  }

  void _recalculateRanks() {
    for (var i = 0; i < _teams.length; i++) {
      _teams[i].rank = i + 1;
      _teams[i].id = '${_teams[i].name}#${_teams[i].points}';
    }
    setState(() {});
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _teams.removeAt(oldIndex);
      _teams.insert(newIndex, item);
      _recalculateRanks();
    });
  }

  void _removeById(String id) {
    setState(() {
      _teams.removeWhere((t) => t.id == id);
      _recalculateRanks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premier League — Table (Top 5)'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // Header row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 40, child: Text('#')),
                      SizedBox(width: 56, child: Text('Logo')),
                      Expanded(child: Text('Team')),
                      SizedBox(
                        width: 64,
                        child: Text('Points', textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Reorderable & Dismissible list
                Expanded(
                  child: ReorderableListView.builder(
                    onReorder: _onReorder,
                    buildDefaultDragHandles: false,
                    itemCount: _teams.length,
                    itemBuilder: (context, index) {
                      final t = _teams[index];
                      return Dismissible(
                        key: ValueKey(t.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('ลบทีม'),
                              content: Text(
                                'คุณแน่ใจว่าต้องการลบ "${t.name}" หรือไม่?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text(
                                    'ลบ',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                          return confirm == true;
                        },
                        onDismissed: (_) => _removeById(t.id),
                        child: Container(
                          key: ValueKey('row-${t.id}'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: Text('${t.rank}')),
                              SizedBox(
                                width: 56,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(t.logoUrl),
                                  radius: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(t.name)),
                              SizedBox(
                                width: 64,
                                child: Text(
                                  '${t.points}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              // Drag handle
                              ReorderableDragStartListener(
                                index: index,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(Icons.drag_handle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
