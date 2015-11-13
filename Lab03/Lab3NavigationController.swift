//
//  Lab3NavigationController.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/30/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit

class Lab3NavigationController: UINavigationController {

	let leftLabel : UILabel = UILabel.init();
	let rightLabel : UILabel = UILabel.init();
	
	
	/**************************************************************************************************
										View Controller Lifecycle
	**************************************************************************************************/
    override func viewDidLoad() {

		super.viewDidLoad();

		leftLabel.frame = CGRectMake(5, 0, self.view.frame.size.width/2-10, self.toolbar.frame.size.height);
		leftLabel.text = "CmpE 277";
		leftLabel.textColor = UIColor.blackColor();
		leftLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18);
		
		self.toolbar.addSubview(leftLabel);

		rightLabel.frame = CGRectMake(self.view.frame.size.width/2+5, 0, self.view.frame.size.width/2-10, self.toolbar.frame.size.height);
		rightLabel.textAlignment = NSTextAlignment.Right;
		rightLabel.text = "Lab 03";
		rightLabel.textColor = UIColor.blackColor();
		rightLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18);

		self.toolbar.addSubview(rightLabel);
	}

    override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning()
    }
}