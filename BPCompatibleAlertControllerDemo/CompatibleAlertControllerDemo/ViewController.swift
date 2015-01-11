//
//  ViewController.swift
//  BPCompatibleAlertControllerDemo
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var alertController: BPCompatibleAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Demo"
        
        alertController = BPCompatibleAlertController(title: "Alert Title", message: "Alert Message", alertStyle: BPCompatibleAlertControllerStyle.Alert)
        alertController?.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
        
        alertController?.addAction(BPCompatibleAlertAction.defaultActionWithTitle("Default", handler: { (action) in
            if let textField = self.alertController?.textFieldAtIndex(0) {
                NSLog("%@", textField.text!)
            }
            if let textField = self.alertController?.textFieldAtIndex(1) {
                NSLog("%@", textField.text!)
            }
        }))
        
        alertController?.addAction(BPCompatibleAlertAction.cancelActionWithTitle("Cancel", handler: { (action) in
            NSLog("Hit cancel")
        }))
        
        alertController?.addAction(BPCompatibleAlertAction.destructiveActionWithTItle("Desctructive", handler: { (action) in
            NSLog("Hit destroy")
        }))
        
        alertController?.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Username"
        })
        
        alertController?.addTextFieldWithConfigurationHandler({ (textField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        alertController?.presentFrom(self.navigationController, animated: true) { () in
            // Completion handler
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}