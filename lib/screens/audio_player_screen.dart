import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../providers/location_provider.dart';
import '../providers/payment_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String locationId;

  const AudioPlayerScreen({Key? key, required this.locationId}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAudio();
    });
  }

  void _loadAudio() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    await locationProvider.getLocationById(widget.locationId);

    final audioUrl = await locationProvider.getAudioStreamUrl(widget.locationId);
    if (audioUrl != null) {
      final isPurchased = paymentProvider.isGuidePurchased(widget.locationId);
      await audioProvider.loadAudio(audioUrl, isTrialMode: !isPurchased);

      if (isPurchased) {
        audioProvider.enablePremiumMode();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشغل الصوت'),
      ),
      body: Consumer3<LocationProvider, PaymentProvider, AudioProvider>(
        builder: (context, locationProvider, paymentProvider, audioProvider, child) {
          final location = locationProvider.currentLocation;

          if (location == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isPurchased = paymentProvider.isGuidePurchased(location.id);

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Location Image
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(location.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Location Name
                      Text(
                        location.nameAr,
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // Duration
                      Text(
                        'المدة: ${location.audioDuration ~/ 60} دقيقة',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      // Trial Time Indicator
                      if (!isPurchased && audioProvider.isTrialMode)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: Column(
                            children: [
                              const Text('نسخة تجريبية مجانية'),
                              const SizedBox(height: 8),
                              Text(
                                '${audioProvider.remainingTrialTime.inSeconds} ثانية متبقية',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      // Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                              ),
                              child: Slider(
                                value: audioProvider.currentPosition.inSeconds.toDouble(),
                                max: audioProvider.duration.inSeconds.toDouble(),
                                onChanged: (value) {
                                  audioProvider.seek(Duration(seconds: value.toInt()));
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(audioProvider.currentPosition),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  _formatDuration(audioProvider.duration),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            iconSize: 32,
                            onPressed: () {
                              audioProvider.seek(
                                Duration(seconds: max(0, audioProvider.currentPosition.inSeconds - 15)),
                              );
                            },
                          ),
                          const SizedBox(width: 24),
                          FloatingActionButton(
                            radius: 32,
                            child: Icon(
                              audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () {
                              if (audioProvider.isPlaying) {
                                audioProvider.pause();
                              } else {
                                audioProvider.play();
                              }
                            },
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            iconSize: 32,
                            onPressed: () {
                              audioProvider.seek(
                                Duration(
                                  seconds: min(
                                    audioProvider.duration.inSeconds,
                                    audioProvider.currentPosition.inSeconds + 15,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Subscribe Button (if not purchased)
              if (!isPurchased)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Go to subscription
                    },
                    child: const Text('استمتع بالنسخة الكاملة'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
