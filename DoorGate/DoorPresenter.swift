//
//  DoorPresenter.swift
//  
//
//  Created by Yuliani Noriega on 1/26/18.
//
import RxSwift

enum DoorState {
    case empty, occupied, locked
}

struct DoorEntity {
    var count :DoorState
    var inEnable :Bool
    var outEnable :Bool
    
    static var empty:DoorEntity {
        return DoorEntity(count: .empty, inEnable: false, outEnable: false)
    }
}

class DoorPresenter {
    private var entitySubject = PublishSubject<DoorEntity>()
    var entity: Observable<DoorEntity> {
        return entitySubject.asObservable()
    }
    
    private let disposeBag = DisposeBag()

    init(commands:PublishSubject<DoorCommand>) {
        commands
            .scan(DoorEntity.empty, accumulator: DoorPresenter.accumulator)
            .subscribe({ result in
                guard let element = result.element else {
                    return print("error on DoorPresenter init commands subcribe")
                }
                
                self.entitySubject.onNext(element)
        }).disposed(by: disposeBag)
    }

    static func accumulator(previousEntity: DoorEntity,
                                    command: DoorCommand) -> DoorEntity {
        let previousCount = previousEntity.count
        var newCount :DoorState

        if command == .goingIn && previousCount != DoorState.locked {
            newCount = (previousCount == .empty) ? .occupied : .locked
        } else if command == .goingOut && previousCount != DoorState.empty {
            newCount = (previousCount == .locked) ? .occupied : .empty
        } else {
            print("Error on buttonTap: \(command)")
            // something went wrong revert to empty state (should never be hit)
            newCount = DoorState.empty
        }

        let inBool = (newCount == DoorState.locked) ? false : true
        let outBool = (newCount == DoorState.empty) ? false : true
        
        return DoorEntity(count: newCount, inEnable: inBool, outEnable: outBool)
    }
}
