import RxSwift

final class MainTypeListViewController: ListViewController {
  private let viewModel: MainTypeListViewModel

  init(viewModel: MainTypeListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.rx.title.bind(to: rx.title).disposed(by: disposeBag)

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

    tableView.rx.willDisplayCell
      .subscribe(onNext: { cell, index in
        cell.contentView.backgroundColor = index.row % 2 == 0 ? .lightGray : .gray })
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(MainType.self)
      .subscribe(onNext: { [weak self] type in
        guard let title = self?.title else {
          return
        }
       self?.presentAlert(title: "\(title) - \(type.name)")
      }).disposed(by: disposeBag)

  }
}

