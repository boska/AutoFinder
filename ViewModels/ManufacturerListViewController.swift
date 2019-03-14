import RxSwift

final class ManufacturerListViewController: ListViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let viewModel = ManufacturerListViewModel()

    viewModel.rx.title
      .bind(to: rx.title)
      .disposed(by: disposeBag)

    viewModel.rx.items
      .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: Cell.self)) {
        (_, data, cell) in
        cell.nameLabel.text = data.name
      }
      .disposed(by: disposeBag)

    tableView.rx.nearBottom
      .asObservable()
      .bind(to: viewModel.loadNextPage)
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(Manufacturer.self)
      .subscribe(onNext: { manufacturer in
        let vm = MainTypeListViewModel(with: manufacturer, autoService: AutoService.shared)
        let vc = MainTypeListViewController(viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
      }).disposed(by: disposeBag)
  }
}

