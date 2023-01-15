import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class _StyleHelper {
  final TextStyle? normalStyle;
  final TextStyle? highlightedStyle;
  var isHighlighted = false;

  TextStyle? get style =>
      (isHighlighted ? highlightedStyle : normalStyle) ?? normalStyle;

  _StyleHelper({this.normalStyle, this.highlightedStyle});
}

class HighlightedTextSpan extends TextSpan {
  final _StyleHelper _styleHelper;

  HighlightedTextSpan({
    super.text,
    super.children,
    super.style,
    super.recognizer,
    super.semanticsLabel,
    TextStyle? highlightedStyle,
  }) : _styleHelper = _StyleHelper(
          normalStyle: style,
          highlightedStyle: highlightedStyle,
        );

  @override
  TextStyle? get style => _styleHelper.style;

  bool get isHighlighted => _styleHelper.isHighlighted;
  set isHighlighted(bool value) => _styleHelper.isHighlighted = value;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (super != other) return false;
    final HighlightedTextSpan typedOther = other;
    return typedOther.isHighlighted == isHighlighted;
  }

  @override
  int get hashCode => Object.hash(isHighlighted, super.hashCode);

  static bool clearHighlight(TextSpan span) {
    var result = false;
    if (span is HighlightedTextSpan) {
      result = result || span.isHighlighted;
      span.isHighlighted = false;
    }
    return result ||
        span.children
                ?.where((c) => c is TextSpan)
                .cast<TextSpan>()
                .where(clearHighlight)
                .isNotEmpty ==
            true;
  }

  @override
  InlineSpan? getSpanForPositionVisitor(
    TextPosition position,
    Accumulator offset,
  ) {
    final text = this.text;
    if (text == null) return null;

    final targetOffset = position.offset;
    final startOffset = offset.value;
    final endOffset = offset.value + text.length - 1;
    if (startOffset <= targetOffset && targetOffset <= endOffset) {
      return this;
    }
    offset.increment(text.length);
    return null;
  }
}
