# react-native-sqlite3

 React native wrapper for sqlite3 using FMDB. Currently only limited FMDB commands are exposed.

### Thread safety:
  
 All sql commands are executed using FMDatabaseQueue, so thread safety comes for free(FMDB rocks!).
 
### Getting Started

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

***Example Usage:***

    var db = require('react-native-sqlite3');
    
    ////you don't have to open the db explicitly. When you execute a sql, db is opened if not already open.
    var openPromise = db.open(dbName);

    var insertEmpSql = "insert into Employee (id, name) values (:id, :name)";
    var insertEmpParams = {id: "11111", name: "John Doe"};
    var insertPromise = db.executeInsert("employee.db", insertEmpSql, insertEmpParams);

    var updateEmpSql = "update Employee set name = :newName where id = :empId";
    var updateEmpParams = {empId: "11111", newName: "John DoeChanged"};
    var updatePromise = this.db.executeUpdate("employee.db", updateEmpSql, updateEmpParams);
        
    var myEmpId = "11111"; 
    var sqlStmt = 'SELECT * from Employees where id = :employeeId';
    var paramMap = {employeeId: myEmpId};  
    var getEmployeePromise = this.db.executeQuery("employee.db", sqlStmt, params);
    getEmployeePromise.then(function(data){
       console.log("employee data is"+ data);
    });
       
## Known limitations:
  
  1. No batch statements support.(this should be trivial though)
  2. No transaction support yet.
  3. No built in migration support yet.
  
## Android support:
 
 I saw this RN plugin https://github.com/jbrodriguez/react-native-android-sqlite based on SqliteOpenHelper. Will be reusing it or create a wrapper directly against SqliteOpenHelper in the next few weeks. Any PR's are welcome :)
