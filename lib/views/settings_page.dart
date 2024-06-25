import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../widgets/bottom_nav_bar.dart';


class SettingsPage extends StatefulWidget {
  final AudioPlayer audioPlayer;

  SettingsPage({required this.audioPlayer});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isMusicOn = true; // 音樂開關的狀態，預設為開啟
  int _currentBackgroundIndex = 0; // 当前背景音乐索引

  @override
  void initState() {
    super.initState();
    // 根据 widget.audioPlayer 的状态来初始化 _isMusicOn
    _isMusicOn = widget.audioPlayer.state == PlayerState.playing;
  }

  Future<void> _saveSettings() async {
    // 如果音樂是開啟的，則繼續播放音樂；否則暫停音樂
    if (_isMusicOn) {
      await widget.audioPlayer.resume();
    } else {
      await widget.audioPlayer.pause();
    }
  }

  void _changeBackgroundMusic() async {
    final List<String> musicList = [
      'audio/background2.mp3',
      'audio/background3.mp3',
      'audio/background1.mp3',
    ];

    try {
      // 停止当前播放的音乐
      await widget.audioPlayer.stop();
      // 播放新的背景音乐
      await widget.audioPlayer.play(AssetSource(musicList[_currentBackgroundIndex]), volume: 0.5);

    } catch (e) {
      print("Error changing background music: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              ' Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SwitchListTile(
              title: Text('Dark theme'),
              value: settingsProvider.isDarkTheme,
              onChanged: (value) {
                settingsProvider.toggleDarkTheme(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Music: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: _isMusicOn,
                  onChanged: (value) {
                    setState(() {
                      _isMusicOn = value; // 更新音樂開關的狀態
                      _saveSettings(); // 儲存設定
                    });
                  },
                  activeColor: Colors.blue, // 開啟時的顏色
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentBackgroundIndex = (_currentBackgroundIndex + 1) % 3;
                  if(_isMusicOn){
                    _changeBackgroundMusic();
                  }
                });
              },
              child: Text('Change Background Music'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/save_task_name');
              break;
            case 2:
              Navigator.pushNamed(context, '/profiles');
              break;
          }
        },
      ),
    );
  }
}
