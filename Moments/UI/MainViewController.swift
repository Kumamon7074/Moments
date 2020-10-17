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
    private var tweets = [Tweet]()
    
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
        updateData()
    }
}

//MARK: - common init
private extension MainViewController {
    
    func commonInit() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = UIColor.flatBlack()
        view.addSubview(tableView)
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateData(){
        Networking.shared.send(ProfileRequest()) { [weak self](profile) in
            guard let `self` = self else {return}
            if let profile = profile {
                self.headerView.update(profile: profile)
            }
        }
        Networking.shared.send(TweetsRequest()) { [weak self](tweets) in
            guard let `self` = self else {return}
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TweetTableCell{
            //cell.update(tweet: tweets[indexPath.row])
        }
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
