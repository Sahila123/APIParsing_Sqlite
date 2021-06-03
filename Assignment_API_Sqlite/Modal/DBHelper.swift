//
//  DBHelper.swift
//  Assignment_API_Sqlite
//
//  Created by Mirajkar on 01/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import Foundation
import SQLite3


class DBHelper {
    static let shared = DBHelper()
    let tableName = "user"
    
    private init() {
        db = openDatabase()
        createTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?  //an opaque pointer is a special case of an opaque data type, a data type declared to be a pointer to a record or data structure of some unspecified type.
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        }
    }
    
    func createTable() {
//        let createTableString = "CREATE TABLE IF NOT EXISTS \(tableName)(Id INTEGER PRIMARY KEY,name TEXT,email TEXT,zipcode TEXT,companyName TEXT,UNIQUE(Id));"
        let createTableString = "CREATE TABLE IF NOT EXISTS \(tableName)(Id INTEGER PRIMARY KEY,name TEXT,email TEXT,zipcode TEXT,companyName TEXT);"

        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\(tableName) table created.")
            } else {
                print("\(tableName) table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    func insert(userObj: User) {
        let users = read()
        for user in users {
            if user.id == userObj.id {
                return
            }
        }
        let insertStatementString = "INSERT INTO \(tableName) (Id, name, email, zipcode, companyName) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(userObj.id ?? 0))
            sqlite3_bind_text(insertStatement, 2, ((userObj.name ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, ((userObj.email ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, ((userObj.zipcode ?? "") as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, ((userObj.companyName ?? "") as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    func read() -> [User] {
        let queryStatementString = "SELECT * FROM \(tableName);"
        var queryStatement: OpaquePointer? = nil
        var userObject : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let zipcode = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let companyName = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                
                userObject.append(User(id: id, name: name, email: email, zipcode: zipcode, companyName: companyName))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return userObject
    }
    
}

