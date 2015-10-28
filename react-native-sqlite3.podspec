
Pod::Spec.new do |s|
  s.name             = "react-native-sqlite3"
  s.version          = "0.1.1"
  s.summary          = "A react native wrapper for sqlite3."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Sqlite3 binding for react native. This is a simple wrapper of FMDB database queue."

  s.homepage         = "https://github.com/ramsundark5/react-native-sqlite3"
  s.license          = 'MIT'
  s.author           = { "Ramsundar Kuppusamy" => "ramsundark5@gmail.com" }
  s.source           = { :git => "https://github.com/ramsundark5/react-native-sqlite3.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ramsundark5'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'iOS/RNSqlite/*'

  s.dependency 'React'
  s.dependency 'FMDB/FTS'
end
