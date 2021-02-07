import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:nature_farming/common/color/color.dart';
import 'package:nature_farming/common/type/types.dart';
import 'package:nature_farming/use_case/account/account_notifier.dart';
import 'package:nature_farming/use_case/account/account_state.dart';
import 'package:nature_farming/views/home/home_page.dart';
import 'package:provider/provider.dart';

final introKey = GlobalKey<IntroductionScreenState>();

class OnBoardPage extends StatelessWidget {
  const OnBoardPage._({Key key}) : super(key: key);

  static Widget wrapped() {
    return MultiProvider(
      providers: [
        StateNotifierProvider<AccountNotifier, AccountState>(
          create: (context) => AccountNotifier(context: context),
        ),
      ],
      child: const OnBoardPage._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AccountNotifier>();
    const bodyStyle = TextStyle(fontSize: 19);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Fractional shares",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          image: _buildImage(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn as you go",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'ユーザー登録しましょう',
          bodyWidget: Form(
              key: notifier.formkey,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        labelText: 'ユーザー名',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.mainColor),
                        )),
                    maxLength: 20,
                    onChanged: (value) {
                      notifier.saveName(value);
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        labelText: '自己紹介文',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.mainColor))),
                    onChanged: (value) {
                      notifier.saveContent(value);
                    },
                  ),
                ],
              )),
          image: _buildImage(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "プロフィール画像を追加",
          body: '後から編集できます。',
          image: _buildImage(),
          footer: RaisedButton(
            onPressed: () {
              notifier.saveProfileImage();
            },
            child: const Text(
              '画像を選択',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          image: _buildImage(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () async {
        if (notifier.formkey.currentState.validate()) {
          notifier.formkey.currentState.save();

          final startUp = await notifier.startUp();
          if (startUp == StartUpType.incompleteUser) {
            return notifier.createUser();
          }
          await notifier.pushReplacementHomePage();
        }
      },
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildImage() {
    return Align(
      child: Image.network(
        'https://i2.wp.com/aspgems.com/wp-content/uploads/2020/01/flutter-dart.png?fit=1200%2C600&ssl=1',
        width: 350,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
