//
//  ChatsViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/26/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {//the last two are protocols

    @IBOutlet weak var tableView: UITableView!
    var recentChats : [NSDictionary] = []
    var filteredChats: [NSDictionary] = []
    
    var recentListener: ListenerRegistration! // used to listen for new changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadRecentChats()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UserTableViewController
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    

    //MARK: tableViewDateSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("here!")
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentChatsTableViewCell
        //setup our cell
        
        
        
        
        return cell
    }
    
    //MARK: LoadRecentChats
    func loadRecentChats() {
        recentListener = reference(.Recent).whereField(kUSERID, isEqualTo: FUser.currentId()).addSnapshotListener({(snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            self.recentChats = []
            
            if !snapshot.isEmpty {
                //sort recent obj based on date
                let sorted = ((dictionaryFromSnapshots(snapshots: snapshot.documents)) as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])  as! [NSDictionary]//decending, latest one on top
                
                for recent in sorted {
                    if recent[kLASTMESSAGE] as! String != "" && recent[kCHATROOMID] != nil && recent[kRECENTID] != nil {
                        
                        self.recentChats.append(recent)
                    }
                    
                    reference(.Recent).whereField(kCHATROOMID, isEqualTo: recent[kCHATROOMID] as! String).getDocuments(completion: { (snapshot, error) in
                        
                    })
                }
                
                self.tableView.reloadData()
            }
           
        })
        
        
        
    }
}
