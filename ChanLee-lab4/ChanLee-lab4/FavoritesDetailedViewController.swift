//
//  FavoritesDetailedViewController.swift
//  ChanLee-lab4
//
//  Created by 이찬 on 10/30/22.
//

import UIKit


class FavoritesDetailedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theMovie.count > 10 ? 10 : theMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = theMovie[indexPath.row].title
        return cell
    }
    
    
    struct APIResults:Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }
    
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String?
        let vote_average: Double
        let overview: String
        let vote_count:Int!
    }
    
    struct ReviewAPIResults:Decodable {
        let id: Int
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Review]
    }
    
    struct Review: Decodable {
        let author : String
        let content : String
        let created_at : String
    }
    
    var movieTitle:String!
    var movieId : Int = 0
    var theData: [APIResults] = []
    var theMovie: [Movie] = []
    var theReviewData : [ReviewAPIResults] = []
    var theReview : [Review] = []
    var tableView : UITableView!
    
    func fetchSimilarDataForTableView() {
        theMovie = []
        theData = []
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=a83d8351a7880fa05c8651c59be8b237&language=en-US&page=1")
        
        let data = try? Data(contentsOf: url!)
        let temp = try? JSONDecoder().decode(APIResults.self, from:data!)
        theData.append(temp!)
        for item in theData[0].results{
            theMovie.append(item)
        }
    }
    
    func fetchReviews() {
        theReview = []
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=a83d8351a7880fa05c8651c59be8b237&language=en-US&page=1")
        let data = try? Data(contentsOf: url!)
        let temp = try? JSONDecoder().decode(ReviewAPIResults.self, from: data!)
        theReview = temp!.results
        print(theReview)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func displayReviews() {
        print(theReview)
        if(theReview.isEmpty){
            let reviewLabelFrame = CGRect(x: 0, y: 400, width: view.frame.size.width, height: view.frame.size.height*0.1)
            let reviewLabelView = UILabel(frame: reviewLabelFrame)
            reviewLabelView.text = "No Reviews"
            reviewLabelView.textAlignment = .center

            view.addSubview(reviewLabelView)
        }
        else{
            let reviewLabelFrame = CGRect(x: 10, y: 410, width: view.frame.size.width*0.95, height: 200)
            let reviewLabelView = UILabel(frame: reviewLabelFrame)
                
            reviewLabelView.lineBreakMode = .byTruncatingTail;
            reviewLabelView.numberOfLines = 0
            let createdAt : String = theReview[0].created_at
            reviewLabelView.text = "Written By: " + theReview[0].author + "\n" + "Created At: " + createdAt + "\n" + "\"" + theReview[0].content + "\""
            reviewLabelView.textAlignment = .center
            view.addSubview(reviewLabelView)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchSimilarDataForTableView()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        fetchReviews()

        
        view.backgroundColor = UIColor.white
        let movieTitleFrame = CGRect(x: view.frame.size.width*0, y: 50, width: view.frame.size.width, height: view.frame.size.height*0.1)

        let titleView = UILabel(frame: movieTitleFrame)
        titleView.text = "Movie Title: " + movieTitle
        titleView.textAlignment = .center
        
        view.addSubview(titleView)
        
        let tableViewTitleFrame = CGRect(x: view.frame.size.width*0, y: 100, width: view.frame.size.width, height: view.frame.size.height*0.1)
        let labelView = UILabel(frame: tableViewTitleFrame)
        labelView.text = "Similar Movies"
        labelView.textAlignment = .center

        view.addSubview(labelView)
        
        let tableViewFrame = CGRect(x: view.frame.size.width*0, y: 110, width: view.frame.size.width, height: view.frame.size.height*0.25)

        tableView = UITableView(frame: tableViewFrame)
        setupTableView()
        view.addSubview(tableView)
        
        let reviewLabelFrame = CGRect(x: view.frame.size.width*0, y: 350, width: view.frame.size.width, height: view.frame.size.height*0.1)
        let reviewLabelView = UILabel(frame: reviewLabelFrame)
        reviewLabelView.text = "Review Top Comments:"
        reviewLabelView.textAlignment = .center

        view.addSubview(reviewLabelView)
        
        displayReviews()
        
        // set navbar title
        self.title = movieTitle
        
        
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
