# Watch Screenshot Magic

Quickly generates perfect Apple Watch screenshots.

Drag and drop a screenshot from the 42mm simulator (⌘S) and choose the correct type.

<img src="screenshot.png" alt="Screenshot" width=450>

__Note:__ This project uses Swift 2.0. In order to compile you must use Xcode 7.0 or newer. 

## Watch App

* Removes charging indicator from status bar
* Changes clock to read "10:09"

<img src="app-before-after.png" alt="Watch App" width=322>

## Glances

* Overlays on blurred watch face
* Adds page indicator

<img src="glance-before-after.png" alt="Glance" width=322>

<sub>__Note:__ Since Apple strongly recommends glances use a black background, a color mask on black content is used to overlay the glance screenshot on the blurred watch face. This means any black content will be treated as transparent. For the majority of users this should not be a problem, but if you have black content you'll need to manually correct your image after using this tool.</sub>

## Notifications

* Overlays on blurred watch face
* Changes clock to read "10:09"

<img src="notification-before-after.png" alt="Notification" width=322>

<sub>__Note:__ The method used to overlay notifications on a blurred watch face is not entirely accurate. Notification content is recommended to be displayed on on white background with 14% opacity. Due to the limited nature of the simulator, the screenshot can only be captured on a black background which prevents this effect from working correctly. In order to best simulate the effect with the available screenshots, the screenshot is composited with the watch face using a screen blend mode. This allows the watch face to display through the gray regions of the notification.</sub>

## Contact

Follow Imperiopolis on Twitter ([@Imperiopolis](https://twitter.com/Imperiopolis))

## License

Released under the MIT license. See LICENSE for details.

