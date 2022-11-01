//
//  DetailedViewController.swift
//  ChanLee-lab4
//
//  Created by 이찬 on 10/22/22.
//

import UIKit

class DetailedViewController: UIViewController {
    var image: UIImage!
    var imageName: String!
    var voteAverage: Double!
    var releaseDate: String!
    var votes: Int!
    var id: Int!
    let dict : NSMutableDictionary = [: ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let theImageFrame = CGRect(x: view.frame.size.width*0.25, y: 100, width: view.frame.size.width*0.5, height: view.frame.size.height*0.3)

        let imageView = UIImageView(frame: theImageFrame)
        imageView.image = image
        
        view.addSubview(imageView)
        
        // set navbar title
        self.title = imageName
        
        
        let theReleaseDateTextFrame = CGRect(x: 0, y: view.frame.size.height*0.3 + 100, width: view.frame.width, height: 30)
        let releaseDateTextView = UILabel(frame: theReleaseDateTextFrame)
        releaseDateTextView.text = "Released: " + releaseDate
        releaseDateTextView.textAlignment = .center
        view.addSubview(releaseDateTextView)
        
        let theVoteAverageTextFrame = CGRect(x: 0, y: view.frame.size.height*0.3 + 200, width: view.frame.width, height: 30)
        let voteAvgTextView = UILabel(frame: theVoteAverageTextFrame)
        voteAvgTextView.text = "Votes Average: " + String(voteAverage)
        voteAvgTextView.textAlignment = .center
        view.addSubview(voteAvgTextView)
        

        
        let theVotesTextFrame = CGRect(x: 0, y: view.frame.size.height*0.3 + 300, width: view.frame.width, height: 30)
        let voteTextView = UILabel(frame: theVotesTextFrame)
        voteTextView.text = "Votes: " + String(votes)
        voteTextView.textAlignment = .center
        view.addSubview(voteTextView)
        
        let addFavoritesBtn = UIButton()
        addFavoritesBtn.setTitle("Add To Favorites", for: .normal)
        addFavoritesBtn.setTitleColor(.blue, for: .normal)
        addFavoritesBtn.frame = CGRect(x: view.frame.width*0.25, y: view.frame.size.height*0.3 + 400, width: view.frame.width*0.5, height: 30)
        addFavoritesBtn.layer.borderWidth = 1
        addFavoritesBtn.layer.borderColor = UIColor.blue.cgColor
        addFavoritesBtn.addTarget(self, action: #selector(addFavorites), for: .touchUpInside)
        view.addSubview(addFavoritesBtn)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func addFavorites() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let path = documentPath.description.appendingFormat("/movies.plist")
        let favMoviesDict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path)!
        favMoviesDict.setValue(id, forKey: imageName)
        favMoviesDict.write(toFile: path, atomically: false)
        print("fav dict is \(favMoviesDict)")
        
        
        
        
        
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
