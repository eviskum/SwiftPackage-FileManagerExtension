//
//  FileManager+Extension.swift
//  FileManagerExtension-SPM
//
//  Created by Esben Viskum on 24/05/2021.
//

import Foundation

extension FileManager {
    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
 
    
    /// FileManager extension to save a String to a file in the document directory
    /// - Parameters:
    ///   - contents: String to save
    ///   - docName: File name to write to in the document directory
    ///   - completion: Completions closure, called in case of error.
    ///
    public func saveDocument(contents: String, docName: String, completion: (Error?) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            completion(error)
        }
    }
    
    
    /// FileManager extension to read Data from a file in the document directory
    /// - Parameters:
    ///   - docName: File name to read from in the document directory
    ///   - completion: Completion closure, called with with Data in case of success and Error in case of failure
    ///
    public func readDocument(docName: String, completion: (Result<Data, Error>) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        print("readDocument: Reading data from \(url.path)")
        
        do {
            let data = try Data(contentsOf: url)
//            print("readDocument: File read successfully")
            completion(.success(data))
        } catch {
//            print ("readDocument: Unable to read file")
            completion(.failure(error))
        }
    }
    
    
    /// FileManager extension to check if a file exists in the document directory
    /// - Parameter docName: File name to check
    /// - Returns: Return true if file exists, false if file does not exist
    ///
    public func docExists(named docName: String) -> Bool {
        let path = Self.docDirURL.appendingPathComponent(docName).path
        return fileExists(atPath: path)
    }


    
    /// FileManager extension to delete a file in the document directory
    /// - Parameters:
    ///   - docName: File name to delete
    ///   - completion: Completions closure, called in case of error.
    ///
    public func deleteDocument(docName: String, completion: (Error?) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
            try removeItem(at: url)
        } catch {
            completion(error)
        }
    }

    
    /// FileManager extension to save Encodable JSON data to a file in the document directory
    /// - Parameters:
    ///   - data: Encodable data to save
    ///   - docName: File name to write to in the document directory
    ///   - completion: Completions closure, called in case of error.
    ///
    public func saveJSON<T: Codable>(data: T, docName: String, completion: (Error?) -> Void) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(data)
            let jsonString = String(decoding: data, as: UTF8.self)
            saveDocument(contents: jsonString, docName: docName, completion: { error in completion(error) })
        } catch {
            completion(error)
        }
    }

    
    /// FileManager extension to read Decodable JSON data from a file in the document directory
    /// - Parameters:
    ///   - type: data Type
    ///   - docName: File name to read from in the document directory
    ///   - completion: Completion closure, called with with decoded Data in case of success and Error in case of failure
    ///
    public func readJSON<T: Codable>(_ type: T.Type, docName: String, completion: (Result<T, Error>) -> Void) {
        readDocument(docName: docName) { (result) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
//                    print("readJSON: json decoded successfully")
                    completion(.success(decodedData))
                } catch {
//                    print("readJSON: Unable to decode JSON")
                    completion(.failure(error))
                }
            case .failure(let error):
//                print("readJSON: Unable to read document")
                completion(.failure(error))
            }
        }
    }
    
    
    /// FileManager extension to print document directory path. Mainly used for debugging in simulator.
    ///
    public func printPath() {
        print("Document path: \(Self.docDirURL.path)")
    }
}
