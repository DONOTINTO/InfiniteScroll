//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by 이중엽 on 2023/05/19.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    let arr = Array<Int>(0...200)
    var actualData: [Int] = []
    let limit: Int = 123
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.prefetchDataSource = self
        
        actualData = Array<Int>(0...20)
    }
    
    func update() {
        // 함수가 호출될 때 마다 actualData에 10개씩 추가되는 로직
        guard let last = actualData.last else { return }
        
        if (limit + 1) != actualData.count {
            let start = last + 1
            var end = last + 10
            
            if end > last {
                end = limit
            }
            
            actualData.append(contentsOf: arr[start...end])
            myTableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actualData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        let item = actualData[indexPath.row]
        cell.myLabel.text = "\(item)"
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        update()
    }
}
