# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!

def shared_pods
  pod 'Charts' 
  pod 'JTAppleCalendar'
  pod 'CSV.swift', '~> 2.4.3'
end

target 'HeartRateMonitor' do
  use_frameworks!

  shared_pods

end

target 'PorterableUITests' do
  shared_pods
end

