//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Deepak Thakur on 17/11/21.
//

import UIKit

class ViewController: UIViewController {
    public var searchBarController: UISearchController!
    let numberOfColumns: CGFloat = Constants.defaultColumnCount
    var viewModel = PhotosViewModel()
    var isFirstTimeActive = true
    let margin: CGFloat = 10
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        viewModelClosures()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeActive {
            searchBarController.isActive = true
            searchBarController.searchBar.becomeFirstResponder()
            isFirstTimeActive = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func showAlert(title: String = "Flickr", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController {
    
    fileprivate func configureUI() {
        createSearchBar()
        activityLoader.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        collectionView.delegate = self
        collectionView.dataSource = self
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionView.register(nib: ImageCollectionViewCell.nibName)
    }
}

extension ViewController {
    
    fileprivate func viewModelClosures() {
        viewModel.showAlert = { [self] (message) in
            self.searchBarController.isActive = false
            self.showAlert(message: message)
        }
        
        viewModel.dataUpdated = { [self] in
            self.collectionView.reloadData()
        }
    }
    
    private func loadNextPage() {
        viewModel.fetchNextPage { }
    }
}

extension ViewController: UISearchControllerDelegate, UISearchBarDelegate {
    private func createSearchBar() {
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.delegate = self
        searchBarController.searchBar.placeholder = Constants.searchPlaceHolder
        searchBarController.searchBar.isAccessibilityElement = true
        searchBarController.searchBar.accessibilityTraits = .searchField
        searchBarController.searchBar.accessibilityIdentifier = "search_bar"
        searchBarController.searchBar.delegate = self
        self.navigationItem.searchController = searchBarController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 1 else {
            return
        }
        activityLoader.isHidden = false
        viewModel.search(text: text) { [self] in
            print("search completed.")
            self.activityLoader.isHidden = true
            self.collectionView.reloadData()
        }
        searchBarController.searchBar.resignFirstResponder()
    }
    
}

//MARK:- UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.nibName, for: indexPath) as! ImageCollectionViewCell
        let model = viewModel.photoArray[indexPath.row]
        cell.model = ImageModel.init(withPhotos: model)
        
        if indexPath.row == (viewModel.photoArray.count - 10) {
            loadNextPage()
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfColumns - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfColumns))
        return CGSize(width: size, height: size)
    }
}




