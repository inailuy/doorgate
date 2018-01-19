//
//  ViewController.swift
//  DoorGate
//
//  Created by Yuliani Noriega on 1/19/18.
//  Copyright © 2018 Yuliani Noriega. All rights reserved.
//

import UIKit

enum State:Int{
    case Open = 0, Occupied, Locked
}

let stateString = ["Open", "Occupied", "Locked"]

class ViewController: UIViewController {
    //Labels
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    //Buttons
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    //State Variable
    var doorState = State.Open.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeState(state: 0)
    }

    //Mark: Button Action
    @IBAction func buttonPressed(_ sender: UIButton) {
        var state = 1
        if sender == outButton {
            state = -1
        }
        changeState(state: state)
    }
    
    func changeState(state:Int) {
        //updating state
        doorState = doorState + state
        
        //updating UI
        countLabel.text = String(doorState)
        stateLabel.text = stateString[doorState]
        
        switch doorState {
        case State.Open.rawValue:
            inButton.isEnabled = true
            outButton.isEnabled = false
            return
        case State.Occupied.rawValue:
            inButton.isEnabled = true
            outButton.isEnabled = true
            return
        case State.Locked.rawValue:
            inButton.isEnabled = false
            outButton.isEnabled = true
            return
        default:
            return
        }
    }
}

