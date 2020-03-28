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
        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        loadUser(filter: kCITY)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
            
        } else {
            return allUserGroupped.count
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterdUsers.count
            
        } else {
            
            //find sectionTitle
            let sectionTitle = self.sectionTitleList[section] //pass our section to get the section title
            //user for given tiel
            let users = self.allUserGroupped[sectionTitle]
            return users!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        var user : FUser//need to set these users dynamically
        
        if searchController.isActive && searchController.searchBar.text != "" {//the user is searching
            user = filterdUsers[indexPath.row]
        } else {
            let sectionTitle = self.sectionTitleList[indexPath.section]
            let users = self.allUserGroupped[sectionTitle]
//            print("printing...")
//            print(users!.count)
//            print(indexPath.row)
            user = users![indexPath.row]
        }

        cell.generateCellWith(fUser: user, indexPath: indexPath)
        
        return cell
    }
    
    //MARK: table view delegate (below 3)
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {//show the section tile bar
        if searchController.isActive && searchController.searchBar.text != "" {//the user is searching
            return ""
        } else {
            return sectionTitleList[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive && searchController.searchBar.text != "" {//the user is searching
           return nil
       } else {
        return self.sectionTitleList
       }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { //able to see a section abbr on the side, click it and it will jump to the section
        return index
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
                self.splitDataIntoSection()
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    //MARK: IB Actions
    
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUser(filter: kCITY)
        case 1:
            loadUser(filter: kCOUNTRY)
        case 2:
            loadUser(filter: "")
        default:
            return
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
    
    //MARK: helper functions
    fileprivate func splitDataIntoSection() {//can only be used in this class
        
        var sectionTitle : String = ""
        for i in 0..<self.allUsers.count {
            let currentUser = self.allUsers[i]
            let firstChar = currentUser.firstname.first! //first letter of firstname
            let firstCarString = "\(firstChar)"
            
            if firstCarString != sectionTitle {
                sectionTitle = firstCarString
                self.allUserGroupped[sectionTitle] = []
                self.sectionTitleList.append(sectionTitle)
                
            }
            self.allUserGroupped[firstCarString]?.append(currentUser) //key is the first Car String
        }
    }
}
