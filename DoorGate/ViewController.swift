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
let EMPTY = 0
let OCCUPIED = 1
let LOCKED = 2

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
    var doorCommandPublishSubject = PublishSubject<DoorCommand>()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = DoorPresenter(commands: doorCommandPublishSubject)

        // Buttons Map In/Out
        deleteButton.rx.tap
            .subscribe(onNext: { _ in
                if #available(iOS 9.0, *) {
                    if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == DYNAMIC_IDENTIFIER }).first {
                        let index = UIApplication.shared.shortcutItems?.index(of: shortcutItem)
                        UIApplication.shared.shortcutItems?.remove(at: index!)
                        
                        print("deleted dynamic quick action")
                    }
                }  
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
        Observable.merge(inObserveable, outObserveable).subscribe(onNext: { doorCommand in
            self.doorCommandPublishSubject.onNext(doorCommand)
        }).disposed(by: disposeBag)

        // UI is updated after logic is adjusted in presenter
        presenter.entity.asObservable()
            .subscribe(onNext: { entity in
                self.updateUI(entity: entity)
            })
            .disposed(by: disposeBag)
    }

    func updateUI(entity:DoorEntity) {
        var count = EMPTY
        if entity.count != .empty {
            count = (entity.count == .occupied) ? OCCUPIED : LOCKED
        }
        
        self.countLabel.text = String(count)
        self.stateLabel.text = countString[count]

        self.inButton.isEnabled = entity.inEnable
        self.outButton.isEnabled = entity.outEnable
        
        if #available(iOS 9.0, *) {
            if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == DYNAMIC_IDENTIFIER }).first {
                let index = UIApplication.shared.shortcutItems?.index(of: shortcutItem)
                UIApplication.shared.shortcutItems?.remove(at: index!)
                
            }
            
            let item = UIMutableApplicationShortcutItem(type: DYNAMIC_IDENTIFIER, localizedTitle: "Dynamic Action")
            item.localizedSubtitle = countString[count]
            UIApplication.shared.shortcutItems?.append(item)
        }
    }
}
