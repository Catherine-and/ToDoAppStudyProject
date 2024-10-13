//
//  UIView+Extension.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 12.10.2024.
//

import UIKit

extension UIView {
    
    func pin(to supeview: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: supeview.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: supeview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: supeview.trailingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: supeview.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: supeview.bottomAnchor).isActive = true
        
    }
}


