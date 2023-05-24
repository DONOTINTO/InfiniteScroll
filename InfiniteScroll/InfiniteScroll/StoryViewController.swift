//
//  StoryViewController.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/05/19.
//

import UIKit

class StoryViewController: UIViewController {
    @IBOutlet weak var storyTableView: UITableView!
    var story = "The prince befriends a fox, who teaches him that the important things in life are visible only to the heart, that his time away from the rose makes the rose more special to him, and that love makes a person responsible for the beings that one loves. The little prince realizes that, even though there are many roses, his love for his rose makes her unique and that he is therefore responsible for her. Despite this revelation, he still feels very lonely because he is so far away from his rose. The prince ends his story by describing his encounters with two men, a railway switchman and a salesclerk."
    var storyList: [String] = []
    var actualList: [String] = []
    var perPage = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyTableView.delegate = self
        storyTableView.dataSource = self
        storyTableView.prefetchDataSource = self
        getBlogInfo(query: "123")
    }
    
    func update() {
        let start = actualList.count
        
        if storyList.count - 1 != perPage {
            perPage = perPage + 10
            
            if perPage > storyList.count {
                perPage = storyList.count - 1
            }
            
            actualList.append(contentsOf: storyList[start...perPage])
            storyTableView.reloadData()
        }
    }
    
    func getBlogInfo(query: String) {
        let baseURL = "https://dapi.kakao.com/v2/search/blog"
        let Authorization = "KakaoAK b201e75e24f51413d5e1b8707ca8231a"
        
        var url = URL(string: baseURL)
        url?.append(queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: "1")
        ])
        
        guard let url = url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(Authorization, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let kakao = try decoder.decode(Kakao.self, from: data)
                let kakaoData = kakao.documents
                
                DispatchQueue.main.sync {
                    self.story = kakaoData[0].contents
                    self.storyList = self.story.components(separatedBy: " ")
                    self.actualList.append(contentsOf: self.storyList[0...10])
                    self.storyTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
            print(response.statusCode)
        }.resume()
    }
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actualList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = storyTableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as? StoryTableViewCell else { return UITableViewCell() }
        cell.myLabel.text = "\(storyList[indexPath.row])"
        
        return cell
    }
}

extension StoryViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        update()
    }
}
