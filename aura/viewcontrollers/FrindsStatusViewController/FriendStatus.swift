//
//  FriendStatus.swift
//  Aura
//
//  Created by Apple on 16/11/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

@objc protocol FriendshipStatusDelegate{
    
    optional
    func selected( statusCode : String , userId : String , friendId : String  )
    func statusAfterSuccess( currentStatusCode : Int  )
   
    
    
    
    // optional func sendFriendshipStatus()
}

class FriendStatus: UIViewController {
    
    var friStatus : Int!
    var delegate:FriendshipStatusDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: --------------- Deleate Method
   func selected( statusCode : String , userId : String , friendId : String  )
   {
    let status = Int(statusCode)!
    friStatus = status
    let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
    if isInternet == false
    {
      //  globalAlertView("Please check your internet connection", viewCont: self)
         delegate!.statusAfterSuccess(98)
    }
    else
    {
        
     //   MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var request : ASIFormDataRequest?
        switch (status)
        {
            
        case 101 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),userId)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("101", forKey: "status")
            request?.setPostValue(friendId, forKey: "friend_id")
            
            break ;
            
            
            
        case 102 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),userId)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("102", forKey: "status")
            request?.setPostValue(friendId, forKey: "friend_id")
            
            break ;
            
               case 105 :
            let strUrl : NSString = NSString(format: "%@user/friend/change_status/%@",self.basicUrl(),userId)
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.setPostValue("105", forKey: "status")
            request?.setPostValue(friendId, forKey: "friend_id")
         
            break;
            
        default :
            break ;
        }
        
        request?.delegate=self
        request?.startAsynchronous()
    
    
    }
    }
    
    
    func requestFinished( request : ASIHTTPRequest ){
        
       
        let response = request.responseString()
        print(response)
        
        do {
            let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
            
            if let aStatus = jsonObject as? NSDictionary{
                let statusCode = aStatus.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    print("Success")
                    
                    let sendReq : Bool = (aStatus.objectForKey("success") as? Bool)!
                    if sendReq  == true
                    {
                        
                        switch (friStatus)
                        {
                            
                        case 101:
                         delegate!.statusAfterSuccess(friStatus)
                           
                            break;
                            
                        case 102 :
                            delegate!.statusAfterSuccess(friStatus)
                           
                            break ;
                      
                            
                        case 105 :
                            delegate!.statusAfterSuccess(100)
                            
                            break ;
                            
                            
                        default :
                            break;
                        }
                    }
                    
                   
                }
               
            }
        }
        catch
        {
            print(error)
             delegate!.statusAfterSuccess(98)
        }
        
        
    }
    
    func requestFailed( req : ASIHTTPRequest ){
         delegate!.statusAfterSuccess(98)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
        print(req.error)
    }

}
