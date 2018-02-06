//
//  DoorPresenter.swift
//  
//
//  Created by Yuliani Noriega on 1/26/18.
//
import RxSwift

// State
enum DoorState: Int {
    case empty = 0, occupied, locked
}

class DoorPresenter {
    var state = PublishSubject<DoorState>()
    private let disposeBag = DisposeBag()

    init(commands:PublishSubject<DoorCommand>) {
        commands
            .scan(DoorState.empty, accumulator: DoorPresenter.accumulator)
            .subscribe({ result in
                self.state.onNext(result.element!)
        }).disposed(by: disposeBag)
    }

    static func accumulator(previousState: DoorState,
                                    command: DoorCommand) -> DoorState {
        var newState = previousState.rawValue

        if command == .goingIn && previousState.rawValue < DoorState.locked.rawValue {
            newState += 1
        } else if command == .goingOut && previousState.rawValue > DoorState.empty.rawValue {
            newState -= 1
        } else {
            print("Error on buttonTap: \(command)")
            // something went wrong revert to empty state (should never be hit)
            newState = DoorState.empty.rawValue
        }
        return DoorState(rawValue: newState)!
    }
}
