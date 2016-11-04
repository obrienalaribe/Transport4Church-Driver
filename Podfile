# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'
platform :ios, '10.0'

target 'Transport4ChurchDriver' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Eureka', '~> 2.0.0-beta.1'
  pod 'ImageRow', '~> 1.0'
  pod 'MGSwipeTableCell'
  pod 'Parse'
  pod 'Socket.IO-Client-Swift', '~> 8.0.2'
  pod 'BRYXBanner'
  pod 'GoogleMaps'
  pod 'GooglePlaces'

  # Pods for Transport4ChurchDriver

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
