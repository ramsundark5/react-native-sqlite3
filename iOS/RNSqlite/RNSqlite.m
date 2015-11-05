
#import "RCTBridgeModule.h"
#import "FMDB.h"

@interface RNSqlite : NSObject <RCTBridgeModule>

@property (strong, nonatomic) NSString *documentDirectory;

@end

@implementation RNSqlite

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initDB:(NSString *)dbName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString* dbPath = [self getDBPath:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL status = [db open];
        NSString * statusString = (status) ? @"True" : @"False";
        NSError* error = [db lastError];
        if(error){
            NSLog(@"%@", error.localizedDescription);
            reject(error);
        }else{
            resolve(statusString);
        }
    }];
    
}

/*RCT_EXPORT_METHOD(executeBatchUpdate:(NSString *)dbName
 sqlStmts:(NSArray *)sqlStmts
 resolver:(RCTPromiseResolveBlock)resolve
 rejecter:(RCTPromiseRejectBlock)reject){
 @try {
 BOOL executedStatus;
 for(NSString* sqlStmt in sqlStmts){
 executedStatus = [self executeUpdateInternal:dbName sqlStmt:sqlStmt params:nil];
 }
 NSString * statusString = (executedStatus) ? @"True" : @"False";
 resolve(statusString);
 }
 @catch (NSError *error) {
 NSLog(@"%@", error.localizedDescription);
 reject(error);
 }
 }*/

RCT_EXPORT_METHOD(executeInsert:(NSString *)dbName
                  sqlStmt:(NSString *)sqlStmt
                  params:(NSDictionary *) params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    
    NSError* error = nil;
    NSInteger lastInsertRowid  = [self executeInsertInternal:dbName
                                                     sqlStmt:sqlStmt
                                                      params:params
                                                      error:error];

    if(error){
        NSLog(@"%@", error.localizedDescription);
        reject(error);
    }else{
        NSNumber *lastRowIdResponse = [NSNumber numberWithInteger: lastInsertRowid];
        resolve(lastRowIdResponse);
    }
}

RCT_EXPORT_METHOD(executeUpdate:(NSString *)dbName
                  sqlStmt:(NSString *)sqlStmt
                  params:(NSDictionary *) params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    NSError* error = nil;
    BOOL status = [self executeUpdateInternal:dbName
                                      sqlStmt:sqlStmt
                                       params:params
                                       error:error];
    if(error){
        NSLog(@"%@", error.localizedDescription);
        reject(error);
    }else{
        NSString * statusString = (status) ? @"True" : @"False";
        resolve(statusString);
    }
}

RCT_EXPORT_METHOD(executeQuery:(NSString *)dbName
                  sqlStmt:(NSString *)sqlStmt
                  params:(NSDictionary *) params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    NSError* error = nil;
    NSArray *results = [self executeQueryInternal:dbName
                                          sqlStmt:sqlStmt
                                           params:params
                                           error:error];
    
    if(error){
        NSLog(@"%@", error.localizedDescription);
        reject(error);
    }else{
        resolve(results);
    }

}

RCT_EXPORT_METHOD(close:(NSString *)dbName
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

    NSString* dbPath = [self getDBPath:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    __block NSError* error = nil;
    [queue inDatabase:^(FMDatabase *db) {
        [db close];
        error = [db lastError];
    }];
    if(error){
        reject(error);
    }else{
        resolve(@"DB Closed");
    }
}

-(NSInteger) executeInsertInternal:(NSString *)dbName
                           sqlStmt:(NSString *)sqlStmt
                            params:(NSDictionary *)params
                            error:(NSError*)error{
    NSString* dbPath = [self getDBPath:dbName];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    __block NSInteger lastId = 0;
    __block NSError* tempError = nil;
    [queue inDatabase:^(FMDatabase *db) {
        BOOL status = [db executeUpdate:sqlStmt withParameterDictionary:params];
        if(status){
            lastId = [db lastInsertRowId];
        }
        tempError = [db lastError];
    }];
    error = tempError;
    return lastId;
}

-(BOOL) executeUpdateInternal:(NSString *)dbName
                      sqlStmt:(NSString *)sqlStmt
                       params:(NSDictionary *)params
                       error:(NSError*)error{
    NSString* dbPath = [self getDBPath:dbName];
    __block NSError* tempError = nil;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    __block BOOL status = FALSE;
    
    [queue inDatabase:^(FMDatabase *db) {
        status = [db executeUpdate:sqlStmt withParameterDictionary:params];
        tempError = [db lastError];
    }];
    error = tempError;
    return status;
}

-(NSArray*) executeQueryInternal:(NSString *)dbName
                         sqlStmt:(NSString *)sqlStmt
                          params:(NSDictionary *)params
                          error:(NSError*)error{
    NSString* dbPath = [self getDBPath:dbName];
    NSMutableArray *results = [NSMutableArray array];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    __block NSError* tempError = nil;
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStmt withParameterDictionary:params];
        while ([rs next]) {
            [results addObject:[rs resultDictionary]];
        }
        [rs close];
         tempError = [db lastError];
    }];
    error = tempError;
    return results;
}

- (NSString *)getDBPath:(NSString *)dbName
{
    if(!self.documentDirectory){
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        self.documentDirectory = documentsDir;
    }
    NSString *dbPath = [self.documentDirectory  stringByAppendingPathComponent:dbName];
    //NSLog(@"DB path is%@", dbPath);
    return dbPath;
}

@end
