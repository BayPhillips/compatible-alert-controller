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
    public let title: String?
    public let actionStyle: CompatibleAlertActionStyle
    public let handler: ((CompatibleAlertAction!) -> Void)!
    public var enabled: Bool
    
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
    
    public init(title: String?, actionStyle: CompatibleAlertActionStyle, handler: ((CompatibleAlertAction!) -> Void)!) {
        self.title = title
        self.actionStyle = actionStyle
        self.handler = handler
        self.enabled = true
    }
    
    class func defaultActionWithTitle(title: String?, handler: ((CompatibleAlertAction!) -> Void)!) -> CompatibleAlertAction {
        return CompatibleAlertAction(title: title, actionStyle: CompatibleAlertActionStyle.Default, handler: handler)
    }
    
    class func cancelActionWithTitle(title: String?, handler: ((CompatibleAlertAction!) -> Void)!) -> CompatibleAlertAction {
        return CompatibleAlertAction(title: title, actionStyle: CompatibleAlertActionStyle.Cancel, handler: handler)
    }
    
    class func destructiveActionWithTItle(title: String?, handler: ((CompatibleAlertAction!) -> Void)!) -> CompatibleAlertAction {
        return CompatibleAlertAction(title: title, actionStyle: CompatibleAlertActionStyle.Destructive, handler: handler)
    }
}
