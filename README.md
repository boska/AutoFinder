# rx-1

it has two UITableView fetch source from dependnt diffrent route of api

## Cons
- There's still a confusing code between viewmodels
- Naming still too verbose
- Dependencies
- MVC way on navigation
- No test on Observables and Subjects
## Pros

- Clean view model for cyclic api call

ManufacturerListViewModel have one input loadNextPage which is hooked by the uiscrollview scroll to bottom
and have only one output show an array of Manufacturer

```ManufacturerListViewModel.swift
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
    manufacturers = _loadNextPage.throttle(0.5, scheduler: MainScheduler.instance)
      //map void event into index
      .enumerated()
      //flap map into api service
      .flatMap {
        autoService.getManufacturers(on: $0.index)  
      }.catchError { error in
        //handle error here sent to some subject? I really not sure yet
        return Observable.empty()
      //sorting
      }.map {
        $0.sorted(by: { $0.name <= $1.name })
      }
      //scan concat result
      .scan([], accumulator: { $0 + $1 })

  }
}
```

## Prerequisites

- [CocoaPods](https://cocoapods.org/)

```
$ sudo gem install cocoapods
```

then execute

```
pod install
```

```
open autofinder.xcworkspace
```

one last thing
put your api key in Secret.plist

```
  AutoFinder/Resources/Secret.plist
```

This project is based on learning with

[RxSwift - Reactive Programming with Swift](https://store.raywenderlich.com/products/rxswift)
