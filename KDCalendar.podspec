Pod::Spec.new do |s|

  s.name         = "KDCalendar"
  s.version      = "2.9"
  s.summary      = "A calendar component with native events supports."

  s.description  = <<-DESC
  This is an implementation of a calendar component for iOS written in Swift 4.0. It features both vertical and horizontal layout (and scrolling) and the display of native calendar events.
                   DESC

  s.homepage     = "https://github.com/GitHub-Ram/CalendarView"
  s.screenshots  = "https://image.ibb.co/eiDPnb/screenshot.png"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "Ram Kumar"

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/GitHub-Ram/CalendarView.git", :tag => s.version }

  s.default_subspec = 'EventManager'

  s.subspec 'Core' do |ss|
    ss.source_files = "KDCalendar/CalendarView/**/*.{swift}"
  end

  s.subspec 'EventManager' do |ss|
    ss.source_files = "KDCalendar/CalendarView/**/*.{swift}"
    ss.resource_bundles = {
   'KDCalendar' => [
       "KDCalendar/CalendarView/**/*.{xib}",
       "KDCalendar/CalendarView/**/*.{Images.xcassets}"
   ]
 }
    ss.pod_target_xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'KDCALENDAR_EVENT_MANAGER_ENABLED' }
  end

end
