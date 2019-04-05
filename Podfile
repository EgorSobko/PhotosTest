platform :ios, '12.0'

BRIGHTFUTURES_VERSION = "7.0.1"
QUICK_VERSION = "2.0.0"
NIMBLE_VERSION = "8.0.1"
NUKE_VERSION = "7.5.1"

target 'Api' do
  use_frameworks!

  pod 'BrightFutures', "#{BRIGHTFUTURES_VERSION}"

  target 'ApiTests' do
    inherit! :search_paths

  pod 'Quick', "#{QUICK_VERSION}"
  pod 'Nimble', "#{NIMBLE_VERSION}"

  end

end

target 'Kit' do
  use_frameworks!

  target 'KitTests' do
    inherit! :search_paths

  pod 'Quick', "#{QUICK_VERSION}"
  pod 'Nimble', "#{NIMBLE_VERSION}"

  end

end

target 'PhotosTest' do
  use_frameworks!

  pod 'Nuke', "#{NUKE_VERSION}"

  target 'PhotosTestTests' do
    inherit! :search_paths
  end

end
