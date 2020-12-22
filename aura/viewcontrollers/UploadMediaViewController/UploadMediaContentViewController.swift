//
//  UploadMediaContentViewController.swift
//  Aura
//
//  Created by Apple on 30/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit
import MediaPlayer

class UploadMediaContentViewController: UIViewController , UITextViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIActionSheetDelegate {
    @IBOutlet var lblSeprator: UILabel!
    @IBOutlet var imgForSend: UIImageView!
    @IBOutlet var btnChangePic: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var ViewForTxtSub: UIView!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var ViewForTxt: UIView!
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var txtTitle: UITextField!
    var indexPathRow : Int!
    var isImage : Bool!
    var isSongV : Bool!
    var image : UIImage!
  var arrayData : NSMutableArray = []
    var moviePlayer : MPMoviePlayerController!
    
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
        headerLbl.text="Upload"
        headerLbl.minimumScaleFactor = 0.5
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        isImage = false
        isSongV = false
        self.tblView.tableFooterView = UIView(frame: CGRectZero)
        btnSend.layer.cornerRadius = 5
        btnSend.layer.masksToBounds = true
        btnChangePic.layer.cornerRadius = 5
        btnChangePic.layer.masksToBounds = true
        
        let tapGes : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboardInSubView")
        self.ViewForTxt .addGestureRecognizer(tapGes)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if appDelegate.hasSelectMood == true
        {
             print( appDelegate.arraySelMoods)
            appDelegate.hasSelectMood = false
            
            self.sendDataToWeb()
        }
        else
        {
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sendDataToWeb()
    {
//         let  mood : NSString = (userDefault.objectForKey("moodValue") as? NSString)!
        
        
       
        
        let mood = appDelegate.arraySelMoods.componentsJoinedByString(",")
        if isImage == true
        {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            var request : ASIFormDataRequest?
            let strUrl : NSString = NSString(format: "%@picture",self.basicUrl())
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            
            request?.delegate=self
            request?.setPostValue(mood, forKey: "mood")
            
            let imageData: NSData = UIImageJPEGRepresentation(imgForSend.image!, 1.0)!
            let imgData : NSData = imageData as NSData
            //
            request?.addData(imgData, withFileName: "image.jpeg", andContentType: "image/jpeg", forKey: "file")
            
            request?.startAsynchronous()
            self.hideSubView()
            
        }
        else
        {
            
            if txtView.text == "Write here..."
            {
                
                
                windowAlertView("Field are mandatory.", viewCont: self)
                
            }
            else
            {
                let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
                if isInternet == false
                {
                    
                    self.windowAlertView ("Please check your internet connection", viewCont: self)
                }
                else
                {
                    
                    
                    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    var request : ASIFormDataRequest?
                    
                    let data : NSData = txtView.text.dataUsingEncoding(NSNonLossyASCIIStringEncoding)!
                    let txtString : String = String(data: data, encoding: NSUTF8StringEncoding)!
        
                    
                    switch (indexPathRow)
                    {
                    case 0 :
                        let titleData : NSData = txtTitle.text!.dataUsingEncoding(NSNonLossyASCIIStringEncoding)!
                        let txtTitleStr : String = String(data: titleData, encoding: NSUTF8StringEncoding)!
                        let strUrl : NSString = NSString(format: "%@song",self.basicUrl())
                            let searchURL : NSURL = NSURL(string: strUrl as String)!
                            request = ASIFormDataRequest(URL:searchURL as NSURL)
                        
                            request?.delegate=self
                            request?.setPostValue(mood, forKey: "mood")
                            request?.setPostValue(txtString, forKey: "song_link")
                            request?.setPostValue(txtTitleStr, forKey: "title")
                     
                        break ;
                        
                    case 1 :
                        let titleData : NSData = txtTitle.text!.dataUsingEncoding(NSNonLossyASCIIStringEncoding)!
                        let txtTitleStr : String = String(data: titleData, encoding: NSUTF8StringEncoding)!
                         let strUrl : NSString = NSString(format: "%@video",self.basicUrl())
                            let searchURL : NSURL = NSURL(string: strUrl as String)!
                            request = ASIFormDataRequest(URL:searchURL as NSURL)
                            
                            request?.delegate=self
                            request?.setPostValue(mood, forKey: "mood")
                            request?.setPostValue(txtString, forKey: "video_link")
                            request?.setPostValue(txtTitleStr, forKey: "title")
                      
                        break ;
                    case 3 :
                        
                        let strUrl : NSString = NSString(format: "%@joke",self.basicUrl())
                        let searchURL : NSURL = NSURL(string: strUrl as String)!
                        request = ASIFormDataRequest(URL:searchURL as NSURL)
                        
                        request?.delegate=self
                        request?.setPostValue(mood, forKey: "mood")
                        request?.setPostValue(txtString, forKey: "joke")
                        break ;
                    case 4 :
                        let strUrl : NSString = NSString(format: "%@quote",self.basicUrl())
                        let searchURL : NSURL = NSURL(string: strUrl as String)!
                        request = ASIFormDataRequest(URL:searchURL as NSURL)
                        
                        request?.delegate=self
                        request?.setPostValue(mood, forKey: "mood")
                        request?.setPostValue(txtString, forKey: "quote")
                        
                        break ;
                    case 5 :
                        let strUrl : NSString = NSString(format: "%@tip",self.basicUrl())
                        let searchURL : NSURL = NSURL(string: strUrl as String)!
                        request = ASIFormDataRequest(URL:searchURL as NSURL)
                        
                        request?.delegate=self
                        request?.setPostValue(mood, forKey: "mood")
                        request?.setPostValue(txtString, forKey: "tip")
                        
                        break ;
                    case 6 :
                        let strUrl : NSString = NSString(format: "%@compliment",self.basicUrl())
                        let searchURL : NSURL = NSURL(string: strUrl as String)!
                        request = ASIFormDataRequest(URL:searchURL as NSURL)
                        
                        request?.delegate=self
                        request?.setPostValue(mood, forKey: "mood")
                        request?.setPostValue(txtString, forKey: "content")
                        break ;
                        
                        
                    default :
                        break ;
                        
                        
                    }
                    request?.startAsynchronous()
                    self.hideSubView()
                    
                }
            }
        }

    }
    
    @IBAction func open(sender: AnyObject) {
        let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        //  moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        
        
        //moviePlayer.fullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullscreen = true
    }
    
    func hideKeyboardInSubView()
    {
      self.hideSubView()
    }
    @IBAction func closeSubView(sender: AnyObject) {
        
        self.hideSubView()
        
    }
    
    @IBAction func actionChangePictureButton(sender: AnyObject) {
        
         self.hideSubView()
         btnChangePic.hidden = true
        let actionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Camera", "Gallery")
        actionSheet.showInView(self.view)
    }
    
    func hideSubView()
    {
        ViewForTxt .removeFromSuperview()
        txtView.hidden = false
        txtView.resignFirstResponder()
        txtView.text = "Write here..."
        txtTitle.text = ""
        txtView.textColor =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        
    }
    @IBAction func saveOnWeb(sender: AnyObject) {
      //  ViewForTxt .removeFromSuperview()
       // txtView.resignFirstResponder()
         let moodSelectionVC : MoodSelectionUPLDViewController = MoodSelectionUPLDViewController(nibName : "MoodSelectionUPLDViewController" , bundle : nil)
          appDelegate.arraySelMoods.removeAllObjects()
       
        switch (indexPathRow)
        {
        case 0 :
            if self.txtTitle.text!.isEmpty
            {
                windowAlertView("Please enter title.", viewCont: self)
               
            }
            else if self.txtTitle.text!.length > 50
            {
                windowAlertView("Maximum length of characters is 50.", viewCont: self)
                
            }
            else   if self.checkTextContainLink(txtView.text) == false
            {
             windowAlertView("Please enter only link", viewCont: self)
            }

            
            else
            {
            self.presentViewController(moodSelectionVC, animated: true, completion: nil)
                ViewForTxt .removeFromSuperview()
                 txtView.resignFirstResponder()
            }
            break ;
            
        case 1 :
           
             if self.txtTitle.text!.isEmpty
            {
                windowAlertView("Please enter title.", viewCont: self)
               
            }
             else if self.txtTitle.text!.characters.count > 50
             {
                windowAlertView("Maximum length of characters is 50.", viewCont: self)
                
             }
            else if self.checkTextContainLink(txtView.text) == false
            {
                
                windowAlertView("Please enter only link.", viewCont: self)
                
            }
           
            else
            {
                self.presentViewController(moodSelectionVC, animated: true, completion: nil)
                ViewForTxt .removeFromSuperview()
                txtView.resignFirstResponder()

                
            }
            break ;
        case 2 :
            if imgForSend.image == nil
            {
                windowAlertView("Please add an image", viewCont: self)
            }
            else
            {
                  ViewForTxt .removeFromSuperview()
                  self.presentViewController(moodSelectionVC, animated: true, completion: nil)
            }
       
        default :
            if txtView.text == "Write here..."
            {
                windowAlertView("Please fill text field.", viewCont: self)
               
            }
            else if txtView.text.characters.count > 500
            {
                windowAlertView("Maximum length of characters is 500.", viewCont: self)
            }
            else
            {
                if indexPathRow == 6
                {
                  self.sendDataToWeb()
                }
                else
                {
                self.presentViewController(moodSelectionVC, animated: true, completion: nil)
                }
                ViewForTxt .removeFromSuperview()
                txtView.resignFirstResponder()
            }
            
            break ;
            
            
        }
  
}
    
    
    
    func checkTextContainLink ( stng : String) -> Bool
    {
       
        let text = stng
        let types: NSTextCheckingType = .Link
        
        var  detector : NSDataDetector!
        
      do
      {
        detector = try NSDataDetector(types: types.rawValue)
        }
        catch
        {
            print(error)
        }
      
        
      
    let matches = detector.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count))
        var counter : Int = 0
        
