//
//  Note.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/2/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit

class Note {
    
    var id: Int
    var title: String
    var note: String
    var photo: UIImage?
    var photoUrl: String
    
    init?(id: Int, title: String, note: String, photo: UIImage?, photoUrl: String) {
        // Initialization should fail if there is no title or no note body
        if title.isEmpty || note.isEmpty {
            return nil
        }
        // Initialize stored properties
        self.id = id
        self.title = title
        self.note = note
        self.photo = photo
        self.photoUrl = photoUrl
    }
    
}
