import UIKit
import RxSwift
import RxCocoa

class ManufacturerListViewController: UIViewController, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Manufacturers"

    let viewModel = ManufacturerListViewModel()

    viewModel.rx.items
      .drive(tableView.rx.items(cellIdentifier: "ManufacturerCell", cellType: ManufacturerCell.self)) {
        (_, data, cell) in
        cell.nameLabel.text = data.name
      }
      .disposed(by: disposeBag)

    tableView.rx.nearBottom
      .asObservable()
      .throttle(2, latest: false, scheduler: MainScheduler.instance)
      .bind(to: viewModel.loadNextPage)
      .disposed(by: disposeBag)

    tableView.rx.willDisplayCell
      .subscribe(onNext: { cell, index in
        cell.contentView.backgroundColor = index.row % 2 == 0 ? .lightGray : .gray })
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(Manufacturer.self).debug().subscribe().disposed(by: disposeBag)


  }
}

