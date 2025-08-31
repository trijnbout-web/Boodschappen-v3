import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const BoodschappenApp());
}

class BoodschappenApp extends StatelessWidget {
  const BoodschappenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gezin Boodschappen App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BoodschappenPagina(),
    );
  }
}

class BoodschappenPagina extends StatefulWidget {
  const BoodschappenPagina({super.key});

  @override
  State<BoodschappenPagina> createState() => _BoodschappenPaginaState();
}

class _BoodschappenPaginaState extends State<BoodschappenPagina> {
  List<Map<String, dynamic>> _boodschappen = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("boodschappen");
    if (data != null) {
      setState(() {
        _boodschappen = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("boodschappen", jsonEncode(_boodschappen));
  }

  void _addBoodschap(String naam, {bool vast = false}) {
    setState(() {
      _boodschappen.add({"naam": naam, "vast": vast});
    });
    _saveData();
  }

  void _removeBoodschap(int index) {
    setState(() {
      _boodschappen.removeAt(index);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boodschappenlijst")),
      body: ListView.builder(
        itemCount: _boodschappen.length,
        itemBuilder: (context, index) {
          final item = _boodschappen[index];
          return ListTile(
            title: Text(item["naam"]),
            leading: item["vast"] ? const Icon(Icons.push_pin, color: Colors.orange) : null,
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeBoodschap(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              bool vast = false;
              return AlertDialog(
                title: const Text("Nieuwe boodschap"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: _controller, decoration: const InputDecoration(hintText: "Productnaam")),
                    Row(
                      children: [
                        Checkbox(
                          value: vast,
                          onChanged: (value) {
                            setState(() {
                              vast = value ?? false;
                            });
                          },
                        ),
                        const Text("Elke week toevoegen"),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Annuleren"),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _addBoodschap(_controller.text, vast: vast);
                        _controller.clear();
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Toevoegen"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
