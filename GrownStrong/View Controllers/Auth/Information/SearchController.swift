//
//  SearchController.swift
//  GrownStrong
//
//  Created by Aman on 27/07/21.
//

import Foundation
import UIKit
import GooglePlaces

protocol SearchLocationControllerDelegate: class {
    func placeSelected(_ place: GMSPlace)
}

class SearchLocationController: UIViewController {

    var placesClient: GMSPlacesClient!
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var placeholder = ""
    weak var delegate: SearchLocationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        if placeholder != ""{
            searchController?.searchBar.placeholder = placeholder
        }
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = false
        searchController?.view.backgroundColor = .clear
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : AppTheme.defaultGreenColor], for: .normal)

    }

    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.isHidden = false
        setDarkStatusBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setLightStatusBar()
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getPlaces() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let nameLabel = place.name
                    let addressLabel = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    debugPrint("Place name -> \(String(describing: nameLabel))")
                    debugPrint("Place Adress -> \(String(describing: addressLabel))")
                }
            }
        })
    }
}

extension SearchLocationController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        delegate?.placeSelected(place)
        self.navigationController?.popViewController(animated: true)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
