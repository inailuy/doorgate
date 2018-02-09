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

let countString = ["Open", "Occupied", "Locked"]

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
    @IBOutlet weak var deleteButton: UIButton!
    
    // Publish Subject & Dispose Bag
    var events = PublishSubject<DoorCommand>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = DoorPresenter(commands: events)

        // Buttons Map In/Out
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
               //AppShortcut.deleteShortcut(identifier: DYNAMIC_IDENTIFIER)
                AppShortcut.deleteAllShortcut()
            }).disposed(by: disposeBag)

        
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
            guard let element = eventCommand.element else {
                return print("error on eventCommand") 
            }
            
            self.events.onNext(element)
        }).disposed(by: disposeBag)

        // UI is updated after logic is adjusted in presenter
        presenter.entity.asObservable()
            .subscribe({ [unowned self] entity in
                self.updateUI(event: entity)
            })
            .disposed(by: disposeBag)
    }

    func updateUI(event:Event<DoorEntity>) {
        guard let entity = event.element else {
            return print("error on event")
        }
        var count = 0
        if entity.count != .empty {
            count = (entity.count == .occupied) ? 1 : 2
        }
        
        self.countLabel.text = String(count)
        self.stateLabel.text = countString[count]

        self.inButton.isEnabled = entity.inEnable
        self.outButton.isEnabled = entity.outEnable
        
        AppShortcut.addShortcut(identifier: DYNAMIC_IDENTIFIER, substring: countString[count])
    }
}
