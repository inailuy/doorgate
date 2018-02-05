//
//  ViewController.swift
//  DoorGate
//
//  Created by Yuliani Noriega on 1/19/18.
//  Copyright © 2018 Yuliani Noriega. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let stateString = ["Open", "Occupied", "Locked"]
let THRESHOLD_TO_DISABLE_IN = 2
let THRESHOLD_TO_DISABLE_OUT = 0

class ViewController: UIViewController {
    var presenter = DoorPresenter()

    //Labels
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    //Buttons
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    //Dispose Bag
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //In Button Logic
        inButton.rx.tap
            .subscribe({ [unowned self] currentCount in
                self.presenter.buttonTap(command: DoorCommand.goingIn)
            })
            .disposed(by: disposeBag)
        //Out Button Logic
        outButton.rx.tap
            .subscribe({ [unowned self] currentCount in
                self.presenter.buttonTap(command: DoorCommand.goingOut)
                })
            .disposed(by: disposeBag)

        presenter.doorEntity.state.asObservable()
            .subscribe(onNext: { state in
                //This feels wrong encapsulating self without the [unowned self]
                self.updateUI(count: state)
            })
            .disposed(by: disposeBag)
    }

    func updateUI(count :Int) {
        self.countLabel.text = String(count)
        self.stateLabel.text = stateString[count]
        
        self.inButton.isEnabled = (count < THRESHOLD_TO_DISABLE_IN)
        self.outButton.isEnabled = (count > THRESHOLD_TO_DISABLE_OUT)
    }
}
