import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo.dart';

class TodoService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Todo> todos = body.map((dynamic item) => Todo.fromJson(item)).toList();
      return todos;
    } else {
      throw "Không thể lấy danh sách công việc.";
    }
  }

  // Thêm công việc mới
  Future<Todo> createTodo(String title) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "completed": false}),
    );

    if (response.statusCode == 201) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw "Không thể tạo công việc.";
    }
  }

  // Cập nhật công việc
  Future<Todo> updateTodo(int id, String title, bool completed) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "completed": completed}),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    } else {
      throw "Không thể cập nhật công việc.";
    }
  }

  // Xóa công việc
  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw "Không thể xóa công việc.";
    }
  }
}
