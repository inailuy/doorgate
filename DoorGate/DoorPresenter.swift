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
    var state :DoorState
    var inEnable :Bool
    var outEnable :Bool
    
    func empty() -> DoorEntity {
        return DoorEntity(state: .empty, inEnable: false, outEnable: false)
    }
}

class DoorPresenter {
    var entity = PublishSubject<DoorEntity>()
    private let disposeBag = DisposeBag()

    init(commands:PublishSubject<DoorCommand>) {
        commands
            .scan(DoorEntity.empty, accumulator: DoorPresenter.accumulator)
            .subscribe({ result in
                self.entity.onNext(result)
        }).disposed(by: disposeBag)
    }

    static func accumulator(previousEntity: DoorEntity,
                                    command: DoorCommand) -> DoorEntity {
        let previousState = previousEntity.state.rawValue
        var newState :DoorState

        if command == .goingIn && previousState < DoorState.locked.rawValue {
            newState = DoorState(rawValue: previousState + 1)!
        } else if command == .goingOut && previousState > DoorState.empty.rawValue {
            newState = DoorState(rawValue: previousState - 1)!
        } else {
            print("Error on buttonTap: \(command)")
            // something went wrong revert to empty state (should never be hit)
            newState = DoorState(rawValue: DoorState.empty.rawValue)!
        }
        
        let inBool = newState.rawValue < THRESHOLD_TO_DISABLE_IN
        let outBool = newState.rawValue > THRESHOLD_TO_DISABLE_OUT
        
        return DoorEntity(state: newState, inEnable: inBool, outEnable: outBool)
    }
}
