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
    @objc dynamic var intTime: Int = 0
    convenience init(title: String, time: String) {
        self.init()
        
        self.title = title
        self.time = time
    }
    
    convenience init(time: String) {
        self.init()
        
        self.time = time
    }
    
    convenience init(title: String) {
        self.init()
        
        self.title = title
    }
    
    
}
