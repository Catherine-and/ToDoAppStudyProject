//
//  StopWatchViewController.swift
//  ToDoAppStudyProject
//
//  Created by Ekaterina Isaeva on 12.10.2024.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    
    var startStopWatch = true
    
    var stopwatchText = ""
    
    lazy var stopwatchLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 86, weight: .light)
        label.font = .monospacedDigitSystemFont(ofSize: 86, weight: .light)
        //label.font = UIFont(name: "Courier", size: 86)
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
    
    lazy var pauseButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "stop"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [playButton,
                                                  pauseButton])
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
            
        }
        
    }
    
    @objc func playBtnTapped() {
        
        if startStopWatch == true {
            timer = Timer.scheduledTimer(timeInterval: 0.01,
                                         target: self,
                                         selector: #selector(updateStopwatch),
                                         userInfo: nil,
                                         repeats: true)
            startStopWatch = false
            playButton.setImage(UIImage(named: "pauseStopwatch"), for: .normal)
        } else {
            
            timer.invalidate()
            startStopWatch = true
            playButton.setImage(UIImage(named: "playStopwatch"), for: .normal)
        }
        
    }
    @objc func updateStopwatch() {
        
        fractions += 1
        if fractions == 100 {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        let secondsString = String(format: "%02d", seconds)
        let minutesString = String(format: "%02d", minutes)
        
        stopwatchText = "\(minutesString):\(secondsString)"
        stopwatchLabel.text = stopwatchText
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
