import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:test_work_donteco/src/data/data_url_music.dart';


class PageManager {
  
  // State для кнопки включения, выключения песни
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  // State для CrossFade
  final crossFadeState = ValueNotifier<CrossFadeState>(CrossFadeState.showFirst);

  late AudioPlayer _audioPlayer;
  PageManager() {
    _init();
  }

  void _init() async {
    DataUrl dataSong = DataUrl();
    _audioPlayer = AudioPlayer();
    //начальный пул песен
    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(dataSong.urlSong["urlSong_1"].toString())),
      AudioSource.uri(Uri.parse(dataSong.urlSong["urlSong_2"].toString())),
    ]))
        .catchError((error) {
      print("An error occured $error");
    });

    // для бесконечной прокрутки песен
    _audioPlayer.setLoopMode(LoopMode.all);

    // ставит на паузу, включает или показывает загрузку в зависимости от State
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.pause();
      }
    });

    //переключение картинок в зависимости от песни
    _audioPlayer.currentIndexStream.listen((index) {
      if (index == 0) {
        crossFadeState.value = CrossFadeState.showFirst;

      }
      if (index == 1) {
        crossFadeState.value = CrossFadeState.showSecond;
      }
    });

  }

  void play() {
    _audioPlayer.play();
  }

  void next() {
    _audioPlayer.seekToNext();
  }

  void previous() {
    _audioPlayer.seekToPrevious();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

enum ButtonState { paused, playing, loading }
