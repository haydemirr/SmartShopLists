SmartShopLists
SmartShopLists, iOS cihazlar için geliştirilmiş, alışveriş listelerinizi kolayca oluşturup yönetmenizi sağlayan bir uygulamadır. Swift ve UIKit ile yazılmış, Core Data ile yerel veri saklama ve Firebase Authentication ile kullanıcı kimlik doğrulaması sunar.
Özellikler

📋 Alışveriş listeleri oluşturma ve düzenleme
✅ Öğeleri işaretleme ve tamamlananları takip etme
💾 Core Data ile çevrimdışı veri saklama
🔒 Firebase Authentication ile güvenli kullanıcı girişi
📱 iPhone ve iPad ile uyumlu UIKit arayüzü

Gereksinimler

Xcode: 15.0 veya üstü
iOS: 16.0 veya üstü
Swift: 5.0 veya üstü
Bir Apple Developer hesabı (Firebase ve test için önerilir)
Cocoapods (Firebase bağımlılıkları için)

Kurulum
Adımlar

Depoyu yerel makinenize klonlayın:git clone https://github.com/haydemirr/SmartShopLists.git


Proje dizinine gidin:cd SmartShopLists


CocoaPods ile bağımlılıkları yükleyin:pod install


Not: Podfile'da Firebase/Auth belirtildiğinden emin olun. Örnek Podfile:

pod 'Firebase/Auth'


.xcworkspace dosyasını Xcode ile açın:open SmartShopLists.xcworkspace


Firebase konfigürasyonunu ayarlayın:
Firebase Konsolu’nda projenizi oluşturun.
GoogleService-Info.plist dosyasını indirip proje kök dizinine ekleyin.
Xcode’da FirebaseApp.configure()’ın AppDelegate veya SceneDelegate’te çağrıldığından emin olun.


Core Data modelini kontrol edin:
.xcdatamodeld dosyasını açın ve varlıkların (entities) doğru yapılandırıldığından emin olun.


Projeyi derleyin ve bir iOS cihaz/simülatörde çalıştırın:
Xcode’da Cmd + R ile çalıştırın.



Kullanım

Giriş Yapma: Firebase Authentication ile e-posta veya Google hesabıyla giriş yapın.
Liste Oluşturma: Ana ekranda "+" butonuyla yeni bir alışveriş listesi ekleyin.
Öğe Yönetimi: Listelerdeki öğeleri ekleyin, düzenleyin veya silin.
Çevrimdışı Destek: Core Data sayesinde internet olmadan da listelerinize erişin.

Katkıda Bulunma
Katkılarınızı bekliyoruz! Şu adımları izleyin:

Depoyu fork edin.
Yeni bir branch oluşturun: git checkout -b feature/yeni-ozellik
Değişikliklerinizi yapın ve commit edin: git commit -m "Yeni özellik eklendi"
Branch’inizi push edin: git push origin feature/yeni-ozellik
GitHub’da bir Pull Request açın.

Lisans
Bu proje MIT Lisansı altında lisanslanmıştır.
İletişim
Sorularınız veya önerileriniz için: haydemir001@gmail.com
Happy Shopping! 🛍️
