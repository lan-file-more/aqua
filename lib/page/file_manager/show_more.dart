import 'dart:io';
import 'dart:ui';

import 'package:android_mix/android_mix.dart';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/cupertino.dart';
import 'package:lan_express/common/widget/action_button.dart';
import 'package:lan_express/common/widget/show_modal.dart';
import 'package:lan_express/external/bot_toast/src/toast.dart';
import 'package:lan_express/external/webdav/webdav.dart';
import 'package:lan_express/page/file_manager/file_action.dart';
import 'package:lan_express/provider/common.dart';
import 'package:lan_express/provider/theme.dart';
import 'package:lan_express/utils/mix_utils.dart';
import 'package:lan_express/utils/webdav.dart';
import 'package:path/path.dart' as pathLib;

Future<void> uploadToWebDAV(SelfFileEntity file) async {
  Client client = (await WebDavUtils().init()).client;
  String path = file.entity.path;
  await client.mkdir('/lan-file-more');
  await Future.delayed(Duration(milliseconds: 500));
  return client.uploadFile(path, '/lan-file-more/${pathLib.basename(path)}');
}

Future<void> showMoreModal(
  BuildContext context,
  StateSetter setState, {
  @required ThemeProvider themeProvider,
  @required CommonProvider commonProvider,
  @required SelfFileEntity file,
}) async {
  MixUtils.safePop(context);
  void showText(String content) {
    BotToast.showText(
        text: content, contentColor: themeProvider.themeData?.toastColor);
  }

  // dynamic themeData = themeProvider.themeData;
  String filesPath = await AndroidMix.storage.getFilesDir;

  showCupertinoModal(
    context: context,
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    builder: (BuildContext context) {
      return SplitSelectionModal(
        // onDispose: () {},
        leftChildren: [
          ActionButton(
            content: '复制至沙盒',
            onTap: () async {
              Directory sandbox = Directory('$filesPath/rootfs/root');
              if (sandbox.existsSync()) {
                // String targetPath = pathLib.join(
                //     _currentDir.path, pathLib.basename(item.entity.path));
                showText('复制中, 请等待');
                await FileAction.copy(file, sandbox.path);
                showText('复制完成');
              } else {
                showText('沙盒不存在');
              }
            },
          ),
          ActionButton(
            content: '上传WebDAV',
            onTap: () async {
              if (commonProvider.webDavAddr == null ||
                  commonProvider.webDavPwd == null ||
                  commonProvider.webDavUsername == null) {
                showText('请先设置WebDAV');
                return;
              }
              await uploadToWebDAV(file).catchError((err) {
                showText('上传失败');
                FLog.error(text: '$err');
              });
              showText('上传成功');
            },
          ),
        ],
        rightChildren: <Widget>[
          ActionButton(
            content: '打开方式',
            onTap: () async {},
          ),
        ],
      );
    },
  );
}