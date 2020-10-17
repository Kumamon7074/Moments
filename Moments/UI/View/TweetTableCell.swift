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
    private var imageCollectionConstraint: Constraint?
    private var commentTableConstraint: Constraint?
    
    private let imageWidth:CGFloat = 70 * SCREEN_WIDTH_RATIO
    private let imageSpace:CGFloat = 6
    
    private var nicknameLabelWidth:CGFloat {
        return SCREEN_WIDTH - 45 - 14*2 - 8
    }
    
    lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.flatWhite()?.darken(byPercentage: 0.1)
        return v
    }()
    
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
        v.register(cellWithClass: CommentTableCell.self)
        v.dataSource = self
        v.rowHeight = UITableView.automaticDimension
        v.estimatedRowHeight = 80
        v.tableFooterView = UIView()
        v.separatorStyle = .none
        v.showsVerticalScrollIndicator = false
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tweet = nil
        imageCollectionView.reloadData()
        commentTableView.reloadData()
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
        commentTableConstraint?.update(offset: calculateCommentsContainterHeight())
        commentTableView.reloadData()
        imageCollectionView.reloadData()
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
            commentTableView,
            line
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
            
        }
        commentTableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(nicknameLabel)
            make.top.equalTo(imageCollectionView.snp.bottom).offset(4)
            commentTableConstraint = make.height.equalTo(calculateCommentsContainterHeight()).constraint
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(commentTableView.snp.bottom).offset(14)
            make.height.equalTo(isPad ? 1.0 : 0.5)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-14)
        }
    }
    
    func configureUI(){
        avatarImageView.cornerRadius = 3
        commentTableView.layer.cornerRadius = 5
    }
}

//MARK: - UITableViewDataSource
extension TweetTableCell:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweet?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CommentTableCell.self, for: indexPath)
        if let comments = tweet?.comments {
            cell.update(comment: comments[indexPath.row])
        }
        return cell
    }
    
}

//MARK: - UICollectionViewDataSource
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
    
    func calculateCommentsContainterHeight()->CGFloat{
        var totalHeight:CGFloat = 0
        if let comments = self.tweet?.comments,comments.count > 0 {
            for comment in comments {
                totalHeight += comment.attrContent.height(withConstrainedWidth: nicknameLabelWidth) + 4.0 //do not forget add label padding each cell
            }
            return totalHeight
        }
        return totalHeight
    }
    
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
