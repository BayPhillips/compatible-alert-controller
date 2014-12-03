//
//  ViewController.swift
//  CompatibleAlertControllerDemo
//
//  Created by Bay Phillips on 12/1/14.
//  Copyright (c) 2014 Relationship Science LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var alertController: CompatibleAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Demo"
        
        // Initialize 
        alertController = CompatibleAlertController(title: "Alert Title", message: "Alert Message", alertStyle: CompatibleAlertControllerStyle.Alert)
        
        var hi = CompatibleAlertAction.
        alertController?.addAction(CompatibleAlertAction.defaultActionWithTitle("Default", handler: { (action) -> Void in
            // Do something here
        }))
        alertController?.addAction(CompatibleAlertAction.cancelActionWithTitle("Cancel", handler: { (action) -> Void in
            // Do something here
        }))
        alertController?.addAction(CompatibleAlertAction.destructiveActionWithTItle("Desctructive", handler: { (action) -> Void in
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