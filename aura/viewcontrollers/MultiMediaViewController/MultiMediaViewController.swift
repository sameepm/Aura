//
//  MultiMediaViewController.swift
//  Aura
//
//  Created by necixy on 15/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class MultiMediaViewController: UIViewController , NSURLConnectionDelegate , UICollectionViewDataSource ,UICollectionViewDelegate, UIViewControllerTransitioningDelegate , UIActionSheetDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var picutreView: UIView!
    @IBOutlet weak var clView: UICollectionView!
    var mmType : Int!
    var itemNumb : Int!
    var totalMedia : Int = -1
    var moodType : NSString!
    var arrayPictureData : NSMutableArray = []
    var arraySongData : NSMutableArray = []
    var arrayVideoData : NSMutableArray = []
    var arrayQuotesData : NSMutableArray = []
    var arrayTipsData : NSMutableArray = []
    var arrayJokesData : NSMutableArray = []
    var data = NSMutableData()
    var appDel : AppDelegate!
    var reachability : Reachability!
    var lastIndexOfCell : Int!
    var pageNumber : Int!
    var refreshControl:UIRefreshControl!
    var connGetData : NSURLConnection!
    var  isReport : Bool!
 
    
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
        //headerLbl.text = "Dashboard"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
    
        isReport = false
        pageNumber = 0
        lastIndexOfCell = 19 * (pageNumber+1)
         //FriendsCell
    
        self.tblView.tableFooterView = UIView(frame: CGRectZero)
        self.clView!.registerNib(UINib(nibName: "PictureCell", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
    
//------------------- Pull to refresh 
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Please wait...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    
        switch mmType
        {
        
        case 1 :
            print("----------------------------- Get Songs--------------------")
            headerLbl.text="Song"
            self.getAllData()
            self.clView.hidden = true
            self.tblView.addSubview(refreshControl)
            break;
        case 2 :
             print("----------------------------- Get Picture--------------------")
            headerLbl.text="Picture"
            self.getAllData()
            self.clView.addSubview(refreshControl)
             break;
        case 3 :
            print("----------------------------- Get Quotes--------------------")
            headerLbl.text="Quotes"
            self.clView.hidden=true
            self.getAllData()
            self.tblView.addSubview(refreshControl)
          
            break;
        case 4 :
            print("----------------------------- Get Video--------------------")
            headerLbl.text="Video"
            self.getAllData()
            self.clView.hidden = true
            self.tblView.addSubview(refreshControl)
            break;
            
        case 5 :
            print("----------------------------- Get Jokes--------------------")
            headerLbl.text="Jokes"
            self.clView.hidden=true
            self.getAllData()
            self.tblView.addSubview(refreshControl)
            
            break;
        case 6 :
            print("----------------------------- Get Tips--------------------")
            headerLbl.text="Tips"
            self.clView.hidden=true
            self.getAllData()
            self.tblView.addSubview(refreshControl)
            break;
            
            
        default :
            break;
        }
            
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
    swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
    self.view.addGestureRecognizer(swipeLeft)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
// MARK: --------------- Pull to refresh
    func refresh(sender:AnyObject)
    {
        pageNumber = 0
        self.getAllData()
        self.refreshControl.endRefreshing()
        
    }

// MARK: --------------- Get All Data
    
     func getAllData()
    {
        
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
              MBProgressHUD .hideHUDForView(self.view, animated: true)
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {
            if totalMedia == -1 {
                
            }
            var strUrl  : NSString!
            switch mmType
            {
                
            case 1 :
               strUrl  = NSString(format: "%@song/mood/%@?page=%d",self.basicUrl(),moodType, pageNumber)
               break;

            case 2 :
              strUrl  = NSString(format: "%@picture/mood/%@?page=%d",self.basicUrl(),moodType, pageNumber)
              break;

            case 3 :
               strUrl  = NSString(format: "%@quote/mood/%@?page=%d",self.basicUrl(),moodType, pageNumber)
               break;
               
            case 4 :
                strUrl  = NSString(format: "%@video/mood/%@?page=%d",self.basicUrl(),moodType, pageNumber)
                break ;
            case 5 :
              strUrl  = NSString(format: "%@joke/mood/%@?page=%d",self.basicUrl(),moodType, pageNumber)
                break;
            case 6 :
              strUrl  = NSString(format: "%@tip/mood/%@?page=%d",self.basicUrl(),moodType, pageNumber)
                break;
                
            default :
                break;
            }
        
            let searchURL : NSURL = NSURL(string: strUrl as String)!
            let request = NSURLRequest(URL: searchURL)
                
            connGetData = NSURLConnection(request: request, delegate: self, startImmediately: true)!
            connGetData.start()
            self.data.setData(NSData())
        }

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
// MARK: --------------- Suffle records
    func shuffle(arrayToSuffle:NSMutableArray) -> NSArray
    {
        if (arrayToSuffle.count <= 1){
         return arrayToSuffle
        }
        
        for index in (1 ... arrayToSuffle.count - 1).reverse(){
            
            // Random int from 0 to index-1
            let j = Int(arc4random_uniform(UInt32(index-1)))
            
            // Swap two array elements
            // Notice '&' required as swap uses 'inout' parameters
            swap(&arrayToSuffle[index], &arrayToSuffle[j])
            
        }

        return arrayToSuffle
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
                    
                    
                    if isReport == true
                    {
                        isReport = false
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
                    else
                    {

                    if   aStatus.objectForKey("success") as! Bool == true
                    {
                        globalAlertView("Error in uploading , Please try later", viewCont: self)
                    }
                    else
                    {
                        globalAlertView("Error in uploading , Please try later", viewCont: self)
                    }
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

    
// MARK: --------------- NSURL CONNECTION DELEGATE
    
        func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
            // println("didReceiveResponse")
        }
        
        func connection(connection: NSURLConnection!, didReceiveData conData: NSData!) {
            self.data.appendData(conData)
        }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
         MBProgressHUD .hideHUDForView(self.view, animated: true)
        globalAlertView("Please check your internet connection", viewCont: self)
    }
        
        func connectionDidFinishLoading(connection: NSURLConnection!)
        {
             MBProgressHUD .hideHUDForView(self.view, animated: true)
           do {
            
            if  let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    let statusCode = jsonResult.objectForKey("status") as? NSString
                    if statusCode == "200"
                    {
                        if connection == connGetData
                        {
                            //Change : Added extra code to suffle array. Previous code is commented
                            // let array = : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
                           
                            let arrayFromServer : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
                            let array = self.shuffle(arrayFromServer.mutableCopy() as! NSMutableArray)
                            switch mmType
                            {
                            case 1 :
                                if pageNumber == 0
                                {
                                    arraySongData.removeAllObjects()
                                    pageNumber = 0
                                    
                                }
                                for var i = 0 ; i < array.count ; i++
                                {
                                    let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                                    arraySongData.addObject(dictTemp)
                                    
                                }
                                lastIndexOfCell = 19 * (pageNumber+1)
                                self.tblView .reloadData()

                                break;
                            case 2:
                                if pageNumber == 0
                                {
                                  arrayPictureData.removeAllObjects()
                                    pageNumber = 0
                                    
                                }
                                for var i = 0 ; i < array.count ; i++
                                {
                                    let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                                    arrayPictureData.addObject(dictTemp)
                                    
                                }
                                lastIndexOfCell = 19 * (pageNumber+1)
                                self.clView .reloadData()
                                break;
                            case 3:
                                if pageNumber == 0
                                {
                                    arrayQuotesData.removeAllObjects()
                                    pageNumber = 0
                                    
                                }
                                for var i = 0 ; i < array.count ; i++
                                {
                                    let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                                    arrayQuotesData.addObject(dictTemp)
                                    
                                }
                                lastIndexOfCell = 19 * (pageNumber+1)
                                self.tblView .reloadData()
                                break;
                            case 4:
                                if pageNumber == 0
                                {
                                    arrayVideoData.removeAllObjects()
                                    pageNumber = 0
                                    
                                }
                                for var i = 0 ; i < array.count ; i++
                                {
                                    let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                                    arrayVideoData.addObject(dictTemp)
                                    
                                }
                                lastIndexOfCell = 19 * (pageNumber+1)
                                self.tblView .reloadData()
                                
                                break;
                            case 5:
                                if pageNumber == 0
                                {
                                    arrayJokesData.removeAllObjects()
                                    pageNumber = 0
                                    
                                }
                                for var i = 0 ; i < array.count ; i++
                                {
                                    let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                                    arrayJokesData.addObject(dictTemp)
                                    
                                }
                                lastIndexOfCell = 19 * (pageNumber+1)
                                self.tblView .reloadData()
                                break;
                            case 6:
                                if pageNumber == 0
                                {
                                    arrayTipsData.removeAllObjects()
                                    pageNumber = 0
                                    
                                }
                                for var i = 0 ; i < array.count ; i++
                                {
                                    let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                                    arrayTipsData.addObject(dictTemp)
                                    
                                }
                                lastIndexOfCell = 19 * (pageNumber+1)
                                self.tblView .reloadData()
                                break;
                            default :
                                break;
                            }
                        }
                        else
                        {
                            
                        }
                        
                    }

                } else {
                    print("not a dictionary")
                }
//            } else {
//               
//                print("Could not parse JSON: \(error!)")
//            }
//            
            }
            catch {
                print(error)
            }
        }
    
    
    
    
// MARK: -------------------------- CollectionView Delegate --------------
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPictureData.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath) as! PictureCell
        cell.backgroundColor = UIColor.clearColor()
        
        
        let dictTempt : NSDictionary = arrayPictureData.objectAtIndex(indexPath.row) as! NSDictionary
        
        if  dictTempt.objectForKey("picture_thumb") as? NSObject != NSNull()
        {
 
            let strUrl : NSURL = NSURL(string: dictTempt.objectForKey("picture_thumb")  as! String)!
            
            cell.imgPic.image = UIImage(named: "PlaceholderDown")
                
              ;
      
            cell.imgPic.imageURL = strUrl
        }
        return cell
    }
   
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
      //  let webVC : InAppWebViewController = InAppWebViewController(nibName : "InAppWebViewController" , bundle: nil)
        
        let shareFriendsVC : ShareMoodViewController = ShareMoodViewController(nibName : "ShareMoodViewController" , bundle : nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let open = UIAlertAction(title: "Open", style: .Default, handler: { (action) -> Void in
            let imgVC : ImageWithPageController = ImageWithPageController(nibName : "ImageWithPageController" , bundle : nil)
            imgVC.arrayData = self.arrayPictureData as [AnyObject]
            
            let indexNum : NSString = NSString(format: "%d",indexPath.row) as NSString
            imgVC.scrollToPage = indexNum as String
            
            self.presentViewController(imgVC, animated: true
                , completion: nil)
        })
        let share = UIAlertAction(title: "Share with Friends", style: .Default, handler: { (action) -> Void in
            shareFriendsVC.shareData = (self.arrayPictureData .objectAtIndex(indexPath.row) as? NSDictionary)!.objectForKey("picture_thumb") as? String
            shareFriendsVC.viewFromCome = "Share Picture"
            
            shareFriendsVC.ref_id  = (self.arrayPictureData .objectAtIndex(indexPath.row) as? NSDictionary)!.objectForKey("id") as? String
            shareFriendsVC.mediaType = "203"
            self.navigationController?.pushViewController(shareFriendsVC, animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        let  delete = UIAlertAction(title: "Report", style: .Destructive) { (action) -> Void in
            self.reportContent("1", contentId: ((self.arrayPictureData .objectAtIndex(indexPath.row) as? NSDictionary)! .objectForKey("id") as? String)!)
        }
        alertController.addAction(open)
        alertController.addAction(share)
        alertController.addAction(cancel)
        alertController.addAction(delete)
        
        presentViewController(alertController, animated: true, completion: nil)
 
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
      
        let lastIndexPath : NSIndexPath = NSIndexPath(forItem: lastIndexOfCell, inSection: 0)
        
        if indexPath.row == lastIndexPath.row
        {
            pageNumber = pageNumber + 1
            self.getAllData()
     
        }
        
        
    }
    
    

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(97, 97)
    }
    
// MARK: -------------------------- TableView ------------------
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var count : Int!
        switch mmType
        {
        case 1 :
            count = arraySongData.count
            break;
  
        case 3 :
            count = arrayQuotesData.count
            break;
        case 4 :
            count = arrayVideoData.count
            break;
        case 5 :
             count = arrayJokesData.count
            break;
        case 6 :
             count = arrayTipsData.count
            break;
        default :
            count = 0
            break;
        }

       
        return count
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "MMTableCell"
        var cell: MMTableCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? MMTableCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "MMTableCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MMTableCell
        }
        
       
        
        switch mmType
        {
            
            case 1 :
            let dictTempt : NSDictionary = arraySongData.objectAtIndex(indexPath.row) as! NSDictionary
            
            let str : String  = dictTempt.objectForKey("title") as! String
            if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
            {
                let data : NSData = dictTempt.objectForKey("title")!.dataUsingEncoding(NSUTF8StringEncoding)!
                let txtString : String = String(data: data, encoding: NSUTF8StringEncoding)!
                cell.lblReadData.text = txtString
            }
            else
            {
                cell.lblReadData.text = str
            }

            cell.icon.image = UIImage(named: "songicon")
            break;
            case 3 :
                 let dictTempt : NSDictionary = arrayQuotesData.objectAtIndex(indexPath.row) as! NSDictionary
                 let str : String  = dictTempt.objectForKey("quote") as! String
                 if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
                 {
                    let data : NSData = dictTempt.objectForKey("quote")!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let txtString : String = String(data: data, encoding: NSASCIIStringEncoding)!
                    cell.lblReadData.text = txtString
 
                 }
                 else
                 {
                    cell.lblReadData.text = str
                 }
                cell.icon.image = UIImage(named: "quote")
            break;
            
        case 4 :
            let dictTempt : NSDictionary = arrayVideoData.objectAtIndex(indexPath.row) as! NSDictionary
            
            
            
            let str : String  = dictTempt.objectForKey("title") as! String
            if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
            {
                let data : NSData = dictTempt.objectForKey("title")!.dataUsingEncoding(NSUTF8StringEncoding)!
                let txtString : String = String(data: data, encoding: NSUTF8StringEncoding)!
                cell.lblReadData.text = txtString
            }
            else
            {
                cell.lblReadData.text = str
            }
            cell.icon.image = UIImage(named: "videoicon")
            break;
            case 5 :
                 let dictTempt : NSDictionary = arrayJokesData.objectAtIndex(indexPath.row) as! NSDictionary
                 
                 let str : String  = dictTempt.objectForKey("joke") as! String
                 if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
                 {
                    let data : NSData = dictTempt.objectForKey("joke")!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let txtString : String = String(data: data, encoding: NSNonLossyASCIIStringEncoding)!
                    cell.lblReadData.text = txtString
                    
                 }
                 else
                 {
                    cell.lblReadData.text = str
                 }

                  cell.icon.image = UIImage(named: "joke")
            break;
            case 6 :
                 let dictTempt : NSDictionary = arrayTipsData.objectAtIndex(indexPath.row) as! NSDictionary
                 let str : String  = dictTempt.objectForKey("tip") as! String
                 if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
                 {
                    let data : NSData = dictTempt.objectForKey("tip")!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let txtString : String = String(data: data, encoding: NSNonLossyASCIIStringEncoding)!
                    cell.lblReadData.text = txtString
                    
                 }
                 else
                 {
                    cell.lblReadData.text = str
                 }

                  cell.icon.image = UIImage(named: "tip")
            break;
            default :
            break;
        }

      
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor=UIColor .clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        // println("%@",section())
        return cell
    }
    
    func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        let lastIndexPath : NSIndexPath = NSIndexPath(forRow: lastIndexOfCell, inSection: 0)
        if indexPath.row == lastIndexPath.row
        {
          
                pageNumber = pageNumber + 1
                self.getAllData()
                
        }
    }
      func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        itemNumb = indexPath.row
        let mmVC : MMSubViewController = MMSubViewController(nibName : "MMSubViewController" , bundle : nil)
          mmVC.viewComeFrom = "multiMedia"
         mmVC.counter = indexPath.row
        
         let webVC : InAppWebViewController = InAppWebViewController(nibName : "InAppWebViewController" , bundle: nil)
        
          let shareFriendsVC : ShareMoodViewController = ShareMoodViewController(nibName : "ShareMoodViewController" , bundle : nil)
        
        switch mmType
        {
        case 1 :
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let open = UIAlertAction(title: "Open", style: .Default, handler: { (action) -> Void in
                let str = (self.arraySongData .objectAtIndex(self.itemNumb) as? NSDictionary)! .objectForKey("song_link") as? String
                webVC.urlString = str
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            let share = UIAlertAction(title: "Share with Friends", style: .Default, handler: { (action) -> Void in
                shareFriendsVC.shareData = (self.arraySongData .objectAtIndex(self.itemNumb) as? NSDictionary)!.objectForKey("song_link") as? String
                shareFriendsVC.viewFromCome = "Share Song"
                shareFriendsVC.mediaType = "205"
                shareFriendsVC.ref_id  = (self.arraySongData .objectAtIndex(self.itemNumb) as? NSDictionary)!.objectForKey("id") as? String
                self.navigationController?.pushViewController(shareFriendsVC, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                print("Cancel Button Pressed")
            })
            let  delete = UIAlertAction(title: "Report", style: .Destructive) { (action) -> Void in
                 self.reportContent("3", contentId: ((self.arraySongData .objectAtIndex(self.itemNumb) as? NSDictionary)! .objectForKey("id") as? String)!)
            }
            alertController.addAction(open)
            alertController.addAction(share)
            alertController.addAction(cancel)
            alertController.addAction(delete)
            
            presentViewController(alertController, animated: true, completion: nil)
 
            break ;
            
            
        case 3 :
            mmVC.dict = arrayQuotesData.objectAtIndex(indexPath.row) as? NSDictionary
            mmVC.type = "Quote"
             mmVC.arrayData = arrayQuotesData
          
            self.navigationController?.pushViewController(mmVC, animated: true)
            
            
            break;
            
            
        case 4 :
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            let open = UIAlertAction(title: "Open", style: .Default, handler: { (action) -> Void in
                let str = (self.arrayVideoData .objectAtIndex(self.itemNumb) as? NSDictionary)! .objectForKey("video_link") as? String
                webVC.urlString = str
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            let share = UIAlertAction(title: "Share with Friends", style: .Default, handler: { (action) -> Void in
                shareFriendsVC.shareData = (self.arrayVideoData .objectAtIndex(self.itemNumb) as? NSDictionary)!.objectForKey("video_link") as? String
                shareFriendsVC.viewFromCome = "Share Video"
                
                shareFriendsVC.ref_id  = (self.arrayVideoData .objectAtIndex(self.itemNumb) as? NSDictionary)!.objectForKey("id") as? String
                shareFriendsVC.mediaType = "207"
                self.navigationController?.pushViewController(shareFriendsVC, animated: true)
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                print("Cancel Button Pressed")
            })
            let  delete = UIAlertAction(title: "Report", style: .Destructive) { (action) -> Void in
                self.reportContent("5", contentId: ((self.arrayVideoData .objectAtIndex(self.itemNumb) as? NSDictionary)! .objectForKey("id") as? String)!)
            }
            alertController.addAction(open)
            alertController.addAction(share)
            alertController.addAction(cancel)
            alertController.addAction(delete)
            
            presentViewController(alertController, animated: true, completion: nil)
            break ;
            
        case 5 :
            mmVC.dict = arrayJokesData.objectAtIndex(indexPath.row) as? NSDictionary
            mmVC.type = "Joke"
             mmVC.arrayData = arrayJokesData
            self.navigationController?.pushViewController(mmVC, animated: true)

            break;
        case 6 :
            mmVC.dict = arrayTipsData.objectAtIndex(indexPath.row) as? NSDictionary
           
            mmVC.type = "Tip"
            mmVC.arrayData = arrayTipsData
            self.navigationController?.pushViewController(mmVC, animated: true)
            break;
        default :
            
            break;
        }
     
        

    }
    
}
