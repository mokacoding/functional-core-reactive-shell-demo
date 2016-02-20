//
//  NetworkService.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 20/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation
import Result

enum Endpoint {
  case GetStuff
}

class NetworkService {

  func performRequest(toEndpoint: Endpoint, completion: (Result<[String: AnyObject], DomainError>) -> ()) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, dispatch_get_main_queue()) {

      let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
      dispatch_async(dispatch_get_global_queue(priority, 0)) { [weak self] in
        guard let strongSelf = self else {
          return
        }

        let result: Result<[String: AnyObject], DomainError> = Result(value: strongSelf.dummyData())
        completion(result)
      }
    }
  }

  private func dummyData() -> [String: AnyObject] {
    return [
      "stuff": [
        ["id": "1", "text": "updated text from the network", "number": 123],
        ["id": "6", "text": "something something", "number": 987],
        ["id": "7", "text": "foo bar", "number": 654],
        ["id": "8", "text": "Use the Force Luke", "number": 321],
      ]
    ]
  }
}

// MARK: Reactive Extension

import ReactiveCocoa

extension NetworkService {

  func performRequest(toEndpoint endpoint: Endpoint) -> SignalProducer<[String: AnyObject], DomainError> {
    return SignalProducer { observer, disposable in
      self.performRequest(endpoint) { result in
        switch result {
        case .Success(let JSON):
          observer.sendNext(JSON)
          observer.sendCompleted()
        case .Failure(let error):
          observer.sendFailed(error)
        }
      }
    }
  }
}