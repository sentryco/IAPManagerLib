# IAPManagerLib

> Lightweight In-App-Purchase library

### Features:
- Straightforward `server-less` subscription management
- Simple callbacks to get operations done
- Local and server validation of receipts

### Description:
- By validating receipt locally we don't have to make a server that handles validation (doesn't always require network)
- We use apple StoreKit API calls to make purchases etc (requires network)
- By using the server-less receipt validation and handeling purchase calls directly with apple we can avoid using RevenueCat (very expensive) and rather manage our subscriptions for free

### Known drawbacks:
- Validating receipt locally is not resistant to user changing the clock (some piracy cant be avoided, the effort to guard against the problem has to justify the magnitude / severity of the problem etc)
- Still has to use StoreKit API to get meta info about products
- Works best with `nonConsumable` purchases, `autoRenewable` purchases will sometimes require re-downloading the receipt via `refresh` call to storekit to verify if they are within expiary date etc
- IAP engineering is very complex 😅

### IAP types:
- `nonConsumable`: Type that customers purchase once. They don't expire.
- `consumable`: Type that are depleted after one use. Customers can purchase them multiple times.
- `nonRenewingSubscription`: Type that customers purchase once and that renew automatically on a recurring basis until customers decide to cancel.
- `autoRenewableSubscription`: Type that customers purchase and it provides access over a limited duration and don't renew automatically. Customers can purchase them again.

### Example code:
```swift
/// Initialize receipt
let receipt = try! Receipt.localReceipt()
receipt.hasPurchases // has purchases
receipt.autoRenewablePurchases  // All auto renewable `Purchase`s,
receipt.activeAutoRenewableSubscriptionPurchases // all ACTIVE auto renewable `Purchase`s,
```

### Gotchas:
- There is only one receipt that includes all purchases. This receipt can fetched from appstore and be stored locally. You can also init a receipt without purchases.
- We can call apples `verifyReceipt` from the app. Even if apples say we should not because of MITM attack etc. Until we add our own server and or local validity check, we can use apples `verifyReceipt` to get things working. then invest more time to make things harder to circumvent not having to pay for the product etc. If you don't want to bother implementing DRM, don't bother with local verification. Just POST the receipt directly to Apple from your app, and they'll send it back to you again in an easily parsed JSON format. It's trivial for pirates to crack this, but if you're just transitioning to freemium and don't care about piracy, it's just a few lines of very easy code  – Dan Fabulich
- Without the intermediate server, the `shared secret` will have to be in the app somewhere to communicate directly with Apple's receipt server.
- You need a copy of Apple's Root Certificate included in your application bundle for local receipt validation to succeed
- ⭐ In Xcode 12, Apple introduced a new In-App purchases environment called Xcode and StoreKit configuration files. By adding such a configuration `File > New > File … > StoreKit Configuration File` you can now test In-App purchases both in a simulator and physical device without resorting to workarounds like specifying purchases status via the environment variable. What’s also great with StoreKit testing is that not only your code is called in exactly the same way as in the production environment, but you also see a production-like purchasing dialogs. With a new `Transactions-Manager`, you can easily remove purchases from the receipt and simulate edge cases like interrupted or deferred purchases.
- When a user downloads app from the `App-Store`, `App-Store` will generate an app receipt and bundle it with the app.
- A receipt is issued each time an installation or an update occurs. When an application is updated, a receipt that matches the new version of the application is issued.
- A receipt is issued each time a transaction occurs: When an in-app purchase occurs, a receipt is issued so that it can be accessed to verify that purchase.
- When previous transactions are restored, a receipt is issued so that it can be accessed to verify those purchases.
- Be sure your code uses the correct certificate in all environments. Add the following conditional compilation block to your receipt validation code to select the test certificate for testing, and the Apple root certificate
- Important: Receipts you produce in the test environment aren’t signed by the `App-Store` and aren’t valid for apps in production.
- ⭐ To distribute your apps together as a universal purchase, your apps need to use a single `bundle-ID` and be associated with the same `app-record` in App-store-Connect. You can create a new app record to use for all platform versions of your app or add new platform versions to an existing app record. https://help.apple.com/app-store-connect/#/dev2cd126805  and https://help.apple.com/app-store-connect/#/dev4df155cc4 and bundle id: https://help.apple.com/xcode/mac/11.4/#/deve70ea917b Your app will be available as a universal purchase after at least two platform versions are approved by `App-Review`. iPhone and iPad. To offer your app on iPhone and iPad, your app simply needs to support both devices.
- ⭐⭐ Super important: Multiple App Records. If your app is currently available on multiple platforms through separate app records, please note that app records can’t be merged. To offer universal purchase, remove all but one version from sale and add the other versions to the remaining app’s record. Once an app is removed from sale, it's original product page on the App Store becomes unavailable and you are no longer able to provide updates to existing users. Ratings and reviews are not transferred to the new product page.
- StoreKit2: The receipt is a SQLite database `receipts.db`
- If the app is live in the app store, a receipt will be in place the moment you download the app even if its free

