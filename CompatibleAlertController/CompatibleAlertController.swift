//
//  CompatibleAlertController.swift
//  RelSci
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import Foundation
import UIKit

public enum CompatibleAlertControllerStyle {
    case Actionsheet
    case Alert
}

@objc(BPCompatibleAlertController)
public class CompatibleAlertController : NSObject, UIAlertViewDelegate {
    let title: String?
    let message: String?
    let alertStyle: CompatibleAlertControllerStyle
    private var actions: [CompatibleAlertAction]
    private var alertControllerStyle: UIAlertControllerStyle {
        get {
            return alertStyle == CompatibleAlertControllerStyle.Actionsheet
                ? UIAlertControllerStyle.ActionSheet
                : UIAlertControllerStyle.Alert
        }
    }
    private var alertViewStyle: UIAlertViewStyle {
        get {
            // TODO: Handle all styles
            return UIAlertViewStyle.Default
        }
    }
    
    public init(title: String?, message: String?, alertStyle: CompatibleAlertControllerStyle) {
        self.title = title
        self.message = message
        self.alertStyle = alertStyle
        self.actions = [CompatibleAlertAction]()
    }
    
    class func alertControllerWithTitle(title: String?, message: String?) -> CompatibleAlertController {
        return CompatibleAlertController(title: title, message: message, alertStyle: CompatibleAlertControllerStyle.Alert)
    }
    
    class func actionSheetControllerWithTitle(title: String?, message: String?) -> CompatibleAlertController {
        return CompatibleAlertController(title: title, message: message, alertStyle: CompatibleAlertControllerStyle.Actionsheet)
    }
    
    public func addAction(action: CompatibleAlertAction) -> Void {
        actions.append(action)
    }
    
    public func presentFrom(viewController: UIViewController!, animated: Bool, completion: (() -> Void)!) {
        if let checkCompatibility: AnyClass = NSClassFromString("UIAlertController") {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
            for action in actions {
                alertController.addAction(UIAlertAction(title: action.title!, style: action.alertActionStyle, handler: { (alertAction) -> Void in
                    action.handler(action)
                }))
            }
            viewController.presentViewController(alertController, animated: animated, completion: { () -> Void in
                completion()
            })
        } else {
            var actionsCopy:[CompatibleAlertAction] = actions
            var cancelAction: CompatibleAlertAction?
            var index = 0
            for action in actions {
                if action.actionStyle == CompatibleAlertActionStyle.Cancel {
                    cancelAction = action
                    actionsCopy.removeAtIndex(index)
                    break
                }
                index++
            }
            let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelAction?.title)
            alertView.alertViewStyle = alertViewStyle
            for action in actionsCopy {
                alertView.addButtonWithTitle(action.title!)
            }
            alertView.show()
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let action = self.actions[buttonIndex] as CompatibleAlertAction
        action.handler(action)
    }
}