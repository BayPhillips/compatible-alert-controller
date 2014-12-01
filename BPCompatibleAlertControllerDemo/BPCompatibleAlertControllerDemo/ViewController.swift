//
//  ViewController.swift
//  BPCompatibleAlertControllerDemo
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Bay Phillips. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var alertController: BPCompatibleAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Demo"
        
        // Initialize 
        alertController = BPCompatibleAlertController(title: "Alert Title", message: "Alert Message", alertStyle: BPCompatibleAlertControllerStyle.Alert)
        
        alertController?.addAction(BPCompatibleAlertAction.defaultActionWithTitle("Default", handler: { (action) -> Void in
            // Do something here
        }))
        alertController?.addAction(BPCompatibleAlertAction.cancelActionWithTitle("Cancel", handler: { (action) -> Void in
            // Do something here
        }))
        alertController?.addAction(BPCompatibleAlertAction.destructiveActionWithTItle("Desctructive", handler: { (action) -> Void in
            // Do something here
        }))
        
        alertController?.presentFrom(self, animated: true) { () -> Void in
            // Completion handler
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}