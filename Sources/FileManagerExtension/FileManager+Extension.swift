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
    
    public func saveDocument(contents: String, docName: String, completion: (Error?) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            completion(error)
        }
    }
    
    func readDocument(docName: String, completion: (Result<Data, Error>) -> Void) {
        let url = Self.docDirURL.appendingPathComponent(docName)
        
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func docExists(named docName: String) -> Bool {
        let path = Self.docDirURL.appendingPathComponent(docName).path
        return fileExists(atPath: path)
    }

    func deleteDocument() {
        
    }
    
    func saveJSON<T: Codable>(data: T, docName: String, completion: (Error?) -> Void) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(data)
            let jsonString = String(decoding: data, as: UTF8.self)
            saveDocument(contents: jsonString, docName: docName, completion: { error in completion(error) })
        } catch {
            completion(error)
        }
    }
    
    func readJSON<T: Codable>(docName: String, completion: (Result<T, Error>) -> Void) {
        readDocument(docName: docName) { (result) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
