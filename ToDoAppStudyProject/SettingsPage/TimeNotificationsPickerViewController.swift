//
//  TimeNotificationsPickerViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 23.10.2024.
//

import UIKit

class TimeNotificationsPickerViewController: UIViewController {

    var currentPickedTime: Date?
    
    var timeValueString = ""
    var hour = 0
    var minute = 0
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.date = currentPickedTime ?? Date()
     
    }
    
    @IBAction func chooseTime(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        let timeValue = dateFormatter.string(from: sender.date)
        timeValueString = timeValue

        if let date = dateFormatter.date(from: timeValue) {
            
            let calendar = Calendar.current
            hour = calendar.component(.hour, from: date)
            minute = calendar.component(.minute, from: date)
            currentPickedTime = date
            
        }
    }
    
    @IBAction func cancelWindow(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
