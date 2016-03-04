//
//  AppDelegate.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 18/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    setupNetworkStubs()

    return true
  }
}

import OHHTTPStubs

extension AppDelegate {

  func setupNetworkStubs() {
    stub(isPath("/" + Endpoint.GetStuff.path)) { request in
      guard let path = OHPathForFile("stuff.json", self.dynamicType) else {
        preconditionFailure("Could not load fixture file")
      }

      return OHHTTPStubsResponse(
        fileAtPath: path,
        statusCode: 200,
        headers: ["ContentType": "application/json"]
      )
    }
  }
}
