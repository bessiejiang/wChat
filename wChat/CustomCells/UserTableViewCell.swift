//
//  UserTableViewCell.swift
//  wChat
//
//  Created by Kim Wang on 3/25/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLable: UILabel!
    
    var indexPath: IndexPath! // not optional
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))//action:which function should be called
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)//now when avatar is tapped it can trigger some functions
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func generateCellWith(fUser: FUser, indexPath: IndexPath) {//IndexPath:
        self.indexPath = indexPath
        self.fullNameLable.text = fUser.fullname
        
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) {(avatarImage) in
                if avatarImage != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked//make image round
                }
            }
        }
    }
    @objc func avatarTap(){
        print("avatar tap at \(indexPath)")
    }
}
