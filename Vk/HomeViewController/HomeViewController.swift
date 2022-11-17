//
//  HomeViewController.swift
//  Vk
//
//  Created by Евгений Кононенко on 17.11.2022.
//

import UIKit

class HomeViewController: UIViewController {

    private let networkService: Networking = NetworkService()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let params = ["filters": "post, photo"]
        networkService.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("error")
            }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data)
            print(json)
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

}
