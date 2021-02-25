//
//  MoviesViewController.swift
//  Flix
//
//  Created by Alex Shin on 2/18/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    // Create an array of dictionaries to store movies data
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            // Get results from the dataDictionary
            self.movies = dataDictionary["results"] as! [[String:Any]]
            self.tableView.reloadData()
           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        // Fetch movie title, synopsis and poster from results from the API
        let movie = movies[indexPath.row]
        
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // Populate each cell with movie title, synopsis and poster
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    override func prepare(for segue:
                            UIStoryboardSegue, sender: Any?) { //sender is the cell tapped on
        
        // Find the selected movie
        let cell = sender as! UITableViewCell // cell tapped on
        let indexPath = tableView.indexPath(for: cell)! // hey tableview, what is the indexpath for that cell
        let movie = movies[indexPath.row] // access the movies array
        
        // Pass the selected movie to the MovieDetailsViewController
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        // Deselect cell when coming back to tableView
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
