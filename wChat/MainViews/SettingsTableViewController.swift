//
//  SettingsTableViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/24/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }


    //MARK: IBActions
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        FUser.logOutCurrentUser{ (success) in
            if success {
                //show login view
                self.showLoginView()
            }
        }
    }
    func showLoginView() {
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        self.present(mainView, animated: true, completion: nil)
    }
}
