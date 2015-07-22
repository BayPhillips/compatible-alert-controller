//
//  ViewController.swift
//  BPCompatibleAlertControllerDemo
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var observerObject: NSObjectProtocol?
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Demo"
        
        let alertController = BPCompatibleAlertController(title: "Alert Title", message: "Alert Message", alertStyle: BPCompatibleAlertControllerStyle.Alert)
        alertController.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
        
        alertController.postActionHandlerCleanupFunction =  {
            if (observerObject != nil)
            {
                NSNotificationCenter.defaultCenter().removeObserver(observerObject!)
                observerObject = nil
            }
        }
        
        // Set releaseResourcesWhenAlertDismissed to false if you intend to re-use alertController to present the alert multiple times.
        // If you do so, you must remember to call alertController.releaseResources() when you are finished with the alertController.
        //alertController.releaseResourcesWhenAlertDismissed = false
        
        let defaultAction = BPCompatibleAlertAction.defaultActionWithTitle("Default", handler: { (action) in
            if let textField = alertController.textFieldAtIndex(0) {
                NSLog("%@", textField.text!)
            }
            if let textField = alertController.textFieldAtIndex(1) {
                NSLog("%@", textField.text!)
            }
        })
        defaultAction.enabled = false
        alertController.addAction(defaultAction)
        
        alertController.addAction(BPCompatibleAlertAction.cancelActionWithTitle("Cancel", handler: { (action) in
            NSLog("Hit cancel")
        }))
        
        alertController.addAction(BPCompatibleAlertAction.destructiveActionWithTItle("Destructive", handler: { (action) in
            NSLog("Hit destroy")
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Username"
            
            // when the user types in something enable the login
            // when the user types something enable the login
            observerObject = NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                defaultAction.enabled = textField.text != ""
            }
        })
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        alertController.presentFrom(self.navigationController, animated: true) { () in
            // Completion handler
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}