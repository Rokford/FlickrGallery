//
//  FlickrGalleryViewController.swift
//  FlickrGallery
//
//  Created by Grzegorz Izworski on 09/03/2018.
//  Copyright © 2018 Mobinaut. All rights reserved.
//

import UIKit

class FlickrGalleryViewController: UIViewController {
    var viewModel: FlickrGalleryViewModel?
    
    fileprivate let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupRefreshControl()

        viewModel?.downloadFlickrFeed()
    }
    
    fileprivate func setupViewModel() {
        if viewModel == nil {
            viewModel = FlickrGalleryViewModel()
        }
        
        viewModel?.delegate = self
    }
    
    fileprivate func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(clearSearchBarAndDownloadFlickrFeed(_:)), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageViewController"
        {
            if let destinationVC = segue.destination as? FlickrGalleryImageViewController{
                if let row = self.tableView.indexPathForSelectedRow?.row, let imageUrl = viewModel?.flickrGalleryItems[row].imageUrl {
                    if let image = viewModel?.getCachedFlickrFeedImage(forUrl: imageUrl) {
                        destinationVC.image = image
                    }
                }
            }
        }
    }
    
    @objc private func clearSearchBarAndDownloadFlickrFeed(_ sender: Any) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        viewModel?.downloadFlickrFeed()
    }
    
    @IBAction func sortingButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: String.sortAlertMessage, preferredStyle: .actionSheet)
        
        let sortByDateTakenAction = UIAlertAction(title: String.sortByDateTakenMessage, style: .default) { action in
            self.viewModel?.sortFlickrGalleryItemsByDate(field: .dateTaken, ordering: .orderedDescending)
            self.tableView.reloadData()
        }
        alertController.addAction(sortByDateTakenAction)
        
        let sortByDatePublishedAction = UIAlertAction(title: String.sortByDatePublishedMessage, style: .default) { action in
            self.viewModel?.sortFlickrGalleryItemsByDate(field: .datePublished, ordering: .orderedDescending)
            self.tableView.reloadData()
        }
        alertController.addAction(sortByDatePublishedAction)
        
        let cancelAction = UIAlertAction(title: String.cancelSortAlertTitle, style: .cancel) {
            action in
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

extension FlickrGalleryViewController: FlickrGalleryViewModelDelegate {
    func refreshList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func showDownloadError(_ error: NSError) {
        let alert = UIAlertController(title: "Error", message: "Error while downloading data: code: \(error.code), domain: \(error.domain)", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        
    }
}

extension FlickrGalleryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterFlickrGalleryItems(byText: searchText)
        tableView.reloadData()
    }
}

extension FlickrGalleryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = self.viewModel else {
            return 0
        }
        
        return model.flickrGalleryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! FlickrGalleryTableViewCell
        
        cell.selectionStyle = .none
        
        if let model = self.viewModel {
            let item = model.flickrGalleryItems[indexPath.row]
            cell.configure(item)
            
            viewModel?.getFlickrFeedImage(for: item.imageUrl) {
                image in
                DispatchQueue.main.async {
                    // make sure the cell is visible
                    if let updateCell = tableView.cellForRow(at: indexPath) as? FlickrGalleryTableViewCell, let image = image {
                        updateCell.updateImage(image)
                    }
                }
            }
        }
        
        return cell
    }
}

