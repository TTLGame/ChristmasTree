# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LongTester' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'RxSwift', '6.5.0'
  	pod 'RxCocoa', '6.5.0'
	pod 'Moya/RxSwift', '~> 15.0'
pod 'Alamofire'
pod 'SnapKit'
pod 'RealmSwift', '~>10'
pod 'IQKeyboardManagerSwift'
pod 'FLEX'
pod 'SDWebImage'
pod 'SVProgressHUD'
pod 'DropDown'
pod 'OHHTTPStubs/Swift'
  # Pods for LongTester

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
