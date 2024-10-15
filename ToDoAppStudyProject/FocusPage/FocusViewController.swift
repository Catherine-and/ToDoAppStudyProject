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
    
    @IBOutlet weak var topBar: UINavigationItem!
    
    
    
    var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = .lightBlue
        
        return tableView
    }()
    
    lazy var addFocusBtn: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "add")
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightBlue
        self.topBar.rightBarButtonItem = addFocusBtn
        
        tableView.register(FocusCell.nib(), forCellReuseIdentifier: FocusCell.identifier)
        
        configureTableView()
        
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FocusCell.identifier, for: indexPath) as! FocusCell
        cell.configure(with: "Study", timeTitle: "50m")
        cell.playButton.addTarget(self, action: #selector(startFocus), for: .touchUpInside)
        
        return cell
    }
    
    @objc func startFocus() {
        
        let  stopWatchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StopWatchViewController") as! StopWatchViewController
        
        stopWatchVC.playBtnTapped()
        
        if let sheet = stopWatchVC.sheetPresentationController {
            sheet.detents = [.large()]
        }
        self.present(stopWatchVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
