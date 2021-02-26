//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by Alex Shin on 2/25/21.
//

import UIKit

class MovieTrailerViewController: UIViewController {
    @IBOutlet weak var trailerLabel: UILabel!
    var movieTitle: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailerLabel.text = movieTitle

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
