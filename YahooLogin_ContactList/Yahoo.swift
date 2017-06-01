//
//  Yahoo.swift
//  MyAssignmentHelp
//
//  Created by Abhishek Gupta on 01/06/17.
//  Copyright © 2017 Abhishek Gupta. All rights reserved.
//

import UIKit

class Yahoo: NSObject,UIWebViewDelegate,YOSRequestDelegate {

    var session: YahooSession!
    var newRequestToken: YOSRequestToken?
    var webView:UIWebView!
    static let instance = Yahoo()
    //Mark:- Present Webview
    func presentWebViewForYahoo(withAuthURL url: URL) {
        
        self.webView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, delay: 0, options: .transitionFlipFromTop, animations: {() -> Void in
                // animate it to the identity transform (100% scale)gweg
                self.webView.transform = CGAffineTransform.identity
                self.webView.isHidden = false
                self.webView.delegate = self
                //so that we can observe the url for verifier
                self.webView.loadRequest(URLRequest(url: url))
                
                
                
            }, completion: {(finished: Bool) -> Void in
                // if you want to do something once the animation finishes, put it here
            })
            

        }
        
    }
    func createYahooSession() {
        // Create session with consumer key, secret and application id
        // Set up a new app here: https://developer.yahoo.com/dashboard/createKey.html
        // The default values here won't work
        //        YahooSession(consumerKey: "dj0yJmk9R1N5VUpMb3ZNQm1RJmQ9WVdrOVUybGxTazFsTnpRbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1mOA--", andConsumerSecret: "081c033eabfed58ddc2afcdf04a96667e66dd355", andApplicationId: "SieJMe74", andCallbackUrl: "http://mickey.io", andDelegate: self)
        
        session = YahooSession(consumerKey: "YOUR_CONSUMER_KEY", andConsumerSecret: "YOUR_SECRET_KEY", andCallbackUrl: "YOUR_CALLBACK_URL", andDelegate: self)
        
        let hasSession: Bool = (session?.resumeSession())!
        print("has yahoo session \(hasSession)")
        if !hasSession {
            // Not logged-in, send login and authorization pages to user
            //session.sendUserToAuthorization()
            // self.session.save()
            fetchSession()
        }
        else {
            // Logged-in, send requests
            print("Session detected!")
            sendUserContactsRequest()
  
        }
    }
    
    //Mark:- Get User contacts
    func sendUserContactsRequest() {
        // Initialize contact list request
        DispatchQueue.global(qos: .background).async {
            
            // do things which can run in background
            // calculations-delay-waiting for a response etc.
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                // implement UI related part which has to run in main thread.
                if(self.session != nil){
                    let request = YOSUserRequest(session: self.session)
                    // Fetch the user's contact list
                    
                    request?.fetchContacts(withStart: 0, andCount: 300, withDelegate: self)
                    
                }
                
            })
        }
        
    }
    
    //Mark;- Fetch User session
    func fetchSession() {
        // create a new YOSAuthRequest used to fetch OAuth tokens.
        let tokenAuthRequest =  YOSAuthRequest(session: self.session)
        // fetch a new request token from oauth.fetchToken(withCallbackUrl: "http://localhost")
        let  newRequestToken = tokenAuthRequest?.fetchToken(withCallbackUrl: "https://myassignmenthelp.com")
        // if it looks like we have a valid request token
        if (newRequestToken != nil) && ((newRequestToken?.key) != nil) && ((newRequestToken?.secret) != nil) {
            // store the request token for later use
            self.session.requestToken = newRequestToken
            self.session.save()
            // create an authorization URL for the request token
            let authorizationUrl: URL? = tokenAuthRequest?.authUrl(for: self.session.requestToken)
            
            presentWebViewForYahoo(withAuthURL: authorizationUrl!)
            //present it in webview
        }
        else {
            // NSLog(@"error fetching request token. check your consumer key and secret.");
        }
    }
    
    //Mark:- Webview Delegate function
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestString: String = request.url!.absoluteString
        
        if (requestString as NSString).range(of: "https://myassignmenthelp.com").length > 0 {
            var verifierRange: NSRange = (requestString as NSString).range(of: "oauth_verifier=")
            if verifierRange.length > 0 {
                verifierRange.location = verifierRange.location + verifierRange.length
                verifierRange.length = (requestString.characters.count ) - verifierRange.location
                print("Verifier => \(requestString as NSString).substring(with: verifierRange)")
                self.session.requestToken.verifier = (requestString as NSString).substring(with: verifierRange)
                self.session.save()
                createYahooSession()
//                   DispatchQueue.main.async {
//                    self.webView.isHidden = true
//                }
            }
            return false
        }
        else {
            return true
        }
        
        
    }

    
    //Mark:- YOSRequestDelegate function
    func requestDidFinishLoading(_ result: YOSResponseData!) {
        let json: [AnyHashable: Any] = result.responseJSONDict
        if(pbSocialDelegate != nil){
            pbSocialDelegate.getYahooContacts!(userData: json)
        }
        // Profile fetched
       // let jsons = JSON(data: result.data)
        print("Yahoooooo profile \(json)")
        
        // Contacts fetched
        
        //        let contactDict: [AnyHashable: Any] = json["contacts"] as! [AnyHashable : Any]
        //        if !contactDict.isEmpty {
        //            print("Contact list fetched")
        //            let contactList: [Any] = YOSUserRequest.parseContactList(contactDict)
        //            var parsedContactList: [Any] = YOSUserRequest.parseContactList(forNameOnly: contactList)
        //          //  contactViewController.loadContactList(parsedContactList)
        //        }
        //        // YQL query response fetched
        //        var yqlDict: [AnyHashable: Any] = json["query"] as! [AnyHashable : Any]
        //        if !yqlDict.isEmpty {
        //            let yqlResults: [AnyHashable: Any] = yqlDict["results"] as! [AnyHashable : Any]
        //            print("\(yqlResults)")
        //        }
        
    }

}
