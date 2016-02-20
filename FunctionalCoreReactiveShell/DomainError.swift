//
//  DomainError.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 20/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation

enum DomainError: ErrorType {
  // TODO: Doesn't RAC have a no error type already
  case NoError

  case JSONDecodeFailed
}
