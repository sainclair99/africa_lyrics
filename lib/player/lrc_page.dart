import 'dart:math';

import 'package:afrikalyrics_mobile/ad_manager.dart';
import 'package:afrikalyrics_mobile/misc/alert_utils.dart';
import 'package:afrikalyrics_mobile/misc/app_colors.dart';
import 'package:afrikalyrics_mobile/misc/screen_utils.dart';
import 'package:afrikalyrics_mobile/misc/utils.dart';
import 'package:afrikalyrics_mobile/player/models/LrcModel.dart';
import 'package:afrikalyrics_mobile/player/player_controller.dart';
import 'package:afrikalyrics_mobile/service_locator.dart';
import 'package:afrikalyrics_mobile/services/lyrics_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lrc/lyric_controller.dart';
import 'package:flutter_lrc/lyric_util.dart';
import 'package:flutter_lrc/lyric_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../local_search_delegate.dart';
import 'widgets/bottom_current_song.dart';

class LrcPage extends StatefulWidget {
  LrcPage({super.key, this.title});

  final String? title;

  @override
  _LrcPageState createState() => _LrcPageState();
}

class _LrcPageState extends State<LrcPage> with TickerProviderStateMixin {
  //歌词
  var songLyc =
      "[00:00.000] 作曲 : Maynard Plant/Blaise Plant/菊池拓哉 \n[00:00.226] 作词 : Maynard Plant/Blaise Plant/菊池拓哉\n[00:00.680]明日を照らすよSunshine\n[00:03.570]窓から射し込む…扉開いて\n[00:20.920]Stop!'cause you got me thinking\n[00:22.360]that I'm a little quicker\n[00:23.520]Go!Maybe the rhythm's off,\n[00:25.100]but I will never let you\n[00:26.280]Know!I wish that you could see it for yourself.\n[00:28.560]It's not,it's not,just stop,hey y'all!やだ!\n[00:30.930]I never thought that I would take over it all.\n[00:33.420]And now I know that there's no way I could fall.\n[00:35.970]You know it's on and on and off and on,\n[00:38.210]And no one gets away.\n[00:40.300]僕の夢は何処に在るのか?\n[00:45.100]影も形も見えなくて\n[00:50.200]追いかけていた守るべきもの\n[00:54.860]There's a sunshine in my mind\n[01:02.400]明日を照らすよSunshineどこまでも続く\n[01:07.340]目の前に広がるヒカリの先へ\n[01:12.870]未来の\n[01:15.420]輝く\n[01:18.100]You know it's hard,just take a chance.\n[01:19.670]信じて\n[01:21.289]明日も晴れるかな?\n[01:32.960]ほんの些細なことに何度も躊躇ったり\n[01:37.830]誰かのその言葉いつも気にして\n[01:42.850]そんな弱い僕でも「いつか必ずきっと!」\n[01:47.800]強がり?それも負け惜しみ?\n[01:51.940]僕の夢は何だったのか\n[01:56.720]大事なことも忘れて\n[02:01.680]目の前にある守るべきもの\n[02:06.640]There's a sunshine in my mind\n[02:14.500]明日を照らすよSunshineどこまでも続く\n[02:19.000]目の前に広がるヒカリの先へ\n[02:24.670]未来のSunshine\n[02:27.200]輝くSunshine\n[02:29.900]You know it's hard,just take a chance.\n[02:31.420]信じて\n[02:33.300]明日も晴れるかな?\n[02:47.200]Rain's got me now\n[03:05.650]I guess I'm waiting for that Sunshine\n[03:09.200]Why's It only shine in my mind\n[03:15.960]I guess I'm waiting for that Sunshine\n[03:19.110]Why's It only shine in my mind\n[03:25.970]明日を照らすよSunshineどこまでも続く\n[03:30.690]目の前に広がるヒカリの先へ\n[03:36.400]未来のSunshine\n[03:38.840]輝くSunshine\n[03:41.520]You know it's hard,just take a chance.\n[03:43.200]信じて\n[03:44.829]明日も晴れるかな?\n";
  //音译/翻译歌词
  var remarkSongLyc =
      "[00:00.680]照亮明天的阳光\n[00:03.570]从窗外洒进来…敞开门扉\n[00:20.920]停下!因为你让我感觉到\n[00:22.360]自己有点过快\n[00:23.520]走吧!也许脱离了节奏\n[00:25.100]但我绝不放开你\n[00:26.280]知道吗!我希望你能亲自看看\n[00:28.560]不是这样不是这样快停下听好!糟了!\n[00:30.930]我从来没想过我会接受这一切\n[00:33.420]现在我知道我没办法降低速度\n[00:35.970]你知道这是不断地和不时地\n[00:38.210]于是谁也无法逃脱\n[00:40.300]我的梦想究竟落在何方?\n[00:45.100]为何形影不见\n[00:50.200]奋力追赶着应当守护的事物\n[00:54.860]阳光至始至终都在我心底里\n[01:02.400]照亮明天的阳光无限延伸\n[01:07.340]向着展现眼前的光明前路\n[01:12.870]Sunshine未来的阳光\n[01:15.420]Sunshine耀眼的阳光\n[01:18.100]你知道难以达成只是想去尝试一番\n[01:19.670]相信吧\n[01:21.289]明天也会放晴吗?\n[01:32.960]常因些微不足道的事情踌躇不前\n[01:37.830]总是很在意某人说过的话\n[01:42.850]如此脆弱的我亦坚信「早日必定成功!」\n[01:47.800]这是逞强还是不服输?\n[01:51.940]我的梦想实为何物\n[01:56.720]竟忘了如此重要的事\n[02:01.680]应当守护的事物就在眼前\n[02:06.640]阳光至始至终都在我心底里\n[02:14.500]照亮明天的阳光无限延伸\n[02:19.000]向着展现眼前的光明前路\n[02:24.670]未来的阳光\n[02:27.200]耀眼的阳光\n[02:29.900]你知道难以达成只是想去尝试一番\n[02:31.420]相信吧\n[02:33.300]明天也会放晴吗?\n[02:47.200]此刻雨水纷飞\n[03:05.650]我推测我所等待的就是这缕阳光\n[03:09.200]为什么它只在我心中闪烁\n[03:15.960]我推测我所等待的就是这缕阳光\n[03:19.110]为什么它只在我心中闪烁\n[03:25.970]照亮明天的阳光无限延伸\n[03:30.690]向着展现眼前的光明前路\n[03:36.400]未来的阳光\n[03:38.840]耀眼的阳光\n[03:41.520]你知道难以达成只是想去尝试一番\n[03:43.200]相信吧\n[03:44.829]明天也会放晴吗?";
  //是否显示选择器
  bool showSelect = false;
  Duration start = new Duration(seconds: 0);
  //歌词控制器
  late LyricController controller;
  late PlayerController player;
  late PlatformFile localFile;
  late TextEditingController _artistNameController;
  late TextEditingController _titleController;
  late List<LrcModel> suggestions;
  bool _isSearching = false;

