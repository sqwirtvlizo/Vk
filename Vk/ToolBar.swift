//
//  ToolBar.swift
//  Vk
//
//  Created by Евгений Кононенко on 18.11.2022.
//

import UIKit
import Foundation

class ToolBar {
    let titleLabel = UILabel()
    let messageAboutConnectionLabel = UILabel()
    var stackView: UIStackView

    init() {
        stackView = UIStackView(arrangedSubviews: [titleLabel, messageAboutConnectionLabel])
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(changeToolBarDueNetworkConnection),
//                                               name: Notification.Name("ConnectionDidChange"),
//                                               object: nil)
    }

    func createToolBar(for viewController: UIViewController, with title: String, in place: String) {
        styleBackButton(for: viewController)
        titleLabel.text = title
       // titleLabel.textColor = UIColor(named: "BlueTitle")
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
//        if !NetworkMonitor.shared.isConnected {
//            messageAboutConnectionLabel.text = "No internet connection"
//            messageAboutConnectionLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12)
//            messageAboutConnectionLabel.textColor = UIColor(named: "BlueTitleLight")
//            messageAboutConnectionLabel.textAlignment = .left
//            messageAboutConnectionLabel.sizeToFit()
//        }

        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        let width = max(titleLabel.frame.size.width, messageAboutConnectionLabel.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 30)
        titleLabel.sizeToFit()
        if place == "left"{
            titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)
            let titleItem = UIBarButtonItem(customView: stackView)
            viewController.navigationItem.leftBarButtonItem = titleItem
        } else if place == "center" {
            titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 20)
            stackView.alignment = .center
            viewController.navigationItem.titleView = stackView
        }
    }

    func styleBackButton(for viewController: UIViewController) {
            let backButton = UIBarButtonItem(image: UIImage(named: ""), style: .plain, target: self, action: nil)
            backButton.title = ""
            backButton.tintColor = UIColor(named: "BlueTitle")
            viewController.navigationItem.backBarButtonItem = backButton
    
        }

//    @objc
//    func changeToolBarDueNetworkConnection() {
//        if NetworkMonitor.shared.isConnected {
//           messageAboutConnectionLabel.text = ""
//        } else {
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) { [self] in
//                messageAboutConnectionLabel.text = "No internet connection"
//                messageAboutConnectionLabel.font = UIFont(name: "SFProDisplay-Regular", size: 12)
//                messageAboutConnectionLabel.textColor = UIColor(named: "BlueTitleLight")
//                messageAboutConnectionLabel.textAlignment = .left
//                messageAboutConnectionLabel.sizeToFit()
//            } completion: { _ in
//            }
//        }
//    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ConnectionDidChange"), object: nil)
    }
}

