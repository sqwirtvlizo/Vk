//
//  AuthViewController.swift
//  Vk
//
//  Created by Евгений Кононенко on 17.11.2022.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .green
        // Do any additional setup after loading the view.
        authService = SceneDelegate.shared().authService
        
    }

    override func viewDidAppear(_ animated: Bool) {
        authService.wakeUpSession()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
