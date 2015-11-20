var DBManager = require('react-native').NativeModules.DBManager;

class RNSqlite{

    constructor(){
        console.log("android sqlite initialized");
    }

    initDB(dbname){
        return new Promise((resolve, reject) => {
            DBManager.initDB(dbname, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors));
                } else {
                    resolve(result)
                }
            });
        });
    }

    executeInsert(dbname, sql, paramsMap){
        let paramsArray = this._convertToParamsArray(sql, paramsMap);
        return new Promise((resolve, reject) => {
            DBManager.executeInsert(dbname, sql, paramsArray, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors));
                } else {
                    resolve(result)
                }
            });
        });
    }

    executeQuery(dbname, sql, paramsMap){
        let paramsArray = this._convertToParamsArray(sql, paramsMap);
        return new Promise((resolve, reject) => {
            DBManager.executeQuery(dbname, sql, paramsArray, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors));
                } else {
                    resolve(result)
                }
            });
        });
    }

    executeUpdate(dbname, sql, paramsMap){
        let paramsArray = this._convertToParamsArray(sql, paramsMap);
        return new Promise((resolve, reject) => {
            DBManager.executeUpdate(dbname, sql, paramsArray, function(errors, result) {
                if (errors) {
                    reject(this._convertError(errors));
                } else {
                    resolve(result)
                }
            });
        });
    }

    _convertError(errors) {
        if (!errors) {
            return null;
        }
        //var out = new Error(error.message);
        //out.key = error.key; // flow doesn't like this :(
        //return out;
        console.log("error executing sqlite statement "+ errors);
        return errors;
    }

    _convertToParamsArray(sql, paramsMap){
        if(!paramsMap){
            return [];
        }
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