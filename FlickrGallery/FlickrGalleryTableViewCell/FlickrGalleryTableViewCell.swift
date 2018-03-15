//
//  FlickrGalleryTableViewCell.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 11/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import UIKit

class FlickrGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 15, y: 60, width: 100, height: 100)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    func configure(_ item: FlickrGalleryTableViewCellViewModel) {
        titleLabel.text = item.title
        authorLabel.text = item.author
        dateTakenLabel.text = item.getDateAsString(.dateTaken)
        datePublishedLabel.text = item.getDateAsString(.datePublished)
        tagsLabel.text = item.tags
        
        // set image to nil to avoid showing old image in reused cells, while the right one is still being downloaded
        imageView?.image = nil
    }
    
    func updateImage(_ image: UIImage) {
        imageView?.image = image
        layoutIfNeeded()
        layoutSubviews()
    }
}
