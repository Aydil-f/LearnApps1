import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: tdCardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: todo.isDone
              ? tdGlowBlue.withOpacity(0.3)
              : Colors.white.withOpacity(0.06),
          width: 1.2,
        ),
        boxShadow: [
          // Efek Glow Halus di Sekeliling Kartu
          BoxShadow(
            color: todo.isDone
                ? tdGlowBlue.withOpacity(0.15)
                : Colors.black.withOpacity(0.3),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => onToDoChanged(todo),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: todo.isDone ? tdGlowBlue : tdTextMuted,
              width: 1.8,
            ),
            boxShadow: todo.isDone
                ? [
                    BoxShadow(
                      color: tdGlowBlue.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: todo.isDone
              ? const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: tdGlowBlue,
                )
              : null,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: todo.isDone ? tdTextMuted : tdTextLight,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            decorationColor: tdTextMuted,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          color: tdTextMuted.withOpacity(0.6),
          onPressed: () => onDeleteItem(todo.id!),
        ),
      ),
    );
  }
}