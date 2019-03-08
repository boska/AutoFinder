import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
  var nearBottom: Signal<()> {
    func isNearBottomEdge(tableView: UITableView, edgeOffset: CGFloat = 30.0) -> Bool {
      return tableView.contentOffset.y + tableView.frame.size.height + edgeOffset > tableView.contentSize.height
    }
    return self.contentOffset.asDriver()
      .flatMap { _ in
        return isNearBottomEdge(tableView: self.base)
          ? Signal.just(())
          : Signal.empty()
    }
  }
}
