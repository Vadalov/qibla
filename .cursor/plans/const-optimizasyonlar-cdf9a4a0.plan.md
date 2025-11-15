<!-- cdf9a4a0-5fce-4083-ae21-e4f2587733f2 7ccb3d0c-d1f4-4790-9398-3d1ba56aeffc -->
# Prayer Times Page Tasarım Güncelleme

## Hedef

Resimdeki modern tasarımı TimesPage'e uygulama. Kart tabanlı düzen, yan yana current/next prayer kartları ve eksik bilgileri ekleme.

## Değişiklikler

### 1. PrayerTimeService Güncelleme

- `lib/services/prayer_time_service.dart`:
- `PrayerTimes` class'ına `suhoor`, `iftaar`, `sunset`, `midday` alanları ekle
- Aladhan API'den `Imsak` (suhoor), `Sunset`, `Midnight`, `Midday` verilerini al
- `getPrayerTimes` metodunu güncelle

### 2. Current Prayer Hesaplama

- `lib/pages/times_page.dart`:
- Mevcut namazı belirleme mantığı ekle (`_getCurrentPrayer()`)
- Mevcut namazın bitiş saatini hesapla (sonraki namaza kadar)

### 3. Tarih ve Navigasyon Bölümü

- Header'a tarih gösterimi ekle:
- Hicri tarih (örn: "7 Ramadan, 1444")
- Miladi tarih (örn: "Wed, 29 March 2023")
- Sol/sağ ok ikonları ile günler arası geçiş

### 4. Current & Next Prayer Cards (Yan Yana)

- `_buildCurrentPrayerCard()` ve `_buildNextPrayerCard()` ekle
- İki kartı yan yana Row içinde göster
- Current Prayer Card (sol):
- "Şu anki vakit" etiketi
- Namaz adı
- Büyük saat gösterimi
- "Bitiş: [saat]" bilgisi
- Hafif gradient arka plan
- Next Prayer Card (sağ):
- "Sonraki vakit" etiketi
- Namaz adı
- Büyük saat gösterimi
- "Azan: [saat]" ve "Cemaat: [saat]" bilgileri

### 5. Suhoor & Iftaar Card

- `_buildSuhoorIftaarCard()` ekle
- İki bölümlü card (Row içinde):
- Sol: Suhoor (bell icon + saat)
- Sağ: Iftaar (bell icon + saat)
- Bell icon'ları notification durumunu göster

### 6. Location & Prayer List Card

- Mevcut prayer list'i bir card içine al
- Location bilgisini card'ın üstünde göster (map pin icon)
- Her namaz satırına bell icon ekle (notification toggle)

### 7. Sunrise/Mid Day/Sunset Card

- `_buildSunTimesCard()` ekle
- Üç bölümlü card:
- Sunrise: Güneş doğuşu
- Mid Day: Öğle vakti (Dhuhr)
- Sunset: Güneş batışı

### 8. Layout Düzenleme

- ScrollView kaldırma (zaten yapılmış)
- Cards'ları Column içinde düzenle:

1. Header (tarih + navigasyon)
2. Current & Next Prayer Cards (Row)
3. Suhoor & Iftaar Card
4. Location & Prayer List Card
5. Sunrise/Mid Day/Sunset Card

### 9. Cami Silueti Dekoratif Element

- Current ve Next Prayer kartlarına alt kısımda dekoratif cami silueti ekle (opsiyonel)
- Opacity düşük gradient overlay kullan

## Dosyalar

- `lib/services/prayer_time_service.dart` - API verilerini genişletme
- `lib/pages/times_page.dart` - UI yeniden tasarımı

## Notlar

- Hicri tarih hesaplama için paket gerekebilir (hijri_date veya manuel hesaplama)
- Azan/Jamaat saatleri normalde aynıdır, Jamaat genelde 5-10 dakika sonra olur (konfigüre edilebilir)
- Suhoor = Imsak, Iftaar = Maghrib (Ramazan için)

### To-dos

- [x] TimesPage - Tutarlı renk ve tasarım
- [x] QiblaPage - Tutarlı renk ve tasarım
- [x] QuranPage - Tutarlı renk ve tasarım
- [x] DuaZikirPage - Tutarlı renk ve tasarım