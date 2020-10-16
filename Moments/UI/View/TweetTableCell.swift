//
//  TweetTableCell.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/16.
//

import UIKit
import ChameleonFramework

class TweetTableCell: UITableViewCell {
    
    lazy var avatarImageView:UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    lazy var nicknameLabel:UILabel = {
        let v = UILabel()
        v.textColor = UIColor.flatBlue()
        v.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        v.textAlignment = .left
        return v
    }()
    
    lazy var contentLabel:UILabel = {
        let v = UILabel()
        v.textColor = UIColor.flatBlack()
        v.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        v.textAlignment = .left
        v.numberOfLines = 0
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    lazy var imageCollectionView:UICollectionView = {
        let layout = UICollectionViewLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return v
    }()
    
    lazy var commentTableView:UITableView = {
        let v = UITableView()
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(tweet:Tweet){
        nicknameLabel.text = tweet.sender.nick
        if let content = tweet.content {
            contentLabel.text = content
        }else {
            //contentLabel.text = nil
        }
        if let url = tweet.sender.avatarURL {
            avatarImageView.set(url: url)
        }
    }
    
}

private extension TweetTableCell {
    
    func commonInit(){
        selectionStyle = .none
        backgroundColor = UIColor.flatWhite()
        
        contentView.addSubviews([
            avatarImageView,
            nicknameLabel,
            contentLabel,
            imageCollectionView,
            commentTableView
        ])
    }
    
    func setupConstraints(){
        avatarImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(45)
            make.leading.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-14)
        }
        nicknameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-14)
            make.top.equalTo(avatarImageView.snp.top)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.bottom.lessThanOrEqualToSuperview().offset(-14)
        }
    }
    
    func configureUI(){
        avatarImageView.cornerRadius = 3
    }
}
