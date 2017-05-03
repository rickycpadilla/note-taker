//
//  Note.swift
//  Swift Sandbox
//
//  Created by Ricky Padilla on 5/2/17.
//  Copyright © 2017 Ricky Padilla. All rights reserved.
//

import UIKit

class Note {
    
    var title: String
    var note: String
    var photo: UIImage?
    
    init?(title: String, note: String, photo: UIImage?) {
        // Initialization should fail if there is no title or no note body
        if title.isEmpty || note.isEmpty {
            return nil
        }
        // Initialize stored properties
        self.title = title
        self.note = note
        self.photo = photo
    }
    
}
