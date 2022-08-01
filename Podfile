# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'CooperationApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Firebase/Auth'
  pod 'GoogleSignIn', '~> 5.0.2'
  pod 'FirebaseUI'
  pod 'Firebase/Database', '~> 8.0.0'
  pod 'SideMenu'
  # Pods for CooperationApp

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end

end
