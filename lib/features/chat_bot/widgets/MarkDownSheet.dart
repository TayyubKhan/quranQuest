import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/themes/color_scheme.dart';

MarkdownStyleSheet markdownStyleSheet(bool isUser) {
  return MarkdownStyleSheet(
    // Paragraph style
    p: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 16,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),
    pPadding: const EdgeInsets.symmetric(vertical: 8),

    // Bold text style
    strong: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),

    // Italic text style
    em: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.italic,
        color: isUser
            ? darkColor.withOpacity(0.7)
            : Colors.white70, // lighter darkColor for user, white70 for AI
      ),
    ),

    // Strikethrough text style
    del: GoogleFonts.nunito(
      textStyle: TextStyle(
        decoration: TextDecoration.lineThrough,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),

    // Blockquote style for quotes
    blockquote: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.italic,
        color: isUser
            ? darkColor.withOpacity(0.7)
            : Colors.white70, // lighter shade for both
      ),
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    blockquoteDecoration: BoxDecoration(
      border: Border(
        left: BorderSide(
          color: isUser ? darkColor : Colors.white,
          width: 4,
        ),
      ),
    ),

    // Image style
    img: GoogleFonts.nunito(
      textStyle: TextStyle(
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),

    // Checkbox style
    checkbox: GoogleFonts.nunito(
      textStyle: TextStyle(
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),

    // Block spacing
    blockSpacing: 16,

    // List styles
    listIndent: 20,
    listBullet: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 16,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),
    listBulletPadding: const EdgeInsets.symmetric(horizontal: 8),

    // Table styles
    tableHead: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),
    tableBody: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 16,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),
    tableHeadAlign: TextAlign.center,
    tablePadding: const EdgeInsets.all(8),
    tableBorder: TableBorder.all(
      color: isUser ? darkColor : Colors.white,
      width: 1,
    ),
    tableColumnWidth: const FlexColumnWidth(1.0),
    tableCellsPadding: const EdgeInsets.all(8),
    tableCellsDecoration: BoxDecoration(
      border: Border.all(
        color: isUser ? darkColor : Colors.white,
        width: 1,
      ),
    ),
    tableVerticalAlignment: TableCellVerticalAlignment.middle,

    // Code block style
    code: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 16,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
        backgroundColor: Colors.transparent, // No background highlight
      ),
    ),
    codeblockPadding: const EdgeInsets.all(8),
    codeblockDecoration: BoxDecoration(
      border: Border.all(
        color: isUser ? darkColor : Colors.white,
        width: 1,
      ),
    ),

    // Horizontal rule style
    horizontalRuleDecoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: isUser ? darkColor : Colors.white,
          width: 1,
        ),
      ),
    ),

    // Heading text styles
    h1: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: isUser
            ? darkColor
            : Colors.white, // darkColor for user, white for AI
      ),
    ),
    h1Padding: const EdgeInsets.symmetric(vertical: 16),

    h2: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isUser ? darkColor : Colors.white, // same logic
      ),
    ),
    h2Padding: const EdgeInsets.symmetric(vertical: 14),

    h3: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isUser ? darkColor : Colors.white, // same logic
      ),
    ),
    h3Padding: const EdgeInsets.symmetric(vertical: 12),

    h4: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isUser ? darkColor : Colors.white, // same logic
      ),
    ),
    h4Padding: const EdgeInsets.symmetric(vertical: 10),

    h5: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isUser ? darkColor : Colors.white, // same logic
      ),
    ),
    h5Padding: const EdgeInsets.symmetric(vertical: 8),

    h6: GoogleFonts.nunito(
      textStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: isUser ? darkColor : Colors.white, // same logic
      ),
    ),
    h6Padding: const EdgeInsets.symmetric(vertical: 6),

    superscriptFontFeatureTag: 'sups',
  );
}
