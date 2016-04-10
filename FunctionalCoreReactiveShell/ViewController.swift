//
//  ViewController.swift
//  FunctionalCoreReactiveShell
//
//  Created by Giovanni on 18/02/2016.
//  Copyright © 2016 mokagio. All rights reserved.
//

import UIKit
import ReactiveCocoa
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource {

  enum Effect {
    case UpdateView(viewModels: [CellViewModel])
    case PresentAlert(error: ErrorType)
  }

  @IBOutlet var tableView: UITableView!

  var viewModels: [CellViewModel] = []

  // TODO: Move to AppDelegate or environment coordinator
  var databaseService: DatabaseService = { () -> DatabaseService in
    do {
      let configuration = Realm.Configuration.defaultConfiguration
      let realm = try Realm(configuration: configuration)

      return DatabaseService(realm: realm)
    } catch {
      preconditionFailure("Could not initialize default Reaml")
    }
  }()
  let networkService = NetworkService(baseURL: "https://mokacoding.com")

  let cellIdentifier = "Cell"

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

    loadData()
  }

  func loadData() {
    merge([
      databaseService.allStuff()
        .map { $0.map { Stuff(realmObject: $0) } },

      networkService.performRequest(toEndpoint: .GetStuff)
        .flatMapLatest { JSON in
          return Stuff.stuffProducer(withJSON: JSON)
      }

      ])
      .map { stuffArray in stuffArray.map { CellViewModel(stuff: $0) } }
      .map { viewModels in Effect.UpdateView(viewModels: viewModels) }
      .observeOnMainThread()
      .on(
        failed: { [weak self] error in
          self?.performEffect(Effect.PresentAlert(error: error))
        },
        next: { [weak self] effect in
          self?.performEffect(effect)
        }
      )
      .start()
  }

  func performEffect(effect: Effect) {
    switch effect {

    case .UpdateView(let viewModels):
      self.viewModels = viewModels
      tableView.reloadData()

    case .PresentAlert(let error):
      presentErrorAlert(error)
    }
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
