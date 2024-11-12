import 'package:flutter/material.dart';
import 'package:sqllite/models/sql_data_model.dart';
import 'default_text_field.dart';

class AddTaskLocal extends StatefulWidget {
  final SqlDataModel? todo;
  final ValueChanged<Map<String, String>> onSubmit;
  const AddTaskLocal({
    super.key,
    this.todo,
    required this.onSubmit,
  });

  @override
  State<AddTaskLocal> createState() => _AddTaskLocalState();
}

class _AddTaskLocalState extends State<AddTaskLocal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30,
          bottom: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextField(
              controller: _titleController,
              hintText: 'Name',
            ),
            const SizedBox(
              height: 15,
            ),
            DefaultTextField(
              keyboardType: TextInputType.number,
              controller: _descriptionController,
              hintText: 'Price',
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Set border radius here
                  ),
                  backgroundColor: Colors.green, // Set the button color to red
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final name = _titleController.text;
                  final price = _descriptionController.text;
                  widget.onSubmit({
                    'name': name,
                    'price': price,
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
