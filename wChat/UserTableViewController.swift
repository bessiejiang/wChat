//
//  UserTableViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/25/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class UserTableViewController: UITableViewController, UISearchResultsUpdating {
    
    

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentedControll: UISegmentedControl!
    
    var allUsers : [FUser] = []
    var filterdUsers : [FUser] = []
    var allUserGroupped = NSDictionary() as! [String : [FUser]]
    var sectionTitleList : [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        cell.generateCellWith(fUser: allUsers[indexPath.row], indexPath: indexPath)
        
        

        return cell
    }
    
    func loadUser(filter: String) {//filter: city, country or all
        ProgressHUD.show()
        var query: Query!
        
        switch filter{
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)//check city equals to my city
        case kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)//check city equals to my city
        default:
            //all is already the defulat keyword
            query = reference(.User).order(by: kFIRSTNAME, descending: false)//get everything back
        }
        
        query.getDocuments {(snapshot, error) in
            self.allUsers = []
            self.sectionTitleList = []
            self.allUserGroupped = [:] //empty dictionary
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()//refresh to replace the incorrect page
                return
            }
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss()
                return
            }
            if !snapshot.isEmpty {
                for userDictionary in snapshot.documents {
                    let userDictionary = userDictionary.data() as NSDictionary //access firestorage and get data as json format
                    let fUser = FUser(_dictionary: userDictionary) //get the user
                    if (fUser.objectId != FUser.currentId()) {//eliminate the current user
                        self.allUsers.append(fUser)
                    }
                }
                //split to group by initials:
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    //Mark: search controller functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterdUsers = allUsers.filter({ (user) -> Bool in
            return user.firstname.lowercased().contains((searchText.lowercased()))
        })
        tableView.reloadData()//everytime we search something need to reload the page to reflect the result
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
