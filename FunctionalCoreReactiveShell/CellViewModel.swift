//
//  CellViewModel.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 21/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Foundation

struct CellViewModel {

  let text: String
}

extension CellViewModel {

  init(stuff: Stuff) {
    self.text = "\(stuff.id) - \(stuff.text) (\(stuff.number))"
  }
}
