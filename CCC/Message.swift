//
//  Message.swift
//  CCC
//
//  Created by Michael Arnold on 8/30/18.
//  Copyright © 2018 AkzLab. All rights reserved.
//

import Foundation
import Firebase


struct Message {
    let ref: DatabaseReference?
    let key: String
    let message: String
    let sentiment: String
    let user: String
    let count: integer_t

    
    init(message: String, sentiment: String, user: String = "Anonymous", key: String = "", count: integer_t = 0) {
        self.ref = nil
        self.message = message
        self.sentiment = sentiment
        self.key = key
        self.user = user
        self.count = count
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let message = value["message"] as? String,
            let sentiment = value["sentiment"] as? String,
            let count = value["count"] as? integer_t,
            let user = value["user"] as? String else {
            return nil
        }
    
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.message = message
        self.sentiment = sentiment
        self.user = user
        self.count = count
    }
    
    func toAnyObject() -> Any {
        return [
            "message": message,
            "sentiment": sentiment,
            "user": user,
            "count": count,
        ]
    }
}
