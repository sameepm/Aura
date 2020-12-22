//
//  LoginViewController.swift
//  Aura
//
//  Created by necixy on 05/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

 let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let welcomeVC : WellComePageViewController = WellComePageViewController(nibName : "WellComePageViewController" , bundle : nil)
class LoginViewController: UIViewController,UITextFieldDelegate, FBSDKLoginButtonDelegate , FBSDKAppInviteDialogDelegate {
    
    @IBOutlet weak var fbBtn: FBSDKLoginButton!
    @IBOutlet weak var txtEmail: UITextField!
     var dict: NSMutableDictionary?
    var email : NSString!
    @IBOutlet weak var scrlView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var txtPwd: UITextField!
    var appDelegate : AppDelegate!
   

    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(UIScreen .mainScreen().bounds.size.height<568)
        {
            scrlView.contentSize=CGSizeMake(320, 516)
        }

              
        super.viewDidLoad()
       
        fbBtn.delegate = self
        
  //----- Facebook Button
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
             fbBtn.readPermissions = ["public_profile", "email", "user_friends"]
            
               }
        else
        {
//            fbBtn.readPermissions = ["public_profile", "email", "user_friends"]
//            fbBtn.delegate = self

        }
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
       
        self.navigationController?.navigationBarHidden=true
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden=false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionOnEmailButton(sender: AnyObject)
    {
        if txtEmail.text!.isEmpty
        {
            globalAlertView("Please enter email", viewCont: self);
        }
        else if !self.emailAvailability(txtEmail.text!)
        {
            globalAlertView("Please enter a valid email.", viewCont: self);
        }
            
        else if txtPwd.text!.isEmpty
        {
            globalAlertView("Please enter password.", viewCont: self);
        }
        else
        {
            let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
            if isInternet == false
            {
              
                globalAlertView("Please check your internet connection", viewCont: self)
            }
            else
            {
            txtEmail .resignFirstResponder()
            txtPwd.resignFirstResponder()
                if appDelegate.device_id == nil{
                    globalAlertView("Please try again later!", viewCont: self)
                }
                else
                {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            dict = [
                
                "email": txtEmail.text!,
                "password" : txtPwd.text!,
                "type" : "1",
                "object_id" : appDelegate.device_id
            ]
            
         do
         {
            let data = try NSJSONSerialization.dataWithJSONObject(dict!, options: NSJSONWritingOptions.PrettyPrinted)
            
            
                let json = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let json = json {
                    var request : ASIFormDataRequest?
                    let strUrl : NSString = "http://api.aura-app.me/login/user"
                    
                    let searchURL : NSURL = NSURL(string: strUrl as String)!
                    
                    
                    request = ASIFormDataRequest(URL:searchURL as NSURL)
                    request?.delegate=self
                    
                    request?.setPostValue(json, forKey: "data")
                    request?.startAsynchronous()
                    
                    
                    //println(json)
                }
           
            }
                catch
                {
                    print(error)
                }
            }
            }
        }
    }
  
    @IBAction func onForgotPassword(sender: AnyObject) {
        let forgotVC : ForgotPwdViewController = ForgotPwdViewController(nibName : "ForgotPwdViewController" , bundle : nil)
        self.presentViewController(forgotVC, animated: true, completion: nil)

    }
    @IBAction func actionOnFacebookButton(sender: AnyObject)
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
           
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {//"public_profile",
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"],  fromViewController:self , handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                 
                }
            }
        })
        }
        
    }
    
    func getFBUserData()
    {
//        var request = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
//        
//        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//            if error == nil {
//                println("Friends are : \(result)")
//            } else {
//                println("Error Getting Friends \(error)");
//            }
//        }
        
       
                        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
//                    var fisrtName: AnyObject? = result.objectForKey("first_name")
                    let tempDic : NSMutableDictionary = result as! NSMutableDictionary
                    self.loginWithFacebook(tempDic)
                   
                }
            })
        }
    }

    func loginWithFacebook (tempDict : NSDictionary)
    {
//        var fisrtName = tempDict.objectForKey("first_name") as! NSString
//         var lastName = tempDict.objectForKey("last_name") as! NSString
        let pictDict = tempDict.objectForKey("picture") as! NSDictionary
         let pictDict2 = pictDict.objectForKey("data") as! NSDictionary
        
        let id = tempDict.objectForKey("id") as! NSString
    
        if !(tempDict.objectForKey("email")  == nil)
        {
           email = tempDict.objectForKey("email") as! NSString
        }
        else
        
        {
            email = id
        }

        dict = [
            
            "email":  email,
            "f_name" : tempDict.objectForKey("first_name") as! NSString,
            "l_name" : tempDict.objectForKey("last_name") as! NSString,
            "image" : pictDict2.objectForKey("url") as! NSString,
            "type" : "2",
            "object_id" : appDelegate.device_id
        ]
        
            do
        {
        let data = try NSJSONSerialization.dataWithJSONObject(dict!, options: NSJSONWritingOptions.PrettyPrinted)
        
       
            let json = NSString(data: data, encoding: NSUTF8StringEncoding)
            if let json = json {
                var request : ASIFormDataRequest?
                let strUrl : NSString = "http://api.aura-app.me/login/user"
//                 let strUrl : NSString = NSString (format:"%@login/user",self.basicUrl())
                let searchURL : NSURL = NSURL(string: strUrl as String)!
                
                
                request = ASIFormDataRequest(URL:searchURL as NSURL)
                request?.delegate=self
                
                request?.setPostValue(json, forKey: "data")
                request?.startAsynchronous()
                
                
                print(json)
            }
       
        }
        catch
        {
            print(error)
        }
        
    }

 
    //MARK: Facebook Delegate Methods

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        if ((error) != nil)
        {
             MBProgressHUD.hideHUDForView(self.view, animated: true)
            // Process error
        }
        else if result.isCancelled {
             MBProgressHUD.hideHUDForView(self.view, animated: true)
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
          
            self.getFBUserData()
          
           FBSDKAccessToken.setCurrentAccessToken(nil)
           FBSDKProfile.setCurrentProfile(nil)
           NSURLCache.sharedURLCache().removeAllCachedResponses()
           NSURLCache.sharedURLCache().diskCapacity = 0
           NSURLCache.sharedURLCache().memoryCapacity = 0
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("User Logged Out")
    }
    @IBAction func onJoinNowForFree(sender: AnyObject) {

        
        let signUpVC : SignUpViewController = SignUpViewController(nibName : "SignUpViewController" , bundle : nil)
        self.navigationController?.pushViewController(signUpVC, animated: true);
    }
    
