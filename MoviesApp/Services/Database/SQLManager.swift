//
//  SQLManager.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import GRDB
import Foundation

fileprivate let appDataDBQueue:DatabaseQueue = {
    let fileManager = FileManager.default
    
    let dbPath = FilesManager.destinationURL!
        .appendingPathComponent("AppData.db")
        .path
    if !FilesManager.isFileExists(filePath: dbPath){
        try? FilesManager.createFile(filePath: dbPath)
    }
    return try! DatabaseQueue(path: dbPath)
}()

class SQLManager {
    
    
    public static func createDBTable() throws {
        try appDataDBQueue.write { db in
            try db.execute(sql: """
                CREATE TABLE IF NOT EXISTS "movies" (
                    "id"    TEXT NOT NULL  UNIQUE,
                    "owner"    TEXT,
                    "secret"    TEXT,
                    "server"    TEXT,
                    "farm"    INTEGER,
                    "title"    TEXT,
                    "ispublic"    INTEGER,
                    "isfriend"    INTEGER,
                    "isfamily"    INTEGER,
                     PRIMARY KEY(id)
                );
                """
            )
        }
    }
    
    
    init() {
        try? SQLManager.createDBTable()
    }
    
}

extension SQLManager: DBManagerProtocol{
    
    // MARK: - fetchMoviesList -
    func fetchMoviesList(currentOffset:Int, pageSize:Int = 20) -> [Photo]{
        do {
            return try appDataDBQueue.read({ db in
                let query = "SELECT * FROM movies LIMIT \(pageSize) OFFSET \(currentOffset)"
                let moviesList = try Photo.fetchAll(db, sql: query)
                return moviesList
            })
        } catch {
            print(error)
            return []
        }
    }
    
    // MARK: - saveMovies -
    func saveMovies(_ movies:[Photo]) {
        var query = "REPLACE INTO movies (id, owner, secret, server, farm, title, ispublic, isfriend, isfamily) VALUES "
        
        var arguments:[Any] = []
        
        for movie in movies {
            query += "(?, ?, ?, ?, ?, ?, ?, ?, ?), "
            arguments.append(contentsOf: [movie.id, movie.owner, movie.secret, movie.server, movie.farm, movie.title, movie.ispublic, movie.isfriend, movie.isfamily])
        }
        query.removeLast(2)
        query += ";"
        do {
            try appDataDBQueue.write({ db in
                try db.execute(
                    sql: query,
                    arguments: StatementArguments(arguments)!)
            })
        } catch {
            print(error)
        }
    }
    
    // MARK: - saveMovie -
    func saveMovie(_ photo:Photo) {
        do {
            try appDataDBQueue.write({ db in
                try db.execute(
                    sql: "INSERT INTO movies (id, owner, secret, server, farm, title, ispublic, isfriend, isfamily) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);",
                    arguments: [photo.id, photo.owner, photo.secret, photo.server, photo.farm, photo.title, photo.ispublic, photo.isfriend, photo.isfamily])
            })
        } catch {
            print(error)
        }
    }
    
    // MARK: - delete with id -
    func delete(id:String) {
        do {
            try appDataDBQueue.write({ db in
                try db.execute(
                    sql: "DELETE FROM movies WHERE id = ?;",
                    arguments: [id])
            })
        } catch {
            print(error)
        }
    }
    
    // MARK: - deleteMovies -
    func deleteMovies() {
        do {
            try appDataDBQueue.write({ db in
                try db.execute(sql: "DELETE FROM movies;")
            })
        } catch {
            print(error)
        }
    }
    
}


