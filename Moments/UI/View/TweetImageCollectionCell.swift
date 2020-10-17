//
//  TweetImageCollectionCell.swift
//  Moments
//
//  Created by Mac Zhou on 2020/10/17.
//

import UIKit

class TweetImageCollectionCell: UICollectionViewCell {
    
    lazy var contentImageView:UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(url:URL){
        contentImageView.set(url: url)
    }
    
    func commonInit(){
        contentView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
