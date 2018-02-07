//
//  DoorPresenter.swift
//  
//
//  Created by Yuliani Noriega on 1/26/18.
//
import RxSwift

enum DoorState :Int {
    case empty = 0, occupied, locked
}

let THRESHOLD_TO_DISABLE_IN = 2
let THRESHOLD_TO_DISABLE_OUT = 0

struct DoorEntity {
    var count :DoorState
    var inEnable :Bool
    var outEnable :Bool
    
    static func empty() -> DoorEntity {
        return DoorEntity(count: .empty, inEnable: false, outEnable: false)
    }
}

class DoorPresenter {
    var entity = PublishSubject<DoorEntity>()
    private let disposeBag = DisposeBag()

    init(commands:PublishSubject<DoorCommand>) {
        commands
            .scan(DoorEntity.empty(), accumulator: DoorPresenter.accumulator)
            .subscribe({ result in
                self.entity.onNext(result.element!)
        }).disposed(by: disposeBag)
    }

    static func accumulator(previousEntity: DoorEntity,
                                    command: DoorCommand) -> DoorEntity {
        let previousCount = previousEntity.count.rawValue
        var newCount :DoorState

        if command == .goingIn && previousCount < DoorState.locked.rawValue {
            newCount = DoorState(rawValue: previousCount + 1)!
        } else if command == .goingOut && previousCount > DoorState.empty.rawValue {
            newCount = DoorState(rawValue: previousCount - 1)!
        } else {
            print("Error on buttonTap: \(command)")
            // something went wrong revert to empty state (should never be hit)
            newCount = DoorState(rawValue: DoorState.empty.rawValue)!
        }
        
        let inBool = newCount.rawValue < THRESHOLD_TO_DISABLE_IN
        let outBool = newCount.rawValue > THRESHOLD_TO_DISABLE_OUT
        
        return DoorEntity(count: newCount, inEnable: inBool, outEnable: outBool)
    }
}
