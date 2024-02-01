//
//  MoreInfoViewController.swift
//  MyMovieStajila
//
//  Created by STANISLAV STAJILA on 1/25/24.
//

import UIKit

class MoreInfoViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var typeOutlet: UILabel!
    @IBOutlet weak var yearOutlet: UILabel!
    @IBOutlet weak var imdbIDOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleOutlet.text = "Title: \(SelectedMovieInfo.selectedMovie!.Title)"
        typeOutlet.text = "Type: \(SelectedMovieInfo.selectedMovie!.Type)"
        yearOutlet.text = "Year: \(SelectedMovieInfo.selectedMovie!.Year)"
        imdbIDOutlet.text = "imdbID: \(SelectedMovieInfo.selectedMovie!.imdbID)"
        
        print("\(SelectedMovieInfo.selectedMovie!.Poster)")
        let dataTask = URLSession.shared.dataTask(with: URL(string: SelectedMovieInfo.selectedMovie!.Poster)!){
            (data: Data?, response: URLResponse?,error: Error?) in
            if let e = error{
                print("Error: \(e)")
            }else{
                if let d = data{          
                    DispatchQueue.main.async{
                            self.posterImageView.image = UIImage(data: d)
                            //self.posterImageView.image = UIImage(named: "Map")
                    print("YEAH")
                        }
                    }
                    }
            }
        dataTask.resume()
    }
}
