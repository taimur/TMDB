// Copyright 2018, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// License   https://creativecommons.org/publicdomain/zero/1.0/
// Source    https://www.ralfebert.de/ios-examples/uikit/choicepopover/

import UIKit

class SuggestedValuesTVC: UITableViewController {
  typealias SelectionHandler = (String) -> Void
  typealias LabelProvider = (String) -> String

  private let values : [String]
  private let labels : LabelProvider
  private let onSelect : SelectionHandler?

  init(_ values : [String], labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) {
    self.values = values
    self.onSelect = onSelect
    self.labels = labels
    super.init(style: .plain)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return values.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    cell.textLabel?.text = labels(values[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.dismiss(animated: true)
    onSelect?(values[indexPath.row])
  }
}
