//
//  ViewController.swift
//  TinderWeek8
//
//  Created by Kunwardeep Gill on 2015-05-26.
//  Copyright (c) 2015 ProjectDGW. All rights reserved.
//

import UIKit
//d
class ViewController: UIViewController, FBSDKLoginButtonDelegate {
  var permissions = ["public_profile", "email", "user_friends"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    if (FBSDKAccessToken.currentAccessToken() != nil)
    {
      // User is already logged in, do work such as go to next view controller.
    }
    else
    {
      let loginView : FBSDKLoginButton = FBSDKLoginButton()
      self.view.addSubview(loginView)
      loginView.center = self.view.center
      loginView.readPermissions = ["public_profile", "email", "user_friends"]
      loginView.delegate = self
    }
  }
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    println("User Logged In")
    
    if ((error) != nil)
    {
      // Process error
    }
    else if result.isCancelled {
      // Handle cancellations
    }
    else {
      
      // Log In (create/update currentUser) with FBSDKAccessToken
      PFFacebookUtils.logInInBackgroundWithAccessToken(result.token, block: {
      (user: PFUser?, error: NSError?) -> Void in
      if user != nil {
      println("User logged in through Facebook!")
    } else {
      println("Uh oh. There was an error logging in.")
    }
  })
      if result.grantedPermissions.contains("email")
      {
        // Do work
      }
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    println("User Logged Out")
    PFUser.logOut()
  }
  
  func returnUserData()
  {
    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
      
      if ((error) != nil)
      {
        // Process error
        println("Error: \(error)")
      }
      else
      {
        println("fetched user: \(result)")
        let userName : NSString = result.valueForKey("name") as! NSString
        println("User Name is: \(userName)")
        let userEmail : NSString = result.valueForKey("email") as! NSString
        println("User Email is: \(userEmail)")
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

