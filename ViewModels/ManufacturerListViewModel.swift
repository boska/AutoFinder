import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base == ManufacturerListViewModel {
  var items: Driver<[Manufacturer]> {
    return base.manufacturers.asDriver(onErrorJustReturn: [])
  }
  var title: Observable<String> {
    return Observable.just("Manufacturers")
  }
}

struct ManufacturerListViewModel: ReactiveCompatible {
  let loadNextPage: AnyObserver<()>
  fileprivate let manufacturers: Observable<[Manufacturer]>

  init(autoService: AutoService = AutoService.shared) {
    let _loadNextPage = PublishSubject<Void>()
    self.loadNextPage = _loadNextPage.asObserver()
    manufacturers = _loadNextPage
      .enumerated()
      .flatMap {
        autoService.getManufacturers(on: $0.index)
      }.catchError { error in
        //handle error here sent to some subject? I really not sure yet
        return Observable.empty()
      }.map {
        $0.sorted(by: { $0.name <= $1.name })
      }.scan([], accumulator: { $0 + $1 })

  }
}
