//
//  StuffJSONSerializationSpec.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 20/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Quick
import Nimble
import Argo
@testable import FunctionalCoreReactiveShell

class StuffJSONSerializationSpec: QuickSpec {
  override func spec() {

    describe("Decoding Stuff from JSON dictionary") {

      context("when the dictionary is empty") {
        it("returns .None") {
          let stuff = Stuff(json: [:])

          expect(stuff).to(beNil())
        }
      }

      context("when the dictionary is missing one of the required keys") {
        it("returns .None") {
          let dict1 = ["id": "42", "text": "anythingh"]
          expect(Stuff(json: dict1)).to(beNil())

          let dict2 = ["id": "42", "number": 3]
          expect(Stuff(json: dict2)).to(beNil())

          let dict3 = ["text": "anything", "number": 3]
          expect(Stuff(json: dict3)).to(beNil())
        }
      }

      context("when the dictionary contains all the valid keys") {
        it("it returns an instance configured with the values in the dictionary") {
          let anyId = "any id"
          let anyText = "any text"
          let anyNumber = 42
          let dict: [String: AnyObject] = ["id": anyId, "text": anyText, "number": anyNumber]

          let stuff = Stuff(json: dict)

          expect(stuff?.id) == anyId
          expect(stuff?.text) == anyText
          expect(stuff?.number) == anyNumber
        }
      }

      context("when the dictionary contains all the valid keys, plus extra keys") {
        it("it doesn't care about the extra keys") {
          let anyId = "any id"
          let anyText = "any text"
          let anyNumber = 42
          let dict: [String: AnyObject] = [
            "id": anyId,
            "text": anyText,
            "number": anyNumber,
            "useless key": "some value",
            "another useless key": "some value"
          ]

          let stuff = Stuff(json: dict)

          expect(stuff?.id) == anyId
          expect(stuff?.text) == anyText
          expect(stuff?.number) == anyNumber
        }
      }
    }
  }
}
