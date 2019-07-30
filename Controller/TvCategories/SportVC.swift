//
//  SportVC.swift
//  Baghdad-Link
//
//  Created by Mohammed Jamal on 5/19/18.
//  Copyright © 2018 Mohammed Jamal. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Foundation
import AVKit

class SportVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    var Sports = [Sport]()
    
    //variables
    var myInt = Int()
    
    
    @IBOutlet weak var TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.getSportApiData()
        self.checkReachability()

        // Do any additional setup after loading the view.
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    @IBAction func backActionBtn(_ sender: Any) {
        //  previous view controller
        navigationController?.popViewController(animated: true)
        // root view controller
        // navigationController?.popToRootViewController(animated: true)
    }
    
    func getSportApiData(){
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = self.view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        self.view.addSubview(myActivityIndicator)
        
        
        
        
        //fetching data from web api
        Alamofire.request(SPORT_URL).responseJSON { response in
            
            //getting json
            if let json = response.result.value {
                print(json)
                
                let NewsArray : NSArray  = json as! NSArray
                // print(towersArray)
                //traversing through all elements of the array
                for i in 0..<NewsArray.count{
                    
                    //adding hero values to the hero list
                    self.Sports.append(Sport(
                        channels_name: (NewsArray[i] as AnyObject).value(forKey: "channels_name") as? String,
                        channels_rtmp: (NewsArray[i] as AnyObject).value(forKey: "channels_rtmp") as? String,
                        
                        channels_image: (NewsArray[i] as AnyObject).value(forKey: "channels_image") as? String
                    ))
                    
                }
                
                
                //displaying data in tableview
                self.TableView.reloadData()
                
                // Call stopAnimating() when need to stop activity indicator
                myActivityIndicator.stopAnimating()
                
                // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
                myActivityIndicator.hidesWhenStopped = true
                
                
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportTbVCell", for: indexPath) as! SportTbVCell
        
        
        //getting the sport for the specified position
        let sport: Sport
        sport = Sports[indexPath.row]
        
        // get image link
        let imageUrl: NSURL? = NSURL(string: sport.channels_image!)
        
        DispatchQueue.main.async {
            //your main thread
            
            
            
            // Display image in cell
            cell.Imageview.sd_setImage(with: imageUrl! as URL, completed: nil)
        }
        
        
        return cell
       
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myInt = indexPath.row
        print(myInt)
       
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = self.view.center
        
        myActivityIndicator.backgroundColor = UIColor.black
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        self.view.addSubview(myActivityIndicator)
        
        
        //fetching data from web api
        Alamofire.request(SPORT_URL).responseJSON { response in
            
            //getting json
            if let json = response.result.value {
                print(json)
                
                let NewsArray : NSArray  = json as! NSArray
        
        
                let tv_url =  (NewsArray[self.myInt] as AnyObject).value(forKey: "channels_rtmp") as? String
        
        print(tv_url!)
                let videoURL = URL(string: tv_url!)
        
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
            
            // Call stopAnimating() when need to stop activity indicator
            myActivityIndicator.stopAnimating()
            
            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
            myActivityIndicator.hidesWhenStopped = true
        }
    }
    
    // Check Network Connection
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            print("User is connected to the internet via wifi.")
            
            getSportApiData()
            
            
            //fetch public ip string
     /*       Alamofire.request(my_publicIP).responseString { response in
                print("Success: \(response.result.isSuccess)")
                let my_ip = response.result.value!
                
                print("My Public IP: \(my_ip)")
                
                
                if my_ip == self.server_public_ip{
                    print("server IP : Display Main Page with movies and tvs")
                    
                    self.performSegue(withIdentifier: "OriginalPage", sender: nil)
                    
                    //let VC = self.storyboard?.instantiateViewController(withIdentifier: "OriginalIPViewController") as? OriginalIPViewController
                    //self.navigationController?.pushViewController(VC!, animated: true)
                    
                    
                    
                    //guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "OriginalIPViewController") else { return }
                    //let navController = UINavigationController(rootViewController: myVC)
                    
                    // self.navigationController?.present(navController, animated: true, completion: nil)
                    
                }else{
                    print("Mobile IP: Display Main page without movies and tvs")
                    
                    self.performSegue(withIdentifier: "DeviceIPVC", sender: nil)
                    //let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServerIPViewController") as? ServerIPViewController
                    //self.navigationController?.pushViewController(VC!, animated: true)
                }
            }
            */
            
            
        }else if currentReachabilityStatus == .reachableViaWWAN{
            
            print("User is connected to the internet via WWAN.")
            
            getSportApiData()
            
        /*    Alamofire.request(my_publicIP).responseString { response in
                print("Success: \(response.result.isSuccess)")
                let my_ip = response.result.value!
                
                print("My Public IP: \(my_ip)")
                
                
                if my_ip == self.server_public_ip{
                    print("server IP : Display Main Page with movies and tvs")
                    
                    self.performSegue(withIdentifier: "OriginalPage", sender: nil)
                    
                    //let VC = self.storyboard?.instantiateViewController(withIdentifier: "OriginalIPViewController") as? OriginalIPViewController
                    //self.navigationController?.pushViewController(VC!, animated: true)
                    
                    
                    
                    //guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "OriginalIPViewController") else { return }
                    //let navController = UINavigationController(rootViewController: myVC)
                    
                    // self.navigationController?.present(navController, animated: true, completion: nil)
                    
                }else{
                    print("Mobile IP: Display Main page without movies and tvs")
                    
                    self.performSegue(withIdentifier: "DeviceIPVC", sender: nil)
                    //let VC = self.storyboard?.instantiateViewController(withIdentifier: "ServerIPViewController") as? ServerIPViewController
                    //self.navigationController?.pushViewController(VC!, animated: true)
                }
            }
            */
            
        } else {
            print("There is no internet connection")
            
            // Alert User for No Connection
            let alert = UIAlertController(title: "تعذر الاتصال", message: "يرجى التحقق من اتصالك بالانترنت", preferredStyle: .alert)
            
            //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                print("Yay! Try Again!!")
                self.checkReachability()
            }))
            
            self.present(alert, animated: true)
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}