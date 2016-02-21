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

  var viewModels: [CellViewModel] = []

  let databaseService = DatabaseService()
  let networkService = NetworkService()

  let cellIdentifier = "Cell"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

    loadData()
  }

  func loadData() {
    SignalProducer(
      values: [
        databaseService.allTheStuff(),
        networkService.performRequest(toEndpoint: .GetStuff)
          .flatMap(.Latest) { JSON in
            return Stuff.stuff(withJSON: JSON)
        }
      ]
      )
      .flatten(.Merge)
      .observeOn(UIScheduler())
      .map { stuffArray in stuffArray.map { CellViewModel(stuff: $0) } }
      .on(
        failed: { error in
          // TODO:
        },
        next: { [weak self] stuff in
          guard let strongSelf = self else {
            return
          }

          strongSelf.viewModels = stuff
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
    return viewModels.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

    let viewModel = viewModels[indexPath.row]

    cell.textLabel?.text = viewModel.text

    return cell
  }
}
