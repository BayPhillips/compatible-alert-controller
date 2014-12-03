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

@objc(BPCompatibleAlertAction)
public class BPCompatibleAlertAction {
    public let title: String?
    public let actionStyle: BPCompatibleAlertActionStyle
    public let handler: ((BPCompatibleAlertAction!) -> Void)!
    public var enabled: Bool
    
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
    
    public init(title: String?, actionStyle: BPCompatibleAlertActionStyle, handler: ((BPCompatibleAlertAction!) -> Void)!) {
        self.title = title
        self.actionStyle = actionStyle
        self.handler = handler
        self.enabled = true
    }
    
    class func defaultActionWithTitle(title: String?, handler: ((BPCompatibleAlertAction!) -> Void)!) -> BPCompatibleAlertAction {
        return BPCompatibleAlertAction(title: title, actionStyle: BPCompatibleAlertActionStyle.Default, handler: handler)
    }
    
    class func cancelActionWithTitle(title: String?, handler: ((BPCompatibleAlertAction!) -> Void)!) -> BPCompatibleAlertAction {
        return BPCompatibleAlertAction(title: title, actionStyle: BPCompatibleAlertActionStyle.Cancel, handler: handler)
    }
    
    class func destructiveActionWithTItle(title: String?, handler: ((BPCompatibleAlertAction!) -> Void)!) -> BPCompatibleAlertAction {
        return BPCompatibleAlertAction(title: title, actionStyle: BPCompatibleAlertActionStyle.Destructive, handler: handler)
    }
}
