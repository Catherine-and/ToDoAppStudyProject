//
//  DataBase.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 08.09.2024.
//

import RealmSwift

let realm = try! Realm()

class TaskStorageManager {
    
    static func saveObject (_ task: Task) {
        try! realm.write {
            realm.add(task)
        }
    }
    
    static func deleteObject (_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
}

class FocusStorageManager {
    
    static func saveObject (_ focus: Focus) {
        try! realm.write {
            realm.add(focus)
        }
    }
    
    static func deleteObject (_ focus: Focus) {
        try! realm.write {
            realm.delete(focus)
        }
    }
}

class SettingsStorageManager {
    
    static func saveObject (_ setting: Settings) {
        try! realm.write {
            realm.add(setting)
        }
    }
}

