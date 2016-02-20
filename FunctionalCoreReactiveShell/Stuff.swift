//
//  Stuff.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 20/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

struct Stuff {
  let id: String
  let text: String
  let number: Int
}

// MARK: JSON

import Argo
import Curry

extension Stuff: Decodable {
  static func decode(json: JSON) -> Decoded<Stuff> {
    return curry(Stuff.init)
      <^> json <| "id"
      <*> json <| "text"
      <*> json <| "number"
  }
}

extension Stuff {
  init?(json: [String: AnyObject]) {
    switch Stuff.decode(JSON.parse(json)) {
    case .Success(let value): self = value
    case .Failure(_): return nil
    }
  }
}

// MARK: Producer

import ReactiveCocoa

extension Stuff {
  static func stuff(withJSON json: [String: AnyObject]) -> SignalProducer<Stuff, DomainError> {
    guard let stuff = Stuff(json: json) else {
      return SignalProducer(error: .JSONDecodeFailed)
    }

    return SignalProducer(value: stuff)
  }
}
