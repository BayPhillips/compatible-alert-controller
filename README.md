#BPCompatibleAlertController ![Travis CI Build](https://api.travis-ci.org/BayPhillips/compatible-alert-controller.svg)
iOS 8 included the new UIAlertController which is a much needed upgrade upon the UIAlertView; however, if you're still supporting iOS 7, like most of us are, then you still need to use UIAlertViews.

`BPCompatibleAlertController` does its best to emulate the UIAlertController implementation while supporting both iOS 7 and 8.

##How to Use##
Code samples are provided in the demo project, but if you're familiar with the UIAlertController, then you'll find this easy:

###Intialize the `BPCompatibleAlertController`:###
```
alertController = BPCompatibleAlertController(title: "My Title", message: "My Message", alertStyle: BPCompatibleAlertControllerStyle.Alert)
```

###Start adding actions/buttons to your controller:###
```
alertController.addAction(BPCompatibleAlertAction.defaultActionWithTitle("Default", handler: { (action) in
  // Do whatever callback you want in here
}))
```
If you want to specify another type of button, you can simply use the other two class functions: `BPCompatibleAlertAction.cancelActionWithTitle` and `BPCompatibleAlertAction.destructiveActionWithTitle`.

###Add any UITextFields:###
```
alertController.addTextFieldWithConfigurationHandler({ (textField) in
    textField.placeholder = "Username"
})
```
To support the different types of textFields in iOS7, just set the `UIAlertViewStyle` on the `BPCompatibleAlertController` to whichever you'd like, **so long as it matches the number of textFields you're adding.**
```
UIAlertViewStyle.Default = 0 textFields
UIAlertViewStyle.PlainTextInput or SecureTextInput = 1 textField
UIAlertViewStyle.LoginAndPasswordInpnut = 2 textFields
```

###Present the alert controller:###
```
alertController.presentFrom(viewController, animated: true) { () in
  // Completion handler once everything is dismissed
}
```

##To Do##
1. You need to retain the `BPCompatibleAlertController` in iOS 7 otherwise when selecting a button from the `UIAlertView` you'll get an exception.
2. Tests!
3. Probably a lot more! PR's are welcome.

##License##
`BPCompatibleAlertController` is licensed under the MIT License. See LICENSE for details.
