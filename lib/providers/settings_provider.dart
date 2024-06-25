import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // 导入音频播放器插件

class SettingsProvider with ChangeNotifier {
  bool _isDarkTheme = false;
  bool _areNotificationsEnabled = true;
  bool _isMusicMuted = false; // 是否静音
  AudioPlayer _audioPlayer = AudioPlayer();

  // 背景音乐文件列表
  List<String> _backgroundMusicList = [
    'audio/background1.mp3',
    'audio/background2.mp3',
    'audio/background3.mp3',
  ];
  int _currentMusicIndex = 0; // 当前背景音乐索引

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

  void initializeMusic() async {
    // 初始化背景音乐，初始为第一个音乐
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(_backgroundMusicList[_currentMusicIndex]), volume: 0.5);
  }

  void switchBackgroundMusic() async {
    // 切换背景音乐到下一个
    _currentMusicIndex = (_currentMusicIndex + 1) % _backgroundMusicList.length;
    await _audioPlayer.play(AssetSource(_backgroundMusicList[_currentMusicIndex]), volume: 0.5);
    notifyListeners();
  }
}
