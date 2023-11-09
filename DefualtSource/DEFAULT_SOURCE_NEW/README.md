# Default source

Người viết: XuanQuy
Last update: 12/10/2023

## Những thứ cần Setup 
*Trong thư mục NEED_TO_SETUP chứa các thông tin của một app cần phải được config sau đây
- Chọn Project > Chọn version IOS 16.0
- AssetDefault: Di chuyển, coppy các thông gồm có Colors, AccentColor, Các asset default support cho nhiều app...
- Pods: Là các Thư viện cần để tạo ra workspace mặc định, chủ yếu là Realm, Firebase, Kingfisher,...
- InfoApp: Chứa các Info plist cần có để tạo ra app mới

## App general
    - version app TARGETS > general > version
        - kiểm tra version checkUpdateVersionApp
            -> kiểm tra version của app trên appstore để hiển thị view cập nhật 
    - DEFAULT_SOURCE  "mặc định của app ít thay đổi"
        + GoogleService-Info.plist: Connect với Firebase
        + ExtensionViews "các extension hỗ trợ mặc định của app"
        + User & IAP - Quản lí thanh toán và User
        + Admob - Các model để show các quảng cáo dựa vào các thuộc tính của User : isPremium, timeExpired
        + HelperView - Những view mặc định cần có của app và các view hỗ trợ trong trong việc sử dụng và tái sử dụng ở nhiều nơi trong dự án
        + DefaultView: chứa các view mặc định ban đầu của app
        + Font: chứa các font chữ của app
        + CONTROLL_APP: *Lưu trữ các source code dùng trong việc quản trị app, 
            * AppDelegate - Quản lý vòng đời của app, đồng thời tiến hành yêu cầu quyền truy cập mặc định như Notificaton & AppTracking
            * Coordinator - Quản lí điều hướng của app : Sheet , FulScreen , push Page navigation
            * APPCONTROLLER - Object giúp quản lý các biến toàn cục trong quá trình điều kiển app
            * SwiftyJSON là extension hỗ trợ cho parse data
            * CONSTANT: Lưu trữ tất cả các giá trị Constant được dùng trong app và hứng dữ liệu từ Firebase
            * Mặc định sẽ dùng temp_manifest.json để parse data, khi muốn dùng Firebase RealmtimeDatabase thì enble USING_MANIFEST trong CONSTANT
            => Trong File [Name]App, cần khởi tạo các giá trị mặc định xem ở DefaultProjectApp.swift
        + Name App
            *Thay đổi ở DefaultProjectApp.swift -> General -> DisplayName
        + HelperModel: chứa các model hỗ trợ khi làm như: 
            * VersionApp: kiểm tra version của app có cập nhập hay không
            * Network: Kiếm tra xem có kết nối internet hay không
            * LocalNotification: hiển thị toast message
        
