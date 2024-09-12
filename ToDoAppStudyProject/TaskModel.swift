//
//  TaskModel.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 07.09.2024.
//

import UIKit
import RealmSwift

class Task: Object {
    
    @objc dynamic var title: String?
    @objc dynamic var descriptionText: String?
    @objc dynamic var date: String?
    
    convenience init(title: String, descriptionText: String? = nil, date: String? = nil) {
        self.init()
        self.title = title
        self.descriptionText = descriptionText
        self.date = date
    }
    
}
