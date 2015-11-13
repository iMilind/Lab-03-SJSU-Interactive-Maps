//
//  BuidlingImageViewController.swift
//  Lab03
//
//  Created by Milind Mahajan on 10/29/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

import UIKit

class BuidlingImageViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var buildingTitleLabel: UILabel!
	
	
	var building : Building!;
	
	
	/**************************************************************************************************
										View Controller Lifecycle
	**************************************************************************************************/
	
	override func viewDidLoad() {

		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false;
    }
	
	override func viewDidAppear(animated: Bool) {
		
		let backgroundImage : UIImage = UIImage(imageLiteral: building.imageName);
		self.imageView.image = backgroundImage;
		self.imageView.layer.borderWidth = 2.0;
		self.imageView.layer.borderColor = UIColor.whiteColor().CGColor;
		
		self.buildingTitleLabel.text = building.name;
		
		self.title = building.name;
	}

    override func didReceiveMemoryWarning() {

		super.didReceiveMemoryWarning()
    }
	
	
	/**************************************************************************************************
										UIScrollViewDelegate
	**************************************************************************************************/

	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		
		return imageView;
	}
}