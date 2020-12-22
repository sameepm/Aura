//
//  SearchFriendsViewController.swift
//  Aura
//
//  Created by necixy on 19/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController, UITextFieldDelegate,   NSURLConnectionDelegate {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var pageNumber : Int!
    var lastPage : Int!
    var  lastSectionLastRow : Int!
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var lblNoRecordMsg: UILabel!
    var arraySearch : NSMutableArray = []
    var data = NSMutableData()
    var appDel : AppDelegate!
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
        headerLbl.text = "Search People"
        headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
        headerView.addSubview(headerLbl)
        
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "backBtn.png"), forState: .Normal)
        button.frame = CGRectMake(5, 5, 34, 34)
        
        button.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = button
        self.navigationItem.leftBarButtonItem = rightItem
       
        pageNumber=0
        lastSectionLastRow = 100
        self.tblView.tableFooterView = UIView(frame: CGRectZero)
        //------------ Table Refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Please wait...")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tblView.addSubview(refreshControl)
        
        
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
        self.searchFriends()
        self.refreshControl.endRefreshing()
    }
    
    func onBackButton()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - TextFiled Delegate Methode
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        lblNoRecordMsg.hidden = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtSearch .resignFirstResponder()
        
        if !txtSearch.text!.isEmpty
        {
        self.searchFriends()
        }
        return true;
        
    }
    
    
    
    @IBAction func clearTextField(sender: AnyObject) {
        txtSearch.text = ""
        txtSearch .resignFirstResponder()
        arraySearch.removeAllObjects()
        self.tblView.reloadData()
    }

    func searchFriends()
    {
        let isInternet : Bool = InternetAvailabiltyClass .checkInternetAvailablity()
        if isInternet == false
        {
          
            globalAlertView("Please check your internet connection", viewCont: self)
        }
        else
        {

        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let strUrl : NSString = NSString(format: "%@users/search/%@?page=%d",self.basicUrl(),txtSearch.text!,pageNumber)
        
       let escapedAddress = strUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
       
        
        let searchURL : NSURL = NSURL(string: escapedAddress! as NSString as String)!
        let request = NSURLRequest(URL: searchURL)
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
            conn?.start()
        self.data.setData(NSData())
        }
    }
    
// MARK: - NSURLConnection Delegate
    
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
        let jsonResult : AnyObject! = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.MutableContainers)
       let statusCode = jsonResult.objectForKey("status") as? NSString
                if statusCode == "200"
                {
                    
                    let array : NSArray = (jsonResult.objectForKey("details") as? NSArray)!
                    if (array.count > 0)
                    {
                        if(pageNumber==0)
                        {
                            self.arraySearch.removeAllObjects()
                        }
                        
                        lblNoRecordMsg.hidden = true
                        for var i = 0 ; i < array.count ; i++
                        {
                            let dictTemp : NSDictionary = array.objectAtIndex(i) as! NSDictionary
                            arraySearch.addObject(dictTemp)
                            
                        }
                          self.tblView.addSubview(refreshControl)
                    self.tblView .reloadData()
                    }
                    else
                    {
                        let str : String = String(format: "%@ not found.", self.txtSearch.text!)
                        lblNoRecordMsg.text = str
                        lblNoRecordMsg.hidden = false
                        self.refreshControl .removeFromSuperview()
                    }
                    
                }
        
        }
        catch
        {
            print(error)
        }
        
        
    }

    
// MARK: - TableView Method
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arraySearch.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0;
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "SearchFriendsCell"
        var cell: SearchFriendsCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? SearchFriendsCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SearchFriendsCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SearchFriendsCell
        }
        let dictData : NSDictionary = arraySearch.objectAtIndex(indexPath.row) as! NSDictionary
        cell.lblUserName.text = dictData.objectForKey("f_name") as? String
        cell.imgFrnds.layer.cornerRadius = cell.imgFrnds.frame.size.width/2
        cell.imgFrnds.layer.masksToBounds = true
        
        if  dictData.objectForKey("thumb") as? NSObject != NSNull()
        {
            let imgStr : String = String (format: "%@", dictData.objectForKey("thumb")  as! String )
            let strUrl : NSURL = NSURL(string: imgStr)!
           
            cell.imgFrnds.image = UIImage(named: "userPlace")
            cell.imgFrnds.imageURL = strUrl
    
        }
        else
        {
          cell.imgFrnds.image = UIImage(named: "userPlace")
        }
       

        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor=UIColor .clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
      
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tempDict : NSMutableDictionary = arraySearch.objectAtIndex(indexPath.row) as! NSMutableDictionary
       let otherUserProfileVC : OtherUserProfileViewController = OtherUserProfileViewController(nibName : "OtherUserProfileViewController" , bundle : nil)
        otherUserProfileVC.dictData = tempDict
        otherUserProfileVC.isFromSearch = true
        otherUserProfileVC.fromPendingReq = false
        otherUserProfileVC.userId = tempDict.objectForKey("id") as! String
        self.navigationController?.pushViewController(otherUserProfileVC, animated: true)
       
    }
    
    func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        
        let lastSectionIndex = tableView.numberOfSections-1
        
        if lastSectionLastRow >= arraySearch.count
        {
            lastSectionLastRow = arraySearch.count
        }
        else
        {
        lastSectionLastRow = tableView.numberOfRowsInSection(lastSectionIndex) - 1
        }
        let lastIndexPath = NSIndexPath(forRow:lastSectionLastRow, inSection: lastSectionIndex)
       // NSLog("lastSectionLastRow = %d",lastSectionLastRow)
        //let cellIndexPath = tableView.indexPathForCell(cell)
        
        // NSLog(" Index Path = %d",lastIndexPath)
        if(lastIndexPath == 0)
        {
            
        }
        else
        {
           
        if indexPath == lastIndexPath
        {
            pageNumber = pageNumber + 1
            
            self.searchFriends()
            lastSectionLastRow = 100 * pageNumber
            
        }
        }
    }


}
