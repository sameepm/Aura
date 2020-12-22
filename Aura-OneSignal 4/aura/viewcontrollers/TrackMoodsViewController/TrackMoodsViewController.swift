//
//  TrackMoodsViewController.swift
//  Aura
//
//  Created by necixy on 30/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class TrackMoodsViewController: UIViewController , SlideNavigationControllerDelegate ,UITableViewDelegate , NSURLConnectionDelegate  {
   var refreshControl:UIRefreshControl!
    @IBOutlet weak var tblView: UITableView!
    var arrayData : NSMutableArray = []
    var data = NSMutableData()
    var appDel : AppDelegate!
    var pageNumber : Int!
    var lastPage : Int!
     var strId: NSString!
    
    var  lastSectionLastRow : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        pageNumber=0
         strId = userDefault.objectForKey("userId") as? NSString
       
        lastSectionLastRow = 10 * (pageNumber+1)
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
        headerLbl.text="Track My Moods"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
        
        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        // arrayData = appDel.arrHappiness
        
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
         self.getHappinessScore()
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Please wait...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tblView.addSubview(refreshControl)
        
        tblView.tableFooterView=UIView(frame: CGRectZero)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "onBackButton")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
       pageNumber = 0
        self.getHappinessScore()
        self.refreshControl.endRefreshing()
    }
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func convertDateFormater(date: String) -> String
    {
        
        let dateFormatter = NSDateFormatter()
        // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        
        
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        //  dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        
        return timeStamp
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Get Happiness Score For User
    func getHappinessScore()
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
            MBProgressHUD .hideHUDForView(self.view, animated: true)
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {
        
        let strUrl : NSString = NSString(format: "%@happiness/%@?page=%d",self.basicUrl(), strId!,pageNumber)
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
            conn!.start()
        self.data.setData(NSData())
        }
        
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        
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
      
        do
        {
        let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let statusCode = jsonResult.objectForKey("status") as? NSString
         self.data.setData(NSData())
        if statusCode == "200"
        {
            
            if pageNumber == 0
            {

                if arrayData.count > 0
                {
                self.arrayData.removeAllObjects()
                }
                // lastSectionLastRow = 11
            }
            
            
            let array : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
            for var i = 0 ; i < array.count ; i++
            {
                let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                //appDel.arrHappiness.addObject(dictTemp)
               arrayData.addObject(dictTemp)
                
            }
             lastSectionLastRow = 10 * (pageNumber+1)
          //  appDel.arrHappiness
            // arrayData = appDel.arrHappiness
            self.tblView .reloadData()
            print( appDel.arrHappiness)
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
       if( arrayData.count >= 0)
       {
        return arrayData.count
        }
        return 0;
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "Custom"
        
        var cell: TrackMoodsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? TrackMoodsTableViewCell
        
        if cell == nil {
            let viewController : UIViewController = UIViewController(nibName: "TrackMoodsTableViewCell", bundle: nil)
            
            cell = viewController.view as? TrackMoodsTableViewCell
            cell.selectionStyle=UITableViewCellSelectionStyle.None
            
                   }
        var dictionary : NSDictionary!
        let archivedData = NSUserDefaults.standardUserDefaults().objectForKey("userInfo") as! NSData
        dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData) as! NSDictionary
        
        if  dictionary.objectForKey("thumb") as? NSObject != NSNull()
        {
            let strUrl : NSURL = NSURL(string: dictionary.objectForKey("thumb")  as! String)!
            cell.imgUser.imageURL = strUrl
            cell.imgUser.image = UIImage(named: "userPlace")

                    }
    cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2
       cell.imgUser.layer.masksToBounds = true
    cell.imgMood.layer.cornerRadius = cell.imgMood.frame.size.width/2
        cell.imgMood.layer.masksToBounds = true
    cell.backgroundColor=UIColor .clearColor()
        
        let dataDict : NSDictionary = arrayData.objectAtIndex(indexPath.row) as! NSDictionary
        
        let dateString : String = self.convertDateFormater(dataDict.objectForKey("date") as! String)
        cell.lblDate.text = dateString

    
        let sclValue : String = dataDict.objectForKey("scale") as! String
        
        let a:Int? = Int(sclValue)
        let imgStr :String = appDel.moodAccordinghappinesScore(a!) as String
        let string : String = String(format: "%@_icon.png",imgStr)
       cell.lblMood.text = String(format: "You changed your mood to %@", imgStr)
        cell.imgMood.image = UIImage(named:  string)
        
        // println("%@",section())
        return cell
    }

    func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
//        
//        let lastSectionIndex = tableView.numberOfSections()-1
//        
//        if lastSectionLastRow >= arrayData.count
//        {
//            lastSectionLastRow = arrayData.count
//        }
//        lastSectionLastRow = tableView.numberOfRowsInSection(lastSectionIndex) - 1
//        let lastIndexPath = NSIndexPath(forRow:lastSectionLastRow, inSection: lastSectionIndex)
//      
//        let cellIndexPath = tableView.indexPathForCell(cell)
//        
//        if indexPath == lastIndexPath
//        {
////              var dataCount = arrayData.count * pageNumber
////            var  count = dataCount/11 - 1
////                            //lastPage =
////                 pageNumber = pageNumber + 1
//            
//                self.getHappinessScore()
//            lastSectionLastRow = 11 * pageNumber
//         
//        }
        
        
        let lastIndexPath : NSIndexPath = NSIndexPath(forRow: lastSectionLastRow, inSection: 0)
        
        
        if indexPath.row == lastIndexPath.row
        {
            pageNumber = pageNumber + 1
            self.getHappinessScore()            
            
        }

    }
        

}
