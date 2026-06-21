import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_be.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_rm.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('be'),
    Locale('bg'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('hy'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('lt'),
    Locale('lv'),
    Locale('ml'),
    Locale('ms'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('rm'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sr'),
    Locale('sv'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tarot Reading'**
  String get appTitle;

  /// No description provided for @spreadSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a Spread'**
  String get spreadSelectionTitle;

  /// No description provided for @spreadSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a tarot spread that fits your question'**
  String get spreadSelectionSubtitle;

  /// No description provided for @spreadOneCardName.
  ///
  /// In en, this message translates to:
  /// **'One Card'**
  String get spreadOneCardName;

  /// No description provided for @spreadOneCardDesc.
  ///
  /// In en, this message translates to:
  /// **'A single card for a quick answer or daily guidance.'**
  String get spreadOneCardDesc;

  /// No description provided for @spreadTwoCardName.
  ///
  /// In en, this message translates to:
  /// **'Two Card'**
  String get spreadTwoCardName;

  /// No description provided for @spreadTwoCardDesc.
  ///
  /// In en, this message translates to:
  /// **'A 2-card spread to simply grasp the current situation and advice.'**
  String get spreadTwoCardDesc;

  /// No description provided for @spreadThreeCardName.
  ///
  /// In en, this message translates to:
  /// **'Three Card'**
  String get spreadThreeCardName;

  /// No description provided for @spreadThreeCardDesc.
  ///
  /// In en, this message translates to:
  /// **'A 3-card spread to understand the flow of past, present, and future.'**
  String get spreadThreeCardDesc;

  /// No description provided for @spreadFourCardName.
  ///
  /// In en, this message translates to:
  /// **'Four Card'**
  String get spreadFourCardName;

  /// No description provided for @spreadFourCardDesc.
  ///
  /// In en, this message translates to:
  /// **'A 4-card spread to clearly diagnose the cause of a problem, get advice, and see the outcome.'**
  String get spreadFourCardDesc;

  /// No description provided for @spreadFiveCardName.
  ///
  /// In en, this message translates to:
  /// **'Five Card'**
  String get spreadFiveCardName;

  /// No description provided for @spreadFiveCardDesc.
  ///
  /// In en, this message translates to:
  /// **'A 5-card spread examining the core of the situation, its causes, and potential outcomes.'**
  String get spreadFiveCardDesc;

  /// No description provided for @spreadCelticCrossName.
  ///
  /// In en, this message translates to:
  /// **'Celtic Cross'**
  String get spreadCelticCrossName;

  /// No description provided for @spreadCelticCrossDesc.
  ///
  /// In en, this message translates to:
  /// **'10 cards for an in-depth analysis of a complex problem.'**
  String get spreadCelticCrossDesc;

  /// No description provided for @positionOneCard.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Card'**
  String get positionOneCard;

  /// No description provided for @positionTwoCard1.
  ///
  /// In en, this message translates to:
  /// **'1. Situation'**
  String get positionTwoCard1;

  /// No description provided for @positionTwoCard2.
  ///
  /// In en, this message translates to:
  /// **'2. Advice'**
  String get positionTwoCard2;

  /// No description provided for @positionThreeCard1.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get positionThreeCard1;

  /// No description provided for @positionThreeCard2.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get positionThreeCard2;

  /// No description provided for @positionThreeCard3.
  ///
  /// In en, this message translates to:
  /// **'Future'**
  String get positionThreeCard3;

  /// No description provided for @positionFourCard1.
  ///
  /// In en, this message translates to:
  /// **'1. Problem'**
  String get positionFourCard1;

  /// No description provided for @positionFourCard2.
  ///
  /// In en, this message translates to:
  /// **'2. Cause'**
  String get positionFourCard2;

  /// No description provided for @positionFourCard3.
  ///
  /// In en, this message translates to:
  /// **'3. Advice'**
  String get positionFourCard3;

  /// No description provided for @positionFourCard4.
  ///
  /// In en, this message translates to:
  /// **'4. Outcome'**
  String get positionFourCard4;

  /// No description provided for @positionFiveCard1.
  ///
  /// In en, this message translates to:
  /// **'1. Present'**
  String get positionFiveCard1;

  /// No description provided for @positionFiveCard2.
  ///
  /// In en, this message translates to:
  /// **'2. Past Influences'**
  String get positionFiveCard2;

  /// No description provided for @positionFiveCard3.
  ///
  /// In en, this message translates to:
  /// **'3. Future Direction'**
  String get positionFiveCard3;

  /// No description provided for @positionFiveCard4.
  ///
  /// In en, this message translates to:
  /// **'4. Core Reason'**
  String get positionFiveCard4;

  /// No description provided for @positionFiveCard5.
  ///
  /// In en, this message translates to:
  /// **'5. Potential Outcome'**
  String get positionFiveCard5;

  /// No description provided for @positionCelticCross1.
  ///
  /// In en, this message translates to:
  /// **'1. Present (Querent)'**
  String get positionCelticCross1;

  /// No description provided for @positionCelticCross2.
  ///
  /// In en, this message translates to:
  /// **'2. The Challenge'**
  String get positionCelticCross2;

  /// No description provided for @positionCelticCross3.
  ///
  /// In en, this message translates to:
  /// **'3. The Past'**
  String get positionCelticCross3;

  /// No description provided for @positionCelticCross4.
  ///
  /// In en, this message translates to:
  /// **'4. The Future'**
  String get positionCelticCross4;

  /// No description provided for @positionCelticCross5.
  ///
  /// In en, this message translates to:
  /// **'5. Conscious'**
  String get positionCelticCross5;

  /// No description provided for @positionCelticCross6.
  ///
  /// In en, this message translates to:
  /// **'6. Subconscious'**
  String get positionCelticCross6;

  /// No description provided for @positionCelticCross7.
  ///
  /// In en, this message translates to:
  /// **'7. Advice'**
  String get positionCelticCross7;

  /// No description provided for @positionCelticCross8.
  ///
  /// In en, this message translates to:
  /// **'8. External Influences'**
  String get positionCelticCross8;

  /// No description provided for @positionCelticCross9.
  ///
  /// In en, this message translates to:
  /// **'9. Hopes and Fears'**
  String get positionCelticCross9;

  /// No description provided for @positionCelticCross10.
  ///
  /// In en, this message translates to:
  /// **'10. Outcome'**
  String get positionCelticCross10;

  /// No description provided for @navReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get navReading;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navMeanings.
  ///
  /// In en, this message translates to:
  /// **'Meanings'**
  String get navMeanings;

  /// No description provided for @navMyMenu.
  ///
  /// In en, this message translates to:
  /// **'My Menu'**
  String get navMyMenu;

  /// No description provided for @readingIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Consult the\nSpirits'**
  String get readingIntroTitle;

  /// No description provided for @readingIntroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The mystical forces are waiting...'**
  String get readingIntroSubtitle;

  /// No description provided for @readingIntroButton.
  ///
  /// In en, this message translates to:
  /// **'Consult Spirits'**
  String get readingIntroButton;

  /// No description provided for @readingSpreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the\nMysteries'**
  String get readingSpreadTitle;

  /// No description provided for @readingSpreadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Tarot Readings'**
  String get readingSpreadSubtitle;

  /// No description provided for @readingSpreadMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'What awaits you in the future...'**
  String get readingSpreadMessageTitle;

  /// No description provided for @readingSpreadMessageBody.
  ///
  /// In en, this message translates to:
  /// **'Prepare for an unexpected journey that brings both challenge and great reward.'**
  String get readingSpreadMessageBody;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Powered\nTarot Chat'**
  String get chatTitle;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Your Tarot Insights'**
  String get chatSubtitle;

  /// No description provided for @chatName.
  ///
  /// In en, this message translates to:
  /// **'Morgan'**
  String get chatName;

  /// No description provided for @chatBadge.
  ///
  /// In en, this message translates to:
  /// **'AI Chat ✨'**
  String get chatBadge;

  /// No description provided for @chatPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Chat Interface Area'**
  String get chatPlaceholder;

  /// No description provided for @meaningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed\nMeanings'**
  String get meaningsTitle;

  /// No description provided for @meaningsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deep Dive into Tarot Cards'**
  String get meaningsSubtitle;

  /// No description provided for @meaningsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Card Details Area'**
  String get meaningsPlaceholder;

  /// No description provided for @card_name_major_00.
  ///
  /// In en, this message translates to:
  /// **'0. The Fool'**
  String get card_name_major_00;

  /// No description provided for @card_upright_major_00.
  ///
  /// In en, this message translates to:
  /// **'New beginnings, adventure, infinite possibilities, freedom, innocence'**
  String get card_upright_major_00;

  /// No description provided for @card_reversed_major_00.
  ///
  /// In en, this message translates to:
  /// **'Recklessness, foolishness, carelessness, taking too big risks, unreality'**
  String get card_reversed_major_00;

  /// No description provided for @card_name_major_01.
  ///
  /// In en, this message translates to:
  /// **'I. The Magician'**
  String get card_name_major_01;

  /// No description provided for @card_upright_major_01.
  ///
  /// In en, this message translates to:
  /// **'Creativity, will, ability, power of new beginnings, determination'**
  String get card_upright_major_01;

  /// No description provided for @card_reversed_major_01.
  ///
  /// In en, this message translates to:
  /// **'Manipulation, wasted talent, deception, lack of confidence, hidden intentions'**
  String get card_reversed_major_01;

  /// No description provided for @card_name_major_02.
  ///
  /// In en, this message translates to:
  /// **'II. The High Priestess'**
  String get card_name_major_02;

  /// No description provided for @card_upright_major_02.
  ///
  /// In en, this message translates to:
  /// **'Intuition, unconscious, mystery, wisdom, inner voice'**
  String get card_upright_major_02;

  /// No description provided for @card_reversed_major_02.
  ///
  /// In en, this message translates to:
  /// **'Ignoring intuition, shallow knowledge, hidden enemies, revealing secrets'**
  String get card_reversed_major_02;

  /// No description provided for @card_name_major_03.
  ///
  /// In en, this message translates to:
  /// **'III. The Empress'**
  String get card_name_major_03;

  /// No description provided for @card_upright_major_03.
  ///
  /// In en, this message translates to:
  /// **'Abundance, motherhood, beauty, fruits of nature, creativity'**
  String get card_upright_major_03;

  /// No description provided for @card_reversed_major_03.
  ///
  /// In en, this message translates to:
  /// **'Overprotection, dependence, creative block, laziness, stagnation'**
  String get card_reversed_major_03;

  /// No description provided for @card_name_major_04.
  ///
  /// In en, this message translates to:
  /// **'IV. The Emperor'**
  String get card_name_major_04;

  /// No description provided for @card_upright_major_04.
  ///
  /// In en, this message translates to:
  /// **'Authority, structure, stability, fatherhood, control, responsibility'**
  String get card_upright_major_04;

  /// No description provided for @card_reversed_major_04.
  ///
  /// In en, this message translates to:
  /// **'Dictatorship, desire for control, lack of flexibility, incompetence, repression'**
  String get card_reversed_major_04;

  /// No description provided for @card_name_major_05.
  ///
  /// In en, this message translates to:
  /// **'V. The Hierophant'**
  String get card_name_major_05;

  /// No description provided for @card_upright_major_05.
  ///
  /// In en, this message translates to:
  /// **'Tradition, belief, education, spiritual guidance, conservatism'**
  String get card_upright_major_05;

  /// No description provided for @card_reversed_major_05.
  ///
  /// In en, this message translates to:
  /// **'Rebellion, breaking conventions, dogmatic attitude, outdated ideas, bad advice'**
  String get card_reversed_major_05;

  /// No description provided for @card_name_major_06.
  ///
  /// In en, this message translates to:
  /// **'VI. The Lovers'**
  String get card_name_major_06;

  /// No description provided for @card_upright_major_06.
  ///
  /// In en, this message translates to:
  /// **'Love, harmony, relationships, important choices, trust'**
  String get card_upright_major_06;

  /// No description provided for @card_reversed_major_06.
  ///
  /// In en, this message translates to:
  /// **'Discord, wrong choices, loss of trust, temptation, imbalance'**
  String get card_reversed_major_06;

  /// No description provided for @card_name_major_07.
  ///
  /// In en, this message translates to:
  /// **'VII. The Chariot'**
  String get card_name_major_07;

  /// No description provided for @card_upright_major_07.
  ///
  /// In en, this message translates to:
  /// **'Willpower, victory, determination, direction, drive towards success'**
  String get card_upright_major_07;

  /// No description provided for @card_reversed_major_07.
  ///
  /// In en, this message translates to:
  /// **'Loss of control, loss of direction, helplessness, aggression, obstacles'**
  String get card_reversed_major_07;

  /// No description provided for @card_name_major_08.
  ///
  /// In en, this message translates to:
  /// **'VIII. Strength'**
  String get card_name_major_08;

  /// No description provided for @card_upright_major_08.
  ///
  /// In en, this message translates to:
  /// **'Courage, patience, inner strength, gentle control, compassion'**
  String get card_upright_major_08;

  /// No description provided for @card_reversed_major_08.
  ///
  /// In en, this message translates to:
  /// **'Fear, weakness, loss of self-control, impulsiveness, arrogance'**
  String get card_reversed_major_08;

  /// No description provided for @card_name_major_09.
  ///
  /// In en, this message translates to:
  /// **'IX. The Hermit'**
  String get card_name_major_09;

  /// No description provided for @card_upright_major_09.
  ///
  /// In en, this message translates to:
  /// **'Introspection, wisdom, solitude, enlightenment, spiritual guide'**
  String get card_upright_major_09;

  /// No description provided for @card_reversed_major_09.
  ///
  /// In en, this message translates to:
  /// **'Isolation, loneliness, escapism, foolish stubbornness, reclusiveness'**
  String get card_reversed_major_09;

  /// No description provided for @card_name_major_10.
  ///
  /// In en, this message translates to:
  /// **'X. Wheel of Fortune'**
  String get card_name_major_10;

  /// No description provided for @card_upright_major_10.
  ///
  /// In en, this message translates to:
  /// **'Turning point, destiny, luck, continuous change, opportunity'**
  String get card_upright_major_10;

  /// No description provided for @card_reversed_major_10.
  ///
  /// In en, this message translates to:
  /// **'Bad luck, resistance, uncontrollable change, repetition of misfortune'**
  String get card_reversed_major_10;

  /// No description provided for @card_name_major_11.
  ///
  /// In en, this message translates to:
  /// **'XI. Justice'**
  String get card_name_major_11;

  /// No description provided for @card_upright_major_11.
  ///
  /// In en, this message translates to:
  /// **'Fairness, truth, karma, balance, rational decisions'**
  String get card_upright_major_11;

  /// No description provided for @card_reversed_major_11.
  ///
  /// In en, this message translates to:
  /// **'Unfairness, prejudice, dishonesty, unavoidable punishment, imbalance'**
  String get card_reversed_major_11;

  /// No description provided for @card_name_major_12.
  ///
  /// In en, this message translates to:
  /// **'XII. The Hanged Man'**
  String get card_name_major_12;

  /// No description provided for @card_upright_major_12.
  ///
  /// In en, this message translates to:
  /// **'Sacrifice, new perspective, waiting, insight, temporary suspension'**
  String get card_upright_major_12;

  /// No description provided for @card_reversed_major_12.
  ///
  /// In en, this message translates to:
  /// **'Meaningless sacrifice, delay, refusing progress, selfishness'**
  String get card_reversed_major_12;

  /// No description provided for @card_name_major_13.
  ///
  /// In en, this message translates to:
  /// **'XIII. Death'**
  String get card_name_major_13;

  /// No description provided for @card_upright_major_13.
  ///
  /// In en, this message translates to:
  /// **'End and new beginning, change, transition, clearing the past'**
  String get card_upright_major_13;

  /// No description provided for @card_reversed_major_13.
  ///
  /// In en, this message translates to:
  /// **'Resistance to change, stagnation, clinging to the old, fear'**
  String get card_reversed_major_13;

  /// No description provided for @card_name_major_14.
  ///
  /// In en, this message translates to:
  /// **'XIV. Temperance'**
  String get card_name_major_14;

  /// No description provided for @card_upright_major_14.
  ///
  /// In en, this message translates to:
  /// **'Harmony, balance, moderation, healing, sense of purpose'**
  String get card_upright_major_14;

  /// No description provided for @card_reversed_major_14.
  ///
  /// In en, this message translates to:
  /// **'Imbalance, excess, extreme actions, disharmony, conflict'**
  String get card_reversed_major_14;

  /// No description provided for @card_name_major_15.
  ///
  /// In en, this message translates to:
  /// **'XV. The Devil'**
  String get card_name_major_15;

  /// No description provided for @card_upright_major_15.
  ///
  /// In en, this message translates to:
  /// **'Obsession, materialism, bondage, temptation, destructive desires'**
  String get card_upright_major_15;

  /// No description provided for @card_reversed_major_15.
  ///
  /// In en, this message translates to:
  /// **'Liberation, breaking free from bondage, independence, enlightenment, freedom'**
  String get card_reversed_major_15;

  /// No description provided for @card_name_major_16.
  ///
  /// In en, this message translates to:
  /// **'XVI. The Tower'**
  String get card_name_major_16;

  /// No description provided for @card_upright_major_16.
  ///
  /// In en, this message translates to:
  /// **'Sudden change, destruction, liberation, revelation, collapse'**
  String get card_upright_major_16;

  /// No description provided for @card_reversed_major_16.
  ///
  /// In en, this message translates to:
  /// **'Averting disaster, delaying unavoidable change, ignoring warnings'**
  String get card_reversed_major_16;

  /// No description provided for @card_name_major_17.
  ///
  /// In en, this message translates to:
  /// **'XVII. The Star'**
  String get card_name_major_17;

  /// No description provided for @card_upright_major_17.
  ///
  /// In en, this message translates to:
  /// **'Hope, inspiration, serenity, healing and positivity, spiritual guidance'**
  String get card_upright_major_17;

  /// No description provided for @card_reversed_major_17.
  ///
  /// In en, this message translates to:
  /// **'Despair, disappointment, lack of inspiration, pessimism, confusion'**
  String get card_reversed_major_17;

  /// No description provided for @card_name_major_18.
  ///
  /// In en, this message translates to:
  /// **'XVIII. The Moon'**
  String get card_name_major_18;

  /// No description provided for @card_upright_major_18.
  ///
  /// In en, this message translates to:
  /// **'Anxiety, illusion, intuition, hidden truths, deception'**
  String get card_upright_major_18;

  /// No description provided for @card_reversed_major_18.
  ///
  /// In en, this message translates to:
  /// **'Overcoming fear, discovery of secrets, resolution of anxiety, revealing truth'**
  String get card_reversed_major_18;

  /// No description provided for @card_name_major_19.
  ///
  /// In en, this message translates to:
  /// **'XIX. The Sun'**
  String get card_name_major_19;

  /// No description provided for @card_upright_major_19.
  ///
  /// In en, this message translates to:
  /// **'Success, positivity, vitality, happiness and achievement, joy'**
  String get card_upright_major_19;

  /// No description provided for @card_reversed_major_19.
  ///
  /// In en, this message translates to:
  /// **'Delayed success, exaggeration, decreased vitality, the dark side of joy'**
  String get card_reversed_major_19;

  /// No description provided for @card_name_major_20.
  ///
  /// In en, this message translates to:
  /// **'XX. Judgement'**
  String get card_name_major_20;

  /// No description provided for @card_upright_major_20.
  ///
  /// In en, this message translates to:
  /// **'Rebirth, decision, forgiveness, new calling, inner awakening'**
  String get card_upright_major_20;

  /// No description provided for @card_reversed_major_20.
  ///
  /// In en, this message translates to:
  /// **'Regret, self-doubt, fear of change, lingering attachment, punishment'**
  String get card_reversed_major_20;

  /// No description provided for @card_name_major_21.
  ///
  /// In en, this message translates to:
  /// **'XXI. The World'**
  String get card_name_major_21;

  /// No description provided for @card_upright_major_21.
  ///
  /// In en, this message translates to:
  /// **'Completion, achievement, integration, new dimension, successful ending'**
  String get card_upright_major_21;

  /// No description provided for @card_reversed_major_21.
  ///
  /// In en, this message translates to:
  /// **'Incompletion, postponement, stagnation, fear of success, delay'**
  String get card_reversed_major_21;

  /// No description provided for @card_name_cups_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Cups'**
  String get card_name_cups_01;

  /// No description provided for @card_upright_cups_01.
  ///
  /// In en, this message translates to:
  /// **'New emotions, beginning of love, intuition, spiritual fulfillment'**
  String get card_upright_cups_01;

  /// No description provided for @card_reversed_cups_01.
  ///
  /// In en, this message translates to:
  /// **'Emotional blockage, feeling unloved, emptiness, sadness'**
  String get card_reversed_cups_01;

  /// No description provided for @card_name_cups_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Cups'**
  String get card_name_cups_02;

  /// No description provided for @card_upright_cups_02.
  ///
  /// In en, this message translates to:
  /// **'Relationship harmony, union, love, mutual respect, cooperation'**
  String get card_upright_cups_02;

  /// No description provided for @card_reversed_cups_02.
  ///
  /// In en, this message translates to:
  /// **'Relationship discord, separation, misunderstanding, imbalance, unrequited love'**
  String get card_reversed_cups_02;

  /// No description provided for @card_name_cups_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Cups'**
  String get card_name_cups_03;

  /// No description provided for @card_upright_cups_03.
  ///
  /// In en, this message translates to:
  /// **'Celebration, friendship, community, joy, creative fulfillment'**
  String get card_upright_cups_03;

  /// No description provided for @card_reversed_cups_03.
  ///
  /// In en, this message translates to:
  /// **'Excessive drinking, exclusion, cliques, love triangle, cancelled celebration'**
  String get card_reversed_cups_03;

  /// No description provided for @card_name_cups_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Cups'**
  String get card_name_cups_04;

  /// No description provided for @card_upright_cups_04.
  ///
  /// In en, this message translates to:
  /// **'Indifference, boredom, meditation, missed opportunities, introspection'**
  String get card_upright_cups_04;

  /// No description provided for @card_reversed_cups_04.
  ///
  /// In en, this message translates to:
  /// **'New awareness, seizing opportunities, renewed vitality, awakening'**
  String get card_reversed_cups_04;

  /// No description provided for @card_name_cups_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Cups'**
  String get card_name_cups_05;

  /// No description provided for @card_upright_cups_05.
  ///
  /// In en, this message translates to:
  /// **'Loss, sorrow, regret over the past, pessimism'**
  String get card_upright_cups_05;

  /// No description provided for @card_reversed_cups_05.
  ///
  /// In en, this message translates to:
  /// **'Overcoming loss, acceptance, healing, finding new hope'**
  String get card_reversed_cups_05;

  /// No description provided for @card_name_cups_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Cups'**
  String get card_name_cups_06;

  /// No description provided for @card_upright_cups_06.
  ///
  /// In en, this message translates to:
  /// **'Nostalgia for the past, childhood, innocence, old friends, memories'**
  String get card_upright_cups_06;

  /// No description provided for @card_reversed_cups_06.
  ///
  /// In en, this message translates to:
  /// **'Stuck in the past, ignoring the future, independence, growth'**
  String get card_reversed_cups_06;

  /// No description provided for @card_name_cups_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Cups'**
  String get card_name_cups_07;

  /// No description provided for @card_upright_cups_07.
  ///
  /// In en, this message translates to:
  /// **'Illusion, dreams, confusion of choices, escapism, daydreaming'**
  String get card_upright_cups_07;

  /// No description provided for @card_reversed_cups_07.
  ///
  /// In en, this message translates to:
  /// **'Facing reality, clear goals, waking from illusion, determination'**
  String get card_reversed_cups_07;

  /// No description provided for @card_name_cups_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Cups'**
  String get card_name_cups_08;

  /// No description provided for @card_upright_cups_08.
  ///
  /// In en, this message translates to:
  /// **'Disappointment, departure, abandonment for deeper meaning, resignation'**
  String get card_upright_cups_08;

  /// No description provided for @card_reversed_cups_08.
  ///
  /// In en, this message translates to:
  /// **'Inability to leave, clinging to the past, relationship recovery, fear'**
  String get card_reversed_cups_08;

  /// No description provided for @card_name_cups_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Cups'**
  String get card_name_cups_09;

  /// No description provided for @card_upright_cups_09.
  ///
  /// In en, this message translates to:
  /// **'Wish fulfillment, satisfaction, sensual pleasure, pride, happiness'**
  String get card_upright_cups_09;

  /// No description provided for @card_reversed_cups_09.
  ///
  /// In en, this message translates to:
  /// **'Dissatisfaction, vanity, superficial success, greed, avarice'**
  String get card_reversed_cups_09;

  /// No description provided for @card_name_cups_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Cups'**
  String get card_name_cups_10;

  /// No description provided for @card_upright_cups_10.
  ///
  /// In en, this message translates to:
  /// **'Family happiness, peace, emotional fulfillment, harmonious relationships'**
  String get card_upright_cups_10;

  /// No description provided for @card_reversed_cups_10.
  ///
  /// In en, this message translates to:
  /// **'Family conflict, broken home, discord, loss of peace'**
  String get card_reversed_cups_10;

  /// No description provided for @card_name_cups_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Cups'**
  String get card_name_cups_11;

  /// No description provided for @card_upright_cups_11.
  ///
  /// In en, this message translates to:
  /// **'New inspiration, creativity, emotional message, intuition'**
  String get card_upright_cups_11;

  /// No description provided for @card_reversed_cups_11.
  ///
  /// In en, this message translates to:
  /// **'Emotional immaturity, creative block, bad news, sensitivity'**
  String get card_reversed_cups_11;

  /// No description provided for @card_name_cups_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Cups'**
  String get card_name_cups_12;

  /// No description provided for @card_upright_cups_12.
  ///
  /// In en, this message translates to:
  /// **'Romance, charm, emotional approach, imagination, chivalry'**
  String get card_upright_cups_12;

  /// No description provided for @card_reversed_cups_12.
  ///
  /// In en, this message translates to:
  /// **'Unreality, capriciousness, jealousy, unreliability, deception'**
  String get card_reversed_cups_12;

  /// No description provided for @card_name_cups_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Cups'**
  String get card_name_cups_13;

  /// No description provided for @card_upright_cups_13.
  ///
  /// In en, this message translates to:
  /// **'Empathy, tenderness, spiritual intuition, emotional stability, consideration'**
  String get card_upright_cups_13;

  /// No description provided for @card_reversed_cups_13.
  ///
  /// In en, this message translates to:
  /// **'Emotional excess, instability, dependent nature, victim mentality'**
  String get card_reversed_cups_13;

  /// No description provided for @card_name_cups_14.
  ///
  /// In en, this message translates to:
  /// **'King of Cups'**
  String get card_name_cups_14;

  /// No description provided for @card_upright_cups_14.
  ///
  /// In en, this message translates to:
  /// **'Emotional control, balance, diplomacy, tolerance, wise advice'**
  String get card_upright_cups_14;

  /// No description provided for @card_reversed_cups_14.
  ///
  /// In en, this message translates to:
  /// **'Emotional manipulation, coldness, instability, moodiness, ruthlessness'**
  String get card_reversed_cups_14;

  /// No description provided for @card_name_pentacles_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Pentacles'**
  String get card_name_pentacles_01;

  /// No description provided for @card_upright_pentacles_01.
  ///
  /// In en, this message translates to:
  /// **'New opportunities, financial beginnings, abundance, practical achievement'**
  String get card_upright_pentacles_01;

  /// No description provided for @card_reversed_pentacles_01.
  ///
  /// In en, this message translates to:
  /// **'Lost opportunities, financial loss, delay, bad investment'**
  String get card_reversed_pentacles_01;

  /// No description provided for @card_name_pentacles_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Pentacles'**
  String get card_name_pentacles_02;

  /// No description provided for @card_upright_pentacles_02.
  ///
  /// In en, this message translates to:
  /// **'Balance, adaptability, time/financial management, flexibility'**
  String get card_upright_pentacles_02;

  /// No description provided for @card_reversed_pentacles_02.
  ///
  /// In en, this message translates to:
  /// **'Imbalance, overwhelmed, financial difficulties, stress'**
  String get card_reversed_pentacles_02;

  /// No description provided for @card_name_pentacles_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Pentacles'**
  String get card_name_pentacles_03;

  /// No description provided for @card_upright_pentacles_03.
  ///
  /// In en, this message translates to:
  /// **'Teamwork, collaboration, skill, recognized effort, construction'**
  String get card_upright_pentacles_03;

  /// No description provided for @card_reversed_pentacles_03.
  ///
  /// In en, this message translates to:
  /// **'Lack of collaboration, lack of skill, unrecognized effort, conflict of opinions'**
  String get card_reversed_pentacles_03;

  /// No description provided for @card_name_pentacles_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Pentacles'**
  String get card_name_pentacles_04;

  /// No description provided for @card_upright_pentacles_04.
  ///
  /// In en, this message translates to:
  /// **'Stability, possessiveness, conservatism, stinginess, accumulation'**
  String get card_upright_pentacles_04;

  /// No description provided for @card_reversed_pentacles_04.
  ///
  /// In en, this message translates to:
  /// **'Cost of greed, loss, financial mismanagement, letting go of attachment'**
  String get card_reversed_pentacles_04;

  /// No description provided for @card_name_pentacles_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Pentacles'**
  String get card_name_pentacles_05;

  /// No description provided for @card_upright_pentacles_05.
  ///
  /// In en, this message translates to:
  /// **'Poverty, financial/emotional lack, exclusion, adversity'**
  String get card_upright_pentacles_05;

  /// No description provided for @card_reversed_pentacles_05.
  ///
  /// In en, this message translates to:
  /// **'Financial recovery, helping hand, overcoming adversity, positive change'**
  String get card_reversed_pentacles_05;

  /// No description provided for @card_name_pentacles_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Pentacles'**
  String get card_name_pentacles_06;

  /// No description provided for @card_upright_pentacles_06.
  ///
  /// In en, this message translates to:
  /// **'Charity, sharing, patronage, fairness, giving and receiving'**
  String get card_upright_pentacles_06;

  /// No description provided for @card_reversed_pentacles_06.
  ///
  /// In en, this message translates to:
  /// **'Selfishness, debt, inequality, showing off, exploitation'**
  String get card_reversed_pentacles_06;

  /// No description provided for @card_name_pentacles_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Pentacles'**
  String get card_name_pentacles_07;

  /// No description provided for @card_upright_pentacles_07.
  ///
  /// In en, this message translates to:
  /// **'Patience, long-term vision, waiting for reward for effort, evaluation'**
  String get card_upright_pentacles_07;

  /// No description provided for @card_reversed_pentacles_07.
  ///
  /// In en, this message translates to:
  /// **'Impatience, fruitless effort, delay, frustration, investment failure'**
  String get card_reversed_pentacles_07;

  /// No description provided for @card_name_pentacles_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Pentacles'**
  String get card_name_pentacles_08;

  /// No description provided for @card_upright_pentacles_08.
  ///
  /// In en, this message translates to:
  /// **'Craftsmanship, dedication, attention to detail, mastery'**
  String get card_upright_pentacles_08;

  /// No description provided for @card_reversed_pentacles_08.
  ///
  /// In en, this message translates to:
  /// **'Boredom, trap of perfectionism, laziness, loss of passion'**
  String get card_reversed_pentacles_08;

  /// No description provided for @card_name_pentacles_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Pentacles'**
  String get card_name_pentacles_09;

  /// No description provided for @card_upright_pentacles_09.
  ///
  /// In en, this message translates to:
  /// **'Achievement, independence, leisure, financial comfort, self-reward'**
  String get card_upright_pentacles_09;

  /// No description provided for @card_reversed_pentacles_09.
  ///
  /// In en, this message translates to:
  /// **'Overspending, superficial glamour, dependence, financial instability'**
  String get card_reversed_pentacles_09;

  /// No description provided for @card_name_pentacles_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Pentacles'**
  String get card_name_pentacles_10;

  /// No description provided for @card_upright_pentacles_10.
  ///
  /// In en, this message translates to:
  /// **'Family business, accumulation of wealth, legacy, stable life, tradition'**
  String get card_upright_pentacles_10;

  /// No description provided for @card_reversed_pentacles_10.
  ///
  /// In en, this message translates to:
  /// **'Loss of wealth, family disputes, rebellion against tradition, instability'**
  String get card_reversed_pentacles_10;

  /// No description provided for @card_name_pentacles_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Pentacles'**
  String get card_name_pentacles_11;

  /// No description provided for @card_upright_pentacles_11.
  ///
  /// In en, this message translates to:
  /// **'Realistic goals, new studies, opportunities, practicality, planning'**
  String get card_upright_pentacles_11;

  /// No description provided for @card_reversed_pentacles_11.
  ///
  /// In en, this message translates to:
  /// **'Delayed plans, lack of practicality, laziness, procrastination'**
  String get card_reversed_pentacles_11;

  /// No description provided for @card_name_pentacles_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Pentacles'**
  String get card_name_pentacles_12;

  /// No description provided for @card_upright_pentacles_12.
  ///
  /// In en, this message translates to:
  /// **'Diligence, responsibility, perseverance, gradual progress, reliability'**
  String get card_upright_pentacles_12;

  /// No description provided for @card_reversed_pentacles_12.
  ///
  /// In en, this message translates to:
  /// **'Stubbornness, apathy, workaholism, lack of flexibility, stagnation'**
  String get card_reversed_pentacles_12;

  /// No description provided for @card_name_pentacles_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Pentacles'**
  String get card_name_pentacles_13;

  /// No description provided for @card_upright_pentacles_13.
  ///
  /// In en, this message translates to:
  /// **'Practical care, practical advice, abundance, generosity, comfort'**
  String get card_upright_pentacles_13;

  /// No description provided for @card_reversed_pentacles_13.
  ///
  /// In en, this message translates to:
  /// **'Overcontrol, possessiveness, selfishness, financial insecurity, overspending'**
  String get card_reversed_pentacles_13;

  /// No description provided for @card_name_pentacles_14.
  ///
  /// In en, this message translates to:
  /// **'King of Pentacles'**
  String get card_name_pentacles_14;

  /// No description provided for @card_upright_pentacles_14.
  ///
  /// In en, this message translates to:
  /// **'Wealth and success, business acumen, authority, strong patron'**
  String get card_upright_pentacles_14;

  /// No description provided for @card_reversed_pentacles_14.
  ///
  /// In en, this message translates to:
  /// **'Materialism, corruption, greed, stubbornness, oppressive authority'**
  String get card_reversed_pentacles_14;

  /// No description provided for @card_name_swords_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Swords'**
  String get card_name_swords_01;

  /// No description provided for @card_upright_swords_01.
  ///
  /// In en, this message translates to:
  /// **'Clear insight, new ideas, truth, mental breakthrough'**
  String get card_upright_swords_01;

  /// No description provided for @card_reversed_swords_01.
  ///
  /// In en, this message translates to:
  /// **'Confusion, misinformation, loss of judgment, lack of communication'**
  String get card_reversed_swords_01;

  /// No description provided for @card_name_swords_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Swords'**
  String get card_name_swords_02;

  /// No description provided for @card_upright_swords_02.
  ///
  /// In en, this message translates to:
  /// **'Indecision, blindness, emotional blockade, avoiding difficult decisions'**
  String get card_upright_swords_02;

  /// No description provided for @card_reversed_swords_02.
  ///
  /// In en, this message translates to:
  /// **'Decision, facing facts, mistakes due to lack of information'**
  String get card_reversed_swords_02;

  /// No description provided for @card_name_swords_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Swords'**
  String get card_name_swords_03;

  /// No description provided for @card_upright_swords_03.
  ///
  /// In en, this message translates to:
  /// **'Heartbreak, sorrow, separation, wounds, painful truth'**
  String get card_upright_swords_03;

  /// No description provided for @card_reversed_swords_03.
  ///
  /// In en, this message translates to:
  /// **'Overcoming pain, healing, forgiveness, shaking off sorrow'**
  String get card_reversed_swords_03;

  /// No description provided for @card_name_swords_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Swords'**
  String get card_name_swords_04;

  /// No description provided for @card_upright_swords_04.
  ///
  /// In en, this message translates to:
  /// **'Rest, recovery, meditation, stress relief, inner peace'**
  String get card_upright_swords_04;

  /// No description provided for @card_reversed_swords_04.
  ///
  /// In en, this message translates to:
  /// **'Exhaustion, refusal to recover, forced rest, extreme stress'**
  String get card_reversed_swords_04;

  /// No description provided for @card_name_swords_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Swords'**
  String get card_name_swords_05;

  /// No description provided for @card_upright_swords_05.
  ///
  /// In en, this message translates to:
  /// **'Pyrrhic victory, betrayal, conflict, hostility, meanness'**
  String get card_upright_swords_05;

  /// No description provided for @card_reversed_swords_05.
  ///
  /// In en, this message translates to:
  /// **'Conflict resolution, reconciliation, compromise, admitting defeat, giving up revenge'**
  String get card_reversed_swords_05;

  /// No description provided for @card_name_swords_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Swords'**
  String get card_name_swords_06;

  /// No description provided for @card_upright_swords_06.
  ///
  /// In en, this message translates to:
  /// **'Transition, moving away from pain, healing journey, movement, travel'**
  String get card_upright_swords_06;

  /// No description provided for @card_reversed_swords_06.
  ///
  /// In en, this message translates to:
  /// **'Resistance to change, past wounds holding back, delay'**
  String get card_reversed_swords_06;

  /// No description provided for @card_name_swords_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Swords'**
  String get card_name_swords_07;

  /// No description provided for @card_upright_swords_07.
  ///
  /// In en, this message translates to:
  /// **'Deception, trickery, strategy, covert actions, escape'**
  String get card_upright_swords_07;

  /// No description provided for @card_reversed_swords_07.
  ///
  /// In en, this message translates to:
  /// **'Confession, revealing secrets, deception exposed, guilt, head-on confrontation'**
  String get card_reversed_swords_07;

  /// No description provided for @card_name_swords_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Swords'**
  String get card_name_swords_08;

  /// No description provided for @card_upright_swords_08.
  ///
  /// In en, this message translates to:
  /// **'Self-imposed limitation, helplessness, limited thinking, prison of fear'**
  String get card_upright_swords_08;

  /// No description provided for @card_reversed_swords_08.
  ///
  /// In en, this message translates to:
  /// **'Liberation, breaking free from one\'s own prison, new perspective'**
  String get card_reversed_swords_08;

  /// No description provided for @card_name_swords_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Swords'**
  String get card_name_swords_09;

  /// No description provided for @card_upright_swords_09.
  ///
  /// In en, this message translates to:
  /// **'Anxiety, despair, insomnia, guilt, inner fear'**
  String get card_upright_swords_09;

  /// No description provided for @card_reversed_swords_09.
  ///
  /// In en, this message translates to:
  /// **'Overcoming fear, light of hope, resolving insomnia, facing facts'**
  String get card_reversed_swords_09;

  /// No description provided for @card_name_swords_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Swords'**
  String get card_name_swords_10;

  /// No description provided for @card_upright_swords_10.
  ///
  /// In en, this message translates to:
  /// **'Ruin, deep wounds, betrayal, hitting rock bottom, arrival of an end'**
  String get card_upright_swords_10;

  /// No description provided for @card_reversed_swords_10.
  ///
  /// In en, this message translates to:
  /// **'Recovery from ruin, the worst is over, survival, reconstruction'**
  String get card_reversed_swords_10;

  /// No description provided for @card_name_swords_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Swords'**
  String get card_name_swords_11;

  /// No description provided for @card_upright_swords_11.
  ///
  /// In en, this message translates to:
  /// **'Curiosity, keen analytical skills, truth-seeking, new ideas'**
  String get card_upright_swords_11;

  /// No description provided for @card_reversed_swords_11.
  ///
  /// In en, this message translates to:
  /// **'Rashness, impatience, cynicism, baseless rumors, rudeness'**
  String get card_reversed_swords_11;

  /// No description provided for @card_name_swords_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Swords'**
  String get card_name_swords_12;

  /// No description provided for @card_upright_swords_12.
  ///
  /// In en, this message translates to:
  /// **'Charge, ambition, intellectual drive, swift and decisive action'**
  String get card_upright_swords_12;

  /// No description provided for @card_reversed_swords_12.
  ///
  /// In en, this message translates to:
  /// **'Recklessness, aggression, inconsiderate words/actions, impulsiveness, ruthlessness'**
  String get card_reversed_swords_12;

  /// No description provided for @card_name_swords_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Swords'**
  String get card_name_swords_13;

  /// No description provided for @card_upright_swords_13.
  ///
  /// In en, this message translates to:
  /// **'Independence, clear communication, sharp judgment, honesty, objectivity'**
  String get card_upright_swords_13;

  /// No description provided for @card_reversed_swords_13.
  ///
  /// In en, this message translates to:
  /// **'Heartlessness, cruelty, excessive criticism, resentment, isolation'**
  String get card_reversed_swords_13;

  /// No description provided for @card_name_swords_14.
  ///
  /// In en, this message translates to:
  /// **'King of Swords'**
  String get card_name_swords_14;

  /// No description provided for @card_upright_swords_14.
  ///
  /// In en, this message translates to:
  /// **'Authority, intellectual insight, logic, fairness, principles, expert'**
  String get card_upright_swords_14;

  /// No description provided for @card_reversed_swords_14.
  ///
  /// In en, this message translates to:
  /// **'Abuse of power, irrationality, cruelty, desire for control, dictatorship'**
  String get card_reversed_swords_14;

  /// No description provided for @card_name_wands_01.
  ///
  /// In en, this message translates to:
  /// **'Ace of Wands'**
  String get card_name_wands_01;

  /// No description provided for @card_upright_wands_01.
  ///
  /// In en, this message translates to:
  /// **'Passion, inspiration, creative power, new potential, vitality'**
  String get card_upright_wands_01;

  /// No description provided for @card_reversed_wands_01.
  ///
  /// In en, this message translates to:
  /// **'Delayed passion, lack of inspiration, loss of motivation, identity confusion'**
  String get card_reversed_wands_01;

  /// No description provided for @card_name_wands_02.
  ///
  /// In en, this message translates to:
  /// **'Two of Wands'**
  String get card_name_wands_02;

  /// No description provided for @card_upright_wands_02.
  ///
  /// In en, this message translates to:
  /// **'Planning, vision, long-term goals, determination, exploration'**
  String get card_upright_wands_02;

  /// No description provided for @card_reversed_wands_02.
  ///
  /// In en, this message translates to:
  /// **'Lack of planning, procrastination, stagnation due to fear, limited vision'**
  String get card_reversed_wands_02;

  /// No description provided for @card_name_wands_03.
  ///
  /// In en, this message translates to:
  /// **'Three of Wands'**
  String get card_name_wands_03;

  /// No description provided for @card_upright_wands_03.
  ///
  /// In en, this message translates to:
  /// **'Realization of hopes, progress, expansion, foresight, leadership'**
  String get card_upright_wands_03;

  /// No description provided for @card_reversed_wands_03.
  ///
  /// In en, this message translates to:
  /// **'Delayed growth, frustration, unexpected obstacles, narrow-mindedness'**
  String get card_reversed_wands_03;

  /// No description provided for @card_name_wands_04.
  ///
  /// In en, this message translates to:
  /// **'Four of Wands'**
  String get card_name_wands_04;

  /// No description provided for @card_upright_wands_04.
  ///
  /// In en, this message translates to:
  /// **'Celebration, comfort, joy of achievement, welcome, domestic event'**
  String get card_upright_wands_04;

  /// No description provided for @card_reversed_wands_04.
  ///
  /// In en, this message translates to:
  /// **'Cancelled event, domestic discord, temporary stability, delayed celebration'**
  String get card_reversed_wands_04;

  /// No description provided for @card_name_wands_05.
  ///
  /// In en, this message translates to:
  /// **'Five of Wands'**
  String get card_name_wands_05;

  /// No description provided for @card_upright_wands_05.
  ///
  /// In en, this message translates to:
  /// **'Competition, conflict, disagreement, disputes, challenge'**
  String get card_upright_wands_05;

  /// No description provided for @card_reversed_wands_05.
  ///
  /// In en, this message translates to:
  /// **'Compromise, avoidance of conflict, cooperation, pursuit of peace, calming confusion'**
  String get card_reversed_wands_05;

  /// No description provided for @card_name_wands_06.
  ///
  /// In en, this message translates to:
  /// **'Six of Wands'**
  String get card_name_wands_06;

  /// No description provided for @card_upright_wands_06.
  ///
  /// In en, this message translates to:
  /// **'Success, public recognition, victory, confidence, rise of a leader'**
  String get card_upright_wands_06;

  /// No description provided for @card_reversed_wands_06.
  ///
  /// In en, this message translates to:
  /// **'Defeat, dishonor, lack of recognition, arrogance, fall from grace'**
  String get card_reversed_wands_06;

  /// No description provided for @card_name_wands_07.
  ///
  /// In en, this message translates to:
  /// **'Seven of Wands'**
  String get card_name_wands_07;

  /// No description provided for @card_upright_wands_07.
  ///
  /// In en, this message translates to:
  /// **'Courage, defense, standing up to competition, firm belief, perseverance'**
  String get card_upright_wands_07;

  /// No description provided for @card_reversed_wands_07.
  ///
  /// In en, this message translates to:
  /// **'Giving up, feeling overwhelmed, compromise, loss of confidence, cowardice'**
  String get card_reversed_wands_07;

  /// No description provided for @card_name_wands_08.
  ///
  /// In en, this message translates to:
  /// **'Eight of Wands'**
  String get card_name_wands_08;

  /// No description provided for @card_upright_wands_08.
  ///
  /// In en, this message translates to:
  /// **'Rapid progress, quick conclusion, news, agility, speed'**
  String get card_upright_wands_08;

  /// No description provided for @card_reversed_wands_08.
  ///
  /// In en, this message translates to:
  /// **'Delay, confusion, mistakes due to haste, communication breakdown'**
  String get card_reversed_wands_08;

  /// No description provided for @card_name_wands_09.
  ///
  /// In en, this message translates to:
  /// **'Nine of Wands'**
  String get card_name_wands_09;

  /// No description provided for @card_upright_wands_09.
  ///
  /// In en, this message translates to:
  /// **'Resilience, defensive stance, continuing despite exhaustion, vigilance, endurance test'**
  String get card_upright_wands_09;

  /// No description provided for @card_reversed_wands_09.
  ///
  /// In en, this message translates to:
  /// **'Fatigue, paranoia, giving up, stubbornness, unnecessary resistance'**
  String get card_reversed_wands_09;

  /// No description provided for @card_name_wands_10.
  ///
  /// In en, this message translates to:
  /// **'Ten of Wands'**
  String get card_name_wands_10;

  /// No description provided for @card_upright_wands_10.
  ///
  /// In en, this message translates to:
  /// **'Excessive burden, extreme pressure, responsibility, oppression, breaking point'**
  String get card_upright_wands_10;

  /// No description provided for @card_reversed_wands_10.
  ///
  /// In en, this message translates to:
  /// **'Laying down burden, avoiding responsibility, burnout, delegation, overcoming'**
  String get card_reversed_wands_10;

  /// No description provided for @card_name_wands_11.
  ///
  /// In en, this message translates to:
  /// **'Page of Wands'**
  String get card_name_wands_11;

  /// No description provided for @card_upright_wands_11.
  ///
  /// In en, this message translates to:
  /// **'Exploration, discovery, passionate ideas, energy, charm'**
  String get card_upright_wands_11;

  /// No description provided for @card_reversed_wands_11.
  ///
  /// In en, this message translates to:
  /// **'Loss of direction, immaturity, easily bored, vain delusions, irresponsibility'**
  String get card_reversed_wands_11;

  /// No description provided for @card_name_wands_12.
  ///
  /// In en, this message translates to:
  /// **'Knight of Wands'**
  String get card_name_wands_12;

  /// No description provided for @card_upright_wands_12.
  ///
  /// In en, this message translates to:
  /// **'Passionate advancement, adventurous spirit, action, energy, confidence'**
  String get card_upright_wands_12;

  /// No description provided for @card_reversed_wands_12.
  ///
  /// In en, this message translates to:
  /// **'Impulsive action, arrogance, capriciousness, anger, lack of planning'**
  String get card_reversed_wands_12;

  /// No description provided for @card_name_wands_13.
  ///
  /// In en, this message translates to:
  /// **'Queen of Wands'**
  String get card_name_wands_13;

  /// No description provided for @card_upright_wands_13.
  ///
  /// In en, this message translates to:
  /// **'Charisma, courage, independence, brightness, charm, vibrancy'**
  String get card_upright_wands_13;

  /// No description provided for @card_reversed_wands_13.
  ///
  /// In en, this message translates to:
  /// **'Selfishness, ostentation, jealousy, capriciousness, aggression'**
  String get card_reversed_wands_13;

  /// No description provided for @card_name_wands_14.
  ///
  /// In en, this message translates to:
  /// **'King of Wands'**
  String get card_name_wands_14;

  /// No description provided for @card_upright_wands_14.
  ///
  /// In en, this message translates to:
  /// **'Charismatic leadership, vision, inspiration, boldness, entrepreneur'**
  String get card_upright_wands_14;

  /// No description provided for @card_reversed_wands_14.
  ///
  /// In en, this message translates to:
  /// **'Dictatorship, impulsive anger, unreality, arrogance, ruthlessness'**
  String get card_reversed_wands_14;

  /// No description provided for @witchNameMorgan.
  ///
  /// In en, this message translates to:
  /// **'Morgan'**
  String get witchNameMorgan;

  /// No description provided for @witchTitleMorgan.
  ///
  /// In en, this message translates to:
  /// **'Original Tarot Witch'**
  String get witchTitleMorgan;

  /// No description provided for @witchBgMorgan.
  ///
  /// In en, this message translates to:
  /// **'The legitimate successor of dark magic following the legendary Morgan le Fay family. Direct and sometimes cynical, but with sharp insight, she provides clear answers to your frustrating situations.'**
  String get witchBgMorgan;

  /// No description provided for @witchPromptMorgan.
  ///
  /// In en, this message translates to:
  /// **'Your name is \"Morgan\", and please adopt the persona of a mysterious, direct, yet insightful tarot witch who penetrates to the essence. Rather than being kind, give advice that is slightly chic yet trustworthy.'**
  String get witchPromptMorgan;

  /// No description provided for @witchNameLuna.
  ///
  /// In en, this message translates to:
  /// **'Luna'**
  String get witchNameLuna;

  /// No description provided for @witchTitleLuna.
  ///
  /// In en, this message translates to:
  /// **'Comfort of Moonlight'**
  String get witchTitleLuna;

  /// No description provided for @witchBgLuna.
  ///
  /// In en, this message translates to:
  /// **'Awakened as a witch after receiving a blessing from the moon spirit in a mysterious forest. With a warm and delicate empathy that touches hurt and exhausted souls, she delivers gentle and cozy comfort like moonlight in the night sky.'**
  String get witchBgLuna;

  /// No description provided for @witchPromptLuna.
  ///
  /// In en, this message translates to:
  /// **'Your name is \"Luna\", and please adopt the persona of a tarot witch who gently and affectionately comforts wounds like moonlight. Be highly empathetic and use a warm tone like a close sister or friend.'**
  String get witchPromptLuna;

  /// No description provided for @witchNameSerena.
  ///
  /// In en, this message translates to:
  /// **'Serena'**
  String get witchNameSerena;

  /// No description provided for @witchTitleSerena.
  ///
  /// In en, this message translates to:
  /// **'Ancient Wisdom'**
  String get witchTitleSerena;

  /// No description provided for @witchBgSerena.
  ///
  /// In en, this message translates to:
  /// **'The great witch of the forest who maintains a young and alluring appearance in her 20s despite transcending 100 years of time. Having witnessed the rise and fall of countless human affairs, she offers profound advice on the flow of fate with deep philosophical thought and an elegant attitude.'**
  String get witchBgSerena;

  /// No description provided for @witchPromptSerena.
  ///
  /// In en, this message translates to:
  /// **'Your name is \"Serena\", and please adopt the persona of an ancient witch who has lived for over 100 years, being very philosophical, profound, and elegant. Use an elegant tone that is slightly old-fashioned and full of wisdom.'**
  String get witchPromptSerena;

  /// No description provided for @witchNameAria.
  ///
  /// In en, this message translates to:
  /// **'Aria'**
  String get witchNameAria;

  /// No description provided for @witchTitleAria.
  ///
  /// In en, this message translates to:
  /// **'Sunshine Energy'**
  String get witchTitleAria;

  /// No description provided for @witchBgAria.
  ///
  /// In en, this message translates to:
  /// **'A genius rookie tarot witch who just graduated at the top of her class from magic school. Although she may lack a bit of practical experience, she is full of unique, bubbly, and bright positive energy, cheerfully suggesting bright and practical action guidelines to the client.'**
  String get witchBgAria;

  /// No description provided for @witchPromptAria.
  ///
  /// In en, this message translates to:
  /// **'Your name is \"Aria\", and please adopt the persona of a very positive, bubbly, and energetic teenage witch who just turned 19. Use a lot of emojis and a friendly, lively tone.'**
  String get witchPromptAria;

  /// No description provided for @witchNameEvelyn.
  ///
  /// In en, this message translates to:
  /// **'Evelyn'**
  String get witchNameEvelyn;

  /// No description provided for @witchTitleEvelyn.
  ///
  /// In en, this message translates to:
  /// **'Alchemist of Ambition'**
  String get witchTitleEvelyn;

  /// No description provided for @witchBgEvelyn.
  ///
  /// In en, this message translates to:
  /// **'Once a cold businesswoman who dominated the big city, she fully awakened her spiritual abilities and created a new magic combining alchemy and tarot. When it comes to money, job changes, and success, she provides a definite solution with sharp and realistic fact-bombing rather than emotional comfort.'**
  String get witchBgEvelyn;

  /// No description provided for @witchPromptEvelyn.
  ///
  /// In en, this message translates to:
  /// **'Your name is \"Evelyn\", and please adopt the persona of a charismatic and realistic witch who is well-versed in success and business. Rather than unnecessary comfort, use a career woman-like tone that offers bone-chilling advice (fact-bombing) and rational solutions.'**
  String get witchPromptEvelyn;

  /// No description provided for @witchNameKaren.
  ///
  /// In en, this message translates to:
  /// **'Karen'**
  String get witchNameKaren;

  /// No description provided for @witchTitleKaren.
  ///
  /// In en, this message translates to:
  /// **'Witch of Twilight'**
  String get witchTitleKaren;

  /// No description provided for @witchBgKaren.
  ///
  /// In en, this message translates to:
  /// **'The older version of \'Morgan\', who was called the \'Original Tarot Witch\' in the past and was skilled in dark magic and authentic tarot. Over decades of wandering the world and watching countless fates, her past sharp attitude has softened, and she now wisely unravels intertwined relationships and the threads of fate with deep and benevolent insight.'**
  String get witchBgKaren;

  /// No description provided for @witchPromptKaren.
  ///
  /// In en, this message translates to:
  /// **'Your name is \"Karen\", and having been \'Morgan\' in your youth, please adopt the persona of an old witch who has gained deep wisdom and benevolence over a long time. Your previously direct personality has rounded out, and use a warm grandmotherly tone full of experience as if treating a grandchild.'**
  String get witchPromptKaren;

  /// No description provided for @witchBloodTypeA.
  ///
  /// In en, this message translates to:
  /// **'Type A'**
  String get witchBloodTypeA;

  /// No description provided for @witchBloodTypeB.
  ///
  /// In en, this message translates to:
  /// **'Type B'**
  String get witchBloodTypeB;

  /// No description provided for @witchBloodTypeO.
  ///
  /// In en, this message translates to:
  /// **'Type O'**
  String get witchBloodTypeO;

  /// No description provided for @witchBloodTypeAB.
  ///
  /// In en, this message translates to:
  /// **'Type AB'**
  String get witchBloodTypeAB;

  /// No description provided for @witchHeightCm.
  ///
  /// In en, this message translates to:
  /// **'{height}cm'**
  String witchHeightCm(String height);

  /// No description provided for @witchWeightKg.
  ///
  /// In en, this message translates to:
  /// **'{weight}kg'**
  String witchWeightKg(String weight);

  /// No description provided for @chatWitchGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello. I am the Tarot Witch {witchName}. The energy of the universe has guided you here. What is your concern?'**
  String chatWitchGreeting(String witchName);

  /// No description provided for @chatWitchChanged.
  ///
  /// In en, this message translates to:
  /// **'[Witch changed to {witchName}.]\nHello. I am your new spiritual guide, {witchName}. What is your concern?'**
  String chatWitchChanged(String witchName);

  /// No description provided for @chatAskPickCards.
  ///
  /// In en, this message translates to:
  /// **'I have delivered your concerns to the universe. Please put your heart into it and draw 3 tarot cards.'**
  String get chatAskPickCards;

  /// No description provided for @chatReadingCards.
  ///
  /// In en, this message translates to:
  /// **'You have drawn all the cards. I will weave the energy of the cards you drew to read your fortune...'**
  String get chatReadingCards;

  /// No description provided for @chatProfileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get chatProfileAge;

  /// No description provided for @chatProfileBloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get chatProfileBloodType;

  /// No description provided for @chatProfileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get chatProfileHeight;

  /// No description provided for @chatProfileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get chatProfileWeight;

  /// No description provided for @chatProfileBackground.
  ///
  /// In en, this message translates to:
  /// **'Background Story'**
  String get chatProfileBackground;

  /// No description provided for @chatProfileClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get chatProfileClose;

  /// No description provided for @chatPickCardsButton.
  ///
  /// In en, this message translates to:
  /// **'Draw Tarot Cards ✨'**
  String get chatPickCardsButton;

  /// No description provided for @chatHintPickCardsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please draw cards first.'**
  String get chatHintPickCardsFirst;

  /// No description provided for @chatHintWriteConcern.
  ///
  /// In en, this message translates to:
  /// **'Write your concern...'**
  String get chatHintWriteConcern;

  /// No description provided for @chatProfileTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the profile picture to view details'**
  String get chatProfileTapHint;

  /// No description provided for @themeName1.
  ///
  /// In en, this message translates to:
  /// **'Skin 1'**
  String get themeName1;

  /// No description provided for @themeName2.
  ///
  /// In en, this message translates to:
  /// **'Skin 2'**
  String get themeName2;

  /// No description provided for @themeName3.
  ///
  /// In en, this message translates to:
  /// **'Skin 3'**
  String get themeName3;

  /// No description provided for @themeMagicBook.
  ///
  /// In en, this message translates to:
  /// **'Magic Book'**
  String get themeMagicBook;

  /// No description provided for @themeBlackCat.
  ///
  /// In en, this message translates to:
  /// **'Black Cat'**
  String get themeBlackCat;

  /// No description provided for @themeEmptyPaidThemes.
  ///
  /// In en, this message translates to:
  /// **'Purchase skins in the shop\nto fill this space!'**
  String get themeEmptyPaidThemes;

  /// No description provided for @shopThemePurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Skin'**
  String get shopThemePurchaseTitle;

  /// No description provided for @shopThemePurchaseContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to purchase the {skinName} skin for {cost} coins?'**
  String shopThemePurchaseContent(String skinName, int cost);

  /// No description provided for @shopCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get shopCancel;

  /// No description provided for @shopPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get shopPurchase;

  /// No description provided for @shopAlreadyOwned.
  ///
  /// In en, this message translates to:
  /// **'Already owned. Try applying it in skin settings!'**
  String get shopAlreadyOwned;

  /// No description provided for @shopPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'{skinName} purchased successfully! Check skin settings.'**
  String shopPurchaseSuccess(String skinName);

  /// No description provided for @shopNotEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins.'**
  String get shopNotEnoughCoins;

  /// No description provided for @shopOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get shopOwned;

  /// No description provided for @shopCoinPrice.
  ///
  /// In en, this message translates to:
  /// **'{cost} coins'**
  String shopCoinPrice(int cost);

  /// No description provided for @navDiary.
  ///
  /// In en, this message translates to:
  /// **'Tarot Diary'**
  String get navDiary;

  /// No description provided for @myMenuFirebaseNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Firebase Not Connected'**
  String get myMenuFirebaseNotConnected;

  /// No description provided for @myMenuWindowsSetupNeeded.
  ///
  /// In en, this message translates to:
  /// **'Windows Setup Needed (Preview)'**
  String get myMenuWindowsSetupNeeded;

  /// No description provided for @myMenuTouchToViewLogin.
  ///
  /// In en, this message translates to:
  /// **'Tap to view Login UI'**
  String get myMenuTouchToViewLogin;

  /// No description provided for @myMenuNoName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get myMenuNoName;

  /// No description provided for @myMenuPleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please Log In'**
  String get myMenuPleaseLogin;

  /// No description provided for @myMenuTouchToSignupLogin.
  ///
  /// In en, this message translates to:
  /// **'Tap to Sign Up & Log In'**
  String get myMenuTouchToSignupLogin;

  /// No description provided for @myMenuSectionMyRecords.
  ///
  /// In en, this message translates to:
  /// **'My Records'**
  String get myMenuSectionMyRecords;

  /// No description provided for @myMenuDiaryStorage.
  ///
  /// In en, this message translates to:
  /// **'Diary Storage'**
  String get myMenuDiaryStorage;

  /// No description provided for @myMenuCheckSavedDiary.
  ///
  /// In en, this message translates to:
  /// **'Check your saved diaries.'**
  String get myMenuCheckSavedDiary;

  /// No description provided for @myMenuFavoriteCards.
  ///
  /// In en, this message translates to:
  /// **'Favorite Cards'**
  String get myMenuFavoriteCards;

  /// No description provided for @myMenuMyFavoriteCardsList.
  ///
  /// In en, this message translates to:
  /// **'List of my favorite cards'**
  String get myMenuMyFavoriteCardsList;

  /// No description provided for @myMenuSectionAppSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get myMenuSectionAppSettings;

  /// No description provided for @myMenuPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get myMenuPushNotifications;

  /// No description provided for @myMenuPushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'New horoscopes and events'**
  String get myMenuPushNotificationsDesc;

  /// No description provided for @myMenuLanguageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get myMenuLanguageSettings;

  /// No description provided for @myMenuThemeSettings.
  ///
  /// In en, this message translates to:
  /// **'Skin Settings'**
  String get myMenuThemeSettings;

  /// No description provided for @myMenuChangeBackground.
  ///
  /// In en, this message translates to:
  /// **'Change background image'**
  String get myMenuChangeBackground;

  /// No description provided for @myMenuSectionCustomerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get myMenuSectionCustomerSupport;

  /// No description provided for @myMenuFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get myMenuFaq;

  /// No description provided for @myMenuAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get myMenuAppInfo;

  /// No description provided for @myMenuSectionAccountManagement.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get myMenuSectionAccountManagement;

  /// No description provided for @myMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get myMenuLogout;

  /// No description provided for @myMenuLogoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Log out from the current device.'**
  String get myMenuLogoutDesc;

  /// No description provided for @myMenuEmailVerifiedMsg.
  ///
  /// In en, this message translates to:
  /// **'Email verification confirmed! ✨'**
  String get myMenuEmailVerifiedMsg;

  /// No description provided for @myMenuEmailSendTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Email'**
  String get myMenuEmailSendTitle;

  /// No description provided for @myMenuEmailSendContent.
  ///
  /// In en, this message translates to:
  /// **'Verification email has been sent.\nPlease check your inbox, click the link, and press this button again!'**
  String get myMenuEmailSendContent;

  /// No description provided for @myMenuConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get myMenuConfirm;

  /// No description provided for @myMenuEmailErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Too many requests or an error occurred.'**
  String get myMenuEmailErrorMsg;

  /// No description provided for @myMenuEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get myMenuEmailVerified;

  /// No description provided for @myMenuEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Not Verified (Tap to verify)'**
  String get myMenuEmailNotVerified;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystemDefault;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @shopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Coins and Skins'**
  String get shopSubtitle;

  /// No description provided for @shopTabCoin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get shopTabCoin;

  /// No description provided for @shopTabTheme.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get shopTabTheme;

  /// No description provided for @shopPayButton.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get shopPayButton;

  /// No description provided for @themeOriginalDeck.
  ///
  /// In en, this message translates to:
  /// **'Original Classic Deck'**
  String get themeOriginalDeck;

  /// No description provided for @themeGoldenSunDeck.
  ///
  /// In en, this message translates to:
  /// **'Golden Sun Deck'**
  String get themeGoldenSunDeck;

  /// No description provided for @themeDarkAbyssDeck.
  ///
  /// In en, this message translates to:
  /// **'Dark Abyss Deck'**
  String get themeDarkAbyssDeck;

  /// No description provided for @themeSpringSpiritDeck.
  ///
  /// In en, this message translates to:
  /// **'Spring Spirit Deck'**
  String get themeSpringSpiritDeck;

  /// No description provided for @shopCoinNotReady.
  ///
  /// In en, this message translates to:
  /// **'Payment for {coins} coins is coming soon.'**
  String shopCoinNotReady(int coins);

  /// No description provided for @shopThemeNotReady.
  ///
  /// In en, this message translates to:
  /// **'Purchase/apply for {name} is coming soon.'**
  String shopThemeNotReady(String name);

  /// No description provided for @readingIntroSelectWitch.
  ///
  /// In en, this message translates to:
  /// **'Select a witch to see your destiny'**
  String get readingIntroSelectWitch;

  /// No description provided for @readingIntroGreeting.
  ///
  /// In en, this message translates to:
  /// **'What destiny shall we look into?\nI am curious about your future.'**
  String get readingIntroGreeting;

  /// No description provided for @readingIntroStart.
  ///
  /// In en, this message translates to:
  /// **'Select Spread'**
  String get readingIntroStart;

  /// No description provided for @tabMajorArcana.
  ///
  /// In en, this message translates to:
  /// **'Major Arcana'**
  String get tabMajorArcana;

  /// No description provided for @tabMinorArcana.
  ///
  /// In en, this message translates to:
  /// **'Minor Arcana'**
  String get tabMinorArcana;

  /// No description provided for @nicknamePrefix0.
  ///
  /// In en, this message translates to:
  /// **'occult'**
  String get nicknamePrefix0;

  /// No description provided for @nicknamePrefix1.
  ///
  /// In en, this message translates to:
  /// **'serene'**
  String get nicknamePrefix1;

  /// No description provided for @nicknamePrefix2.
  ///
  /// In en, this message translates to:
  /// **'holy'**
  String get nicknamePrefix2;

  /// No description provided for @nicknamePrefix3.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get nicknamePrefix3;

  /// No description provided for @nicknamePrefix4.
  ///
  /// In en, this message translates to:
  /// **'shining'**
  String get nicknamePrefix4;

  /// No description provided for @nicknamePrefix5.
  ///
  /// In en, this message translates to:
  /// **'bleak'**
  String get nicknamePrefix5;

  /// No description provided for @nicknamePrefix6.
  ///
  /// In en, this message translates to:
  /// **'hot'**
  String get nicknamePrefix6;

  /// No description provided for @nicknamePrefix7.
  ///
  /// In en, this message translates to:
  /// **'fascinating'**
  String get nicknamePrefix7;

  /// No description provided for @nicknamePrefix8.
  ///
  /// In en, this message translates to:
  /// **'cruel'**
  String get nicknamePrefix8;

  /// No description provided for @nicknamePrefix9.
  ///
  /// In en, this message translates to:
  /// **'pure'**
  String get nicknamePrefix9;

  /// No description provided for @nicknamePrefix10.
  ///
  /// In en, this message translates to:
  /// **'harsh'**
  String get nicknamePrefix10;

  /// No description provided for @nicknamePrefix11.
  ///
  /// In en, this message translates to:
  /// **'soft'**
  String get nicknamePrefix11;

  /// No description provided for @nicknamePrefix12.
  ///
  /// In en, this message translates to:
  /// **'beautiful'**
  String get nicknamePrefix12;

  /// No description provided for @nicknamePrefix13.
  ///
  /// In en, this message translates to:
  /// **'weird'**
  String get nicknamePrefix13;

  /// No description provided for @nicknamePrefix14.
  ///
  /// In en, this message translates to:
  /// **'big'**
  String get nicknamePrefix14;

  /// No description provided for @nicknamePrefix15.
  ///
  /// In en, this message translates to:
  /// **'shabby'**
  String get nicknamePrefix15;

  /// No description provided for @nicknamePrefix16.
  ///
  /// In en, this message translates to:
  /// **'eternal'**
  String get nicknamePrefix16;

  /// No description provided for @nicknamePrefix17.
  ///
  /// In en, this message translates to:
  /// **'forgotten'**
  String get nicknamePrefix17;

  /// No description provided for @nicknamePrefix18.
  ///
  /// In en, this message translates to:
  /// **'brilliant'**
  String get nicknamePrefix18;

  /// No description provided for @nicknamePrefix19.
  ///
  /// In en, this message translates to:
  /// **'sad'**
  String get nicknamePrefix19;

  /// No description provided for @nicknamePrefix20.
  ///
  /// In en, this message translates to:
  /// **'glad'**
  String get nicknamePrefix20;

  /// No description provided for @nicknamePrefix21.
  ///
  /// In en, this message translates to:
  /// **'dreamy'**
  String get nicknamePrefix21;

  /// No description provided for @nicknamePrefix22.
  ///
  /// In en, this message translates to:
  /// **'fallen'**
  String get nicknamePrefix22;

  /// No description provided for @nicknamePrefix23.
  ///
  /// In en, this message translates to:
  /// **'pure white'**
  String get nicknamePrefix23;

  /// No description provided for @nicknamePrefix24.
  ///
  /// In en, this message translates to:
  /// **'jet black'**
  String get nicknamePrefix24;

  /// No description provided for @nicknamePrefix25.
  ///
  /// In en, this message translates to:
  /// **'bloody'**
  String get nicknamePrefix25;

  /// No description provided for @nicknamePrefix26.
  ///
  /// In en, this message translates to:
  /// **'grayish'**
  String get nicknamePrefix26;

  /// No description provided for @nicknamePrefix27.
  ///
  /// In en, this message translates to:
  /// **'golden'**
  String get nicknamePrefix27;

  /// No description provided for @nicknamePrefix28.
  ///
  /// In en, this message translates to:
  /// **'argent'**
  String get nicknamePrefix28;

  /// No description provided for @nicknamePrefix29.
  ///
  /// In en, this message translates to:
  /// **'blue'**
  String get nicknamePrefix29;

  /// No description provided for @nicknamePrefix30.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get nicknamePrefix30;

  /// No description provided for @nicknamePrefix31.
  ///
  /// In en, this message translates to:
  /// **'yellow'**
  String get nicknamePrefix31;

  /// No description provided for @nicknamePrefix32.
  ///
  /// In en, this message translates to:
  /// **'black'**
  String get nicknamePrefix32;

  /// No description provided for @nicknamePrefix33.
  ///
  /// In en, this message translates to:
  /// **'white'**
  String get nicknamePrefix33;

  /// No description provided for @nicknamePrefix34.
  ///
  /// In en, this message translates to:
  /// **'transparent'**
  String get nicknamePrefix34;

  /// No description provided for @nicknamePrefix35.
  ///
  /// In en, this message translates to:
  /// **'lone'**
  String get nicknamePrefix35;

  /// No description provided for @nicknamePrefix36.
  ///
  /// In en, this message translates to:
  /// **'noisy'**
  String get nicknamePrefix36;

  /// No description provided for @nicknamePrefix37.
  ///
  /// In en, this message translates to:
  /// **'quiet'**
  String get nicknamePrefix37;

  /// No description provided for @nicknamePrefix38.
  ///
  /// In en, this message translates to:
  /// **'warm'**
  String get nicknamePrefix38;

  /// No description provided for @nicknamePrefix39.
  ///
  /// In en, this message translates to:
  /// **'frosty'**
  String get nicknamePrefix39;

  /// No description provided for @nicknamePrefix40.
  ///
  /// In en, this message translates to:
  /// **'solitary'**
  String get nicknamePrefix40;

  /// No description provided for @nicknamePrefix41.
  ///
  /// In en, this message translates to:
  /// **'lonesome'**
  String get nicknamePrefix41;

  /// No description provided for @nicknamePrefix42.
  ///
  /// In en, this message translates to:
  /// **'happy'**
  String get nicknamePrefix42;

  /// No description provided for @nicknamePrefix43.
  ///
  /// In en, this message translates to:
  /// **'happy'**
  String get nicknamePrefix43;

  /// No description provided for @nicknamePrefix44.
  ///
  /// In en, this message translates to:
  /// **'gloomy'**
  String get nicknamePrefix44;

  /// No description provided for @nicknamePrefix45.
  ///
  /// In en, this message translates to:
  /// **'desperate'**
  String get nicknamePrefix45;

  /// No description provided for @nicknamePrefix46.
  ///
  /// In en, this message translates to:
  /// **'hopeful'**
  String get nicknamePrefix46;

  /// No description provided for @nicknamePrefix47.
  ///
  /// In en, this message translates to:
  /// **'dazzling'**
  String get nicknamePrefix47;

  /// No description provided for @nicknamePrefix48.
  ///
  /// In en, this message translates to:
  /// **'dusky'**
  String get nicknamePrefix48;

  /// No description provided for @nicknamePrefix49.
  ///
  /// In en, this message translates to:
  /// **'midnight'**
  String get nicknamePrefix49;

  /// No description provided for @nicknamePrefix50.
  ///
  /// In en, this message translates to:
  /// **'desolate'**
  String get nicknamePrefix50;

  /// No description provided for @nicknamePrefix51.
  ///
  /// In en, this message translates to:
  /// **'secret'**
  String get nicknamePrefix51;

  /// No description provided for @nicknamePrefix52.
  ///
  /// In en, this message translates to:
  /// **'secret'**
  String get nicknamePrefix52;

  /// No description provided for @nicknamePrefix53.
  ///
  /// In en, this message translates to:
  /// **'sacred'**
  String get nicknamePrefix53;

  /// No description provided for @nicknamePrefix54.
  ///
  /// In en, this message translates to:
  /// **'profane'**
  String get nicknamePrefix54;

  /// No description provided for @nicknamePrefix55.
  ///
  /// In en, this message translates to:
  /// **'superior'**
  String get nicknamePrefix55;

  /// No description provided for @nicknamePrefix56.
  ///
  /// In en, this message translates to:
  /// **'modest'**
  String get nicknamePrefix56;

  /// No description provided for @nicknamePrefix57.
  ///
  /// In en, this message translates to:
  /// **'wise'**
  String get nicknamePrefix57;

  /// No description provided for @nicknamePrefix58.
  ///
  /// In en, this message translates to:
  /// **'foolish'**
  String get nicknamePrefix58;

  /// No description provided for @nicknamePrefix59.
  ///
  /// In en, this message translates to:
  /// **'tough'**
  String get nicknamePrefix59;

  /// No description provided for @nicknamePrefix60.
  ///
  /// In en, this message translates to:
  /// **'weak'**
  String get nicknamePrefix60;

  /// No description provided for @nicknamePrefix61.
  ///
  /// In en, this message translates to:
  /// **'brave'**
  String get nicknamePrefix61;

  /// No description provided for @nicknamePrefix62.
  ///
  /// In en, this message translates to:
  /// **'dastardly'**
  String get nicknamePrefix62;

  /// No description provided for @nicknamePrefix63.
  ///
  /// In en, this message translates to:
  /// **'Distant'**
  String get nicknamePrefix63;

  /// No description provided for @nicknamePrefix64.
  ///
  /// In en, this message translates to:
  /// **'near'**
  String get nicknamePrefix64;

  /// No description provided for @nicknamePrefix65.
  ///
  /// In en, this message translates to:
  /// **'moving away'**
  String get nicknamePrefix65;

  /// No description provided for @nicknamePrefix66.
  ///
  /// In en, this message translates to:
  /// **'oncoming'**
  String get nicknamePrefix66;

  /// No description provided for @nicknamePrefix67.
  ///
  /// In en, this message translates to:
  /// **'disappearing'**
  String get nicknamePrefix67;

  /// No description provided for @nicknamePrefix68.
  ///
  /// In en, this message translates to:
  /// **'emergent'**
  String get nicknamePrefix68;

  /// No description provided for @nicknamePrefix69.
  ///
  /// In en, this message translates to:
  /// **'awakened'**
  String get nicknamePrefix69;

  /// No description provided for @nicknamePrefix70.
  ///
  /// In en, this message translates to:
  /// **'asleep'**
  String get nicknamePrefix70;

  /// No description provided for @nicknamePrefix71.
  ///
  /// In en, this message translates to:
  /// **'dreaming'**
  String get nicknamePrefix71;

  /// No description provided for @nicknamePrefix72.
  ///
  /// In en, this message translates to:
  /// **'wandering'**
  String get nicknamePrefix72;

  /// No description provided for @nicknamePrefix73.
  ///
  /// In en, this message translates to:
  /// **'wandering'**
  String get nicknamePrefix73;

  /// No description provided for @nicknamePrefix74.
  ///
  /// In en, this message translates to:
  /// **'staying'**
  String get nicknamePrefix74;

  /// No description provided for @nicknamePrefix75.
  ///
  /// In en, this message translates to:
  /// **'leaving'**
  String get nicknamePrefix75;

  /// No description provided for @nicknamePrefix76.
  ///
  /// In en, this message translates to:
  /// **'coming back'**
  String get nicknamePrefix76;

  /// No description provided for @nicknamePrefix77.
  ///
  /// In en, this message translates to:
  /// **'waiting'**
  String get nicknamePrefix77;

  /// No description provided for @nicknamePrefix78.
  ///
  /// In en, this message translates to:
  /// **'looking for'**
  String get nicknamePrefix78;

  /// No description provided for @nicknamePrefix79.
  ///
  /// In en, this message translates to:
  /// **'cryptic'**
  String get nicknamePrefix79;

  /// No description provided for @nicknamePrefix80.
  ///
  /// In en, this message translates to:
  /// **'exposed'**
  String get nicknamePrefix80;

  /// No description provided for @nicknamePrefix81.
  ///
  /// In en, this message translates to:
  /// **'abandoned'**
  String get nicknamePrefix81;

  /// No description provided for @nicknamePrefix82.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get nicknamePrefix82;

  /// No description provided for @nicknamePrefix83.
  ///
  /// In en, this message translates to:
  /// **'blessed'**
  String get nicknamePrefix83;

  /// No description provided for @nicknamePrefix84.
  ///
  /// In en, this message translates to:
  /// **'cursed'**
  String get nicknamePrefix84;

  /// No description provided for @nicknamePrefix85.
  ///
  /// In en, this message translates to:
  /// **'loved'**
  String get nicknamePrefix85;

  /// No description provided for @nicknamePrefix86.
  ///
  /// In en, this message translates to:
  /// **'hated'**
  String get nicknamePrefix86;

  /// No description provided for @nicknamePrefix87.
  ///
  /// In en, this message translates to:
  /// **'remember'**
  String get nicknamePrefix87;

  /// No description provided for @nicknamePrefix88.
  ///
  /// In en, this message translates to:
  /// **'oblivious'**
  String get nicknamePrefix88;

  /// No description provided for @nicknamePrefix89.
  ///
  /// In en, this message translates to:
  /// **'starlight'**
  String get nicknamePrefix89;

  /// No description provided for @nicknamePrefix90.
  ///
  /// In en, this message translates to:
  /// **'moonlight'**
  String get nicknamePrefix90;

  /// No description provided for @nicknamePrefix91.
  ///
  /// In en, this message translates to:
  /// **'of sunlight'**
  String get nicknamePrefix91;

  /// No description provided for @nicknamePrefix92.
  ///
  /// In en, this message translates to:
  /// **'cosmic'**
  String get nicknamePrefix92;

  /// No description provided for @nicknamePrefix93.
  ///
  /// In en, this message translates to:
  /// **'of the earth'**
  String get nicknamePrefix93;

  /// No description provided for @nicknamePrefix94.
  ///
  /// In en, this message translates to:
  /// **'of the sea'**
  String get nicknamePrefix94;

  /// No description provided for @nicknamePrefix95.
  ///
  /// In en, this message translates to:
  /// **'heavenly'**
  String get nicknamePrefix95;

  /// No description provided for @nicknamePrefix96.
  ///
  /// In en, this message translates to:
  /// **'of the clouds'**
  String get nicknamePrefix96;

  /// No description provided for @nicknamePrefix97.
  ///
  /// In en, this message translates to:
  /// **'of the wind'**
  String get nicknamePrefix97;

  /// No description provided for @nicknamePrefix98.
  ///
  /// In en, this message translates to:
  /// **'rain'**
  String get nicknamePrefix98;

  /// No description provided for @nicknamePrefix99.
  ///
  /// In en, this message translates to:
  /// **'of the eye'**
  String get nicknamePrefix99;

  /// No description provided for @nicknamePrefix100.
  ///
  /// In en, this message translates to:
  /// **'icy'**
  String get nicknamePrefix100;

  /// No description provided for @nicknamePrefix101.
  ///
  /// In en, this message translates to:
  /// **'fiery'**
  String get nicknamePrefix101;

  /// No description provided for @nicknamePrefix102.
  ///
  /// In en, this message translates to:
  /// **'water'**
  String get nicknamePrefix102;

  /// No description provided for @nicknamePrefix103.
  ///
  /// In en, this message translates to:
  /// **'earthen'**
  String get nicknamePrefix103;

  /// No description provided for @nicknamePrefix104.
  ///
  /// In en, this message translates to:
  /// **'wooden'**
  String get nicknamePrefix104;

  /// No description provided for @nicknamePrefix105.
  ///
  /// In en, this message translates to:
  /// **'forest'**
  String get nicknamePrefix105;

  /// No description provided for @nicknamePrefix106.
  ///
  /// In en, this message translates to:
  /// **'mountainous'**
  String get nicknamePrefix106;

  /// No description provided for @nicknamePrefix107.
  ///
  /// In en, this message translates to:
  /// **'lecture'**
  String get nicknamePrefix107;

  /// No description provided for @nicknamePrefix108.
  ///
  /// In en, this message translates to:
  /// **'of the lake'**
  String get nicknamePrefix108;

  /// No description provided for @nicknamePrefix109.
  ///
  /// In en, this message translates to:
  /// **'of time'**
  String get nicknamePrefix109;

  /// No description provided for @nicknamePrefix110.
  ///
  /// In en, this message translates to:
  /// **'of space'**
  String get nicknamePrefix110;

  /// No description provided for @nicknamePrefix111.
  ///
  /// In en, this message translates to:
  /// **'dimension'**
  String get nicknamePrefix111;

  /// No description provided for @nicknamePrefix112.
  ///
  /// In en, this message translates to:
  /// **'fateful'**
  String get nicknamePrefix112;

  /// No description provided for @nicknamePrefix113.
  ///
  /// In en, this message translates to:
  /// **'fateful'**
  String get nicknamePrefix113;

  /// No description provided for @nicknamePrefix114.
  ///
  /// In en, this message translates to:
  /// **'miraculous'**
  String get nicknamePrefix114;

  /// No description provided for @nicknamePrefix115.
  ///
  /// In en, this message translates to:
  /// **'magical'**
  String get nicknamePrefix115;

  /// No description provided for @nicknamePrefix116.
  ///
  /// In en, this message translates to:
  /// **'mythical'**
  String get nicknamePrefix116;

  /// No description provided for @nicknamePrefix117.
  ///
  /// In en, this message translates to:
  /// **'legendary'**
  String get nicknamePrefix117;

  /// No description provided for @nicknamePrefix118.
  ///
  /// In en, this message translates to:
  /// **'of truth'**
  String get nicknamePrefix118;

  /// No description provided for @nicknamePrefix119.
  ///
  /// In en, this message translates to:
  /// **'false'**
  String get nicknamePrefix119;

  /// No description provided for @nicknamePrefix120.
  ///
  /// In en, this message translates to:
  /// **'fantasy'**
  String get nicknamePrefix120;

  /// No description provided for @nicknamePrefix121.
  ///
  /// In en, this message translates to:
  /// **'dream'**
  String get nicknamePrefix121;

  /// No description provided for @nicknamePrefix122.
  ///
  /// In en, this message translates to:
  /// **'nightmare'**
  String get nicknamePrefix122;

  /// No description provided for @nicknamePrefix123.
  ///
  /// In en, this message translates to:
  /// **'ruin'**
  String get nicknamePrefix123;

  /// No description provided for @nicknamePrefix124.
  ///
  /// In en, this message translates to:
  /// **'of creation'**
  String get nicknamePrefix124;

  /// No description provided for @nicknamePrefix125.
  ///
  /// In en, this message translates to:
  /// **'of life'**
  String get nicknamePrefix125;

  /// No description provided for @nicknamePrefix126.
  ///
  /// In en, this message translates to:
  /// **'of death'**
  String get nicknamePrefix126;

  /// No description provided for @nicknamePrefix127.
  ///
  /// In en, this message translates to:
  /// **'soul'**
  String get nicknamePrefix127;

  /// No description provided for @nicknamePrefix128.
  ///
  /// In en, this message translates to:
  /// **'physical'**
  String get nicknamePrefix128;

  /// No description provided for @nicknamePrefix129.
  ///
  /// In en, this message translates to:
  /// **'of reason'**
  String get nicknamePrefix129;

  /// No description provided for @nicknamePrefix130.
  ///
  /// In en, this message translates to:
  /// **'emotional'**
  String get nicknamePrefix130;

  /// No description provided for @nicknamePrefix131.
  ///
  /// In en, this message translates to:
  /// **'of love'**
  String get nicknamePrefix131;

  /// No description provided for @nicknamePrefix132.
  ///
  /// In en, this message translates to:
  /// **'of hate'**
  String get nicknamePrefix132;

  /// No description provided for @nicknamePrefix133.
  ///
  /// In en, this message translates to:
  /// **'of sadness'**
  String get nicknamePrefix133;

  /// No description provided for @nicknamePrefix134.
  ///
  /// In en, this message translates to:
  /// **'of joy'**
  String get nicknamePrefix134;

  /// No description provided for @nicknamePrefix135.
  ///
  /// In en, this message translates to:
  /// **'angry'**
  String get nicknamePrefix135;

  /// No description provided for @nicknamePrefix136.
  ///
  /// In en, this message translates to:
  /// **'of peace'**
  String get nicknamePrefix136;

  /// No description provided for @nicknamePrefix137.
  ///
  /// In en, this message translates to:
  /// **'of war'**
  String get nicknamePrefix137;

  /// No description provided for @nicknamePrefix138.
  ///
  /// In en, this message translates to:
  /// **'chaos'**
  String get nicknamePrefix138;

  /// No description provided for @nicknamePrefix139.
  ///
  /// In en, this message translates to:
  /// **'orderly'**
  String get nicknamePrefix139;

  /// No description provided for @nicknamePrefix140.
  ///
  /// In en, this message translates to:
  /// **'of light'**
  String get nicknamePrefix140;

  /// No description provided for @nicknamePrefix141.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get nicknamePrefix141;

  /// No description provided for @nicknamePrefix142.
  ///
  /// In en, this message translates to:
  /// **'twilight'**
  String get nicknamePrefix142;

  /// No description provided for @nicknamePrefix143.
  ///
  /// In en, this message translates to:
  /// **'dawn'**
  String get nicknamePrefix143;

  /// No description provided for @nicknamePrefix144.
  ///
  /// In en, this message translates to:
  /// **'noon'**
  String get nicknamePrefix144;

  /// No description provided for @nicknamePrefix145.
  ///
  /// In en, this message translates to:
  /// **'midnight'**
  String get nicknamePrefix145;

  /// No description provided for @nicknamePrefix146.
  ///
  /// In en, this message translates to:
  /// **'past'**
  String get nicknamePrefix146;

  /// No description provided for @nicknamePrefix147.
  ///
  /// In en, this message translates to:
  /// **'present'**
  String get nicknamePrefix147;

  /// No description provided for @nicknamePrefix148.
  ///
  /// In en, this message translates to:
  /// **'future'**
  String get nicknamePrefix148;

  /// No description provided for @nicknamePrefix149.
  ///
  /// In en, this message translates to:
  /// **'of origin'**
  String get nicknamePrefix149;

  /// No description provided for @nicknamePrefix150.
  ///
  /// In en, this message translates to:
  /// **'apocalyptic'**
  String get nicknamePrefix150;

  /// No description provided for @nicknamePrefix151.
  ///
  /// In en, this message translates to:
  /// **'infinite'**
  String get nicknamePrefix151;

  /// No description provided for @nicknamePrefix152.
  ///
  /// In en, this message translates to:
  /// **'finite'**
  String get nicknamePrefix152;

  /// No description provided for @nicknamePrefix153.
  ///
  /// In en, this message translates to:
  /// **'silent'**
  String get nicknamePrefix153;

  /// No description provided for @nicknamePrefix154.
  ///
  /// In en, this message translates to:
  /// **'of noise'**
  String get nicknamePrefix154;

  /// No description provided for @nicknamePrefix155.
  ///
  /// In en, this message translates to:
  /// **'singing'**
  String get nicknamePrefix155;

  /// No description provided for @nicknamePrefix156.
  ///
  /// In en, this message translates to:
  /// **'dancing'**
  String get nicknamePrefix156;

  /// No description provided for @nicknamePrefix157.
  ///
  /// In en, this message translates to:
  /// **'crying'**
  String get nicknamePrefix157;

  /// No description provided for @nicknamePrefix158.
  ///
  /// In en, this message translates to:
  /// **'smiling'**
  String get nicknamePrefix158;

  /// No description provided for @nicknamePrefix159.
  ///
  /// In en, this message translates to:
  /// **'whispering'**
  String get nicknamePrefix159;

  /// No description provided for @nicknamePrefix160.
  ///
  /// In en, this message translates to:
  /// **'crying'**
  String get nicknamePrefix160;

  /// No description provided for @nicknamePrefix161.
  ///
  /// In en, this message translates to:
  /// **'praying'**
  String get nicknamePrefix161;

  /// No description provided for @nicknamePrefix162.
  ///
  /// In en, this message translates to:
  /// **'pleading'**
  String get nicknamePrefix162;

  /// No description provided for @nicknamePrefix163.
  ///
  /// In en, this message translates to:
  /// **'commanding'**
  String get nicknamePrefix163;

  /// No description provided for @nicknamePrefix164.
  ///
  /// In en, this message translates to:
  /// **'submissive'**
  String get nicknamePrefix164;

  /// No description provided for @nicknamePrefix165.
  ///
  /// In en, this message translates to:
  /// **'ruling'**
  String get nicknamePrefix165;

  /// No description provided for @nicknamePrefix166.
  ///
  /// In en, this message translates to:
  /// **'serving'**
  String get nicknamePrefix166;

  /// No description provided for @nicknamePrefix167.
  ///
  /// In en, this message translates to:
  /// **'guiding'**
  String get nicknamePrefix167;

  /// No description provided for @nicknamePrefix168.
  ///
  /// In en, this message translates to:
  /// **'accompanying'**
  String get nicknamePrefix168;

  /// No description provided for @nicknamePrefix169.
  ///
  /// In en, this message translates to:
  /// **'teaching'**
  String get nicknamePrefix169;

  /// No description provided for @nicknamePrefix170.
  ///
  /// In en, this message translates to:
  /// **'learning'**
  String get nicknamePrefix170;

  /// No description provided for @nicknamePrefix171.
  ///
  /// In en, this message translates to:
  /// **'of memory'**
  String get nicknamePrefix171;

  /// No description provided for @nicknamePrefix172.
  ///
  /// In en, this message translates to:
  /// **'of memories'**
  String get nicknamePrefix172;

  /// No description provided for @nicknamePrefix173.
  ///
  /// In en, this message translates to:
  /// **'of wounds'**
  String get nicknamePrefix173;

  /// No description provided for @nicknamePrefix174.
  ///
  /// In en, this message translates to:
  /// **'healing'**
  String get nicknamePrefix174;

  /// No description provided for @nicknamePrefix175.
  ///
  /// In en, this message translates to:
  /// **'poisonous'**
  String get nicknamePrefix175;

  /// No description provided for @nicknamePrefix176.
  ///
  /// In en, this message translates to:
  /// **'medicine'**
  String get nicknamePrefix176;

  /// No description provided for @nicknamePrefix177.
  ///
  /// In en, this message translates to:
  /// **'welcome'**
  String get nicknamePrefix177;

  /// No description provided for @nicknamePrefix178.
  ///
  /// In en, this message translates to:
  /// **'of substance'**
  String get nicknamePrefix178;

  /// No description provided for @nicknamePrefix179.
  ///
  /// In en, this message translates to:
  /// **'ideal'**
  String get nicknamePrefix179;

  /// No description provided for @nicknamePrefix180.
  ///
  /// In en, this message translates to:
  /// **'real'**
  String get nicknamePrefix180;

  /// No description provided for @nicknamePrefix181.
  ///
  /// In en, this message translates to:
  /// **'imaginary'**
  String get nicknamePrefix181;

  /// No description provided for @nicknamePrefix182.
  ///
  /// In en, this message translates to:
  /// **'natural'**
  String get nicknamePrefix182;

  /// No description provided for @nicknamePrefix183.
  ///
  /// In en, this message translates to:
  /// **'artificial'**
  String get nicknamePrefix183;

  /// No description provided for @nicknamePrefix184.
  ///
  /// In en, this message translates to:
  /// **'in the beginning'**
  String get nicknamePrefix184;

  /// No description provided for @nicknamePrefix185.
  ///
  /// In en, this message translates to:
  /// **'eternity'**
  String get nicknamePrefix185;

  /// No description provided for @nicknamePrefix186.
  ///
  /// In en, this message translates to:
  /// **'of the moment'**
  String get nicknamePrefix186;

  /// No description provided for @nicknamePrefix187.
  ///
  /// In en, this message translates to:
  /// **'fleeting'**
  String get nicknamePrefix187;

  /// No description provided for @nicknamePrefix188.
  ///
  /// In en, this message translates to:
  /// **'eternal'**
  String get nicknamePrefix188;

  /// No description provided for @nicknamePrefix189.
  ///
  /// In en, this message translates to:
  /// **'of change'**
  String get nicknamePrefix189;

  /// No description provided for @nicknamePrefix190.
  ///
  /// In en, this message translates to:
  /// **'still'**
  String get nicknamePrefix190;

  /// No description provided for @nicknamePrefix191.
  ///
  /// In en, this message translates to:
  /// **'flowing'**
  String get nicknamePrefix191;

  /// No description provided for @nicknamePrefix192.
  ///
  /// In en, this message translates to:
  /// **'rundown'**
  String get nicknamePrefix192;

  /// No description provided for @nicknamePrefix193.
  ///
  /// In en, this message translates to:
  /// **'blazing'**
  String get nicknamePrefix193;

  /// No description provided for @nicknamePrefix194.
  ///
  /// In en, this message translates to:
  /// **'cooling down'**
  String get nicknamePrefix194;

  /// No description provided for @nicknamePrefix195.
  ///
  /// In en, this message translates to:
  /// **'blooming'**
  String get nicknamePrefix195;

  /// No description provided for @nicknamePrefix196.
  ///
  /// In en, this message translates to:
  /// **'withering'**
  String get nicknamePrefix196;

  /// No description provided for @nicknamePrefix197.
  ///
  /// In en, this message translates to:
  /// **'growing up'**
  String get nicknamePrefix197;

  /// No description provided for @nicknamePrefix198.
  ///
  /// In en, this message translates to:
  /// **'dying'**
  String get nicknamePrefix198;

  /// No description provided for @nicknamePrefix199.
  ///
  /// In en, this message translates to:
  /// **'breathing'**
  String get nicknamePrefix199;

  /// No description provided for @nicknamePrefix200.
  ///
  /// In en, this message translates to:
  /// **'suffocating'**
  String get nicknamePrefix200;

  /// No description provided for @nicknameSuffix0.
  ///
  /// In en, this message translates to:
  /// **'prophet'**
  String get nicknameSuffix0;

  /// No description provided for @nicknameSuffix1.
  ///
  /// In en, this message translates to:
  /// **'wizard'**
  String get nicknameSuffix1;

  /// No description provided for @nicknameSuffix2.
  ///
  /// In en, this message translates to:
  /// **'witch'**
  String get nicknameSuffix2;

  /// No description provided for @nicknameSuffix3.
  ///
  /// In en, this message translates to:
  /// **'article'**
  String get nicknameSuffix3;

  /// No description provided for @nicknameSuffix4.
  ///
  /// In en, this message translates to:
  /// **'warrior'**
  String get nicknameSuffix4;

  /// No description provided for @nicknameSuffix5.
  ///
  /// In en, this message translates to:
  /// **'Archer'**
  String get nicknameSuffix5;

  /// No description provided for @nicknameSuffix6.
  ///
  /// In en, this message translates to:
  /// **'thief'**
  String get nicknameSuffix6;

  /// No description provided for @nicknameSuffix7.
  ///
  /// In en, this message translates to:
  /// **'assassin'**
  String get nicknameSuffix7;

  /// No description provided for @nicknameSuffix8.
  ///
  /// In en, this message translates to:
  /// **'paladin'**
  String get nicknameSuffix8;

  /// No description provided for @nicknameSuffix9.
  ///
  /// In en, this message translates to:
  /// **'priest'**
  String get nicknameSuffix9;

  /// No description provided for @nicknameSuffix10.
  ///
  /// In en, this message translates to:
  /// **'priestess'**
  String get nicknameSuffix10;

  /// No description provided for @nicknameSuffix11.
  ///
  /// In en, this message translates to:
  /// **'monk'**
  String get nicknameSuffix11;

  /// No description provided for @nicknameSuffix12.
  ///
  /// In en, this message translates to:
  /// **'powwow'**
  String get nicknameSuffix12;

  /// No description provided for @nicknameSuffix13.
  ///
  /// In en, this message translates to:
  /// **'alchemist'**
  String get nicknameSuffix13;

  /// No description provided for @nicknameSuffix14.
  ///
  /// In en, this message translates to:
  /// **'necromancer'**
  String get nicknameSuffix14;

  /// No description provided for @nicknameSuffix15.
  ///
  /// In en, this message translates to:
  /// **'spiritist'**
  String get nicknameSuffix15;

  /// No description provided for @nicknameSuffix16.
  ///
  /// In en, this message translates to:
  /// **'summoner'**
  String get nicknameSuffix16;

  /// No description provided for @nicknameSuffix17.
  ///
  /// In en, this message translates to:
  /// **'illusionist'**
  String get nicknameSuffix17;

  /// No description provided for @nicknameSuffix18.
  ///
  /// In en, this message translates to:
  /// **'healer'**
  String get nicknameSuffix18;

  /// No description provided for @nicknameSuffix19.
  ///
  /// In en, this message translates to:
  /// **'wise man'**
  String get nicknameSuffix19;

  /// No description provided for @nicknameSuffix20.
  ///
  /// In en, this message translates to:
  /// **'scholar'**
  String get nicknameSuffix20;

  /// No description provided for @nicknameSuffix21.
  ///
  /// In en, this message translates to:
  /// **'researcher'**
  String get nicknameSuffix21;

  /// No description provided for @nicknameSuffix22.
  ///
  /// In en, this message translates to:
  /// **'explorer'**
  String get nicknameSuffix22;

  /// No description provided for @nicknameSuffix23.
  ///
  /// In en, this message translates to:
  /// **'traveler'**
  String get nicknameSuffix23;

  /// No description provided for @nicknameSuffix24.
  ///
  /// In en, this message translates to:
  /// **'vagabond'**
  String get nicknameSuffix24;

  /// No description provided for @nicknameSuffix25.
  ///
  /// In en, this message translates to:
  /// **'vagabond'**
  String get nicknameSuffix25;

  /// No description provided for @nicknameSuffix26.
  ///
  /// In en, this message translates to:
  /// **'pilgrim'**
  String get nicknameSuffix26;

  /// No description provided for @nicknameSuffix27.
  ///
  /// In en, this message translates to:
  /// **'seeker'**
  String get nicknameSuffix27;

  /// No description provided for @nicknameSuffix28.
  ///
  /// In en, this message translates to:
  /// **'observer'**
  String get nicknameSuffix28;

  /// No description provided for @nicknameSuffix29.
  ///
  /// In en, this message translates to:
  /// **'recorder'**
  String get nicknameSuffix29;

  /// No description provided for @nicknameSuffix30.
  ///
  /// In en, this message translates to:
  /// **'communicator'**
  String get nicknameSuffix30;

  /// No description provided for @nicknameSuffix31.
  ///
  /// In en, this message translates to:
  /// **'tutelar'**
  String get nicknameSuffix31;

  /// No description provided for @nicknameSuffix32.
  ///
  /// In en, this message translates to:
  /// **'warden'**
  String get nicknameSuffix32;

  /// No description provided for @nicknameSuffix33.
  ///
  /// In en, this message translates to:
  /// **'guard'**
  String get nicknameSuffix33;

  /// No description provided for @nicknameSuffix34.
  ///
  /// In en, this message translates to:
  /// **'gatekeeper'**
  String get nicknameSuffix34;

  /// No description provided for @nicknameSuffix35.
  ///
  /// In en, this message translates to:
  /// **'judge'**
  String get nicknameSuffix35;

  /// No description provided for @nicknameSuffix36.
  ///
  /// In en, this message translates to:
  /// **'bailiff'**
  String get nicknameSuffix36;

  /// No description provided for @nicknameSuffix37.
  ///
  /// In en, this message translates to:
  /// **'governor'**
  String get nicknameSuffix37;

  /// No description provided for @nicknameSuffix38.
  ///
  /// In en, this message translates to:
  /// **'ruler'**
  String get nicknameSuffix38;

  /// No description provided for @nicknameSuffix39.
  ///
  /// In en, this message translates to:
  /// **'king'**
  String get nicknameSuffix39;

  /// No description provided for @nicknameSuffix40.
  ///
  /// In en, this message translates to:
  /// **'queen'**
  String get nicknameSuffix40;

  /// No description provided for @nicknameSuffix41.
  ///
  /// In en, this message translates to:
  /// **'emperor'**
  String get nicknameSuffix41;

  /// No description provided for @nicknameSuffix42.
  ///
  /// In en, this message translates to:
  /// **'empress'**
  String get nicknameSuffix42;

  /// No description provided for @nicknameSuffix43.
  ///
  /// In en, this message translates to:
  /// **'nobility'**
  String get nicknameSuffix43;

  /// No description provided for @nicknameSuffix44.
  ///
  /// In en, this message translates to:
  /// **'permanent residence'**
  String get nicknameSuffix44;

  /// No description provided for @nicknameSuffix45.
  ///
  /// In en, this message translates to:
  /// **'knight commander'**
  String get nicknameSuffix45;

  /// No description provided for @nicknameSuffix46.
  ///
  /// In en, this message translates to:
  /// **'mercenary'**
  String get nicknameSuffix46;

  /// No description provided for @nicknameSuffix47.
  ///
  /// In en, this message translates to:
  /// **'pirate'**
  String get nicknameSuffix47;

  /// No description provided for @nicknameSuffix48.
  ///
  /// In en, this message translates to:
  /// **'thief'**
  String get nicknameSuffix48;

  /// No description provided for @nicknameSuffix49.
  ///
  /// In en, this message translates to:
  /// **'fraud'**
  String get nicknameSuffix49;

  /// No description provided for @nicknameSuffix50.
  ///
  /// In en, this message translates to:
  /// **'jester'**
  String get nicknameSuffix50;

  /// No description provided for @nicknameSuffix51.
  ///
  /// In en, this message translates to:
  /// **'fool'**
  String get nicknameSuffix51;

  /// No description provided for @nicknameSuffix52.
  ///
  /// In en, this message translates to:
  /// **'hermit'**
  String get nicknameSuffix52;

  /// No description provided for @nicknameSuffix53.
  ///
  /// In en, this message translates to:
  /// **'heretic'**
  String get nicknameSuffix53;

  /// No description provided for @nicknameSuffix54.
  ///
  /// In en, this message translates to:
  /// **'betrayer'**
  String get nicknameSuffix54;

  /// No description provided for @nicknameSuffix55.
  ///
  /// In en, this message translates to:
  /// **'traitor'**
  String get nicknameSuffix55;

  /// No description provided for @nicknameSuffix56.
  ///
  /// In en, this message translates to:
  /// **'hero'**
  String get nicknameSuffix56;

  /// No description provided for @nicknameSuffix57.
  ///
  /// In en, this message translates to:
  /// **'saver'**
  String get nicknameSuffix57;

  /// No description provided for @nicknameSuffix58.
  ///
  /// In en, this message translates to:
  /// **'liberator'**
  String get nicknameSuffix58;

  /// No description provided for @nicknameSuffix59.
  ///
  /// In en, this message translates to:
  /// **'destroyer'**
  String get nicknameSuffix59;

  /// No description provided for @nicknameSuffix60.
  ///
  /// In en, this message translates to:
  /// **'creator'**
  String get nicknameSuffix60;

  /// No description provided for @nicknameSuffix61.
  ///
  /// In en, this message translates to:
  /// **'god'**
  String get nicknameSuffix61;

  /// No description provided for @nicknameSuffix62.
  ///
  /// In en, this message translates to:
  /// **'goddess'**
  String get nicknameSuffix62;

  /// No description provided for @nicknameSuffix63.
  ///
  /// In en, this message translates to:
  /// **'angel'**
  String get nicknameSuffix63;

  /// No description provided for @nicknameSuffix64.
  ///
  /// In en, this message translates to:
  /// **'devil'**
  String get nicknameSuffix64;

  /// No description provided for @nicknameSuffix65.
  ///
  /// In en, this message translates to:
  /// **'government ordinance'**
  String get nicknameSuffix65;

  /// No description provided for @nicknameSuffix66.
  ///
  /// In en, this message translates to:
  /// **'fairy'**
  String get nicknameSuffix66;

  /// No description provided for @nicknameSuffix67.
  ///
  /// In en, this message translates to:
  /// **'monster'**
  String get nicknameSuffix67;

  /// No description provided for @nicknameSuffix68.
  ///
  /// In en, this message translates to:
  /// **'demon beast'**
  String get nicknameSuffix68;

  /// No description provided for @nicknameSuffix69.
  ///
  /// In en, this message translates to:
  /// **'dragon'**
  String get nicknameSuffix69;

  /// No description provided for @nicknameSuffix70.
  ///
  /// In en, this message translates to:
  /// **'ghost'**
  String get nicknameSuffix70;

  /// No description provided for @nicknameSuffix71.
  ///
  /// In en, this message translates to:
  /// **'shade'**
  String get nicknameSuffix71;

  /// No description provided for @nicknameSuffix72.
  ///
  /// In en, this message translates to:
  /// **'undead'**
  String get nicknameSuffix72;

  /// No description provided for @nicknameSuffix73.
  ///
  /// In en, this message translates to:
  /// **'vampire'**
  String get nicknameSuffix73;

  /// No description provided for @nicknameSuffix74.
  ///
  /// In en, this message translates to:
  /// **'werewolf'**
  String get nicknameSuffix74;

  /// No description provided for @nicknameSuffix75.
  ///
  /// In en, this message translates to:
  /// **'mermaid'**
  String get nicknameSuffix75;

  /// No description provided for @nicknameSuffix76.
  ///
  /// In en, this message translates to:
  /// **'siren'**
  String get nicknameSuffix76;

  /// No description provided for @nicknameSuffix77.
  ///
  /// In en, this message translates to:
  /// **'nymph'**
  String get nicknameSuffix77;

  /// No description provided for @nicknameSuffix78.
  ///
  /// In en, this message translates to:
  /// **'goblin'**
  String get nicknameSuffix78;

  /// No description provided for @nicknameSuffix79.
  ///
  /// In en, this message translates to:
  /// **'oak'**
  String get nicknameSuffix79;

  /// No description provided for @nicknameSuffix80.
  ///
  /// In en, this message translates to:
  /// **'troll'**
  String get nicknameSuffix80;

  /// No description provided for @nicknameSuffix81.
  ///
  /// In en, this message translates to:
  /// **'elf'**
  String get nicknameSuffix81;

  /// No description provided for @nicknameSuffix82.
  ///
  /// In en, this message translates to:
  /// **'dwarf'**
  String get nicknameSuffix82;

  /// No description provided for @nicknameSuffix83.
  ///
  /// In en, this message translates to:
  /// **'giant'**
  String get nicknameSuffix83;

  /// No description provided for @nicknameSuffix84.
  ///
  /// In en, this message translates to:
  /// **'postmark'**
  String get nicknameSuffix84;

  /// No description provided for @nicknameSuffix85.
  ///
  /// In en, this message translates to:
  /// **'human being'**
  String get nicknameSuffix85;

  /// No description provided for @nicknameSuffix86.
  ///
  /// In en, this message translates to:
  /// **'prisoner'**
  String get nicknameSuffix86;

  /// No description provided for @nicknameSuffix87.
  ///
  /// In en, this message translates to:
  /// **'signature'**
  String get nicknameSuffix87;

  /// No description provided for @nicknameSuffix88.
  ///
  /// In en, this message translates to:
  /// **'Fishman'**
  String get nicknameSuffix88;

  /// No description provided for @nicknameSuffix89.
  ///
  /// In en, this message translates to:
  /// **'employee'**
  String get nicknameSuffix89;

  /// No description provided for @nicknameSuffix90.
  ///
  /// In en, this message translates to:
  /// **'evil spirit'**
  String get nicknameSuffix90;

  /// No description provided for @nicknameSuffix91.
  ///
  /// In en, this message translates to:
  /// **'Sura'**
  String get nicknameSuffix91;

  /// No description provided for @nicknameSuffix92.
  ///
  /// In en, this message translates to:
  /// **'hell'**
  String get nicknameSuffix92;

  /// No description provided for @nicknameSuffix93.
  ///
  /// In en, this message translates to:
  /// **'heaven'**
  String get nicknameSuffix93;

  /// No description provided for @nicknameSuffix94.
  ///
  /// In en, this message translates to:
  /// **'underworld'**
  String get nicknameSuffix94;

  /// No description provided for @nicknameSuffix95.
  ///
  /// In en, this message translates to:
  /// **'Otherworld'**
  String get nicknameSuffix95;

  /// No description provided for @nicknameSuffix96.
  ///
  /// In en, this message translates to:
  /// **'abyss'**
  String get nicknameSuffix96;

  /// No description provided for @nicknameSuffix97.
  ///
  /// In en, this message translates to:
  /// **'chaos'**
  String get nicknameSuffix97;

  /// No description provided for @nicknameSuffix98.
  ///
  /// In en, this message translates to:
  /// **'order'**
  String get nicknameSuffix98;

  /// No description provided for @nicknameSuffix99.
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get nicknameSuffix99;

  /// No description provided for @nicknameSuffix100.
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get nicknameSuffix100;

  /// No description provided for @nicknamePrefix201.
  ///
  /// In en, this message translates to:
  /// **'brilliant'**
  String get nicknamePrefix201;

  /// No description provided for @nicknamePrefix202.
  ///
  /// In en, this message translates to:
  /// **'subtle'**
  String get nicknamePrefix202;

  /// No description provided for @nicknamePrefix203.
  ///
  /// In en, this message translates to:
  /// **'hazy'**
  String get nicknamePrefix203;

  /// No description provided for @nicknamePrefix204.
  ///
  /// In en, this message translates to:
  /// **'faint'**
  String get nicknamePrefix204;

  /// No description provided for @nicknamePrefix205.
  ///
  /// In en, this message translates to:
  /// **'transparent'**
  String get nicknamePrefix205;

  /// No description provided for @nicknamePrefix206.
  ///
  /// In en, this message translates to:
  /// **'faint'**
  String get nicknamePrefix206;

  /// No description provided for @nicknamePrefix207.
  ///
  /// In en, this message translates to:
  /// **'dazzling'**
  String get nicknamePrefix207;

  /// No description provided for @nicknamePrefix208.
  ///
  /// In en, this message translates to:
  /// **'weird'**
  String get nicknamePrefix208;

  /// No description provided for @nicknamePrefix209.
  ///
  /// In en, this message translates to:
  /// **'peculiar'**
  String get nicknamePrefix209;

  /// No description provided for @nicknamePrefix210.
  ///
  /// In en, this message translates to:
  /// **'special'**
  String get nicknamePrefix210;

  /// No description provided for @nicknamePrefix211.
  ///
  /// In en, this message translates to:
  /// **'noble'**
  String get nicknamePrefix211;

  /// No description provided for @nicknamePrefix212.
  ///
  /// In en, this message translates to:
  /// **'pure'**
  String get nicknamePrefix212;

  /// No description provided for @nicknamePrefix213.
  ///
  /// In en, this message translates to:
  /// **'fallen'**
  String get nicknamePrefix213;

  /// No description provided for @nicknamePrefix214.
  ///
  /// In en, this message translates to:
  /// **'lone'**
  String get nicknamePrefix214;

  /// No description provided for @nicknamePrefix215.
  ///
  /// In en, this message translates to:
  /// **'lonesome'**
  String get nicknamePrefix215;

  /// No description provided for @nicknamePrefix216.
  ///
  /// In en, this message translates to:
  /// **'desolate'**
  String get nicknamePrefix216;

  /// No description provided for @nicknamePrefix217.
  ///
  /// In en, this message translates to:
  /// **'Distant'**
  String get nicknamePrefix217;

  /// No description provided for @nicknamePrefix218.
  ///
  /// In en, this message translates to:
  /// **'harsh'**
  String get nicknamePrefix218;

  /// No description provided for @nicknamePrefix219.
  ///
  /// In en, this message translates to:
  /// **'ruthless'**
  String get nicknamePrefix219;

  /// No description provided for @nicknamePrefix220.
  ///
  /// In en, this message translates to:
  /// **'cruel'**
  String get nicknamePrefix220;

  /// No description provided for @nicknamePrefix221.
  ///
  /// In en, this message translates to:
  /// **'big'**
  String get nicknamePrefix221;

  /// No description provided for @nicknamePrefix222.
  ///
  /// In en, this message translates to:
  /// **'tough'**
  String get nicknamePrefix222;

  /// No description provided for @nicknamePrefix223.
  ///
  /// In en, this message translates to:
  /// **'firm'**
  String get nicknamePrefix223;

  /// No description provided for @nicknamePrefix224.
  ///
  /// In en, this message translates to:
  /// **'sinuous'**
  String get nicknamePrefix224;

  /// No description provided for @nicknamePrefix225.
  ///
  /// In en, this message translates to:
  /// **'quick'**
  String get nicknamePrefix225;

  /// No description provided for @nicknamePrefix226.
  ///
  /// In en, this message translates to:
  /// **'slow'**
  String get nicknamePrefix226;

  /// No description provided for @nicknamePrefix227.
  ///
  /// In en, this message translates to:
  /// **'in silence'**
  String get nicknamePrefix227;

  /// No description provided for @nicknamePrefix228.
  ///
  /// In en, this message translates to:
  /// **'in chaos'**
  String get nicknamePrefix228;

  /// No description provided for @nicknamePrefix229.
  ///
  /// In en, this message translates to:
  /// **'in memory'**
  String get nicknamePrefix229;

  /// No description provided for @nicknamePrefix230.
  ///
  /// In en, this message translates to:
  /// **'imaginary'**
  String get nicknamePrefix230;

  /// No description provided for @nicknamePrefix231.
  ///
  /// In en, this message translates to:
  /// **'silent'**
  String get nicknamePrefix231;

  /// No description provided for @nicknamePrefix232.
  ///
  /// In en, this message translates to:
  /// **'whispering'**
  String get nicknamePrefix232;

  /// No description provided for @nicknamePrefix233.
  ///
  /// In en, this message translates to:
  /// **'singing'**
  String get nicknamePrefix233;

  /// No description provided for @nicknamePrefix234.
  ///
  /// In en, this message translates to:
  /// **'dancing'**
  String get nicknamePrefix234;

  /// No description provided for @nicknamePrefix235.
  ///
  /// In en, this message translates to:
  /// **'sobbing'**
  String get nicknamePrefix235;

  /// No description provided for @nicknamePrefix236.
  ///
  /// In en, this message translates to:
  /// **'smiling'**
  String get nicknamePrefix236;

  /// No description provided for @nicknamePrefix237.
  ///
  /// In en, this message translates to:
  /// **'mocking'**
  String get nicknamePrefix237;

  /// No description provided for @nicknamePrefix238.
  ///
  /// In en, this message translates to:
  /// **'contemplating'**
  String get nicknamePrefix238;

  /// No description provided for @nicknamePrefix239.
  ///
  /// In en, this message translates to:
  /// **'wandering'**
  String get nicknamePrefix239;

  /// No description provided for @nicknamePrefix240.
  ///
  /// In en, this message translates to:
  /// **'wandering'**
  String get nicknamePrefix240;

  /// No description provided for @nicknamePrefix241.
  ///
  /// In en, this message translates to:
  /// **'awake'**
  String get nicknamePrefix241;

  /// No description provided for @nicknamePrefix242.
  ///
  /// In en, this message translates to:
  /// **'asleep'**
  String get nicknamePrefix242;

  /// No description provided for @nicknamePrefix243.
  ///
  /// In en, this message translates to:
  /// **'dreaming'**
  String get nicknamePrefix243;

  /// No description provided for @nicknamePrefix244.
  ///
  /// In en, this message translates to:
  /// **'daydreaming'**
  String get nicknamePrefix244;

  /// No description provided for @nicknamePrefix245.
  ///
  /// In en, this message translates to:
  /// **'delusional'**
  String get nicknamePrefix245;

  /// No description provided for @nicknamePrefix246.
  ///
  /// In en, this message translates to:
  /// **'praying'**
  String get nicknamePrefix246;

  /// No description provided for @nicknamePrefix247.
  ///
  /// In en, this message translates to:
  /// **'earnest'**
  String get nicknamePrefix247;

  /// No description provided for @nicknamePrefix248.
  ///
  /// In en, this message translates to:
  /// **'sorrowful'**
  String get nicknamePrefix248;

  /// No description provided for @nicknamePrefix249.
  ///
  /// In en, this message translates to:
  /// **'miserable'**
  String get nicknamePrefix249;

  /// No description provided for @nicknamePrefix250.
  ///
  /// In en, this message translates to:
  /// **'sublime'**
  String get nicknamePrefix250;

  /// No description provided for @nicknamePrefix251.
  ///
  /// In en, this message translates to:
  /// **'wicked'**
  String get nicknamePrefix251;

  /// No description provided for @nicknamePrefix252.
  ///
  /// In en, this message translates to:
  /// **'mean'**
  String get nicknamePrefix252;

  /// No description provided for @nicknamePrefix253.
  ///
  /// In en, this message translates to:
  /// **'arrogant'**
  String get nicknamePrefix253;

  /// No description provided for @nicknamePrefix254.
  ///
  /// In en, this message translates to:
  /// **'modest'**
  String get nicknamePrefix254;

  /// No description provided for @nicknamePrefix255.
  ///
  /// In en, this message translates to:
  /// **'fond'**
  String get nicknamePrefix255;

  /// No description provided for @nicknamePrefix256.
  ///
  /// In en, this message translates to:
  /// **'warm'**
  String get nicknamePrefix256;

  /// No description provided for @nicknamePrefix257.
  ///
  /// In en, this message translates to:
  /// **'cool'**
  String get nicknamePrefix257;

  /// No description provided for @nicknamePrefix258.
  ///
  /// In en, this message translates to:
  /// **'chilly'**
  String get nicknamePrefix258;

  /// No description provided for @nicknamePrefix259.
  ///
  /// In en, this message translates to:
  /// **'bizarre'**
  String get nicknamePrefix259;

  /// No description provided for @nicknamePrefix260.
  ///
  /// In en, this message translates to:
  /// **'uncanny'**
  String get nicknamePrefix260;

  /// No description provided for @nicknamePrefix261.
  ///
  /// In en, this message translates to:
  /// **'rapt'**
  String get nicknamePrefix261;

  /// No description provided for @nicknamePrefix262.
  ///
  /// In en, this message translates to:
  /// **'fascinating'**
  String get nicknamePrefix262;

  /// No description provided for @nicknamePrefix263.
  ///
  /// In en, this message translates to:
  /// **'dizzying'**
  String get nicknamePrefix263;

  /// No description provided for @nicknamePrefix264.
  ///
  /// In en, this message translates to:
  /// **'sweetish'**
  String get nicknamePrefix264;

  /// No description provided for @nicknamePrefix265.
  ///
  /// In en, this message translates to:
  /// **'bitter'**
  String get nicknamePrefix265;

  /// No description provided for @nicknamePrefix266.
  ///
  /// In en, this message translates to:
  /// **'bitterish'**
  String get nicknamePrefix266;

  /// No description provided for @nicknamePrefix267.
  ///
  /// In en, this message translates to:
  /// **'barbed'**
  String get nicknamePrefix267;

  /// No description provided for @nicknamePrefix268.
  ///
  /// In en, this message translates to:
  /// **'sharp'**
  String get nicknamePrefix268;

  /// No description provided for @nicknamePrefix269.
  ///
  /// In en, this message translates to:
  /// **'dull'**
  String get nicknamePrefix269;

  /// No description provided for @nicknamePrefix270.
  ///
  /// In en, this message translates to:
  /// **'harsh'**
  String get nicknamePrefix270;

  /// No description provided for @nicknamePrefix271.
  ///
  /// In en, this message translates to:
  /// **'soft'**
  String get nicknamePrefix271;

  /// No description provided for @nicknamePrefix272.
  ///
  /// In en, this message translates to:
  /// **'cozy'**
  String get nicknamePrefix272;

  /// No description provided for @nicknamePrefix273.
  ///
  /// In en, this message translates to:
  /// **'comfortable'**
  String get nicknamePrefix273;

  /// No description provided for @nicknamePrefix274.
  ///
  /// In en, this message translates to:
  /// **'precarious'**
  String get nicknamePrefix274;

  /// No description provided for @nicknamePrefix275.
  ///
  /// In en, this message translates to:
  /// **'uneasy'**
  String get nicknamePrefix275;

  /// No description provided for @nicknamePrefix276.
  ///
  /// In en, this message translates to:
  /// **'calm'**
  String get nicknamePrefix276;

  /// No description provided for @nicknamePrefix277.
  ///
  /// In en, this message translates to:
  /// **'calm'**
  String get nicknamePrefix277;

  /// No description provided for @nicknamePrefix278.
  ///
  /// In en, this message translates to:
  /// **'drowsy'**
  String get nicknamePrefix278;

  /// No description provided for @nicknamePrefix279.
  ///
  /// In en, this message translates to:
  /// **'bored'**
  String get nicknamePrefix279;

  /// No description provided for @nicknamePrefix280.
  ///
  /// In en, this message translates to:
  /// **'passionate'**
  String get nicknamePrefix280;

  /// No description provided for @nicknamePrefix281.
  ///
  /// In en, this message translates to:
  /// **'nonchalant'**
  String get nicknamePrefix281;

  /// No description provided for @nicknamePrefix282.
  ///
  /// In en, this message translates to:
  /// **'tranquil'**
  String get nicknamePrefix282;

  /// No description provided for @nicknamePrefix283.
  ///
  /// In en, this message translates to:
  /// **'violent'**
  String get nicknamePrefix283;

  /// No description provided for @nicknamePrefix284.
  ///
  /// In en, this message translates to:
  /// **'fierce'**
  String get nicknamePrefix284;

  /// No description provided for @nicknamePrefix285.
  ///
  /// In en, this message translates to:
  /// **'crazy'**
  String get nicknamePrefix285;

  /// No description provided for @nicknamePrefix286.
  ///
  /// In en, this message translates to:
  /// **'gone crazy'**
  String get nicknamePrefix286;

  /// No description provided for @nicknamePrefix287.
  ///
  /// In en, this message translates to:
  /// **'rational'**
  String get nicknamePrefix287;

  /// No description provided for @nicknamePrefix288.
  ///
  /// In en, this message translates to:
  /// **'emotional'**
  String get nicknamePrefix288;

  /// No description provided for @nicknamePrefix289.
  ///
  /// In en, this message translates to:
  /// **'cool-headed'**
  String get nicknamePrefix289;

  /// No description provided for @nicknamePrefix290.
  ///
  /// In en, this message translates to:
  /// **'sensible'**
  String get nicknamePrefix290;

  /// No description provided for @nicknamePrefix291.
  ///
  /// In en, this message translates to:
  /// **'foolish'**
  String get nicknamePrefix291;

  /// No description provided for @nicknamePrefix292.
  ///
  /// In en, this message translates to:
  /// **'innocent'**
  String get nicknamePrefix292;

  /// No description provided for @nicknamePrefix293.
  ///
  /// In en, this message translates to:
  /// **'cunning'**
  String get nicknamePrefix293;

  /// No description provided for @nicknamePrefix294.
  ///
  /// In en, this message translates to:
  /// **'serpentine'**
  String get nicknamePrefix294;

  /// No description provided for @nicknamePrefix295.
  ///
  /// In en, this message translates to:
  /// **'pure white'**
  String get nicknamePrefix295;

  /// No description provided for @nicknamePrefix296.
  ///
  /// In en, this message translates to:
  /// **'jet black'**
  String get nicknamePrefix296;

  /// No description provided for @nicknamePrefix297.
  ///
  /// In en, this message translates to:
  /// **'golden'**
  String get nicknamePrefix297;

  /// No description provided for @nicknamePrefix298.
  ///
  /// In en, this message translates to:
  /// **'argent'**
  String get nicknamePrefix298;

  /// No description provided for @nicknamePrefix299.
  ///
  /// In en, this message translates to:
  /// **'bloody'**
  String get nicknamePrefix299;

  /// No description provided for @nicknameSuffix101.
  ///
  /// In en, this message translates to:
  /// **'seeker'**
  String get nicknameSuffix101;

  /// No description provided for @nicknameSuffix102.
  ///
  /// In en, this message translates to:
  /// **'pilgrim'**
  String get nicknameSuffix102;

  /// No description provided for @nicknameSuffix103.
  ///
  /// In en, this message translates to:
  /// **'vagabond'**
  String get nicknameSuffix103;

  /// No description provided for @nicknameSuffix104.
  ///
  /// In en, this message translates to:
  /// **'hermit'**
  String get nicknameSuffix104;

  /// No description provided for @nicknameSuffix105.
  ///
  /// In en, this message translates to:
  /// **'Ethan'**
  String get nicknameSuffix105;

  /// No description provided for @nicknameSuffix106.
  ///
  /// In en, this message translates to:
  /// **'traitor'**
  String get nicknameSuffix106;

  /// No description provided for @nicknameSuffix107.
  ///
  /// In en, this message translates to:
  /// **'pioneer'**
  String get nicknameSuffix107;

  /// No description provided for @nicknameSuffix108.
  ///
  /// In en, this message translates to:
  /// **'conqueror'**
  String get nicknameSuffix108;

  /// No description provided for @nicknameSuffix109.
  ///
  /// In en, this message translates to:
  /// **'ruler'**
  String get nicknameSuffix109;

  /// No description provided for @nicknameSuffix110.
  ///
  /// In en, this message translates to:
  /// **'orchestrator'**
  String get nicknameSuffix110;

  /// No description provided for @nicknameSuffix111.
  ///
  /// In en, this message translates to:
  /// **'tutelar'**
  String get nicknameSuffix111;

  /// No description provided for @nicknameSuffix112.
  ///
  /// In en, this message translates to:
  /// **'observer'**
  String get nicknameSuffix112;

  /// No description provided for @nicknameSuffix113.
  ///
  /// In en, this message translates to:
  /// **'observer'**
  String get nicknameSuffix113;

  /// No description provided for @nicknameSuffix114.
  ///
  /// In en, this message translates to:
  /// **'recorder'**
  String get nicknameSuffix114;

  /// No description provided for @nicknameSuffix115.
  ///
  /// In en, this message translates to:
  /// **'communicator'**
  String get nicknameSuffix115;

  /// No description provided for @nicknameSuffix116.
  ///
  /// In en, this message translates to:
  /// **'guide'**
  String get nicknameSuffix116;

  /// No description provided for @nicknameSuffix117.
  ///
  /// In en, this message translates to:
  /// **'leader'**
  String get nicknameSuffix117;

  /// No description provided for @nicknameSuffix118.
  ///
  /// In en, this message translates to:
  /// **'saver'**
  String get nicknameSuffix118;

  /// No description provided for @nicknameSuffix119.
  ///
  /// In en, this message translates to:
  /// **'destroyer'**
  String get nicknameSuffix119;

  /// No description provided for @nicknameSuffix120.
  ///
  /// In en, this message translates to:
  /// **'creator'**
  String get nicknameSuffix120;

  /// No description provided for @nicknameSuffix121.
  ///
  /// In en, this message translates to:
  /// **'shade'**
  String get nicknameSuffix121;

  /// No description provided for @nicknameSuffix122.
  ///
  /// In en, this message translates to:
  /// **'ghost'**
  String get nicknameSuffix122;

  /// No description provided for @nicknameSuffix123.
  ///
  /// In en, this message translates to:
  /// **'ghost'**
  String get nicknameSuffix123;

  /// No description provided for @nicknameSuffix124.
  ///
  /// In en, this message translates to:
  /// **'evil spirit'**
  String get nicknameSuffix124;

  /// No description provided for @nicknameSuffix125.
  ///
  /// In en, this message translates to:
  /// **'government ordinance'**
  String get nicknameSuffix125;

  /// No description provided for @nicknameSuffix126.
  ///
  /// In en, this message translates to:
  /// **'fairy'**
  String get nicknameSuffix126;

  /// No description provided for @nicknameSuffix127.
  ///
  /// In en, this message translates to:
  /// **'demon beast'**
  String get nicknameSuffix127;

  /// No description provided for @nicknameSuffix128.
  ///
  /// In en, this message translates to:
  /// **'holy water'**
  String get nicknameSuffix128;

  /// No description provided for @nicknameSuffix129.
  ///
  /// In en, this message translates to:
  /// **'refund'**
  String get nicknameSuffix129;

  /// No description provided for @nicknameSuffix130.
  ///
  /// In en, this message translates to:
  /// **'Shinsu'**
  String get nicknameSuffix130;

  /// No description provided for @nicknameSuffix131.
  ///
  /// In en, this message translates to:
  /// **'test'**
  String get nicknameSuffix131;

  /// No description provided for @nicknameSuffix132.
  ///
  /// In en, this message translates to:
  /// **'article'**
  String get nicknameSuffix132;

  /// No description provided for @nicknameSuffix133.
  ///
  /// In en, this message translates to:
  /// **'Archer'**
  String get nicknameSuffix133;

  /// No description provided for @nicknameSuffix134.
  ///
  /// In en, this message translates to:
  /// **'thief'**
  String get nicknameSuffix134;

  /// No description provided for @nicknameSuffix135.
  ///
  /// In en, this message translates to:
  /// **'assassin'**
  String get nicknameSuffix135;

  /// No description provided for @nicknameSuffix136.
  ///
  /// In en, this message translates to:
  /// **'wizard'**
  String get nicknameSuffix136;

  /// No description provided for @nicknameSuffix137.
  ///
  /// In en, this message translates to:
  /// **'powwow'**
  String get nicknameSuffix137;

  /// No description provided for @nicknameSuffix138.
  ///
  /// In en, this message translates to:
  /// **'alchemist'**
  String get nicknameSuffix138;

  /// No description provided for @nicknameSuffix139.
  ///
  /// In en, this message translates to:
  /// **'necromancer'**
  String get nicknameSuffix139;

  /// No description provided for @nicknameSuffix140.
  ///
  /// In en, this message translates to:
  /// **'priest'**
  String get nicknameSuffix140;

  /// No description provided for @nicknameSuffix141.
  ///
  /// In en, this message translates to:
  /// **'scholar'**
  String get nicknameSuffix141;

  /// No description provided for @nicknameSuffix142.
  ///
  /// In en, this message translates to:
  /// **'researcher'**
  String get nicknameSuffix142;

  /// No description provided for @nicknameSuffix143.
  ///
  /// In en, this message translates to:
  /// **'explorer'**
  String get nicknameSuffix143;

  /// No description provided for @nicknameSuffix144.
  ///
  /// In en, this message translates to:
  /// **'traveler'**
  String get nicknameSuffix144;

  /// No description provided for @nicknameSuffix145.
  ///
  /// In en, this message translates to:
  /// **'artist'**
  String get nicknameSuffix145;

  /// No description provided for @nicknameSuffix146.
  ///
  /// In en, this message translates to:
  /// **'jester'**
  String get nicknameSuffix146;

  /// No description provided for @nicknameSuffix147.
  ///
  /// In en, this message translates to:
  /// **'bard'**
  String get nicknameSuffix147;

  /// No description provided for @nicknameSuffix148.
  ///
  /// In en, this message translates to:
  /// **'merchant'**
  String get nicknameSuffix148;

  /// No description provided for @nicknameSuffix149.
  ///
  /// In en, this message translates to:
  /// **'craftsman'**
  String get nicknameSuffix149;

  /// No description provided for @nicknameSuffix150.
  ///
  /// In en, this message translates to:
  /// **'peasant'**
  String get nicknameSuffix150;

  /// No description provided for @nicknameSuffix151.
  ///
  /// In en, this message translates to:
  /// **'crow'**
  String get nicknameSuffix151;

  /// No description provided for @nicknameSuffix152.
  ///
  /// In en, this message translates to:
  /// **'owl'**
  String get nicknameSuffix152;

  /// No description provided for @nicknameSuffix153.
  ///
  /// In en, this message translates to:
  /// **'owl'**
  String get nicknameSuffix153;

  /// No description provided for @nicknameSuffix154.
  ///
  /// In en, this message translates to:
  /// **'eagle'**
  String get nicknameSuffix154;

  /// No description provided for @nicknameSuffix155.
  ///
  /// In en, this message translates to:
  /// **'hawk'**
  String get nicknameSuffix155;

  /// No description provided for @nicknameSuffix156.
  ///
  /// In en, this message translates to:
  /// **'wolf'**
  String get nicknameSuffix156;

  /// No description provided for @nicknameSuffix157.
  ///
  /// In en, this message translates to:
  /// **'fox'**
  String get nicknameSuffix157;

  /// No description provided for @nicknameSuffix158.
  ///
  /// In en, this message translates to:
  /// **'bear'**
  String get nicknameSuffix158;

  /// No description provided for @nicknameSuffix159.
  ///
  /// In en, this message translates to:
  /// **'lion'**
  String get nicknameSuffix159;

  /// No description provided for @nicknameSuffix160.
  ///
  /// In en, this message translates to:
  /// **'tiger'**
  String get nicknameSuffix160;

  /// No description provided for @nicknameSuffix161.
  ///
  /// In en, this message translates to:
  /// **'leopard'**
  String get nicknameSuffix161;

  /// No description provided for @nicknameSuffix162.
  ///
  /// In en, this message translates to:
  /// **'black panther'**
  String get nicknameSuffix162;

  /// No description provided for @nicknameSuffix163.
  ///
  /// In en, this message translates to:
  /// **'Salsssop'**
  String get nicknameSuffix163;

  /// No description provided for @nicknameSuffix164.
  ///
  /// In en, this message translates to:
  /// **'cat'**
  String get nicknameSuffix164;

  /// No description provided for @nicknameSuffix165.
  ///
  /// In en, this message translates to:
  /// **'puppy'**
  String get nicknameSuffix165;

  /// No description provided for @nicknameSuffix166.
  ///
  /// In en, this message translates to:
  /// **'snake'**
  String get nicknameSuffix166;

  /// No description provided for @nicknameSuffix167.
  ///
  /// In en, this message translates to:
  /// **'lizard'**
  String get nicknameSuffix167;

  /// No description provided for @nicknameSuffix168.
  ///
  /// In en, this message translates to:
  /// **'turtle'**
  String get nicknameSuffix168;

  /// No description provided for @nicknameSuffix169.
  ///
  /// In en, this message translates to:
  /// **'crocodile'**
  String get nicknameSuffix169;

  /// No description provided for @nicknameSuffix170.
  ///
  /// In en, this message translates to:
  /// **'dragon'**
  String get nicknameSuffix170;

  /// No description provided for @nicknameSuffix171.
  ///
  /// In en, this message translates to:
  /// **'unicorn'**
  String get nicknameSuffix171;

  /// No description provided for @nicknameSuffix172.
  ///
  /// In en, this message translates to:
  /// **'Pegasus'**
  String get nicknameSuffix172;

  /// No description provided for @nicknameSuffix173.
  ///
  /// In en, this message translates to:
  /// **'griffon'**
  String get nicknameSuffix173;

  /// No description provided for @nicknameSuffix174.
  ///
  /// In en, this message translates to:
  /// **'gargoyle'**
  String get nicknameSuffix174;

  /// No description provided for @nicknameSuffix175.
  ///
  /// In en, this message translates to:
  /// **'goblin'**
  String get nicknameSuffix175;

  /// No description provided for @nicknameSuffix176.
  ///
  /// In en, this message translates to:
  /// **'oak'**
  String get nicknameSuffix176;

  /// No description provided for @nicknameSuffix177.
  ///
  /// In en, this message translates to:
  /// **'troll'**
  String get nicknameSuffix177;

  /// No description provided for @nicknameSuffix178.
  ///
  /// In en, this message translates to:
  /// **'auger'**
  String get nicknameSuffix178;

  /// No description provided for @nicknameSuffix179.
  ///
  /// In en, this message translates to:
  /// **'slime'**
  String get nicknameSuffix179;

  /// No description provided for @nicknameSuffix180.
  ///
  /// In en, this message translates to:
  /// **'skeleton'**
  String get nicknameSuffix180;

  /// No description provided for @nicknameSuffix181.
  ///
  /// In en, this message translates to:
  /// **'zombi'**
  String get nicknameSuffix181;

  /// No description provided for @nicknameSuffix182.
  ///
  /// In en, this message translates to:
  /// **'ghoul'**
  String get nicknameSuffix182;

  /// No description provided for @nicknameSuffix183.
  ///
  /// In en, this message translates to:
  /// **'vampire'**
  String get nicknameSuffix183;

  /// No description provided for @nicknameSuffix184.
  ///
  /// In en, this message translates to:
  /// **'werewolf'**
  String get nicknameSuffix184;

  /// No description provided for @nicknameSuffix185.
  ///
  /// In en, this message translates to:
  /// **'minotaur'**
  String get nicknameSuffix185;

  /// No description provided for @nicknameSuffix186.
  ///
  /// In en, this message translates to:
  /// **'centaur'**
  String get nicknameSuffix186;

  /// No description provided for @nicknameSuffix187.
  ///
  /// In en, this message translates to:
  /// **'harpy'**
  String get nicknameSuffix187;

  /// No description provided for @nicknameSuffix188.
  ///
  /// In en, this message translates to:
  /// **'siren'**
  String get nicknameSuffix188;

  /// No description provided for @nicknameSuffix189.
  ///
  /// In en, this message translates to:
  /// **'Kraken'**
  String get nicknameSuffix189;

  /// No description provided for @nicknameSuffix190.
  ///
  /// In en, this message translates to:
  /// **'leviathan'**
  String get nicknameSuffix190;

  /// No description provided for @nicknameSuffix191.
  ///
  /// In en, this message translates to:
  /// **'knife'**
  String get nicknameSuffix191;

  /// No description provided for @nicknameSuffix192.
  ///
  /// In en, this message translates to:
  /// **'shield'**
  String get nicknameSuffix192;

  /// No description provided for @nicknameSuffix193.
  ///
  /// In en, this message translates to:
  /// **'window'**
  String get nicknameSuffix193;

  /// No description provided for @nicknameSuffix194.
  ///
  /// In en, this message translates to:
  /// **'bow'**
  String get nicknameSuffix194;

  /// No description provided for @nicknameSuffix195.
  ///
  /// In en, this message translates to:
  /// **'cane'**
  String get nicknameSuffix195;

  /// No description provided for @nicknameSuffix196.
  ///
  /// In en, this message translates to:
  /// **'ring'**
  String get nicknameSuffix196;

  /// No description provided for @nicknameSuffix197.
  ///
  /// In en, this message translates to:
  /// **'necklace'**
  String get nicknameSuffix197;

  /// No description provided for @nicknameSuffix198.
  ///
  /// In en, this message translates to:
  /// **'crown'**
  String get nicknameSuffix198;

  /// No description provided for @nicknameSuffix199.
  ///
  /// In en, this message translates to:
  /// **'Holy Grail'**
  String get nicknameSuffix199;

  /// No description provided for @themeFree.
  ///
  /// In en, this message translates to:
  /// **'Free Skin'**
  String get themeFree;

  /// No description provided for @themePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid Skin'**
  String get themePaid;

  /// No description provided for @diaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No diary entries yet.\nCheck your fortune today and leave a diary!'**
  String get diaryEmpty;

  /// No description provided for @diaryTarotConsult.
  ///
  /// In en, this message translates to:
  /// **'Tarot Consultation'**
  String get diaryTarotConsult;

  /// No description provided for @diaryTarotReading.
  ///
  /// In en, this message translates to:
  /// **'Tarot Reading'**
  String get diaryTarotReading;

  /// No description provided for @diaryAndMore.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String diaryAndMore(int count);

  /// No description provided for @diaryDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String diaryDaysAgo(int days);

  /// No description provided for @diaryHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String diaryHoursAgo(int hours);

  /// No description provided for @diaryMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String diaryMinutesAgo(int minutes);

  /// No description provided for @diaryJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get diaryJustNow;

  /// No description provided for @diaryNoEntryForDate.
  ///
  /// In en, this message translates to:
  /// **'No reading records for this date.'**
  String get diaryNoEntryForDate;

  /// No description provided for @diaryMyQuestion.
  ///
  /// In en, this message translates to:
  /// **'My Question'**
  String get diaryMyQuestion;

  /// No description provided for @diaryWitchReading.
  ///
  /// In en, this message translates to:
  /// **'\'s Tarot Reading'**
  String get diaryWitchReading;

  /// No description provided for @diaryNoResult.
  ///
  /// In en, this message translates to:
  /// **'No results available.'**
  String get diaryNoResult;

  /// No description provided for @diaryFollowUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Note'**
  String get diaryFollowUpTitle;

  /// No description provided for @diaryFollowUpHint.
  ///
  /// In en, this message translates to:
  /// **'Record whether the reading was accurate a few days later.'**
  String get diaryFollowUpHint;

  /// No description provided for @diaryFollowUpPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'How did the reading turn out?'**
  String get diaryFollowUpPlaceholder;

  /// No description provided for @diaryFollowUpSave.
  ///
  /// In en, this message translates to:
  /// **'Save Follow-up'**
  String get diaryFollowUpSave;

  /// No description provided for @diaryFollowUpSaved.
  ///
  /// In en, this message translates to:
  /// **'Follow-up saved!'**
  String get diaryFollowUpSaved;

  /// No description provided for @diaryFollowUpEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Follow-up'**
  String get diaryFollowUpEdit;

  /// No description provided for @diaryTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get diaryTagTitle;

  /// No description provided for @diaryTagAddHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new tag'**
  String get diaryTagAddHint;

  /// No description provided for @diaryTagDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this tag?'**
  String get diaryTagDeleteConfirm;

  /// No description provided for @diaryTagDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get diaryTagDelete;

  /// No description provided for @diaryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Diary'**
  String get diaryDeleteTitle;

  /// No description provided for @diaryDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this diary entry? This cannot be undone.'**
  String get diaryDeleteConfirm;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communityErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading data.\n'**
  String get communityErrorLoading;

  /// No description provided for @communityEmptyFeed.
  ///
  /// In en, this message translates to:
  /// **'No public tarot diaries yet.\nBe the first to share your diary!'**
  String get communityEmptyFeed;

  /// No description provided for @communityNoInterpretation.
  ///
  /// In en, this message translates to:
  /// **'No interpretation.'**
  String get communityNoInterpretation;

  /// No description provided for @communityLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get communityLike;

  /// No description provided for @communityComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get communityComments;

  /// No description provided for @communityFirstCommentPrompt.
  ///
  /// In en, this message translates to:
  /// **'Be the first to leave a comment!'**
  String get communityFirstCommentPrompt;

  /// No description provided for @communityCommentInputHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get communityCommentInputHint;

  /// No description provided for @communityCommentFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add comment: '**
  String get communityCommentFailed;

  /// No description provided for @communityLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required.'**
  String get communityLoginRequired;

  /// No description provided for @communityReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get communityReportTitle;

  /// No description provided for @communityReportHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for reporting'**
  String get communityReportHint;

  /// No description provided for @communityReportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get communityReportCancel;

  /// No description provided for @communityReportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get communityReportSubmit;

  /// No description provided for @communityReportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report has been submitted.'**
  String get communityReportSuccess;

  /// No description provided for @communityTarotQuestion.
  ///
  /// In en, this message translates to:
  /// **'Q. Tarot Question'**
  String get communityTarotQuestion;

  /// No description provided for @communityNoName.
  ///
  /// In en, this message translates to:
  /// **'Nameless Witch'**
  String get communityNoName;

  /// No description provided for @diaryShareToCommunity.
  ///
  /// In en, this message translates to:
  /// **'Share to Community'**
  String get diaryShareToCommunity;

  /// No description provided for @diarySharedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Shared to the community.'**
  String get diarySharedSuccess;

  /// No description provided for @diaryPrivateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Set to private.'**
  String get diaryPrivateSuccess;

  /// No description provided for @growthTitle.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get growthTitle;

  /// No description provided for @growthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gather magic power to strengthen tarot cards'**
  String get growthSubtitle;

  /// No description provided for @growthTabCrystalBall.
  ///
  /// In en, this message translates to:
  /// **'Crystal Ball Upgrade'**
  String get growthTabCrystalBall;

  /// No description provided for @growthTabWorldTree.
  ///
  /// In en, this message translates to:
  /// **'Grow World Tree'**
  String get growthTabWorldTree;

  /// No description provided for @growthWorldTreeLevel.
  ///
  /// In en, this message translates to:
  /// **'World Tree Level {level}'**
  String growthWorldTreeLevel(int level);

  /// No description provided for @growthExp.
  ///
  /// In en, this message translates to:
  /// **'Exp: '**
  String get growthExp;

  /// No description provided for @growthWaterFree.
  ///
  /// In en, this message translates to:
  /// **'Water for Free'**
  String get growthWaterFree;

  /// No description provided for @growthWaterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Watered the World Tree! Exp +10 💧'**
  String get growthWaterSuccess;

  /// No description provided for @growthDustOwned.
  ///
  /// In en, this message translates to:
  /// **'Magic Dust Used: {dust}'**
  String growthDustOwned(int dust);

  /// No description provided for @growthCrystalBallLevel.
  ///
  /// In en, this message translates to:
  /// **'Mystic Crystal Ball Level {level}'**
  String growthCrystalBallLevel(int level);

  /// No description provided for @growthUpgradeButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade (10 Dust)'**
  String get growthUpgradeButton;

  /// No description provided for @growthUpgradeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Crystal Ball Upgrade Successful! ✨'**
  String get growthUpgradeSuccess;

  /// No description provided for @growthUpgradeNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough magic dust. (Need: 10)'**
  String get growthUpgradeNotEnough;

  /// No description provided for @diaryViewList.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get diaryViewList;

  /// No description provided for @diaryViewCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar View'**
  String get diaryViewCalendar;

  /// No description provided for @tarotMajor00Name.
  ///
  /// In en, this message translates to:
  /// **'The Fool'**
  String get tarotMajor00Name;

  /// No description provided for @tarotMajor00Upright.
  ///
  /// In en, this message translates to:
  /// **'New beginnings, adventure, infinite possibilities, freedom, innocence'**
  String get tarotMajor00Upright;

  /// No description provided for @tarotMajor00Reversed.
  ///
  /// In en, this message translates to:
  /// **'Recklessness, foolishness, carelessness, taking too great a risk, impracticality.'**
  String get tarotMajor00Reversed;

  /// No description provided for @tarotMajor01Name.
  ///
  /// In en, this message translates to:
  /// **'The Magician'**
  String get tarotMajor01Name;

  /// No description provided for @tarotMajor01Upright.
  ///
  /// In en, this message translates to:
  /// **'Creativity, will, ability, power of new beginnings, determination'**
  String get tarotMajor01Upright;

  /// No description provided for @tarotMajor01Reversed.
  ///
  /// In en, this message translates to:
  /// **'Manipulation, wasted talent, deception, lack of confidence, hidden agendas.'**
  String get tarotMajor01Reversed;

  /// No description provided for @tarotMajor02Name.
  ///
  /// In en, this message translates to:
  /// **'The High Priestess'**
  String get tarotMajor02Name;

  /// No description provided for @tarotMajor02Upright.
  ///
  /// In en, this message translates to:
  /// **'Intuition, unconsciousness, mystery, wisdom, inner voice'**
  String get tarotMajor02Upright;

  /// No description provided for @tarotMajor02Reversed.
  ///
  /// In en, this message translates to:
  /// **'Ignoring intuition, shallow knowledge, hidden enemies, leaking secrets'**
  String get tarotMajor02Reversed;

  /// No description provided for @tarotMajor03Name.
  ///
  /// In en, this message translates to:
  /// **'The Empress'**
  String get tarotMajor03Name;

  /// No description provided for @tarotMajor03Upright.
  ///
  /// In en, this message translates to:
  /// **'Abundance, maternal love, beauty, natural fruition, creativity'**
  String get tarotMajor03Upright;

  /// No description provided for @tarotMajor03Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overprotection, dependence, creative deficiency, laziness, stagnation'**
  String get tarotMajor03Reversed;

  /// No description provided for @tarotMajor04Name.
  ///
  /// In en, this message translates to:
  /// **'The Emperor'**
  String get tarotMajor04Name;

  /// No description provided for @tarotMajor04Upright.
  ///
  /// In en, this message translates to:
  /// **'Authority, structure, stability, paternal love, control, responsibility'**
  String get tarotMajor04Upright;

  /// No description provided for @tarotMajor04Reversed.
  ///
  /// In en, this message translates to:
  /// **'Dictatorship, desire to dominate, lack of flexibility, incompetence, oppression'**
  String get tarotMajor04Reversed;

  /// No description provided for @tarotMajor05Name.
  ///
  /// In en, this message translates to:
  /// **'The Hierophant'**
  String get tarotMajor05Name;

  /// No description provided for @tarotMajor05Upright.
  ///
  /// In en, this message translates to:
  /// **'Tradition, faith, education, spiritual guidance, conservatism'**
  String get tarotMajor05Upright;

  /// No description provided for @tarotMajor05Reversed.
  ///
  /// In en, this message translates to:
  /// **'Rebellion, breaking convention, dogmatism, old ideas, bad advice.'**
  String get tarotMajor05Reversed;

  /// No description provided for @tarotMajor06Name.
  ///
  /// In en, this message translates to:
  /// **'The Lovers'**
  String get tarotMajor06Name;

  /// No description provided for @tarotMajor06Upright.
  ///
  /// In en, this message translates to:
  /// **'Love, harmony, relationships, important choices, trust'**
  String get tarotMajor06Upright;

  /// No description provided for @tarotMajor06Reversed.
  ///
  /// In en, this message translates to:
  /// **'Discord, bad choices, loss of trust, temptation, imbalance.'**
  String get tarotMajor06Reversed;

  /// No description provided for @tarotMajor07Name.
  ///
  /// In en, this message translates to:
  /// **'The Chariot'**
  String get tarotMajor07Name;

  /// No description provided for @tarotMajor07Upright.
  ///
  /// In en, this message translates to:
  /// **'Will, victory, determination, direction, drive toward success'**
  String get tarotMajor07Upright;

  /// No description provided for @tarotMajor07Reversed.
  ///
  /// In en, this message translates to:
  /// **'Loss of control, disorientation, helplessness, aggression, obstacles'**
  String get tarotMajor07Reversed;

  /// No description provided for @tarotMajor08Name.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get tarotMajor08Name;

  /// No description provided for @tarotMajor08Upright.
  ///
  /// In en, this message translates to:
  /// **'Courage, perseverance, inner strength, gentle control, mercy.'**
  String get tarotMajor08Upright;

  /// No description provided for @tarotMajor08Reversed.
  ///
  /// In en, this message translates to:
  /// **'Fear, weakness, loss of self-control, impulsiveness, pride.'**
  String get tarotMajor08Reversed;

  /// No description provided for @tarotMajor09Name.
  ///
  /// In en, this message translates to:
  /// **'The Hermit'**
  String get tarotMajor09Name;

  /// No description provided for @tarotMajor09Upright.
  ///
  /// In en, this message translates to:
  /// **'Inner exploration, wisdom, solitude, enlightenment, spiritual advisor'**
  String get tarotMajor09Upright;

  /// No description provided for @tarotMajor09Reversed.
  ///
  /// In en, this message translates to:
  /// **'Isolation, loneliness, escapism, foolish stubbornness, seclusion'**
  String get tarotMajor09Reversed;

  /// No description provided for @tarotMajor10Name.
  ///
  /// In en, this message translates to:
  /// **'Wheel of Fortune'**
  String get tarotMajor10Name;

  /// No description provided for @tarotMajor10Upright.
  ///
  /// In en, this message translates to:
  /// **'Turning point, destiny, luck, constant change, opportunity'**
  String get tarotMajor10Upright;

  /// No description provided for @tarotMajor10Reversed.
  ///
  /// In en, this message translates to:
  /// **'Misfortune, resistance, uncontrollable change, repetition of misfortune'**
  String get tarotMajor10Reversed;

  /// No description provided for @tarotMajor11Name.
  ///
  /// In en, this message translates to:
  /// **'Justice'**
  String get tarotMajor11Name;

  /// No description provided for @tarotMajor11Upright.
  ///
  /// In en, this message translates to:
  /// **'Fairness, truth, retribution, balance, rational decision'**
  String get tarotMajor11Upright;

  /// No description provided for @tarotMajor11Reversed.
  ///
  /// In en, this message translates to:
  /// **'unfairness, prejudice, dishonesty, inevitable punishment, imbalance'**
  String get tarotMajor11Reversed;

  /// No description provided for @tarotMajor12Name.
  ///
  /// In en, this message translates to:
  /// **'The Hanged Man'**
  String get tarotMajor12Name;

  /// No description provided for @tarotMajor12Upright.
  ///
  /// In en, this message translates to:
  /// **'Sacrifice, new perspective, waiting, insight, temporary pause.'**
  String get tarotMajor12Upright;

  /// No description provided for @tarotMajor12Reversed.
  ///
  /// In en, this message translates to:
  /// **'Pointless sacrifice, delay, refusal to progress, selfishness'**
  String get tarotMajor12Reversed;

  /// No description provided for @tarotMajor13Name.
  ///
  /// In en, this message translates to:
  /// **'Death'**
  String get tarotMajor13Name;

  /// No description provided for @tarotMajor13Upright.
  ///
  /// In en, this message translates to:
  /// **'End and new beginning, change, transition, clearing up the past'**
  String get tarotMajor13Upright;

  /// No description provided for @tarotMajor13Reversed.
  ///
  /// In en, this message translates to:
  /// **'Resistance to change, stagnation, obsession with the old, fear'**
  String get tarotMajor13Reversed;

  /// No description provided for @tarotMajor14Name.
  ///
  /// In en, this message translates to:
  /// **'Temperance'**
  String get tarotMajor14Name;

  /// No description provided for @tarotMajor14Upright.
  ///
  /// In en, this message translates to:
  /// **'Harmony, balance, moderation, healing, purposefulness'**
  String get tarotMajor14Upright;

  /// No description provided for @tarotMajor14Reversed.
  ///
  /// In en, this message translates to:
  /// **'Imbalance, intemperance, extreme behavior, disharmony, conflict'**
  String get tarotMajor14Reversed;

  /// No description provided for @tarotMajor15Name.
  ///
  /// In en, this message translates to:
  /// **'The Devil'**
  String get tarotMajor15Name;

  /// No description provided for @tarotMajor15Upright.
  ///
  /// In en, this message translates to:
  /// **'Obsession, materialism, bondage, temptation, destructive desires.'**
  String get tarotMajor15Upright;

  /// No description provided for @tarotMajor15Reversed.
  ///
  /// In en, this message translates to:
  /// **'Liberation, freedom from bondage, independence, enlightenment, freedom'**
  String get tarotMajor15Reversed;

  /// No description provided for @tarotMajor16Name.
  ///
  /// In en, this message translates to:
  /// **'The Tower'**
  String get tarotMajor16Name;

  /// No description provided for @tarotMajor16Upright.
  ///
  /// In en, this message translates to:
  /// **'sudden change, destruction, liberation, revelation, collapse'**
  String get tarotMajor16Upright;

  /// No description provided for @tarotMajor16Reversed.
  ///
  /// In en, this message translates to:
  /// **'Avoiding disaster, delaying inevitable change, ignoring warnings'**
  String get tarotMajor16Reversed;

  /// No description provided for @tarotMajor17Name.
  ///
  /// In en, this message translates to:
  /// **'The Star'**
  String get tarotMajor17Name;

  /// No description provided for @tarotMajor17Upright.
  ///
  /// In en, this message translates to:
  /// **'Hope, Inspiration, Serenity, Healing and Affirmation, Spiritual Guidance'**
  String get tarotMajor17Upright;

  /// No description provided for @tarotMajor17Reversed.
  ///
  /// In en, this message translates to:
  /// **'Despair, disappointment, lack of inspiration, pessimism, confusion'**
  String get tarotMajor17Reversed;

  /// No description provided for @tarotMajor18Name.
  ///
  /// In en, this message translates to:
  /// **'The Moon'**
  String get tarotMajor18Name;

  /// No description provided for @tarotMajor18Upright.
  ///
  /// In en, this message translates to:
  /// **'Anxiety, illusion, intuition, hidden truth, deception'**
  String get tarotMajor18Upright;

  /// No description provided for @tarotMajor18Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overcoming fear, discovering secrets, relieving anxiety, uncovering the truth'**
  String get tarotMajor18Reversed;

  /// No description provided for @tarotMajor19Name.
  ///
  /// In en, this message translates to:
  /// **'The Sun'**
  String get tarotMajor19Name;

  /// No description provided for @tarotMajor19Upright.
  ///
  /// In en, this message translates to:
  /// **'Success, positivity, vitality, happiness and achievement, joy'**
  String get tarotMajor19Upright;

  /// No description provided for @tarotMajor19Reversed.
  ///
  /// In en, this message translates to:
  /// **'The other side of delayed success, exaggeration, lack of energy, and sadness.'**
  String get tarotMajor19Reversed;

  /// No description provided for @tarotMajor20Name.
  ///
  /// In en, this message translates to:
  /// **'Judgement'**
  String get tarotMajor20Name;

  /// No description provided for @tarotMajor20Upright.
  ///
  /// In en, this message translates to:
  /// **'Resurrection, determination, forgiveness, new calling, inner awakening'**
  String get tarotMajor20Upright;

  /// No description provided for @tarotMajor20Reversed.
  ///
  /// In en, this message translates to:
  /// **'Regret, self-doubt, fear of change, regret, punishment'**
  String get tarotMajor20Reversed;

  /// No description provided for @tarotMajor21Name.
  ///
  /// In en, this message translates to:
  /// **'The World'**
  String get tarotMajor21Name;

  /// No description provided for @tarotMajor21Upright.
  ///
  /// In en, this message translates to:
  /// **'completion, achievement, integration, new level, successful finish'**
  String get tarotMajor21Upright;

  /// No description provided for @tarotMajor21Reversed.
  ///
  /// In en, this message translates to:
  /// **'Incompleteness, postponement, stagnation, fear of success, procrastination.'**
  String get tarotMajor21Reversed;

  /// No description provided for @tarotCups01Name.
  ///
  /// In en, this message translates to:
  /// **'Ace of Cups'**
  String get tarotCups01Name;

  /// No description provided for @tarotCups01Upright.
  ///
  /// In en, this message translates to:
  /// **'New emotions, beginnings of love, intuition, spiritual fulfillment'**
  String get tarotCups01Upright;

  /// No description provided for @tarotCups01Reversed.
  ///
  /// In en, this message translates to:
  /// **'Blocked emotions, feeling unloved, feeling empty, sad.'**
  String get tarotCups01Reversed;

  /// No description provided for @tarotCups02Name.
  ///
  /// In en, this message translates to:
  /// **'Two of Cups'**
  String get tarotCups02Name;

  /// No description provided for @tarotCups02Upright.
  ///
  /// In en, this message translates to:
  /// **'Harmony in relationships, union, love, mutual respect, cooperation'**
  String get tarotCups02Upright;

  /// No description provided for @tarotCups02Reversed.
  ///
  /// In en, this message translates to:
  /// **'Relationship discord, separation, misunderstanding, imbalance, unrequited love'**
  String get tarotCups02Reversed;

  /// No description provided for @tarotCups03Name.
  ///
  /// In en, this message translates to:
  /// **'Three of Cups'**
  String get tarotCups03Name;

  /// No description provided for @tarotCups03Upright.
  ///
  /// In en, this message translates to:
  /// **'Celebration, friendship, community, joy, creative fruition.'**
  String get tarotCups03Upright;

  /// No description provided for @tarotCups03Reversed.
  ///
  /// In en, this message translates to:
  /// **'Excessive drinking, alienation, cliques, love triangles, cancellation of festivals.'**
  String get tarotCups03Reversed;

  /// No description provided for @tarotCups04Name.
  ///
  /// In en, this message translates to:
  /// **'Four of Cups'**
  String get tarotCups04Name;

  /// No description provided for @tarotCups04Upright.
  ///
  /// In en, this message translates to:
  /// **'Apathy, boredom, meditation, missed opportunities, inner reflection.'**
  String get tarotCups04Upright;

  /// No description provided for @tarotCups04Reversed.
  ///
  /// In en, this message translates to:
  /// **'New awareness, seizing opportunities, revitalization, awakening'**
  String get tarotCups04Reversed;

  /// No description provided for @tarotCups05Name.
  ///
  /// In en, this message translates to:
  /// **'Five of Cups'**
  String get tarotCups05Name;

  /// No description provided for @tarotCups05Upright.
  ///
  /// In en, this message translates to:
  /// **'Loss, sadness, regret about the past, pessimism'**
  String get tarotCups05Upright;

  /// No description provided for @tarotCups05Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overcoming loss, acceptance, healing, and finding new hope'**
  String get tarotCups05Reversed;

  /// No description provided for @tarotCups06Name.
  ///
  /// In en, this message translates to:
  /// **'Six of Cups'**
  String get tarotCups06Name;

  /// No description provided for @tarotCups06Upright.
  ///
  /// In en, this message translates to:
  /// **'Nostalgia of the past, childhood, innocence, old friends, memories'**
  String get tarotCups06Upright;

  /// No description provided for @tarotCups06Reversed.
  ///
  /// In en, this message translates to:
  /// **'Stuck in the past, ignoring the future, independence, growth'**
  String get tarotCups06Reversed;

  /// No description provided for @tarotCups07Name.
  ///
  /// In en, this message translates to:
  /// **'Seven of Cups'**
  String get tarotCups07Name;

  /// No description provided for @tarotCups07Upright.
  ///
  /// In en, this message translates to:
  /// **'Fantasy, dream, confusion of choice, escapism, daydream'**
  String get tarotCups07Upright;

  /// No description provided for @tarotCups07Reversed.
  ///
  /// In en, this message translates to:
  /// **'Facing reality, clear goals, waking up from illusions, determination'**
  String get tarotCups07Reversed;

  /// No description provided for @tarotCups08Name.
  ///
  /// In en, this message translates to:
  /// **'Eight of Cups'**
  String get tarotCups08Name;

  /// No description provided for @tarotCups08Upright.
  ///
  /// In en, this message translates to:
  /// **'Disappointment, leaving, giving up and resignation in search of deeper meaning.'**
  String get tarotCups08Upright;

  /// No description provided for @tarotCups08Reversed.
  ///
  /// In en, this message translates to:
  /// **'Unable to leave, clinging to the past, restoring relationships, fear'**
  String get tarotCups08Reversed;

  /// No description provided for @tarotCups09Name.
  ///
  /// In en, this message translates to:
  /// **'Nine of Cups'**
  String get tarotCups09Name;

  /// No description provided for @tarotCups09Upright.
  ///
  /// In en, this message translates to:
  /// **'Wish fulfillment, satisfaction, sensual pleasure, self-esteem, happiness'**
  String get tarotCups09Upright;

  /// No description provided for @tarotCups09Reversed.
  ///
  /// In en, this message translates to:
  /// **'Dissatisfaction, vanity, superficial success, greed, greed.'**
  String get tarotCups09Reversed;

  /// No description provided for @tarotCups10Name.
  ///
  /// In en, this message translates to:
  /// **'Ten of Cups'**
  String get tarotCups10Name;

  /// No description provided for @tarotCups10Upright.
  ///
  /// In en, this message translates to:
  /// **'Family happiness, peace, emotional fulfillment, harmonious relationships'**
  String get tarotCups10Upright;

  /// No description provided for @tarotCups10Reversed.
  ///
  /// In en, this message translates to:
  /// **'Conflict within the family, broken home, discord, loss of peace'**
  String get tarotCups10Reversed;

  /// No description provided for @tarotCups11Name.
  ///
  /// In en, this message translates to:
  /// **'Page of Cups'**
  String get tarotCups11Name;

  /// No description provided for @tarotCups11Upright.
  ///
  /// In en, this message translates to:
  /// **'New inspiration, creativity, emotional message, intuition'**
  String get tarotCups11Upright;

  /// No description provided for @tarotCups11Reversed.
  ///
  /// In en, this message translates to:
  /// **'Emotional immaturity, creative block, bad news, irritability.'**
  String get tarotCups11Reversed;

  /// No description provided for @tarotCups12Name.
  ///
  /// In en, this message translates to:
  /// **'Knight of Cups'**
  String get tarotCups12Name;

  /// No description provided for @tarotCups12Upright.
  ///
  /// In en, this message translates to:
  /// **'Romance, charm, emotional access, imagination, chivalry'**
  String get tarotCups12Upright;

  /// No description provided for @tarotCups12Reversed.
  ///
  /// In en, this message translates to:
  /// **'unreality, fickleness, jealousy, unreliability, deceit'**
  String get tarotCups12Reversed;

  /// No description provided for @tarotCups13Name.
  ///
  /// In en, this message translates to:
  /// **'Queen of Cups'**
  String get tarotCups13Name;

  /// No description provided for @tarotCups13Upright.
  ///
  /// In en, this message translates to:
  /// **'Empathy, kindness, spiritual intuition, emotional stability, consideration'**
  String get tarotCups13Upright;

  /// No description provided for @tarotCups13Reversed.
  ///
  /// In en, this message translates to:
  /// **'Hyperemotionality, instability, dependence, victim cosplay'**
  String get tarotCups13Reversed;

  /// No description provided for @tarotCups14Name.
  ///
  /// In en, this message translates to:
  /// **'King of Cups'**
  String get tarotCups14Name;

  /// No description provided for @tarotCups14Upright.
  ///
  /// In en, this message translates to:
  /// **'Emotional control, balance, diplomacy, tolerance, wise counsel.'**
  String get tarotCups14Upright;

  /// No description provided for @tarotCups14Reversed.
  ///
  /// In en, this message translates to:
  /// **'Emotionally manipulative, callous, unstable, moody, ruthless.'**
  String get tarotCups14Reversed;

  /// No description provided for @tarotPentacles01Name.
  ///
  /// In en, this message translates to:
  /// **'Ace of Pentacles'**
  String get tarotPentacles01Name;

  /// No description provided for @tarotPentacles01Upright.
  ///
  /// In en, this message translates to:
  /// **'New opportunities, financial beginnings, abundance, realistic achievements.'**
  String get tarotPentacles01Upright;

  /// No description provided for @tarotPentacles01Reversed.
  ///
  /// In en, this message translates to:
  /// **'Lost opportunities, financial losses, delays, bad investments.'**
  String get tarotPentacles01Reversed;

  /// No description provided for @tarotPentacles02Name.
  ///
  /// In en, this message translates to:
  /// **'Two of Pentacles'**
  String get tarotPentacles02Name;

  /// No description provided for @tarotPentacles02Upright.
  ///
  /// In en, this message translates to:
  /// **'Balance, adaptability, time/financial management, flexibility'**
  String get tarotPentacles02Upright;

  /// No description provided for @tarotPentacles02Reversed.
  ///
  /// In en, this message translates to:
  /// **'Imbalance, overwhelming, financial difficulties, stress'**
  String get tarotPentacles02Reversed;

  /// No description provided for @tarotPentacles03Name.
  ///
  /// In en, this message translates to:
  /// **'Three of Pentacles'**
  String get tarotPentacles03Name;

  /// No description provided for @tarotPentacles03Upright.
  ///
  /// In en, this message translates to:
  /// **'Teamwork, collaboration, technology, recognized effort, architecture'**
  String get tarotPentacles03Upright;

  /// No description provided for @tarotPentacles03Reversed.
  ///
  /// In en, this message translates to:
  /// **'Lack of collaboration, lack of skills, lack of recognition, conflict of opinions.'**
  String get tarotPentacles03Reversed;

  /// No description provided for @tarotPentacles04Name.
  ///
  /// In en, this message translates to:
  /// **'Four of Pentacles'**
  String get tarotPentacles04Name;

  /// No description provided for @tarotPentacles04Upright.
  ///
  /// In en, this message translates to:
  /// **'Stability, possessiveness, conservatism, stinginess, accumulation'**
  String get tarotPentacles04Upright;

  /// No description provided for @tarotPentacles04Reversed.
  ///
  /// In en, this message translates to:
  /// **'Let go of the price of greed, loss, financial neglect, and obsession.'**
  String get tarotPentacles04Reversed;

  /// No description provided for @tarotPentacles05Name.
  ///
  /// In en, this message translates to:
  /// **'Five of Pentacles'**
  String get tarotPentacles05Name;

  /// No description provided for @tarotPentacles05Upright.
  ///
  /// In en, this message translates to:
  /// **'Deprivation, financial/emotional deprivation, alienation, adversity'**
  String get tarotPentacles05Upright;

  /// No description provided for @tarotPentacles05Reversed.
  ///
  /// In en, this message translates to:
  /// **'Financial recovery, a helping hand, overcoming adversity, positive change.'**
  String get tarotPentacles05Reversed;

  /// No description provided for @tarotPentacles06Name.
  ///
  /// In en, this message translates to:
  /// **'Six of Pentacles'**
  String get tarotPentacles06Name;

  /// No description provided for @tarotPentacles06Upright.
  ///
  /// In en, this message translates to:
  /// **'Charity, sharing, sponsorship, fairness, giving and receiving'**
  String get tarotPentacles06Upright;

  /// No description provided for @tarotPentacles06Reversed.
  ///
  /// In en, this message translates to:
  /// **'Selfishness, debt, inequality, condescension, exploitation'**
  String get tarotPentacles06Reversed;

  /// No description provided for @tarotPentacles07Name.
  ///
  /// In en, this message translates to:
  /// **'Seven of Pentacles'**
  String get tarotPentacles07Name;

  /// No description provided for @tarotPentacles07Upright.
  ///
  /// In en, this message translates to:
  /// **'Patience, long-term vision, waiting for rewards for effort, evaluation'**
  String get tarotPentacles07Upright;

  /// No description provided for @tarotPentacles07Reversed.
  ///
  /// In en, this message translates to:
  /// **'Impatience, fruitless efforts, delays, frustration, and failed investments.'**
  String get tarotPentacles07Reversed;

  /// No description provided for @tarotPentacles08Name.
  ///
  /// In en, this message translates to:
  /// **'Eight of Pentacles'**
  String get tarotPentacles08Name;

  /// No description provided for @tarotPentacles08Upright.
  ///
  /// In en, this message translates to:
  /// **'Craftsmanship, commitment, attention to detail, skill.'**
  String get tarotPentacles08Upright;

  /// No description provided for @tarotPentacles08Reversed.
  ///
  /// In en, this message translates to:
  /// **'Boredom, the perfectionism trap, laziness, loss of passion.'**
  String get tarotPentacles08Reversed;

  /// No description provided for @tarotPentacles09Name.
  ///
  /// In en, this message translates to:
  /// **'Nine of Pentacles'**
  String get tarotPentacles09Name;

  /// No description provided for @tarotPentacles09Upright.
  ///
  /// In en, this message translates to:
  /// **'Achievement, independence, leisure, financial comfort, self-reward'**
  String get tarotPentacles09Upright;

  /// No description provided for @tarotPentacles09Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overspending, superficial extravagance, dependency, financial insecurity'**
  String get tarotPentacles09Reversed;

  /// No description provided for @tarotPentacles10Name.
  ///
  /// In en, this message translates to:
  /// **'Ten of Pentacles'**
  String get tarotPentacles10Name;

  /// No description provided for @tarotPentacles10Upright.
  ///
  /// In en, this message translates to:
  /// **'Family business, accumulation of wealth, legacy, stable life, tradition'**
  String get tarotPentacles10Upright;

  /// No description provided for @tarotPentacles10Reversed.
  ///
  /// In en, this message translates to:
  /// **'Loss of property, family strife, rebellion against tradition, instability.'**
  String get tarotPentacles10Reversed;

  /// No description provided for @tarotPentacles11Name.
  ///
  /// In en, this message translates to:
  /// **'Page of Pentacles'**
  String get tarotPentacles11Name;

  /// No description provided for @tarotPentacles11Upright.
  ///
  /// In en, this message translates to:
  /// **'Realistic goals, new studies, opportunities, practicality, planning'**
  String get tarotPentacles11Upright;

  /// No description provided for @tarotPentacles11Reversed.
  ///
  /// In en, this message translates to:
  /// **'Delay in planning, lack of practicality, laziness, procrastination.'**
  String get tarotPentacles11Reversed;

  /// No description provided for @tarotPentacles12Name.
  ///
  /// In en, this message translates to:
  /// **'Knight of Pentacles'**
  String get tarotPentacles12Name;

  /// No description provided for @tarotPentacles12Upright.
  ///
  /// In en, this message translates to:
  /// **'Sincerity, responsibility, persistence, gradual development, reliability'**
  String get tarotPentacles12Upright;

  /// No description provided for @tarotPentacles12Reversed.
  ///
  /// In en, this message translates to:
  /// **'Stubbornness, lethargy, workaholism, lack of flexibility, stagnation'**
  String get tarotPentacles12Reversed;

  /// No description provided for @tarotPentacles13Name.
  ///
  /// In en, this message translates to:
  /// **'Queen of Pentacles'**
  String get tarotPentacles13Name;

  /// No description provided for @tarotPentacles13Upright.
  ///
  /// In en, this message translates to:
  /// **'Practical care, practical advice, abundance, generosity, comfort.'**
  String get tarotPentacles13Upright;

  /// No description provided for @tarotPentacles13Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overcontrol, possessiveness, selfishness, financial insecurity, overspending.'**
  String get tarotPentacles13Reversed;

  /// No description provided for @tarotPentacles14Name.
  ///
  /// In en, this message translates to:
  /// **'King of Pentacles'**
  String get tarotPentacles14Name;

  /// No description provided for @tarotPentacles14Upright.
  ///
  /// In en, this message translates to:
  /// **'Wealth, success, business acumen, authority, and strong supporter.'**
  String get tarotPentacles14Upright;

  /// No description provided for @tarotPentacles14Reversed.
  ///
  /// In en, this message translates to:
  /// **'Materialism, corruption, greed, stubbornness, oppressive authority'**
  String get tarotPentacles14Reversed;

  /// No description provided for @tarotSwords01Name.
  ///
  /// In en, this message translates to:
  /// **'Ace of Swords'**
  String get tarotSwords01Name;

  /// No description provided for @tarotSwords01Upright.
  ///
  /// In en, this message translates to:
  /// **'Clear insight, new thoughts, truth, spiritual breakthrough'**
  String get tarotSwords01Upright;

  /// No description provided for @tarotSwords01Reversed.
  ///
  /// In en, this message translates to:
  /// **'Confusion, misinformation, loss of judgment, lack of communication'**
  String get tarotSwords01Reversed;

  /// No description provided for @tarotSwords02Name.
  ///
  /// In en, this message translates to:
  /// **'Two of Swords'**
  String get tarotSwords02Name;

  /// No description provided for @tarotSwords02Upright.
  ///
  /// In en, this message translates to:
  /// **'Indecisiveness, blindness, blocking emotions, avoidance of difficult decisions.'**
  String get tarotSwords02Upright;

  /// No description provided for @tarotSwords02Reversed.
  ///
  /// In en, this message translates to:
  /// **'Making decisions, facing facts, making mistakes due to lack of information'**
  String get tarotSwords02Reversed;

  /// No description provided for @tarotSwords03Name.
  ///
  /// In en, this message translates to:
  /// **'Three of Swords'**
  String get tarotSwords03Name;

  /// No description provided for @tarotSwords03Upright.
  ///
  /// In en, this message translates to:
  /// **'Heartache, sadness, separation, hurt, painful truth.'**
  String get tarotSwords03Upright;

  /// No description provided for @tarotSwords03Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overcoming pain, healing, forgiveness, letting go of sadness'**
  String get tarotSwords03Reversed;

  /// No description provided for @tarotSwords04Name.
  ///
  /// In en, this message translates to:
  /// **'Four of Swords'**
  String get tarotSwords04Name;

  /// No description provided for @tarotSwords04Upright.
  ///
  /// In en, this message translates to:
  /// **'Relaxation, recovery, meditation, stress relief, inner peace'**
  String get tarotSwords04Upright;

  /// No description provided for @tarotSwords04Reversed.
  ///
  /// In en, this message translates to:
  /// **'Exhaustion, refusal to recover, forced rest, extreme stress.'**
  String get tarotSwords04Reversed;

  /// No description provided for @tarotSwords05Name.
  ///
  /// In en, this message translates to:
  /// **'Five of Swords'**
  String get tarotSwords05Name;

  /// No description provided for @tarotSwords05Upright.
  ///
  /// In en, this message translates to:
  /// **'Victory that only hurts, betrayal, conflict, hostility, and meanness.'**
  String get tarotSwords05Upright;

  /// No description provided for @tarotSwords05Reversed.
  ///
  /// In en, this message translates to:
  /// **'Conflict resolution, reconciliation, compromise, admitting defeat, giving up revenge'**
  String get tarotSwords05Reversed;

  /// No description provided for @tarotSwords06Name.
  ///
  /// In en, this message translates to:
  /// **'Six of Swords'**
  String get tarotSwords06Name;

  /// No description provided for @tarotSwords06Upright.
  ///
  /// In en, this message translates to:
  /// **'Transition, release from pain, healing journey, movement, travel'**
  String get tarotSwords06Upright;

  /// No description provided for @tarotSwords06Reversed.
  ///
  /// In en, this message translates to:
  /// **'Resistance to change, past hurts holding you back, procrastination'**
  String get tarotSwords06Reversed;

  /// No description provided for @tarotSwords07Name.
  ///
  /// In en, this message translates to:
  /// **'Seven of Swords'**
  String get tarotSwords07Name;

  /// No description provided for @tarotSwords07Upright.
  ///
  /// In en, this message translates to:
  /// **'deception, trickery, strategy, stealth, escape'**
  String get tarotSwords07Upright;

  /// No description provided for @tarotSwords07Reversed.
  ///
  /// In en, this message translates to:
  /// **'Confession, revealing secrets, discovering deception, guilt, confronting things head on.'**
  String get tarotSwords07Reversed;

  /// No description provided for @tarotSwords08Name.
  ///
  /// In en, this message translates to:
  /// **'Eight of Swords'**
  String get tarotSwords08Name;

  /// No description provided for @tarotSwords08Upright.
  ///
  /// In en, this message translates to:
  /// **'Self-centeredness, helplessness, limited thinking, prison of fear'**
  String get tarotSwords08Upright;

  /// No description provided for @tarotSwords08Reversed.
  ///
  /// In en, this message translates to:
  /// **'Liberation, breaking free from one\'s own prison, a new perspective'**
  String get tarotSwords08Reversed;

  /// No description provided for @tarotSwords09Name.
  ///
  /// In en, this message translates to:
  /// **'Nine of Swords'**
  String get tarotSwords09Name;

  /// No description provided for @tarotSwords09Upright.
  ///
  /// In en, this message translates to:
  /// **'Anxiety, despair, insomnia, guilt, inner fear.'**
  String get tarotSwords09Upright;

  /// No description provided for @tarotSwords09Reversed.
  ///
  /// In en, this message translates to:
  /// **'Overcoming fear, ray of hope, relieving insomnia, facing facts'**
  String get tarotSwords09Reversed;

  /// No description provided for @tarotSwords10Name.
  ///
  /// In en, this message translates to:
  /// **'Ten of Swords'**
  String get tarotSwords10Name;

  /// No description provided for @tarotSwords10Upright.
  ///
  /// In en, this message translates to:
  /// **'Destruction, deep wounds, betrayal, hitting rock bottom, the end comes.'**
  String get tarotSwords10Upright;

  /// No description provided for @tarotSwords10Reversed.
  ///
  /// In en, this message translates to:
  /// **'Recovery from destruction, the worst is over, survival, rebuilding'**
  String get tarotSwords10Reversed;

  /// No description provided for @tarotSwords11Name.
  ///
  /// In en, this message translates to:
  /// **'Page of Swords'**
  String get tarotSwords11Name;

  /// No description provided for @tarotSwords11Upright.
  ///
  /// In en, this message translates to:
  /// **'Curiosity, keen analytical skills, seeking truth, new ideas'**
  String get tarotSwords11Upright;

  /// No description provided for @tarotSwords11Reversed.
  ///
  /// In en, this message translates to:
  /// **'Indiscretion, impatience, cynicism, groundless rumors, rudeness'**
  String get tarotSwords11Reversed;

  /// No description provided for @tarotSwords12Name.
  ///
  /// In en, this message translates to:
  /// **'Knight of Swords'**
  String get tarotSwords12Name;

  /// No description provided for @tarotSwords12Upright.
  ///
  /// In en, this message translates to:
  /// **'Dash, ambition, intellectual drive, quick and decisive action'**
  String get tarotSwords12Upright;

  /// No description provided for @tarotSwords12Reversed.
  ///
  /// In en, this message translates to:
  /// **'Recklessness, aggression, inconsiderate words and actions, impulsiveness, ruthlessness'**
  String get tarotSwords12Reversed;

  /// No description provided for @tarotSwords13Name.
  ///
  /// In en, this message translates to:
  /// **'Queen of Swords'**
  String get tarotSwords13Name;

  /// No description provided for @tarotSwords13Upright.
  ///
  /// In en, this message translates to:
  /// **'Independence, clear communication, keen judgment, honesty, objectivity'**
  String get tarotSwords13Upright;

  /// No description provided for @tarotSwords13Reversed.
  ///
  /// In en, this message translates to:
  /// **'Heartlessness, ruthlessness, excessive criticism, resentment, isolation'**
  String get tarotSwords13Reversed;

  /// No description provided for @tarotSwords14Name.
  ///
  /// In en, this message translates to:
  /// **'King of Swords'**
  String get tarotSwords14Name;

  /// No description provided for @tarotSwords14Upright.
  ///
  /// In en, this message translates to:
  /// **'Authority, intellectual insight, logic, fairness, principles, expert'**
  String get tarotSwords14Upright;

  /// No description provided for @tarotSwords14Reversed.
  ///
  /// In en, this message translates to:
  /// **'Abuse of power, irrationality, cruelty, desire for control, dictatorship'**
  String get tarotSwords14Reversed;

  /// No description provided for @tarotWands01Name.
  ///
  /// In en, this message translates to:
  /// **'Ace of Wands'**
  String get tarotWands01Name;

  /// No description provided for @tarotWands01Upright.
  ///
  /// In en, this message translates to:
  /// **'Passion, inspiration, creative power, new potential, vitality'**
  String get tarotWands01Upright;

  /// No description provided for @tarotWands01Reversed.
  ///
  /// In en, this message translates to:
  /// **'Delayed enthusiasm, lack of inspiration, loss of motivation, and identity confusion.'**
  String get tarotWands01Reversed;

  /// No description provided for @tarotWands02Name.
  ///
  /// In en, this message translates to:
  /// **'Two of Wands'**
  String get tarotWands02Name;

  /// No description provided for @tarotWands02Upright.
  ///
  /// In en, this message translates to:
  /// **'Planning, vision, long-term goals, determination, exploration'**
  String get tarotWands02Upright;

  /// No description provided for @tarotWands02Reversed.
  ///
  /// In en, this message translates to:
  /// **'Lack of planning, procrastination, stagnation due to fear, limited vision.'**
  String get tarotWands02Reversed;

  /// No description provided for @tarotWands03Name.
  ///
  /// In en, this message translates to:
  /// **'Three of Wands'**
  String get tarotWands03Name;

  /// No description provided for @tarotWands03Upright.
  ///
  /// In en, this message translates to:
  /// **'Realization of expectations, progress, expansion, foresight, leadership'**
  String get tarotWands03Upright;

  /// No description provided for @tarotWands03Reversed.
  ///
  /// In en, this message translates to:
  /// **'Retardation of growth, setbacks, unexpected disabilities, intolerance'**
  String get tarotWands03Reversed;

  /// No description provided for @tarotWands04Name.
  ///
  /// In en, this message translates to:
  /// **'Four of Wands'**
  String get tarotWands04Name;

  /// No description provided for @tarotWands04Upright.
  ///
  /// In en, this message translates to:
  /// **'Celebration, comfort, joy of accomplishment, welcome, household events'**
  String get tarotWands04Upright;

  /// No description provided for @tarotWands04Reversed.
  ///
  /// In en, this message translates to:
  /// **'Canceled events, family strife, temporary stability, delayed celebrations.'**
  String get tarotWands04Reversed;

  /// No description provided for @tarotWands05Name.
  ///
  /// In en, this message translates to:
  /// **'Five of Wands'**
  String get tarotWands05Name;

  /// No description provided for @tarotWands05Upright.
  ///
  /// In en, this message translates to:
  /// **'Competition, conflict, disagreement, quarrel, challenge'**
  String get tarotWands05Upright;

  /// No description provided for @tarotWands05Reversed.
  ///
  /// In en, this message translates to:
  /// **'Compromise, avoidance of conflict, cooperation, pursuit of peace, calming chaos'**
  String get tarotWands05Reversed;

  /// No description provided for @tarotWands06Name.
  ///
  /// In en, this message translates to:
  /// **'Six of Wands'**
  String get tarotWands06Name;

  /// No description provided for @tarotWands06Upright.
  ///
  /// In en, this message translates to:
  /// **'Success, public recognition, victory, confidence, rise of leader.'**
  String get tarotWands06Upright;

  /// No description provided for @tarotWands06Reversed.
  ///
  /// In en, this message translates to:
  /// **'Defeat, dishonor, disapproval, pride, loss of reputation'**
  String get tarotWands06Reversed;

  /// No description provided for @tarotWands07Name.
  ///
  /// In en, this message translates to:
  /// **'Seven of Wands'**
  String get tarotWands07Name;

  /// No description provided for @tarotWands07Upright.
  ///
  /// In en, this message translates to:
  /// **'Courage, defense, facing competition, firm conviction, perseverance.'**
  String get tarotWands07Upright;

  /// No description provided for @tarotWands07Reversed.
  ///
  /// In en, this message translates to:
  /// **'Giving up, being overwhelmed, compromising, losing confidence, cowardice.'**
  String get tarotWands07Reversed;

  /// No description provided for @tarotWands08Name.
  ///
  /// In en, this message translates to:
  /// **'Eight of Wands'**
  String get tarotWands08Name;

  /// No description provided for @tarotWands08Upright.
  ///
  /// In en, this message translates to:
  /// **'Fast paced, quick ending, news, agility, speed.'**
  String get tarotWands08Upright;

  /// No description provided for @tarotWands08Reversed.
  ///
  /// In en, this message translates to:
  /// **'Delays, confusion, mistakes due to haste, inability to communicate'**
  String get tarotWands08Reversed;

  /// No description provided for @tarotWands09Name.
  ///
  /// In en, this message translates to:
  /// **'Nine of Wands'**
  String get tarotWands09Name;

  /// No description provided for @tarotWands09Upright.
  ///
  /// In en, this message translates to:
  /// **'Resilience, defensiveness, continuing even when exhausted, vigilance, testing of stamina.'**
  String get tarotWands09Upright;

  /// No description provided for @tarotWands09Reversed.
  ///
  /// In en, this message translates to:
  /// **'Fatigue, paranoia, giving up, stubbornness, unnecessary resistance.'**
  String get tarotWands09Reversed;

  /// No description provided for @tarotWands10Name.
  ///
  /// In en, this message translates to:
  /// **'Ten of Wands'**
  String get tarotWands10Name;

  /// No description provided for @tarotWands10Upright.
  ///
  /// In en, this message translates to:
  /// **'Excessive burden, extreme pressure, responsibility, pressure, limitations.'**
  String get tarotWands10Upright;

  /// No description provided for @tarotWands10Reversed.
  ///
  /// In en, this message translates to:
  /// **'Letting go, avoiding responsibility, exhaustion, delegating, overcoming.'**
  String get tarotWands10Reversed;

  /// No description provided for @tarotWands11Name.
  ///
  /// In en, this message translates to:
  /// **'Page of Wands'**
  String get tarotWands11Name;

  /// No description provided for @tarotWands11Upright.
  ///
  /// In en, this message translates to:
  /// **'Exploration, discovery, passionate ideas, energy, charm'**
  String get tarotWands11Upright;

  /// No description provided for @tarotWands11Reversed.
  ///
  /// In en, this message translates to:
  /// **'Loss of direction, immaturity, getting bored easily, vain delusions, irresponsibility'**
  String get tarotWands11Reversed;

  /// No description provided for @tarotWands12Name.
  ///
  /// In en, this message translates to:
  /// **'Knight of Wands'**
  String get tarotWands12Name;

  /// No description provided for @tarotWands12Upright.
  ///
  /// In en, this message translates to:
  /// **'Passionate forward movement, adventurous spirit, action, energy, confidence'**
  String get tarotWands12Upright;

  /// No description provided for @tarotWands12Reversed.
  ///
  /// In en, this message translates to:
  /// **'Impulsive behavior, arrogance, capriciousness, anger, and lack of planning.'**
  String get tarotWands12Reversed;

  /// No description provided for @tarotWands13Name.
  ///
  /// In en, this message translates to:
  /// **'Queen of Wands'**
  String get tarotWands13Name;

  /// No description provided for @tarotWands13Upright.
  ///
  /// In en, this message translates to:
  /// **'Charisma, courage, independence, brightness, charm, vitality'**
  String get tarotWands13Upright;

  /// No description provided for @tarotWands13Reversed.
  ///
  /// In en, this message translates to:
  /// **'Selfishness, exhibitionism, jealousy, capriciousness, aggression'**
  String get tarotWands13Reversed;

  /// No description provided for @tarotWands14Name.
  ///
  /// In en, this message translates to:
  /// **'King of Wands'**
  String get tarotWands14Name;

  /// No description provided for @tarotWands14Upright.
  ///
  /// In en, this message translates to:
  /// **'Charismatic leadership, vision, inspiration, boldness, entrepreneur'**
  String get tarotWands14Upright;

  /// No description provided for @tarotWands14Reversed.
  ///
  /// In en, this message translates to:
  /// **'Dictatorship, impulsive anger, unreality, arrogance, ruthlessness'**
  String get tarotWands14Reversed;

  /// No description provided for @nicknamePrefixes.
  ///
  /// In en, this message translates to:
  /// **'Mysterious, serene, holy, dark, shining, cold, hot, captivating, brutal, pure, rough, gentle, beautiful, strange, great, shabby, eternal, forgotten, brilliant , sad, happy, dreamy, decadent, pure white, jet black, blood red, gray, golden, silvery, blue, red, yellow, black, white, transparent, lonely, noisy, quiet, warm, cold. lonely, lonely, joyful, happy, gloomy, hopeless, hopeful, dazzling, dusky, dark, desolate, secret, secret, sacred, profane, arrogant, humble, wise lonely, foolish, strong, weak, brave, cowardly, distant, near, receding, approaching, disappearing, appearing, waking, sleeping, dreaming, wandering, wandering, staying, floating I am returning, waiting, seeking, hidden, revealed, abandoned, chosen, blessed, cursed, loved, hated, remembering, forgetting, of starlight, of moonlight, of sunlight, of the universe, Of the earth, sea, sky, clouds, wind, rain, snow, ice, fire, water, soil, trees, forests, mountains, rivers, lakes, time, space, dimensions, fate, destiny, energy Of enemies, of magic, of myth, of legend, of truth, of lies, of fantasy, of dreams, of nightmares, of destruction, of creation, of life, of death, of soul, of flesh, of reason, of emotion, of love, of hate, of sorrow. Of joy, anger, peace, war, chaos, order, light, darkness, twilight, dawn, noon, midnight, past, present, future, origin, apocalypse, infinite, finite, silence. of noise, singing, dancing, crying, laughing, whispering, shouting, praying, pleading, commanding, obeying, ruling, serving, leading, following, teaching, learning, Of memory, memories, wounds, healing, poison, medicine, illusion, substance, ideal, reality, virtual, natural, artificial, primordial, eternity, moment, fleeting, eternal, change, stop. ,flowing,stopped,burning,cooling,blooming,withering,growing,dying,breathing,suffocating,brilliant,subtle,dark,dim,transparent,faint,dazzling,strange. unique, special, noble, pure, corrupted, solitary, lonely, desolate, distant, harsh, cruel, cruel, great, strong, firm, flexible, quick, slow, quiet ,chaotic,memory,imaginary,silent,whispering,singing,dancing,sobbing,smiling,smirking,contemplating,wandering,wandering,awake,asleep,dreaming,daydreaming. Doing, delusional, praying, earnest, heartbreaking, heartbreaking, sublime, evil, mean, arrogant, humble, kind, warm, cool, creepy, bizarre, eerie, ecstatic, fascinating , dizzying, sweet, bittersweet, bitter, prickly, sharp, dull, rough, soft, cozy, comfortable, precarious, uneasy, carefree, peaceful, languid, bored, passionate ,indifferent, calm, fierce, fierce, crazy, crazy, rational, emotional, cool-headed, wise, foolish, naive, cunning, insidious, pure white, jet black, golden, silver, bloody'**
  String get nicknamePrefixes;

  /// No description provided for @nicknameSuffixes.
  ///
  /// In en, this message translates to:
  /// **'Prophet, Wizard, Witch, Knight, Warrior, Archer, Rogue, Assassin, Paladin, Priest, Priestess, Monk, Shaman, Alchemist, Necromancer, Elementalist, Summoner, Illusionist, Healer, Sage, Scholar, Researcher, Explorer, Traveler ruler, wanderer, wanderer, pilgrim, seeker, observer, recorder, messenger, guardian, sentinel, guard, gatekeeper, judge, executioner, ruler, ruler, king, queen, emperor, empress, noble, lord, knight commander, mercenary, pirate , thief, trickster, clown, fool, hermit, heretic, traitor, traitor, hero, savior, liberator, destroyer, creator, god, goddess, angel, devil, spirit, fairy, monster, beast, dragon, ghost, wraith, undead, vampire. , werewolf, mermaid, siren, nymph, goblin, orc, troll, elf, dwarf, giant, dwarf, human, beastman, joiner, fishman, dragon, evil spirit, Sura, abyss, heaven, underworld, other world, abyss, chaos, order, light, darkness, seeker , pilgrim, wanderer, hermit, heretic, traitor, pioneer, conqueror, ruler, coordinator, guardian, watcher, observer, recorder, messenger, guide, guide, savior, destroyer, creator, ghost, ghost, ghost, evil spirit. , spirit, fairy, magical beast, holy beast, phantom beast, divine beast, swordsman, knight, archer, thief, assassin, wizard, shaman, alchemist, necromancer, priest, scholar, researcher, explorer, traveler, artist, jester, bard, merchant, artisan, Farmer, crow, owl, eagle, hawk, wolf, fox, bear, lion, tiger, leopard, black panther, cat, cat, puppy, snake, lizard, turtle, crocodile, dragon, unicorn, pegasus, griffon, gargoyle, goblin. , Orc, Troll, Ogre, Slime, Skeleton, Zombie, Ghoul, Vampire, Werewolf, Minotaur, Centaur, Harpy, Siren, Kraken, Leviathan, Sword, Shield, Spear, Bow, Staff, Ring, Necklace, Crown, Holy Grail.'**
  String get nicknameSuffixes;

  /// No description provided for @eulaTitle.
  ///
  /// In en, this message translates to:
  /// **'End User License Agreement (EULA)'**
  String get eulaTitle;

  /// No description provided for @eulaArticle1.
  ///
  /// In en, this message translates to:
  /// **'Article 1 (Grant of License)\nPermission to use this app (“Tarot Witch”) is granted for personal, non-commercial use only, and no ownership or intellectual property rights in the app are transferred.'**
  String get eulaArticle1;

  /// No description provided for @eulaArticle2.
  ///
  /// In en, this message translates to:
  /// **'Article 2 (Prohibited Use)\nUsers may not use this service for purposes that are illegal or infringe upon the rights of others, and may not arbitrarily manipulate or reverse engineer systems or data.'**
  String get eulaArticle2;

  /// No description provided for @eulaArticle3.
  ///
  /// In en, this message translates to:
  /// **'Article 3 (Data collection and storage period)\nTo provide smooth service, tarot diaries and related fortune telling data written by users are safely stored for three years from the date of creation.'**
  String get eulaArticle3;

  /// No description provided for @eulaArticle4.
  ///
  /// In en, this message translates to:
  /// **'Article 4 (Handling of long-term inactive dormant accounts)\nIf a user does not access the service for more than one year (365 days), the account will be converted to a dormant account, and all data of the user will be automatically deleted without prior notice to protect personal information and maintain a smooth server environment.'**
  String get eulaArticle4;

  /// No description provided for @eulaArticle5.
  ///
  /// In en, this message translates to:
  /// **'Article 5 (Data destruction and recovery impossible)\nData that has elapsed the retention period in Article 3 or has been deleted in accordance with Article 4 will be permanently destroyed and cannot be recovered under any circumstances.'**
  String get eulaArticle5;

  /// No description provided for @eulaArticle6.
  ///
  /// In en, this message translates to:
  /// **'Article 6 (Disclaimer of Warranty and Indemnification)\nThe tarot readings and interpretations provided by this app are for entertainment purposes only and are not a substitute for legal, medical, or financial advice. The developer is not responsible for any direct or indirect damages arising from the use of the service.'**
  String get eulaArticle6;

  /// No description provided for @eulaAgreement.
  ///
  /// In en, this message translates to:
  /// **'The above EULA contents and data management policy are mandatory items that must be agreed to in order to use the app.'**
  String get eulaAgreement;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'close'**
  String get closeButton;

  /// No description provided for @pushTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Opt-in to receive event and marketing notifications'**
  String get pushTermsTitle;

  /// No description provided for @pushArticle1.
  ///
  /// In en, this message translates to:
  /// **'Article 1 (Purpose)\nThis consent is for the Tarot Witch service to send advertising information such as events, promotions, and new horoscope updates that are beneficial to users through push notifications.'**
  String get pushArticle1;

  /// No description provided for @pushArticle2.
  ///
  /// In en, this message translates to:
  /// **'Article 2 (Withdrawal of receipt)\nUsers may withdraw this consent at any time through [My Menu > App Settings] within the app. Even if you withdraw your consent, you can still use the basic functions (essential services) of the service as normal.'**
  String get pushArticle2;

  /// No description provided for @pushArticle3.
  ///
  /// In en, this message translates to:
  /// **'Article 3 (Contents of Notification)\nNotifications sent may include advertising and marketing in nature, such as special in-app discount offers, limited-time events, and personalized horoscope recommendations.'**
  String get pushArticle3;

  /// No description provided for @pushAgreement.
  ///
  /// In en, this message translates to:
  /// **'The above is optional for the user, and even if consent is not given, there is no disadvantage in using the tarot service.'**
  String get pushAgreement;

  /// No description provided for @windowsNoGoogleLogin.
  ///
  /// In en, this message translates to:
  /// **'Google login is not supported in the preview environment (Windows). Please use an Android device or the web.'**
  String get windowsNoGoogleLogin;

  /// No description provided for @signupTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'To proceed with membership registration, you must agree to the data storage terms and conditions.'**
  String get signupTermsRequired;

  /// No description provided for @googleLoginError.
  ///
  /// In en, this message translates to:
  /// **'Google login error: {error}'**
  String googleLoginError(String error);

  /// No description provided for @googleLoginUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred while logging in to Google.'**
  String get googleLoginUnknownError;

  /// No description provided for @windowsNoFirebase.
  ///
  /// In en, this message translates to:
  /// **'Firebase login is not supported in the preview environment (Windows).'**
  String get windowsNoFirebase;

  /// No description provided for @emailVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Email verification is required. Please check the email you signed up with.'**
  String get emailVerificationRequired;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendEmail;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'The verification email has been resent.'**
  String get verificationEmailSent;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password does not match. Please check again.'**
  String get passwordMismatch;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Membership registration has been completed. Please check the email sent to complete verification.'**
  String get signupSuccess;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'An authentication error occurred.'**
  String get authError;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'log in'**
  String get authLoginTitle;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'join the membership'**
  String get authSignupTitle;

  /// No description provided for @authTarotNickname.
  ///
  /// In en, this message translates to:
  /// **'Nicknames in the Tarot World'**
  String get authTarotNickname;

  /// No description provided for @authRerollNickname.
  ///
  /// In en, this message translates to:
  /// **'Pick a nickname again'**
  String get authRerollNickname;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'verify password'**
  String get authConfirmPassword;

  /// No description provided for @authKeepLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Stay logged in'**
  String get authKeepLoggedIn;

  /// No description provided for @authAgreeEula.
  ///
  /// In en, this message translates to:
  /// **'I agree to the End User License Agreement (EULA). (essential)'**
  String get authAgreeEula;

  /// No description provided for @authViewContent.
  ///
  /// In en, this message translates to:
  /// **'[View content]'**
  String get authViewContent;

  /// No description provided for @authAgreePush.
  ///
  /// In en, this message translates to:
  /// **'I agree to receive notifications of new tarot readings and events. (select)'**
  String get authAgreePush;

  /// No description provided for @authBtnLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authBtnLogin;

  /// No description provided for @authBtnSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authBtnSignup;

  /// No description provided for @authSwitchToSignup.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? join the membership'**
  String get authSwitchToSignup;

  /// No description provided for @authSwitchToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? log in'**
  String get authSwitchToLogin;

  /// No description provided for @authGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Get started with Google'**
  String get authGoogleSignIn;

  /// No description provided for @cardDetailNotReady.
  ///
  /// In en, this message translates to:
  /// **'This interpretation is not yet ready.'**
  String get cardDetailNotReady;

  /// No description provided for @cardDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading data.'**
  String get cardDetailLoadError;

  /// No description provided for @cardDetailTabUpright.
  ///
  /// In en, this message translates to:
  /// **'Upright'**
  String get cardDetailTabUpright;

  /// No description provided for @cardDetailTabReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get cardDetailTabReversed;

  /// No description provided for @cardDetailNoInterpretation.
  ///
  /// In en, this message translates to:
  /// **'There is no interpretation.'**
  String get cardDetailNoInterpretation;

  /// No description provided for @cardDetailSectionKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get cardDetailSectionKeywords;

  /// No description provided for @cardDetailSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General interpretation'**
  String get cardDetailSectionGeneral;

  /// No description provided for @cardDetailSectionLove.
  ///
  /// In en, this message translates to:
  /// **'love luck'**
  String get cardDetailSectionLove;

  /// No description provided for @cardDetailSectionCareer.
  ///
  /// In en, this message translates to:
  /// **'money career'**
  String get cardDetailSectionCareer;

  /// No description provided for @cardDetailSectionHealth.
  ///
  /// In en, this message translates to:
  /// **'health'**
  String get cardDetailSectionHealth;

  /// No description provided for @cardDetailSectionSpirituality.
  ///
  /// In en, this message translates to:
  /// **'spirituality inside'**
  String get cardDetailSectionSpirituality;

  /// No description provided for @chatDustShortageTitle.
  ///
  /// In en, this message translates to:
  /// **'lack of powder'**
  String get chatDustShortageTitle;

  /// No description provided for @chatDustShortageContent.
  ///
  /// In en, this message translates to:
  /// **'There is not enough magic powder. Tarot reading requires 1 powder.'**
  String get chatDustShortageContent;

  /// No description provided for @chatConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'check'**
  String get chatConfirmBtn;

  /// No description provided for @chatStartReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Start tarot reading'**
  String get chatStartReadingTitle;

  /// No description provided for @chatStartReadingContent.
  ///
  /// In en, this message translates to:
  /// **'Would you like to spend 1 powder to start a tarot reading?'**
  String get chatStartReadingContent;

  /// No description provided for @chatCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'cancellation'**
  String get chatCancelBtn;

  /// No description provided for @chatStartBtn.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get chatStartBtn;

  /// No description provided for @chatShufflingCards.
  ///
  /// In en, this message translates to:
  /// **'Shuffling tarot cards...'**
  String get chatShufflingCards;

  /// No description provided for @profileEditEmptyNickname.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname.'**
  String get profileEditEmptyNickname;

  /// No description provided for @profileEditDuplicateNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname is already in use. Please enter a different nickname.'**
  String get profileEditDuplicateNickname;

  /// No description provided for @profileEditEmptyPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password to change your email.'**
  String get profileEditEmptyPassword;

  /// No description provided for @profileEditEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email has been sent. Please complete verification in your new email inbox.'**
  String get profileEditEmailSent;

  /// No description provided for @profileEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile has been saved.'**
  String get profileEditSuccess;

  /// No description provided for @profileEditErrorDefault.
  ///
  /// In en, this message translates to:
  /// **'An error occurred.'**
  String get profileEditErrorDefault;

  /// No description provided for @profileEditErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get profileEditErrorWrongPassword;

  /// No description provided for @profileEditErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get profileEditErrorInvalidEmail;

  /// No description provided for @profileEditErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use.'**
  String get profileEditErrorEmailInUse;

  /// No description provided for @profileEditErrorRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, please log in again and try.'**
  String get profileEditErrorRecentLogin;

  /// No description provided for @profileEditErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred while saving: {error}'**
  String profileEditErrorUnknown(String error);

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditPhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profileEditPhoto;

  /// No description provided for @profileEditNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get profileEditNickname;

  /// No description provided for @profileEditEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get profileEditEmail;

  /// No description provided for @profileEditEmailSocialHint.
  ///
  /// In en, this message translates to:
  /// **'Google/Apple linked accounts cannot change email.'**
  String get profileEditEmailSocialHint;

  /// No description provided for @profileEditEmailChangeHint.
  ///
  /// In en, this message translates to:
  /// **'A verification email will be sent when changing email.'**
  String get profileEditEmailChangeHint;

  /// No description provided for @profileEditPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password (for email change verification)'**
  String get profileEditPassword;

  /// No description provided for @profileEditCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileEditCancel;

  /// No description provided for @profileEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditSave;

  /// No description provided for @coinShortageTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Enough Coins'**
  String get coinShortageTitle;

  /// No description provided for @coinShortageContent.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have enough coins. 1 coin is required for a tarot reading.'**
  String get coinShortageContent;

  /// No description provided for @dialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogOk;

  /// No description provided for @proceedReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Proceed Tarot Reading'**
  String get proceedReadingTitle;

  /// No description provided for @proceedReadingContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to consume 1 coin to proceed with the reading?'**
  String get proceedReadingContent;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogProceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get dialogProceed;

  /// No description provided for @pickCardsText.
  ///
  /// In en, this message translates to:
  /// **'Pick {count} cards'**
  String pickCardsText(int count);

  /// No description provided for @layoutFan.
  ///
  /// In en, this message translates to:
  /// **'Fan Shape'**
  String get layoutFan;

  /// No description provided for @layoutStacked.
  ///
  /// In en, this message translates to:
  /// **'Stacked'**
  String get layoutStacked;

  /// No description provided for @readingFateFragments.
  ///
  /// In en, this message translates to:
  /// **'Reading the fragments of destiny.'**
  String get readingFateFragments;

  /// No description provided for @witchTarotReading.
  ///
  /// In en, this message translates to:
  /// **'{witchName}\'s Tarot Reading'**
  String witchTarotReading(String witchName);

  /// No description provided for @magicDustObtained.
  ///
  /// In en, this message translates to:
  /// **'Obtained +{amount} Magic Dust! ✨'**
  String magicDustObtained(int amount);

  /// No description provided for @spreadUpright.
  ///
  /// In en, this message translates to:
  /// **'Upright'**
  String get spreadUpright;

  /// No description provided for @spreadReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get spreadReversed;

  /// No description provided for @buttonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get buttonShare;

  /// No description provided for @buttonSelectSpread.
  ///
  /// In en, this message translates to:
  /// **'Select Spread'**
  String get buttonSelectSpread;

  /// No description provided for @buttonSelectOtherWitch.
  ///
  /// In en, this message translates to:
  /// **'Select Other Witch'**
  String get buttonSelectOtherWitch;

  /// No description provided for @shareResultText.
  ///
  /// In en, this message translates to:
  /// **'🔮 Check out my Tarot reading results!\\n\\nIf you want to know the detailed reading, install the Tarot Witch app and check your tarot reading yourself!\\n👉 Download: https://play.google.com/store/apps/details?id=com.ncia.tarot_card'**
  String get shareResultText;

  /// No description provided for @buttonTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get buttonTranslate;

  /// No description provided for @translateFailed.
  ///
  /// In en, this message translates to:
  /// **'Translation failed: {error}'**
  String translateFailed(String error);

  /// No description provided for @tagLove.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get tagLove;

  /// No description provided for @tagMoney.
  ///
  /// In en, this message translates to:
  /// **'Wealth'**
  String get tagMoney;

  /// No description provided for @tagHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get tagHealth;

  /// No description provided for @tagCareer.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get tagCareer;

  /// No description provided for @tagToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Fortune'**
  String get tagToday;

  /// No description provided for @tagRelationship.
  ///
  /// In en, this message translates to:
  /// **'Relationships'**
  String get tagRelationship;

  /// No description provided for @tagSelfReflection.
  ///
  /// In en, this message translates to:
  /// **'Self-Reflection'**
  String get tagSelfReflection;

  /// No description provided for @myMenuDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get myMenuDeleteAccount;

  /// No description provided for @myMenuDeleteAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Delete my account and information'**
  String get myMenuDeleteAccountDesc;

  /// No description provided for @myMenuDeleteAccountWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Deletion Warning'**
  String get myMenuDeleteAccountWarnTitle;

  /// No description provided for @myMenuDeleteAccountWarnDesc.
  ///
  /// In en, this message translates to:
  /// **'Upon deleting your account, all data saved on your smartphone will also be deleted. Do you wish to continue?'**
  String get myMenuDeleteAccountWarnDesc;

  /// No description provided for @myMenuDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get myMenuDeleteAccountConfirm;

  /// No description provided for @myMenuDeleteAccountCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get myMenuDeleteAccountCancel;

  /// No description provided for @emailVerificationRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Verification Required'**
  String get emailVerificationRequiredTitle;

  /// No description provided for @emailVerificationRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'You need to verify your email to use main features like Tarot reading and payments. Please complete the verification in My Menu.'**
  String get emailVerificationRequiredDesc;

  /// No description provided for @emailVerificationGoToMenu.
  ///
  /// In en, this message translates to:
  /// **'Go to My Menu'**
  String get emailVerificationGoToMenu;

  /// No description provided for @profileEditBio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileEditBio;

  /// No description provided for @profileEditSnsIntegration.
  ///
  /// In en, this message translates to:
  /// **'SNS Integration (Optional)'**
  String get profileEditSnsIntegration;

  /// No description provided for @profileEditSnsInsta.
  ///
  /// In en, this message translates to:
  /// **'Instagram URL (or ID)'**
  String get profileEditSnsInsta;

  /// No description provided for @profileEditSnsFb.
  ///
  /// In en, this message translates to:
  /// **'Facebook URL'**
  String get profileEditSnsFb;

  /// No description provided for @profileEditSnsX.
  ///
  /// In en, this message translates to:
  /// **'X (Twitter) URL'**
  String get profileEditSnsX;

  /// No description provided for @btnClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// No description provided for @cardDetailAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Added to Favorites'**
  String get cardDetailAddFavorite;

  /// No description provided for @cardDetailRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Removed from Favorites'**
  String get cardDetailRemoveFavorite;

  /// No description provided for @favoriteCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite Cards'**
  String get favoriteCardsTitle;

  /// No description provided for @favoriteCardsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorite cards yet.'**
  String get favoriteCardsEmpty;

  /// No description provided for @cardDetailDataNotReady.
  ///
  /// In en, this message translates to:
  /// **'Detailed interpretation data is not yet ready.'**
  String get cardDetailDataNotReady;

  /// No description provided for @cardDetailNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get cardDetailNoData;

  /// No description provided for @buttonSaveReading.
  ///
  /// In en, this message translates to:
  /// **'Save Tarot Reading'**
  String get buttonSaveReading;

  /// No description provided for @readingSavedToDevice.
  ///
  /// In en, this message translates to:
  /// **'Saved to device.'**
  String get readingSavedToDevice;

  /// No description provided for @growthPhaseFormat.
  ///
  /// In en, this message translates to:
  /// **'[{level} Phase: {name}]'**
  String growthPhaseFormat(int level, String name);

  /// No description provided for @growthTabMagicBook.
  ///
  /// In en, this message translates to:
  /// **'Magic Book Upgrade'**
  String get growthTabMagicBook;

  /// No description provided for @growthPhaseCrystal0.
  ///
  /// In en, this message translates to:
  /// **'Abyssal Magic'**
  String get growthPhaseCrystal0;

  /// No description provided for @growthPhaseCrystal1.
  ///
  /// In en, this message translates to:
  /// **'Opening the Spirit Eye'**
  String get growthPhaseCrystal1;

  /// No description provided for @growthPhaseCrystal2.
  ///
  /// In en, this message translates to:
  /// **'Wisdom of Mother Nature'**
  String get growthPhaseCrystal2;

  /// No description provided for @growthPhaseCrystal3.
  ///
  /// In en, this message translates to:
  /// **'Essence of the Sun'**
  String get growthPhaseCrystal3;

  /// No description provided for @growthPhaseCrystal4.
  ///
  /// In en, this message translates to:
  /// **'Celestial Aurora'**
  String get growthPhaseCrystal4;

  /// No description provided for @growthPhaseCrystal5.
  ///
  /// In en, this message translates to:
  /// **'Divine Realm'**
  String get growthPhaseCrystal5;

  /// No description provided for @growthPhaseCrystal6.
  ///
  /// In en, this message translates to:
  /// **'Magic of Creation'**
  String get growthPhaseCrystal6;

  /// No description provided for @growthPhaseCrystal7.
  ///
  /// In en, this message translates to:
  /// **'Breath of the Universe'**
  String get growthPhaseCrystal7;

  /// No description provided for @growthPhaseCrystal8.
  ///
  /// In en, this message translates to:
  /// **'Eternal Light'**
  String get growthPhaseCrystal8;

  /// No description provided for @growthPhaseCrystal9.
  ///
  /// In en, this message translates to:
  /// **'Pure White Awakening'**
  String get growthPhaseCrystal9;

  /// No description provided for @growthPhaseCrystal10.
  ///
  /// In en, this message translates to:
  /// **'Transcendence'**
  String get growthPhaseCrystal10;

  /// No description provided for @growthPhaseBook0.
  ///
  /// In en, this message translates to:
  /// **'Apprentice\'s Writing Tools'**
  String get growthPhaseBook0;

  /// No description provided for @growthPhaseBook1.
  ///
  /// In en, this message translates to:
  /// **'Basic Magic Primer'**
  String get growthPhaseBook1;

  /// No description provided for @growthPhaseBook2.
  ///
  /// In en, this message translates to:
  /// **'Ancient Rune Grammar'**
  String get growthPhaseBook2;

  /// No description provided for @growthPhaseBook3.
  ///
  /// In en, this message translates to:
  /// **'Understanding Elemental Magic'**
  String get growthPhaseBook3;

  /// No description provided for @growthPhaseBook4.
  ///
  /// In en, this message translates to:
  /// **'Harmony of Starlight'**
  String get growthPhaseBook4;

  /// No description provided for @growthPhaseBook5.
  ///
  /// In en, this message translates to:
  /// **'Artifact Deciphering'**
  String get growthPhaseBook5;

  /// No description provided for @growthPhaseBook6.
  ///
  /// In en, this message translates to:
  /// **'Forbidden Book of the Sage'**
  String get growthPhaseBook6;

  /// No description provided for @growthPhaseBook7.
  ///
  /// In en, this message translates to:
  /// **'Communion with Spirits'**
  String get growthPhaseBook7;

  /// No description provided for @growthPhaseBook8.
  ///
  /// In en, this message translates to:
  /// **'Grimoire of Truth'**
  String get growthPhaseBook8;

  /// No description provided for @growthPhaseBook9.
  ///
  /// In en, this message translates to:
  /// **'Omnipotent Record'**
  String get growthPhaseBook9;

  /// No description provided for @growthMagicBookLevel.
  ///
  /// In en, this message translates to:
  /// **'Magic Book Level {level}'**
  String growthMagicBookLevel(int level);

  /// No description provided for @growthMagicBookKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge: {current} / {max}'**
  String growthMagicBookKnowledge(int current, int max);

  /// No description provided for @growthCrystalBallMana.
  ///
  /// In en, this message translates to:
  /// **'Mana: {current} / {max}'**
  String growthCrystalBallMana(int current, int max);

  /// No description provided for @growthMagicBookExpGained.
  ///
  /// In en, this message translates to:
  /// **'The magic book\'s knowledge has deepened! Exp +{amount}'**
  String growthMagicBookExpGained(int amount);

  /// No description provided for @growthUpgradeMagicBookButton.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Magic Book ({amount} Dust)'**
  String growthUpgradeMagicBookButton(int amount);

  /// No description provided for @devDustCharged.
  ///
  /// In en, this message translates to:
  /// **'Dev: 1000 Magic Dust charged!'**
  String get devDustCharged;

  /// No description provided for @growthUpgradeButtonCost.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Crystal Ball ({amount} Dust)'**
  String growthUpgradeButtonCost(int amount);

  /// No description provided for @menuSectionNews.
  ///
  /// In en, this message translates to:
  /// **'News & Notifications'**
  String get menuSectionNews;

  /// No description provided for @menuMailboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Mailbox'**
  String get menuMailboxTitle;

  /// No description provided for @menuMailboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check new updates and gifts'**
  String get menuMailboxSubtitle;

  /// No description provided for @mailboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Mailbox'**
  String get mailboxTitle;

  /// No description provided for @mailboxAllRewardsClaimed.
  ///
  /// In en, this message translates to:
  /// **'All rewards claimed.'**
  String get mailboxAllRewardsClaimed;

  /// No description provided for @mailboxClaimAll.
  ///
  /// In en, this message translates to:
  /// **'Claim All'**
  String get mailboxClaimAll;

  /// No description provided for @mailboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'Mailbox is empty.'**
  String get mailboxEmpty;

  /// No description provided for @mailboxSenderAndDate.
  ///
  /// In en, this message translates to:
  /// **'From: {sender} • {date}'**
  String mailboxSenderAndDate(String sender, String date);

  /// No description provided for @mailboxClaimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get mailboxClaimed;

  /// No description provided for @mailboxClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get mailboxClaim;

  /// No description provided for @mailboxAttachedRewards.
  ///
  /// In en, this message translates to:
  /// **'Attached Rewards'**
  String get mailboxAttachedRewards;

  /// No description provided for @mailboxRewardClaimed.
  ///
  /// In en, this message translates to:
  /// **'Reward claimed.'**
  String get mailboxRewardClaimed;

  /// No description provided for @mailboxClaimReward.
  ///
  /// In en, this message translates to:
  /// **'Claim Reward'**
  String get mailboxClaimReward;

  /// No description provided for @menuNotificationCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Center'**
  String get menuNotificationCenterTitle;

  /// No description provided for @menuNotificationCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check latest notifications and announcements'**
  String get menuNotificationCenterSubtitle;

  /// No description provided for @authSignupComplete.
  ///
  /// In en, this message translates to:
  /// **'Sign up is complete. Please check the email sent to you to verify.'**
  String get authSignupComplete;

  /// No description provided for @chatInitError.
  ///
  /// In en, this message translates to:
  /// **'Initialization error occurred:\n{error}'**
  String chatInitError(String error);

  /// No description provided for @chatError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred:\n{error}\n\n{stackTrace}'**
  String chatError(String error, String stackTrace);

  /// No description provided for @chatPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'Position {number}'**
  String chatPositionLabel(int number);

  /// No description provided for @communityTranslationFailed.
  ///
  /// In en, this message translates to:
  /// **'Translation failed: {error}'**
  String communityTranslationFailed(String error);

  /// No description provided for @diarySelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get diarySelectDate;

  /// No description provided for @diarySavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Diary saved successfully!'**
  String get diarySavedSuccess;

  /// No description provided for @diarySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save diary.'**
  String get diarySaveFailed;

  /// No description provided for @diaryWriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Write Diary'**
  String get diaryWriteTitle;

  /// No description provided for @diaryWriteHint.
  ///
  /// In en, this message translates to:
  /// **'Feel free to write your thoughts or feelings about today\'s reading.'**
  String get diaryWriteHint;

  /// No description provided for @diarySaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save to Diary'**
  String get diarySaveButton;

  /// No description provided for @myMenuAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String myMenuAppVersion(String version);

  /// No description provided for @readingSpreadLabelToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Fortune'**
  String get readingSpreadLabelToday;

  /// No description provided for @readingSpreadLabelPast1.
  ///
  /// In en, this message translates to:
  /// **'1. Past'**
  String get readingSpreadLabelPast1;

  /// No description provided for @readingSpreadLabelPresent2.
  ///
  /// In en, this message translates to:
  /// **'2. Present'**
  String get readingSpreadLabelPresent2;

  /// No description provided for @readingSpreadLabelFuture3.
  ///
  /// In en, this message translates to:
  /// **'3. Future'**
  String get readingSpreadLabelFuture3;

  /// No description provided for @readingSpreadLabelCurrent1.
  ///
  /// In en, this message translates to:
  /// **'1. Current'**
  String get readingSpreadLabelCurrent1;

  /// No description provided for @readingSpreadLabelPast2.
  ///
  /// In en, this message translates to:
  /// **'2. Past'**
  String get readingSpreadLabelPast2;

  /// No description provided for @readingSpreadLabelFuture3Alt.
  ///
  /// In en, this message translates to:
  /// **'3. Future'**
  String get readingSpreadLabelFuture3Alt;

  /// No description provided for @readingSpreadLabelCause4.
  ///
  /// In en, this message translates to:
  /// **'4. Cause'**
  String get readingSpreadLabelCause4;

  /// No description provided for @readingSpreadLabelPotential5.
  ///
  /// In en, this message translates to:
  /// **'5. Potential'**
  String get readingSpreadLabelPotential5;

  /// No description provided for @readingSpreadLabelCurrentSituation1.
  ///
  /// In en, this message translates to:
  /// **'1. Current situation and problem'**
  String get readingSpreadLabelCurrentSituation1;

  /// No description provided for @readingSpreadLabelCauseOfProblem2.
  ///
  /// In en, this message translates to:
  /// **'2. Cause of problem'**
  String get readingSpreadLabelCauseOfProblem2;

  /// No description provided for @readingSpreadLabelAdviceForResolution3.
  ///
  /// In en, this message translates to:
  /// **'3. Advice for resolution'**
  String get readingSpreadLabelAdviceForResolution3;

  /// No description provided for @readingSpreadLabelExpectedResult4.
  ///
  /// In en, this message translates to:
  /// **'4. Expected result'**
  String get readingSpreadLabelExpectedResult4;

  /// No description provided for @readingSpreadLabelCurrentSituation1Alt.
  ///
  /// In en, this message translates to:
  /// **'1. Current situation'**
  String get readingSpreadLabelCurrentSituation1Alt;

  /// No description provided for @readingSpreadLabelObstacle2.
  ///
  /// In en, this message translates to:
  /// **'2. Obstacle'**
  String get readingSpreadLabelObstacle2;

  /// No description provided for @readingSpreadLabelUnconscious3.
  ///
  /// In en, this message translates to:
  /// **'3. Unconscious'**
  String get readingSpreadLabelUnconscious3;

  /// No description provided for @readingSpreadLabelPast4.
  ///
  /// In en, this message translates to:
  /// **'4. Past'**
  String get readingSpreadLabelPast4;

  /// No description provided for @readingSpreadLabelConsciousGoal5.
  ///
  /// In en, this message translates to:
  /// **'5. Conscious Goal'**
  String get readingSpreadLabelConsciousGoal5;

  /// No description provided for @readingSpreadLabelNearFuture6.
  ///
  /// In en, this message translates to:
  /// **'6. Near Future'**
  String get readingSpreadLabelNearFuture6;

  /// No description provided for @readingSpreadLabelAttitude7.
  ///
  /// In en, this message translates to:
  /// **'7. Attitude'**
  String get readingSpreadLabelAttitude7;

  /// No description provided for @readingSpreadLabelExternalEnvironment8.
  ///
  /// In en, this message translates to:
  /// **'8. External Environment'**
  String get readingSpreadLabelExternalEnvironment8;

  /// No description provided for @readingSpreadLabelHopesAndFears9.
  ///
  /// In en, this message translates to:
  /// **'9. Hopes and Fears'**
  String get readingSpreadLabelHopesAndFears9;

  /// No description provided for @readingSpreadLabelFinalResult10.
  ///
  /// In en, this message translates to:
  /// **'10. Final Result'**
  String get readingSpreadLabelFinalResult10;

  /// No description provided for @readingSpreadLabelAdvice4.
  ///
  /// In en, this message translates to:
  /// **'4. Advice'**
  String get readingSpreadLabelAdvice4;

  /// No description provided for @readingSpreadLabelSurroundings5.
  ///
  /// In en, this message translates to:
  /// **'5. Surroundings'**
  String get readingSpreadLabelSurroundings5;

  /// No description provided for @readingSpreadLabelResult6.
  ///
  /// In en, this message translates to:
  /// **'6. Result'**
  String get readingSpreadLabelResult6;

  /// No description provided for @shopBonusCoins.
  ///
  /// In en, this message translates to:
  /// **'Bonus {amount}'**
  String shopBonusCoins(String amount);

  /// No description provided for @shopCoins.
  ///
  /// In en, this message translates to:
  /// **'{amount} Coins'**
  String shopCoins(int amount);

  /// No description provided for @serviceLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login is required.'**
  String get serviceLoginRequired;

  /// No description provided for @serviceDefaultNickname.
  ///
  /// In en, this message translates to:
  /// **'Nameless Witch'**
  String get serviceDefaultNickname;

  /// No description provided for @serviceTarotReadingError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while reading the fortune: {error}'**
  String serviceTarotReadingError(String error);

  /// No description provided for @defaultUserDisplayName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserDisplayName;

  /// No description provided for @listenToInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Listen to Interpretation'**
  String get listenToInterpretation;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'Can I read tarot every day?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Yes, it is good to read the flow of today with a light heart. However, it is not recommended to keep drawing cards repeatedly for the same question.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I get magic dust?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Each time you get a mystical tarot reading, you will acquire 10 Magic Powder as a basic reward per reading!'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'What should I do if the result is bad?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Tarot is not a fixed future, but an advice. Use a bad result as a milestone to warn you of risks to avoid.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'How can I see my past tarot readings?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'You can view your saved reading records by list and date at any time in the \'Tarot Diary\' tab of the bottom menu.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'How do I share to the community?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'If you turn on the \'Community Share\' switch on the diary detail screen saved in the Tarot Diary, you can share your readings with other users.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'How can I change my nickname or profile?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'You can change your nickname and icon at any time by touching the profile area at the top of the \'My Menu\' tab.'**
  String get faqA6;

  /// No description provided for @faqQ7.
  ///
  /// In en, this message translates to:
  /// **'Where can I turn notifications on and off?'**
  String get faqQ7;

  /// No description provided for @faqA7.
  ///
  /// In en, this message translates to:
  /// **'You can turn push notifications on or off at any time via the \'Receive Push Notifications\' switch in the \'My Menu\' tab of the bottom menu. We recommend keeping notifications on so you don\'t miss out on various special event benefits and new tarot news.'**
  String get faqA7;

  /// No description provided for @faqQ8.
  ///
  /// In en, this message translates to:
  /// **'Can I see other people\'s tarot diaries?'**
  String get faqQ8;

  /// No description provided for @faqA8.
  ///
  /// In en, this message translates to:
  /// **'By clicking the community icon at the top, you can browse and support interesting tarot readings set to public by other wizards (users).'**
  String get faqA8;

  /// No description provided for @faqQ9.
  ///
  /// In en, this message translates to:
  /// **'Where can I check my premium subscription or payment history?'**
  String get faqQ9;

  /// No description provided for @faqA9.
  ///
  /// In en, this message translates to:
  /// **'By selecting \'Payment History\' from the [My Menu] tab at the bottom, you can view your coin payment history and acquired Magic Powder in detail.'**
  String get faqA9;

  /// No description provided for @faqQ10.
  ///
  /// In en, this message translates to:
  /// **'I want to study the meaning of Tarot cards personally. How can I do that?'**
  String get faqQ10;

  /// No description provided for @faqA10.
  ///
  /// In en, this message translates to:
  /// **'If you go to the [Card Encyclopedia] tab in the bottom menu, you can freely view the upright and reversed meanings, symbols, and in-depth explanations of all 78 cards.'**
  String get faqA10;

  /// No description provided for @faqQ11.
  ///
  /// In en, this message translates to:
  /// **'How can I delete my account or withdraw?'**
  String get faqQ11;

  /// No description provided for @faqA11.
  ///
  /// In en, this message translates to:
  /// **'You can find the \'Account Deletion\' button at the bottom of the [My Menu] tab in the bottom menu. Upon deletion, all diaries and data will be permanently deleted.'**
  String get faqA11;

  /// No description provided for @faqQ12.
  ///
  /// In en, this message translates to:
  /// **'Where do I contact if I encounter an error or have suggestions?'**
  String get faqQ12;

  /// No description provided for @faqA12.
  ///
  /// In en, this message translates to:
  /// **'If you send details through \'Contact Customer Service\' which is being prepared at the bottom of the current screen or via official email, we will quickly check and magically solve it for you.'**
  String get faqA12;

  /// No description provided for @faqQ13.
  ///
  /// In en, this message translates to:
  /// **'What should I do if a warning message appears when I try to sign up with a different email address?'**
  String get faqQ13;

  /// No description provided for @faqA13.
  ///
  /// In en, this message translates to:
  /// **'For secure data management, the current system supports registration and login with only a single email address per device (app). If you wish to sign up with a different email address, please delete the app completely and then reinstall it to proceed.'**
  String get faqA13;

  /// No description provided for @myMenuContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get myMenuContactUs;

  /// No description provided for @myMenuContactUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inquiries and suggestions'**
  String get myMenuContactUsSubtitle;

  /// No description provided for @contactDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactDialogTitle;

  /// No description provided for @contactTypeBug.
  ///
  /// In en, this message translates to:
  /// **'Bug Report'**
  String get contactTypeBug;

  /// No description provided for @contactTypeFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature Suggestion'**
  String get contactTypeFeature;

  /// No description provided for @contactTypePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment Issue'**
  String get contactTypePayment;

  /// No description provided for @contactTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other Inquiry'**
  String get contactTypeOther;

  /// No description provided for @contactHint.
  ///
  /// In en, this message translates to:
  /// **'Please write your inquiry in detail.'**
  String get contactHint;

  /// No description provided for @contactSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get contactSend;

  /// No description provided for @contactCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get contactCancel;

  /// No description provided for @contactEmptyErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get contactEmptyErrorTitle;

  /// No description provided for @contactEmptyErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your inquiry content.'**
  String get contactEmptyErrorMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'be',
    'bg',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fa',
    'fi',
    'fr',
    'hi',
    'hr',
    'hu',
    'hy',
    'id',
    'it',
    'ja',
    'ko',
    'lt',
    'lv',
    'ml',
    'ms',
    'no',
    'pl',
    'pt',
    'rm',
    'ro',
    'ru',
    'sk',
    'sl',
    'sr',
    'sv',
    'th',
    'tl',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'be':
      return AppLocalizationsBe();
    case 'bg':
      return AppLocalizationsBg();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'hy':
      return AppLocalizationsHy();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'ml':
      return AppLocalizationsMl();
    case 'ms':
      return AppLocalizationsMs();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'rm':
      return AppLocalizationsRm();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sr':
      return AppLocalizationsSr();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
