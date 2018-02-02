//
//  DoorPresenter.swift
//  
//
//  Created by Yuliani Noriega on 1/26/18.
//

struct DoorPresenter {
    let doorEntity = DoorEntity()
    
    mutating func buttonTap(command:DoorCommand) {
        let state = doorEntity.state.value //easier to read in the if statements below
        
        if command == .goingIn && state < DoorState.locked.rawValue {
            doorEntity.state.value += 1
        } else if command == .goingOut && state != DoorState.empty.rawValue{
            doorEntity.state.value -= 1
        } 
    }
}
