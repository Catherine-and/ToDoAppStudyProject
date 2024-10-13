//
//  DataBase.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 08.09.2024.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
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
