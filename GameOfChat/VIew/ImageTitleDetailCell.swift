//
//  UserCell.swift
//  GameOfChat
//
//  Created by 徐永宏 on 2018/2/8.
//  Copyright © 2018年 徐永宏. All rights reserved.
//

import UIKit
import Firebase

class ImageTitleDetailCell: UITableViewCell {
    
    static let profileImageWidth: CGFloat = 44
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.layer.cornerRadius = profileImageWidth / 2.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    var user: User? {
        didSet {
            textLabel?.text = user?.name
            detailTextLabel?.text = user?.email
            
            // profile image
            if let imageUrlStr = user?.profileUrl {
                // load image using imageview custom extension with a cache image capability, habahaba!!!
                profileImageView.loadCachedImageWithUrl(imageUrlStr: imageUrlStr)
                
            } else { // if the user dont have a profile image url, set its image to nil to present image mis-reuse
                profileImageView.image = nil
            }
        }
    }
    
    var message: Message? {
        didSet {
            // the msg time stamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss a"
            if let seconds = self.message?.timeStamp?.doubleValue {
                let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: seconds))
                dateLabel.text = dateStr
            }
            // the message label
            detailTextLabel?.text = self.message?.message
            
            setMessageIconAndName()
        }
    }
    
    fileprivate func setMessageIconAndName() {
        // if the toUser is the current user, set the image and name to fromUser's
        var finalUserId: String?
        if let currentUid = Auth.auth().currentUser?.uid, let toUserId = self.message?.toUser, let fromUserId = self.message?.fromUser {
            finalUserId = currentUid == toUserId ? fromUserId : toUserId
        }
        
        if let toUserId = finalUserId {
            AppDelegate.db.collection("users").document(toUserId).getDocument(completion: { (snapshot, error) in
                if let error = error {
                    print("Error occurred fetching the 'toUser' info: \(error)")
                } else {
                    let dataDic = snapshot!.data()
                    if let dataDic = dataDic {
                        // set the 'toUser' image
                        self.profileImageView.loadCachedImageWithUrl(imageUrlStr: dataDic["profileUrl"] as! String)
                        
                        // set the 'toUser' name label
                        self.textLabel?.text = dataDic["name"] as? String
                        
                    }
                }
            })
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier);
        
        // add a imageview for the user profile image
        addSubview(profileImageView)
        // layout the profile image view
        layoutProfileImageView()
        
        // add a data label to the cell
        addSubview(dateLabel)
        layoutDateLabel()
    }
    
    func layoutProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: ImageTitleDetailCell.profileImageWidth).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: ImageTitleDetailCell.profileImageWidth).isActive = true
    }
    
    func layoutDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
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
