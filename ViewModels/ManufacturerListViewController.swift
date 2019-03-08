//
//  ViewController.swift
//  autofinder
//
//  Created by Boska on 2019/3/8.
//  Copyright © 2019 boska. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ManufacturerListViewController: UITableViewController {
  let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Manufacturers"
    tableView.dataSource = nil
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    let viewModel = ManufacturerListViewModel()
    viewModel.rx.items.drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (_, data, cell) in
      cell.textLabel?.text = data.name
      //cell.configure(data: data)
    }.disposed(by: disposeBag)

    tableView.rx.nearBottom.asObservable().throttle(2, latest: false, scheduler: MainScheduler.instance).bind(to: viewModel.loadNextPage).disposed(by: disposeBag)
    
  }
}

extension Reactive where Base: UITableView {
  var nearBottom: Signal<()> {
    func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 20.0) -> Bool {
      return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
    }
    return self.contentOffset.asDriver()
      .flatMap { _ in
        return isNearBottomEdge(tableView: self.base, edgeOffset: 20.0)
          ? Signal.just(())
          : Signal.empty()
    }
  }
}
