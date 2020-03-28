//
//  ProfileTableViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/27/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var messageButtonOutlet: UIButton!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var blockButtonOutlet: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var user: FUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
      
    }

    
    //MARK: IBAction
    
    @IBAction func callButtonPressed(_ sender: Any) {
    }
    @IBAction func chatButtonPressed(_ sender: Any) {
    }
    @IBAction func blockButtonPressedPressed(_ sender: Any) {
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3//it's not dynamic
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "" //we have empty headers
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()//initialzie empty view
    }
    
    //set the first header height to zero
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func setupUI() {
        
    }
}
