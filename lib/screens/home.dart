import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/todo.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  int _navIndex = 1;

  static const _icons = [
    Icons.format_list_bulleted,
    Icons.chat_bubble_outline,
    Icons.access_time,
    Icons.radio_button_unchecked,
  ];

  @override
  void initState() {
    _foundToDo = List.from(todosList);
    super.initState();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() => todo.isDone = !todo.isDone);
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _foundToDo.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) {
    if (toDo.trim().isEmpty) return;
    setState(() {
      todosList.add(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: toDo,
      ));
      _foundToDo = List.from(todosList);
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results;
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() => _foundToDo = List.from(results));
  }

  @override
  Widget build(BuildContext context) {
    final active = _foundToDo.where((t) => !t.isDone).toList();
    final finished = _foundToDo.where((t) => t.isDone).toList();

    return Scaffold(
      backgroundColor: tdBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              children: [
                _searchBox(),
                _sectionTitle("Fokus Hari Ini"),
                for (final t in active) _item(t),
                if (finished.isNotEmpty) _sectionTitle('Selesai'),
                for (final t in finished) _item(t),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _addBar(),
          CurvedNavBar(
            index: _navIndex,
            icons: const [
              Icons.calendar_today_outlined,
              Icons.format_list_bulleted,
              Icons.settings_outlined,
            ],
            onTap: (i) => setState(() => _navIndex = i),
          ),
        ],
      ),
    );
  }

  Widget _item(ToDo t) {
    final idx = todosList.indexOf(t) % _icons.length;
    return ToDoItem(
      todo: t,
      icon: _icons[idx],
      onToDoChanged: _handleToDoChange,
      onDeleteItem: _deleteToDoItem,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 34),
      decoration: BoxDecoration(
        color: tdCard,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: tdBlue.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Text(
        'Team 1 Apps',
        style: TextStyle(
          color: tdText,
          fontSize: 28,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: tdCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        onChanged: _runFilter,
        style: const TextStyle(color: tdText),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: tdGrey, size: 20),
          border: InputBorder.none,
          hintText: 'Cari Rencana...',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 26, bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          color: tdGrey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _addBar() {
    return Container(
      color: tdBg,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: tdCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _todoController,
                style: const TextStyle(color: tdText),
                onSubmitted: _addToDoItem,
                decoration: const InputDecoration(
                  hintText: 'Buat rencana baru...',
                  hintStyle: TextStyle(color: tdGrey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _addToDoItem(_todoController.text),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: tdBlue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: tdBlue.withOpacity(0.5), blurRadius: 14),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

/// Navigasi bawah melengkung dengan bubble yang bergeser ke item aktif.
class CurvedNavBar extends StatelessWidget {
  final int index;
  final List<IconData> icons;
  final ValueChanged<int> onTap;

  const CurvedNavBar({
    super.key,
    required this.index,
    required this.icons,
    required this.onTap,
  });

  static const double _topY = 26; // tinggi area bubble di atas bar
  static const double _height = 82;
  static const double _bubble = 54;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final itemW = width / icons.length;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: index.toDouble()),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            builder: (context, pos, _) {
              final cx = (pos + 0.5) * itemW;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Bar dengan lekukan
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _NavPainter(cx: cx, topY: _topY),
                    ),
                  ),
                  // Ikon yang tidak aktif
                  Positioned.fill(
                    top: _topY,
                    child: Row(
                      children: List.generate(icons.length, (i) {
                        final selected = i == index;
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => onTap(i),
                            child: Center(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: selected ? 0 : 1,
                                child: Icon(icons[i], color: tdGrey, size: 26),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Bubble aktif
                  Positioned(
                    left: cx - _bubble / 2,
                    top: 0,
                    child: IgnorePointer(
                      child: Container(
                        width: _bubble,
                        height: _bubble,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tdBlue,
                          boxShadow: [
                            BoxShadow(
                              color: tdBlue.withOpacity(0.6),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Icon(icons[index], color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _NavPainter extends CustomPainter {
  final double cx;
  final double topY;

  _NavPainter({required this.cx, required this.topY});

  @override
  void paint(Canvas canvas, Size size) {
    const half = 46.0; // lebar lekukan
    const depth = 36.0; // kedalaman lekukan
    final rl = (cx - half).clamp(0.0, 22.0);
    final rr = (size.width - cx - half).clamp(0.0, 22.0);

    final path = Path()
      ..moveTo(0, topY + rl)
      ..quadraticBezierTo(0, topY, rl, topY)
      ..lineTo(cx - half, topY)
      ..cubicTo(cx - 28, topY, cx - 34, topY + depth, cx, topY + depth)
      ..cubicTo(cx + 34, topY + depth, cx + 28, topY, cx + half, topY)
      ..lineTo(size.width - rr, topY)
      ..quadraticBezierTo(size.width, topY, size.width, topY + rr)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // glow biru tipis di tepi atas
    canvas.drawPath(
      path,
      Paint()
        ..color = tdBlue.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawPath(path, Paint()..color = tdCard);
  }

  @override
  bool shouldRepaint(covariant _NavPainter old) => old.cx != cx;
}