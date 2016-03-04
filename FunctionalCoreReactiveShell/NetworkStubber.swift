//
//  File.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 4/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import OHHTTPStubs

class NetworkStubber {

  static func stubGetStuffSuccess() {
    stub(isPath("/" + Endpoint.GetStuff.path)) { request in
      guard let path = OHPathForFile("stuff.json", self) else {
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
