//
//  ProfileHeaderView.swift
//  Moments
//
//  Created by macrzhou(周荣) on 2020/10/16.
//

import UIKit
import ChameleonFramework

class ProfileHeaderView: UIView {
    
    private var profile:Profile!
    private var profileImageView:UIImageView!
    private var avatarImageView:UIImageView!
    private var nickNameLabel:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(profile:Profile){
        if let url = profile.profileImageURL{
            profileImageView.set(url: url)
        }
        if let url = profile.avatarURL {
            avatarImageView.set(url: url)
        }
        nickNameLabel.text = profile.nick
    }
    
    private func commonInit(){
        backgroundColor = UIColor.flatWhite()
        profileImageView = UIImageView()
        avatarImageView = UIImageView()
        nickNameLabel = UILabel()
        nickNameLabel.textColor = UIColor.flatWhite()
        nickNameLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        nickNameLabel.textAlignment = .right
        
        addSubview(profileImageView)
        addSubview(avatarImageView)
        addSubview(nickNameLabel)
        
        profileImageView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(320*SCREEN_WIDTH_RATIO)
        }
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100*SCREEN_WIDTH_RATIO)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20*SCREEN_WIDTH_RATIO)
        }
        nickNameLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(avatarImageView.snp.leading).offset(-8)
            make.bottom.equalTo(profileImageView.snp.bottom).offset(-10)
        }
    }
}
