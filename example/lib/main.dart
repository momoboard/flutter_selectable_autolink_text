import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(_MyApp());

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: _MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selectable Autolink Text')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _basic(context),
            const Divider(height: 32),
            _advanced(context),
            const Divider(height: 32),
            _custom(context),
            const Divider(height: 32),
            _moreAdvanced(context),
            SelectableText(''),
          ],
        ),
      ),
    );
  }

  Widget _basic(BuildContext context) {
    return SelectableAutoLinkText(
      'Basic\n'
      'Generate inline links that can be selected, tapped, '
      'long pressed and highlighted on tap.\n'
      'As written below.\n'
      'Dart packages https://pub.dev',
      linkStyle: const TextStyle(color: Colors.blueAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Colors.blueAccent.withAlpha(0x33),
      ),
      onTap: _launchUrl,
      onLongPress: _share,
    );
  }

  Widget _advanced(BuildContext context) {
    return SelectableAutoLinkText(
      '''
Advanced
You can shrink url like https://github.com/miyakeryo/flutter_selectable_autolink_text
tel: 012-3456-7890
email: mail@example.com''',
      style: TextStyle(color: Colors.green[800]),
      linkStyle: const TextStyle(color: Colors.purpleAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.purpleAccent,
        backgroundColor: Colors.purpleAccent.withAlpha(0x33),
      ),
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) async {
        print('🌶 Tap: $url');
        if (!await _launchUrl(url)) {
          _alert(context, '🌶 Tap', url);
        }
      },
      onLongPress: (url) {
        print('🍔 LongPress: $url');
        _share(url);
      },
      onTapOther: (local, global) {
        print('🍇️ onTapOther: $local, $global');
      },
      onLongPressOther: (local, global) {
        print('🍊️ onLongPressOther: $local, $global');
      },
    );
  }

  Widget _custom(BuildContext context) {
    return SelectableAutoLinkText(
      'Custom links'
      '\nHi! @screen_name.'
      ' If you customize the regular expression, you can make them.'
      ' #hash_tag',
      style: const TextStyle(color: Colors.black87),
      linkStyle: const TextStyle(color: Colors.deepOrangeAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.deepOrangeAccent,
        backgroundColor: Colors.deepOrangeAccent.withAlpha(0x33),
      ),
      linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) => _alert(context, '🍒 Tap', url),
      onLongPress: (url) => _alert(context, '🍩 LongPress', url),
      onDebugMatch: (match) {
        /// for debug
        print('DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`');
      },
    );
  }

  Widget _moreAdvanced(BuildContext context) {
    final blueStyle = const TextStyle(color: Colors.blueAccent);
    final highlightedStyle = TextStyle(
      color: Colors.blueAccent,
      backgroundColor: Colors.blueAccent.withAlpha(0x33),
    );
    final orangeStyle = TextStyle(color: Colors.orange);
    final boldStyle = const TextStyle(fontWeight: FontWeight.bold);
    final italicStyle = const TextStyle(fontStyle: FontStyle.italic);
    final bigStyle = const TextStyle(fontSize: 24);
    final regExpPattern = r'\[([^\]]+)\]\(([^\s\)]+)\)';
    final regExp = RegExp(regExpPattern);

    return SelectableAutoLinkText(
      '''
More advanced usage

[This is a link text](https://google.com)
[This text is bold](bold)
This text is normal
[This text is italic](italic)
[This text is orange](orange)
[This text is big](big)''',
      linkRegExpPattern: regExpPattern,
      onTransformDisplayLink: (s) {
        final match = regExp.firstMatch(s);
        if (match != null && match.groupCount == 2) {
          final text1 = match.group(1)!;
          final text2 = match.group(2)!;
          switch (text2) {
            case 'bold':
              return LinkAttribute(text1, style: boldStyle);
            case 'italic':
              return LinkAttribute(text1, style: italicStyle);
            case 'orange':
              return LinkAttribute(text1, style: orangeStyle);
            case 'big':
              return LinkAttribute(text1, style: bigStyle);
            default:
              if (text2.startsWith('http')) {
                return LinkAttribute(
                  text1,
                  link: text2,
                  style: blueStyle,
                  highlightedStyle: highlightedStyle,
                );
              } else {
                return LinkAttribute(text1);
              }
          }
        }
        return LinkAttribute(s);
      },
      onTap: _launchUrl,
      onLongPress: _share,
    );
  }

  Future<bool> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      return false;
    }
  }

  Future _share(String text, [String? subject]) async {
    try {
      return await Share.share(text, subject: subject);
    } on MissingPluginException catch (e) {
      print("😡 $e");
    }
  }

  Future _alert(BuildContext context, String title, [String? message]) {
    return showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : null,
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: Navigator.of(c).pop,
            ),
          ],
        );
      },
    );
  }
}
