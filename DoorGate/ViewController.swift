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

// Command
enum DoorCommand {
    case goingIn
    case goingOut
}

class ViewController: UIViewController {
    // iVars
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    // Publish Subject & Dispose Bag
    var events = PublishSubject<DoorCommand>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = DoorPresenter(commands: events)

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
            self.events.onNext(eventCommand.element!)
        }).disposed(by: disposeBag)

        // UI is updated after logic is adjusted in presenter
        presenter.entity.asObservable()
            .subscribe({ [unowned self] entity in
                self.updateUI(event: entity)
            })
            .disposed(by: disposeBag)
    }

    func updateUI(event:Event<DoorEntity>) {
        let entity = event.element!
        
        self.countLabel.text = String(entity.state.rawValue)
        self.stateLabel.text = stateString[entity.state.rawValue]

        self.inButton.isEnabled = entity.inEnable
        self.outButton.isEnabled = entity.outEnable
    }
}