1.Thêm các extension và view để thuận tiện sử dụng 
 Extension views, String
    + Thêm ViewModifier styledText, rounded, customButtonStyle,  extractName, placeholder
    + String: extractName, isValidEmail, isValidPassword, containsDigits
    - Date: chuyển đổi các kiểu ngày, tháng, năm...
    - Bundle: mở rộng chức năng của đối tượng Bundle trong Swift. Nó cung cấp một thuộc tính tính toán là icon để truy xuất hình ảnh biểu tượng của ứng dụng từ thông tin trong tệp Info.plist của ứng dụng.
    - Array: Dùng để dễ dàng chuyển đổi mảng các đối tượng có thể Codable thành một chuỗi raw (raw string) và ngược lại.
    - FileManager: cung cấp một số hàm tiện ích để quản lý tệp tin và thư mục trong ứng dụng:
        + getDocumentsDirectory(): Hàm này trả về đường dẫn của thư mục Documents trong ứng dụng. Thư mục Documents thường được sử dụng để lưu trữ dữ liệu ứng dụng.
        + change(fileName:destination:): Hàm này nhận vào tên tệp tin (fileName) và đường dẫn đích (destination). Nếu tệp tin với tên đã cho đã tồn tại trong thư mục đích, nó sẽ thay đổi tên tệp tin để tránh xung đột và trả về tên mới. Nếu tệp tin không tồn tại, nó trả về tên tệp tin ban đầu.
        + saveImage(image:folder:name:completion:): Hàm này lưu một hình ảnh vào thư mục được chỉ định (folder) với tên tệp tin (name) và gọi hàm hoàn thành (completion) khi việc lưu trữ hoàn tất.
        + saveImage(id:image:): Hàm này lưu một hình ảnh với tên dựa trên một ID vào thư mục được xác định.
        + removeImage(folder:name:): Hàm này xóa một tệp tin hình ảnh từ thư mục được chỉ định bằng tên tệp tin.
        + loadImageFromDiskWith(id:folder:): Hàm này trả về một hình ảnh từ thư mục được chỉ định bằng ID và tên tệp tin.
    - Image: được sử dụng để tính toán màu trung bình của hình ảnh. 
    - Int: cho phép bạn ánh xạ một giá trị Int từ một phạm vi nguồn sang một phạm vi mục tiêu, cho phép bạn chuyển đổi giá trị từ một phạm vi sang một phạm vi khác theo cách tuyến tính.
    - SafeAreaInsets: tạo một cách để truy cập dấu hiệu an toàn trong SwiftUI thông qua EnvironmentValues, đồng thời định nghĩa một chìa khóa môi trường tùy chỉnh và chuyển đổi giữa UIEdgeInsets và EdgeInsets để sử dụng chúng trong SwiftUI.
    - String: Sửa dụng để convert String
    - Font: Khai báo sử dụng các font  và UIFont
    - TimeInterval: cho phép chuyển đổi một khoảng thời gian thành một chuỗi thời gian định dạng.
    - UIApplication: ung cấp một số tính năng bổ sung cho lớp UIApplication và UIViewController trong ứng dụng iOS:
        + static func dismissKeyboard(): Phương thức tĩnh để tắt bàn phím. Nó tìm cửa sổ chính hiện tại và kết thúc việc chỉnh sửa (dismiss keyboard) trên các trường văn bản hoặc trường nhập liệu đang hoạt động.
        + func topMostViewController() -> UIViewController?: Phương thức để lấy ViewController đang hiển thị ở đầu ngăn xếp của ứng dụng, nghĩa là ViewController mà người dùng đang tương tác. Phương thức này duyệt qua cấu trúc ViewController, bao gồm cả các trường hợp đặc biệt như nếu có một presentedViewController, một UINavigationController, hoặc một UITabBarController.
    - UIDevice: Được sử dụng để lấy thông tin về dung lượng ổ đĩa của thiết bị iOS. Nó cung cấp các thuộc tính tính toán để trả về thông tin về dung lượng ổ đĩa ở dạng định dạng MB và GB.
    - View: Chứa các extension, view modifier
    - BytesConverter: được sử dụng để chuyển đổi kích thước dữ liệu từ đơn vị byte sang (KB), (MB) và (GB), và cung cấp chuỗi dễ đọc để hiển thị kích thước dưới dạng đơn vị thích hợp.
        + getReadableUnit: Phương thức này trả về một chuỗi dễ đọc để hiển thị kích thước dữ liệu theo đơn vị thích hợp. Nó sử dụng một câu lệnh switch để xác định đơn vị thích hợp (bytes, KB, MB hoặc GB) và định dạng kích thước dưới dạng chuỗi.
    - URL: dùng để thực hiện các tác vụ liên quan đến quản lý và truy xuất các đường dẫn và thư mục trong hệ thống tệp của ứng dụng
        + isDirectoryAndReachable: Kiểm tra xem URL có phải là một thư mục và có thể truy cập được hay không.
        + directoryTotalAllocatedSize: Trả về kích thước tổng đã phân bổ của thư mục bao gồm các thư mục con (nếu có).
        + sizeOnDisk: Trả về kích thước tổng của thư mục trên ổ đĩa dưới dạng một chuỗi định dạng.
        + isDirectory: Kiểm tra xem URL có phải là một thư mục hay không bằng cách kiểm tra thuộc tính .isDirectoryKey.
        + subDirectories: Trả về một mảng các URL đại diện cho các thư mục con bên trong thư mục đang xem xét. Nó loại bỏ các tệp ẩn và chỉ trả về các thư mục con
    - ConfettiSwiftUI: 
        + ConfettiType: Đây là một loại liệt kê định nghĩa loại confetti có thể sử dụng. Nó bao gồm các loại hình dạng như hình tròn, tam giác, hình vuông, và nhiều loại khác, cũng như chữ văn bản và biểu tượng SF Symbols. Mỗi loại có một view tương ứng để vẽ hình dạng hoặc hiển thị nội dung.
        + ConfettiCannon: Đây là một View SwiftUI chính để hiển thị hiệu ứng mưa confetti. Nó nhận các tham số như số lượng confetti, hình dạng, màu sắc, và nhiều cài đặt khác để tạo hiệu ứng. Khi giá trị của biến counter thay đổi, hiệu ứng sẽ chạy.
        + ConfettiContainer: Một lớp trung gian để quản lý số lượng confetti trong hiệu ứng. Nó theo dõi số lượng confetti đã hoàn thành và thêm các ConfettiView vào bên trong.
        + ConfettiView: Đại diện cho một viên confetti cụ thể. Nó có thể có hình dạng và màu sắc ngẫu nhiên và di chuyển qua một loạt các hoạt ảnh để tạo hiệu ứng mưa.
        + ConfettiAnimationView: Đây là nơi các hình dạng confetti cụ thể được hiển thị. Nó có thể xoay và di chuyển theo các hướng khác nhau để tạo hiệu ứng vui mắt.
        + ConfettiConfig: Một lớp chứa các cài đặt của hiệu ứng confetti như kích thước, màu sắc, và thời gian.
        + RoundedCorner: Một hình dạng tùy chỉnh để tạo các góc bo tròn.
    - Views
        + confettiCannon: Đây là một phương thức mở rộng cho SwiftUI View. Nó thêm hiệu ứng "Confetti" (một loại hạt giấy nhiều màu thường được sử dụng trong các lễ kỷ niệm) vào giao diện người dùng của bạn. Bạn có thể tùy chỉnh nhiều thông số như số lượng confetti, màu sắc, kích thước, và nhiều tham số khác.
        + closeKeyBoard(): Một phương thức mở rộng cho SwiftUI View để đóng bàn phím trên thiết bị.
        + disableWithOpacity(): Một phương thức mở rộng cho SwiftUI View để vô hiệu hóa và thay đổi độ mờ của view dựa trên điều kiện được cung cấp.
        + hAlign() và vAlign(): Các phương thức mở rộng cho SwiftUI View để căn chỉnh view theo chiều ngang hoặc chiều dọc.
        + rounded(): áp dụng một hiệu ứng làm tròn vùng xung quanh cho một View và màu 
        + styledText(): tạo và định dạng một đoạn văn bản (Text) với màu chữ (foregroundColor) và font chữ (font) được chỉ định.
        + border(): Một phương thức mở rộng cho SwiftUI View để thêm viền với kích thước và màu sắc được chỉ định.
        + fillView(): Một phương thức mở rộng cho SwiftUI View để thêm một lớp màu fill với màu sắc được chỉ định
        + cornerRadius(): Một phương thức mở rộng cho SwiftUI View để làm việc với bo góc của view.
        + linearGradient() và angularGradient(): Các phương thức mở rộng để tạo gradient tuyến tính và gradient góc.
        + onBackground() và onForeground(): Các phương thức mở rộng cho SwiftUI View để thực hiện các hành động khi ứng dụng chuyển đổi giữa trạng thái nền và trạng thái hoạt động.
        + customButtonStyle(): Phương thức này được thiết kế để áp dụng một kiểu trình bày tùy chỉnh cho một button
        + placeholder(): sử dụng để hiển thị một nội dung (placeholder) trên một TextField
        + popup(): Một phương thức mở rộng cho SwiftUI View để tạo cửa sổ pop-up đơn giản dựa trên việc cài đặt giá trị isPresented.
        + UINavigationController: Mở rộng này cho phép bạn thiết lập một UINavigationController để xử lý việc vuốt để quay lại trang trước đó.

