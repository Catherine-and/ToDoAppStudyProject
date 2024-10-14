//
//  MainViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 07.09.2024.
//

import UIKit
import RealmSwift

class ToDoListViewController: UIViewController {
    
    var tasks: Results<Task>!
    var filteredTasks: Results<Task>!
    var currentFilter: UIBarButtonItem!
    
    let tabBar = UITabBarController()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addTaskButtonLabel: UIButton!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    
    @IBOutlet weak var allTasksButton: UIBarButtonItem!
    @IBOutlet weak var overdueTasksButton: UIBarButtonItem!
    @IBOutlet weak var todayTasksButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customNavigationBar.shadowImage = UIImage()
        
        addTaskButtonLabel.tintColor = .deepViolet
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        setButtonColors(for: todayTasksButton)
        
        tasks = realm.objects(Task.self)
        filteredTasks = tasks
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterTasks(by: todayTasksButton)
        
    }
    
    func formatDateForCell(_ date: Date?, for text: UILabel) -> String {
        guard let date = date else { return "" }
        
        let today = Date()
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        dateFormatter.dateFormat = "dd MMM"
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(date) {
            text.textColor = .red
            return "Yesterday"
        } else if date < today {
            text.textColor = .red
            return dateFormatter.string(from: date)
        }
        
        return dateFormatter.string(from: date)
    }
    
    func filterTasks(by filterType: UIBarButtonItem) {
        let today = Date()
        let calendar = Calendar.current
        
        switch filterType {
        case todayTasksButton:
            let startOfDay = calendar.startOfDay(for: today)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            filteredTasks = tasks.filter("toBeDoneDate >= %@ AND toBeDoneDate < %@", startOfDay, endOfDay)
            
        case overdueTasksButton:
            let startOfDay = calendar.startOfDay(for: today)
            filteredTasks = tasks.filter("toBeDoneDate < %@", startOfDay)
            
        default:
            filteredTasks = tasks
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MoveToExistedTaskVC", let indexPath = sender as? IndexPath {
            let task = filteredTasks[indexPath.row]
            
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
        
        filterTasks(by: currentFilter ?? todayTasksButton)
    }
    
    @IBAction func allBarButtonTapped(_ sender: UIBarButtonItem) {
        setButtonColors(for: sender)
        currentFilter = sender
        filterTasks(by: sender)
    }
    
    @IBAction func overdueBarButtonTapped(_ sender: UIBarButtonItem) {
        setButtonColors(for: sender)
        currentFilter = sender
        filterTasks(by: sender)
    }
    
    @IBAction func todayBarButtonTapped(_ sender: UIBarButtonItem) {
        setButtonColors(for: sender)
        currentFilter = sender
        filterTasks(by: sender)
    }
    
    
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.isEmpty ? 0 : filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let task = filteredTasks[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.descriptionLabel.text = task.descriptionText
        cell.dateLabel.textColor = .blue
        cell.dateLabel.text = formatDateForCell(task.toBeDoneDate, for: cell.dateLabel)
        cell.isChecked = task.isDone
        let imageName = cell.isChecked ? "selected" : "unselected"
        cell.checkBoxButton.setImage(UIImage(named: imageName), for: .normal)
        cell.delegate = self
        
        return cell
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
        let task = filteredTasks[indexPath.row]
        
        try! realm.write {
            task.isDone = cell.isChecked
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    func setButtonColors(for selectedButton: UIBarButtonItem) {
        
        allTasksButton.tintColor = .gray
        overdueTasksButton.tintColor = .gray
        todayTasksButton.tintColor = .gray
        
        selectedButton.tintColor = .blue
    }
}

extension ToDoListViewController: ExistedTaskVCDelegate {
    
    func didDeleteTask(task: Task) {
        if let index = tasks.index(of: task) {
            TaskStorageManager.deleteObject(task)
            
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func didChangeTask(task: Task) {
        filterTasks(by: currentFilter)
        tableView.reloadData()
    }
}
