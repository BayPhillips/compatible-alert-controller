//
//  CompatibleAlertAction.swift
//  RelSci
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import Foundation
import UIKit

public enum CompatibleAlertActionStyle {
    case Default
    case Cancel
    case Destructive
}

@objc(BPCompatibleAlertAction)
public class CompatibleAlertAction {
    /**
        The title of the Action to be shown in the button.
    */
    public let title: String?
    
    /**
        The style of the button, depending on its type of action.
    */
    public let actionStyle: CompatibleAlertActionStyle
    
    /**
        The handler to be called when the action/button is pressed.
    */
    public let handler: ((CompatibleAlertAction!) -> Void)!
    
    /**
        Whether or not this action is actionable. Currently not supported.
    */
    public var enabled: Bool
    
    /**
        The UIAlertActionStyle to be used for the UIAlertController in iOS 8.
    */
    public var alertActionStyle: UIAlertActionStyle {
        get {
            if self.actionStyle == CompatibleAlertActionStyle.Cancel {
                return UIAlertActionStyle.Cancel
            } else if self.actionStyle == CompatibleAlertActionStyle.Destructive {
                return UIAlertActionStyle.Destructive
            } else {
                return UIAlertActionStyle.Default
            }
        }
    }
    
    /**
        Creates an instance of CompatibleAlertAction.
        
        :param: title The title of the button.
        :param: actionStyle The style of the button.
        :param: handler The block to be called when the button is pressed.
    
        :returns: The created action.
    */
    public init(title: String?, actionStyle: CompatibleAlertActionStyle, handler: ((CompatibleAlertAction!) -> Void)!) {
        self.title = title
        self.actionStyle = actionStyle
        self.handler = handler
        self.enabled = true
    }
    
    /**
        Helper function to create an instance of CompatibleAlertAction with the type of Default.
    
        :param: title The title of the button.
        :param: handler The block to be called when the button is pressed.
    
        :returns: The created action.
    */
    class func defaultActionWithTitle(title: String?, handler: ((CompatibleAlertAction!) -> Void)!) -> CompatibleAlertAction {
        return CompatibleAlertAction(title: title, actionStyle: CompatibleAlertActionStyle.Default, handler: handler)
    }
    
    /**
        Helper function to create an instance of CompatibleAlertAction with the type of Cancel.
        
        :param: title The title of the button.
        :param: handler The block to be called when the button is pressed.
    
        :returns: The created action.
    */
    class func cancelActionWithTitle(title: String?, handler: ((CompatibleAlertAction!) -> Void)!) -> CompatibleAlertAction {
        return CompatibleAlertAction(title: title, actionStyle: CompatibleAlertActionStyle.Cancel, handler: handler)
    }
    
    /**
        Helper function to create an instance of CompatibleAlertAction with the type of Desctructive.
        
        :param: title The title of the button.
        :param: handler The block to be called when the button is pressed.
    
        :returns: The created action.
    */
    class func destructiveActionWithTItle(title: String?, handler: ((CompatibleAlertAction!) -> Void)!) -> CompatibleAlertAction {
        return CompatibleAlertAction(title: title, actionStyle: CompatibleAlertActionStyle.Destructive, handler: handler)
    }
}
