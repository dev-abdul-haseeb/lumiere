import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

enum TextType {
  // Cormorant Garamond (serif)
  splashTagline,   // italic, w300, 22 – splash "Crafted for skin…"
  heroTitle,       // italic, w300, 40 – "Welcome back", "Forgot your password?"
  sectionHeading,  // italic, w400, 22 – admin page headings
  productName,     // italic, w400, 16 – product card / detail names

  // DM Sans (sans-serif)
  appName,         // w500, 16, ls 3.5 – "LUMIÈRE"
  appSubtitle,     // w400, 11, ls 2.5 – "LUXURY SKINCARE", "ADMIN PANEL"
  screenTitle,     // w600, 18         – "Dashboard", "Customers"
  bodyText,        // w400, 14         – descriptions, subtitles, body copy
  price,           // w700, 16         – "$128.00", "TOTAL $222.00"
  label,           // w500, 11, ls 1.4 – "EMAIL ADDRESS", "PASSWORD"
  caption,         // w400, 12         – "3 previous orders", "30ml", helper text
  button,          // w600, 13, ls 2.0 – "SIGN IN", "PUBLISH", "ADD TO BAG"
  link,            // w600, 13         – "Sign up", "Back to sign in"
}

class AppText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color color;
  final TextAlign? align;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppText(
      this.text, {
        super.key,
        this.type = TextType.bodyText,
        required this.color,
        this.align,
        this.letterSpacing,
        this.maxLines,
        this.overflow,
      });

  // Responsive font size

  double _fontSize(BuildContext context) {
    final double scale = MediaQuery.of(context).size.width / 375;

    switch (type) {
      case TextType.splashTagline:  return (22 * scale).clamp(18, 28);
      case TextType.heroTitle:      return (40 * scale).clamp(32, 52);
      case TextType.sectionHeading: return (22 * scale).clamp(18, 30);
      case TextType.productName:    return (16 * scale).clamp(14, 22);

      case TextType.appName:        return (16 * scale).clamp(14, 22);
      case TextType.appSubtitle:    return (11 * scale).clamp(10, 14);
      case TextType.screenTitle:    return (18 * scale).clamp(16, 24);
      case TextType.bodyText:       return (14 * scale).clamp(13, 18);
      case TextType.price:          return (16 * scale).clamp(14, 22);
      case TextType.label:          return (11 * scale).clamp(10, 13);
      case TextType.caption:        return (12 * scale).clamp(11, 15);
      case TextType.button:         return (13 * scale).clamp(12, 16);
      case TextType.link:           return (13 * scale).clamp(12, 16);
    }
  }

  // Default letter spacing per type

  double _defaultLetterSpacing() {
    switch (type) {
      case TextType.appName:     return 3.5;
      case TextType.appSubtitle: return 2.5;
      case TextType.label:       return 1.4;
      case TextType.button:      return 2.0;
      default:                   return 0.0;
    }
  }

  // Text style

  TextStyle _style(BuildContext context) {
    final double size = _fontSize(context);
    final double ls   = letterSpacing ?? _defaultLetterSpacing();

    switch (type) {
    // Serif
      case TextType.splashTagline:
        return GoogleFonts.cormorantGaramond(
          fontSize: size, fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic, color: color, letterSpacing: ls,
        );
      case TextType.heroTitle:
        return GoogleFonts.cormorantGaramond(
          fontSize: size, fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic, color: color, height: 1.1,
          letterSpacing: ls,
        );
      case TextType.sectionHeading:
        return GoogleFonts.cormorantGaramond(
          fontSize: size, fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic, color: color, letterSpacing: ls,
        );
      case TextType.productName:
        return GoogleFonts.cormorantGaramond(
          fontSize: size, fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic, color: color, letterSpacing: ls,
        );

    // Sans
      case TextType.appName:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w500,
          color: color, letterSpacing: ls,
        );
      case TextType.appSubtitle:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w400,
          color: color, letterSpacing: ls,
        );
      case TextType.screenTitle:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w600,
          color: color, letterSpacing: ls,
        );
      case TextType.bodyText:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w400,
          color: color, letterSpacing: ls, height: 1.5,
        );
      case TextType.price:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w700,
          color: color, letterSpacing: ls,
        );
      case TextType.label:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w500,
          color: color, letterSpacing: ls,
        );
      case TextType.caption:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w400,
          color: color, letterSpacing: ls, height: 1.4,
        );
      case TextType.button:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w600,
          color: color, letterSpacing: ls,
        );
      case TextType.link:
        return GoogleFonts.dmSans(
          fontSize: size, fontWeight: FontWeight.w600,
          color: color, letterSpacing: ls,
          decoration: TextDecoration.none,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: _style(context),
    );
  }
}