//
//  DashboardViewController.swift
//  Aura
//
//  Created by necixy on 06/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit


class DashboardViewController: UIViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnMoods: UIButton!
    @IBOutlet weak var btnMedia: UIButton!
    @IBOutlet weak var btnComliment: UIButton!
    var dictMyInfo : NSDictionary!
    var data = NSMutableData()
    var arrayAllData: NSMutableArray = []
    var arrayMoods: NSMutableArray = []
    var arrayComplements: NSMutableArray = []
    var arrayMedia: NSMutableArray = []
    var buttontag : Int!
    var lastIndexOfCell : Int!
    var pageNumber : Int!
    var refreshControl:UIRefreshControl!
    var itemNumb : Int!
    var urlString : String!
    var tempDict : NSMutableDictionary!
    var indexNumb : NSString!
    var isReport : Bool!
    var dateFormater : NSDateFormatter!
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView : UIView = UIView()
        
        //------- Custom Navigation
        headerView.frame=CGRectMake(70, 0, 180, 44);
        headerView.backgroundColor=UIColor.clearColor()
        self.navigationItem.titleView=headerView
        let headerLbl : UILabel = UILabel()
        headerLbl.frame=CGRectMake(0, 0, 180, 44);
        headerLbl.textAlignment=NSTextAlignment.Center
        headerLbl.textColor=UIColor.whiteColor()
        headerLbl.backgroundColor=UIColor.clearColor()
        headerLbl.text = "Dashboard"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        pageNumber = 0
        lastIndexOfCell = 98 * (pageNumber+1)
        dictMyInfo  = self.getUserData()
        
        buttontag = 1000
       dateFormater  = NSDateFormatter()
        dateFormater.dateFormat = "MMM dd, yyyy HH:mm"
        dateFormater.timeZone = NSTimeZone.systemTimeZone();
        tblView.tableFooterView=UIView(frame: CGRectZero)
       // tblView.registerClass(DashboardTableViewCell.self, forCellReuseIdentifier: "DashboardTableCell")
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Please wait...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tblView.addSubview(self.refreshControl)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.fetchAllDataFromWeb()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - SlideNavigation
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true;
    }
    
