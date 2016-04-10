//
//  StuffFromRealmStuffSpec.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 4/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Quick
import Nimble
@testable import FunctionalCoreReactiveShell

class StuffFromRealmStuffSpec: QuickSpec {
  override func spec() {

    describe("Stuff model from Realm object") {
      it("sets its properties based on the Realm object one") {
        let realmObject = RealmStuff.test_fixture()

        let sut = Stuff(realmObject: realmObject)

        expect(sut.id) == realmObject.id
        expect(sut.number) == realmObject.number
        expect(sut.text) == realmObject.text
      }
    }
  }
}

extension RealmStuff {
  static func test_fixture(
    id: String = "any id",
    number: Int = 123,
    text: String = "any text"
    ) -> RealmStuff {
    let realmObject = RealmStuff()
    realmObject.id = id
    realmObject.number = number
    realmObject.text = text
    return realmObject
  }
}