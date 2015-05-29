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
  
  var xFromCenter:CGFloat = 0
  var frame:CGRect!

  @IBOutlet var profileImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var backgroundCardView: UIView!
  
  
  override func viewDidLoad() {
    frame = CGRectZero

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
  
  

  
  override func viewWillAppear(animated: Bool) {
    var query = PFUser.query()!
    query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]?, error:NSError?) -> Void in
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
    self.performSegueWithIdentifier("returnLogin", sender: nil)

//    presentViewController(ViewController(), animated: true, completion: nil)
  }
  
  @IBAction func cardSwipeGesture(sender: UIPanGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.Began {
      frame = sender.view?.frame
    }
    let translation = sender.translationInView(self.view)
    // get was has been dragged
    var profile = sender.view!
    xFromCenter += translation.x
    var scale = min( 100 / abs(xFromCenter), 1)
    profile.center = CGPoint(x: profile.center.x + translation.x, y: profile.center.y)
    // reset translation
    sender.setTranslation(CGPointZero, inView: self.view)
    //rotate label
    var rotation:CGAffineTransform = CGAffineTransformMakeRotation(translation.x / 200)
    // stretch the current view
    var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
    //imageView.transform = stretch
    // check if chosen or not chosen
    if profile.center.x <  100 {
      //println("not chose")
      // do nothing
      if profile.center.x <  20 {
        //println("swiped Left")
      }
    } else {
      //println("chosen")
      // Add to chosen list on parse
      if profile.center.x > 300 {
      }
    }
    if sender.state == UIGestureRecognizerState.Ended {
      
      
      
      // set the label back
      //            profile.center = CGPointMake(view.bounds.width / 2, view.bounds.height / 2)
      //            // undo scale
      //            scale = max(abs(xFromCenter) / 100, 1)
      //            // undo rotation and stretch
      //            rotation = CGAffineTransformMakeRotation(0)
      //            // stretch the current view
      //            stretch = CGAffineTransformScale(rotation, scale, scale)
      //            // set image to original size after scaling
      
      UIView.animateWithDuration(0.3, animations:
        { () -> Void in
          profile.frame = self.frame
        }, completion: {
          (success) -> Void in
      })
      
      
    }
    // TODO: load next image
    
  }
  
}



