//
//  StopWatchViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 12.10.2024.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    var scheduledTimer = Timer()
    var currentFocus: Focus?
    
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var timerCounting = false
    
    var stopwatchText = ""
    
    lazy var stopwatchLabel: UILabel = {
        
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 86, weight: .light)
        label.font = .monospacedDigitSystemFont(ofSize: 86, weight: .light)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var playButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "playStopwatch"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    lazy var resetButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "stop"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    lazy var buttonsStackView: UIStackView = {
        
        let view = UIStackView(arrangedSubviews: [playButton,
                                                  resetButton])
        view.axis = .horizontal
        view.spacing = 30
        view .alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        
        let view = UIStackView(arrangedSubviews: [stopwatchLabel,
                                                  buttonsStackView])
        view.axis = .vertical
        view.spacing = 50
        view .alignment = .center
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightBlue
        
        addSubviews()
        
        setupConstraints()
        
        DispatchQueue.main.async {
            
            self.playButton.addTarget(self, action: #selector(self.playBtnTapped), for: .touchUpInside)
            self.resetButton.addTarget(self, action: #selector(self.resetBtnTapped), for: .touchUpInside)
        }
        print("\(timerCounting) after first opening")

//        if timerCounting {
//            print("\(timerCounting) after second opening")
//            startTimer()
//            
//        } else {
//            print("\(timerCounting) after second opening")
//
//            stopTimer()
//            if let start = startTime {
//                if let stop = stopTime {
//                    let time = calcRestartTime(start: start, stop: stop)
//                    let diff = Date().timeIntervalSince(time)
//                    setTimeLabel(Int(diff))
//                }
//            }
//        }
    }
    
    @objc func playBtnTapped() {

        if timerCounting == true {
            setStopTime(date: Date())
            stopTimer()

        } else {
            if let stop = stopTime {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            } else {
                setStartTime(date: Date())
            }
            startTimer()
        }
    }
    
    @objc func resetBtnTapped() {
        
        setStopTime(date: nil)
        setStartTime(date: nil)
        stopwatchLabel.text = makeTimeString(min: 0, sec: 0)
        
        if let focus = currentFocus {
            try? realm.write {
                focus.time = stopwatchText
            }
        }
        
        stopTimer()
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    @objc func updateStopwatch() {
        
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
            
        } else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int) {
        
        let time = secondsToHoursMinutes(val)
        let timeString = makeTimeString(min: time.0, sec: time.1)
        stopwatchLabel.text = timeString
    }
    
    func secondsToHoursMinutes(_ ms: Int) -> (Int, Int) {
        
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        
        return (min, sec)
    }
    
    func makeTimeString(min: Int, sec: Int) -> String {
        
        var timeString = ""
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        
        stopwatchText = String(min) + "m"

        print(stopwatchText)
        return timeString
    }
    
    func setStartTime(date: Date?) {
        
        startTime = date
        userDefaults.set(date, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?) {
        
        stopTime = date
        userDefaults.set(date, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool) {
        
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func startTimer() {
        
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.01,
                                              target: self,
                                              selector: #selector(updateStopwatch),
                                              userInfo: nil,
                                              repeats: true)
        setTimerCounting(true)
        print("\(timerCounting) after startTimer")
        playButton.setImage(UIImage(named: "pauseStopwatch"), for: .normal)
    }
    
    func stopTimer() {
        scheduledTimer.invalidate()
   
        setTimerCounting(false)
        print("\(timerCounting) after stopTimer")

        playButton.setImage(UIImage(named: "playStopwatch"), for: .normal)
    }
    
    private func addSubviews() {
        view.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate ([
            stopwatchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopwatchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
    
   
    
    
    
}
