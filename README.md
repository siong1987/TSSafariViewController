# TSSafariViewController

In iOS 9, Apple introduced `SFSafariViewController` which supports
native Safari features within the app.  But you have to present
`SFSafariViewController` modally in order to prevent the loss of default
bar behavior.

`TSSafariViewController` is created in order to prevent the above problem.
It supports all `SFSafariViewController` features but with proper
push/pop presenting animation.

## Installation

#### Cocoapods

Add the following line to your Podfile.

```
pod "TSSafariViewController", "~> 1.0"
```

## Usage

``` swift
let safariViewController = TSSafariViewController(URL: NSURL("https://google.com")!)
safariViewController.safariDelegate = self
self.presentViewController(safariViewController, animated:true, completion: nil)

// or
let safariViewController = TSSafariViewController(URL: NSURL("https://google.com")!, entersReaderIfAvailable: true)
safariViewController.safariDelegate = self
self.presentViewController(safariViewController, animated:true, completion: nil)

// safariDelegate methods
protocol TSSafariViewControllerDelegate {
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool)
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity]
    func safariViewControllerDidFinish(controller: SFSafariViewController)
}
```

For the reference on how to use the delegate methods, check out the [SFSafariViewControllerDelegate](https://developer.apple.com/library/prerelease/ios/documentation/SafariServices/Reference/SFSafariViewControllerDelegate/index.html#//apple_ref/swift/intf/c:objc(pl)SFSafariViewControllerDelegate).

## TODO

- [ ] Better push/pop animation with proper shadow animation (Opacity
  fades along with the view)

## References

- [Push / Pop modal SFSafariViewController](http://www.stringcode.co.uk/push-pop-modal-sfsafariviewcontroller-hacking-swipe-from-edge-gesture/)
- [SCSafariViewController GitHub](https://github.com/stringcode86/SCSafariViewController)