// MARK: --------------- REPORT CONTENT
    func reportContent( type : String  , contentId : String )
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
            MBProgressHUD .hideHUDForView(self.view, animated: true)
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            isReport = true
            
            var request : ASIFormDataRequest?
            let strUrl : NSString = NSString(format: "%@report",self.basicUrl())
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            request = ASIFormDataRequest(URL:searchURL as NSURL)
            
            request?.delegate=self
            request?.setPostValue(type, forKey: "type")
            request?.setPostValue(contentId, forKey: "res_id")
            
            request?.startAsynchronous()
            
        }
        
    }


      // MARK: - Action On Top Section 
    
    @IBAction func perfromActionOnButtons(sender: AnyObject) {
       
        
            tblView .setContentOffset(tblView.contentOffset, animated: false)
        let button = sender as! UIButton
              pageNumber = 0
        lastIndexOfCell = 108
        buttontag = button.tag
        switch(buttontag)
        {
        case 1000 :
            btnAll.backgroundColor = selectedColor
            btnMoods.backgroundColor = appColor
            btnComliment.backgroundColor = appColor
            btnMedia.backgroundColor = appColor
            
           
            break;
            
        case 1001 :
            btnAll.backgroundColor = appColor
            btnMoods.backgroundColor = selectedColor
            btnComliment.backgroundColor = appColor
            btnMedia.backgroundColor = appColor
            break;
            
        case 1002 :
            btnAll.backgroundColor = appColor
            btnMoods.backgroundColor = appColor
            btnComliment.backgroundColor = selectedColor
            btnMedia.backgroundColor = appColor
            break;
            
        case 1003 :
            btnAll.backgroundColor = appColor
            btnMoods.backgroundColor = appColor
            btnComliment.backgroundColor = appColor
            btnMedia.backgroundColor = selectedColor
            break;
            
        default :
            break;
        }
      

        self.tblView .reloadData()
         tblView .setContentOffset(CGPointZero, animated: false)
    }
    
    func refresh(sender:AnyObject)
    {
        pageNumber = 0
        self.fetchAllDataFromWeb()
        self.refreshControl.endRefreshing()
        
    }
    
    
  // MARK: - Fetch Data 
    func fetchAllDataFromWeb()
   
    {
        
        let strUrl : NSString = NSString(format: "%@user/notify/%@?page=%d",self.basicUrl(), (dictMyInfo.objectForKey("id")as? String)!,pageNumber)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        _ = NSURLConnection(request: request, delegate: self, startImmediately: true)
        self.data.setData(NSData())
    }
    
    
    // MARK: --------------- ASIHTTPRequest Delegate
    func requestFinished( request : ASIHTTPRequest ){
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
    do {
            
            let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableContainers)
            
            if let aStatus = jsonObject as? NSDictionary{
                let statusCode = aStatus.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    print("Success")
                    
                    
                   
                        let email_status  = aStatus.objectForKey("email_status") as? Int
                        if email_status == 1
                        {
                            globalAlertView("Reported Successfully", viewCont: self)
                            
                        }
                        else
                        {
                            globalAlertView("Something went a wrong. Please try again later.", viewCont: self)
                            
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
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        isReport = false
        self.windowAlertView ("Please check your internet connection", viewCont: self)
        print(req.error)
    }

    
    // MARK: - NSUrlConnection Delegate
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
    }
    
    func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
        self.data.appendData(conData)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error")
        globalAlertView("Please check your internet connection", viewCont: self)
        MBProgressHUD .hideHUDForView(self.view, animated: true)
    }
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        MBProgressHUD .hideHUDForView(self.view, animated: true)
    
        do{
        let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let statusCode = jsonResult.objectForKey("status") as? NSString
        self.data.setData(NSData())
        if statusCode == "200"
        {
            
            let array : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
            if pageNumber == 0
            {
                arrayAllData.removeAllObjects()
                arrayComplements.removeAllObjects()
                arrayMoods.removeAllObjects()
                arrayMedia.removeAllObjects()
            }
            
            
            
            for var i = 0 ; i < array.count ; i++
            {
                
                let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
               
                let type : Int =  Int((dictTemp.objectForKey("type") as! String))!
                switch (type)
                {
                case 200 :
                    arrayMoods.addObject(dictTemp)
                    break ;
                case 201 :
                    arrayMoods.addObject(dictTemp)
                    break ;
                case 202 :
                     arrayComplements.addObject(dictTemp)
                    break ;
               
                default :
                    arrayMedia.addObject(dictTemp)
                    break;
                }
                
                arrayAllData.addObject(dictTemp)
                
            }
            lastIndexOfCell = 98 * (pageNumber+1)
            self.tblView .reloadData()
            
        }
        }
        catch
        {
            print(error)
        }
        
    }

   
    // MARK: - TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var count : Int!
        switch(buttontag)
        {
        case 1000 :
            count =  arrayAllData.count
            break;
            
        case 1001 :
             count =  arrayMoods.count
            break;
            
        case 1002 :
             count =  arrayComplements.count
            break;
            
        case 1003 :
             count =  arrayMedia.count
            break;
            
        default :
             count =  15
            break;
        }
        return  count
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;
        
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       let identifier = "DashboardTableCell"
        
        var cell: DashboardTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? DashboardTableViewCell
        
        if cell == nil {
            let viewController : UIViewController = UIViewController(nibName: "DashboardTableViewCell", bundle: nil)
            
            cell = viewController.view as? DashboardTableViewCell
            cell.selectionStyle=UITableViewCellSelectionStyle.None
            
             }
        var tempDict : NSDictionary!
       
        switch(buttontag)
        {
        case 1000 :
           
            tempDict = arrayAllData.objectAtIndex(indexPath.row) as! NSDictionary
            break;
        case 1001 :
              tempDict = arrayMoods.objectAtIndex(indexPath.row) as! NSDictionary
              let  strBg : String  = String(format: "%@.png", appDelegate.moodAccordingNumber(tempDict.objectForKey("data") as! String)  ) as String
              cell.imgOther.image = UIImage(named: strBg)
            break;
        case 1002 :
              tempDict = arrayComplements.objectAtIndex(indexPath.row) as! NSDictionary
            break;
        case 1003 :
              tempDict = arrayMedia.objectAtIndex(indexPath.row) as! NSDictionary
            break;
            
        default :
            break;
            
        }
        
       
        if  tempDict.objectForKey("sender_thumb") as? NSObject != NSNull() ||  tempDict.objectForKey("sender_thumb") as? String == nil
        {
            
                if tempDict.objectForKey("sender_thumb") as? String == nil
                {
                    if tempDict.objectForKey("sender_id") as? String == nil
                    {

                    let imgStr : NSString = NSString(format: "%@.png", self.getUserIdFromStore())
                    let readPath = self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
                    let image = UIImage(contentsOfFile: readPath)
                    if image == nil
                    {
                        cell.imgUser.image = UIImage(named: "userPlace");
                    }
                    else
                    {
                        cell.imgUser.image=image
                    }
                    }
                    else
                    {
                        
                            cell.imgUser.image = UIImage(named: "userPlace");
                      
                    }
                }
                else
                {
                    let imgStr : String = String (format: "%@", tempDict.objectForKey("sender_thumb")  as! String )
                    let strUrl : NSURL = NSURL(string: imgStr)!
                    cell.imgUser.image = UIImage(named: "userPlace")
                    cell.imgUser.imageURL = strUrl
                    
                }
            
        
        }
        else
        {
            let imgStr : NSString = NSString(format: "%@.png", self.getUserIdFromStore())
            let readPath = self.documentDirectoryPath().stringByAppendingPathComponent(imgStr as String)
            let image = UIImage(contentsOfFile: readPath)
            cell.imgUser.image=image
        }
        
        let string : String = tempDict.objectForKey("time_millis") as! String
        
        let timeinterval : NSTimeInterval = (string as NSString).doubleValue / 1000 // convert it in to NSTimeInteral
        
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
      
       // print(dateFromServer)
        //  print(dateFormater.stringFromDate(dateFromServer))
        let timeStamp = dateFormater.stringFromDate(dateFromServer)
        cell.lblTime.text = timeStamp
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2
           cell.imgUser.layer.masksToBounds=true
        cell.imgOther.layer.cornerRadius = cell.imgOther.frame.size.width/2
        cell.imgOther.layer.masksToBounds=true
        
        let type : Int =  Int( (tempDict.objectForKey("type") as! String))!
        switch (type)
        {
        case 200 :
             cell.imgOther.hidden = false
            cell.icon.hidden = true
           cell.lblMood.text = String(format: "You changed mood to : %@", appDelegate.moodAccordingNumber(tempDict.objectForKey("data") as! String)  ) as String
           let  strBg : String  = String(format: "%@.png", appDelegate.moodAccordingNumber(tempDict.objectForKey("data") as! String)  ) as String
           cell.imgOther.image = UIImage(named: strBg)
            break ;
        case 201 :
            cell.icon.hidden = true
            cell.imgOther.hidden = false
           // tempDict = arrayAllData.objectAtIndex(indexPath.row) as! NSDictionary
            let  strBg : String  = String(format: "%@.png", appDelegate.moodAccordingNumber(tempDict.objectForKey("data") as! String)  ) as String
            cell.imgOther.image = UIImage(named: strBg)
            cell.lblMood.text = String(format: "%@ shared : %@ Mood",tempDict.objectForKey("sender_f_name") as! String, appDelegate.moodAccordingNumber(tempDict.objectForKey("data") as! String)  ) as String

            break ;
        case 202 :
            cell.icon.hidden = false
           cell.imgOther.hidden = true
            if tempDict.objectForKey("sender_id") as? String ==  dictMyInfo.objectForKey("id")as? String
            {
                cell.lblMood.text = String(format: "You sent compliment to : %@ ",tempDict.objectForKey("sender_f_name") as! String ) as String
            }
            else
            {
             cell.lblMood.text = String(format: "%@ sent compliment to you",tempDict.objectForKey("sender_f_name") as! String ) as String
            }
              cell.icon.image = UIImage(named: "compliment_icon")
            
            break ;
        case 203 :
             cell.icon.hidden = false
             
         cell.imgOther .hidden = true
             cell.lblMood.text = String(format: "%@ sent picture to you",tempDict.objectForKey("sender_f_name") as! String ) as String
            cell.icon.image = UIImage(named: "picicon")

            break ;
        case 204 :
            
            cell.icon.hidden = false
            
            cell.imgOther .hidden = true
            cell.lblMood.text = String(format: "%@ sent quote to you",tempDict.objectForKey("sender_f_name") as! String ) as String
            cell.icon.image = UIImage(named: "quote")
            
            break ;

        case 205 :
            
            cell.icon.hidden = false
            
            cell.imgOther .hidden = true
            cell.lblMood.text = String(format: "%@ sent song to you",tempDict.objectForKey("sender_f_name") as! String ) as String
            cell.icon.image = UIImage(named: "songicon.png")
            
            break ;

        case 206 :
            
            cell.icon.hidden = false
            
            cell.imgOther .hidden = true
            cell.lblMood.text = String(format: "%@ sent joke to you",tempDict.objectForKey("sender_f_name") as! String ) as String
            cell.icon.image = UIImage(named: "joke")
            
            break ;

        case 207 :
            cell.icon.hidden = false
            
            cell.imgOther .hidden = true
            cell.lblMood.text = String(format: "%@ sent video to you",tempDict.objectForKey("sender_f_name") as! String ) as String
            cell.icon.image = UIImage(named: "videoicon")
            
            break ;

        case 208 :
            cell.icon.hidden = false
            
            cell.imgOther .hidden = true
            cell.lblMood.text = String(format: "%@ sent tip to you",tempDict.objectForKey("sender_f_name") as! String ) as String
    
             cell.icon.image = UIImage(named: "tip")
            
            break ;

        default :
                  break;
        }
        cell.backgroundColor=UIColor .clearColor()
  
        return cell
    }
    
    
    
    func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        
 
        let lastIndexPath : NSIndexPath = NSIndexPath(forRow: lastIndexOfCell, inSection: 0)