### Hickups:
- ⚠️️⚠️️⚠️️⚠️️⚠️️⚠️️ When testing StoreKit in MacOS the local receipt may randomly not be created for unknown reasons. A tip can be make sure products are prefixed with `app-bundle-id`, make a purchase and check that it arrived in the transaction manager, then 👉 restart the computer 👈. Now your local receipt should be generated.
- When we build the app using Xcode or download it using TestFlight, usually the receipt is not included, and the `localReceipt()` method will throw an error saying receipt not found. We can manually request a receipt from the sandbox App Store by calling the StoreKit function `SKReceiptRefreshRequest.start()` . TPInAppReceipt library also provides a wrapper around this function, we can call `InAppReceipt.refresh` to retrieve or refresh the receipt file

### Resources:
- Read more about validating receipt locally: https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device
- Instead of validating offline / online. A middleground solution is to use keychain to just register purchased products: https://fluffy.es/check-purchased-iap-using-keychain/ discussing keychain vs userdefault vs local verification: https://rdovhaliuk.medium.com/implementing-in-app-purchases-without-keychain-and-userdefaults-52a43c0f76e8
- Video tut on validating receipt locally: https://www.raywenderlich.com/23523765-local-receipt-validation-in-ios
- Video tut on Remote validity check: https://www.pluralsight.com/courses/implementing-in-app-purchases-ios
- Walkthrough of receipt logic +  some util code: https://betterprogramming.pub/how-to-validate-ios-in-app-purchase-receipts-locally-ce57ba752cae
- Basic IAPManager using rx: https://gist.github.com/RenGate/261dd84a02b0a17e18aaa69254923355
- ⭐ Tutorial for the `TPInAppReceipt` github lib: https://fluffy.es/in-app-purchase-receipt-local/
- ⭐ `IAPManager` that uses `TPINAppReceipt`: https://gist.github.com/cupnoodle/63daf45c06aad525f81ddd195cb699fb
- ⭐ Nice little server call to apple to verify receipt: https://stackoverflow.com/a/44427094/5389500
- ⭐ RayWenderlich tutorial on local receipt validation: https://www.raywenderlich.com/9257-in-app-purchases-receipt-validation-tutorial#toc-anchor-009
- ⭐ Great simple gist that uses `Kvitto` and simple StoreKit API: https://gist.github.com/RenGate/261dd84a02b0a17e18aaa69254923355 and tutorial https://rdovhaliuk.medium.com/implementing-in-app-purchases-without-keychain-and-userdefaults-52a43c0f76e8
- Very gd instructions: https://github.com/russell-archer/IAPDemo also has some testing code

### Testing IAP
- Workflow for configuring in-app purchases https://help.apple.com/app-store-connect/#/devb57be10e7
- Create a Sandbox Apple ID: https://help.apple.com/app-store-connect/#/dev8b997bee1
- Sandbox IAP testing: https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox
- Test in-app purchases https://help.apple.com/app-store-connect/#/dev7e89e149d
- Test ask to buy by selecting StoreKit config file and clicking editor -> enable ask to buy etc

### Storekit github libraries:
- ⭐ https://github.com/benjaminmayo/merchantkit (advance, extremly complex, has comments, has localReceipt validator)
- ⭐⭐ https://github.com/atjason/IAPHelper (sleek, all you need to get going)
- https://github.com/jinSasaki/InAppPurchase (big and messy, not readable)
- https://github.com/bizz84/SwiftyStoreKit (pretty good, a bit spagethi code wise)
- https://github.com/sandorgyulai/InAppFramework (needs refactor, but has basics)
- https://github.com/suraphanL/SwiftInAppPurchase (big and has remote receipt validator)

