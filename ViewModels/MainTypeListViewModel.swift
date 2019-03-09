import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base == MainTypeListViewModel {
  var items: Driver<[MainType]> {
    return base.types.asDriver(onErrorJustReturn: [])
  }
  var title: Observable<String> {
    return base.title
  }
}

struct MainTypeListViewModel: ReactiveCompatible {
  let loadNextPage: AnyObserver<()>

  fileprivate let types: Observable<[MainType]>
  fileprivate let title: Observable<String>

  init(with manufacturer: Manufacturer, autoService: AutoService = AutoService.shared) {
    let _loadNextPage = PublishSubject<Void>()
    self.loadNextPage = _loadNextPage.asObserver()

    let _title = BehaviorSubject<String>(value: manufacturer.name)
    self.title = _title.asObservable()

    types = _loadNextPage
      .enumerated()
      .flatMap {
        autoService.getMainTypes(with: manufacturer.id, on: $0.index)
      }.catchError { error in
        //handle error here sent to some subject? I really not sure yet
        return Observable.empty()
      }.map {
        $0.sorted(by: { $0.name <= $1.name })
      }.scan([], accumulator: { $0 + $1 })

  }
}
