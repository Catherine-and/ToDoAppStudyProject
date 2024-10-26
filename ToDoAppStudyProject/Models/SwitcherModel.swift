//
//  SwitcherModel.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 25.10.2024.
//

import Foundation
import RealmSwift

class Switcher: Object {
    
    @objc dynamic var isSwiched: Bool = false
    
    convenience init(isSwiched: Bool) {
        self.init()
        self.isSwiched = isSwiched
    }
}
