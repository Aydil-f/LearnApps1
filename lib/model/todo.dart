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
      ToDo(id: '01', todoText: "Tugas Pemrograman Mobile", isDone: true),
      ToDo(id: '02', todoText: 'Jadi Wapres (Opsional)', isDone: false),
      ToDo(id: '03', todoText: 'Lari Pagi (2 KM)', isDone: false),
      ToDo(id: '04', todoText: 'Push Tugas', isDone: false),
    ];
  }
}