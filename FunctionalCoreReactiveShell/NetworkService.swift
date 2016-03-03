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

  var path: String {
    switch self {
    case .GetStuff: return "stuff"
    }
  }

  var method: String {
    switch self {
    case .GetStuff: return "GET"
    }
  }
}

class NetworkService {

  private let baseURL: NSURL
  private let session: NSURLSession

  init(baseURL baseURLString: String) {
    guard let _baseURL = NSURL(string: baseURLString) else {
      preconditionFailure("Provided base URL string is not a valid URL (\(baseURLString))")
    }

    self.baseURL = _baseURL
    self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
  }

  func performRequest(endpoint: Endpoint, completion: (Result<[String: AnyObject], DomainError>) -> ()) {
    let mutableRequest = NSMutableURLRequest(URL: baseURL.URLByAppendingPathExtension(endpoint.path))
    mutableRequest.HTTPMethod = endpoint.method

    let task = session.dataTaskWithRequest(mutableRequest) { data, response, error in
      var result: Result<[String: AnyObject], DomainError>
      if let error = error {
        result = Result(error: DomainError.BoxedError(error))

        completion(result)
        return
      }

      guard let data = data else {
        result = Result(error: DomainError.EmptyResponse)

        completion(result)
        return
      }

      do {
        guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] else {
          result = Result(error: DomainError.JSONDecodeFailed)

          completion(result)
          return
        }

        result = Result(value: json)
      } catch {
        result = Result(error: DomainError.JSONDecodeFailed)
      }

      completion(result)
    }

    task.resume()
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