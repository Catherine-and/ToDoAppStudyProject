//
//  DataBase.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 08.09.2024.
//

import RealmSwift


class TaskStorageManager {
    
    static func saveObject (_ task: Task) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(task)
        }
    }
    
    static func deleteObject (_ task: Task) {
        let realm = try! Realm()

        try! realm.write {
            realm.delete(task)
        }
    }
}

class FocusStorageManager {
    
    static func saveObject (_ focus: Focus) {
        let realm = try! Realm()

        try! realm.write {
            realm.add(focus)
        }
    }
    
    static func deleteObject (_ focus: Focus) {
        let realm = try! Realm()

        try! realm.write {
            realm.delete(focus)
        }
    }
}

class SettingsStorageManager {
    
    static func saveObject (_ setting: Settings) {
        let realm = try! Realm()

        try! realm.write {
            realm.add(setting)
        }
    }
    
    static func deleteObject (_ setting: Settings) {
        let realm = try! Realm()

        try! realm.write {
            realm.delete(setting)
        }
    }
}