        for match in matches {
            print(match)
            counter++
           
        }
        if counter > 1
        {
            globalAlertView("Onle one link is allowed.", viewCont: self)
              MBProgressHUD.hideHUDForView(self.view, animated: true)
           return false
        }
        else  if counter == 1
        {
            return true
        }
        else
        {
             return false
        }

       
    }
// MARK: - ASIHTTPRequest
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
       
      
        do {
        
        let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
        
        if let aStatus = jsonObject as? NSDictionary{
            let statusCode = aStatus.objectForKey("status") as? NSString
            if statusCode == "200"
            {
                print("Success")
                
               
                if   aStatus.objectForKey("success") as! Bool == true
                {
                    txtView.hidden = false
                    self.imgForSend.hidden = true
                    self.btnChangePic.hidden = true
                     isImage = false
                switch (indexPathRow)
                {
                    
                case 0 :
                     globalAlertView("Audio uploaded successfully!", viewCont: self)
                    break ;
                case 1 :
                    globalAlertView("Video uploaded successfully!", viewCont: self)
                    break ;
                case 2 :
                    globalAlertView("Picture uploaded successfully!", viewCont: self)
                    break ;
                case 3 :
                     globalAlertView("Joke uploaded successfully!", viewCont: self)
                    break ;
                case 4 :
                     globalAlertView("Quote uploaded successfully!", viewCont: self)
                    break ;
                case 5 :
                     globalAlertView("Tip uploaded successfully!", viewCont: self)
                    break ;
                case 6 :
                     globalAlertView("Compliment uploaded successfully!", viewCont: self)
                    break ;
                default :
                    break ;
                }
                    txtTitle.text = ""
                }
                else
                {
                     globalAlertView("Error in uploading , Please try later", viewCont: self)
                }

                //friendRequestUpdate
            }
         
            
        }
            else
        {
            
            }
        }
        catch
        {
            print(error)
            globalAlertView("Error in uploading , Please try later", viewCont: self)
        }
        
        
    }
    
    func requestFailed( req : ASIHTTPRequest ){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.windowAlertView ("Please check your internet connection", viewCont: self)
        print(req.error)
    }

