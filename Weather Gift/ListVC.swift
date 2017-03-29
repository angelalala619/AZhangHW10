//
//  ListVC.swift
//  Weather Gift
//
//  Created by Angela Zhang on 3/4/17.
//  Copyright © 2017 Angela Zhang. All rights reserved.
//

import UIKit
import GooglePlaces

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var locationsArray = [WeatherLocation] ()
    var currentPage = 0
    
    
    
    override func viewDidLoad() {
        print("A")
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        print("B")
    }
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPageVC" {
            let controller = segue.destination as! PageVC
            //Identify the table cell row that the user tapped.
            //THis is passed back to PageVC as currentPage, so that
            //PageVC knows whih
            currentPage = (tableView.indexPathForSelectedRow?.row)!
            controller.currentPage = currentPage
            controller.locationsArray = locationsArray
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPage = indexPath.row
        performSegue(withIdentifier: "ToPageVC", sender: self)
    }
    
    //MARK: - TableView Editing Functions
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //First Make a copy of the item that you are going to move
        let itemToMove = locationsArray[sourceIndexPath.row]
        //Delete item from the original location (pre-move)
        locationsArray.remove(at:sourceIndexPath.row)
        //Insert item into the "to", post-move, location
        locationsArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    //MARK: - TableView Code to Freeze the first cell
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row == 0 ? false : true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    func updateTable(_ place: GMSPlace) {
        let newLocation = WeatherLocation()
        newLocation.name = place.name
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        newLocation.coordinates = "\(lat),\(long)"
        print(newLocation.coordinates)
        locationsArray.append(newLocation)
        tableView.reloadData()
        
    }
}
extension ListVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.a
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        updateTable(place)

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}







