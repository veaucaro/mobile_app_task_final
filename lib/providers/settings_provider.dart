import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class SettingsProvider with ChangeNotifier {
  bool _isDarkTheme = false;
  bool _areNotificationsEnabled = true;
  bool _isMusicMuted = false;
  AudioPlayer _audioPlayer = AudioPlayer();

  List<String> _backgroundMusicList = [
    'audio/background1.mp3',
    'audio/background2.mp3',
    'audio/background3.mp3',
  ];
  int _currentMusicIndex = 0;

  bool get isDarkTheme => _isDarkTheme;
  bool get areNotificationsEnabled => _areNotificationsEnabled;
  bool get isMusicMuted => _isMusicMuted;

  void toggleDarkTheme(bool value) {
    _isDarkTheme = value;
    notifyListeners();
  }

  void toggleMusicMuted(bool value) {
    _isMusicMuted = value;
    if (value) {
      _audioPlayer.stop();
    }
    notifyListeners();
  }

  // void initializeMusic() async {
  //   //ini
  //   _audioPlayer.setReleaseMode(ReleaseMode.loop);
  //   await _audioPlayer.play(AssetSource(_backgroundMusicList[_currentMusicIndex]), volume: 0.5);
  // }

  void switchBackgroundMusic() async {
    _currentMusicIndex = (_currentMusicIndex + 1) % _backgroundMusicList.length;
    await _audioPlayer.play(AssetSource(_backgroundMusicList[_currentMusicIndex]), volume: 0.5);
    notifyListeners();
  }
}
