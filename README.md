# Selectable Autolink Text

[![pub package](https://img.shields.io/pub/v/selectable_autolink_text.svg)](https://pub.dartlang.org/packages/selectable_autolink_text)

Generate inline links that can be selected and tapped in text for Flutter

![Example](https://github.com/miyakeryo/flutter_selectable_autolink_text/raw/master/example/screen.gif)

## Install

https://pub.dev/packages/selectable_autolink_text#-installing-tab-

## Usage

### Basic

```dart
@override
Widget build(BuildContext context) {
  return SelectableAutoLinkText(
    'Basic https://flutter.dev',
    linkStyle: TextStyle(color: Colors.blueAccent),
    highlightedLinkStyle: TextStyle(
      color: Colors.blueAccent,
      backgroundColor: Colors.blueAccent.withAlpha(0x33),
    ),
    onTap: (url) => launchUrl(Uri.parse(url)),
    onLongPress: (url) => Share.share(url),
  );
}
```

### Advanced

```dart
@override
Widget build(BuildContext context) {
  return SelectableAutoLinkText(
    '''
Advanced
You can shrink url like https://github.com/miyakeryo/flutter_selectable_autolink_text
tel: 012-3456-7890
email: mail@example.com''',
    style: TextStyle(color: Colors.green[800]),
    linkStyle: TextStyle(color: Colors.purpleAccent),
    highlightedLinkStyle: TextStyle(
      color: Colors.purpleAccent,
      backgroundColor: Colors.purpleAccent.withAlpha(0x33),
    ),
    onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
    onTap: (url) async {
      print('🌶Tap: $url');
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        launchUrl(uri);
      }
    },
    onLongPress: (url) {
      print('🍔LongPress: $url');
      Share.share(url);
    },
  );
}
```

### Customized
You can customize link pattern.

```dart
@override
Widget build(BuildContext context) {
  return SelectableAutoLinkText(
    'Custom links'
    '\nHi! @screen_name.'
    ' If you customize the regular expression, you can make them.'
    ' #hash_tag',
    linkStyle: TextStyle(color: Colors.deepOrangeAccent),
    highlightedLinkStyle: TextStyle(
      color: Colors.deepOrangeAccent,
      backgroundColor: Colors.deepOrangeAccent.withAlpha(0x33),
    ),
    linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
    onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
    onTap: (url) => print('🍒Tap: $url'),
    onLongPress: (url) => print('🍩LongPress: $url'),
  );
}
```

### More advanced usage

```dart
@override
Widget build(BuildContext context) {
  final blueStyle = TextStyle(color: Colors.blueAccent);
  final highlightedStyle = TextStyle(
    color: Colors.blueAccent, 
    backgroundColor: Colors.blueAccent.withAlpha(0x33),
  );
  final orangeStyle = TextStyle(color: Colors.orange);
  final boldStyle = TextStyle(fontWeight: FontWeight.bold);
  final italicStyle = TextStyle(fontStyle: FontStyle.italic);
  final bigStyle = TextStyle(fontSize: 24);
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
    onTap: (url) => launchUrl(Uri.parse(url)),
    onLongPress: (url) => Share.share(url),
  );
}
```