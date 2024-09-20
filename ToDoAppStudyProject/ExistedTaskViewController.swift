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
        

        titleLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //dateLabel.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        descriptionLabel.delegate = self
        
        updateUI()
        
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
            changeData()
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        isTaskChanged = true
    }
    
    func updateUI() {
        
        guard let task = currentTask, !task.isInvalidated else { return }
        
        titleLabel.text = task.title
        descriptionLabel.text = task.descriptionText
        //dateLabel.text = task.date
    }
    
    func changeData() {
        
        if isTaskChanged, let task = currentTask {
            
            try? realm.write {
                task.title = titleLabel.text
                task.descriptionText = descriptionLabel.text
                //task.date = dateLabel.text

            }
            self.delegate?.didChangeTask(task: task)
        }
    }

    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertMessage = UIAlertController(title: "You're about to completely delete the task", message: "Are you sure?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self] action in
            guard let self = self, let task = self.currentTask else { return }
            
            self.delegate?.didDeleteTask(task: task)
            currentTask = nil
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)

        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertMessage.addAction(yes)
        alertMessage.addAction(cancel)
        
        self.present(alertMessage, animated: true)

    }
    
}

extension ExistedTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        isTaskChanged = true
    }
}
