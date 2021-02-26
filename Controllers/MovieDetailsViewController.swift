//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Alex Shin on 2/25/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    // Store movie, its info and URL to trailer
    var movie: [String:Any]!
    var movieInfo = [[String:Any]]()
    var trailerUrl: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate title, synopsis, poster, and backdrop
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["overview"] as? String
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af.setImage(withURL: posterUrl!)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdropView.af.setImage(withURL: backdropUrl!)
        
        // Initiate tap gesture recognizer on poster
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        posterView.isUserInteractionEnabled = true
        posterView.addGestureRecognizer(tapGestureRecognizer)
        
        // Grab trailer url key from API
        let movieId = movie["id"] as! Int
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(Int(movieId))/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            // Get results from the dataDictionary and configure trailer URL via YouTube
            self.movieInfo = dataDictionary["results"] as! [[String:Any]]
            let movieKey = self.movieInfo[0]["key"] as! String
            self.trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(movieKey)")
           }
        }
        task.resume()
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
    }
    
    // Pass trailer URL to MovieTrailerViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieTrailerViewController = segue.destination as! MovieTrailerViewController
        movieTrailerViewController.trailerLink = trailerUrl
    }
}
