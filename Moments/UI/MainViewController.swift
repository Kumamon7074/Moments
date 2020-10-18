//
//  MainViewController.swift
//  Moments
//
//  Created by Mac Zhou on 2020/10/14.
//

import UIKit
import ChameleonFramework
import SnapKit
import SwifterSwift

class MainViewController: UIViewController {
    public let kHeaderHeight = 370*SCREEN_WIDTH_RATIO
    private var refreshHeader:MJRefreshNormalHeader?
    private var loadMoreFooter:MJRefreshAutoFooter?
    private var profile:Profile?
    private var tweets = [Tweet]()
    private var moreTweets = [Tweet]()
    
    lazy var headerView:ProfileHeaderView = {
        let v = ProfileHeaderView(frame: CGRect(origin: .zero, size: CGSize.init(width: SCREEN_WIDTH, height: kHeaderHeight)))
        return v
    }()
    
    lazy var tableView:UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.delegate = self
        v.dataSource = self
        v.backgroundColor = UIColor.flatBlack()
        v.contentInsetAdjustmentBehavior = .never
        v.rowHeight = UITableView.automaticDimension
        v.estimatedRowHeight = kHeaderHeight
        v.tableFooterView = UIView()
        v.showsVerticalScrollIndicator = false
        v.separatorInset = .zero
        v.separatorColor = UIColor.clear
        v.register(cellWithClass: TweetTableCell.self)
        return v
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        setupConstraints()
        fetchData()
    }
}

//MARK: - common init
private extension MainViewController {
    
    func commonInit() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = UIColor.flatBlack()
        view.addSubview(tableView)
        refreshHeader = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.fetchData()
        })
        loadMoreFooter = MJRefreshAutoFooter(refreshingBlock:{ [weak self] in
            guard let `self` = self else {return}
            self.tweets = self.tweets + self.moreTweets
            self.tableView.reloadData()
            self.loadMoreFooter?.endRefreshing()
        })
        tableView.mj_header = refreshHeader
        tableView.mj_footer = loadMoreFooter
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        Networking.shared.send(ProfileRequest()) { [weak self](profile) in
            guard let `self` = self else {return}
            self.profile = profile

            group.leave()
        }
        group.enter()
        Networking.shared.send(TweetsRequest()) { [weak self](tweets) in
            guard let `self` = self else {return}
            if let tweets = tweets {
                self.tweets = Array(tweets[0...4])
                self.moreTweets = Array(tweets[5..<tweets.count])
            }
            group.leave()
        }
        group.notify(queue: .main) {
            if let profile = self.profile {
                self.headerView.update(profile: profile)
            }
            self.tableView.reloadData()
            self.refreshHeader?.endRefreshing()
        }
    }
}

//MARK: - UITableViewDataSource
extension MainViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TweetTableCell.self, for: indexPath)
        cell.update(tweet: tweets[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MainViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
}
