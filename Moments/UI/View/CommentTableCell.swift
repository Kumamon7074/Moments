//
//  CommentTableCell.swift
//  Moments
//
//  Created by Mac Zhou on 2020/10/17.
//

import UIKit
import ChameleonFramework

class CommentTableCell: UITableViewCell {
    
    lazy var commentLabel:UILabel = {
        let v = UILabel()
        v.textColor = UIColor.flatBlack()
        v.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        v.textAlignment = .left
        v.numberOfLines = 0
        v.lineBreakMode = .byWordWrapping
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(comment:Comment){
        commentLabel.attributedText = comment.attrContent
    }
    
    private func commonInit(){
        contentView.backgroundColor = UIColor.flatWhite()?.darken(byPercentage: 0.02)
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
    }
}
