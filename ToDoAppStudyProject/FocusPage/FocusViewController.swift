//
//  FocusViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 10.10.2024.
//

import UIKit

class FocusViewController: UIViewController{
    
    var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.backgroundColor = .lightBlue
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightBlue
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: FocusCell.identifier, for: indexPath) as! FocusCell
            cell.configure(with: "Study", timeTitle: "50m")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
