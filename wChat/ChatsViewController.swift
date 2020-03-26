//
//  ChatsViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/26/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UserTableViewController
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    

}
