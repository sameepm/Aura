//
//  SettingViewController.swift
//  Aura
//
//  Created by necixy on 21/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController , UITextFieldDelegate , ASIHTTPRequestDelegate , UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtOldPwd: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnProfileImg: UIButton!
    @IBOutlet weak var txtConfirmPwd: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtName: UITextField!
     var txtField : UITextField!
     var dict: NSMutableDictionary?
    @IBOutlet weak var scrlView: TPKeyboardAvoidingScrollView!
    var dataDict : NSMutableDictionary!
    var isImageChange : Bool!
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView : UIView = UIView()
        isImageChange=false;
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 180, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 180, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text="Change Profile"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 20)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
        
        //------
        imgUser.layer.cornerRadius=53;
        imgUser.layer.masksToBounds=true
        
        btnProfileImg.layer.cornerRadius=53;
        btnProfileImg.layer.masksToBounds=true
        
        btnDone.layer.cornerRadius=3;
        btnDone.layer.masksToBounds=true
        
        if(UIScreen .mainScreen().bounds.size.height < 508)
        {
            scrlView.contentSize=CGSizeMake(320, 650)
        }

        
        self.showImageProfile()
        txtName.text = dataDict.objectForKey("f_name") as? String
        txtLastName.text = dataDict.objectForKey("l_name")  as? String
        txtEmail.text = dataDict.objectForKey("email")  as? String
     
       if dataDict.objectForKey("type") as? NSString == "2"
            {
               txtPwd.userInteractionEnabled=false
               txtConfirmPwd.userInteractionEnabled=false
                txtName.userInteractionEnabled=false;
                txtLastName.userInteractionEnabled=false
                btnProfileImg.userInteractionEnabled=false
        }
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

             //scrlView.contentSize=CGSizeMake(320, 710)
   
        // Do any additional setup after loading the view.
    }

    func showImageProfile()
    {
        if  dataDict.objectForKey("thumb") as? NSObject != NSNull() || dataDict.objectForKey("thumb") as? String == nil
        {
            
            if dataDict.objectForKey("thumb") as? String == nil
            {
                imgUser.image = UIImage(named: "userPlace")
                
            }
            else{
                
                let imgStr : NSString = NSString(format: "%@.png", self.getUserIdFromStore())
                let readPath = self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
                let image = UIImage(contentsOfFile: readPath)
                imgUser.image=image;
            }
            
        }

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

    @IBAction func changeUserProfile(sender: AnyObject) {
        
        
        if txtName.text!.isEmpty
        {
           globalAlertView("Please enter first name.", viewCont: self);
        }
            
            
        else if txtLastName.text!.isEmpty
        {
            globalAlertView("Please enter last name", viewCont: self);
        }
            
       else if txtOldPwd.text!.isEmpty
        {
          //   txtField.resignFirstResponder()
            MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            
           
       
            dict = [
               
                "f_name": txtName.text!,
                "l_name":txtLastName.text!,
                        ]
              let strId: NSString? =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString
            
            do {
                
           
            let data =  try NSJSONSerialization.dataWithJSONObject(dict!, options: NSJSONWritingOptions.PrettyPrinted)
            
           
                let json = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let json = json {
                    var request : ASIFormDataRequest?
                    let strUrl : NSString = NSString(format: "%@user/edit/%@",self.basicUrl(), strId!)
                    
                    let searchURL : NSURL = NSURL(string: strUrl as String)!
                    
                    request = ASIFormDataRequest(URL:searchURL as NSURL)
                    request?.delegate=self
                    
                    request?.setPostValue(json, forKey: "data")
                    if isImageChange != false
                    {
                    if imgUser != nil
                    {
                        let imageData: NSData = UIImageJPEGRepresentation(imgUser.image!, 1.0)!
                        let imgData : NSData = imageData as NSData
                        //
                        request?.addData(imgData, withFileName: "image.jpeg", andContentType: "image/jpeg", forKey: "file")
                        
                    }
                    }
                    else
                    {
                        self.showImageProfile()
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
        
        else
        {
             if txtOldPwd.text!.isEmpty
             {
                 globalAlertView("Please enter old password.", viewCont: self);
            }
         else   if txtPwd.text!.isEmpty
            {
                globalAlertView("Please enter password.", viewCont: self);
            }
                
            else if txtPwd.text?.characters.count < 3 || txtPwd.text?.characters.count >= 16
            {
                globalAlertView("Password must be atleast min 3 character's and max 15 character's", viewCont: self);
            }
                
            else if txtConfirmPwd.text != txtPwd.text
            {
                globalAlertView("Confirm password does not match with password", viewCont: self);
            }
            else
            {
                MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
                
               // txtField.resignFirstResponder()
               
                dict = [
                 
                    "f_name":txtName.text!,
                     "l_name":txtLastName.text!,
                    "old_pwd": txtOldPwd.text!,
                    "new_pwd" : txtPwd.text!,
                   
                ]
                do {
                
                let data = try NSJSONSerialization.dataWithJSONObject(dict!, options: NSJSONWritingOptions.PrettyPrinted)
                
                
                     let strId: NSString? =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString
                    let json = NSString(data: data, encoding: NSUTF8StringEncoding)
                    if let json = json {
                        var request : ASIFormDataRequest?
                        let strUrl : NSString = NSString(format: "%@user/edit/%@",self.basicUrl(), strId!)
                        
                        let searchURL : NSURL = NSURL(string: strUrl as String)!
                        
                        request = ASIFormDataRequest(URL:searchURL as NSURL)
                        request?.delegate=self
                        
                        request?.setPostValue(json, forKey: "data")
                        var imgData : NSData!
                        if imgUser.image != nil
                        {
                            let imageData: NSData = UIImageJPEGRepresentation(imgUser.image!, 1.0)!
                             imgData  = imageData as NSData
                        }
                        else
                        {
                            imgData=nil
                             self.showImageProfile()
                        }
                        
                         request?.addData(imgData, withFileName: "image.jpeg", andContentType: "image/jpeg", forKey: "file")
                        
                        
                        request?.startAsynchronous()
                        print(json)
                    }
               
                }
                catch {
                    print(error)
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
        
       
            let statusCode = jsonObject.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                let pwdStatus = jsonObject.objectForKey("pwd_status") as? Bool
                 let hasPwdStatus = jsonObject.objectForKey("has_pwd") as? Bool
                
                 let userProStatus = jsonObject.objectForKey("user_status") as? Bool
                if (pwdStatus == true && userProStatus == true)
                {
                    dataDict!.setObject(txtName.text!, forKey: "f_name")
                    dataDict!.setObject(txtLastName.text!, forKey: "l_name")
                    globalAlertView("User profile and password hase been successfully changed.", viewCont: self)
                }
                    
                else if (hasPwdStatus == true &&  userProStatus == false)
                {
                  
                    globalAlertView("Old Password is wrong.", viewCont: self)
                }
                else if userProStatus == true
                {
                    dataDict!.setObject(txtName.text!, forKey: "f_name")
                    dataDict!.setObject(txtLastName.text!, forKey: "l_name")
                    globalAlertView("User profile has been successfully changed.", viewCont: self)
                }
                
                let personEncodedObject : NSData = NSKeyedArchiver.archivedDataWithRootObject(dataDict!)
                    
                    NSUserDefaults.standardUserDefaults().setObject(personEncodedObject, forKey: "userInfo");
                    NSUserDefaults.standardUserDefaults().synchronize()
             //---- Image store in document directory
                let imgStr : NSString = NSString(format: "%@.png", self.getUserIdFromStore())
                let readPath = self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
                
                 let img : UIImage = imgUser.image!
                let imgData  =  UIImagePNGRepresentation(img)! as NSData
                
              imgData.writeToFile(readPath, atomically: true)
               
               let imageDict : NSDictionary = NSDictionary(object:img as UIImage, forKey: "userImage")
                    NSNotificationCenter.defaultCenter().postNotificationName("userInfoChanged", object: nil, userInfo: imageDict as [NSObject : AnyObject])
                
            }
            
      
        }
        catch
        {
            print(error)
        }
        
        
    }
    
    func requestFailed( req : ASIHTTPRequest ){
        MBProgressHUD.hideHUDForView(self.view.window, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
        print(req.error)
    }

    @IBAction func onProfileiMageChange(sender: AnyObject) {
        //---- Actionsheet
        let actionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Camera", "Gallery")
        actionSheet.showInView(self.view)

    }
    
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //---- Mark Action Delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 1:
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                print("Button capture")
                
                let imag = UIImagePickerController()
                imag.delegate=self;
                imag.sourceType = UIImagePickerControllerSourceType.Camera;
                // imag.mediaTypes = [kUTTypeImage]
                imag.allowsEditing = true
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            
            break;
            
        case 2:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                print("Button capture")
                
                let imag = UIImagePickerController()
                imag.delegate=self;
                imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                // imag.mediaTypes = [kUTTypeImage]
                imag.allowsEditing = true
                
                self.presentViewController(imag, animated: true, completion: nil)
            }
            break;
            
        default:
            NSLog("Default");
            break;
            
        }
    }
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        isImageChange = true;
        picker .dismissViewControllerAnimated(true, completion: nil)
        imgUser.image = info[UIImagePickerControllerEditedImage] as? UIImage
        imgUser.image = self.RBResizeImage(imgUser.image!, targetSize: CGSize( width: 600, height: 600))
        let image : UIImage = imgUser.image!
        btnProfileImg.setImage(image, forState: .Normal)
        
        UIApplication.sharedApplication() .setStatusBarStyle(.LightContent, animated: true)
        
        //sets the selected image to image view
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: Image Resize
    
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

    //----- Textfield Delegate Methode
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtField=textField;
        txtField .resignFirstResponder()
        return true;
    }
}
