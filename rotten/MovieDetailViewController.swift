//
//  MovieDetailViewController.swift
//  rotten
//
//  Created by Prashant Bhartiya on 9/14/14.
//  Copyright (c) 2014 Prashant Bhartiya. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var movieSynopsis: String = ""
    var movieDetailImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synopsisLabel.text = movieSynopsis
        movieImage.image = movieDetailImage!
        
    }
}
