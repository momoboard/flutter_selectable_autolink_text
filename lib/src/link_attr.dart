import 'package:flutter/widgets.dart';

class LinkAttribute {
  final String text;
  final String? link;
  final TextStyle? style;
  final TextStyle? highlightedStyle;

  const LinkAttribute(
    this.text, {
    this.link,
    this.style,
    this.highlightedStyle,
  });

  factory LinkAttribute.shrinkUrl(String url) {
    final text = () {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        return url;
      }
      final displayUrl = '${uri.host}${uri.path}';
      if (displayUrl.isEmpty) {
        return url;
      } else if (displayUrl.length > 30) {
        return '${displayUrl.substring(0, 29)}…';
      } else {
        return displayUrl;
      }
    }();
    return LinkAttribute(text, link: url);
  }
}
