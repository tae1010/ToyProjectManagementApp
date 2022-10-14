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

  # Pods for ToyProjectManagementApp

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end

end