### Other links:
- Randomnize the receipt for added security: http://receigen.etiemble.com/
- Local receipt verification lib + tut: https://github.com/andrewcbancroft/SwiftyLocalReceiptValidator and https://www.andrewcbancroft.com/2017/08/01/local-receipt-validation-swift-start-finish/
- ⭐⭐ TPInAppReceipt receipt validator: https://github.com/tikhop/TPInAppReceipt
- ⭐ Kvitto receipt validator: https://github.com/Cocoanetics/Kvitto (75$)
- ⭐ Nice basic IAPManager gist: https://gist.github.com/cupnoodle/63daf45c06aad525f81ddd195cb699fb
- Lib for local receipt validity check: https://github.com/andrewcbancroft/SwiftyLocalReceiptValidator
- Remote receipt validator for heroku: https://github.com/fluffyes/ReceiptCheckerServer
- Sick overview of receipt validation: https://www.objc.io/issues/17-security/receipt-validation/
- The most comprehsnive into to IAP subscriptions from apple: https://developer.apple.com/app-store/subscriptions/

### Local validation:
Debug App on Device
1 – Run your app from Xcode on the device you’ve just set up.
2 – Executing code, such as a request to refresh a receipt should prompt you for your newly created Sandbox Tester credentials.
3 – Enter the password for that Apple ID – you should receive a receipt!

### Steps to test In-app-purchase
- The steps bellow are necessary as Sandbox App Store won't issue a receipt if your app is not created in App Store Connect. After creating sandbox tester and app in App Store Connect, now we can proceed to refresh receipt :
- Since xcode 14 you can setup local or synced config file more info: https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode

**Sandbox testing**
1. Create a sandbox tester account in App Store Connect, head over to https://appstoreconnect.apple.com/access/testers and create one (not needed for local IAP testing)
2. Create an App ID created in Developer centre and App created in App Store connect, if you haven't already, head over to Apple developer center to create an App ID : (not needed for local IAP testing)
3. Create an App using the App ID you have created earlier. https://appstoreconnect.apple.com/ (not needed for local IAP testing)
4. Refreshing receipt in Simulator will result in failure, you will be prompted to login, login with your sandbox tester account credential. (not needed for local IAP testing)
5. After logging in, the app will download the receipt from sandbox App Store. (not needed for local IAP testing)
6. One of the step of receipt verification includes using Apple Root Certificate to check if the receipt is actually signed by Apple (using their own private key). To perform this step, we would first need to download Apple Root Certificate (the public key) from Apple website here : https://www.apple.com/certificateauthority/ . Select the certificate named "Apple Inc. Root Certificate". (not needed for local IAP testing) also this can be done via xcode menus etc
7. Once you have downloaded the certificate (AppleIncRootCertificate.cer file), add it into your project bundle, and check ' Copy items if needed' and select your app as target.

**Local IAP testing**
1. In xCode 12, Apple introduced a new In-App purchases environment called Xcode and StoreKit configuration files. By adding such a configuration (`File > New > File … > StoreKit Configuration File`) you can now test In-App purchases both in a simulator and physical device without resorting to workarounds like specifying purchases status via the environment variable. What’s also great with StoreKit testing is that not only your code is called in exactly the same way as in the production environment, but you also see a production-like purchasing dialogs. more info here: https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode
2. With a new XCode `Transactions Manager`, you can easily remove purchases from the receipt and simulate edge cases like interrupted or deferred purchases.
3. Enable Developer Mode to test your app on devices running iOS 16 and later, or watchOS 9 and later. For more information about how to enable Developer Mode, see https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
4. To enable StoreKit testing in Xcode, your project must have an active `StoreKit configuration file`. By default, StoreKit testing in Xcode is disabled. To select a configuration file and make it active: Click the scheme to open the Scheme menu and choose `Edit Scheme`. An Xcode project can contain multiple StoreKit configuration files, but only one can be active at a time. When it’s active, build and run your app as usual. Instead of accessing App Store Connect or the sandbox server, your app gets StoreKit data from the test environment. Remember to disable this after usage, to start using storekit from apple servers etc. I think
5. StoreKit testing in Xcode generates locally signed receipts that your app validates locally. Obtain the certificate you need for local validation and add it to your project as follows: In `Xcode Project navigator, click the `StoreKit configuration file`. From the Xcode menu, choose `Editor > Save Public Certificate. Select a location in your project to save the file.
6. Select your StoreKit configuration file in the Project navigator and choose Menu -> `Editor` to change the many different testing settings and custom testing calls etc
7. `Menu -> Debug -> StoreKit -> Transaction-manager` can be used to perform steps in an in-app purchase flow that normally occur outside your app, such as approving, declining, or refunding a transaction. To open the transaction manager, choose Debug > StoreKit > Manage Transactions.
8. Add the `in-app-purchase capability` from the signing and capabilites tab. (iOS only, actually macOS seems to have this as well 🤔)

