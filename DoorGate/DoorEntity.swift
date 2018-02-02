//
//  DoorEntity.swift
//  DoorGate
//
//  Created by Yuliani Noriega on 1/29/18.
//  Copyright © 2018 Yuliani Noriega. All rights reserved.
//
import RxSwift

struct DoorEntity {
    var state = Variable(DoorState.empty.rawValue)
}
