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
    
    override static func ignoredProperties() -> [String] {
        return ["photo"]
    }
    
}
