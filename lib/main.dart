import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'api/api.dart';

void main() {
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Generator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        hintColor: Color(0xFF32CD32), // Lime Green
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1C1C1E), // Dark Grey
          titleTextStyle: GoogleFonts.pacifico(
              fontSize: 24, color: Colors.white), // White text
          elevation: 10,
          actionsIconTheme: IconThemeData(color: Colors.white), // White icons
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color.fromARGB(255, 50, 205, 202), // Lime Green
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color.fromARGB(255, 50, 179, 205), // Lime Green
          ),
        ),
        scaffoldBackgroundColor: Color(0xFF121212), // Very Dark Background
      ),
      home: MusicScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _styleController = TextEditingController();
  List<dynamic> _songs = [];
  bool _isPlaying = false;
  String? _playingSongUrl;
  late AudioPlayer _audioPlayer;
  late SunoApi _sunoApi;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _sunoApi = SunoApi();
    _sunoApi.init(
        '__cf_bm=HxL.KYp7lx17Gn.KHit4mWyWSsySKUeuZ0NRTc0Lfn8-1718826925-1.0.1.1-8uesJKzRD4j7ezxLHs0Dh05yiE.W6A6UHBYr2aTAkjMUGmOT4RHJUJdPBrgU.Fye.J9vFGoJQ673b6PAK7s8Vg; _cfuvid=bvMq26OdvdMJ3LRr.4VJxWtsqowYExX3jLqeYRhIMHo-1718826925780-0.0.1.1-604800000; __client=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNsaWVudF8yaTcxbEI5dDJLM3dCdk9sU2d6Tjh4Zzd2TVYiLCJyb3RhdGluZ190b2tlbiI6InhwMTB6ZWtvbXJreTNyY3poYzM1MWh5dWF6cjA4OTZuOWNyY3dlaXcifQ.KcJRng6QPFi_AsRsXzzTI9Os_HfgP5nPP9XV2IgGI91gViZIqGhrtTgZ2j-egNyHODjsFdA96hNicP4PRhNVmx3zt5XHX3_dzyAXq6_2zgB_FNMTSc61ynaVBdLkrLkXOYCYeubvIuPF3JAxfHDTqNmP0IIN5sUPScT4v4HVqNUQhN2QYvzMoRbS99ov9nOvl8jSg4SjSKQa21UvIZpf5jOKbVmeBk4nqpWZJCDEk75VsAnJuNqO4CV10YJsGJ_hAltlZmYKr2zoe1qFiYwUozx0pwRGLD_q-ho6iP6VYfw-NqHfWDbFgBnKPSY8ujMlMjpYqYVj7gPCGMglxx8HrQ; __client_uat=1718826956; mp_26ced217328f4737497bd6ba6641ca1c_mixpanel=%7B%22distinct_id%22%3A%20%225bfeed14-d1bf-426e-ab40-c67459482dc4%22%2C%22%24device_id%22%3A%20%221902a176e742391-0ee5ba25c4caf9-19525637-157188-1902a176e742391%22%2C%22%24search_engine%22%3A%20%22google%22%2C%22%24initial_referrer%22%3A%20%22https%3A%2F%2Fwww.google.com%2F%22%2C%22%24initial_referring_domain%22%3A%20%22www.google.com%22%2C%22__mps%22%3A%20%7B%7D%2C%22__mpso%22%3A%20%7B%7D%2C%22__mpus%22%3A%20%7B%7D%2C%22__mpa%22%3A%20%7B%7D%2C%22__mpu%22%3A%20%7B%7D%2C%22__mpr%22%3A%20%5B%5D%2C%22__mpap%22%3A%20%5B%5D%2C%22__mpus%22%3A%20%5B%5D%2C%22__mpa%22%3A%20%7B%7D%2C%22__mpr%22%3A%20%5B%5D%2C%22__mpap%22%3A%20%5B%5D%2C%22__mpus%22%3A%20%5B%5D%2C%22__mpap%22%3A%20%5B%5D%2C%22%24user_id%22%3A%20%225bfeed14-d1bf-426e-ab40-c67459482dc4%22%7D'); // Replace with your actual cookie
  }

  Future<void> _generateSong() async {
    FocusScope.of(context).unfocus(); // Hide the keyboard
    setState(() {
      _isLoading = true; // Show the loader
    });

    final String prompt = _promptController.text;
    final String style = _styleController.text;

    try {
      final songs = await _sunoApi.generateSong(
          prompt, style, SunoApi.defaultModel) as List<dynamic>?;
      if (songs != null && songs.isNotEmpty) {
        setState(() {
          _songs = songs;
        });
      } else {
        setState(() {
          _songs = []; // Clear the list if no songs are returned
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _songs = []; // Clear the list if there's an error
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide the loader
      });
    }
  }

  Future<void> _playSong(String url) async {
    if (_isPlaying && _playingSongUrl == url) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      if (_isPlaying) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.setSourceUrl(url);
      await _audioPlayer.resume();
      setState(() {
        _isPlaying = true;
        _playingSongUrl = url;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Music Generator',
          style: GoogleFonts.poppins(
              fontSize: 24, color: Colors.white), // White text
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF232323), // Darker Grey
                Color(0xFF1C1C1E) // Dark Grey
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white, // White icon
            onPressed: () {
              // Action for settings
            },
          ),
        ],
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF343434), // Darker Grey
              Color(0xFF121212) // Very Dark Background
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _promptController,
              cursorColor: Colors.black, // Lime Green
              decoration: InputDecoration(
                hintText: 'Description prompt',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 69, 68, 68)), // Grey text
                filled: true,
                fillColor: Colors.white, // Light Grey
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _styleController,
              cursorColor: Color(0xFF32CD32), // Lime Green
              decoration: InputDecoration(
                hintText: 'Enter music style',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 69, 68, 68)), // Grey text
                filled: true,
                fillColor: Colors.white, // Light Grey
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF32CD32), // Lime Green
                    ),
                  )
                : ElevatedButton(
                    onPressed: _generateSong,
                    child: Text('Generate Song'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFF32CD32), // Lime Green
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1 / 1.58,
                ),
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  return MusicCard(
                    song: song ?? {},
                    isPlaying:
                        _isPlaying && _playingSongUrl == song?['audio_url'],
                    onPlayPause: () => _playSong(song?['audio_url'] ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MusicCard extends StatelessWidget {
  final Map<String, dynamic> song;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const MusicCard({
    Key? key,
    required this.song,
    required this.isPlaying,
    required this.onPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Card(
        color: Colors.white, // Lime Green
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                song['image_url'] ?? '',
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 90,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.music_note,
                    color: Colors.grey[600],
                    size: 50,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    song['title']?.toString().isNotEmpty == true
                        ? song['title']
                        : (song['metadata']?['prompt'] ?? 'Unknown')
                            .toString()
                            .split(' ')
                            .map((word) =>
                                word[0].toUpperCase() + word.substring(1))
                            .join(' '),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(height: 5),
                  Text(
                    song["metadata"]!["tags"]
                        .toString()
                        .split(' ')
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(' '),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 18, 26, 103),
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Color(0xFF32CD32), // Lime Green
                          size: 40,
                        ),
                        onPressed: onPlayPause,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
