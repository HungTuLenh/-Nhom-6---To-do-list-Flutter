import 'package:flutter/material.dart';
import 'todo_service.dart';
import 'todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoService api = TodoService();
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  fetchTodos() async {
    final results = await api.getTodos();
    setState(() {
      todos = results;
    });
  }

  addTodo() async {
    TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm công việc mới'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nhập tên công việc"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                String newTitle = controller.text;
                if (newTitle.isNotEmpty) {
                  final newTodo = await api.createTodo(newTitle);
                  setState(() {
                    todos.add(newTodo);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  updateTodo(Todo todo) async {
    final updatedTodo = await api.updateTodo(todo.id, todo.title, !todo.completed);
    setState(() {
      int index = todos.indexOf(todo);
      todos[index] = updatedTodo;
    });
  }

  deleteTodo(Todo todo) async {
    await api.deleteTodo(todo.id);
    setState(() {
      todos.remove(todo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addTodo,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    updateTodo(todo);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteTodo(todo);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
