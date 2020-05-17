//
//  ChatsViewController.swift
//  wChat
//
//  Created by Kim Wang on 3/26/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import UIKit
import FirebaseFirestore
class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,RecentChatsTableViewCellDelegate, UISearchResultsUpdating {
    
    
    //the last two are protocols

    @IBOutlet weak var tableView: UITableView!
    var recentChats : [NSDictionary] = []
    var filteredChats: [NSDictionary] = []
    
    var recentListener: ListenerRegistration! // used to listen for new changes
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        loadRecentChats()
        tableView.tableFooterView=UIView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        recentListener.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController=searchController
        navigationItem.hidesSearchBarWhenScrolling=true
        
        searchController.searchResultsUpdater=self
        searchController.dimsBackgroundDuringPresentation=false//deprecated 
        definesPresentationContext=true
        
        setTableViewHeader()
        
        
    }
    
    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UserTableViewController
        self.navigationController?.pushViewController(userVC, animated: true)
    }
    

    //MARK: tableViewDateSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != " "{
            return filteredChats.count
        }else{
            return recentChats.count
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentChatsTableViewCell
        //setup our cell
        cell.delegate=self
        
        var recent : NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != " "{
            recent=filteredChats[indexPath.row]
        }else{
            recent=recentChats[indexPath.row]
        }
        
        cell.generateCell(recentChat: recent, indexPath: indexPath)
        
        
        return cell
    }
    
    // MARK: TableViewDelegate functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var tempRecent : NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != " "{
            tempRecent=filteredChats[indexPath.row]
        }else{
            tempRecent=recentChats[indexPath.row]
        }
        
        var muteTitle = "Unmute"
        var mute = false
        
        if(tempRecent[kMEMBERSTOPUSH] as! [String]).contains(FUser.currentId()){
            muteTitle="Mute"
            mute=true
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            self.recentChats.remove(at: indexPath.row)

            deleteRecentChat(recentChatDictionary: tempRecent)

            self.tableView.reloadData()
        }
        
        
        let muteAction = UITableViewRowAction(style: .default, title: muteTitle) { (action, indexPath) in
            
//            self.updatePushMembers(recent: tempRecent, mute: mute)
        }
        
        muteAction.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        return [deleteAction, muteAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var recent: NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            recent = filteredChats[indexPath.row]
        } else {
            recent = recentChats[indexPath.row]
        }

        restartRecentChat(recent: recent)
        
        let chatVC = ChatViewController()
        chatVC.hidesBottomBarWhenPushed = true
        chatVC.titleName = (recent[kWITHUSERFULLNAME] as? String)!
        chatVC.memberIds = (recent[kMEMBERS] as? [String])!
        chatVC.membersToPush = (recent[kMEMBERSTOPUSH] as? [String])!
        chatVC.chatRoomId = (recent[kCHATROOMID] as? String)!
        chatVC.isGroup = (recent[kTYPE] as! String) == kGROUP
        
        navigationController?.pushViewController(chatVC, animated: true)
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
    //MARK: custom tableviewHeader
    func setTableViewHeader(){
        let headerView=UIView(frame: CGRect(x: 0 , y: 0,width:tableView.frame.width , height: 45))
        let btnView = UIView(frame: CGRect(x: 0, y: 5, width: tableView.frame.width, height: 35))
        let groupBtn=UIButton(frame: CGRect(x: tableView.frame.width-110, y: 10, width: 100, height: 20))
        
        groupBtn.addTarget(self, action: #selector(self.groupBtnPressed), for: .touchUpInside)
        groupBtn.setTitle("New Group", for: .normal)
        let buttonColor=#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        groupBtn.setTitleColor(buttonColor, for: .normal)
        
        let lineView=UIView( frame: CGRect(x: 0, y: tableView.frame.height-1 , width: tableView.frame.width, height: 1) )
        lineView.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        btnView.addSubview(groupBtn)
        btnView.addSubview(btnView)
        btnView.addSubview(lineView)
        
        tableView.tableHeaderView=headerView
        
    }
    @objc func groupBtnPressed(){
        print("hello")
    }
   

    
    //MARK: RecentChatsCell delegate
    func didTapAvatarImage(indexPath: IndexPath) {
        
        var recentChat : NSDictionary!
        
        if searchController.isActive && searchController.searchBar.text != " "{
            recentChat=filteredChats[indexPath.row]
        }else{
            recentChat=recentChats[indexPath.row]
        }
        
        if recentChat[kTYPE] as! String == kPRIVATE{
            
            reference(.User).document(recentChat[kWITHUSERUSERID] as! String).getDocument{(snapshot,err) in
                guard let snapshot = snapshot else { return }
                if snapshot.exists{
                    let userDictionary = snapshot.data() as! NSDictionary
                    let tempUser = FUser(_dictionary: userDictionary)
                    self.showUserProfile(user: tempUser)
                }
            }
        }
     }
    
    func showUserProfile(user: FUser) {
        
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as!ProfileTableViewController
        profileVC.user = user
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //MARK: search controller functions
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredChats = recentChats.filter({ (recentChat) -> Bool in
            return (recentChat[kWITHUSERUSERID] as! String).lowercased().contains(searchText.lowercased())
        })

        tableView.reloadData()//everytime we search something need to reload the page to reflect the result
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
