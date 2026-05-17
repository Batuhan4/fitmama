import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fil'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'FitMama'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Doğumdan sonra daha güçlü'**
  String get appTagline;

  /// No description provided for @welcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldin'**
  String get welcomeTitle;

  /// No description provided for @welcomeSub.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulamayı kim kullanacak?'**
  String get welcomeSub;

  /// No description provided for @welcomeMom.
  ///
  /// In tr, this message translates to:
  /// **'Ben anneyim'**
  String get welcomeMom;

  /// No description provided for @welcomeMomDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kendi takip ve önerilerimi yöneteceğim.'**
  String get welcomeMomDesc;

  /// No description provided for @welcomePartner.
  ///
  /// In tr, this message translates to:
  /// **'Partner / Arkadaş'**
  String get welcomePartner;

  /// No description provided for @welcomePartnerDesc.
  ///
  /// In tr, this message translates to:
  /// **'Annenin paylaştığı kodla ona destek olmak istiyorum.'**
  String get welcomePartnerDesc;

  /// No description provided for @welcomeEnterCode.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşme kodunu gir'**
  String get welcomeEnterCode;

  /// No description provided for @welcomeEnterCodeDesc.
  ///
  /// In tr, this message translates to:
  /// **'Anne, Ayarlar\'dan kodu oluşturup seninle paylaşır.'**
  String get welcomeEnterCodeDesc;

  /// No description provided for @welcomeConnect.
  ///
  /// In tr, this message translates to:
  /// **'Bağlan'**
  String get welcomeConnect;

  /// No description provided for @welcomeConnected.
  ///
  /// In tr, this message translates to:
  /// **'Bağlandın 💕'**
  String get welcomeConnected;

  /// No description provided for @welcomeBadCode.
  ///
  /// In tr, this message translates to:
  /// **'Kod doğru değil'**
  String get welcomeBadCode;

  /// No description provided for @welcomeNoCodeYet.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihazda henüz bir kod oluşturulmamış'**
  String get welcomeNoCodeYet;

  /// No description provided for @partnerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Partner görünümü'**
  String get partnerTitle;

  /// No description provided for @partnerMom.
  ///
  /// In tr, this message translates to:
  /// **'Anne'**
  String get partnerMom;

  /// No description provided for @partnerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Annenin bugünkü durumuna göz at ve nasıl destek olabileceğini gör.'**
  String get partnerSubtitle;

  /// No description provided for @partnerStatusToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü ruh hali'**
  String get partnerStatusToday;

  /// No description provided for @partnerNoMood.
  ///
  /// In tr, this message translates to:
  /// **'Henüz mood girilmedi'**
  String get partnerNoMood;

  /// No description provided for @partnerHowToHelp.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl destek olabilirsin?'**
  String get partnerHowToHelp;

  /// No description provided for @partnerCWater.
  ///
  /// In tr, this message translates to:
  /// **'Su tüketimi düşük — bir bardak su getirebilirsin.'**
  String get partnerCWater;

  /// No description provided for @partnerCFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Son beslenme üzerinden uzun zaman geçti — sormak iyi olabilir.'**
  String get partnerCFeeding;

  /// No description provided for @partnerCMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood biraz düşük — sıcak bir sohbet veya kısa bir mola önerebilirsin.'**
  String get partnerCMood;

  /// No description provided for @partnerCSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku süresi az — bebeğe bir süreliğine sen bakabilirsin.'**
  String get partnerCSleep;

  /// No description provided for @partnerSupportTips.
  ///
  /// In tr, this message translates to:
  /// **'Destek önerileri'**
  String get partnerSupportTips;

  /// No description provided for @partnerTip1.
  ///
  /// In tr, this message translates to:
  /// **'Bebeğe 1-2 saat bakarak anneye dinlenme zamanı tanı.'**
  String get partnerTip1;

  /// No description provided for @partnerTip2.
  ///
  /// In tr, this message translates to:
  /// **'Su ve atıştırmalık hazırlayıp yanına bırak.'**
  String get partnerTip2;

  /// No description provided for @partnerTip3.
  ///
  /// In tr, this message translates to:
  /// **'Onu yargılamadan dinle — sadece orada olmak yeterli.'**
  String get partnerTip3;

  /// No description provided for @partnerTip4.
  ///
  /// In tr, this message translates to:
  /// **'Birkaç ev işini sessizce üstlen.'**
  String get partnerTip4;

  /// No description provided for @partnerSwitchRole.
  ///
  /// In tr, this message translates to:
  /// **'Rolü değiştir'**
  String get partnerSwitchRole;

  /// No description provided for @navDashboard.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navDashboard;

  /// No description provided for @navFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme'**
  String get navFeeding;

  /// No description provided for @navMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood'**
  String get navMood;

  /// No description provided for @navSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku'**
  String get navSleep;

  /// No description provided for @navExercise.
  ///
  /// In tr, this message translates to:
  /// **'Egzersiz'**
  String get navExercise;

  /// No description provided for @navNutrition.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme & Su'**
  String get navNutrition;

  /// No description provided for @navProgress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get navProgress;

  /// No description provided for @navReminders.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar'**
  String get navReminders;

  /// No description provided for @navCommunity.
  ///
  /// In tr, this message translates to:
  /// **'Topluluk'**
  String get navCommunity;

  /// No description provided for @navSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get navSettings;

  /// No description provided for @navMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha'**
  String get navMore;

  /// No description provided for @navVideos.
  ///
  /// In tr, this message translates to:
  /// **'Videolar'**
  String get navVideos;

  /// No description provided for @tabHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get tabHome;

  /// No description provided for @tabPrograms.
  ///
  /// In tr, this message translates to:
  /// **'Programlar'**
  String get tabPrograms;

  /// No description provided for @tabNutrition.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme'**
  String get tabNutrition;

  /// No description provided for @tabStats.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get tabStats;

  /// No description provided for @tabProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get tabProfile;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar hoş geldin'**
  String get homeWelcomeBack;

  /// No description provided for @homeMotivationToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün kendin için küçük bir adım at.'**
  String get homeMotivationToday;

  /// No description provided for @homeDiscoverFitness.
  ///
  /// In tr, this message translates to:
  /// **'Fitness & Pilates'**
  String get homeDiscoverFitness;

  /// No description provided for @homeDiscoverFitnessSub.
  ///
  /// In tr, this message translates to:
  /// **'Her seviye için antrenmanlar'**
  String get homeDiscoverFitnessSub;

  /// No description provided for @homeDiscoverNutrition.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı Beslenme'**
  String get homeDiscoverNutrition;

  /// No description provided for @homeDiscoverNutritionSub.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı alışkanlıklar, lezzetli tarifler'**
  String get homeDiscoverNutritionSub;

  /// No description provided for @homeDiscoverTips.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık Tüyoları'**
  String get homeDiscoverTips;

  /// No description provided for @homeDiscoverTipsSub.
  ///
  /// In tr, this message translates to:
  /// **'Pelvik sağlık, rutinler ve daha fazlası'**
  String get homeDiscoverTipsSub;

  /// No description provided for @homeDiscoverExplore.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get homeDiscoverExplore;

  /// No description provided for @homeRoutineSuggestions.
  ///
  /// In tr, this message translates to:
  /// **'Rutinine eklemek isteyebileceklerin'**
  String get homeRoutineSuggestions;

  /// No description provided for @homeNewPrograms.
  ///
  /// In tr, this message translates to:
  /// **'Yeni çıkan programlar'**
  String get homeNewPrograms;

  /// No description provided for @homeInviteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşını davet et, birbirinizi teşvik edin!'**
  String get homeInviteTitle;

  /// No description provided for @homeInviteBody.
  ///
  /// In tr, this message translates to:
  /// **'İlerleyen versiyonlarda arkadaşlarınla antrenmanlarını, beslenme alışkanlıklarını ve gelişimini takip edebileceksin.'**
  String get homeInviteBody;

  /// No description provided for @homeInviteCta.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşını davet et'**
  String get homeInviteCta;

  /// No description provided for @homeFavorites.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerin'**
  String get homeFavorites;

  /// No description provided for @homeFavoriteRecipes.
  ///
  /// In tr, this message translates to:
  /// **'Favori tarifler'**
  String get homeFavoriteRecipes;

  /// No description provided for @homeFavoriteRecipesSub.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı sağlıklı tariflerini gör'**
  String get homeFavoriteRecipesSub;

  /// No description provided for @homeFavoriteWorkouts.
  ///
  /// In tr, this message translates to:
  /// **'Favori workoutlar'**
  String get homeFavoriteWorkouts;

  /// No description provided for @homeFavoriteWorkoutsSub.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı programlarını ve rutinlerini gör'**
  String get homeFavoriteWorkoutsSub;

  /// No description provided for @homeCommunityIntro.
  ///
  /// In tr, this message translates to:
  /// **'Bizimle tanış'**
  String get homeCommunityIntro;

  /// No description provided for @homeCommunitySub.
  ///
  /// In tr, this message translates to:
  /// **'Topluluğumuza katıl ve yolculuğumuzu takip et!'**
  String get homeCommunitySub;

  /// No description provided for @homeStories.
  ///
  /// In tr, this message translates to:
  /// **'FitMama hikayeleri'**
  String get homeStories;

  /// No description provided for @homeAllStories.
  ///
  /// In tr, this message translates to:
  /// **'Tüm hikayeler'**
  String get homeAllStories;

  /// No description provided for @homeViewAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü gör'**
  String get homeViewAll;

  /// No description provided for @homeNewBadge.
  ///
  /// In tr, this message translates to:
  /// **'YENİ'**
  String get homeNewBadge;

  /// No description provided for @progLocationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nerede antrenman yapmak istersin?'**
  String get progLocationTitle;

  /// No description provided for @progLocationHome.
  ///
  /// In tr, this message translates to:
  /// **'Evde'**
  String get progLocationHome;

  /// No description provided for @progLocationHomeSub.
  ///
  /// In tr, this message translates to:
  /// **'Ekipmansız, etkili antrenmanlar'**
  String get progLocationHomeSub;

  /// No description provided for @progLocationGym.
  ///
  /// In tr, this message translates to:
  /// **'Salonda'**
  String get progLocationGym;

  /// No description provided for @progLocationGymSub.
  ///
  /// In tr, this message translates to:
  /// **'Ağırlık ve makine odaklı antrenmanlar'**
  String get progLocationGymSub;

  /// No description provided for @progLocationOutdoor.
  ///
  /// In tr, this message translates to:
  /// **'Dışarıda'**
  String get progLocationOutdoor;

  /// No description provided for @progLocationOutdoorSub.
  ///
  /// In tr, this message translates to:
  /// **'Yürüyüş, koşu ve açık hava aktiviteleri'**
  String get progLocationOutdoorSub;

  /// No description provided for @progContinueTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaldığın yerden devam et'**
  String get progContinueTitle;

  /// No description provided for @progContinue.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get progContinue;

  /// No description provided for @progCategories.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get progCategories;

  /// No description provided for @progCategoryRegion.
  ///
  /// In tr, this message translates to:
  /// **'Bölgesel'**
  String get progCategoryRegion;

  /// No description provided for @progCategoryGoal.
  ///
  /// In tr, this message translates to:
  /// **'Hedefsel'**
  String get progCategoryGoal;

  /// No description provided for @progCategoryType.
  ///
  /// In tr, this message translates to:
  /// **'Antrenman türü'**
  String get progCategoryType;

  /// No description provided for @progCategoryLevel.
  ///
  /// In tr, this message translates to:
  /// **'Seviye'**
  String get progCategoryLevel;

  /// No description provided for @progFeatured.
  ///
  /// In tr, this message translates to:
  /// **'Öne çıkan programlar'**
  String get progFeatured;

  /// No description provided for @progAiTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sana özel öneriler'**
  String get progAiTitle;

  /// No description provided for @progAiSub.
  ///
  /// In tr, this message translates to:
  /// **'Enerji seviyene ve hedeflerine göre bugün senin için önerilenler.'**
  String get progAiSub;

  /// No description provided for @progAiCta.
  ///
  /// In tr, this message translates to:
  /// **'Önerileri gör'**
  String get progAiCta;

  /// No description provided for @nutTabAll.
  ///
  /// In tr, this message translates to:
  /// **'Tüm tarifler'**
  String get nutTabAll;

  /// No description provided for @nutTabAirfryer.
  ///
  /// In tr, this message translates to:
  /// **'Airfryer tarifleri'**
  String get nutTabAirfryer;

  /// No description provided for @nutTabDessert.
  ///
  /// In tr, this message translates to:
  /// **'Fit tatlı tarifleri'**
  String get nutTabDessert;

  /// No description provided for @nutTabOther.
  ///
  /// In tr, this message translates to:
  /// **'Fit diğer tarifleri'**
  String get nutTabOther;

  /// No description provided for @nutPopular.
  ///
  /// In tr, this message translates to:
  /// **'Popüler tarifler'**
  String get nutPopular;

  /// No description provided for @nutWeekPlan.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık yemek planlaması'**
  String get nutWeekPlan;

  /// No description provided for @nutWeekPlanSub.
  ///
  /// In tr, this message translates to:
  /// **'Planla, pişir, zaman kazan!'**
  String get nutWeekPlanSub;

  /// No description provided for @nutMealBreakfast.
  ///
  /// In tr, this message translates to:
  /// **'Kahvaltı'**
  String get nutMealBreakfast;

  /// No description provided for @nutMealLunch.
  ///
  /// In tr, this message translates to:
  /// **'Öğle yemeği'**
  String get nutMealLunch;

  /// No description provided for @nutMealDinner.
  ///
  /// In tr, this message translates to:
  /// **'Akşam yemeği'**
  String get nutMealDinner;

  /// No description provided for @nutMealSnack.
  ///
  /// In tr, this message translates to:
  /// **'Ara öğün'**
  String get nutMealSnack;

  /// No description provided for @nutEditPlan.
  ///
  /// In tr, this message translates to:
  /// **'Planı düzenle'**
  String get nutEditPlan;

  /// No description provided for @nutMoreTitle.
  ///
  /// In tr, this message translates to:
  /// **'Daha fazlası'**
  String get nutMoreTitle;

  /// No description provided for @nutShoppingList.
  ///
  /// In tr, this message translates to:
  /// **'Alışveriş listesi'**
  String get nutShoppingList;

  /// No description provided for @nutShoppingListSub.
  ///
  /// In tr, this message translates to:
  /// **'İhtiyacın olan tüm malzemeleri listele.'**
  String get nutShoppingListSub;

  /// No description provided for @nutBlog.
  ///
  /// In tr, this message translates to:
  /// **'Blog yazıları'**
  String get nutBlog;

  /// No description provided for @nutBlogSub.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme, spor ve kadın sağlığı üzerine faydalı yazılar.'**
  String get nutBlogSub;

  /// No description provided for @nutNutrients.
  ///
  /// In tr, this message translates to:
  /// **'Besin değerlerini keşfet'**
  String get nutNutrients;

  /// No description provided for @nutFavorites.
  ///
  /// In tr, this message translates to:
  /// **'Favori tariflerim'**
  String get nutFavorites;

  /// No description provided for @nutPerServing.
  ///
  /// In tr, this message translates to:
  /// **'Değerler 1 porsiyon içindir.'**
  String get nutPerServing;

  /// No description provided for @statsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İstatistikler'**
  String get statsTitle;

  /// No description provided for @statsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kendini her geçen gün daha iyiye taşı!'**
  String get statsSubtitle;

  /// No description provided for @statsRangeWeek.
  ///
  /// In tr, this message translates to:
  /// **'Hafta'**
  String get statsRangeWeek;

  /// No description provided for @statsRangeMonth.
  ///
  /// In tr, this message translates to:
  /// **'Ay'**
  String get statsRangeMonth;

  /// No description provided for @statsRange3Month.
  ///
  /// In tr, this message translates to:
  /// **'3 Ay'**
  String get statsRange3Month;

  /// No description provided for @statsRangeYear.
  ///
  /// In tr, this message translates to:
  /// **'Yıl'**
  String get statsRangeYear;

  /// No description provided for @statsKpiCalories.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Kalori'**
  String get statsKpiCalories;

  /// No description provided for @statsKpiTime.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Süre'**
  String get statsKpiTime;

  /// No description provided for @statsKpiWorkouts.
  ///
  /// In tr, this message translates to:
  /// **'Antrenman'**
  String get statsKpiWorkouts;

  /// No description provided for @statsKpiActiveDays.
  ///
  /// In tr, this message translates to:
  /// **'Aktif Gün'**
  String get statsKpiActiveDays;

  /// No description provided for @statsSeans.
  ///
  /// In tr, this message translates to:
  /// **'seans'**
  String get statsSeans;

  /// No description provided for @statsGun.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get statsGun;

  /// No description provided for @statsMuscleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalıştırılan bölgeler'**
  String get statsMuscleTitle;

  /// No description provided for @statsMuscleDetail.
  ///
  /// In tr, this message translates to:
  /// **'Detaylı görünüm'**
  String get statsMuscleDetail;

  /// No description provided for @statsMuscleHip.
  ///
  /// In tr, this message translates to:
  /// **'Kalça'**
  String get statsMuscleHip;

  /// No description provided for @statsMuscleLegFront.
  ///
  /// In tr, this message translates to:
  /// **'Bacak (Ön)'**
  String get statsMuscleLegFront;

  /// No description provided for @statsMuscleLegBack.
  ///
  /// In tr, this message translates to:
  /// **'Bacak (Arka)'**
  String get statsMuscleLegBack;

  /// No description provided for @statsMuscleCore.
  ///
  /// In tr, this message translates to:
  /// **'Karın (Core)'**
  String get statsMuscleCore;

  /// No description provided for @statsMuscleBack.
  ///
  /// In tr, this message translates to:
  /// **'Sırt'**
  String get statsMuscleBack;

  /// No description provided for @statsMuscleShoulder.
  ///
  /// In tr, this message translates to:
  /// **'Omuz'**
  String get statsMuscleShoulder;

  /// No description provided for @statsLevelGreat.
  ///
  /// In tr, this message translates to:
  /// **'Çok İyi'**
  String get statsLevelGreat;

  /// No description provided for @statsLevelGood.
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get statsLevelGood;

  /// No description provided for @statsLevelOk.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get statsLevelOk;

  /// No description provided for @statsLevelStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get statsLevelStart;

  /// No description provided for @statsExtraTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ekstra çalışman gereken bölgeler'**
  String get statsExtraTitle;

  /// No description provided for @statsExtraCta.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen programlara göz at'**
  String get statsExtraCta;

  /// No description provided for @statsDistribution.
  ///
  /// In tr, this message translates to:
  /// **'Bölgeye göre dağılım'**
  String get statsDistribution;

  /// No description provided for @statsTotalWork.
  ///
  /// In tr, this message translates to:
  /// **'Toplam çalışma'**
  String get statsTotalWork;

  /// No description provided for @statsPerformance.
  ///
  /// In tr, this message translates to:
  /// **'Performans grafikleri'**
  String get statsPerformance;

  /// No description provided for @statsDetailedAnalysis.
  ///
  /// In tr, this message translates to:
  /// **'Detaylı analiz'**
  String get statsDetailedAnalysis;

  /// No description provided for @statsWater.
  ///
  /// In tr, this message translates to:
  /// **'Su tüketimi'**
  String get statsWater;

  /// No description provided for @statsWaterGoal.
  ///
  /// In tr, this message translates to:
  /// **'Hedef: 2.5 L'**
  String get statsWaterGoal;

  /// No description provided for @statsNutritionSummary.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme özeti'**
  String get statsNutritionSummary;

  /// No description provided for @statsDailyAvg.
  ///
  /// In tr, this message translates to:
  /// **'Günlük ortalama'**
  String get statsDailyAvg;

  /// No description provided for @statsProtein.
  ///
  /// In tr, this message translates to:
  /// **'Protein'**
  String get statsProtein;

  /// No description provided for @statsCarb.
  ///
  /// In tr, this message translates to:
  /// **'Karbonhidrat'**
  String get statsCarb;

  /// No description provided for @statsFat.
  ///
  /// In tr, this message translates to:
  /// **'Yağ'**
  String get statsFat;

  /// No description provided for @statsMacro.
  ///
  /// In tr, this message translates to:
  /// **'Makro dağılımı'**
  String get statsMacro;

  /// No description provided for @statsCalorieDistribution.
  ///
  /// In tr, this message translates to:
  /// **'Kalori dağılımı'**
  String get statsCalorieDistribution;

  /// No description provided for @statsAvgHeart.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama kalp atış'**
  String get statsAvgHeart;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profilim'**
  String get profileTitle;

  /// No description provided for @profileWorkouts.
  ///
  /// In tr, this message translates to:
  /// **'Antrenman'**
  String get profileWorkouts;

  /// No description provided for @profileWeeksWithFitmama.
  ///
  /// In tr, this message translates to:
  /// **'FitMama\'da hafta'**
  String get profileWeeksWithFitmama;

  /// No description provided for @profileAchievements.
  ///
  /// In tr, this message translates to:
  /// **'Başarımlar'**
  String get profileAchievements;

  /// No description provided for @profileMyProgress.
  ///
  /// In tr, this message translates to:
  /// **'Gelişimim'**
  String get profileMyProgress;

  /// No description provided for @profileFocusAreas.
  ///
  /// In tr, this message translates to:
  /// **'Odak alanları'**
  String get profileFocusAreas;

  /// No description provided for @profileMamaTools.
  ///
  /// In tr, this message translates to:
  /// **'Mama araçları'**
  String get profileMamaTools;

  /// No description provided for @profileMamaToolsSub.
  ///
  /// In tr, this message translates to:
  /// **'Anne-bebek günlük takip ekranları'**
  String get profileMamaToolsSub;

  /// No description provided for @profileToolFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme logları'**
  String get profileToolFeeding;

  /// No description provided for @profileToolSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku takibi'**
  String get profileToolSleep;

  /// No description provided for @profileToolMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood günlüğü'**
  String get profileToolMood;

  /// No description provided for @profileToolMilestones.
  ///
  /// In tr, this message translates to:
  /// **'Bebek gelişim adımları'**
  String get profileToolMilestones;

  /// No description provided for @profileToolRecovery.
  ///
  /// In tr, this message translates to:
  /// **'Recovery zaman çizelgesi'**
  String get profileToolRecovery;

  /// No description provided for @profileToolKegel.
  ///
  /// In tr, this message translates to:
  /// **'Kegel egzersizleri'**
  String get profileToolKegel;

  /// No description provided for @profileToolPartner.
  ///
  /// In tr, this message translates to:
  /// **'Partner yönetimi'**
  String get profileToolPartner;

  /// No description provided for @profileToolReminders.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcılar'**
  String get profileToolReminders;

  /// No description provided for @profileToolBreathing.
  ///
  /// In tr, this message translates to:
  /// **'Nefes egzersizi'**
  String get profileToolBreathing;

  /// No description provided for @profileToolCommunity.
  ///
  /// In tr, this message translates to:
  /// **'Topluluk'**
  String get profileToolCommunity;

  /// No description provided for @profileToolVideos.
  ///
  /// In tr, this message translates to:
  /// **'Videolar'**
  String get profileToolVideos;

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldin anne'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeSub.
  ///
  /// In tr, this message translates to:
  /// **'Doğum sonrası iyileşme yolculuğunda sana eşlik edeceğiz. Birkaç bilgiyle başlayalım.'**
  String get onbWelcomeSub;

  /// No description provided for @onbStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get onbStart;

  /// No description provided for @onbNext.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get onbNext;

  /// No description provided for @onbBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get onbBack;

  /// No description provided for @onbFinish.
  ///
  /// In tr, this message translates to:
  /// **'Bitir'**
  String get onbFinish;

  /// No description provided for @onbName.
  ///
  /// In tr, this message translates to:
  /// **'Adın'**
  String get onbName;

  /// No description provided for @onbNamePh.
  ///
  /// In tr, this message translates to:
  /// **'Örn. Ayşe'**
  String get onbNamePh;

  /// No description provided for @onbBirthDate.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi (bebeğin)'**
  String get onbBirthDate;

  /// No description provided for @onbBirthType.
  ///
  /// In tr, this message translates to:
  /// **'Doğum şekli'**
  String get onbBirthType;

  /// No description provided for @onbNormal.
  ///
  /// In tr, this message translates to:
  /// **'Normal'**
  String get onbNormal;

  /// No description provided for @onbCsection.
  ///
  /// In tr, this message translates to:
  /// **'Sezaryen'**
  String get onbCsection;

  /// No description provided for @onbPreferences.
  ///
  /// In tr, this message translates to:
  /// **'Tercihlerin'**
  String get onbPreferences;

  /// No description provided for @onbPreferencesSub.
  ///
  /// In tr, this message translates to:
  /// **'Sana daha iyi öneri sunabilmemiz için birkaç şeyi işaretle.'**
  String get onbPreferencesSub;

  /// No description provided for @onbHealthLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık durumun'**
  String get onbHealthLabel;

  /// No description provided for @onbHBp.
  ///
  /// In tr, this message translates to:
  /// **'Tansiyon'**
  String get onbHBp;

  /// No description provided for @onbHDiabetes.
  ///
  /// In tr, this message translates to:
  /// **'Diyabet'**
  String get onbHDiabetes;

  /// No description provided for @onbHThyroid.
  ///
  /// In tr, this message translates to:
  /// **'Tiroid'**
  String get onbHThyroid;

  /// No description provided for @onbHAnemia.
  ///
  /// In tr, this message translates to:
  /// **'Anemi'**
  String get onbHAnemia;

  /// No description provided for @onbHPpd.
  ///
  /// In tr, this message translates to:
  /// **'Doğum sonrası depresyon'**
  String get onbHPpd;

  /// No description provided for @onbHBack.
  ///
  /// In tr, this message translates to:
  /// **'Bel ağrısı'**
  String get onbHBack;

  /// No description provided for @onbHIncision.
  ///
  /// In tr, this message translates to:
  /// **'İyileşmemiş yara'**
  String get onbHIncision;

  /// No description provided for @onbAllergenLabel.
  ///
  /// In tr, this message translates to:
  /// **'Alerjilerin'**
  String get onbAllergenLabel;

  /// No description provided for @onbAMilk.
  ///
  /// In tr, this message translates to:
  /// **'Süt'**
  String get onbAMilk;

  /// No description provided for @onbAEgg.
  ///
  /// In tr, this message translates to:
  /// **'Yumurta'**
  String get onbAEgg;

  /// No description provided for @onbANuts.
  ///
  /// In tr, this message translates to:
  /// **'Kuruyemiş'**
  String get onbANuts;

  /// No description provided for @onbAGluten.
  ///
  /// In tr, this message translates to:
  /// **'Gluten'**
  String get onbAGluten;

  /// No description provided for @onbASeafood.
  ///
  /// In tr, this message translates to:
  /// **'Deniz ürünü'**
  String get onbASeafood;

  /// No description provided for @onbASoy.
  ///
  /// In tr, this message translates to:
  /// **'Soya'**
  String get onbASoy;

  /// No description provided for @onbDislikeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yemediğin yiyecekler'**
  String get onbDislikeLabel;

  /// No description provided for @onbDMeat.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı et'**
  String get onbDMeat;

  /// No description provided for @onbDFish.
  ///
  /// In tr, this message translates to:
  /// **'Balık'**
  String get onbDFish;

  /// No description provided for @onbDVeg.
  ///
  /// In tr, this message translates to:
  /// **'Sebze'**
  String get onbDVeg;

  /// No description provided for @onbDSpicy.
  ///
  /// In tr, this message translates to:
  /// **'Acılı'**
  String get onbDSpicy;

  /// No description provided for @onbDDairy.
  ///
  /// In tr, this message translates to:
  /// **'Süt ürünleri'**
  String get onbDDairy;

  /// No description provided for @onbDLegumes.
  ///
  /// In tr, this message translates to:
  /// **'Baklagiller'**
  String get onbDLegumes;

  /// No description provided for @onbFeedingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme düzeni (bebek)'**
  String get onbFeedingLabel;

  /// No description provided for @onbFBreast.
  ///
  /// In tr, this message translates to:
  /// **'Anne sütü'**
  String get onbFBreast;

  /// No description provided for @onbFBottle.
  ///
  /// In tr, this message translates to:
  /// **'Biberon'**
  String get onbFBottle;

  /// No description provided for @onbFMixed.
  ///
  /// In tr, this message translates to:
  /// **'Karışık'**
  String get onbFMixed;

  /// No description provided for @onbFPump.
  ///
  /// In tr, this message translates to:
  /// **'Sağma'**
  String get onbFPump;

  /// No description provided for @onbOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get onbOther;

  /// No description provided for @onbOtherPh.
  ///
  /// In tr, this message translates to:
  /// **'Diğer (yazarak ekle)'**
  String get onbOtherPh;

  /// No description provided for @onbGoals.
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerini seç'**
  String get onbGoals;

  /// No description provided for @onbGoalSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku düzenini iyileştir'**
  String get onbGoalSleep;

  /// No description provided for @onbGoalWeight.
  ///
  /// In tr, this message translates to:
  /// **'Kilo ver'**
  String get onbGoalWeight;

  /// No description provided for @onbGoalMove.
  ///
  /// In tr, this message translates to:
  /// **'Günlük hareket artır'**
  String get onbGoalMove;

  /// No description provided for @onbGoalMood.
  ///
  /// In tr, this message translates to:
  /// **'Ruh halini takip et'**
  String get onbGoalMood;

  /// No description provided for @onbGoalFeed.
  ///
  /// In tr, this message translates to:
  /// **'Emzirme düzeni oluştur'**
  String get onbGoalFeed;

  /// No description provided for @onbSaved.
  ///
  /// In tr, this message translates to:
  /// **'Profilin kaydedildi'**
  String get onbSaved;

  /// No description provided for @dashHello.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba'**
  String get dashHello;

  /// No description provided for @dashLastFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Son beslenme'**
  String get dashLastFeeding;

  /// No description provided for @dashNextFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki beslenme'**
  String get dashNextFeeding;

  /// No description provided for @dashWater.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get dashWater;

  /// No description provided for @dashMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood'**
  String get dashMood;

  /// No description provided for @dashSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku'**
  String get dashSleep;

  /// No description provided for @dashActivity.
  ///
  /// In tr, this message translates to:
  /// **'Hareket'**
  String get dashActivity;

  /// No description provided for @dashNoFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Henüz beslenme yok'**
  String get dashNoFeeding;

  /// No description provided for @dashAddFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme ekle'**
  String get dashAddFeeding;

  /// No description provided for @dashLogMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood gir'**
  String get dashLogMood;

  /// No description provided for @dashAddSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku ekle'**
  String get dashAddSleep;

  /// No description provided for @dashAddExercise.
  ///
  /// In tr, this message translates to:
  /// **'Egzersiz ekle'**
  String get dashAddExercise;

  /// No description provided for @dashTips.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün önerileri'**
  String get dashTips;

  /// No description provided for @dashTip1.
  ///
  /// In tr, this message translates to:
  /// **'Bugün hafif yoga öneriliyor.'**
  String get dashTip1;

  /// No description provided for @dashTip2.
  ///
  /// In tr, this message translates to:
  /// **'Son beslenmeden sonra {h} saat geçti.'**
  String dashTip2(int h);

  /// No description provided for @dashTip3.
  ///
  /// In tr, this message translates to:
  /// **'Bugün su tüketimin düşük, bir bardak su iç.'**
  String get dashTip3;

  /// No description provided for @dashTip4.
  ///
  /// In tr, this message translates to:
  /// **'Kısa bir nefes egzersizi seni rahatlatabilir.'**
  String get dashTip4;

  /// No description provided for @dashMinAgo.
  ///
  /// In tr, this message translates to:
  /// **'{m} dk önce'**
  String dashMinAgo(int m);

  /// No description provided for @dashHAgo.
  ///
  /// In tr, this message translates to:
  /// **'{h} sa önce'**
  String dashHAgo(int h);

  /// No description provided for @dashInMin.
  ///
  /// In tr, this message translates to:
  /// **'{m} dk sonra'**
  String dashInMin(int m);

  /// No description provided for @dashCups.
  ///
  /// In tr, this message translates to:
  /// **'{n} bardak'**
  String dashCups(int n);

  /// No description provided for @feedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bebek Beslenme'**
  String get feedTitle;

  /// No description provided for @feedTimer.
  ///
  /// In tr, this message translates to:
  /// **'Zamanlayıcı'**
  String get feedTimer;

  /// No description provided for @feedLeft.
  ///
  /// In tr, this message translates to:
  /// **'Sol'**
  String get feedLeft;

  /// No description provided for @feedRight.
  ///
  /// In tr, this message translates to:
  /// **'Sağ'**
  String get feedRight;

  /// No description provided for @feedBottle.
  ///
  /// In tr, this message translates to:
  /// **'Biberon'**
  String get feedBottle;

  /// No description provided for @feedStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlat'**
  String get feedStart;

  /// No description provided for @feedStop.
  ///
  /// In tr, this message translates to:
  /// **'Durdur'**
  String get feedStop;

  /// No description provided for @feedSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get feedSave;

  /// No description provided for @feedAmount.
  ///
  /// In tr, this message translates to:
  /// **'Miktar (ml)'**
  String get feedAmount;

  /// No description provided for @feedHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get feedHistory;

  /// No description provided for @feedWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get feedWeekly;

  /// No description provided for @feedNoEntries.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıt yok'**
  String get feedNoEntries;

  /// No description provided for @feedMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{n} dk'**
  String feedMinutes(int n);

  /// No description provided for @feedDeleteConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu kaydı silmek istiyor musun?'**
  String get feedDeleteConfirm;

  /// No description provided for @moodTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mood Takibi'**
  String get moodTitle;

  /// No description provided for @moodTodayQ.
  ///
  /// In tr, this message translates to:
  /// **'Bugün nasıl hissediyorsun?'**
  String get moodTodayQ;

  /// No description provided for @moodHappy.
  ///
  /// In tr, this message translates to:
  /// **'Mutlu'**
  String get moodHappy;

  /// No description provided for @moodTired.
  ///
  /// In tr, this message translates to:
  /// **'Yorgun'**
  String get moodTired;

  /// No description provided for @moodStressed.
  ///
  /// In tr, this message translates to:
  /// **'Stresli'**
  String get moodStressed;

  /// No description provided for @moodAnxious.
  ///
  /// In tr, this message translates to:
  /// **'Kaygılı'**
  String get moodAnxious;

  /// No description provided for @moodEnergetic.
  ///
  /// In tr, this message translates to:
  /// **'Enerjik'**
  String get moodEnergetic;

  /// No description provided for @moodNote.
  ///
  /// In tr, this message translates to:
  /// **'Kısa not'**
  String get moodNote;

  /// No description provided for @moodNotePh.
  ///
  /// In tr, this message translates to:
  /// **'Bugün hakkında bir şey yaz…'**
  String get moodNotePh;

  /// No description provided for @moodSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get moodSave;

  /// No description provided for @moodHistory.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get moodHistory;

  /// No description provided for @moodSupport.
  ///
  /// In tr, this message translates to:
  /// **'Bugün biraz zor görünüyor. Sana iyi gelebilecek şeyler:'**
  String get moodSupport;

  /// No description provided for @moodBreathing.
  ///
  /// In tr, this message translates to:
  /// **'Nefes egzersizi'**
  String get moodBreathing;

  /// No description provided for @moodMotivation.
  ///
  /// In tr, this message translates to:
  /// **'Sen harikasın. Bu zorlu dönemde yapabildiğin her şey değerli. Kendine zaman tanı.'**
  String get moodMotivation;

  /// No description provided for @breathTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nefes Egzersizi'**
  String get breathTitle;

  /// No description provided for @breathDesc.
  ///
  /// In tr, this message translates to:
  /// **'4 saniye nefes al, 4 saniye tut, 4 saniye ver.'**
  String get breathDesc;

  /// No description provided for @breathInhale.
  ///
  /// In tr, this message translates to:
  /// **'Nefes Al'**
  String get breathInhale;

  /// No description provided for @breathHold.
  ///
  /// In tr, this message translates to:
  /// **'Tut'**
  String get breathHold;

  /// No description provided for @breathExhale.
  ///
  /// In tr, this message translates to:
  /// **'Nefes Ver'**
  String get breathExhale;

  /// No description provided for @breathStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlat'**
  String get breathStart;

  /// No description provided for @breathStop.
  ///
  /// In tr, this message translates to:
  /// **'Durdur'**
  String get breathStop;

  /// No description provided for @breathCalmHint.
  ///
  /// In tr, this message translates to:
  /// **'🌸 Yumuşak, sakin ve düzenli bir nefes seni rahatlatabilir.'**
  String get breathCalmHint;

  /// No description provided for @sleepTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uyku Takibi'**
  String get sleepTitle;

  /// No description provided for @sleepMom.
  ///
  /// In tr, this message translates to:
  /// **'Anne'**
  String get sleepMom;

  /// No description provided for @sleepBaby.
  ///
  /// In tr, this message translates to:
  /// **'Bebek'**
  String get sleepBaby;

  /// No description provided for @sleepAddSession.
  ///
  /// In tr, this message translates to:
  /// **'Uyku ekle'**
  String get sleepAddSession;

  /// No description provided for @sleepStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get sleepStart;

  /// No description provided for @sleepEnd.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş'**
  String get sleepEnd;

  /// No description provided for @sleepQuality.
  ///
  /// In tr, this message translates to:
  /// **'Kalite'**
  String get sleepQuality;

  /// No description provided for @sleepSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get sleepSave;

  /// No description provided for @sleepToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün toplam'**
  String get sleepToday;

  /// No description provided for @sleepWeekly.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık'**
  String get sleepWeekly;

  /// No description provided for @sleepNoEntries.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt yok'**
  String get sleepNoEntries;

  /// No description provided for @exTitle.
  ///
  /// In tr, this message translates to:
  /// **'Egzersiz'**
  String get exTitle;

  /// No description provided for @exQuickMode.
  ///
  /// In tr, this message translates to:
  /// **'5 dk hızlı mod'**
  String get exQuickMode;

  /// No description provided for @exCategories.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get exCategories;

  /// No description provided for @exYoga.
  ///
  /// In tr, this message translates to:
  /// **'Hafif Yoga'**
  String get exYoga;

  /// No description provided for @exStretch.
  ///
  /// In tr, this message translates to:
  /// **'Esneme'**
  String get exStretch;

  /// No description provided for @exBreath.
  ///
  /// In tr, this message translates to:
  /// **'Nefes'**
  String get exBreath;

  /// No description provided for @exPelvic.
  ///
  /// In tr, this message translates to:
  /// **'Pelvik Taban'**
  String get exPelvic;

  /// No description provided for @exWalk.
  ///
  /// In tr, this message translates to:
  /// **'Yürüyüş'**
  String get exWalk;

  /// No description provided for @exPosture.
  ///
  /// In tr, this message translates to:
  /// **'Postür'**
  String get exPosture;

  /// No description provided for @exAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get exAll;

  /// No description provided for @exMarkDone.
  ///
  /// In tr, this message translates to:
  /// **'Tamamlandı işaretle'**
  String get exMarkDone;

  /// No description provided for @exWeeklyDone.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta tamamlanan'**
  String get exWeeklyDone;

  /// No description provided for @exCsectionNote.
  ///
  /// In tr, this message translates to:
  /// **'Sezaryen sonrası ilk 6 hafta için doktoruna danışmadan yoğun egzersiz yapma.'**
  String get exCsectionNote;

  /// No description provided for @exSummary.
  ///
  /// In tr, this message translates to:
  /// **'{count} egzersiz · {mins} dk'**
  String exSummary(int count, int mins);

  /// No description provided for @nutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme & Su'**
  String get nutTitle;

  /// No description provided for @nutWater.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get nutWater;

  /// No description provided for @nutGoal.
  ///
  /// In tr, this message translates to:
  /// **'Günlük hedef: {n} bardak'**
  String nutGoal(int n);

  /// No description provided for @nutMeals.
  ///
  /// In tr, this message translates to:
  /// **'Öğünler'**
  String get nutMeals;

  /// No description provided for @nutMealNamePh.
  ///
  /// In tr, this message translates to:
  /// **'Örn. kahvaltı'**
  String get nutMealNamePh;

  /// No description provided for @nutSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get nutSave;

  /// No description provided for @nutWhatToEat.
  ///
  /// In tr, this message translates to:
  /// **'Bugün ne yemeliyim?'**
  String get nutWhatToEat;

  /// No description provided for @nutCupsOf.
  ///
  /// In tr, this message translates to:
  /// **'/ {n} bardak'**
  String nutCupsOf(int n);

  /// No description provided for @remTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar'**
  String get remTitle;

  /// No description provided for @remEnable.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri etkinleştir'**
  String get remEnable;

  /// No description provided for @remEnabled.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler açık'**
  String get remEnabled;

  /// No description provided for @remDenied.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim izni reddedildi'**
  String get remDenied;

  /// No description provided for @remFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme'**
  String get remFeeding;

  /// No description provided for @remWater.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get remWater;

  /// No description provided for @remSleep.
  ///
  /// In tr, this message translates to:
  /// **'Dinlenme'**
  String get remSleep;

  /// No description provided for @remExercise.
  ///
  /// In tr, this message translates to:
  /// **'Egzersiz'**
  String get remExercise;

  /// No description provided for @remMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood girişi'**
  String get remMood;

  /// No description provided for @remDoctor.
  ///
  /// In tr, this message translates to:
  /// **'Doktor kontrolü'**
  String get remDoctor;

  /// No description provided for @remEvery.
  ///
  /// In tr, this message translates to:
  /// **'Her {n} dakikada bir'**
  String remEvery(int n);

  /// No description provided for @progTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get progTitle;

  /// No description provided for @progWeight.
  ///
  /// In tr, this message translates to:
  /// **'Kilo'**
  String get progWeight;

  /// No description provided for @progWeightKg.
  ///
  /// In tr, this message translates to:
  /// **'Kilo (kg)'**
  String get progWeightKg;

  /// No description provided for @progSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku'**
  String get progSleep;

  /// No description provided for @progMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood'**
  String get progMood;

  /// No description provided for @progFeeding.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme'**
  String get progFeeding;

  /// No description provided for @progExercise.
  ///
  /// In tr, this message translates to:
  /// **'Egzersiz'**
  String get progExercise;

  /// No description provided for @progNoData.
  ///
  /// In tr, this message translates to:
  /// **'Yeterli veri yok'**
  String get progNoData;

  /// No description provided for @comTitle.
  ///
  /// In tr, this message translates to:
  /// **'Topluluk'**
  String get comTitle;

  /// No description provided for @comExperts.
  ///
  /// In tr, this message translates to:
  /// **'Uzman önerileri'**
  String get comExperts;

  /// No description provided for @comStories.
  ///
  /// In tr, this message translates to:
  /// **'Deneyim paylaşımları'**
  String get comStories;

  /// No description provided for @comLessons.
  ///
  /// In tr, this message translates to:
  /// **'Mini eğitimler'**
  String get comLessons;

  /// No description provided for @comComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Yakında: canlı sohbet ve uzman yayınları'**
  String get comComingSoon;

  /// No description provided for @setTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get setTitle;

  /// No description provided for @setEditProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili düzenle'**
  String get setEditProfile;

  /// No description provided for @setLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get setLanguage;

  /// No description provided for @setTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get setTheme;

  /// No description provided for @setLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get setLight;

  /// No description provided for @setDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get setDark;

  /// No description provided for @setData.
  ///
  /// In tr, this message translates to:
  /// **'Veri'**
  String get setData;

  /// No description provided for @setExport.
  ///
  /// In tr, this message translates to:
  /// **'Verileri dışa aktar'**
  String get setExport;

  /// No description provided for @setImport.
  ///
  /// In tr, this message translates to:
  /// **'Verileri içe aktar'**
  String get setImport;

  /// No description provided for @setReset.
  ///
  /// In tr, this message translates to:
  /// **'Tüm verileri sıfırla'**
  String get setReset;

  /// No description provided for @setResetConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Tüm veriler silinecek. Emin misin?'**
  String get setResetConfirm;

  /// No description provided for @setPairTitle.
  ///
  /// In tr, this message translates to:
  /// **'Partner eşleşme kodu'**
  String get setPairTitle;

  /// No description provided for @setPairDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bu kodu partnerinle paylaş; karşılama ekranında bu kodu girerek hesabına bağlanabilir.'**
  String get setPairDesc;

  /// No description provided for @setYourCode.
  ///
  /// In tr, this message translates to:
  /// **'Senin kodun'**
  String get setYourCode;

  /// No description provided for @setGenerate.
  ///
  /// In tr, this message translates to:
  /// **'Kod oluştur'**
  String get setGenerate;

  /// No description provided for @setRegen.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden oluştur'**
  String get setRegen;

  /// No description provided for @setCopy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get setCopy;

  /// No description provided for @setCodeGenerated.
  ///
  /// In tr, this message translates to:
  /// **'Kod oluşturuldu'**
  String get setCodeGenerated;

  /// No description provided for @setCodeCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kod kopyalandı'**
  String get setCodeCopied;

  /// No description provided for @vidTitle.
  ///
  /// In tr, this message translates to:
  /// **'Videolu Egzersizler'**
  String get vidTitle;

  /// No description provided for @vidHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Seviyeli postpartum egzersizler'**
  String get vidHeadline;

  /// No description provided for @vidSub.
  ///
  /// In tr, this message translates to:
  /// **'Kendi temponda ilerle, her seviyeyi tamamladıkça yeni seviye açılır.'**
  String get vidSub;

  /// No description provided for @vidLevel.
  ///
  /// In tr, this message translates to:
  /// **'Seviye'**
  String get vidLevel;

  /// No description provided for @vidL1Name.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get vidL1Name;

  /// No description provided for @vidL2Name.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get vidL2Name;

  /// No description provided for @vidL3Name.
  ///
  /// In tr, this message translates to:
  /// **'İleri'**
  String get vidL3Name;

  /// No description provided for @vidL1Desc.
  ///
  /// In tr, this message translates to:
  /// **'Doğumdan sonra ilk haftalar için yumuşak nefes, esneme ve pelvik farkındalık.'**
  String get vidL1Desc;

  /// No description provided for @vidL2Desc.
  ///
  /// In tr, this message translates to:
  /// **'4-6. haftadan sonra hafif yoga, postür ve düşük etkili kardiyo.'**
  String get vidL2Desc;

  /// No description provided for @vidL3Desc.
  ///
  /// In tr, this message translates to:
  /// **'8+ hafta sonrası, doktor onayıyla daha enerjik tüm vücut çalışmaları.'**
  String get vidL3Desc;

  /// No description provided for @vidOpenInYoutube.
  ///
  /// In tr, this message translates to:
  /// **'YouTube\'da aç'**
  String get vidOpenInYoutube;

  /// No description provided for @proBadge.
  ///
  /// In tr, this message translates to:
  /// **'FitMama Pro'**
  String get proBadge;

  /// No description provided for @proTitle.
  ///
  /// In tr, this message translates to:
  /// **'Detaylı ilerleme analizi'**
  String get proTitle;

  /// No description provided for @proSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kilo, uyku, mood ve egzersiz trendlerini haftalık grafiklerle gör.'**
  String get proSubtitle;

  /// No description provided for @proF1.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız geçmiş ve haftalık grafikler'**
  String get proF1;

  /// No description provided for @proF2.
  ///
  /// In tr, this message translates to:
  /// **'Kilo, uyku ve mood trend analizi'**
  String get proF2;

  /// No description provided for @proF3.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme ve egzersiz devamlılık raporu'**
  String get proF3;

  /// No description provided for @proF4.
  ///
  /// In tr, this message translates to:
  /// **'Reklamsız deneyim'**
  String get proF4;

  /// No description provided for @proPrice.
  ///
  /// In tr, this message translates to:
  /// **'Pro üyelik'**
  String get proPrice;

  /// No description provided for @proMonth.
  ///
  /// In tr, this message translates to:
  /// **'ay'**
  String get proMonth;

  /// No description provided for @proCta.
  ///
  /// In tr, this message translates to:
  /// **'Pro\'ya geç'**
  String get proCta;

  /// No description provided for @proNote.
  ///
  /// In tr, this message translates to:
  /// **'Demo: bu sürümde ödeme alınmaz.'**
  String get proNote;

  /// No description provided for @recTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sana özel öneriler'**
  String get recTitle;

  /// No description provided for @recFood.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme'**
  String get recFood;

  /// No description provided for @recMood.
  ///
  /// In tr, this message translates to:
  /// **'Mood'**
  String get recMood;

  /// No description provided for @recExercise.
  ///
  /// In tr, this message translates to:
  /// **'Egzersiz'**
  String get recExercise;

  /// No description provided for @recLogMeal.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get recLogMeal;

  /// No description provided for @recLogMood.
  ///
  /// In tr, this message translates to:
  /// **'Gir'**
  String get recLogMood;

  /// No description provided for @recTryNow.
  ///
  /// In tr, this message translates to:
  /// **'Dene'**
  String get recTryNow;

  /// No description provided for @recStart.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get recStart;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get commonSave;

  /// No description provided for @commonClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get commonClose;

  /// No description provided for @commonMinutes.
  ///
  /// In tr, this message translates to:
  /// **'dk'**
  String get commonMinutes;

  /// No description provided for @commonHours.
  ///
  /// In tr, this message translates to:
  /// **'sa'**
  String get commonHours;

  /// No description provided for @milestoneTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bebek Gelişimi'**
  String get milestoneTitle;

  /// No description provided for @milestoneAge.
  ///
  /// In tr, this message translates to:
  /// **'{w} haftalık'**
  String milestoneAge(int w);

  /// No description provided for @milestoneAgeMonths.
  ///
  /// In tr, this message translates to:
  /// **'{m} aylık'**
  String milestoneAgeMonths(int m);

  /// No description provided for @recoveryTitle.
  ///
  /// In tr, this message translates to:
  /// **'İyileşme Yolculuğun'**
  String get recoveryTitle;

  /// No description provided for @recoveryWeek.
  ///
  /// In tr, this message translates to:
  /// **'{n}. hafta'**
  String recoveryWeek(int n);

  /// No description provided for @affirmationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün motivasyonu'**
  String get affirmationTitle;

  /// No description provided for @kegelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kegel egzersizi'**
  String get kegelTitle;

  /// No description provided for @kegelDesc.
  ///
  /// In tr, this message translates to:
  /// **'Pelvik tabanı sıkıp gevşeterek güçlendir.'**
  String get kegelDesc;

  /// No description provided for @kegelSqueeze.
  ///
  /// In tr, this message translates to:
  /// **'Sık'**
  String get kegelSqueeze;

  /// No description provided for @kegelRelease.
  ///
  /// In tr, this message translates to:
  /// **'Bırak'**
  String get kegelRelease;

  /// No description provided for @waterQuickAdd.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı su'**
  String get waterQuickAdd;

  /// No description provided for @feedingReminderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme hatırlatması'**
  String get feedingReminderTitle;

  /// No description provided for @feedingReminderBody.
  ///
  /// In tr, this message translates to:
  /// **'Bebeği beslemenin zamanı geldi olabilir.'**
  String get feedingReminderBody;

  /// No description provided for @waterReminderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Su hatırlatması'**
  String get waterReminderTitle;

  /// No description provided for @waterReminderBody.
  ///
  /// In tr, this message translates to:
  /// **'Bir bardak su içmeyi unutma.'**
  String get waterReminderBody;
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
    'bn',
    'de',
    'en',
    'es',
    'fa',
    'fil',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pl',
    'pt',
    'ru',
    'tr',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
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