//----- AppInvite
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
       NSLog("Result = %@", results)
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }
 
       // MARK: - Asihttp Delegate
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
       // let response = request.responseString()
       // print(response)
        do
        {
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
        
        if let aStatus = jsonObject as? NSDictionary{
            let statusCode = aStatus.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                let userId = aStatus.objectForKey("id") as? Double
                if (userId == 0)
                {
                    globalAlertView("Email already exist.", viewCont: self)
                }
                else
                {
                    
                    dict = aStatus.objectForKey("details") as? NSMutableDictionary;
                    if dict  != nil
                    {
                    if dict!.objectForKey("type") as? NSString == "2"
                    {
                          dict!["password"] = ""
                    }
                    else
                    {
                         dict!["password"] = txtPwd.text
                    }
                    let personEncodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(dict!)
                                      NSUserDefaults.standardUserDefaults().setObject(personEncodedObject, forKey: "userInfo");
                    NSUserDefaults.standardUserDefaults().setObject(dict!.objectForKey("id"), forKey: "userId")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                        var scoreHpns: String? = aStatus.objectForKey("score") as? String
                        if scoreHpns == nil
                        {
                            scoreHpns = "11"
                        }
                        userDefault.setObject(scoreHpns, forKey: "happinesScore")
                    userDefault.synchronize()
                        appDelegate.sliderMenuController()
                       
                    
                }
                    else
                    {
                         globalAlertView("Email or password is wrong.", viewCont: self)
                    }
                }
                
                
            }
            else
            {
                 globalAlertView("Email or password is wrong.", viewCont: self)
            }
            
        }
        }
        catch
        {
            print(error)
        }
        
        
    }
    
    func requestFailed( req : ASIHTTPRequest ){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
        print(req.error)
    }
   
    func emailAvailability (strinEmail : NSString)->Bool
    {
        let stricterFilter : Bool?=true
        let stricterFilterString : NSString? = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString : NSString? = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex : NSString? = (stricterFilter != nil) ? stricterFilterString :laxString
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@",  emailRegex!)
        
        return emailTest .evaluateWithObject(strinEmail)
    }
   
    
    //----
    
    
    // MARK: - TextFiled Delegate Methode
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtEmail .resignFirstResponder()
        txtPwd.resignFirstResponder()
        return true;
        
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
