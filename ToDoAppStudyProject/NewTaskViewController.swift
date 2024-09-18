//
//  CreationNewTaskViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 10.09.2024.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    var currentTask: Task?
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var date: UITextField!
    
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        saveButton.isEnabled = false
        
        titleText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        updateButtonState()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        descriptionTextView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make focus to a textField right at the pint of opening a screen
        self.titleText.becomeFirstResponder()
    }
    
    
    @objc func updateTextView(notification: Notification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardFrame.height
        updateBottomLayoutConstraint(with: keyboardHeight)
    }
    
    func updateBottomLayoutConstraint(with height: CGFloat) {
        bottomButtonConstraint.constant = height + 16.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func saveNewTask() {
        
        let newTask = Task(title: titleText.text!,
                           descriptionText: descriptionTextView.text!,
                           date: date.text!)
        
//        if currentTask != nil {
//        
//            try? realm.write {
//                currentTask?.title = newTask.title
//                currentTask?.descriptionText = newTask.descriptionText
//                currentTask?.date = newTask.date
//            }
            
  //      } else {
            StorageManager.saveObject(newTask)
 //       }
    }
}


// MARK: TextField delegate

extension NewTaskViewController: UITextFieldDelegate {
    
    @objc func textFieldChanged() {
        
        if titleText.text?.isEmpty == false || descriptionTextView.text?.isEmpty == false {
            saveButton.isEnabled = true
    
        } else {
            saveButton.isEnabled = false
        }
    }
}

extension NewTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        updateButtonState()
    }
    
    func updateButtonState() {
        
        if descriptionTextView.text.isEmpty == false {
            saveButton.isEnabled = true
            
        } else {
            saveButton.isEnabled = false
        }
    }
}
