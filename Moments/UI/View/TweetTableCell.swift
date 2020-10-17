//
//  TweetTableCell.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/16.
//

import UIKit
import ChameleonFramework
import SnapKit

class TweetTableCell: UITableViewCell {
    
    private var tweet:Tweet?
    private var contentLabelConstraint: Constraint?
    private var imageCollectionConstraint: Constraint?
    private var commentTableConstraint: Constraint?
    
    private let imageWidth:CGFloat = 70 * SCREEN_WIDTH_RATIO
    private let imageSpace:CGFloat = 6
    
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
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        layout.minimumInteritemSpacing = imageSpace
        layout.minimumLineSpacing = imageSpace
        layout.scrollDirection = .vertical
        
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.register(cellWithClass: TweetImageCollectionCell.self)
        v.dataSource = self
        v.backgroundColor = UIColor.flatWhite()
        v.isScrollEnabled = false
        v.showsVerticalScrollIndicator = false
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
        print("\(nicknameLabel.size.width)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tweet = nil
        imageCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(tweet:Tweet){
        self.tweet = tweet
        nicknameLabel.text = tweet.sender.nick
        if let content = tweet.content {
            contentLabel.text = content
        }else {
            contentLabel.text = nil
            
        }
        if let url = tweet.sender.avatarURL {
            avatarImageView.set(url: url)
        }
        imageCollectionConstraint?.update(offset: calculateImageContainerHeight())
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
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-14)
            make.top.equalTo(avatarImageView.snp.top)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
        }
        imageCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.width.equalTo(imageWidth*3+2*imageSpace)
            imageCollectionConstraint = make.height.equalTo(calculateImageContainerHeight()).constraint
            make.bottom.lessThanOrEqualToSuperview().offset(-14)
        }
    }
    
    func configureUI(){
        avatarImageView.cornerRadius = 3
    }
}

//MARK: -UICollectionViewDataSource
extension TweetTableCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tweet?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: TweetImageCollectionCell.self, for: indexPath)
        if let images = tweet?.images {
            cell.update(url: images[indexPath.row])
        }
        return cell
    }
}

//MARK: - Helpers
extension TweetTableCell {
    
    func calculateImageContainerHeight()->CGFloat{
        if let images = self.tweet?.images,images.count > 0 {
            if images.count <= 3 {
                return imageWidth
            }else if images.count > 3 && images.count <= 6 {
                return imageWidth*2 + imageSpace
            }else {
                return imageWidth*3 + 2*imageSpace
            }
        }
        return 0
    }
}
