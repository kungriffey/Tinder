//
//  SwipeViewController.swift
//  TinderWeek8
//
//  Created by Kunwardeep Gill on 2015-05-27.
//  Copyright (c) 2015 ProjectDGW. All rights reserved.
//

import Foundation
import UIKit

class SwipeViewController : UIViewController, FBSDKLoginButtonDelegate{
  
  var listOfMatch = []

  override func viewDidLoad() {

  
    let fbLoginButton : FBSDKLoginButton = FBSDKLoginButton()
    self.view.addSubview(fbLoginButton)
    self.view.bringSubviewToFront(fbLoginButton)
    fbLoginButton.center = CGPoint(x: view.center.x, y: view.frame.size.height - view.frame.size.height / 8)
    fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
    fbLoginButton.delegate = self
  
    PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
      //display the coordinates
      println(geopoint)
    }
    
  }
  
  
  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  override func viewWillAppear(animated: Bool) {
    var query = PFUser.query()!
    //query.selectKeys(["photoURL","name", "email"])
    //println(query)
    query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
//      println("objects: \( objects)")
      if let result = objects {
        for object in result {
          
          if let user = object as? PFUser {
            
            if let url = user["photoURL"] as? String{
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                if let data = NSData(contentsOfURL: NSURL(string: url)!){
                  dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: data)
                    self.profileImageView.image = image
                  })
                }
              })
            }
            //  Check for Name
            if let name = user["name"] as? String{
              self.fullNameLabel.text = name
            }
            
            // Check for Email
            if let email = user["email"] as? String{
              self.emailLabel.text = email
            }
          }
        }
      }
    }
  }
  
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {}
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    PFUser.logOut()
    presentViewController(ViewController(), animated: true, completion: nil)
  }
  
  
}