// MARK: - SlideNavigationController
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
       
        return true
    }
  
    
// MARK: - TextView Delegate 

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if isSongV == true
        {
            if txtView.text == "Enter URL"
            {
                txtView.text = ""
                txtView.textColor = UIColor.darkGrayColor()
            }
            
        }
        else
        {
        if txtView.text == "Write here..."
        {
            txtView.text = ""
            txtView.textColor = UIColor.darkGrayColor()
        }
        }
        return true
    }
     func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if isSongV == true
        {
            if txtView.text.characters.count <= 0
            {
                txtView.text = "Enter URL"
                txtView.textColor =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
            }
            
        }
        else
        {
        
        if txtView.text.characters.count <= 0
        {
            txtView.text = "Write here..."
           txtView.textColor =  UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        }
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
  
    
    
// MARK: - TableView
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        
        return 7
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "UploadMediaCell"
        var cell: UploadMediaCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? UploadMediaCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "UploadMediaCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UploadMediaCell
        }
        
        switch (indexPath.row)
        {
        case 0 :
            cell.lblTitle.text = "Audio"
            cell.imgIcon.image = UIImage(named: "songicon")
            break ;

        case 1 :
            cell.lblTitle?.text = "Video"
            cell.imgIcon?.image = UIImage(named: "videoicon.png")
        break ;
       
        case 2 :
            cell.lblTitle?.text = "Picture"
            cell.imgIcon?.image = UIImage(named: "picicon.png")
            break ;

        case 3 :
            cell.lblTitle?.text = "Joke"
            cell.imgIcon?.image = UIImage(named: "joke")
            break ;

        case 4 :
            cell.lblTitle?.text = "Quote"
            cell.imgIcon?.image = UIImage(named: "quote")
            break ;
        case 5 :
            cell.lblTitle?.text = "Tip"
            cell.imgIcon?.image = UIImage(named: "tip")
            break ;
            
        case 6 :
            cell.lblTitle?.text = "Compliment"
            cell.imgIcon?.image = UIImage(named: "compliment_icon")
            break ;
        default :
                break ;
            
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor=UIColor .clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // println("%@",section())
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        indexPathRow = indexPath.row
        
        if indexPath.row == 2
        {
            //---- Actionsheet
           
            
            let actionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil , otherButtonTitles: "Camera", "Gallery")
            actionSheet.showInView(self.view)
            
            
        }
        else
        {
            self.view.window! .addSubview(ViewForTxt)
            self.ViewForTxtSub.transform =   CGAffineTransformMakeScale(0.7, 0.5)
        
            btnClose.transform =   CGAffineTransformMakeScale(0.8, 0.5)
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity:0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: ({
            self.ViewForTxtSub.transform = CGAffineTransformMakeScale(1, 1)
              self.btnClose.transform =   CGAffineTransformMakeScale(1.0, 1.0)
                self.btnChangePic.hidden = true
                self.imgForSend.hidden = true
                
                if(indexPath.row == 0 || indexPath.row == 1)
                {
                    self.txtView.text = "Enter URL"
                    self.isSongV = true
                }
                else
                {
                   self.txtView.text = "Write here..."
                    self.isSongV = false
                }
                
            // do stuff
        }), completion: nil)
            
            switch (indexPathRow)
            {
            case 0 :
                lblTitle.text = "Audio"
                txtTitle.hidden = false
                lblSeprator.hidden = false
                btnSend .setTitle("Select Mood to Apply", forState: UIControlState.Normal)

                txtView.frame = CGRectMake(8, 112, 265, 192)
                
                break ;
            case 1 :
                lblTitle.text = "Video"
                txtTitle.hidden = false
                lblSeprator.hidden = false
                btnSend .setTitle("Select Mood to Apply", forState: UIControlState.Normal)

                txtView.frame = CGRectMake(8, 112, 265, 192)
                break ;
            case 3 :
                lblTitle.text = "Joke"
                txtTitle.hidden = true
                lblSeprator.hidden = true
                btnSend .setTitle("Select Mood to Apply", forState: UIControlState.Normal)

                txtView.frame = CGRectMake(8, 65, 265, 239)
                break ;
            case 4 :
                lblTitle.text = "Quote"
                txtTitle.hidden = true
                  lblSeprator.hidden = true
                btnSend .setTitle("Select Mood to Apply", forState: UIControlState.Normal)

                 txtView.frame = CGRectMake(8, 65, 265, 239)
                break ;
            case 5 :
                lblTitle.text = "Tip"
                txtTitle.hidden = true
                  lblSeprator.hidden = true
                btnSend .setTitle("Select Mood to Apply", forState: UIControlState.Normal)
                 txtView.frame = CGRectMake(8, 65, 265, 239)
                break ;
            case 6 :
                lblTitle.text = "Compliment"
                txtTitle.hidden = true
                btnSend .setTitle("Upload Now", forState: UIControlState.Normal)
                  lblSeprator.hidden = true
                 txtView.frame = CGRectMake(8, 65, 265, 239)
                break ;
            default :
                break ;
            }
        }
        
        
      
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

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        image=info[UIImagePickerControllerEditedImage] as? UIImage
        image = self.RBResizeImage(image!, targetSize: CGSize( width: 600, height: 600))
        
       
        UIApplication.sharedApplication() .setStatusBarStyle(.LightContent, animated: true)
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.view.window! .addSubview(self.ViewForTxt)
            self.lblTitle.text = "Picture"
            self.imgForSend.hidden = false
        
            self.imgForSend.image = self.image
            self.txtView.hidden = true
            self.isImage = true
            self.txtTitle.hidden = true
              self.lblSeprator.hidden = true
            self.btnChangePic.hidden = false
        })
    }

        
        //sets the selected image to image view
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        isImage = false
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

    // MARK: - TextFiled Delegate Methode
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtTitle .resignFirstResponder()
        return true;
        
    }
   
    
   
}
