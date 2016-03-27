//
//  StuffService.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 1/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation

class StuffService {

  let networkService: NetworkService
  let databaseService: DatabaseService

  init(networkService: NetworkService, databaseService: DatabaseService) {
    self.networkService = networkService
    self.databaseService = databaseService
  }

  func fetchStuff(callback: ([Stuff]?, DomainError?) -> ()) {
    let persistedStuff: [Stuff] = databaseService.allTheStuff().map { Stuff(realmObject: $0) }
    callback(persistedStuff, .None)

    networkService.performRequest(.GetStuff) { result in
      switch result {
      case .Success(let response):
        guard let jsonStuff = response["stuff"] as? [[String: AnyObject]] else {
          callback(.None, DomainError.JSONDecodeFailed)
          return
        }

        let stuff = jsonStuff.flatMap { Stuff(json: $0) }
        callback(stuff, .None)
      case .Failure(let error):
        callback(.None, error)
      }
    }
  }
}