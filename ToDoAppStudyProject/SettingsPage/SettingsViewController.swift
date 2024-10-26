//
//  SettingsViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 21.10.2024.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {
    
    var settings: Results<Settings>!
    var switcher: Results<Switcher>!
    
    var currentSettings: Settings?
    var currentSwitcher: Switcher?
    
    var chosenTime: Date?
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var addTimeBtn: UIButton!
    @IBOutlet weak var notificationTimeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings = realm.objects(Settings.self)
        switcher = realm.objects(Switcher.self)
        
        
        loadSwitchState()
        loadNotificationTime()
        
        if switchBtn.isOn {
            dispatchNotification()
        } else {
            secondView.isHidden = true
            addTimeBtn.isHidden = true
            notificationTimeBtn.isHidden = true
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pickedTime = currentSettings {
            notificationTimeBtn.setTitle(pickedTime.pickedTime, for: .normal)
        }
        
    }
    
    
    func loadSwitchState() {
        // Проверяем, существует ли текущий объект Switcher в базе данных
        if let savedSwitcher = switcher.first {
            currentSwitcher = savedSwitcher
        } else {
            // Если объект не найден, создаем и сохраняем новый
            let newSwitchStatus = Switcher()
            try? realm.write {
                realm.add(newSwitchStatus)
            }
            currentSwitcher = newSwitchStatus
        }
        
        // Устанавливаем состояние UISwitch в соответствии с данными в базе
        switchBtn.isOn = currentSwitcher?.isSwiched ?? false
    }
    
    func loadNotificationTime() {
        
        if let savedSettings = settings.first {
            currentSettings = savedSettings
            notificationTimeBtn.setTitle(savedSettings.pickedTime, for: .normal)
        } else {
            let newSettings = Settings()
            SettingsStorageManager.saveObject(newSettings)
            currentSettings = newSettings
        }
    }
    
    func checkForPermission() {
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            default: return
            }
        }
    }
    
    func dispatchNotification() {
        
        let id = "my notification"
        let title = "My app"
        let body = "Let's go running"
        let isDaily = true
        
        var hour = 0
        var minute = 0
        
        if let pickedTime = currentSettings {
            hour = pickedTime.pickedHour
            minute = pickedTime.pickedMin
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        notificationCenter.add(request)
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoChangeTime" {
            
            if let timeNotificationsPickerVC = segue.destination as? TimeNotificationsPickerViewController {
                
                if let savedTime = currentSettings?.pickedTime, let time = convertToTime(savedTime) {
                    timeNotificationsPickerVC.currentPickedTime = time
                } else {
                    timeNotificationsPickerVC.currentPickedTime = Date()
                }
            }
        }
    }
    
    func  convertToTime(_ time: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.date(from: time)
    }
    
    @IBAction func turnOnOffNotifications(_ sender: UISwitch) {
        
        try? realm.write {
            currentSwitcher?.isSwiched = sender.isOn
        }
        
        notificationTimeBtn.isHidden = !sender.isOn
        secondView.isHidden = !sender.isOn
        addTimeBtn.isHidden = !sender.isOn
        
        if sender.isOn {
            checkForPermission()
            dispatchNotification()
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let timeNotificationsPickerVC = segue.source as? TimeNotificationsPickerViewController else { return }
        
        let newTime = Settings(pickedTime: timeNotificationsPickerVC.timeValueString,
                               pickedHour: timeNotificationsPickerVC.hour,
                               pickedMin: timeNotificationsPickerVC.minute)
        
        if currentSettings != nil  {
            
            try? realm.write {
                currentSettings?.pickedTime = newTime.pickedTime
                currentSettings?.pickedHour = newTime.pickedHour
                currentSettings?.pickedMin = newTime.pickedMin
            }
        } else {
            SettingsStorageManager.saveObject(newTime)
            currentSettings = newTime
        }
        
        dispatchNotification()
        
        notificationTimeBtn.setTitle(currentSettings?.pickedTime, for: .normal)
        
        chosenTime = timeNotificationsPickerVC.currentPickedTime
    }
    
    
}
