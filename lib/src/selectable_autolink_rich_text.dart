import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../selectable_autolink_text.dart';
import 'highlighted_text_span.dart';
import 'selectable_text.dart' as my show SelectableText;
import 'selectable_text.dart' show GesturePointCallback;
import 'tap_and_long_press.dart';
import 'text_element.dart';

enum RichTextType { TEXT, CUSTOM }

mixin AutoLinkRichTextMixin {
  RichTextType getRichTextType();

  String getRichText();
}

typedef CustomRichTextSpanBuilder<T> = List<TextSpan> Function(T text);

class SelectableAutoLinkRichText<T extends AutoLinkRichTextMixin>
    extends StatefulWidget {
  final List<T>? list;

  final CustomRichTextSpanBuilder<T>? customRichTextSpanBuilder;

  /// Regular expression for link
  /// If null, defaults RegExp([AutoLinkUtils.defaultLinkRegExpPattern]).
  final RegExp _linkRegExp;

  /// Transform the display of Link
  /// Called when Link is displayed
  final OnTransformLinkAttributeFunction? onTransformDisplayLink;

  /// Called when the user taps on link.
  final OnOpenLinkFunction? onTap;

  /// Called when the user long-press on link.
  final OnOpenLinkFunction? onLongPress;

  /// Called when the user taps on non-link.
  final GesturePointCallback? onTapOther;

  /// Called when the user long-press on non-link.
  final GesturePointCallback? onLongPressOther;

  /// Style of link text
  final TextStyle? linkStyle;

  /// Style of highlighted link text
  final TextStyle? highlightedLinkStyle;

  /// {@macro flutter.material.SelectableText.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.material.SelectableText.style}
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.selectionControls}
  final TextSelectionControls? selectionControls;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool showCursor;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// {@macro flutter.material.SelectableText.cursorColor}
  final Color? cursorColor;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.material.SelectableText.toolbarOptions}
  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  final ToolbarOptions? toolbarOptions;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.widgets.editableText.onSelectionChanged}
  final SelectionChangedCallback? onSelectionChanged;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// {@macro flutter.widgets.magnifier}
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// For debugging linkRegExp
  final OnDebugMatchFunction? onDebugMatch;

  SelectableAutoLinkRichText(
    this.list, {
    super.key,
    String? linkRegExpPattern,
    this.onTransformDisplayLink,
    this.customRichTextSpanBuilder,
    this.onTap,
    this.onLongPress,
    this.onTapOther,
    this.onLongPressOther,
    this.linkStyle,
    this.highlightedLinkStyle,
    this.focusNode,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.selectionControls,
    this.showCursor = false,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.enableInteractiveSelection = true,
    this.dragStartBehavior = DragStartBehavior.start,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    this.toolbarOptions,
    this.scrollPhysics,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.contextMenuBuilder = my.SelectableText.defaultContextMenuBuilder,
    this.magnifierConfiguration,
    this.onDebugMatch,
  }) : _linkRegExp =
            RegExp(linkRegExpPattern ?? AutoLinkUtils.defaultLinkRegExpPattern);

  @override
  _SelectableAutoLinkRichTextState createState() =>
      _SelectableAutoLinkRichTextState();
}

class _SelectableAutoLinkRichTextState
    extends State<SelectableAutoLinkRichText> {
  final _gestureRecognizers = <TapAndLongPressGestureRecognizer>[];

  @override
  void dispose() {
    _clearGestureRecognizers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return my.SelectableText.rich(
      TextSpan(children: _createTextSpans()),
      focusNode: widget.focusNode,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      textScaleFactor: widget.textScaleFactor,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      selectionControls: widget.selectionControls,
      showCursor: widget.showCursor,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      dragStartBehavior: widget.dragStartBehavior,
      // ignore: deprecated_member_use_from_same_package
      toolbarOptions: widget.toolbarOptions,
      scrollPhysics: widget.scrollPhysics,
      textWidthBasis: widget.textWidthBasis,
      contextMenuBuilder: widget.contextMenuBuilder,
      magnifierConfiguration: widget.magnifierConfiguration,
      onTap: widget.onTapOther,
      onLongPress: widget.onLongPressOther,
      onSelectionChanged: widget.onSelectionChanged,
    );
  }

  List<TextElement> _generateElements(String text) {
    if (text.isEmpty) return [];

    final elements = <TextElement>[];

    final matches = widget._linkRegExp.allMatches(text);
    if (matches.isEmpty) {
      elements.add(TextElement(
        type: TextElementType.text,
        text: text,
      ));
    } else {
      var index = 0;
      matches.forEach((match) {
        widget.onDebugMatch?.call(match);

        if (match.start != 0) {
          elements.add(TextElement(
            type: TextElementType.text,
            text: text.substring(index, match.start),
          ));
        }
        elements.add(TextElement(
          type: TextElementType.link,
          text: match.group(0) ?? '',
        ));
        index = match.end;
      });

      if (index < text.length) {
        elements.add(TextElement(
          type: TextElementType.text,
          text: text.substring(index),
        ));
      }
    }

    return elements;
  }

  List<TextSpan> _createTextSpans() {
    _clearGestureRecognizers();

    if (widget.list?.isEmpty ?? true) {
      return _buildTextSpan("");
    }

    List<TextSpan> result = [];

    widget.list!.forEach((element) {
      if (element.getRichTextType() == RichTextType.TEXT) {
        result.addAll(_buildTextSpan(element.getRichText()));
      } else if (element.getRichTextType() == RichTextType.CUSTOM) {
        if (widget.customRichTextSpanBuilder != null) {
          result.addAll(widget.customRichTextSpanBuilder!(element));
        } else {
          result.addAll(_buildTextSpan(element.getRichText()));
        }
      }
    });

    return result;
  }

  List<TextSpan> _buildTextSpan(String text) {
    return _generateElements(text).map(
      (e) {
        var isLink = e.type == TextElementType.link;
        final linkAttr =
            isLink ? widget.onTransformDisplayLink?.call(e.text) : null;
        final link = linkAttr != null ? linkAttr.link : e.text;
        isLink = isLink && link != null;

        return HighlightedTextSpan(
          text: linkAttr?.text ?? e.text,
          style: linkAttr?.style ?? (isLink ? widget.linkStyle : widget.style),
          highlightedStyle: isLink
              ? (linkAttr?.highlightedStyle ?? widget.highlightedLinkStyle)
              : null,
          recognizer: isLink ? _createGestureRecognizer(link) : null,
        );
      },
    ).toList();
  }

  TapAndLongPressGestureRecognizer? _createGestureRecognizer(String link) {
    if (widget.onTap == null && widget.onLongPress == null) {
      return null;
    }
    final recognizer = TapAndLongPressGestureRecognizer();
    _gestureRecognizers.add(recognizer);
    recognizer.onTap = () => widget.onTap?.call(link);
    recognizer.onLongPress = () => widget.onLongPress?.call(link);

    return recognizer;
  }

  void _clearGestureRecognizers() {
    _gestureRecognizers.forEach((r) => r.dispose());
    _gestureRecognizers.clear();
  }
}
