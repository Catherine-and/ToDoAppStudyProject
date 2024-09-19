//
//  MainViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 07.09.2024.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks: Results<Task>!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addTaskButtonLabel: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = realm.objects(Task.self)
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.isEmpty ? 0 : tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let task = tasks[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.descriptionText
        cell.dateLabel.text = task.date
        cell.isChecked = task.isDone
        let imageName = cell.isChecked ? "selected" : "unselected"
        cell.checkBoxButton.setImage(UIImage(named: imageName), for: .normal)
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MoveToExistedTaskVC", let indexPath = sender as? IndexPath {
            let task = tasks[indexPath.row]
            
            if let existedTaskVC = segue.destination as? ExistedTaskViewController {
                existedTaskVC.delegate = self
                existedTaskVC.currentTask = task
                
                if let sheet = existedTaskVC.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.preferredCornerRadius = 15.0
                }
            }
        }
    }
    
    @IBAction func addNewTaskAction(_ sender: UIButton) {
        
        let  newTaskVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewTaskViewController")
        
        if let sheet = newTaskVC.sheetPresentationController {
            
            sheet.detents = [.custom(resolver: { context in
                0.15 * context.maximumDetentValue
            })]
        }
        self.present(newTaskVC, animated: true)
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newTaskVC = segue.source as? NewTaskViewController else { return }
        newTaskVC.saveNewTask()
        tableView.reloadData()
        
    }
}


extension ToDoListViewController: CustomTableViewCellDelegate {
    
    func cellTapped(cell: CustomTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            performSegue(withIdentifier: "MoveToExistedTaskVC", sender: indexPath)
        }
    }
    
    func checkBoxToggled(cell: CustomTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let task = tasks[indexPath.row]
        
        try! realm.write {
            task.isDone = cell.isChecked
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ToDoListViewController: ExistedTaskVCDelegate {
    
    func didDeleteTask(task: Task) {
        if let index = tasks.index(of: task) {
            StorageManager.deleteObject(task)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func didChangeTask(task: Task) {
        tableView.reloadData()
    }
}
