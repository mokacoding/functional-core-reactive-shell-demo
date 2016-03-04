//
//  StuffServiceSpec.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 1/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
import RealmSwift
@testable import FunctionalCoreReactiveShell

class StuffServiceSpec: QuickSpec {
  override func spec() {

    describe("StuffService") {

      var sut: StuffService!

      let testRealm: Realm = {
        do {
          var configuration = Realm.Configuration.defaultConfiguration
          configuration.inMemoryIdentifier = "test"

          return try Realm(configuration: configuration)
        } catch {
          preconditionFailure("Could not init in memory Realm")
        }
      }()

      beforeEach {
        let testDatabaseService = DatabaseService(realm: testRealm)
        let testNetworkService = NetworkService(baseURL: "test://te.st")

        sut = StuffService(networkService: testNetworkService, databaseService: testDatabaseService)
      }

      context("when there is data in the database") {
        beforeEach {
          try! testRealm.write {
            let realmStuff = RealmStuff()
            realmStuff.id = "some id"
            realmStuff.text = "some text"
            realmStuff.number = 123

            testRealm.add(realmStuff)
          }
        }

        it("calls the callback with that data immediately") {
          var fetchedStuff: [Stuff]? = []
          sut.fetchStuff { stuff, error in
            fetchedStuff = stuff
          }

          expect(fetchedStuff?.count).toEventually(equal(1))
        }
      }

      context("when the network returns data successfully") {
        it("eventually calls the callback with the decoded data") {
          NetworkStubber.stubGetStuffSuccess()

          var fetchedStuff: [Stuff]? = []
          sut.fetchStuff { stuff, error in
            fetchedStuff = stuff
          }

          expect(fetchedStuff?.count).toEventually(equal(21))

          OHHTTPStubs.removeAllStubs()
        }
      }
    }
  }
}
