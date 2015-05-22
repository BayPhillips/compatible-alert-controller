//
//  BPCompatibleAlertController.swift
//  RelSci
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import Foundation
import UIKit

public typealias BPCompatibleTextFieldConfigruationHandler = ((UITextField!) -> Void)!

public enum BPCompatibleAlertControllerStyle {
    case Actionsheet
    case Alert
}

@objc(BPCompatibleAlertController)
public class BPCompatibleAlertController : NSObject, UIAlertViewDelegate {
    let title: String?
    let message: String?
    let alertStyle: BPCompatibleAlertControllerStyle
    
    /**
    Allows for UITextFields in iOS7 UIAlertViews. Must have corresponding counts of
    BPCompatibleTextFieldConfigurationHandlers for each style.
    Default = 0
    PlainTextInput or SecureTextInput = 1
    LoginAndPasswordInpnut = 2
    */
    public var alertViewStyle: UIAlertViewStyle
    
    private var alertController: UIAlertController!
    private var alertView: UIAlertView!
    private var actions: [String : BPCompatibleAlertAction]
    private var textFieldConfigurations: [BPCompatibleTextFieldConfigruationHandler]
    private var alertControllerStyle: UIAlertControllerStyle {
        get {
            return alertStyle == BPCompatibleAlertControllerStyle.Actionsheet
                ? UIAlertControllerStyle.ActionSheet
                : UIAlertControllerStyle.Alert
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
        self.alertViewStyle = UIAlertViewStyle.Default
        self.actions = [String : BPCompatibleAlertAction]()
        self.textFieldConfigurations = [BPCompatibleTextFieldConfigruationHandler]()
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
        
        // listen to changes on the BPCompatibleAlertAction enabled field to update the UIAlertAction in the alertController
        NSNotificationCenter.defaultCenter().addObserverForName(BPCompatibleAlertActionEnabledDidChangeNotification, object: action, queue: NSOperationQueue.mainQueue()) { (notification) in
            if self.isiOS8 {
                for a in self.alertController.actions {
                    if a.title == action.title {
                        if let internalAction = a as? UIAlertAction {
                            internalAction.enabled = action.enabled
                        }
                        break
                    }
                }
            }
        }
    }
    
    public func addTextFieldWithConfigurationHandler(configurationHandler : BPCompatibleTextFieldConfigruationHandler ) -> Void {
        textFieldConfigurations.append(configurationHandler)
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
            alertController = UIAlertController(title: title, message: message, preferredStyle: alertControllerStyle)
            for action in actions.values {
                
                let uiAlertAction = UIAlertAction(title: action.title!, style: action.alertActionStyle, handler: { (alertAction) in
                    if let handler = action.handler {
                        handler(action)
                    }
                })
                uiAlertAction.enabled = action.enabled
                alertController.addAction(uiAlertAction)
            }
            
            for textFieldHandler in textFieldConfigurations {
                alertController.addTextFieldWithConfigurationHandler(textFieldHandler)
            }
            
            viewController.presentViewController(alertController, animated: animated, completion: { () in
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
            
            alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: cancelAction?.title)
            
            sanityCheckTextFields()
            
            alertView.alertViewStyle = alertViewStyle
            
            for (index, config) in enumerate(textFieldConfigurations) {
                let textField = alertView.textFieldAtIndex(index) as UITextField!
                config(textField)
            }
            
            for (title, action) in actionsCopy {
                alertView.addButtonWithTitle(title)
            }
            
            alertView.show()
        }
    }
    
    private func sanityCheckTextFields() {
        if alertViewStyle == UIAlertViewStyle.Default {
            assert(textFieldConfigurations.isEmpty, "You must set the alertViewStyle property to the corresponding style in order to use textFields in iOS7")
        } else if alertViewStyle == UIAlertViewStyle.PlainTextInput || alertViewStyle == UIAlertViewStyle.SecureTextInput {
            assert(textFieldConfigurations.count == 1, "You must specify only 1 textField when using either SecureTextInput or PlainTextInput")
        } else if alertViewStyle == UIAlertViewStyle.LoginAndPasswordInput {
            assert(textFieldConfigurations.count == 2, "You must specify 2 textFields when using the LoginAndPasswordInput alertViewStyle")
        }
    }
    
    public func textFieldAtIndex(index: Int) -> UITextField? {
        if isiOS8 {
            if alertController.textFields?.count > index {
                if let textField: UITextField = alertController.textFields![index] as? UITextField {
                    return textField
                }
            }
            return nil
        } else {
            return alertView.textFieldAtIndex(index)
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