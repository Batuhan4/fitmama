# FitMama Rebrand & 5-Tab IA — Design Spec

**Date:** 2026-05-17
**Project:** momrise (Flutter) → **FitMama**
**Scope:** Tam görsel kimlik değişimi + 5-tab bilgi mimarisi + mevcut postpartum özelliklerinin yeni yapıya migration'ı.

## 1. Marka

- **İsim:** `FitMama`
- **Wordmark:** "Fit" hot-pink (#FF2E7E), "Mama" theme foreground (dark: warm white, light: ink).
- **Logo işareti:** Stilize kalp + nabız çizgisi (heart + ECG pulse), primary renkte.
- **Tagline (opsiyonel):** "Stronger After Birth" / "Doğumdan sonra daha güçlü."
- **Display name (Android/iOS/Web):** `FitMama`
- **Dart package adı:** `fitmama` (paket adı dahil tam rebrand).
- **Bundle ID / Application ID:** Şimdilik mevcut kalır (cihazda kurulu sürümü orphan etmemek için). Production öncesi `com.fitmama.app` olarak değiştirilebilir.

## 2. Tema Token'ları

### 2.1 Renk paleti

| Token              | Light       | Dark        | Not                                   |
|--------------------|-------------|-------------|---------------------------------------|
| `primary`          | `#FF2E7E`   | `#FF2E7E`   | Hot magenta — CTA, pill, accent       |
| `primarySoft`      | `#FF6FB1`   | `#FF6FB1`   | Hover/secondary action                |
| `primaryDeep`      | `#E91E63`   | `#FF1493`   | Bastırılmış vurgu                     |
| `background`       | `#FFFFFF`   | `#0A0309`   | Ana zemin                             |
| `surface`          | `#FFFFFF`   | `#1A0F13`   | Kart                                  |
| `surfaceRaised`    | `#FDF2F7`   | `#26161D`   | Kabarık kart (selected, raised)       |
| `foreground`       | `#1A0309`   | `#F7E8F0`   | Ana metin                             |
| `mutedForeground`  | `#7A5560`   | `#B89BB0`   | İkincil metin                         |
| `border`           | `#F0DEE6`   | `#3A1F2A`   | Hairline                              |
| `success`          | `#22C55E`   | `#4ADE80`   | Yeşil                                 |
| `warning`          | `#F59E0B`   | `#FBBF24`   | Amber                                 |
| `destructive`      | `#DC2626`   | `#F87171`   | Kırmızı                               |
| `accentOrange`     | `#FB923C`   | `#FB923C`   | İkon variety (Yağ, HIIT)              |
| `accentPurple`     | `#A78BFA`   | `#C4B5FD`   | İkon variety (Pilates, Yoga)          |
| `accentGreen`      | `#34D399`   | `#34D399`   | İkon variety (Walking, Esneme)        |
| `accentBlue`       | `#60A5FA`   | `#60A5FA`   | İkon variety (Su, Mavi seri)          |

### 2.2 Tipografi

Inter ailesi (zaten yüklü). Display'lerde 800 weight, letter-spacing -0.8.

| Style              | Font | Weight | Size  | Letter   |
|--------------------|------|--------|-------|----------|
| `displayLarge`     | Inter| 800    | 36-44 | -0.8     |
| `displayMedium`    | Inter| 800    | 30    | -0.6     |
| `headlineLarge`    | Inter| 800    | 24    | -0.5     |
| `headlineMedium`   | Inter| 700    | 20    | -0.3     |
| `titleLarge`       | Inter| 700    | 17    | -0.2     |
| `bodyLarge`        | Inter| 500    | 15    | 0        |
| `bodyMedium`       | Inter| 400    | 14    | 0        |
| `labelLarge`       | Inter| 600    | 13    | 0.1      |

### 2.3 Spacing & shape

- Card radius: **18px** (büyük kartlar 24px)
- Button radius: **999px** (full pill) for primary CTA, 14px for secondary
- Card border: 1px `border` color
- Chip radius: 999px
- Bottom nav height: 72px (with safe area)

## 3. Bilgi Mimarisi — 5 Tab

Bottom nav: **Ana Sayfa · Programlar · Beslenme · İstatistikler · Profil**

(Tips bottom nav'da DEĞİL — Ana Sayfa'da "Sağlık Tüyoları" kartı altında.)

### 3.1 Ana Sayfa (`/home`)

Yapı, yukarıdan aşağıya:
1. TopBar: FitMama logo + bildirim + avatar
2. Welcome card: `Welcome Back! 👋` + günlük motivasyon
3. **3 keşfet kartı:** Fitness & Pilates · Sağlıklı Beslenme · Sağlık Tüyoları
4. **Rutinine Eklemek İsteyebileceklerin:** ikon strip (Şekeri Bırakma, Yağ Oranı Düşürme, Core Güçlendirme, Shuffle Workout, Meditasyon & Yoga, Stretch & Release, Günlük Yürüyüş)
5. **Yeni Çıkan Programlar:** 4'lü kart grid (YENİ badge)
6. **Arkadaşını Davet Et** kartı
7. **Favorilerin:** Tarifler + Workoutlar (2 büyük kart)
8. **Bizimle Tanış:** social link row (IG/TikTok/YouTube/FB/Mail)
9. **FitMama Stories:** before/after carousel

### 3.2 Programlar (`/programs`)

1. **Nerede Antrenman Yapmak İstiyorsun?** — 3 kart (Evde · Salonda · Dışarıda) görselli
2. **Kaldığın Yerden Devam Et** — devam edilen program ile progress bar
3. **Kategoriler:** 4 chip tab (Bölgesel · Hedefsel · Antrenman Türü · Seviye)
   - Bölgesel: Core, Full Body, Upper Body, Lower Body, Glute, Pelvik Taban, Bel İnceltme, Sırt & Postur
   - Antrenman Türü: Kardiyo, HIIT, Pilates, Yoga, Kuvvet, Esneme, Dance Fitness, Walking
4. **Öne Çıkan Programlar:** 3 büyük kart (Strong Mama, Glute Builder, HIIT Burn vb.)
5. **Sana Özel Öneriler** — AI kartı (Gemini servisini bağla)

### 3.3 Beslenme (`/nutrition`)

1. Kategori tabs: Tüm Tarifler · Airfryer · Fit Tatlı · Fit Diğer
2. **Popüler Tarifler** carousel (rating)
3. **Haftalık Yemek Planlaması** — gün tab (Pzt..Paz) + 4 öğün kartı + "Planı Düzenle"
4. **Daha Fazlası:** Alışveriş Listesi · Blog Yazıları
5. **Besin Değerlerini Keşfet** — pill row (Kalori/Protein/Karb/Yağ/Lif)
6. **Favori Tariflerim** — 4'lü grid

### 3.4 İstatistikler (`/stats`)

1. Aralık tabs: Hafta · Ay · 3 Ay · Yıl
2. **KPI kartları:** Toplam Kalori · Toplam Süre · Antrenman · Aktif Gün (delta %)
3. **Çalıştırılan Bölgeler:** ön/arka anatomi görseli + bölge derecelendirmeleri (Çok İyi / İyi / Orta / Başlangıç)
4. **Bölgeye Göre Dağılım:** donut chart (fl_chart)
5. **Performans Grafikleri:** 4 mini line chart (Kalori, Süre, Antrenman, Kalp Atış)
6. **Su Tüketimi** + **Beslenme Özeti** (protein/karb/yağ progress)
7. **Makro Dağılımı** + **Kalori Dağılımı** (donut + line)

### 3.5 Profil (`/profile`)

1. Header: avatar, isim, e-posta, ayarlar ikonu
2. KPI strip: Workouts · Weeks with FitMama · Achievements
3. My Progress kart (haftalık görünüm)
4. **Mama Araçları** liste:
   - Beslenme Logları (mevcut feeding screen)
   - Uyku Takibi (mevcut sleep screen)
   - Mood Günlüğü (mevcut mood screen)
   - Bebek Gelişim Adımları (mevcut milestones)
   - Recovery Timeline
   - Kegel Egzersizleri (Pelvik Taban detay)
   - Partner Yönetimi
   - Hatırlatıcılar
5. Focus Areas progress bar listesi
6. Achievements grid (rozetler)
7. Settings linki

## 4. Mevcut Feature Mapping

| Eski route | Yeni yer |
|------------|----------|
| `/dashboard` | `/home` (refactor — yeni Ana Sayfa) |
| `/feeding` | Profil > Mama Araçları > Beslenme Logları |
| `/mood` | Profil > Mama Araçları > Mood |
| `/sleep` | Profil > Mama Araçları > Uyku |
| `/exercise` | `/programs` içerik kartı (kategori detayı) |
| `/breathing` | `/programs` (Stretch & Release / Esneme kategorisi) |
| `/nutrition` | `/nutrition` (extend) |
| `/videos` | `/programs` içeriği (program detay kartları) |
| `/community` | Ana Sayfa "Bizimle Tanış" + "FitMama Stories" |
| `/progress` | `/stats` (replace + zenginleştir) |
| `/reminders` | Profil > Mama Araçları |
| `/settings` | Profil header |
| `/more` | Kaldırıldı (Profil zaten içeriyor) |
| `/recovery` | Profil > Mama Araçları > Recovery |
| `/milestones` | Profil > Mama Araçları > Milestones |
| `/kegel` | Profil > Mama Araçları > Kegel |
| `/partner` | Profil > Mama Araçları > Partner |

Sub-route'lar kaldı: `/home/feeding`, `/profile/sleep` vs. tüm mevcut ekranlar dokunulmadan erişilebilir kalır.

## 5. Yeni Bileşenler

- `FitmamaLogo` — heart+pulse + iki renkli wordmark, boyut varyantları (small/medium/large).
- `WelcomeBanner` — kişiselleştirilmiş selamlama + ikon.
- `FeatureDiscoveryCard` — büyük görselli (gradient veya solid) keşfet kartı.
- `RoutineQuickAddStrip` — yatay ikon listesi (yuvarlak ikon + label).
- `ProgramCard` — fotoğrafı/illüstrasyonu + isim + süre/seviye chip + bookmark.
- `LocationCard` — bg image/gradient + büyük ikon + isim + alt başlık + ok.
- `CategoryChipGrid` — 4 sütun ikon grid (line icon + label).
- `BodyAnatomyHeatmap` — CustomPainter veya SVG asset (ön/arka kadın silüet) + bölge highlight + yan tarafa seviye listesi.
- `MiniLineChart` — fl_chart sparkline wrapper.
- `MealPlannerWeek` — gün tab + 4 öğün satır.
- `StoryBeforeAfterCard` — split fotoğraf + isim + yaş + kalp.
- `InviteFriendCard` — pembe gradient + CTA.

## 6. Implementation Sırası

1. Spec (bu doc) + memory update
2. Paket rename: `momrise` → `fitmama` (pubspec + imports)
3. Native display name update (Android/iOS/Web)
4. Yeni `app_theme.dart` (token + ThemeData)
5. `FitmamaLogo` widget
6. Yeni `AppShell` (5-tab nav)
7. Router refactor (yeni branch route'lar, eski route'lar sub-route)
8. Yeni Ana Sayfa
9. Yeni Programlar
10. Beslenme refresh
11. Yeni İstatistikler
12. Yeni Profil + Mama Araçları hub
13. Localization (TR/EN) yeni key'ler
14. Test fixleri + analyze + test
15. Build doğrula

## 7. Notlar

- **Fotoğraf yok:** Screenshot'lardaki fitness/yemek fotoğrafları telif sebebiyle dahil edilmiyor. Yerine gradient + ikon placeholder kullanıyoruz; kullanıcı gerçek asset'leri sonra `assets/images/` altına ekler.
- **Asset placeholder kontratı:** `assets/images/programs/<slug>.jpg`, `assets/images/meals/<slug>.jpg`, `assets/images/stories/<slug>.jpg`. Eksikse `ProgramCard.fallback()` gradient + ikon gösterir.
- **fl_chart** zaten bağımlı; istatistik chart'ları için yeterli.
- **Light theme** korunur ama default `dark` (system'i override etmiyoruz — `themeMode: ThemeMode.system` kalır, sadece dark renkleri ön planda tasarlandı).
