import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'calendar_screen.dart';
import 'package:get_storage/get_storage.dart';

class EventInputScreen extends StatefulWidget {
  const EventInputScreen({Key? key}) : super(key: key);

  @override
  _EventInputScreenState createState() => _EventInputScreenState();
}

class _EventInputScreenState extends State<EventInputScreen> {
  final server = dotenv.env['WUP_SERVER']!;
  final email = GetStorage().read('email');

  late TextEditingController _titleController;
  late DateTime? _startDate;
  late DateTime? _endDate = DateTime.now();
  bool _isEndDateEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _startDate = DateTime.now();
    // _endDate = DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final initialDate = _startDate ?? DateTime.now();
    final newStartDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newStartDate != null) {
      setState(() {
        _startDate = newStartDate;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final initialDate = _endDate ?? _startDate ?? DateTime.now();
    final newEndDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newEndDate != null) {
      setState(() {
        _endDate = newEndDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _selectStartDate,
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_startDate!),
                    ),
                  ),
                ),
              ],
            ),
            if (_isEndDateEnabled)
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _selectEndDate,
                      child: Text(
                        _endDate != null
                            ? DateFormat('yyyy-MM-dd').format(_endDate!)
                            : 'Select end date',
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Checkbox(
                  value: _isEndDateEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isEndDateEnabled = value!;
                    });
                  },
                ),
                const Text('End Date'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')));
                  return;
                }
                if (_startDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please select a start date')));
                  return;
                }
                if (_isEndDateEnabled && _endDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please select an end date')));
                  return;
                }
                if (_isEndDateEnabled && _endDate!.isBefore(_startDate!)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('End date must be after start date')));
                  return;
                }

                final event = Event(
                  null,
                  _titleController.text,
                  _startDate!,
                  _isEndDateEnabled ? _endDate! : _startDate!,
                );

                final response = await http.post(
                  Uri.parse('$server/calendars/events/$email/'),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                  body: jsonEncode(event.toJson()),
                );

                if (response.statusCode == 201) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add event')));
                }
              },
              child: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
