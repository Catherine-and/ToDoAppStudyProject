//
//  ExistedTaskViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 15.09.2024.
//

import UIKit

protocol ExistedTaskVCDelegate: AnyObject {
    func didDeleteTask(task: Task)
}

class ExistedTaskViewController: UIViewController {

    var task: Task?

    weak var delegate: ExistedTaskVCDelegate?
    
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
    
    func updateUI() {
        
        titleLabel.text = task?.title
        descriptionLabel.text = task?.descriptionText
        dateLabel.text = task?.date
    }

    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertMessage = UIAlertController(title: "You're about to completely delete the task", message: "Are you sure?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            guard let self = self, let task = self.task else { return }
            
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
