//
//  ExistedTaskViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 15.09.2024.
//

import UIKit

protocol ExistedTaskVCDelegate: AnyObject {
    func didDeleteTask(task: Task)
    func didChangeTask(task: Task)
}

class ExistedTaskViewController: UIViewController {

    var currentTask: Task?

    weak var delegate: ExistedTaskVCDelegate?
    var isTaskChanged = false
    
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        changeData()
        
    }
    
    func updateUI() {
        
        titleLabel.text = currentTask?.title
        descriptionLabel.text = currentTask?.descriptionText
        dateLabel.text = currentTask?.date
        
    }
    
    func changeData() {
        try? realm.write {
            currentTask?.title = titleLabel.text
            currentTask?.descriptionText = descriptionLabel.text
            currentTask?.date = dateLabel.text
        }
        
        self.delegate?.didChangeTask(task: currentTask!)
        
    }
    
    

    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertMessage = UIAlertController(title: "You're about to completely delete the task", message: "Are you sure?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            guard let self = self, let task = self.currentTask else { return }
            
            self.delegate?.didDeleteTask(task: task)
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)

        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertMessage.addAction(yes)
        alertMessage.addAction(cancel)
        
        self.present(alertMessage, animated: true)

    }
    
}
