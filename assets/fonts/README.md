# SF Pro fonts

Apple'ın San Francisco Pro fontu ücretsiz ama lisanslı; pub.dev üzerinden dağıtılamadığı için elle indirilip bu klasöre konması gerekiyor.

## İndirme

1. https://developer.apple.com/fonts/ adresine git.
2. "SF Pro" başlığı altındaki **Download** butonuna tıkla. (Apple ID ile giriş istenebilir; ücretsiz Developer hesabı yeterli.)
3. Gelen `SF-Pro.dmg` (macOS) veya `.zip`'i aç.
4. İçinden aşağıdaki `.otf` dosyalarını al ve bu klasöre (`assets/fonts/`) kopyala.

## Beklenen dosyalar

```
assets/fonts/SF-Pro-Display-Regular.otf
assets/fonts/SF-Pro-Display-Medium.otf
assets/fonts/SF-Pro-Display-Semibold.otf
assets/fonts/SF-Pro-Display-Bold.otf
assets/fonts/SF-Pro-Display-Heavy.otf
assets/fonts/SF-Pro-Display-Black.otf
assets/fonts/SF-Pro-Text-Regular.otf
assets/fonts/SF-Pro-Text-Medium.otf
assets/fonts/SF-Pro-Text-Semibold.otf
assets/fonts/SF-Pro-Text-Bold.otf
```

Apple paketindeki dosya adları `SFPro` (boşluksuz) olabilir; öyleyse yukarıdaki adlara yeniden adlandır.

## Doğrulama

Dosyaları yerleştirdikten sonra:

```bash
flutter pub get
flutter clean
flutter run
```

Tüm gövde metni ve başlıklar SF Pro Display / SF Pro Text fontuyla render edilecek.

## Lisans

Apple'ın SF Pro lisansı (developer.apple.com/fonts/) "design and produce user interface mock-ups" kapsamında kullanım izni verir. Apple-dışı OS'a yönelik bir ürünü tanıtmak veya satmak için tasarımda kullanım kısıtlıdır. App Store dağıtımı (iOS/macOS) için problem yok; Android/Web dağıtımında lisans yüzünden risk olabileceğini bilerek kullan. Detaylar için lisans metnini oku.
