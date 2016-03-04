//
//  DatabaseService.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 20/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseService {

  let realm: Realm

  init(realm: Realm) {
    self.realm = realm
  }

  func allTheStuff() -> [Stuff] {
    let results = realm.objects(RealmStuff.self)
    // TODO: split and do properly...
    return (0..<results.count)
      .map { results[$0] }
      .map { Stuff(realmObject: $0) }
  }
}

// MARK: Reactive Extension

import ReactiveCocoa

extension DatabaseService {

  func allTheStuff() -> SignalProducer<[Stuff], DomainError> {
    return SignalProducer(value: allTheStuff())
  }
}