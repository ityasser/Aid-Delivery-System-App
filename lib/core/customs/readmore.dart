import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nocommission_app/core/customs/custom_text_button.dart';
import 'package:nocommission_app/core/local.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/theme/founts.dart';

import 'custom_text.dart';

class TextWrapper extends StatefulWidget {
  const TextWrapper({Key? key, required this.text,this.maxLine=3}) : super(key: key);

  final String text;
  final int maxLine;

  @override
  State<TextWrapper> createState() => _TextWrapperState();
}

class _TextWrapperState extends State<TextWrapper>
    with TickerProviderStateMixin {

  bool isTextAboveThreeLines(String text, TextStyle style, double maxWidth) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.maxLine, // Set the maximum number of lines to 3
      ellipsis: '...', // Optional: specify an ellipsis for truncated text
    );
    textPainter.layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          assert(constraints.hasBoundedWidth);
          final double maxWidth = constraints.maxWidth;
          final textSpan = TextSpan(text: widget.text, style: TextStyle(
            color: ColorsUi.blackItem,
            fontSize: 13.sp,
            fontWeight: FontWeight.normal,
            height: 1.3.h,
            letterSpacing: 0,
          ));
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: Directionality.of(context),
            maxLines: widget.maxLine, // Set the maximum number of lines to 3
            ellipsis: '', // Optional: specify an ellipsis for truncated text
          );
          textPainter.layout(maxWidth: maxWidth);
          bool isTextAboveThreeLines= textPainter.didExceedMaxLines;
          return Column(
              children: [
                AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: TextCustom(widget.text,
                        size: 13.sp,

                        color: ColorsUi.blackItem,
                        height: 1.3,maxLine:isExpanded?null:widget.maxLine ,
                        textOverflow: TextOverflow.visible)),
                SizedBox(height: 3.h,),


                if(isTextAboveThreeLines)
                  CustomTextButton(
                      text: isExpanded
                          ? AppLocal.getString().readless
                          : AppLocal.getString().readmore,
                      iconTrailing: isExpanded
                          ? Icon(Icons.keyboard_arrow_up_outlined)
                          : Icon(Icons.keyboard_arrow_down_outlined),
                      onPressed: () {
                        setState(() => isExpanded = !isExpanded);
                      })
              ]);


        });
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: TextCustom(widget.text,
              size: 13.sp,
              color: ColorsUi.blackItem,
              height: 1.3,maxLine:isExpanded?null:widget.maxLine ,
              textOverflow: TextOverflow.visible)),
      SizedBox(height: 3.h,),


      if(isTextAboveThreeLines(widget.text,TextStyle(
          color: ColorsUi.blackItem,
          fontSize: 13.sp,
          fontWeight: FontWeight.normal,
          height: 1.3.h,
          letterSpacing: 0,
      ),double.infinity))
      CustomTextButton(
          text: isExpanded
              ? AppLocal.getString().readless
              : AppLocal.getString().readmore,
          iconTrailing: isExpanded
              ? Icon(Icons.keyboard_arrow_up_outlined)
              : Icon(Icons.keyboard_arrow_down_outlined),
          onPressed: () {
            setState(() => isExpanded = !isExpanded);
          })
    ]);
  }
}

enum TrimMode {
  Length,
  Line,
}

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(
    this.data, {
    Key? key,
    this.preDataText,
    this.postDataText,
    this.preDataTextStyle,
    this.postDataTextStyle,
    this.trimExpandedText = 'show less',
    this.trimCollapsedText = 'read more',
    this.colorClickableText,
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = TrimMode.Length,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.semanticsLabel,
    this.moreStyle,
    this.lessStyle,
    this.delimiter = _kEllipsis + ' ',
    this.delimiterStyle,
    this.callback,
    this.onLinkPressed,
    this.linkTextStyle,
  }) : super(key: key);

  /// Used on TrimMode.Length
  final int trimLength;

  /// Used on TrimMode.Lines
  final int trimLines;

  /// Determines the type of trim. TrimMode.Length takes into account
  /// the number of letters, while TrimMode.Lines takes into account
  /// the number of lines
  final TrimMode trimMode;

  /// TextStyle for expanded text
  final TextStyle? moreStyle;

  /// TextStyle for compressed text
  final TextStyle? lessStyle;

  /// Textspan used before the data any heading or somthing
  final String? preDataText;

  /// Textspan used after the data end or before the more/less
  final String? postDataText;

  /// Textspan used before the data any heading or somthing
  final TextStyle? preDataTextStyle;

  /// Textspan used after the data end or before the more/less
  final TextStyle? postDataTextStyle;

  ///Called when state change between expanded/compress
  final Function(bool val)? callback;

  final ValueChanged<String>? onLinkPressed;

  final TextStyle? linkTextStyle;

  final String delimiter;
  final String data;
  final String trimExpandedText;
  final String trimCollapsedText;
  final Color? colorClickableText;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final String? semanticsLabel;
  final TextStyle? delimiterStyle;

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

