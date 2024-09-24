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
    var selectedDate: Date?
    
    weak var delegate: ExistedTaskVCDelegate?
    
    var isTaskChanged = false
    var dateButtonTitle = ""
    
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTView: UITextView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var dateButtonExistedVC: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        
        titleTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        descriptionTView.delegate = self
        selectedDate = currentTask?.toBeDoneDate
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("func viewWillDisappear: \(dateButtonTitle)")
        changeData()
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        isTaskChanged = true
    }
    
    func updateUI() {
        
        guard let task = currentTask else { return }
        
        titleTF.text = task.title
        descriptionTView.text = task.descriptionText
        dateButtonTitle = task.date!
        dateButtonExistedVC.setTitle(dateButtonTitle, for: .normal)
    }
    
    func changeData() {
        
        if isTaskChanged, let task = currentTask {
            print("func changeData: \(dateButtonTitle)")
            
            try? realm.write {
                task.title = titleTF.text
                task.descriptionText = descriptionTView.text
                task.date = dateButtonTitle
                task.toBeDoneDate = selectedDate
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
    
    @IBAction func dateButtonEVCTapped(_ sender: UIButton) {
        
        let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
        
        calendarVC.selectedDate = selectedDate
        calendarVC.delegate = self
        
        if let sheet = calendarVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.present(calendarVC, animated: true)
    }
    
}

extension ExistedTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        isTaskChanged = true
    }
}

extension ExistedTaskViewController: CalendarViewControllerDelegate {
    func setDate(date: Date) {
        selectedDate = date
        updateButtonTitle(with: date)
        isTaskChanged = true
    }
    
    
    func updateButtonTitle(with date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM"
        let dateString = dateFormatter.string(from: date)
        dateButtonTitle = dateString
        
        dateButtonExistedVC.setTitle(dateString, for: .normal)
    }
}
