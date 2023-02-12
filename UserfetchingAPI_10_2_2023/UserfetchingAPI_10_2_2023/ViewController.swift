//
//  ViewController.swift
//  UserfetchingAPI_10_2_2023
//
//  Created by Mac on 10/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userTableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableviewDelegateAndDatasource()
       registerXib()
       fetchingAPI()
    }
    func tableviewDelegateAndDatasource(){
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    func registerXib(){
        let uiNib = UINib(nibName: "userTableViewCell", bundle: nil)
        self.userTableView.register(uiNib, forCellReuseIdentifier: "userTableViewCell")
    }
    func fetchingAPI(){
        let urlString = "https://jsonplaceholder.typicode.com/users"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        var session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request){ data , response , error in
            print("Data -- \(data)")
            print("Response -- \(response)")
            print("Error -- \(error)")
            
            var getJSONObject = try! JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
            
            for dictionary in getJSONObject{
                let eachDictionary = dictionary as [String : Any]
                let userid = eachDictionary["id"] as! Int
                let uname = eachDictionary["name"] as! String
                let UserName = eachDictionary["username"] as! String
                let uemail = eachDictionary["email"] as! String
                
                var newUser = User(id: userid, name: uname, username: UserName, email: uemail)
                self.users.append(newUser)
            }
        DispatchQueue.main.async {
            self.userTableView.reloadData()
        }
        }
        dataTask.resume()
}
}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    }

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.userTableView.dequeueReusableCell(withIdentifier: "userTableViewCell", for: indexPath) as! userTableViewCell
        var eachUser = users[indexPath.row]
        cell.idlbl.text = "\(eachUser.id)"
        cell.namelbl.text = eachUser.name
        cell.usernamelbl.text = eachUser.username
        cell.emaillbl.text = eachUser.email
        
        return cell
        
    }
    
}