  @override
  void initState() {
    suggestions = [];
    controller = LyricController(vsync: this);
    player = PlayerController.to;
    _artistNameController = TextEditingController();
    _titleController = TextEditingController();

    //监听控制器
    controller.addListener(() {
      //如果拖动歌词则显示选择器
      if (showSelect != controller.isDragging) {
        setState(() {
          showSelect = controller.isDragging;
        });
      }
    });
    player.currentPosition.stream.listen((value) {
      if (mounted) controller.progress = value;
    });
    player.currentLrcString.listen((value) {
      if (mounted) {
        AdManager.instance.showInstertialAd();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    AdManager.instance.disposeInterstitialAd();
    super.dispose();
  }

  double slider = 0;

  picLrcFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      localFile = result.files.first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //var remarkLyrics = LyricUtil.formatLyric(remarkSongLyc);
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Get.isDarkMode
            ? Image.asset(
                "assets/images/logo_white.png",
                height: 48,
              )
            : Image.asset("assets/images/Logo3.png"),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
        child: Container(
          width: context.width,
          height: context.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background_lyrics.jpeg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Obx(() {
            if (player.isCurrentLrcReady.value == false) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  if (player.playing.value != null) BottomCurrentSong(),
                ],
              );
            }
            if (player.isCurrentHasLrc.value == false) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: renderAdvancedLyricForm(),
                    ),
                    if (localFile != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${localFile.name}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var success = player.setCurrentLrc(
                            local: true,
                            localPath: localFile.path!,
                          );
                          if (success == true) {
                            player.addLocalLrc(
                              localSongId: '${player.playing.value.songId}',
                              localPath: localFile.path!,
                            );
                          }
                        },
                        child: Container(
                          color: AppColors.primary,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (player.playing.value != null) BottomCurrentSong(),
                  ],
                ),
              );
            }
            bool isAvailable = player.isCurrentLrcReady.value;
            var lyrics = LyricUtil.formatLyric(songLyc);

            if (isAvailable) {
              lyrics = LyricUtil.formatLyric(player.currentLrcString.value);
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Center(
                          child: LyricWidget(
                            lyricGap: 25,
                            size: Size(ScreenUtils.getScreenWidth(context) - 20,
                                ScreenUtils.getScreenHeight(context) - 20),
                            lyricMaxWidth:
                                ScreenUtils.getScreenWidth(context) - 20,
                            lyrics: lyrics,
                            controller: controller,
                            lyricStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.white.withOpacity(.5),
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),

                            currLyricStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                            textAlign: TextAlign.left,
                            //remarkLyrics: remarkLyrics,
                          ),
                        ),
                        Offstage(
                          offstage: !showSelect,
                          child: GestureDetector(
                            onTap: () {
                              //点击选择器后移动歌词到滑动位置;
                              controller.draggingComplete!();
                              //当前进度
                              print("进度:${controller.draggingProgress}");
                              player.seekTo(controller.draggingProgress!);
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                Expanded(
                                    child: Divider(
                                  color: Colors.red,
                                  height: 5,
                                )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (player.playing.value != null) BottomCurrentSong(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    if (suggestions != null && suggestions.isNotEmpty) {
      return Container(
        child: Column(
          children: [
            if (_isSearching)
              Center(
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Search results for: '${_artistNameController.text}${_titleController.text.isNotEmpty ? " - " + _titleController.text : ''}'",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                        height: 2,
                      ),
                  itemCount: min(suggestions.length, 2),
                  itemBuilder: (context, index) {
                    var item = suggestions[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          "${item.artistName}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "${item.title}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            player.setCurrentLrc(lrc: item);
                          },
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Center renderAdvancedLyricForm() {
    return Center(
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _buildSuggestions()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Lyrics not Found, please try to search manually',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                  hintText: "Enter Song Title",
                ),
              ),
              TextField(
                controller: _artistNameController,
                style: Theme.of(context).textTheme.headline5,
                decoration: InputDecoration(
                  hintText: "Enter Artist Name",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    try {
                      setState(() {
                        _isSearching = true;
                      });
                      List<LrcModel> results =
                          await locator.get<LyricsService>().searchLrc(
                                artist: _artistNameController.text,
                                title: _titleController.text,
                              );

                      setState(() {
                        suggestions = results;
                        _isSearching = false;
                      });
                    } catch (e) {
                      showError(extractMessage(e));
                      setState(() {
                        _isSearching = false;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20,
                      ),
                      child: Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
