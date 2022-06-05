import 'package:flutter/material.dart';
import 'package:test_work_donteco/src/data/data_image.dart';
import 'package:test_work_donteco/src/page_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageManager _pageManager;
  // значения контейнера по умолчанию
  double heightContainer = 270;
  double widthContainer = 270;
  //начальное значение AnimatedCrossFade 
  int _value = 2;

  DataImage dataImage = DataImage();

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.5,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              boxShadow: [
                 BoxShadow(
                    blurRadius: 15,
                    offset:  Offset(4, 4),
                    color:  Color.fromARGB(101, 24, 24, 24)),
                BoxShadow(
                    blurRadius: 15,
                    offset:  Offset(0, -4),
                    color: Color.fromARGB(101, 0, 0, 0))
              ],
              color:  Color.fromARGB(255, 58, 58, 58),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                    valueListenable: _pageManager.crossFadeState,
                    builder: (_, value, __) {
                      return AnimatedCrossFade(
                          crossFadeState: _pageManager.crossFadeState.value,
                          duration: Duration(seconds: _value),
                          firstCurve: Curves.easeInOut,
                          secondCurve: Curves.easeInBack,
                          firstChild: customAnimatedContainer(
                              dataImage.image["image_1"].toString()),
                          secondChild: customAnimatedContainer(
                              dataImage.image["image_2"].toString()));
                    }),
                const SizedBox(
                  height: 20,
                ),
                Slider(
                    value: _value.toDouble(),
                    min: 2,
                    max: 10,
                    inactiveColor: const Color.fromARGB(255, 141, 141, 141),
                    thumbColor: Colors.white,
                    activeColor: const Color.fromARGB(255, 221, 221, 221),
                    divisions: 8,
                    label: _value.toString(),
                    onChanged: (value) {
                      setState(() {
                        _value = value.toInt();
                      });
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<ButtonState>(
                      valueListenable: _pageManager.buttonNotifier,
                      builder: (_, value, __) {
                        return IconButton(
                            icon: const Icon(Icons.skip_previous_rounded),
                            color: Colors.white,
                            iconSize: 40.0,
                            onPressed: () {
                              setState(() {});
                              _pageManager.previous();
                            });
                      },
                    ),
                    ValueListenableBuilder<ButtonState>(
                      valueListenable: _pageManager.buttonNotifier,
                      builder: (_, value, __) {
                        switch (value) {
                          case ButtonState.loading:
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              width: 40.0,
                              height: 40.0,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          case ButtonState.paused:
                            return IconButton(
                                icon: const Icon(Icons.play_arrow_rounded),
                                color: Colors.white,
                                iconSize: 40.0,
                                onPressed: () {
                                  _pageManager.play();

                                  setState(() {
                                    widthContainer = 300;
                                    heightContainer = 300;
                                  });
                                });
                          case ButtonState.playing:
                            return IconButton(
                                icon: const Icon(Icons.pause_rounded),
                                color: Colors.white,
                                iconSize: 40.0,
                                onPressed: () {
                                  setState(() {
                                    widthContainer = 270;
                                    heightContainer = 270;
                                  });
                                  _pageManager.pause();
                                });
                        }
                      },
                    ),
                    ValueListenableBuilder<ButtonState>(
                      valueListenable: _pageManager.buttonNotifier,
                      builder: (_, value, __) {
                        return IconButton(
                          icon: const Icon(Icons.skip_next_rounded),
                          color: Colors.white,
                          iconSize: 40.0,
                          onPressed: () {
                            setState(() {});
                            _pageManager.next();
                          },
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //кастомный AnimatedContainer
  Widget customAnimatedContainer(String image) {
    return AnimatedContainer(
      height: heightContainer,
      width: widthContainer,
      duration: const Duration(milliseconds: 200),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
