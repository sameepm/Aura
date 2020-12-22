//
//  FacebookFriendsViewController.swift
//  Aura
//
//  Created by Apple on 29/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class FacebookFriendsViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        let params=["link":"http://www.eatbyapp.com/", "message":"Convert your kitchen to smart kitchen "]
        
        
//        FBSDKGraphRequestConnection.startWithGraphPath("/me/feed", parameters:params, HTTPMethod: "POST", completionHandler: { (connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
//            if error != nil {
//                println("Request to share link / An error occurred: \(error.localizedDescription)")
//                println(error)
//                //handle error
//            }else{
//                println("link successfully posted: \(result)")
//            }
//        })
        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: params).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                   
                    
                }
            })
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
