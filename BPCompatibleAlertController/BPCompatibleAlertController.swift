//
//  BPCompatibleAlertController.swift
//  RelSci
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import Foundation
import UIKit

public enum BPCompatibleAlertControllerStyle {
    case Actionsheet
    case Alert
}

@objc(BPCompatibleAlertController)
public class BPCompatibleAlertController : NSObject, UIAlertViewDelegate {
    let title: String?
    let message: String?
    let alertStyle: BPCompatibleAlertControllerStyle
    private var actions: [BPCompatibleAlertAction]
    private var alertControllerStyle: UIAlertControllerStyle {
        get {
            return alertStyle == BPCompatibleAlertControllerStyle.Actionsheet
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
    
    public init(title: String?, message: String?, alertStyle: BPCompatibleAlertControllerStyle) {
        self.title = title
        self.message = message
        self.alertStyle = alertStyle
        self.actions = [BPCompatibleAlertAction]()
    }
    
    class func alertControllerWithTitle(title: String?, message: String?) -> BPCompatibleAlertController {
        return BPCompatibleAlertController(title: title, message: message, alertStyle: BPCompatibleAlertControllerStyle.Alert)
    }
    
    class func actionSheetControllerWithTitle(title: String?, message: String?) -> BPCompatibleAlertController {
        return BPCompatibleAlertController(title: title, message: message, alertStyle: BPCompatibleAlertControllerStyle.Actionsheet)
    }
    
    public func addAction(action: BPCompatibleAlertAction) -> Void {
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
            var actionsCopy:[BPCompatibleAlertAction] = actions
            var cancelAction: BPCompatibleAlertAction?
            var index = 0
            for action in actions {
                if action.actionStyle == BPCompatibleAlertActionStyle.Cancel {
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
        let action = self.actions[buttonIndex] as BPCompatibleAlertAction
        action.handler(action)
    }
}