//
//  CellViewModelSpec.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 21/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Quick
import Nimble
@testable import FunctionalCoreReactiveShell

class CellViewModelSpec: QuickSpec {
  override func spec() {

    describe("CellViewModel") {
      context("when initialized with a Stuff model") {
        it("sets the text using the stuff properties") {
          let stuff = Stuff(id: "123", text: "any text", number: 42)

          let sut = CellViewModel(stuff: stuff)

          expect(sut.text) == "123 - any text (42)"
        }
      }
    }
  }
}
