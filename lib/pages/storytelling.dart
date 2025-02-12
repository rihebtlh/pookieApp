import 'package:flutter/material.dart';
import 'text_correction_service.dart';

class TextCorrectionScreen extends StatefulWidget {
  const TextCorrectionScreen({super.key});

  @override
  _TextCorrectionScreenState createState() => _TextCorrectionScreenState();
}

class _TextCorrectionScreenState extends State<TextCorrectionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _correctedText = '';
  bool _isLoading = false;

  void _correctText() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String corrected = await TextCorrectionService().correctText(_controller.text);
      setState(() {
        _correctedText = corrected;
      });
    } catch (e) {
      setState(() {
        _correctedText = 'Error occurred while correcting text.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Correction AI Bot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Enter text to correct',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _correctText,
                    child: Text('Correct Text'),
                  ),
            SizedBox(height: 16),
            Text(
              'Corrected Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _correctedText.isNotEmpty ? _correctedText : 'No corrections yet.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
