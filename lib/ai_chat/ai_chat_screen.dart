import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/data/network/gemini_service.dart';
import '../movies/selection/movie_selection_repository.dart'; // ⭐️ Film verilerini almak için

List<String> _genres = [];
List<String> _titles = [];

final geminiService = GeminiService();

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final MovieSelectionRepository _repository = MovieSelectionRepository();

  @override
  void initState() {
    super.initState();
    _sendInitialPrompt(); // Otomatik prompt gönder
  }

  Future<void> _sendInitialPrompt() async {
    final allSelectedMovies = await _repository.getSelectedMovies();

    if (allSelectedMovies.isEmpty) return;

    _genres = allSelectedMovies.expand((e) => e.genres).toSet().toList();
    _titles = allSelectedMovies.map((e) => e.title).take(5).toList();

    // İlk AI mesajı: isteğe bağlı olarak kullanıcıya bir selam veya öneri atabiliriz
    const initialUserPrompt = 'Merhaba!';

    setState(() {
      _messages.add({"role": "user", "text": initialUserPrompt});
      _messages.add({"role": "ai", "text": "Cevap hazırlanıyor..."});
    });

    final response = await geminiService.getGeminiResponse(
      userInput: initialUserPrompt,
      genres: _genres,
      titles: _titles,
    );

    setState(() {
      _messages.removeLast();
      _messages.add({"role": "ai", "text": response});
    });
  }

  void _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": input});
      _messages.add({"role": "ai", "text": "Cevap hazırlanıyor..."});
    });

    _controller.clear();

    final response = await geminiService.getGeminiResponse(
      userInput: input,
      genres: _genres,
      titles: _titles,
    );

    setState(() {
      _messages.removeLast();
      _messages.add({"role": "ai", "text": response});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Container(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.red : Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isUser ? 12 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Mesaj yaz...',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.red,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
