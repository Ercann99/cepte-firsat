# Cepte Fırsat 1.0 – Android kaynak projesi

Bu paket Flutter ile hazırlanmış ilk çalışan arayüz/prototip kaynak kodudur.

## İçerik
- Ana sayfa ve örnek fırsat listesi
- BİM, A101, ŞOK ve Migros için demo broşür alanları
- Ürün arama ve market bazında fiyat karşılaştırma
- Sepete ürün ekleme/çıkarma ve market toplamları
- Favoriler
- Demo fiyat alarmı ekranı
- Premium üyelik tanıtım ekranı

**Önemli:** Bütün fiyatlar ve kampanyalar hayalî demo verisidir. Gerçek fiyat değildir. Ödeme, hesap açma, sunucu, gerçek bildirim ve canlı veri bağlantısı henüz yoktur.

## Android APK nasıl oluşturulur?
Bu kaynak Flutter projesidir. APK üretmek için Flutter SDK ve Android SDK gerekir.

1. Bilgisayarda Flutter SDK kurun: https://docs.flutter.dev/get-started/install
2. ZIP'i çıkarın.
3. Proje klasöründe terminal açın.
4. `flutter pub get`
5. `flutter run` (emülatör/USB ile bağlı Android cihazda test)
6. `flutter build apk --release`
7. APK: `build/app/outputs/flutter-apk/app-release.apk`

## Android Studio
Android Studio'da proje klasörünü açın. Gerekirse Android proje iskeletini oluşturmak için:
`flutter create --platforms=android .`
Ardından `flutter pub get` ve `flutter build apk --release` çalıştırın.

## Sonraki geliştirme adımları
1. Tasarım ve kullanıcı akışını kullanıcıyla birlikte kesinleştirmek
2. Ürün/market veri modelini Supabase'e taşımak
3. Yönetim paneli ve gerçek broşür/fiyat veri kaynağı eklemek
4. Ürün eşleştirme ve OCR iş akışını eklemek
5. Gerçek bildirim, üyelik ve ödeme entegrasyonu
6. Gizlilik, kullanım şartları, market marka/görsel izinleri ve Play Store hazırlığı


## Cepte Fırsat 1.0 – Özel ürün listeleri

Uygulamaya şu özel listeler eklendi:
- Glutensiz ürünler
- Türk malı ürünler
- Katkı maddesi içermeyen ürünler
- Şekersiz ürünler
- Vegan ürünler
- Organik ürünler
- Laktozsuz ürünler
- Helal ürünler
- Yerli üretici ürünleri
- İndirimdeki sağlıklı ürünler

Ürün veri modeli bir ürünün birden fazla listeye eklenmesini destekleyecek şekilde tasarlanmıştır. Mevcut örnek eşleştirmeler yalnızca arayüzü göstermek için kullanılan DEMO VERİSİDİR; gerçek ürün uygunluğu veya sertifikası anlamına gelmez. Üretim sürümünde içerik/ambalaj ve güvenilir kaynak doğrulaması gereklidir. “Türk markası” ve “Türkiye'de üretilmiştir” bilgileri de birbirinden ayrı tutulmalıdır.
