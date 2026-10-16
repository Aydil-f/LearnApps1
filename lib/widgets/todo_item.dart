import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final IconData icon;
  final void Function(ToDo todo) onToDoChanged;
  final void Function(String id) onDeleteItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.icon,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    final done = todo.isDone;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: done
            ? [BoxShadow(color: tdBlue.withOpacity(0.25), blurRadius: 14)]
            : [],
      ),
      child: ListTile(
        onTap: () => onToDoChanged(todo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: done ? tdBlue.withOpacity(0.6) : Colors.white10,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        tileColor: tdCard,
        leading: Icon(
          done ? Icons.check_circle : icon,
          color: done ? tdBlue : tdGrey,
        ),
        title: Text(
          todo.todoText ?? '',
          style: TextStyle(
            fontSize: 16,
            color: done ? tdGrey : tdText,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 20),
          color: tdGrey,
          onPressed: () => onDeleteItem(todo.id!),
        ),
      ),
    );
  }
}