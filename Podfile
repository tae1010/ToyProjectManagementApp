# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ToyProjectManagementApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase/Auth'
  pod 'GoogleSignIn', '~> 5.0.2'
  pod 'Firebase/Database', '~> 8.0.0'

  pod 'SideMenu'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'MaterialComponents/BottomSheet'
  pod 'DropDown'

  pod 'KakaoSDKCommon'  # 필수 요소를 담은 공통 모듈
  pod 'KakaoSDKAuth'  # 사용자 인증
  pod 'KakaoSDKUser'  # 카카오 로그인, 사용자 관리

  # Pods for ToyProjectManagementApp

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end

end
