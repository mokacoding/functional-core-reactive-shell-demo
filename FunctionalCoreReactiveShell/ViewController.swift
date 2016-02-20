//
//  ViewController.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 18/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController, UITableViewDataSource {

  @IBOutlet var tableView: UITableView!

  var data: [Stuff] = []

  let databaseService = DatabaseService()

  let cellIdentifier = "Cell"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

    loadData()
  }

  func loadData() {
    databaseService.allTheStuff()
      .observeOn(UIScheduler())
      .on(
        failed: { error in
          // TODO:
        },
        next: { [weak self] stuff in
          guard let strongSelf = self else {
            return
          }

          strongSelf.data = stuff
          strongSelf.tableView.reloadData()
        }
      )
      .start()
  }

  // MARK: UITableViewDataSource

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

    let stuff = data[indexPath.row]

    cell.textLabel?.text = stuff.text

    return cell
  }
}
