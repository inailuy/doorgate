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

// Command
enum DoorCommand {
    case goingIn
    case goingOut
}

class ViewController: UIViewController {
    var presenter = DoorPresenter()

    // Labels
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    // Buttons
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    // Dispose Bag
    private let disposeBag = DisposeBag()
    
    // Publish Subject
    var publishSubject = PublishSubject<DoorCommand>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.passInViewContoller(vc: self)

        // Buttons Map In/Out
        let inObserveable = inButton.rx.tap
            .map{ _ in
                return DoorCommand.goingIn
            }
        let outObserveable = outButton.rx.tap
            .map{ _ in
                return DoorCommand.goingOut
        }
        // Buttons Merged and Subscribe
        Observable.merge(inObserveable, outObserveable).subscribe({ eventCommand in
            self.publishSubject.onNext(eventCommand.element!)
        }).disposed(by: disposeBag)
        
        // UI is updated after logic is adjusted in presenter
        presenter.state.asObservable()
            .subscribe(onNext: { [unowned self] state in
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
