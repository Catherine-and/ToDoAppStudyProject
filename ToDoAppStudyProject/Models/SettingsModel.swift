//
//  SettingsModel.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 22.10.2024.
//

import Foundation
import RealmSwift

class Settings: Object {
    
    @objc dynamic var pickedTime: String?
    @objc dynamic var pickedHour: Int = 0
    @objc dynamic var pickedMin: Int = 0
    
    convenience init(pickedTime: String, pickedHour: Int, pickedMin: Int) {
        self.init()
        self.pickedTime = pickedTime
        self.pickedHour = pickedHour
        self.pickedMin = pickedMin
    }
 
}
