//
//  ForgotPwdViewController.swift
//  Aura
//
//  Created by necixy on 15/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSubmit.layer.cornerRadius=3.0;
        btnSubmit.layer.masksToBounds=true;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSubmitButton(sender: AnyObject) {
        
            
         if txtEmail.text!.isEmpty
        {
            globalAlertView("Please enter email.", viewCont: self);
        }
       else  if !self.emailAvailability(txtEmail.text!)
        {
            globalAlertView("Please enter a valid email.", viewCont: self);
        }
        else
         {
            txtEmail .resignFirstResponder()
      let strUrl : NSString = NSString (format:"%@forgot_pwd",self.basicUrl())
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
            
            
            let txt = txtEmail.text! as NSString
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var request : ASIFormDataRequest?

        request = ASIFormDataRequest(URL:searchURL as NSURL)
        request?.delegate=self
        
        request?.setPostValue(txt, forKey: "email")
        request?.startAsynchronous()
        }

    }
    
    // MARK: - ASIHTTP  Delegate Methode
  
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
       // var response = request.responseString()
      
        do
        {
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
        
        if let aStatus = jsonObject as? NSDictionary{
            let statusCode = aStatus.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                let emailStatus : AnyObject = aStatus.objectForKey("email_status")!
               
                if emailStatus as! Int  == 1
                {
                    globalAlertView("Your password reset email has been sent.", viewCont: self)
                    
                    txtEmail.text="";
                }
                else  if emailStatus as! Int == 0
                {
                      globalAlertView("This email id does not exist.", viewCont: self)
                }
                else
                {
                     globalAlertView("This email id does not exist in our database.", viewCont: self)
                }
                
            }
            else
            {
                 globalAlertView("Something went wrong", viewCont: self)
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

    
    // MARK: - TextFiled Delegate Methode
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtEmail .resignFirstResponder()
       
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