1.HelperView
    - CustomActivity
        + CustomActivity: là một tùy chỉnh SwiftUI View, được sử dụng để hiển thị một biểu tượng hoạt động (activity indicator) giữa màn hình
        + ArcsIndicatorItemView: là một View dùng để tạo ra một biểu tượng hoạt động gồm nhiều vòng cung xoay.
        + ActivityIndicatorView: là một View sử dụng để tạo một biểu tượng hoạt động bằng cách sử dụng ArcsIndicatorItemView
    - LottieView: Dùng để hiển thị annimation LottieView khi import file json
    - MarqueeText: là một View sử dụng để hiển thị văn bản dưới dạng hiệu ứng marquee (văn bản tự động cuộn ngang khi nó quá dài để hiển thị).
    - Shimmer: chứa extension cho View hiệu ứng nhấp nháy, thường dùng để tạo data giả khi bắt đầu tải data, 
        + Shimmer: là một ViewModifier và chứa các phần tử liên quan đến hiệu ứng shimmer. sử dụng AnimatedMask để tạo mask cho hiệu ứng shimmer và sử dụng gradient để tạo lớp mặt nạ.
    - SkeletonView: để tạo hiệu ứng "skeleton loading" hoặc "shimmer" cho nội dung bên trong nó. Hiệu ứng skeleton sử dụng để cho thấy rằng dữ liệu giống đang được tải lên
    - TextShimmer: tạo hiệu lấp lánh cho văn bản 
    - WebView: là một UIViewRepresentable, được sử dụng để hiển thị một trang web trong ứng dụng.
    - CircleProgressView: custom progess hình tròn có thể thay đổi màu và kích thước..
    - NotificationView: view toast message có thể tuỳ biến
    - CustomSheet: tuỳ chỉnh lại sheet có thể set chiều cao,...
    - ParticaleEffect: Tạo hiệu ứng animation nhảy khi ấn button 
    - ArcMenuButton: Tạo menu button dạng vòng cung
    ...
