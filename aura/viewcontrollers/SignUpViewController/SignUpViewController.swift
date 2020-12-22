//
//  SignUpViewController.swift
//  Aura
//
//  Created by necixy on 07/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit
import QuartzCore

class SignUpViewController: UIViewController , UITextFieldDelegate , ASIHTTPRequestDelegate , UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
     var dict: NSMutableDictionary?
    var alertController : UIAlertController!
    @IBOutlet weak var txtFirstName: UITextField!
    var txtField : UITextField!
    var userImage : UIImage?
    var productData : NSMutableData?
    @IBOutlet weak var txtConfirmPwd: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var scrlView: TPKeyboardAvoidingScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView : UIView = UIView()
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 220, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 220, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text="SIGN UP"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 20)
        headerView.addSubview(headerLbl)
        //-----Navigation Left Button
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
       
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
        btnImage.layer.cornerRadius=53;
        btnImage.layer.masksToBounds=true
        
        if(UIScreen .mainScreen().bounds.size.height<508)
        {
            scrlView.contentSize=CGSizeMake(320, 579)
        }
         let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.navigationBarHidden=true
    }
    override func viewWillDisappear(animated: Bool) {
      //  self.navigationController?.navigationBarHidden=false
    }
    
    @IBAction func onBackviewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)

    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func getImage(sender: AnyObject) {
        //---- Actionsheet
        let actionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Camera", "Gallery")
         actionSheet.showInView(self.view)
    }
// MARK: --------------- USER REGISTRATION
    
    @IBAction func signUpUser(sender: AnyObject) {
        
        
        if txtFirstName.text!.isEmpty
        {
            //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    //appDelegate.sliderMenuControllser()
            globalAlertView("Please enter first name.", viewCont: self);
        }
           
       
        else if txtLastName.text!.isEmpty
        {
            globalAlertView("Please enter last name", viewCont: self);
        }

        else if txtEmail.text!.isEmpty
        {
            globalAlertView("Please enter a valid email", viewCont: self);
        }
        else if !self.emailAvailability(txtEmail.text!)
        {
            globalAlertView("Please enter a valid email.", viewCont: self);
        }
            
        else if txtPassword.text!.isEmpty
        {
           
            globalAlertView("Please enter password.", viewCont: self);
        }
            
        else if txtPassword.text?.characters.count < 3 || txtPassword.text?.characters.count >= 16
        {
            globalAlertView("Password must be atleast min 3 character's and max 15 character's", viewCont: self);
        }

        else if txtConfirmPwd.text != txtPassword.text
        {
            globalAlertView("Confirm password does not match with password", viewCont: self);
        }
        else
        {
            
            txtFirstName.resignFirstResponder()
            txtLastName.resignFirstResponder()
            txtEmail.resignFirstResponder()
            txtPassword.resignFirstResponder()
            txtConfirmPwd.resignFirstResponder()
            
            let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
            if isInternet == false
            {
                
                globalAlertView("Please check your internet connection", viewCont: self)
            }
            
            else
            {
                if appDelegate.device_id == nil{
                globalAlertView("Please try again later!", viewCont: self)
                }
                else
                {
            MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
          
            dict = [
                "f_name": txtFirstName.text!,
                "l_name":txtLastName.text!,
                "email": txtEmail.text!,
                 "password" : txtPassword.text!,
                "type" : "1",
                  "object_id" : appDelegate.device_id
            ]
                do{
            let data = try NSJSONSerialization.dataWithJSONObject(dict!, options: NSJSONWritingOptions.PrettyPrinted)
            
                    let json = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let json = json {
                    var request : ASIFormDataRequest?
                   // let strUrl : NSString = "http://www.pairroxz.com/developer/aura/api/new/user"
                    let strUrl : NSString = NSString(format: "%@new/user",self.basicUrl())
                    let searchURL : NSURL = NSURL(string: strUrl as String)!
                    request = ASIFormDataRequest(URL:searchURL as NSURL)
                    request?.delegate=self
                    
                    request?.setPostValue(json, forKey: "data")
                    if userImage != nil
                    {
                        let imageData: NSData = UIImageJPEGRepresentation(userImage!, 1.0)!
                        let imgData : NSData = imageData as NSData
//
                        request?.addData(imgData, withFileName: "image.jpeg", andContentType: "image/jpeg", forKey: "file")

                    }
    
                    request?.startAsynchronous()
                    print(json)
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
    func requestFinished( request : ASIHTTPRequest ){
            MBProgressHUD.hideHUDForView(self.view.window, animated: true)
        let response = request.responseString()
         print(response)
        do{
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
            
       
            if let aStatus = jsonObject as? NSDictionary{
               let statusCode = aStatus.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                     print("Success")
                    let userId = aStatus.objectForKey("id") as? Double
                    if (userId == 0)
                    {
                       globalAlertView("Account with same email already exists!", viewCont: self)
                    }
                    else
                    {
                          let userIdStr : String = String(format:"%.0f" , userId!)
                        dict!["id"] = userIdStr
                        let scoreHpns: String? = "11"
                        userDefault.setObject(scoreHpns, forKey: "happinesScore")
                        userDefault.synchronize()
                    
                        let thumb  : String = String(format: "http://www.pairroxz.com/developer/aura/profile/thumbs/%.0f.jpeg",userId!)
                        
                        dict!["thumb"] = thumb
                        let personEncodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(dict!)
              
                        NSUserDefaults.standardUserDefaults().setObject(personEncodedObject, forKey: "userInfo");
                        
                        NSUserDefaults.standardUserDefaults().setObject(userIdStr, forKey: "userId")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        
                        appDelegate.storeUserImageInLocalDirectory()
//                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                       // appDelegate.sliderMenuControllser()
                        appDelegate.sliderMenuController()
                        
                      }
                    
                }
           
            }
            
        }
        catch
        {
            print(error)
        }
       
       
    }
    
    func requestFailed( req : ASIHTTPRequest ){
         MBProgressHUD.hideHUDForView(self.view.window, animated: true)
        let str : String = String(format: "%@",req.error)
        globalAlertView(str, viewCont: self)
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
// MARK: --------------- Textfield Delegate Methode
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtField=textField;
        txtField .resignFirstResponder()
        return true;
    }
// MARK: --------------- ACTIONSHEET DELEGATE
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 1:
         
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                    print("Button capture")
                    
                    let imag = UIImagePickerController()
                    imag.delegate=self;
                    imag.sourceType = UIImagePickerControllerSourceType.Camera;
                      imag.allowsEditing = true
                   // imag.mediaTypes = [kUTTypeImage]
                   
                    
                    self.presentViewController(imag, animated: true, completion: nil)
                }
           
            break;
                    
        case 2:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                print("Button capture")
                
                let imag = UIImagePickerController()
                imag.delegate=self;
                imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
             
                imag.allowsEditing = true
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            break;
            
               default:
            NSLog("Default");
            break;
            
        }
    }
    
//MARK: --------------- IMAGEPICKER DELEGATE
   // func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
       // userImage = info[UIImagePickerControllerEditedImage]
        userImage=info[UIImagePickerControllerEditedImage] as? UIImage
        userImage = self.RBResizeImage(userImage!, targetSize: CGSize( width: 600, height: 600))
        
        btnImage.setImage(userImage, forState: .Normal)
         UIApplication.sharedApplication() .setStatusBarStyle(.LightContent, animated: true)
        
        //sets the selected image to image view
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
//MARK: --------------- IMAGE RESIZE

    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
  
}
