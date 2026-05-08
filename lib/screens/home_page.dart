import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SizedBox.expand(
        child: Consumer<NoteProvider>(
          builder: (context, provider, child) {
            if (provider.notes.isEmpty) {
              return const Center(
                child: Text('Chưa có ghi chú nào. Hãy tạo mới nhé!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index];
                return NoteCard(
                  note: note,
                  onTap: () => _editNote(note),
                  onDelete: () => _deleteNoteConfirm(context, note),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editNote(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editNote(Note? note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    );
  }

  void _deleteNoteConfirm(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa ghi chú này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}