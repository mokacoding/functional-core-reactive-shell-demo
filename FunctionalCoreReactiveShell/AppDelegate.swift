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
    NetworkStubber.stubGetStuffSuccess()

    return true
  }
}
