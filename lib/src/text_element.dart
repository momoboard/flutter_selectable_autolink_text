enum TextElementType { text, link }

class TextElement {
  final TextElementType type;
  final String text;
  const TextElement({required this.type, required this.text});
}
