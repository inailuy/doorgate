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

class ViewController: UIViewController {
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
        inButton.rx.tap.scan(0) { (priorValue, _) in
                return 1
            }
            .subscribe(onNext: { [unowned self] currentCount in
                let count = Int(self.countLabel.text!)! + currentCount
                self.logic(count: count)
                })
            .disposed(by: disposeBag)
       
        //Out Button Logic
        outButton.rx.tap.scan(0) { (priorValue, _) in
                return -1
            }
            .subscribe(onNext: { [unowned self] currentCount in
                let count = Int(self.countLabel.text!)! + currentCount
                self.logic(count: count)
            })
            .disposed(by: disposeBag)
    }
    
    func logic(count :Int) {
        self.countLabel.text = String(count)
        self.stateLabel.text = stateString[count]

        self.inButton.isEnabled = (count < 2)
        self.outButton.isEnabled = (count > 0)
    }
}