### Todo:
- ✅ Create the basic IAPManager to get started with In app purchases in the app etc this one looks really sleek: `atjason/IAPHelper`
- ✅ Add `verifyReceipt` from server: (IAPMAnager) https://betterprogramming.pub/subscriptions-receipts-and-storekit-in-ios-14-16194eb93963
- ✅ Add local validation. (use TPInAppReceipt, SwiftyLocalReceiptValidator or Kvitto) better for offline (users can buy lifetime, and never have to assert apples server etc, for paranoids and people storing on offline devices that never go online etc)
- 🚫 (This is dep-recated) Add `NetworkActivityIndicatorManager.networkOperationStarted()` when interacting with server see https://github.com/bizz84/SwiftyStoreKit/blob/master/SwiftyStoreKit-iOS-Demo/
- ✅ Make sure the lib works with don't verify receipt before user has a purchase. https://github.com/bizz84/SwiftyStoreKit/issues/397
- 🚫 Rename to IAPStoreLib? or Bazar? or BazarKit? 👉 IAPManagerLib? 👈
- Try to cover these edge cases: https://github.com/bizz84/SwiftyStoreKit/issues?page=2&q=is%3Aissue+is%3Aopen
- 👉 Warn the user that the device will need to connect to internet before syncing more than 2 devices. If app is offline and receipt cant validate because expiration date. Inform the user that they can buy the lifetime product to avoid having to go online for validity check in the future. if this is important for the user etc.
- Add leeway graceperiod so that user dont feel interupted service if issue with payment etc. 30 days is gd. apple use: They use 6 days for weekly subscriptions, 16 days for
- Add support for: Promotional Offers and discounts
- Add support for Purchase.price is the normal price. And Purchase.subscriptionTerms.introductoryOffer to see introductory pricing.
- Add support for adding offer in the appstore produt page `SKPaymentTransactionObserver#paymentQueue(_:shouldAddStorePayment:for:)` https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/PromotingIn-AppPurchases/PromotingIn-AppPurchases.html#//apple_ref/doc/uid/TP40008267-CH11-SW1
- 👉 Make sure you call production url before sandbox url etc
- Create IAP manager with AlertBoxes etc. for mac and iOS to test how things work, to not clutter up main repo etc
- Migrate local validation to own remote server. (maybe in the future)
- StoreKit 2 has some new simpler API calls. add these. here are some: https://qonversion.io/blog/storekit-2-capabilities-deep-dive/
- Add graceperiod retryperiod etc: https://qonversion.io/blog/storekit-2-capabilities-deep-dive/
- Add request price increase consent. THis can be prompted from transaction manager in xcode by rightclicking a current active purchase etc
- ⚠️️⚠️️⚠️️ Storekit2 does automatic transaction ("receipt") verification ("validation") for you. So, no more using OpenSSL to decrypt and read App Store receipts or sending receipts to an Apple server for verification!
- ⚠️️⚠️️⚠️️ Note that the App Store cryptographically secures and signs each transaction using the industry-standard JSON Web Signature (JWS) format. The Transaction object provides access to the underling JWS as a String property, so you may perform your own validation if required (although this probably won't be necessary for most apps).
- Add request refund button
- Add support for Direct purchases of App Store Promotions in appstore listing etc
- Remove de-precated code etc
- Add architectural overview in the repo. Markdown structure map etc
- Seems like there are two sets of tests, remove one
