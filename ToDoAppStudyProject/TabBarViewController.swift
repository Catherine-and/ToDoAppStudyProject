////
////  TabBarViewController.swift
////  ToDoAppStudyProject
////
////  Created by Ekaterina Isaeva on 03.10.2024.
////
//
//import UIKit
//
//class TabBarViewController: UITabBarController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setubTabs()
//    }
//    
//    
//    private func setubTabs() {
//        
//        let toDos = self.creatNavigation(with: nil, and: UIImage(systemName: "checkmark.circle.fill"), vc: ToDoListViewController())
//        let weather = self.creatNavigation(with: "Weather", and: UIImage(systemName: "sun.horizon.circle.fill"), vc: WeatherViewController())
//        
//        
//        self.setViewControllers([toDos, weather], animated: true)
//    }
//    
//    private func creatNavigation(with title: String?, and image: UIImage?, vc: UIViewController) -> UINavigationController {
//        
//        let nav = UINavigationController(rootViewController: vc)
//        nav.tabBarItem.title = title
//        nav.tabBarItem.image = image
//        nav.viewControllers.first?.navigationItem.title = title
//        
//        
//        return nav
//    }
//    
//}
