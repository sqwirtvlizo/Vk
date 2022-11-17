//
//  TabBar.swift
//  Vk
//
//  Created by Евгений Кононенко on 17.11.2022.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        tabBar.tintColor = UIColor(red: 0.161, green: 0.459, blue: 0.8, alpha: 1)
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOffset = .zero
        tabBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        viewControllers = [
            generateViewController(rootViewController: HomeViewController(), image: UIImage(named: "home")!, title: "Главная"),
            generateViewController(rootViewController: ServicesViewController(), image: UIImage(named: "services")!, title: "Сервисы"),
            generateViewController(rootViewController: MessageViewController(), image: UIImage(named: "messages")!, title: "Сообщения"),
            generateViewController(rootViewController: ClipsViewController(), image: UIImage(named: "clips")!, title: "Клипы"),
            generateViewController(rootViewController: MessageViewController(), image: UIImage(named: "profile")!, title: "Профиль")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }

}
