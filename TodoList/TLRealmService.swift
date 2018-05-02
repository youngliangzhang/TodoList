//
//  TLRealmService.swift
//  TodoList
//
//  Created by Sky on 9/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class TLRealmService {
    
    static var realmService:TLRealmService? = nil
    var realm: Realm?
    
    static public func sharedInstance() -> TLRealmService {
        if realmService == nil {
            realmService = TLRealmService()
        }
        
        return realmService!
    }
    
    init() {
        realm = try! Realm()
    }
    
    func addToDoItem(_ item: TLToDoItem) {
        guard let realm = realm else {
            return
        }
        
        try! realm.write {
            realm.add(item)
        }
    }
    
    func updateToDoItem(_ item: TLToDoItem) {
        guard let realm = realm else {
            return
        }
        
        try! realm.write {
            realm.add(item, update: true)
        }
    }
    
    func deleteToDoItem(_ item: TLToDoItem) {
        guard let realm = realm else {
            return
        }
        
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func getToDoListItems() -> Results<TLToDoItem>? {
        
        guard let realm = realm else {
            return nil
        }
        
        return realm.objects(TLToDoItem.self)
    }
    
}
