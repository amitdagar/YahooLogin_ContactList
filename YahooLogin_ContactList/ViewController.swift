//
//  ViewController.swift
//  YahooLogin_ContactList
//
//  Created by Abhishek Gupta on 01/06/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PBSocialDelegate {

    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Mark:- Button Action
    @IBAction func btnYahooClick(_ sender: Any) {
        pbSocialDelegate = self
        Yahoo.instance.webView = self.webview
        Yahoo.instance.createYahooSession()
        
        
    }
    func getYahooContacts(userData: [AnyHashable : Any]) {
      print("Your response  \(userData)")
    }
}

