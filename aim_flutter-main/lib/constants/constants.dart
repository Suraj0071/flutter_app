import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String APP_NAME = "Abaca AIM";
const String SUCCESS_MESSAGE = "You will be contacted by us very soon.";
const double BOTTOM_NAV_HEIGHT = 78;

const double SIZE_XXS = 6.0;
const double SIZE_XS = 8.0;
const double SIZE_SM = 12.0;
const double SIZE_IC = 20.0;
const double SIZE_MD = 24.0;
const double SIZE_LG = 36.0;

const double BORDER_RADIUS_LG = 18.0;
const double BORDER_RADIUS_MD = 12.0;

const double PADDING_SM = 16.0;
const double PADDING_XS = 12.0;
const double PADDING_MD = 24.0;
const double PADDING_LG = 32.0;
const double PADDING_XL = 48.0;

const double FONT_XS = 12.0;
const double FONT_XSS = 14.0;
const double FONT_SM = 16.0;
const double FONT_APPBAR_TITLE = 20.0;
const double FONT_MD = 24.0;
const double FONT_LG = 32.0;

const double SPACING_LG = 44.0;

const Color APPBAR_TXT_CLR = Color(0xFF2B2E2E);
const Color BG_COLOR = Color(0xFFFAFAFC);
const Color SECONDARY_CLR = Color(0xFF868698);
const Color SECONDARY_BG_CLR = Color(0xFF9D9E9F);
const Color TEXT_FIELD_BG = Color(0xFFF1F0F4);
const Color TEXT_FIELD_IC_CLR = Color(0xFFA7A7D5);
const Color BOTTOM_NAV_BG = Color(0xFFFAFAFA);
const Color BOTTOM_NAV_SELECTED = Color(0xFF504DE5);
const Color BOTTOM_NAV_UNSELECTED = Color(0xFF868698);
const Color SEMI_SEC_TEXT_CLR = Color(0xFF4C4C60);
const Color DARK_CLR = Color(0xFF333333);
const Color SELECTED_TAB_CLR = Color(0xFFEC5555);
const Color UNSELECTED_TAB_CLR = Color(0xFF1B1D4D);
const Color BLUR_COLOR = Color(0xFF9A8989);
const Color BORDER_COLOR = Color(0xFFC7C7C7);
const Color ACTIVE_BORDER_COLOR = Color(0xFF02AB7D);
const Color DIVIDER_COLOR = Color(0xFFCED6E1);
const Color DASH_COLOR = Color(0xFFB0CEF7);
const Color ICON_COLOR = Color(0xFF092C4C);
const Color ICON_BG_COLOR = Color(0xFF5B6EBC);
const Color INPUT_BORDER_CLR = Color(0xFFDCDBDD);
const Color FOCUSED_INPUT_BORDER_CLR = Color.fromARGB(255, 201, 200, 201);
const Color BTMSHEET_CLOSE_BG_CLR = Color(0xFFF0F8FF);
const Color BTN_HOVER_CLR = Color(0xFFF4F2FE);
const Color FILTER_BG = Color(0xFFFFAC7A);

const Color DARK_ERROR_COLOR = Color.fromARGB(255, 229, 57, 53);
const Color DARK_HINT_COLOR = Color.fromARGB(255, 233, 131, 129);
const Color LIGHT_ERROR_COLOR = Color.fromARGB(255, 255, 205, 210);

const Color DARK_SUCCESS_COLOR = Color.fromARGB(255, 57, 216, 51);
const Color LIGHT_SUCCESS_COLOR = Color.fromARGB(255, 205, 255, 211);

const String NOT_PROVIDED = "Not Provided";

const Color DARK_TEXT_CLR = Color(0xFF121924);
const Color NORMAL_TEXT_CLR = Color(0xFF121924);

const Color CALL_SUMMARY_TX_BG = Color(0xFFFFFAE6);
const Color CALL_SUMMARY_TX_BG_1 = Color(0xFFE0ECF9);

const String BASE_URL = "https://aim.abacaaim.com/ords/as/mobile_api";

const Map<int, Color> THEME_COLOR_SHADES = {
  50: Color.fromRGBO(255, 255, 255, .1),
  100: Color.fromRGBO(255, 255, 255, .2),
  200: Color.fromRGBO(255, 255, 255, .3),
  300: Color.fromRGBO(255, 255, 255, .4),
  400: Color.fromRGBO(255, 255, 255, .5),
  500: Color.fromRGBO(255, 255, 255, .6),
  600: Color.fromRGBO(255, 255, 255, .7),
  700: Color.fromRGBO(255, 255, 255, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(255, 255, 255, 1),
};

class TextStyles {
  static const TextStyle notProvidedtextStyle =
      TextStyle(fontSize: FONT_XSS, color: SECONDARY_CLR);
}
