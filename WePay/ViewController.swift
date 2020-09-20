//
//  ViewController.swift
//  WePay
//
//  Created by Adila on 9/16/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn

class ViewController: UIViewController {
    var braintreeClient: BTAPIClient!
    var venmoDriver : BTVenmoDriver?
//    var venmoButton : UIButton?
//    var apiClient : BTAPIClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        braintreeClient = BTAPIClient(authorization: "sandbox_tv3zshkj_cc7s9nn7chsdgwmj")
        //delegate
    }
    
    //Drop-in UI Begin
    @IBAction func payBtn(_ sender: Any) {
        
    }
    
    @IBAction func payAction(_ sender: Any) {
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")

                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone

                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                print("Email: \(email)")
                print("Name: \(firstName) \(lastName)")
                print("Phone: \(phone)")
                print("Billing Address: \(billingAddress)")
                print("Shipping Address: \(shippingAddress)")
                
                
            } else if let error = error {
                // Handle error here...
                print("ERR: \(error)")
            } else {
                // Buyer canceled payment approval
                print("Buyer canceled payment approval")
            }
        }
    }
//    @IBAction func venmoAction(_ sender: Any) {
//        self.venmoDriver = BTVenmoDriver(apiClient: self.braintreeClient)
//        self.venmoDriver?.authorizeAccountAndVault(false, completion: { (venmoAccount, error) in
//                   guard let venmoAccount = venmoAccount else {
//                       print("Error: \(error)")
//                       return
//                   }
//                   // You got a Venmo nonce!
//                   print(venmoAccount.nonce)
//               })
//    }
    
}


extension ViewController : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ViewController : BTAppSwitchDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        showLoadingUI()
 
//        NotificationCenter.default.addObserver(self, selector: #selector(hideLoadingUI), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        hideLoadingUI()
    }

    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {

    }
    func showLoadingUI() {
        // ...
    }

    func hideLoadingUI() {
//        NotificationCenter
//            .default
//            .removeObserver(self, name: NSNotification.Name.UIApplication.didBecomeActiveNotification, object: nil)
        // ...
    }

}

