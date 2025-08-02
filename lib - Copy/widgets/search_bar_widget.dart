import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      await _speechToText.initialize();
    } catch (e) {
      print('Speech initialization failed: $e');
    }
  }

  void _startListening() async {
    try {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {
        _isListening = true;
      });
    } catch (e) {
      print('Speech listening failed: $e');
    }
  }

  void _stopListening() async {
    try {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    } catch (e) {
      print('Speech stop failed: $e');
    }
  }

  void _onSpeechResult(result) {
    setState(() {
      _controller.text = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search courses, topics...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.grey,
            ),
            onPressed: _isListening ? _stopListening : _startListening,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        onSubmitted: (value) {
          // Handle search
          print('Searching for: $value');
        },
      ),
    );
  }
}
