//
//  ViewController.swift
//  abhisht_reminderApp
//
//  Created by manjit on 28/10/23.
//

import UserNotifications
import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    //var for audio player
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    //for dark mode
    @IBOutlet weak var DarkModeSwitch: UISwitch!
    @IBOutlet var table: UITableView!
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        do{
            let audioPath1 = Bundle.main.path(forResource: "lalaland", ofType: "mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath1!) as URL)
        }
        catch
            {
                
            }
    }
    
    @IBAction func DarkModeAction(_ sender: UISwitch) {
        print("Switch state: \(sender.isOn)")
        if(DarkModeSwitch.isOn){
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
        }else{
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func didTapAdd() {
        let alert = UIAlertController(title: "Reminder App", message: "Do you want to create a new reminder?", preferredStyle: .actionSheet)
            
            let addAction = UIAlertAction(title: "Add Reminder", style: .default) { [weak self] _ in
                self?.alertNew()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
    }
    func alertNew(){
        // show add vc
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                let new = MyReminder(title: title, date: date, identifier: "id_\(title)", body: body)
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                          from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapTest() {
        // fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                // schedule test
                self.scheduleTest()
            }
            else if error != nil{
                print("error occurred")
            }
        })
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "My long body. My long body. My long body."
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print("something went wrong")
            }
        })
    }
    
    @IBAction func musicButton(_ sender: Any) {
        if(audioPlayer.isPlaying){
            let alert = UIAlertController(title: "Reminder App", message: "Do you want to stop playing music?", preferredStyle: .alert)
                
                let addAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                    self?.audioPlayer.stop()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                
                alert.addAction(addAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Reminder App", message: "Do you want to play music?", preferredStyle: .alert)
                
                let addAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                    // Call the function to navigate to the new note view
                    self?.audioPlayer.play()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                
                alert.addAction(addAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // Table View segment
            table.isHidden = false
            webView.isHidden = true
        case 1: // Web View segment
            table.isHidden = true
            webView.isHidden = false
            let urlString = URL(string: "https://youtu.be/rffveK6_t_E?si=5LbBb2q841A8umWG")
            let urlReq = URLRequest(url:urlString!)
            webView.loadRequest(urlReq)
        default:
            break
        }
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        
        
        //Show reminderViewController
        let model = models[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "reminderView") as? reminderViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = ""
        vc.reminderTitle = model.title
        vc.reminderBody = model.body
        vc.reminderDate = "Scheduled at: \(model.date)"
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
}

struct MyReminder  {
    let title: String
    let date: Date
    let identifier: String
    let body: String
}