2. HelperModel
    - Alerter: sử dụng để quản lý việc hiển thị và ẩn cửa sổ cảnh báo trên giao diện người dùng 
    - Giftcode: Hiển thị và nhập Giftcode
    - MyAlert: được tạo ra để thực hiện các tùy chỉnh và tiện ích cho UIAlertController trong iOS
        + func setBackgroundColor(color: Color): Thiết lập màu nền cho alert controller bằng cách tìm và thay đổi thuộc tính backgroundColor của các phần tử con trong cấu trúc UIAlertController.
        + func setTitle(font: UIFont?, color: Color?): Thiết lập font và màu cho tiêu đề của alert.
        + func setMessage(font: UIFont?, color: Color?): Thiết lập font và màu cho thông điệp của alert.
        + func setTint(color: UIColor): Đặt màu sắc chung cho alert controller.
        + func showAlert(alert: MyAlert): Hiển thị alert controller trên màn hình. Nó thực hiện việc tìm top-most view controller và hiển thị alert controller trên đó.
        + func share(item: [Any]): Hiển thị một UIActivityViewController để chia sẻ nội dung. UIActivityViewController cho phép người dùng chia sẻ nội dung với các ứng dụng khác.
        + static func showRate(): Hiển thị gợi ý xếp hạng ứng dụng sử dụng SKStoreReviewController. Nếu ứng dụng đang ở trạng thái chạy trong chế độ foregroundActive, thì nó sẽ hiển thị cửa sổ xếp hạng ứng dụng.
    - VersionApp: hỗ trợ kiểm tra version của app có cập nhập hay không
    - Network: hỗ trợ kiếm tra xem có kết nối internet hay không
    - LocalNotification: quản lý và gửi các thông báo cục bộ (local notifications) trong ứng dụng
    - RequestGetPermission: Thực hiện các tác vụ liên quan đến xin cấp quyền (permissions) và điều hướng người dùng đến cài đặt (settings) của ứng dụng.
    
