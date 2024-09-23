//
//  CalendarViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 20.09.2024.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    
    func setDate(date: Date)
}

class CalendarViewController: UIViewController {
    
    weak var delegate: CalendarViewControllerDelegate?
    
    var date = ""
    var selectedDate: Date?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        if let date = selectedDate {
            datePicker.date = date
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        let selctedDateFromPicker = datePicker.date
        self.delegate?.setDate(date: selctedDateFromPicker)
        dismiss(animated: true, completion: nil)
    }
    
}
