#BPCompatibleAlertController
iOS 8 included the new UIAlertController which is a much needed upgrade upon the UIAlertView; however, if you're still supporting iOS 7, like most of us are, then you still need to use UIAlertViews.

`BPCompatibleAlertController` does its best to emulate the UIAlertController implementation while supporting both iOS 7 and 8.

##How to Use##
Code samples are provided in the demo project, but if you're familiar with the UIAlertController, then you'll find this easy:

First, intialize the `BPCompatibleAlertController`:
```
alertController = BPCompatibleAlertController(title: "My Title", message: "My Message", alertStyle: BPCompatibleAlertControllerStyle.Alert)
```

Start adding actions/buttons to your controller:
```
alertController.addAction(BPCompatibleAlertAction.defaultActionWithTitle("Default", handler: { (action) -> Void in
  // Do whatever callback you want in here
}))
```
If you want to specify another type of button, you can simply use the other two class functions: `BPCompatibleAlertAction.cancelActionWithTitle` and `BPCompatibleAlertAction.destructiveActionWithTitle`.

Then, when you're ready, present the alert controller. This is slightly different from UIAlertControllers but that's okay:
```
alertController.presentFrom(viewController, animated: true) { () -> Void in
  // Completion handler once everything is dismissed
}
```

##To Do##
1. `BPCompatibleAlertController` currently doesn't support the different types of UIAlertView styles (with various form inputs) but can easily be extended to do all of it.
2. You need to retain the `BPCompatibleAlertController` in iOS 7 otherwise when selecting a button from the `UIAlertView` you'll get an exception.
3. Probably a lot more! PR's are welcome.

##License##
`BPCompatibleAlertController` is licensed under the MIT License. See LICENSE for details.