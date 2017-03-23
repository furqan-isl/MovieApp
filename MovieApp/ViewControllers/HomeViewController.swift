//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Furqan on 3/23/17.
//  Copyright © 2017 Furqan. All rights reserved.
//

import UIKit
import AlamofireImage


enum DisplayMode: Int {
    case searchResults, suggestions
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet var tableviewMovies: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var currentDisplayMode = DisplayMode.suggestions
    var moviesList = [Movie]()
    var isDataUpdateRequire = true
    
    //MARK:- Private Methods
    
    func updateResults() {
        if searchBar.text != "" {
            updateMoviesList(queryStr: searchBar.text!)
        }
    }
    
    func updateMoviesList(queryStr: String) {
        currentDisplayMode = .searchResults
        
        WebserviceManager.shared.getMoviesList(query: queryStr) { [weak self] (responseTuple: ResponseTuple) in
            
            self?.refreshControl.endRefreshing()
            if responseTuple.success == true {
                //Success
                print("successfully get usate data")
                let json = responseTuple.responseDictionary
                print("json : \(json)")
                if let results = json?["results"].array {
                    if results.count > 0 {
                        self?.moviesList.removeAll()
                        for result in results {
                            let movie = Movie(json: result)
                            self?.moviesList.append(movie)
                        }
                        
                        
                        DispatchQueue.main.async {
                            self?.tableviewMovies.reloadData()
                        }
                        
                        //Suggestion update
                        if DataModelManager.shared.suggestionsList.count > 0 {
                            var isAlreadyFound = false
                            for str in DataModelManager.shared.suggestionsList {
                                if queryStr == str {
                                    isAlreadyFound = true
                                }
                            }
                            
                            if isAlreadyFound == false {
                                DataModelManager.shared.suggestionsList.append(queryStr)
                            }
                        }
                        else {
                            DataModelManager.shared.suggestionsList.append(queryStr)
                        }

                    }
                    else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "", message: "no result is found!")
                        }
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.showAlert(title: "", message: responseTuple.message)
                }
            }
        }
    }
    
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func setupPullToRefresh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.updateResults), for: UIControlEvents.valueChanged)
        tableviewMovies.addSubview(refreshControl)
    }
    
    //Pull to refresh - update data
    var refreshControl: UIRefreshControl!
    
    
    
    //MARK:- UITableView Datasource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentDisplayMode == .suggestions {
            return DataModelManager.shared.suggestionsList.count
        }
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
//        cell.textLabel?.text = "Movie"
        
        if currentDisplayMode == .suggestions {

            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
            let suggestion = DataModelManager.shared.suggestionsList[indexPath.row]
            cell.textLabel?.text = suggestion
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = moviesList[indexPath.row]
        cell.lblName.text = movie.name
        cell.lblReleaseDate.text = movie.releaseDate
        cell.lblOverview.text = movie.overview
        if movie.posterUrl != nil {
            cell.imgViewPoster.af_setImage(withURL: URL(string: movie.posterUrl!)!)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if currentDisplayMode == .suggestions {
            let suggestion = DataModelManager.shared.suggestionsList[indexPath.row]
            searchBar.text = suggestion
            searchBar.resignFirstResponder()
            updateMoviesList(queryStr: suggestion)
        }
    }
    
    
    //MARK:- UISearchBar Delegate
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        updateMoviesList(queryStr: searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        currentDisplayMode = .suggestions
        tableviewMovies.reloadData()
    }
    
    //MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableviewMovies.estimatedRowHeight = 228
        tableviewMovies.rowHeight = UITableViewAutomaticDimension
        tableviewMovies.tableFooterView = UIView()
        setupPullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if isDataUpdateRequire {
//            updateMoviesList(queryStr: "batman")
//            isDataUpdateRequire = false
//        }
        
        
//        tableviewMovies.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
