//
//  RecentChatsTableViewCell.swift
//  wChat
//
//  Created by Kim Wang on 3/31/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit
protocol RecentChatsTableViewCellDelegate {
    func didTapAvatarImage(indexPath: IndexPath)
}

class RecentChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var messageCounter: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageCounterBackgroundView: UIView!
    
    var indexPath : IndexPath!
    let tapGesture = UITapGestureRecognizer()
    var delegate : RecentChatsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageCounterBackgroundView.layer.cornerRadius = messageCounterBackgroundView.frame.width / 2
        
        //add tap gesture
        tapGesture.addTarget(self, action: #selector(self.avatarTap))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //Mark: generate cell
    
    func generateCell(recentChat:NSDictionary, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.nameLabel.text = recentChat[kWITHUSERFULLNAME] as? String
        self.lastMessageLabel.text = recentChat[kLASTMESSAGE]  as? String
        self.messageCounter.text = recentChat[kCOUNTER] as? String
        
        if let avatarString = recentChat[kAVATAR] {
            imageFromData(pictureData: avatarString as! String) {(avatarImage) in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                } else {
                    
                }
            }
        }
        
        if recentChat[kCOUNTER] as! Int != 0 {
            self.messageCounter.text = "\(recentChat[kCOUNTER] as! Int)"
            self.messageCounterBackgroundView.isHidden = false
            self.messageCounter.isHidden = false
        } else {
            self.messageCounterBackgroundView.isHidden = true
            self.messageCounter.isHidden = true
        }
        
        var date : Date!
        if let created = recentChat[kDATE] {
            if (created as! String).count != 14 {//date saved in firebase is 14 digit long
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        
        self.dateLabel.text = timeElapsed(date: date)
    }
    
    @objc func avatarTap(){
        print("avatar tapped")
        delegate?.didTapAvatarImage(indexPath: indexPath)
    }
}
