//
//  UserCell.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/8.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier);
        
        // add a imageview for the user profile image
        addSubview(profileImageView)
        
        // layout the profile image view
        layoutProfileImageView()
    }
    
    func layoutProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // move the title and detail to match the layout of the image view
        if let textLabel = textLabel {
            textLabel.frame = CGRect(x: 64, y: textLabel.frame.origin.y - 4, width: textLabel.frame.width, height: textLabel.frame.height)
        }
        if let detailTextLabel = detailTextLabel {
            detailTextLabel.frame = CGRect(x: 64, y: detailTextLabel.frame.origin.y + 4, width: detailTextLabel.frame.width, height: detailTextLabel.frame.height)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
