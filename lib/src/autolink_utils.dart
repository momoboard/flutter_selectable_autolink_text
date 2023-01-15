import 'link_attr.dart';

abstract class AutoLinkUtils {
  AutoLinkUtils._();

  static const urlRegExpPattern =
      r'https?://([\w-]+\.)+[\w-]+(/[\w-./?%&@\$=~#+]*)?';
  static const phoneNumberRegExpPattern = r'[+0]\d+[\d-]+\d';
  static const emailRegExpPattern = r'[^@\s]+@([^@\s]+\.)+[^@\W]+';
  static const defaultLinkRegExpPattern =
      '($urlRegExpPattern|$phoneNumberRegExpPattern|$emailRegExpPattern)';

  static LinkAttribute shrinkUrl(String url) => LinkAttribute.shrinkUrl(url);
}
