//
//  CalendarViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 20.09.2024.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    
    func setDate(date: String)
}

class CalendarViewController: UIViewController {

    weak var delegate: CalendarViewControllerDelegate?
    var date = ""
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.delegate?.setDate(date: date)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let dateValue = dateFormatter.string(from: sender.date)
        date = dateValue
    }
    

}
