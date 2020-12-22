//
//  LeftMenuController.swift
//  Aura
//
//  Created by necixy on 07/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit


class LeftMenuController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var appDel : AppDelegate!
    
    @IBOutlet weak var tblView: UITableView!
    var slideOutAnimationEnabled : Bool!
    var dictionary : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        slideOutAnimationEnabled=true;
        self.view.backgroundColor=UIColor(patternImage: UIImage(named: "sliderBG")!)
        self.tblView.separatorColor=UIColor(red: 68.0/255.0, green:68.0/255.0, blue: 68.0/255.0, alpha: 1.0)

        self.tblView.tableFooterView=UIView(frame: CGRectZero);
        self.tblView.backgroundColor=UIColor.clearColor()
        dictionary = self.getUserData()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeLeftMenuOption:", name: "UserLoggedIn", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"changeUserProfile:", name: "userInfoChanged", object: nil)
        
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOfReceivedNotification", name:"NotificationIdentifier", object: nil)

  //openCustomlySlider
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func changeLeftMenuOption(notification : NSNotification){
//        
//        var indexPath : NSIndexPath
//
//         appDel = UIApplication.sharedApplication().delegate as! AppDelegate
//        if appDel.notiFyType == 309
//        {
//             indexPath = NSIndexPath(forRow: 4, inSection: 0) as NSIndexPath
//        }
//        else
//        {
//            indexPath = NSIndexPath(forRow: 3, inSection: 0) as NSIndexPath
//
//        }
//         self.tableView(tblView, didSelectRowAtIndexPath: indexPath)
//    }
    func changeUserProfile(notification : NSNotification)
    {
        let imgData : NSDictionary = notification.userInfo as! AnyObject as! NSDictionary
       
        dictionary = self.getUserData()
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection: 0) as NSIndexPath
         let cell: LeftmenuCell! = self.tblView .cellForRowAtIndexPath(indexPath) as! LeftmenuCell
        
        cell.userName.text=dictionary.objectForKey("f_name") as! NSString as String
        if  imgData.objectForKey("userImage") as? NSObject != NSNull()
        {
           // var strUrl : NSURL = NSURL(string: dictionary.objectForKey("thumb")  as! String)!
            
            cell.userImg.image = imgData.objectForKey("userImage") as? UIImage
        }

        
        
    }
    
