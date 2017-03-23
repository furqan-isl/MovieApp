//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Furqan on 3/23/17.
//  Copyright © 2017 Furqan. All rights reserved.
//

import UIKit


enum DisplayMode: Int {
    case searchResults, suggestions
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet var tableviewMovies: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    
    var moviesList = [Movie]()
    
    var isDataUpdateRequire = true
    
    //MARK:- Private Methods
    
    func updateResults() {
        refreshControl.endRefreshing()
    }
    
    
    func updateMoviesList(queryStr: String) {
        
        WebserviceManager.shared.getMoviesList(query: queryStr) { [weak self] (responseTuple: ResponseTuple) in
            
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
                    }
                }
                
            }
        }
    }
    
    
    private func setupPullToRefresh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.updateResults), for: UIControlEvents.valueChanged)
        tableviewMovies.addSubview(refreshControl)
    }
    
    //Pull to refresh - update data
    var refreshControl: UIRefreshControl!
    
    var currentDisplayMode = DisplayMode.searchResults
    
    
    //MARK:- UITableView Datasource/Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
//        cell.textLabel?.text = "Movie"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        return cell
    }
    
    
    //MARK:- UISearchBar Delegate
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    //MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
