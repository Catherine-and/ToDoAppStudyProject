//
//  FocusViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 10.10.2024.
//

import UIKit
import RealmSwift

class FocusViewController: UIViewController{
    
    var focuses: Results<Focus>!
    
    var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = .lightBlue
        
        return tableView
    }()
    
    @IBOutlet weak var addFocusBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        focuses = realm.objects(Focus.self)

        view.backgroundColor = .lightBlue
       
        tableView.register(FocusCell.nib(), forCellReuseIdentifier: FocusCell.identifier)
        
        configureTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFocus))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
     @objc func addFocus() {
      
      let alert = UIAlertController(title: "New focus",
                                    message: "",
                                    preferredStyle: .alert)
         
         alert.addTextField()

         let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
             if let focusName = alert.textFields?.first?.text {
                 
                 let newFocus = Focus(title: focusName,
                                      time: "0m")
                 FocusStorageManager.saveObject(newFocus)
                 
                 self.tableView.reloadData()
             }
         }
         let cancel = UIAlertAction(title: "Cancel", style: .cancel)
         alert.addAction(saveButton)
         alert.addAction(cancel)
         
         present(alert, animated: true)
    }
    
    func configureTableView() {
        
        view.addSubview(tableView)
        
        setTableViewDelegates()
        
        tableView.rowHeight = 50
        tableView.backgroundColor = .lightBlue
        tableView.pin(to: view)
        tableView.separatorStyle = .none
    }
    
    private func setTableViewDelegates() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}


// MARK: - Work with TableView

extension FocusViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  focuses.isEmpty ? 0 : focuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let focus = focuses[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FocusCell.identifier, for: indexPath) as! FocusCell
        
        cell.configure(with: focus.title, timeTitle: focus.time)
        
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(startFocus(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func startFocus(sender: UIButton) {
        
        let  stopWatchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StopWatchViewController") as! StopWatchViewController
        
        let selectedIndex = sender.tag
        let selectedFocus = focuses[selectedIndex]
        
        stopWatchVC.currentFocus = selectedFocus
        stopWatchVC.nameFocusLabel.text = selectedFocus.title
        
        stopWatchVC.playBtnTapped()
        
        stopWatchVC.delegate = self
        
        if let sheet = stopWatchVC.sheetPresentationController {
            sheet.detents = [.large()]
        }
        self.present(stopWatchVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}


extension FocusViewController: StopWatchViewControllerDelegate {
    
    func didChangeFocus(focus: Focus) {
        tableView.reloadData()
    }
    
    
}
//extension FocusViewController: FocusCellDelegate {
//    
//    func cellTapped(cell: FocusCell) {
//        if let indexPath = tableView.indexPath(for: cell) {
//            performSegue(withIdentifier: "MoveToStopwatchVC", sender: indexPath)
//        }
//    }
//    
//}
