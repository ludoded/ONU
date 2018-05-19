//
//  FirebaseManager.swift
//  final
//
//  Created by Haik Ampardjian on 19.05.2018.
//  Copyright © 2018 Haik Ampardjian. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    private var storage = Storage.storage()
    
    private init() {}
    
    func uploadData(data: Data, completion: @escaping (Error?) -> Void) {
        let timestamp = Date().timeIntervalSince1970
        let videoName = "\(timestamp).mov"
        let movieRef = storage.reference(withPath: "videos/\(videoName)")
        
        movieRef.putData(data, metadata: nil) { (_, error) in
            completion(error)
        }
    }
}
