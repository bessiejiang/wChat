//
//  Recent.swift
//  wChat
//
//  Created by Kim Wang on 3/30/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import Foundation

func startPrivateChat(user1 : FUser, user2 : FUser) -> String{
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    } else {
        chatRoomId = userId2 + userId1
    }
    
    let members = [userId1, userId2]
    
    //create recent chats
    createRecent(members: members, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE, users: [user1, user2], avatarOfGroup: nil)
    
    return chatRoomId
}

func createRecent(members: [String], chatRoomId: String, withUserUserName : String, type : String, users : [FUser]?, avatarOfGroup : String?) { //last para is only for group chat
    var tempMembers = members // members is read only
    reference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments {(snapshot, error) in
        guard let snapshot = snapshot else { return }//check if we have a snapshot in firebase
        
        if !snapshot.isEmpty {
            for recent in snapshot.documents {
                let currentRecent = recent.data() as NSDictionary
                if let currentUserId = currentRecent[kUSERID] {
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.index(of: currentUserId as! String)!)
                    }
                    
                }
            }
        }
        
        for userId in tempMembers { // whoever left, they don't have recent chats
            //create recent items
            createRecentItems(userId: userId, chatRoomId: chatRoomId, members: members, withUserUserName: withUserUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
        }
    }
}

func createRecentItems(userId: String, chatRoomId: String, members: [String], withUserUserName: String, type : String, users: [FUser]?, avatarOfGroup: String?) {
    
    let localReference = reference(.Recent).document()
    let recentId = localReference.documentID
    let date = dateFormatter().string(from: Date())
    
    var recent: [String: Any]!
    
    if type == kPRIVATE {//for private chat
        var withUser : FUser?
        //dynamic way to set the withUser
        if users != nil && users!.count > 0 {
            if userId == FUser.currentId() {//we are creating the obj for the current user
                withUser = users!.last!
            } else {
                //
                withUser = users!.first!
            }
        }
        
        recent = [kRECENTID : recentId, kUSERID : userId, kCHATROOMID: chatRoomId, kMEMBERS: members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME: withUser!.fullname, kWITHUSERUSERID: withUser!.objectId, kLASTMESSAGE: "", kCOUNTER: 0, kDATE: date, kTYPE : type, kAVATAR : withUser!.avatar] as [String: Any]//which user need to get the notifications
    } else { // for group chat
        if avatarOfGroup != nil {
            recent = [kRECENTID : recentId, kUSERID : userId, kCHATROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH: members, kWITHUSERFULLNAME : withUserUserName, kLASTMESSAGE : "", kCOUNTER : 0, kDATE: date, kAVATAR : avatarOfGroup!] as [String : Any]
        }
    }
    
    //save recent chat as the dictionary
    localReference.setData(recent)
}
