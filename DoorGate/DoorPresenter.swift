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
    var state = Variable(DoorState.empty.rawValue)
    var viewController :ViewController?
    private let disposeBag = DisposeBag()
    
    func passInViewContoller(vc:ViewController) {
        viewController = vc
        
        viewController?.publishSubject.subscribe({ [unowned self] doorCommand in
            //easier to read in the if statements below
            let command = doorCommand.element
            let state = self.state.value
            
            if command == .goingIn && state < DoorState.locked.rawValue {
                self.state.value += 1
            } else if command == .goingOut && state > DoorState.empty.rawValue {
                self.state.value -= 1
            } else {
                print("Error on buttonTap: \(command)")
                // something went wrong revert to empty state (should never be hit)
                self.state.value = DoorState.empty.rawValue
            }
        }).disposed(by: disposeBag)
    }
}
