//
//  FilesManager.swift
//  MoviesApp
//
//  Created by Mostafa Abd ElFatah on 5/21/22.
//

import Foundation


class FilesManager {

    // MARK: - getDestinationURL -
    public static var destinationURL: URL? {
        guard let path = try? FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("MoviesApp/DB")
                .path
        else { return nil }
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    // MARK: - deleteFileIfExists -
    public static func createFile(filePath:String) throws {
        if FileManager.default.fileExists(atPath: filePath) { return }
        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
    }
    
    // MARK: - deleteFileIfExists -
    public static func deleteFileIfExists(fileURL:URL) throws {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try FileManager.default.removeItem(at: fileURL)
        }
    }
    
    //MARK: - isFileDownloaded -
    public static func isFileExists(filePath:String) -> Bool  {
        FileManager.default.fileExists(atPath: filePath)
    }
}
