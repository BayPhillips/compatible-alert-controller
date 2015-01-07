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
    private var actions: [String : BPCompatibleAlertAction]
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
    private var isiOS8: Bool {
        get {
            return objc_getClass("UIAlertController") != nil
        }
    }
    
    /**
    Creates an instance of BPCompatibleAlertController.
    
    :param: title The title of the alert shown.
    :param: message The message shown for the alert below the title.
    :param: alertStyle The style to be used when displaying the alert. Currently only supporting iOS 8.
    
    :returns: The created alert controller.
    */
    public init(title: String?, message: String?, alertStyle: BPCompatibleAlertControllerStyle) {
        self.title = title
        self.message = message
        self.alertStyle = alertStyle
        self.actions = [String : BPCompatibleAlertAction]()
    }
    
    /**
    Creates a BPCompatibleAlertController with a type of Alert.
    
    :param: title The title of the alert shown.
    :param: message The message shown for the alert below the title.
    
    :   returns: The created alert controller.
    */
    class func alertControllerWithTitle(title: String?, message: String?) -> BPCompatibleAlertController {
        return BPCompatibleAlertController(title: title, message: message, alertStyle: BPCompatibleAlertControllerStyle.Alert)
    }
    
    /**
    Creates a BPCompatibleAlertController with a type of ActionSheet.
    
    :param: title The title of the alert shown.
    :param: message The message shown for the alert below the title.
    
    :returns: The created alert controller.
    */
    class func actionSheetControllerWithTitle(title: String?, message: String?) -> BPCompatibleAlertController {
        return BPCompatibleAlertController(title: title, message: message, alertStyle: BPCompatibleAlertControllerStyle.Actionsheet)
    }
    
    /**
    Adds a button with a corresponding action to be executed upon pressing.
    
    :param: action The BPCompatibleAlertAction with set title and action block.
    */
    public func addAction(action: BPCompatibleAlertAction) -> Void {
        actions[action.title!] = action
    }
    
    /**
    Presents the BPCompatibleAlertController to the user in the passed in UIViewController. If iOS 7, will
    disregard the viewController and simply show the UIAlertView.
    
    :param: viewController The UIViewController for the UIAlertController to be displayed to. Not used in iOS 7.
    :param: animated Whether or not to animate the presentation.
    :param: completion The completion block to be called when done presenting.
    */
    public func presentFrom(viewController: UIViewController!, animated: Bool, completion: (() -> Void)?) {
        if isiOS8 {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
            for action in actions.values {
                alertController.addAction(UIAlertAction(title: action.title!, style: action.alertActionStyle, handler: { (alertAction) -> Void in
                    if let handler = action.handler {
                        handler(action)
                    }
                }))
            }
            viewController.presentViewController(alertController, animated: animated, completion: { () -> Void in
                if let completionHandler = completion {
                    completionHandler()
                }
            })
        } else {
            var actionsCopy:[String : BPCompatibleAlertAction] = actions
            var cancelAction: BPCompatibleAlertAction?
            var index = 0
            for (title, action) in actions {
                if action.actionStyle == BPCompatibleAlertActionStyle.Cancel {
                    cancelAction = action
                    actionsCopy.removeValueForKey(title)
                    break
                }
                index++
            }
            
            let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelAction?.title)
            alertView.alertViewStyle = alertViewStyle
            for (title, action) in actionsCopy {
                alertView.addButtonWithTitle(title)
            }
            alertView.show()
        }
    }
    
    /**
    Used to handle iOS 7 UIAlertView delegate calls. Do not use.
    */
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let action = actions[alertView.buttonTitleAtIndex(buttonIndex)] as BPCompatibleAlertAction!
        if let handler = action.handler {
            handler(action)
        }
    }
}