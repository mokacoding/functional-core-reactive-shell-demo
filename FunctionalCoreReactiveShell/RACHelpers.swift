//
//  RACHelpers.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 1/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import ReactiveCocoa

extension SignalProducerType {

  public func observeOnMainThread() -> SignalProducer<Value, Error> {
    return lift { $0.observeOn(UIScheduler()) }
  }

  public func flatMapLatest<U>(transform: Value -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
    return flatMap(.Latest, transform: transform)
  }
}

public func merge<U, Error>(producers: [SignalProducer<U, Error>]) -> SignalProducer<U, Error> {
  return SignalProducer(values: producers).flatten(.Merge)
}