// Mark : - Action Logout
    func actionlogOut (sender:UIButton!)
    {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure do you want to logout?", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        let  delete = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            self.appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            
            MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            
            
            let strUrl : NSString = NSString(format: "%@users/notify/unsubscribe",self.basicUrl() )
            
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            var request : ASIFormDataRequest?
            
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            request?.delegate=self
            
            request?.setPostValue(self.appDel.device_id, forKey: "object_id")
            
             let strId: NSString? =  NSUserDefaults.standardUserDefaults().objectForKey("userId") as? NSString
            request?.setPostValue(strId, forKey: "user_id")
            request?.startAsynchronous()
                   }
        
        alertController.addAction(cancel)
        alertController.addAction(delete)
        
     UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        

       
    }
    // MARK: - Table view data source
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
   func onSettingButton()
{
  //  var settingVC : SettingViewController = SettingViewController(nibName : "SettingViewController" , bundle : nil)
    
    if dictionary.objectForKey("type") as! String == "1"
    {
        let settingVC : SettingViewController = SettingViewController(nibName : "SettingViewController" , bundle : nil)
        
        settingVC.dataDict=dictionary.mutableCopy() as! NSMutableDictionary;
        SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(settingVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
    }
    else
    {        windowAlertView("You're logged in using facebook. Please visit your facebook profile to update and re-login.", viewCont: self);
    }
    
}

   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 9
    
       
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row==0)
        {
            return 170.0;
        }
        else  if (indexPath.row==8)
        {
            return 100.0;
        }
        else
        {
            return 44.0;
        }
    }
    
    
       
    
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            if indexPath.row==0
            {
                let identifier = "Custom"
                
                var cell: LeftmenuCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? LeftmenuCell
                
                if cell == nil {
                    tableView.registerNib(UINib(nibName: "LeftmenuCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? LeftmenuCell
                }
                
                cell.userImg.layer.cornerRadius = cell.userImg.frame.size.width/2
                cell.userImg.layer.masksToBounds=true
                
               
                
               cell.backgroundColor=UIColor .clearColor()
               cell.userName.text=dictionary.objectForKey("f_name") as! NSString as String
                if  dictionary.objectForKey("thumb") as? NSObject != NSNull()
                {
                    let imgStr : NSString = NSString(format: "%@.png", self.getUserIdFromStore())
                    let readPath = self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
                    let image = UIImage(contentsOfFile: readPath)
                    if image != nil
                        {
                            cell.userImg.image=image
                        }
                        else
                    {
                            cell.userImg.image = UIImage(named: "userPlace")
                    
                        }
               
                    }
                else
                {
                    cell.userImg.image = UIImage(named: "userPlace")
                }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                   cell.btnSetting.addTarget(self, action: "onSettingButton", forControlEvents: UIControlEvents.TouchUpInside )
                
                return cell;
                
            }
                
            else
                if indexPath.row==8
                {
                    let identifier = "Custom1"
                    
                    var cell: LeftMenuLastCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? LeftMenuLastCell
                    
                    if cell == nil {
                        tableView.registerNib(UINib(nibName: "LeftMenuLastCell", bundle: nil), forCellReuseIdentifier: identifier)
                        cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? LeftMenuLastCell
                    }
                    cell.backgroundColor=UIColor .clearColor()
                
                    cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0);
                    cell.logOutBtn.addTarget(self, action: "actionlogOut:", forControlEvents: UIControlEvents.TouchUpInside)
                     // button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                        cell.selectionStyle = UITableViewCellSelectionStyle.None
                  
                    return cell;
                    
                }

        else
            {
      //  let cell : UITableViewCell
     
      
       
       let  cell  = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
        
        cell.backgroundColor=UIColor .clearColor()
         cell.textLabel?.textAlignment=NSTextAlignment.Center
        cell.textLabel?.textColor=UIColor.whiteColor()
                cell.textLabel?.font=UIFont(name: "Roboto-Regular", size: 18.0)
          cell.selectionStyle = UITableViewCellSelectionStyle.None
        switch indexPath.row
        {
        
//        case 1:
//            cell.textLabel?.text="Home"
//            break;
        case 1:
           cell.textLabel?.text="Moods"
            break;
        case 2:
            cell.textLabel?.text="Happiness Scale"
            break;
        case 3:
           cell.textLabel?.text="Dashboard"
            break;
            
        case 4:
            cell.textLabel?.text="Friends"
            break;
        case 5:
            cell.textLabel?.text="Compliments"
            break;
        case 6:
            cell.textLabel?.text="Upload"
            break;
        case 7:
            cell.textLabel?.text="About Aura"
            break;
            
        default:
            cell.textLabel?.text=""
        }
        
       // println("%@",section())
                return cell
            }
        // Configure the cell...

        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        appDel.isInLeft = false
        let scoreHpns: String? = userDefault.objectForKey("happinesScore") as? String
        if scoreHpns == "11"
        {
            
          
            let moodVC : MoodsViewController = MoodsViewController(nibName : "MoodsViewController" , bundle : nil)
            
            
            SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(moodVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
            
            windowAlertView("Please first select your mood.", viewCont: self)
            
                }
        else
        {
                  switch indexPath.row
            {
          

            case 1 :
             let moodVC : MoodsViewController = MoodsViewController(nibName : "MoodsViewController" , bundle : nil)
            
          
            SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(moodVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)

            
            break ;
                    
            case 2 :
                    
                   let moodVC : HappinesScoreViewController = HappinesScoreViewController(nibName : "HappinesScoreViewController" , bundle : nil)
                   appDel.isInLeft = true
                     SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(moodVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
                break;
                    
                    
                    
                  case 3 :
                    let moodVC : DashboardViewController = DashboardViewController(nibName : "DashboardViewController" , bundle : nil)
                    
                    
                    SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(moodVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
                                      break;
                    
                  case 4 :
                    
                    let friendsVC : FriendsViewController = FriendsViewController(nibName : "FriendsViewController" , bundle : nil)
                    SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(friendsVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
                  break;
                    
                 case 5 :
                   
                   let complimentVC : ComplimentListViewController = ComplimentListViewController(nibName : "ComplimentListViewController" , bundle : nil)
                  // complimentVC.hasComeDash = false
                   SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(complimentVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
                   break;

                    
                  case 6 :
                    
                    let moodVC : UploadMediaContentViewController = UploadMediaContentViewController(nibName : "UploadMediaContentViewController" , bundle : nil)
                    SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(moodVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
                    break;
                    
                  case 7 :
                    
                    let moodVC : AboutAuraViewController = AboutAuraViewController(nibName : "AboutAuraViewController" , bundle : nil)
                    SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(moodVC, withSlideOutAnimation: self.slideOutAnimationEnabled, andCompletion: nil)
                    break;


                  case 8 :
//                        NSUserDefaults.standardUserDefaults().setObject("0", forKey: "userId")
//                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                        appDelegate.logoutUser()
                   

                    break;
            default:
                NSLog("Default");
                break;
                
        }
        }
        
         }
        
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
                    NSUserDefaults.standardUserDefaults().setObject("0", forKey: "userId")
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.logoutUser()

                    
                }
                else
                {
                    windowAlertView("Something went wrong.", viewCont: self)
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
        windowAlertView("Please check your internet connection", viewCont: self)
        print(req.error)
    }

    
}
