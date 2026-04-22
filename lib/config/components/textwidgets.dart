import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

enum TextType {
  appName,
  productNames,
  logos,
  headings,
  screenTitles,
  uiLabels,
  prices,
  buttons,
}

class AppText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color color;
  final TextAlign? align;
  final double? letterSpacing;

  const AppText(
      this.text, {
        super.key,
        this.type = TextType.buttons,
        required this.color,
        this.align = TextAlign.center,
        this.letterSpacing = 0.0,
      });

  double _getResponsiveFont(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double scale = width / 375;

    switch (type) {
      case TextType.appName:
        return (22 * scale).clamp(22, 38);
      case TextType.logos:
        return (20 * scale).clamp(20, 34);
      case TextType.screenTitles:
        return (18 * scale).clamp(18, 30);
      case TextType.headings:
        return (16 * scale).clamp(16, 26);
      case TextType.productNames:
        return (15 * scale).clamp(15, 24);
      case TextType.prices:
        return (14 * scale).clamp(14, 22);
      case TextType.uiLabels:
        return (11 * scale).clamp(11, 16);
      case TextType.buttons:
        return (10 * scale).clamp(10, 14);
    }
  }

  TextStyle _getGoogleFontStyle() {
    switch (type) {
    // Cormorant Garamond — editorial serif for brand identity
      case TextType.appName:
        return GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
        );
      case TextType.logos:
        return GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
        );
      case TextType.productNames:
        return GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );
      case TextType.headings:
        return GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        );

    // DM Sans — clean sans-serif for UI chrome
      case TextType.screenTitles:
        return GoogleFonts.dmSans(
          fontWeight: FontWeight.w500,
        );
      case TextType.prices:
        return GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
        );
      case TextType.uiLabels:
        return GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
        );
      case TextType.buttons:
        return GoogleFonts.dmSans(
          fontWeight: FontWeight.w400,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: _getGoogleFontStyle().copyWith(
        fontSize: _getResponsiveFont(context),
        color: color,
        letterSpacing: letterSpacing,
      ),
    );
  }
}