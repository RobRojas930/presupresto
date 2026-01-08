import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StartView extends StatefulWidget {
  const StartView({Key? key}) : super(key: key);

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/background.mp4')
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
            _videoController.setLooping(true);
          });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video de fondo
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
          // Overlay oscuro opcional
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          const SizedBox(height: 20),

          // Botones centrados
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.8)),
                        ),
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
