//
//  StuffServiceSpec.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 1/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import Quick
import Nimble
@testable import FunctionalCoreReactiveShell

class StuffServiceSpec: QuickSpec {
  override func spec() {

    describe("StuffService") {

      var sut: StuffService!

      beforeEach {
        // TODO: Implement Realm integration
        let testDatabaseService = DatabaseService()
        let testNetworkService = NetworkService(baseURL: "test://te.st")

        sut = StuffService(networkService: testNetworkService, databaseService: testDatabaseService)
      }

      context("when there is data in the database") {
        it("calls the callback with that data immediately") {

        }
      }

      context("when the network returns data successfully") {
        it("eventually calls the callback with the decoded data") {

        }
      }
    }
  }
}