3.Custom lại local notification (toast message)
    + Thêm màu sắc, icon, trang thái
    + Gọi ra và truyền value (message, status) sử dụng như bình thường và tuỳ vào từng style : success , error , warning ... 
    để hiện thị ra style theo bối cảnh
    + NotificationView: là view hiển thị của toast message

4.Thay đổi LauchScreen và icon 
    + Thêm ảnh trong assert, và thêm tên ảnh đó vào LauchScreen( Image Name,Background color ) trong info.plist
    + Sử dụng Launch Screen.storyboard (hiện đang sử dụng cách này)
    
5.Kiểm tra version update app
    + Kiểm tra app có cập nhật mới hay không sau đó xử lí tuỳ biến... ở ContentView (VersionApp.shared.checkUpdateVersionApp)
    + Nếu có bản cập nhật mới thì show ra popup yêu cầu cập nhật...
    
6. DefaultView: chứa các view mặc định
    + Thêm OnboardingDefaultView, LoginDefaultView, SettingDefaultView, PremiumDefaultView mặc định (các view này sẽ là các view mặc định cần có của source có thể dùng luôn cho app hoặc tuỳ biến lại với design cho phù hợp)
        * SettingDefaultView mặc định có các chức năng bẳt buộc cần có như Feedback, privacy, darkmode ,rate,...
        * OnboardingDefaultView view giới thiệu khi lần đầu vào app, có thể tuỳ biến cho hợp design
        * LoginDefaultView view login mặc định cần có cho bất kì dự án nào, có thể tuỳ biến cho hợp design
        * PremiumDefaultView trang nâng cấp lên trả phí sẽ mở các tính năng khác và không có quảng cáo 
        * UpdateVersionView: tuỳ biến hiển thị view yêu cầu cập nhập phiên bản cho phù hợp
    + LoadingView dùng để loading khi đăng nhập, đăng ký
    + AuthManagerViewModel tạo view model để xử lí riêng cho login và có thể sử dụng dễ dàng hơn quản lý tiện nhanh chóng hơn    

7.Recommand ứng dụng khác
    + Thêm id của app vào appIdentifier trong appStoreOverlay để recommand app khác
        .appStoreOverlay(isPresented: $showRecommended) {
            SKOverlay.AppConfiguration(appIdentifier: CONSTANT.SHARED.ADS.APP_ID_RECOMMEND, position: .bottom)
        }, sử dụng manifeat để quản lý
    + Khi vào app 5s sẽ show Recommand ra

- Sử dụng SFSafariViewWrapper dùng GG Form đề feedback giải quyết các vấn đề của khách hàng

- Tìm hiểu cách hoạt động của các dạng ADS
    + Callback (adDidDismissFullScreenContent) xử lý khi xem xong và tắt ADS, func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) xử lý khi có lỗi
    + Func Load ads tải dữ liệu quảng cáo từ Google AdMob 
    + Trước khi gọi hàm show quảng cáo phải kiểm tra xem User và quyền cho phép có được bật không: 
        + ShowInterstitial: User.isShowInterstitial()
        + SwiftUIBannerAd: kiểm tra thêm biến ADS_READY nữa APPCONTROLLER.shared.ADS_READY && User.isShowBanner() sau đó gọi sử dụng SwiftUIBannerAd(width: UIScreen.main.bounds.width, height: 60)
        + ShowRewarded: User.isShowRewarded()
        + ShowNative: User.isShowNative()
        + ShowAdsOpen: User.isShowAdsOpen()
    + Func show if let ad = RewardedAd.shared.rewardedAd kiểm tra xem đã tải dữ liệu quảng cáo và lưu trữ thành công hay chưa

- 111023: Updated new UI and logic OnboardingDefaultView
