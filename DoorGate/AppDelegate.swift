//
//  AppDelegate.swift
//  DoorGate
//
//  Created by Yuliani Noriega on 1/19/18.
//  Copyright © 2018 Yuliani Noriega. All rights reserved.
//

import UIKit

enum ShortcutType: String {
    case staticType = "Static"
    case dynamicType = "Dynamic"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(withShortcutItem: shortcutItem))
    }
    
    func handleShortcutItem(withShortcutItem item: UIApplicationShortcutItem) -> Bool {
        guard let shortcutType = item.type.components(separatedBy: ".").last else { return false }
        
        if let type = ShortcutType(rawValue: shortcutType) {
            switch type {
            case .staticType:
                print("static quick action handled!")
                return true
            case .dynamicType:
                print("dynamic quick action handled! room state = " + item.localizedSubtitle!.lowercased())
                return true
            }
        }
        return false
    }
}