//        
        
        if indexPath.row == lastIndexPath.row
        {
           pageNumber = pageNumber + 1
            self.fetchAllDataFromWeb()
                
        
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        itemNumb = indexPath.row
        
        
        let webVC : InAppWebViewController = InAppWebViewController(nibName : "InAppWebViewController" , bundle: nil)
        let mmVC : MMSubViewController = MMSubViewController(nibName : "MMSubViewController" , bundle : nil)
        mmVC.viewComeFrom = "dashboard"

//         var tempDict : NSMutableDictionary!
        switch(buttontag)
        {
        case 1000 :
             tempDict  = arrayAllData.objectAtIndex(indexPath.row) as! NSMutableDictionary
            break ;
            
        case 1001 :
            tempDict = arrayMoods.objectAtIndex(indexPath.row) as! NSMutableDictionary
        case 1002 :
             tempDict  = arrayComplements .objectAtIndex(indexPath.row) as! NSMutableDictionary
            break ;
            
        case 1003 :
            tempDict  = arrayMedia .objectAtIndex(indexPath.row) as! NSMutableDictionary
            break ;

        default :
            break;
        }
 
        let strType : String  =  tempDict.objectForKey("type") as! String
        let typeInt : Int = Int(strType)!
        
        switch(typeInt)
        {
        case 202 :
            let complimentVC : ComplimentViewController = ComplimentViewController(nibName : "ComplimentViewController" , bundle : nil)
            complimentVC.hasComeDash = true
            complimentVC.idOfComp = tempDict.objectForKey("data")as? String
            
            self.navigationController?.pushViewController(complimentVC, animated: true)
            break ;
        case 203 :
          
            
          // tempDict = self.arrayMedia .objectAtIndex(indexPath.row) as! NSMutableDictionary
           
           let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
           let open = UIAlertAction(title: "Open", style: .Default, handler: { (action) -> Void in
            let imgVC : ImageWithPageController = ImageWithPageController(nibName : "ImageWithPageController" , bundle : nil)
            let arrTemp : NSArray = NSArray(object: self.tempDict)
            imgVC.arrayData = arrTemp as [AnyObject]
            
            self.indexNumb  = NSString(format: "%d",self.itemNumb) as NSString
            imgVC.scrollToPage =    self.indexNumb  as String
            imgVC.isComeFromDash = true
            self.presentViewController(imgVC, animated: true
                , completion: nil)
           })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
           })
           let  delete = UIAlertAction(title: "Report", style: .Destructive) { (action) -> Void in
            self.reportContent("1", contentId: (self.tempDict.objectForKey("ref_id") as? String)!)
           }
           alertController.addAction(open)
          
           alertController.addAction(cancel)
           alertController.addAction(delete)
           
           presentViewController(alertController, animated: true, completion: nil)

            break ;
            
        case 204 :
           // tempDict  = arrayMedia .objectAtIndex(indexPath.row)
             //   as! NSMutableDictionary
            mmVC.type = "Quote"
            mmVC.dict = tempDict
            
            self.navigationController!.pushViewController(mmVC, animated: true)
            break ;
        case 205 :
            if buttontag == 1000
            {
                urlString = (arrayAllData .objectAtIndex(itemNumb) as? NSDictionary)! .objectForKey("data") as? String
            }
            else
            {
            urlString = (arrayMedia .objectAtIndex(itemNumb) as? NSDictionary)! .objectForKey("data") as? String
            }

            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let open = UIAlertAction(title: "Open", style: .Default, handler: { (action) -> Void in
                webVC.urlString = self.urlString
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                print("Cancel Button Pressed")
            })
            let  delete = UIAlertAction(title: "Report", style: .Destructive) { (action) -> Void in
                self.reportContent("3", contentId: (self.tempDict .objectForKey("ref_id") as? String)!)
            }
            alertController.addAction(open)
            
            alertController.addAction(cancel)
            alertController.addAction(delete)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            
            break ;

        case 206 :
           // tempDict  = arrayMedia .objectAtIndex(indexPath.row) as! NSMutableDictionary
            mmVC.type = "Joke"
            mmVC.dict = tempDict
            
            
            self.navigationController!.pushViewController(mmVC, animated: true)
            break ;

        case 207 :
            if buttontag == 1000
            {
                urlString = (arrayAllData .objectAtIndex(itemNumb) as? NSDictionary)! .objectForKey("data") as? String
            }
            else
            {
            urlString = (arrayMedia .objectAtIndex(itemNumb) as? NSDictionary)! .objectForKey("data") as? String
            }
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let open = UIAlertAction(title: "Open", style: .Default, handler: { (action) -> Void in
                webVC.urlString = self.urlString
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                print("Cancel Button Pressed")
            })
            let  delete = UIAlertAction(title: "Report", style: .Destructive) { (action) -> Void in
               self.reportContent("5", contentId: (self.tempDict.objectForKey("ref_id") as? String)!)
            }
            alertController.addAction(open)
            
            alertController.addAction(cancel)
            alertController.addAction(delete)
            
            presentViewController(alertController, animated: true, completion: nil)
             break ;

        case 208 :
            //tempDict  = arrayMedia .objectAtIndex(indexPath.row) as! NSMutableDictionary
            mmVC.type = "Tip"
            mmVC.dict = tempDict
            
            self.navigationController!.pushViewController(mmVC, animated: true)
            break ;

            
        default :
            break;
        }
        
    }
    
    
   
}
