//
//  CollectionReference.swift
//  wChat
//
//  Created by Kim Wang on 3/22/20.
//  Copyright © 2020 Kim Wang. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
