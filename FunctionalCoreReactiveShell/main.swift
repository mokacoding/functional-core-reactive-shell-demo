//
//  main.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 4/03/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import UIKit

private func delegateClassName() -> String? {
  return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate) : nil
}

UIApplicationMain(Process.argc, Process.unsafeArgv, nil, delegateClassName())
