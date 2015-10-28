# react-native-sqlite3

 React native wrapper for sqlite3 using FMDB. Currently only limited FMDB commands are exposed.

 ## Getting Started

 First, `cd` to your RN project directory, run the command `npm install react-native-sqlite3 --save`.

 #### iOS: Using [CocoaPods](https://cocoapods.org)

 Assuming you have [CocoaPods](https://cocoapods.org) installed, create a `PodFile` like this in your app's project directory. You can leave out the modules you don't need.

 ```ruby
 xcodeproj 'path/to/YourProject.xcodeproj/'

 pod 'React', :subspecs => ['Core', 'RCTText', 'RCTWebSocket'], :path => 'node_modules/react-native'
 pod 'react-native-sqlite3', :path => 'node_modules/react-native-sqlite3'

 post_install do |installer|
   target = installer.pods_project.targets.select{|t| 'React' == t.name}.first
   phase = target.new_shell_script_build_phase('Run Script')
   phase.shell_script = "if nc -w 5 -z localhost 8081 ; then\n  if ! curl -s \"http://localhost:8081/status\" | grep -q \"packager-status:running\" ; then\n    echo \"Port 8081 already in use, packager is either not running or not running correctly\"\n    exit 2\n  fi\nelse\n  open $SRCROOT/../node_modules/react-native/packager/launchPackager.command || echo \"Can't start packager automatically\"\nfi"
 end
 ```

 Now run `pod install`. This will create an Xcode workspace containing all necessary native files, including react-native-sqlite3. From now on open `YourProject.xcworkspace` instead of `YourProject.xcodeproject` in Xcode. Because React Native's iOS code is now pulled in via CocoaPods, you also need to remove the `React`, `RCTImage`, etc. subprojects from your app's Xcode project, in case they were added previously.

 ## Usage
