//
//  AppShortcut.swift
//  DoorGate
//
//  Created by Yuliani Noriega on 2/8/18.
//  Copyright © 2018 Yuliani Noriega. All rights reserved.
//
import UIKit

enum ShortcutType: String {
    case staticType = "Static"
    case dynamicType = "Dynamic"
}

class AppShortcut {
    //MARK: AppDelegate Call
    static func handleShortcutFromAppDelegate(withShortcutItem item: UIApplicationShortcutItem) -> Bool {
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
    //MARK: Add/Delete 3D Pressure Shortcuts
    static func addShortcut(identifier: String, substring: String) {
        if #available(iOS 9.0, *) {
            if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == identifier }).first {
                let index = UIApplication.shared.shortcutItems?.index(of: shortcutItem)
                UIApplication.shared.shortcutItems?.remove(at: index!)
            }
            let item = UIMutableApplicationShortcutItem(type: identifier, localizedTitle: "Dynamic Action")
            item.localizedSubtitle = substring
            UIApplication.shared.shortcutItems?.append(item)
        }
    }
    
    static func deleteShortcut(identifier: String) {
        if #available(iOS 9.0, *) {
            if let shortcutItem = UIApplication.shared.shortcutItems?.filter({ $0.type == identifier }).first {
                let index = UIApplication.shared.shortcutItems?.index(of: shortcutItem)
                UIApplication.shared.shortcutItems?.remove(at: index!)
                print("deleted dynamic quick action")
            }
        }
    }
    
    static func deleteAllShortcut() {
        if #available(iOS 9.0, *) {
            UIApplication.shared.shortcutItems?.removeAll()
            print("deleted all dynamic quick actions")
        }
    }
}
