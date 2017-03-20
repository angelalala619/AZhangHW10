//
//  DeatilVC.swift
//  Weather Gift
//
//  Created by Angela Zhang on 3/4/17.
//  Copyright © 2017 Angela Zhang. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       locationLabel.text = locationsArray[currentPage]
    }

   }
