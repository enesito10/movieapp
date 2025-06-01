import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/core/data/network/api_constants.dart';
import '../../../tv_shows/selection/episode_selection.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyDCNaHk_qqgX3VTZww8Uy4VL4fzixjXpEI';
  static const String _url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

  Future<String> getGeminiResponse({
    required String userInput,
    required List<String> genres,
    required List<String> titles,
    required List<EpisodeSelection> episodes,
  }) async {
    // Dizi adlarına göre grupla
    final Map<String, int> seriesWatchCounts = {};

    for (var episode in episodes) {
      final seriesTitle = episode.name; // 👉 bunu EpisodeSelection içinde sağlayacağız
      seriesWatchCounts[seriesTitle] = (seriesWatchCounts[seriesTitle] ?? 0) + 1;
    }

    final watchedSeriesSummary = seriesWatchCounts.entries
        .map((e) => '"${e.key}" dizisinden ${e.value} bölüm izledi')
        .join(', ');


    final prompt = '''
Kullanıcı daha önce şu türlerde filmler izledi: ${genres.join(', ')}.
İzlediği bazı filmler şunlar: ${titles.join(', ')}.

Ayrıca şu dizileri izledi: $watchedSeriesSummary.

Kullanıcı bundan sonra film veya dizi önerisi isterse, bu geçmiş zevklere göre öneride bulun. 
Kullanıcıya soru sorma. Direkt öneri ver.

Kullanıcı mesajı: $userInput
''';



    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        return content;
      } else {
        print("API Hatası: ${response.statusCode}");
        print("Hata Mesajı: ${response.body}");
        return 'AI cevap veremedi. ${response.statusCode}';
      }
    } catch (e) {
      print("İstisna: $e");
      return 'Bir hata oluştu: $e';
    }
  }
}

