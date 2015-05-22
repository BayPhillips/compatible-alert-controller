//
//  BPCompatibleAlertAction.swift
//  RelSci
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import Foundation
import UIKit

public enum BPCompatibleAlertActionStyle {
    case Default
    case Cancel
    case Destructive
}

let BPCompatibleAlertActionEnabledDidChangeNotification: String = "BPCompatibleAlertActionEnabledDidChangeNotification"

@objc(BPCompatibleAlertAction)
public class BPCompatibleAlertAction {
    /**
    The title of the Action to be shown in the button.
    */
    public let title: String?
    
    /**
    The style of the button, depending on its type of action.
    */
    public let actionStyle: BPCompatibleAlertActionStyle
    
    /**
    The handler to be called when the action/button is pressed.
    */
    public let handler: ((BPCompatibleAlertAction!) -> Void)?
    
    /**
    Whether or not this action is actionable.
    */
    public var enabled: Bool {
        didSet {
            if (enabled != oldValue) {
                // let the controller
                NSNotificationCenter.defaultCenter().postNotificationName(BPCompatibleAlertActionEnabledDidChangeNotification, object: self)
            }
        }
    }
    
    /**
    The UIAlertActionStyle to be used for the UIAlertController in iOS 8.
    */
    public var alertActionStyle: UIAlertActionStyle {
        get {
            if self.actionStyle == BPCompatibleAlertActionStyle.Cancel {
                return UIAlertActionStyle.Cancel
            } else if self.actionStyle == BPCompatibleAlertActionStyle.Destructive {
                return UIAlertActionStyle.Destructive
            } else {
                return UIAlertActionStyle.Default
            }
        }
    }
    
    /**
    Creates an instance of BPCompatibleAlertAction.
    
    :param: title The title of the button.
    :param: actionStyle The style of the button.
    :param: handler The block to be called when the button is pressed.
    
    :returns: The created action.
    */
    public init(title: String?, actionStyle: BPCompatibleAlertActionStyle, handler: ((BPCompatibleAlertAction!) -> Void)?) {
        self.title = title
        self.actionStyle = actionStyle
        self.handler = handler
        self.enabled = true
    }
    
    
    /**
    Helper function to create an instance of BPCompatibleAlertAction with the type of Default.
    
    :param: title The title of the button.
    :param: handler The block to be called when the button is pressed.
    
    :returns: The created action.
    */
    class func defaultActionWithTitle(title: String?, handler: ((BPCompatibleAlertAction!) -> Void)?) -> BPCompatibleAlertAction {
        return BPCompatibleAlertAction(title: title, actionStyle: BPCompatibleAlertActionStyle.Default, handler: handler)
    }
    
    /**
    Helper function to create an instance of BPCompatibleAlertAction with the type of Cancel.
    
    :param: title The title of the button.
    :param: handler The block to be called when the button is pressed.
    
    :returns: The created action.
    */
    class func cancelActionWithTitle(title: String?, handler: ((BPCompatibleAlertAction!) -> Void)?) -> BPCompatibleAlertAction {
        return BPCompatibleAlertAction(title: title, actionStyle: BPCompatibleAlertActionStyle.Cancel, handler: handler)
    }
    
    /**
    Helper function to create an instance of BPCompatibleAlertAction with the type of Desctructive.
    
    :param: title The title of the button.
    :param: handler The block to be called when the button is pressed.
    
    :returns: The created action.
    */
    class func destructiveActionWithTItle(title: String?, handler: ((BPCompatibleAlertAction!) -> Void)?) -> BPCompatibleAlertAction {
        return BPCompatibleAlertAction(title: title, actionStyle: BPCompatibleAlertActionStyle.Destructive, handler: handler)
    }
}
