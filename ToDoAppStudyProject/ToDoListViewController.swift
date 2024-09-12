//
//  MainViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 07.09.2024.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var task: Results<Task>!

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addTaskButtonLabel: UIButton!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task = realm.objects(Task.self)
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.isEmpty ? 0 : task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
         
        let task = task[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.descriptionText
        cell.dateLabel.text = task.date
        
        
        return cell
    }
    

    // MARK: - Navigation
    
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
