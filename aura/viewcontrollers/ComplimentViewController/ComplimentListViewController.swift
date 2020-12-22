//
//  ComplimentListViewController.swift
//  Aura
//
//  Created by necixy on 01/02/16.
//  Copyright © 2016 necixy. All rights reserved.
//

import UIKit

class ComplimentListViewController: UIViewController,NSURLConnectionDelegate  {

    @IBOutlet var tblView: UITableView!
    var pageNumber : Int!
    var data = NSMutableData()

    var lastIndexOfCell : Int!
    var getOldCompConn : NSURLConnection!
    var arrayData : NSMutableArray = []
    var tempData : NSMutableArray = []
     var refreshControl:UIRefreshControl!
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
        headerLbl.text = "Compliment"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        tblView.tableFooterView=UIView(frame: CGRectZero)

      
        pageNumber = 0
          MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.getMultipleCompliments()
        //------------------- Pull to refresh
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Please wait...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
           self.tblView.addSubview(refreshControl)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMultipleCompliments()
    {
        
      
        var strUrl : NSString!
        
        strUrl = NSString(format: "%@user/compliments?page=%d",self.basicUrl(),pageNumber)
        
        
        let searchURL : NSURL = NSURL(string: strUrl as String)!
        let request = NSURLRequest(URL: searchURL)
        getOldCompConn = NSURLConnection(request: request, delegate: self, startImmediately: true)
        getOldCompConn.start()
        self.data.setData(NSData())
        
        
    }
// MARK: --------------- Pull to refresh
    func refresh(sender:AnyObject)
    {
        pageNumber = 0
        self.getMultipleCompliments()
        self.refreshControl.endRefreshing()
        
    }
// MARK: --------------- SlideNavigationController
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
       
        return true
    }

// MARK: --------------- NSURL Connection Delegate
    
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
        do
        {
            if let jsonResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers) {
                
                let statusCode = jsonResult.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    if pageNumber == 0
                    {
                        arrayData.removeAllObjects()
                        pageNumber = 0
                        
                    }
                    lastIndexOfCell = 99 * (pageNumber+1)
                    //Change : Added extra code to suffle array. Previous code is commented
                    //tempData   = jsonResult.objectForKey("details") as! NSMutableArray
                    
                    let arrayFromServer : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
                    tempData = self.shuffle(arrayFromServer.mutableCopy() as! NSMutableArray)
                    
                        if tempData.count > 0
                        {
                            
                            for var i = 0 ; i < tempData.count ; i++
                            {
                                
                                    arrayData.addObject(tempData.objectAtIndex(i))
                                
                            }
                    
                            tblView.reloadData()
                        }
                
                
            }
            
        }
        }
        catch
        {
            print(error)
        }
    
    }
    // MARK: --------------- Suffle records
    func shuffle(arrayToSuffle:NSMutableArray) -> NSMutableArray
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

    // MARK: -------------------------- TableView ------------------
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                 return arrayData.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "MMTableCell"
        var cell: MMTableCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? MMTableCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "MMTableCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MMTableCell
        }
        
        let tempDict : NSDictionary = arrayData.objectAtIndex(indexPath.row) as! NSDictionary
            
    
        let str : String  = tempDict.objectForKey("content") as! String
        if str.canBeConvertedToEncoding(NSASCIIStringEncoding)
        {
            let data : NSData = tempDict.objectForKey("content")!.dataUsingEncoding(NSUTF8StringEncoding)!
            let txtString : String = String(data: data, encoding: NSUTF8StringEncoding)!
            cell.lblReadData!.text = txtString
            
        }
        else
        {
            cell.lblReadData!.text = str
        }
        cell.icon.image = UIImage(named: "compliment_icon")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor=UIColor .clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
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
            self.getMultipleCompliments()
            
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         let mmVC : ComplimentViewController = ComplimentViewController(nibName : "ComplimentViewController" , bundle : nil)
        mmVC.hasComeDash    = false
        mmVC.zumpTo = indexPath.row
        mmVC.arrayData = arrayData
        self.navigationController?.pushViewController(mmVC, animated: true)
          }


}
