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
    private var feedViewModel = FeedViewModel(cells: [])
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
                print(feedItem)
            }
        }
        setToolbar()
        tableView.register(UINib(nibName: "NewsfeedTableViewCell", bundle: nil), forCellReuseIdentifier: NewsfeedTableViewCell.reuseId)
        
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
        self.navigationController?.hidesBarsOnSwipe = true
        interactor?.makeRequest(request: .getNewsfeed)
    
      
        
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
        case .displayNewsfeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            tableView.reloadData()
        }
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedTableViewCell.reuseId, for: indexPath) as! NewsfeedTableViewCell
        cell.layer.borderWidth = CGFloat(3)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        let cellViewModel = feedViewModel.cells[indexPath.row]
//        cell.imageCellView.layer.cornerRadius = cell.imageCellView.fr
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        feedViewModel.cells[indexPath.row].sizes.totalHieght
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.velocity = velocity
      //  showAndHideToolBar(with: velocity)
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        feedViewModel.cells[indexPath.row].sizes.totalHieght
    }
    
    
    
    
    private func showAndHideToolBar(with velocity: CGPoint) {
        if velocity.y > 0 {
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
}

extension NewsfeedViewController: NewsfeedCellDelegate {
    func revealPost(cell: NewsfeedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}
