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

  // TODO: This should not be necessary
  //
  init(id: String, text: String, number: Int) {
    self.id = id
    self.text = text
    self.number = number
  }
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
  static func stuff(withJSON json: [String: AnyObject]) -> SignalProducer<[Stuff], DomainError> {
    // TODO: Maybe getting the "stuff" part belogns outside this method?
    guard let rawStuff = json["stuff"] as? [[String: AnyObject]] else {
      return SignalProducer(error: .JSONDecodeFailed)
    }

    let stuff = rawStuff.flatMap { Stuff(json: $0) }

    return SignalProducer(value: stuff)
  }
}
