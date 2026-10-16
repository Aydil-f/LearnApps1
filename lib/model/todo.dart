class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Push Tugas'),
      ToDo(id: '02', todoText: 'Lari Pagi (2 KM)'),
      ToDo(id: '03', todoText: 'Jadi Wapres (Opsional)'),
      ToDo(id: '04', todoText: 'Tugas Pemrograman Mobile', isDone: true),
    ];
  }
}