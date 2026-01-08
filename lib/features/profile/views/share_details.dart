import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareDetails extends ConsumerWidget {
  const ShareDetails({super.key});

  final List<String> titles = const [
    'Topics',
    'Script',
    'Audios',
    'Chat: All Users',
    'Chat: Linked to Me',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: titles
            .map(
              (title) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: _ShareDetailRow(title: title),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ShareDetailRow extends StatefulWidget {
  const _ShareDetailRow({required this.title});
  final String title;

  @override
  State<_ShareDetailRow> createState() => _ShareDetailRowState();
}

class _ShareDetailRowState extends State<_ShareDetailRow> {
  bool isChecked = false; // Track check/uncheck state

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF024B3A),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter value',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (newValue) {
                // Optional: handle text input per row
              },
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isChecked = !isChecked; // toggle state
              });
            },
            child: Icon(
              isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isChecked ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
