//
//  NewsfeedViewController.swift
//  Vk
//
//  Created by Евгений Кононенко on 17.11.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: AnyObject {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {
    let toolbar = ToolBar()
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    private var velocity = CGPoint()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetcher.getFeed { feedResponse in
            guard let feedResponse = feedResponse else { return }
            feedResponse.items.map { feedItem in
                print(feedItem.postId)
            }
        }
        
        setToolbar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "loop"),
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(handleSearch))
        let rightBarButtonItem1 = UIBarButtonItem(image: UIImage(named: "notification"),
                                                  style: .done,
                                                  target: self,
                                                  action: #selector(handleNotification))
        rightBarButtonItem.tintColor = UIColor(red: 0.161, green: 0.459, blue: 0.8, alpha: 1)
        rightBarButtonItem1.tintColor = UIColor(red: 0.161, green: 0.459, blue: 0.8, alpha: 1)
        
        let rightBarButtonItems: [UIBarButtonItem] = [rightBarButtonItem1, rightBarButtonItem]
        navigationItem.rightBarButtonItems = rightBarButtonItems
        
//        let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
//           segment.sizeToFit()
//           segment.selectedSegmentTintColor = UIColor.red
//           segment.selectedSegmentIndex = 0
//           segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Bold", size: 23)], for: .normal)
////        segment.topAnchor.constraint(equalTo: toolbar.stackView.topAnchor, constant: 0).isActive = true
//        segment.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
//        segment.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
//        segment.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0).isActive = true
//        self.view.addSubview(segment)
    
//        self.navigationController?.hidesBarsOnSwipe = true
        
    }
    
    override func viewDidLayoutSubviews() {
    }
    @objc
    private func handleSearch() {
        
    }
    
    @objc
    private func handleNotification() {
        
    }
    
    func setToolbar() {
        toolbar.createToolBar(for: self, with: "Главная", in: "left")
       
    }
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .some:
            print(". some vc")
        case .displayNewsfeed:
            print()
        }
    }
    //    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //
    //
    //       }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.velocity = velocity
        showAndHideToolBar(with: velocity)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.makeRequest(request: .getFeed)
    }
    
    
    private func showAndHideToolBar(with velocity: CGPoint) {
        if velocity.y > 0{
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: { [self] in
                toolbar.titleLabel.layer.opacity = 0
//                navigationController?.toolbar.layer.opacity = 0
                
                navigationController?.setNavigationBarHidden(true, animated: true)
                navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseIn, animations: { [self] in
                toolbar.titleLabel.layer.opacity = 1
//                navigationController?.toolbar.layer.opacity = 1
                navigationController?.setNavigationBarHidden(false, animated: true)
                navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
        }
    }
    //    scrollview
}
