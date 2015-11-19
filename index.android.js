var DBManager = require('react-native').NativeModules.DBManager;

class RNSqlite{

    constructor(){
        console.log("android sqlite initialized");
    }

    initDB(dbname){
        return new Promise((resolve, reject) => {
            DBManager.initDB(dbname, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors[0]));
                } else {
                    resolve(result)
                }
            });
        });
    }

    executeInsert(sql, paramsMap){
        let paramsArray = this._convertToParamsArray(sql, paramsMap);
        return new Promise((resolve, reject) => {
            DBManager.executeInsert(sql, paramsArray, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors[0]));
                } else {
                    resolve(result)
                }
            });
        });
    }

    executeQuery(sql, paramsMap){
        let paramsArray = this._convertToParamsArray(paramsMap);
        return new Promise((resolve, reject) => {
            DBManager.executeQuery(dbName, sql, paramsArray, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors[0]));
                } else {
                    resolve(result)
                }
            });
        });
    }

    executeUpdate(sql, paramsMap){
        let paramsArray = this._convertToParamsArray(paramsMap);
        return new Promise((resolve, reject) => {
            DBManager.executeUpdate(sql, paramsArray, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors[0]));
                } else {
                    resolve(result)
                }
            });
        });
    }

    _convertError(error) {
        if (!error) {
            return null;
        }
        var out = new Error(error.message);
        out.key = error.key; // flow doesn't like this :(
        return out;
    }

    _convertToParamsArray(sql, paramsMap){
        //we use :columnName as convention in sql statement
        let columnNames = sql.match(/:\w+/g);
        let paramsArray = [];
        if(columnNames && columnNames.length > 0){
            for(let i=0; i < columnNames.length; i++){
                //remove the prefix ':' from column name
                let cleanedUpColumnName = columnNames[i].replace(':', '');
                let paramValue = paramsMap[cleanedUpColumnName];
                if(!paramValue){
                    paramValue = null;
                }
                paramsArray.push(paramValue);
            }
        }
        return paramsArray;
    }
}

module.exports = new RNSqlite();