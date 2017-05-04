//
//  Note.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/2/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit
import RealmSwift

class Note: Object {
    
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var note: String = ""
    var photo: UIImage?
    dynamic var photoUrl: String = ""
    
//    init?(id: Int, title: String, note: String, photo: UIImage?, photoUrl: String) {
//        // Initialization should fail if there is no title or no note body
//        if title.isEmpty || note.isEmpty {
//            return nil
//        }
//        // Initialize stored properties
//        self.id = id
//        self.title = title
//        self.note = note
//        self.photo = photo
//        self.photoUrl = photoUrl
//    }
    
    override static func ignoredProperties() -> [String] {
        return ["photo"]
    }
    
}
