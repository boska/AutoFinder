import UIKit
import RxSwift

class ListViewController: UITableViewController {
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = nil
    tableView.register(UINib(nibName: Cell.identifier, bundle: nil), forCellReuseIdentifier: Cell.identifier)
    tableView.separatorStyle = .none

    tableView.rx.willDisplayCell
      .subscribe(onNext: { cell, index in
        cell.contentView.backgroundColor = index.row % 2 == 0 ? .lightGray : .gray })
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] index in
      self?.tableView.deselectRow(at: index, animated: true)
    }).disposed(by: disposeBag)
  }
}
