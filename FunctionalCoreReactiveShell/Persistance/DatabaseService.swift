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

  func allStuff() -> [RealmStuff] {
    let results = realm.objects(RealmStuff.self)
    // TODO: I bet there is a better way to go from results to array?
    return (0..<results.count).map { results[$0] }
  }
}

// MARK: Reactive Extension

import ReactiveCocoa

extension DatabaseService {

  func allStuff() -> SignalProducer<[RealmStuff], DomainError> {
    return SignalProducer(value: allStuff())
  }
}