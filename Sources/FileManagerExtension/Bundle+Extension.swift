//
//  Bundle+Extension.swift
//  FileManagerExtension-SPM//
//
//  Created by Esben Viskum on 02/06/2021.
//

import Foundation

extension Bundle {
    
    /// Bundle extension to read Data from a file in the bundle
    /// - Parameters:
    ///   - docName: File name to read from in the document directory
    ///   - completion: Completion closure, called with with Data in case of success and Error in case of failure
    ///
    public func readDocument(docName: String, completion: (Result<Data, Error>) -> Void) {
        do {
            let url = self.url(forResource: docName, withExtension: nil)
            let data = try Data(contentsOf: url!)
            print("readDocument: File read successfully")
            completion(.success(data))
        } catch {
            print ("readDocument: Unable to read file")
            completion(.failure(error))
        }
    }

    
    /// Bundle extension to read Decodable JSON data from a file in the document directory
    /// - Parameters:
    ///   - type: data Type
    ///   - docName: File name to read from in the bundle
    ///   - completion: Completion closure, called with with decoded Data in case of success and Error in case of failure
    ///
    public func readJSON<T: Codable>(_ type: T.Type, docName: String, completion: (Result<T, Error>) -> Void) {
        readDocument(docName: docName) { (result) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    print("readJSON: json decoded successfully")
                    completion(.success(decodedData))
                } catch {
                    print("readJSON: Unable to decode JSON")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("readJSON: Unable to read document")
                completion(.failure(error))
            }
        }
    }
}
