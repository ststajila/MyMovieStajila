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
    var defaults =  UserDefaults.standard
    var alertController = UIAlertController(title: "Hey", message: "The movie is already in your favorites!", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)

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
    
    
    @IBAction func saveAction(_ sender: Any) {
        
        if isInFavorite(movieArray: SelectedMovieInfo.favoriteMovie, ID: SelectedMovieInfo.selectedMovie!.imdbID){
            SelectedMovieInfo.favoriteMovie.append(SelectedMovieInfo.selectedMovie!)
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(SelectedMovieInfo.favoriteMovie) {
                UserDefaults.standard.set(encoded, forKey: "favoriteMovie")
            }
        } else{
            present(alertController, animated: true)
        }
    }
    
    func isInFavorite(movieArray: [MovieSearch], ID: String) -> Bool{
        for movie in movieArray{
            if movie.imdbID == ID{
                return false
            }
        }
        return true
    }
    
}
