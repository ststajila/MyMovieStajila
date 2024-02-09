//
//  SavedMoviesViewController.swift
//  MyMovieStajila
//
//  Created by Stanislav Stajila on 2/8/24.
//

import UIKit

class SavedMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedMovieInfo.favoriteMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! CustomCell
        
        cell.titleOutlet.text = SelectedMovieInfo.favoriteMovie[indexPath.row].Title
        
        cell.yearOutlet.text = "Year: \(SelectedMovieInfo.favoriteMovie[indexPath.row].Year)"
        
        cell.titleOutlet.text = SelectedMovieInfo.favoriteMovie[indexPath.row].Title
        
        cell.typeOutlet.text = "Type: \(SelectedMovieInfo.favoriteMovie[indexPath.row].Type)"
        
        //cell.imbdIDOutlet.text = SelectedMovieInfo.favoriteMovie[indexPath.row].imdbID
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: SelectedMovieInfo.favoriteMovie[indexPath.row].Poster)!){
            (data: Data?, response: URLResponse?,error: Error?) in
            if let e = error{
                print("Error: \(e)")
            }else{
                if let d = data{
                    DispatchQueue.main.async{
                        cell.posterOutlet.image = UIImage(data: d)
                        }
                    }
                    }
            }
        dataTask.resume()
        
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
        {
            if editingStyle == .delete {
                SelectedMovieInfo.favoriteMovie.remove(at: indexPath.row)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(SelectedMovieInfo.favoriteMovie) {
                    UserDefaults.standard.set(encoded, forKey: "favoriteMovie")
                }
                tableView.reloadData()
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = "\(SelectedMovieInfo.favoriteMovie[indexPath.row].Title) (\(SelectedMovieInfo.favoriteMovie[indexPath.row].Year))"
        print("Copied")
    }
    
}
