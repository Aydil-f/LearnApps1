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
        children: [_addBar(), _buildBottomNav()],
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
          hintText: 'Cari rencana...',
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
                  hintText: 'Tambahkan rencana baru...',
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

  Widget _buildBottomNav() {
    const icons = [
      Icons.calendar_today_outlined,
      Icons.format_list_bulleted,
      Icons.settings_outlined,
    ];
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 18),
      decoration: BoxDecoration(
        color: tdCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: tdBlue.withOpacity(0.2), blurRadius: 18),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (i) {
          final selected = _navIndex == i;
          return IconButton(
            onPressed: () => setState(() => _navIndex = i),
            icon: Icon(
              icons[i],
              size: 28,
              color: selected ? tdBlue : tdGrey,
              shadows: selected
                  ? [Shadow(color: tdBlue.withOpacity(0.9), blurRadius: 14)]
                  : null,
            ),
          );
        }),
      ),
    );
  }
}