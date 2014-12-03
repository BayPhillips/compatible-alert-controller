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
    
    /**
        Creates an instance of CompatibleAlertController.
        
        :param: title The title of the alert shown.
        :param: message The message shown for the alert below the title.
        :param: alertStyle The style to be used when displaying the alert. Currently only supporting iOS 8.
    
        :returns: The created alert controller.
    */
    public init(title: String?, message: String?, alertStyle: CompatibleAlertControllerStyle) {
        self.title = title
        self.message = message
        self.alertStyle = alertStyle
        self.actions = [CompatibleAlertAction]()
    }
    
    /**
        Creates a CompatibleAlertController with a type of Alert.
    
        :param: title The title of the alert shown.
        :param: message The message shown for the alert below the title.
    
    :   returns: The created alert controller.
    */
    class func alertControllerWithTitle(title: String?, message: String?) -> CompatibleAlertController {
        return CompatibleAlertController(title: title, message: message, alertStyle: CompatibleAlertControllerStyle.Alert)
    }
    
    /**
        Creates a CompatibleAlertController with a type of ActionSheet.
        
        :param: title The title of the alert shown.
        :param: message The message shown for the alert below the title.
    
        :returns: The created alert controller.
    */
    class func actionSheetControllerWithTitle(title: String?, message: String?) -> CompatibleAlertController {
        return CompatibleAlertController(title: title, message: message, alertStyle: CompatibleAlertControllerStyle.Actionsheet)
    }
    
    /**
        Adds a button with a corresponding action to be executed upon pressing.
        
        :param: action The CompatibleAlertAction with set title and action block.
    */
    public func addAction(action: CompatibleAlertAction) -> Void {
        actions.append(action)
    }
    
    /**
        Presents the CompatibleAlertController to the user in the passed in UIViewController. If iOS 7, will
        disregard the viewController and simply show the UIAlertView.
    
        :param: viewController The UIViewController for the UIAlertController to be displayed to. Not used in iOS 7.
        :param: animated Whether or not to animate the presentation.
        :param: completion The completion block to be called when done presenting.
    */
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
    
    /**
        Used to handle iOS 7 UIAlertView delegate calls. Do not use.
    */
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let action = self.actions[buttonIndex] as CompatibleAlertAction
        action.handler(action)
    }
}