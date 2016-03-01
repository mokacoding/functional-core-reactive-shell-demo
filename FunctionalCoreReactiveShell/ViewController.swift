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
    merge([
      databaseService.allTheStuff(),

      networkService.performRequest(toEndpoint: .GetStuff)
        .flatMapLatest { JSON in
          return Stuff.stuff(withJSON: JSON)
      }

      ])
      .map { stuffArray in stuffArray.map { CellViewModel(stuff: $0) } }
      .observeOnMainThread()
      .on(
        failed: { [weak self] error in
          self?.presentErrorAlert(error)
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

  // MARK: Alert

  func presentErrorAlert(error: ErrorType) {
    let alertController = UIAlertController(
      title: "Woooops",
      message: "\(error)",
      preferredStyle: .Alert
    )

    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: .None))

    presentViewController(alertController, animated: true, completion: .None)
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
