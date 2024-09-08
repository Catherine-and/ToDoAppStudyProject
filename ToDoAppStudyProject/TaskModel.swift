//
//  TaskModel.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 07.09.2024.
//

import UIKit
import RealmSwift

class Task: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var text: String?
    @objc dynamic var date: Date?
    
    convenience init(title: String, text: String? = nil, date: Date? = nil) {
        self.init()
        self.title = title
        self.text = text
        self.date = date
    }
    
}