const String _kEllipsis = '\u2026';

const String _kLineSeparator = '\u2028';

class ReadMoreTextState extends State<ReadMoreText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() {
      _readMore = !_readMore;
      widget.callback?.call(_readMore);
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style?.inherit ?? false) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaleFactor =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final overflow = defaultTextStyle.overflow;
    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);

    final colorClickableText =
        widget.colorClickableText ?? Theme.of(context).colorScheme.secondary;
    final _defaultLessStyle = widget.lessStyle ??
        effectiveTextStyle?.copyWith(color: colorClickableText);
    final _defaultMoreStyle = widget.moreStyle ??
        effectiveTextStyle?.copyWith(color: colorClickableText);
    final _defaultDelimiterStyle = widget.delimiterStyle ?? effectiveTextStyle;

    TextSpan link =TextSpan(
        text: _readMore ? widget.trimCollapsedText : widget.trimExpandedText,
      style: _readMore ? _defaultMoreStyle : _defaultLessStyle,
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,

    );

    TextSpan _delimiter = TextSpan(
      text: _readMore
          ? widget.trimCollapsedText.isNotEmpty
              ? widget.delimiter
              : ''
          : '',
      style: _defaultDelimiterStyle,
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    Widget result = LayoutBuilder(

      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        TextSpan? preTextSpan;
        TextSpan? postTextSpan;
        if (widget.preDataText != null)
          preTextSpan = TextSpan(
            text: widget.preDataText! + " ",
            style: widget.preDataTextStyle ?? effectiveTextStyle,
          );
        if (widget.postDataText != null)
          postTextSpan = TextSpan(
            text: " " + widget.postDataText!,
            style: widget.postDataTextStyle ?? effectiveTextStyle,
          );

        // Create a TextSpan with data
        final text = TextSpan(
          children: [
            if (preTextSpan != null) preTextSpan,
            TextSpan(text: widget.data, style: effectiveTextStyle),
            if (postTextSpan != null) postTextSpan
          ],
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.trimLines,
          ellipsis: overflow == TextOverflow.ellipsis ? widget.delimiter : null,
          locale: locale,
        );
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = _delimiter;
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of data
        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(Offset(
            textDirection == TextDirection.rtl
                ? readMoreSize
                : textSize.width - readMoreSize,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          var pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        var textSpan;
        switch (widget.trimMode) {
          case TrimMode.Length:
            if (widget.trimLength < widget.data.length) {
              textSpan = _buildData(
                data: _readMore
                    ? widget.data.substring(0, widget.trimLength)
                    : widget.data,
                textStyle: effectiveTextStyle,
                linkTextStyle: effectiveTextStyle?.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
                onPressed: widget.onLinkPressed,
                children: [_delimiter, link],
              );
            } else {
              textSpan = _buildData(
                data: widget.data,
                textStyle: effectiveTextStyle,
                linkTextStyle: effectiveTextStyle?.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
                onPressed: widget.onLinkPressed,
                children: [],
              );
            }
            break;
          case TrimMode.Line:
            if (textPainter.didExceedMaxLines) {
              textSpan = _buildData(
                data: _readMore
                    ? widget.data.substring(0, endIndex) +
                        (linkLongerThanLine ? _kLineSeparator : '')
                    : widget.data,
                textStyle: effectiveTextStyle,
                linkTextStyle: effectiveTextStyle?.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
                onPressed: widget.onLinkPressed,
                children: [_delimiter, link],
              );
            } else {
              textSpan = _buildData(
                data: widget.data,
                textStyle: effectiveTextStyle,
                linkTextStyle: effectiveTextStyle?.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
                onPressed: widget.onLinkPressed,
                children: [],
              );
            }
            break;
          default:
            throw Exception(
                'TrimMode type: ${widget.trimMode} is not supported');
        }

        return Text.rich(
          TextSpan(
            children: [
              if (preTextSpan != null) preTextSpan,
              textSpan,
              if (postTextSpan != null) postTextSpan,
            ],
          ),
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: true,
          overflow: TextOverflow.clip,
          textScaleFactor: textScaleFactor,
        );
      },
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }

  TextSpan _buildData({
    required String data,
    TextStyle? textStyle,
    TextStyle? linkTextStyle,
    ValueChanged<String>? onPressed,
    required List<TextSpan> children,
  }) {
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

    List<TextSpan> contents = [];

    while (exp.hasMatch(data)) {
      final match = exp.firstMatch(data);

      final firstTextPart = data.substring(0, match!.start);
      final linkTextPart = data.substring(match.start, match.end);

      contents.add(
        TextSpan(
          text: firstTextPart,
        ),
      );
      contents.add(
        TextSpan(
          text: linkTextPart,
          style: linkTextStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () => onPressed?.call(
                  linkTextPart.trim(),
                ),
        ),
      );
      data = data.substring(match.end, data.length);
    }
    contents.add(
      TextSpan(
        text: data,
      ),
    );
    return TextSpan(
      children: contents..addAll(children),
      style: textStyle,
    );
  }
}
