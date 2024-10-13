//
//  FocusModel.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 13.10.2024.
//

import Foundation
import RealmSwift

class Focus: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var time: String = ""
    
    convenience init(title: String, time: String) {
        self.init()
        
        self.title = title
        self.time = time
    }
    
}
