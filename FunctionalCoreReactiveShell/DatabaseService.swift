//
//  DatabaseService.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 20/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation

class DatabaseService {

  func allTheStuff() -> [Stuff] {
    return [
      Stuff(id: "0", text: "local value first", number: 123),
      Stuff(id: "1", text: "local value second", number: 456),
      Stuff(id: "2", text: "local value third", number: 789),
    ]
  }
}

// MARK: Reactive Extension

import ReactiveCocoa

extension DatabaseService {

  func allTheStuff() -> SignalProducer<[Stuff], DomainError> {
    return SignalProducer(value: allTheStuff())
  }
}