//
//  HomeViewController.swift
//  Aura
//
//  Created by necixy on 05/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController ,SlideNavigationControllerDelegate {

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
               headerLbl.text="Home"
               headerLbl.font=UIFont(name: "PetitaMedium", size: 22)
               headerView.addSubview(headerLbl)
        
        
                print("%@",self.navigationController);
        
      
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.shadowImage=UIImage(contentsOfFile: "")
        
    }
    // Mark: - SlideNavigationController Methods -
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
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
