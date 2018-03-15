//
//  ImageViewController.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 13/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import UIKit

class FlickrGalleryImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
}
