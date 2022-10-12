//
//  ViewController.swift
//  Focused
//
//  Created by Tai Wong on 7/27/22.
//

import UIKit
import BEMCheckBox
import AVFoundation




class ViewController: UIViewController {
    
    @IBOutlet weak var nonimportant: UIButton!
    @IBAction func nonimportant(_ sender: UIButton) {
        let pulse = PulseAnimation(numberOfPulses: 1, radius: 1000, position: sender.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "nonimportant", sender: self)
        }
        pulse.animationDuration = 2
        pulse.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1).cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }
    
    @IBAction func createAItem(_ sender: Any) {
        performSegue(withIdentifier: "create", sender: self)
    }
    @IBOutlet weak var important: UIButton!
    @IBAction func importantcheck(_ sender: UIButton) {
        let pulse = PulseAnimation(numberOfPulses: 1, radius: 1000, position: sender.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "important", sender: self)
        }
        pulse.animationDuration = 2
        pulse.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.6901960784, blue: 0.7803921569, alpha: 1).cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }
    
    @IBOutlet weak var veryimportant: UIButton!
    @IBAction func veryimportantcheck(_ sender: UIButton) {
        let pulse = PulseAnimation(numberOfPulses: 1, radius: 1000, position: sender.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "veryimportant", sender: self)
        }
        pulse.animationDuration = 2
        pulse.backgroundColor = #colorLiteral(red: 1, green: 0.8268307787, blue: 0.6278962847, alpha: 1).cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }
    let center = UNUserNotificationCenter.current()
    
    @IBAction func openMusic(_ sender: Any) {
        performSegue(withIdentifier: "music", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        var htasks = UserDefaults.standard.array(forKey: "High") as? [String] ?? []
        var hCollection: [String] = []
        
        var mtasks = UserDefaults.standard.array(forKey: "Medium") as? [String] ?? []
        var mCollection: [String] = []
        
        var ltasks = UserDefaults.standard.array(forKey: "Low") as? [String] ?? []
        var lCollection: [String] = []
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if mtasks.contains(request.identifier) {
                    mCollection.append(request.identifier)
                } else {
                    mtasks = mtasks.filter { $0 != request.identifier }
                }
                
                if htasks.contains(request.identifier) {
                    hCollection.append(request.identifier)
                } else {
                    htasks = htasks.filter { $0 != request.identifier }
                }
                
                if ltasks.contains(request.identifier) {
                    lCollection.append(request.identifier)
                } else {
                    ltasks = ltasks.filter { $0 != request.identifier }
                }
            }
            UserDefaults.standard.set(mtasks, forKey: "Medium")
            UserDefaults.standard.set(htasks, forKey: "High")
            UserDefaults.standard.set(ltasks, forKey: "Low")

            let totalCount = mCollection.count + hCollection.count + lCollection.count
            
            
            DispatchQueue.main.sync {
                if hCollection.isEmpty == true {
                    self.veryimportant.isHidden = true
                } else {
                    self.veryimportant.isHidden = false
                    self.veryimportant.titleLabel?.font =   .systemFont(ofSize: 40, weight: .medium)
                    self.veryimportant.setTitle("\(hCollection.count)", for: .normal)
                }
                if mCollection.isEmpty == true {
                    self.nonimportant.isHidden = true
                } else {
                    self.nonimportant.isHidden = false
                    self.nonimportant.titleLabel?.font =   .systemFont(ofSize: 40, weight: .medium)
                    self.nonimportant.setTitle("\(mCollection.count)", for: .normal)
                }
                if lCollection.isEmpty == true {
                    self.important.isHidden = true
                } else {
                    self.important.isHidden = false
                    self.important.titleLabel?.font =   .systemFont(ofSize: 40, weight: .medium)
                    self.important.setTitle("\(lCollection.count)", for: .normal)
                }
                self.totalTasks.text = "\(totalCount)"
            }
        })
    }
    @IBOutlet weak var totalTasks: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
class musicViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVAudioPlayerDelegate {
    
    var colors = [UIColor.systemRed, UIColor.systemGreen, UIColor.systemBlue]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! vinylCell
        cell.backgroundColor = colors[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.title.text = "Default"
        case 1:
            cell.title.text = "Playful"
        case 2:
            cell.title.text = "Waves"
        default:
            cell.title.text = ""
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let zcell = cell as! vinylCell
        
        audioPlayer?.stop()
        
        if selectedRunningCell != nil {
            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layoutIfNeeded()
        } else {
            zcell.vinyl.layer.removeAllAnimations()
            zcell.vinyl.layoutIfNeeded()
        }
        
        
    }
    var loop = false
    @IBOutlet weak var loopbutton: UIButton!
    @IBAction func loop(_ sender: Any) {
        if loop == false {
            loopbutton.tintColor = .systemPurple
            loopbutton.rotacion()
            loop = true
        } else {
            loopbutton.tintColor = .white
            loopbutton.layer.removeAllAnimations()
            loopbutton.layoutIfNeeded()
            loop = false
        }
    }
    var selectedRunningCell: vinylCell?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedRunningCell != nil {
            audioPlayer?.stop()

            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layoutIfNeeded()
            
            if selectedRunningCell != collectionView.cellForItem(at: indexPath) as! vinylCell {
                selectedRunningCell = collectionView.cellForItem(at: indexPath) as! vinylCell
                playAudioFile()
                selectedRunningCell!.vinyl.rotate()
            } else {
                selectedRunningCell = nil
            }
            
            do {
                try audioSession.setActive(false)
            } catch {
                print("unable to deactivate")
            }
            
            
            
            
        } else {
            selectedRunningCell = collectionView.cellForItem(at: indexPath) as! vinylCell
            playAudioFile()
            selectedRunningCell!.vinyl.rotate()
        }
    
    }
    
    var audioPlayer: AVAudioPlayer?
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if loop == true {
            playAudioFile()
        } else {
            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layoutIfNeeded()
        }
        print("Finish")
    }
    let audioSession = AVAudioSession.sharedInstance()

    func playAudioFile() {
                
        do {
            try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
            try audioSession.setActive(true)

        } catch {
            print("Failed to set audio session category.")
        }
        
        
        
        
        let pathToSound = Bundle.main.path(forResource: selectedRunningCell!.title.text, ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do
        {
            
            
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            audioPlayer?.delegate = self
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1
            audioPlayer?.play()
            
            
            
           
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}
class vinylCell: UICollectionViewCell {
    @IBOutlet weak var vinyl: UIImageView!
    @IBOutlet weak var title: UILabel!
    
}
extension UIImageView {
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
extension UIView {
    func rotacion() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}




class veryImportantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BEMCheckBoxDelegate {
    var tasks: [String] = []
    var tasksCollection: [UNNotificationRequest] = []
    func animationDidStop(for checkBox: BEMCheckBox) {
        let buttonTag = checkBox.tag
        tasks = tasks.filter { $0 != tasksCollection[buttonTag].identifier }
        center.removePendingNotificationRequests(withIdentifiers: [tasksCollection[buttonTag].identifier])
        tasksCollection.remove(at: buttonTag)
        
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    let center = UNUserNotificationCenter.current()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! taskCell
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .full
        
        //unfinished - ill do tn
        
        if let trigger = tasksCollection[indexPath.row].trigger as? UNCalendarNotificationTrigger {
            
            let formattedString = formatter.string(from: trigger.nextTriggerDate()!.timeIntervalSinceNow)

           cell.taskTime.text = "Due in \(formattedString!)"
        } else {
            cell.taskTime.text = "Unknown"
        }
        
        
        
        
        cell.taskName.text = tasksCollection[indexPath.row].identifier
        cell.checkBox.tag = indexPath.row
        cell.checkBox.delegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksCollection.count
    }
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = UserDefaults.standard.array(forKey: "High") as? [String] ?? []
        var pendingNotifs: [String] = []

        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if self.tasks.contains(request.identifier) {
                    self.tasksCollection.append(request)
                    pendingNotifs.append(request.identifier)
                }
            }
            UserDefaults.standard.set(pendingNotifs, forKey: "High")

            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
class MediumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BEMCheckBoxDelegate {
    var tasks: [String] = []
    var tasksCollection: [UNNotificationRequest] = []
    func animationDidStop(for checkBox: BEMCheckBox) {
        let buttonTag = checkBox.tag
        tasks = tasks.filter { $0 != tasksCollection[buttonTag].identifier }
        center.removePendingNotificationRequests(withIdentifiers: [tasksCollection[buttonTag].identifier])
        tasksCollection.remove(at: buttonTag)
        
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    let center = UNUserNotificationCenter.current()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! taskCell
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .full
        
        //unfinished - ill do tn
        
        if let trigger = tasksCollection[indexPath.row].trigger as? UNCalendarNotificationTrigger {
            
            let formattedString = formatter.string(from: trigger.nextTriggerDate()!.timeIntervalSinceNow)

           cell.taskTime.text = "Due in \(formattedString!)"
        } else {
            cell.taskTime.text = "Unknown"
        }
        
        
        
        
        cell.taskName.text = tasksCollection[indexPath.row].identifier
        cell.checkBox.tag = indexPath.row
        cell.checkBox.delegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksCollection.count
    }
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = UserDefaults.standard.array(forKey: "Medium") as? [String] ?? []
        var pendingNotifs: [String] = []
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if self.tasks.contains(request.identifier) {
                    self.tasksCollection.append(request)
                    pendingNotifs.append(request.identifier)
                }
            }
            UserDefaults.standard.set(pendingNotifs, forKey: "Medium")
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
class LowViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BEMCheckBoxDelegate {
    var tasks: [String] = []
    var tasksCollection: [UNNotificationRequest] = []
    func animationDidStop(for checkBox: BEMCheckBox) {
        let buttonTag = checkBox.tag
        tasks = tasks.filter { $0 != tasksCollection[buttonTag].identifier }
        center.removePendingNotificationRequests(withIdentifiers: [tasksCollection[buttonTag].identifier])
        tasksCollection.remove(at: buttonTag)
        
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    let center = UNUserNotificationCenter.current()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! taskCell
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .full
        
        //unfinished - ill do tn
        
        if let trigger = tasksCollection[indexPath.row].trigger as? UNCalendarNotificationTrigger {
            
            let formattedString = formatter.string(from: trigger.nextTriggerDate()!.timeIntervalSinceNow)

           cell.taskTime.text = "Due in \(formattedString!)"
        } else {
            cell.taskTime.text = "Unknown"
        }
        
        
        
        
        cell.taskName.text = tasksCollection[indexPath.row].identifier
        cell.checkBox.tag = indexPath.row
        cell.checkBox.delegate = self
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasksCollection.count
    }
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = UserDefaults.standard.array(forKey: "Low") as? [String] ?? []
        var pendingNotifs: [String] = []

        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                if self.tasks.contains(request.identifier) {
                    self.tasksCollection.append(request)
                    pendingNotifs.append(request.identifier)
                }
            }
            UserDefaults.standard.set(pendingNotifs, forKey: "Low")

            DispatchQueue.main.sync {
                self.collectionView.reloadData()
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
class taskCell: UICollectionViewCell {
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var taskTime: UILabel!
}
let phColor = #colorLiteral(red: 0.1490196078, green: 0.1647058824, blue: 0.4117647059, alpha: 1)
let bgColor = #colorLiteral(red: 0.08143170742, green: 0.08536147959, blue: 0.2311015965, alpha: 1)

var taskname: String = ""

class createTask: UIViewController, UITextFieldDelegate {
    @IBAction func exit(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
       // dismiss(animated: true, completion: nil)
    }
   
    @IBOutlet weak var taskName: UITextField!
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField.text?.count ?? 0 > 0) {
            submit.isUserInteractionEnabled = true
            submit.setTitleColor(.white, for: .normal)
            submit.backgroundColor = phColor
        } else {
            submit.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
            submit.backgroundColor = .white.withAlphaComponent(0.25)
            submit.isUserInteractionEnabled = false
        }
    }
    @IBAction func submitted(_ sender: Any) {
        taskname = taskName.text!
        performSegue(withIdentifier: "choose", sender: self)
    }
    
    @IBOutlet weak var submit: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        taskname = ""
        taskName.delegate = self
        
    }
}



class chooseTimeTask: UITableViewController {
    
    func setupPickerView(sender: MyButton) {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = bgColor
        pickerView.tintColor = .white
        pickerView.delegate = self
        
        let toolbar = UIToolbar( frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolbar.backgroundColor = phColor
        toolbar.barTintColor = bgColor
        toolbar.sizeToFit()

        
        pickerView.tag = 10122006
            
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.finished(sender:)))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(sender:)))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        button.tag = sender.tag
        button.tintColor = .tintColor
        cancel.tintColor = .white
        toolbar.setItems([cancel, flexible, button], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        
        sender.inputView = pickerView
        sender.inputAccessoryView = toolbar
    }
    @IBOutlet weak var prioritySelection: UILabel!
    @objc func cancel(sender: UIBarButtonItem) {
        
        priorityLevel = prioritySelection.text ?? "High"
        view.endEditing(true)
    }
    @objc func finished(sender: UIBarButtonItem) {
        prioritySelection.text = priorityLevel
        view.endEditing(true)
    }
    @IBAction func save(_ sender: Any) {
        print(datePicker.date)
        
        switch repeatLabel.text {
        case "Never":
            createNotification(date: datePicker.date, title: taskname, repeating: false, importance: prioritySelection.text!)
        case "Always":
            createNotification(date: datePicker.date, title: taskname, repeating: true, importance: prioritySelection.text!)
        default:
            createNotification(date: datePicker.date, title: taskname, repeating: false, importance: prioritySelection.text!)
        }
        
        
        
    }
    func createNotification(date: Date, title: String, repeating: Bool, importance: String) {
        print(importance, "ian")
        
        var identifiers: [String] = []

        identifiers = UserDefaults.standard.array(forKey: importance) as? [String] ?? []
        
        
        
        let center = UNUserNotificationCenter.current()
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeating)
        let uuidString = title
        
        
        
        
        let content = UNMutableNotificationContent()
        content.title = "Task Notification"
        content.body = "Deadline for \(title) is ending"
        
        
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus.rawValue {
            case 0:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                    
                }
            case 1:
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: "Unable to create Notification", message: "Please make sure you have Notifications on.", preferredStyle: .alert)
                   
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                            case .default:
                            print("default")
                            
                            case .cancel:
                            print("cancel")
                            
                            case .destructive:
                            print("destructive")
                            
                        @unknown default:
                            fatalError()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            case 2:
                center.add(request) { (error) in
                    if error != nil {
                        DispatchQueue.main.sync {
                            let alert = UIAlertController(title: "Unable to create Notification", message: "Please make sure you have Notifications on.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style {
                                    case .default:
                                    print("default")
                                    
                                    case .cancel:
                                    print("cancel")
                                    
                                    case .destructive:
                                    print("destructive")
                                    
                                @unknown default:
                                    fatalError()
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print("couldnt add request")
                        }
                    } else {
                        identifiers.append(uuidString)
                        UserDefaults.standard.set(identifiers, forKey: importance)
                        DispatchQueue.main.sync {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        

                    }
                }
            default:
                center.add(request) { (error) in
                    if error != nil {
                        DispatchQueue.main.sync {
                            let alert = UIAlertController(title: "Unable to create Notification", message: "Please make sure you have Notifications on.", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                    case .default:
                                    print("default")
                                    
                                    case .cancel:
                                    print("cancel")
                                    
                                    case .destructive:
                                    print("destructive")
                                    
                                @unknown default:
                                    fatalError()
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print("couldnt add request")

                        }
                    } else {
                        identifiers.append(uuidString)
                        UserDefaults.standard.set(identifiers, forKey: importance)
                        DispatchQueue.main.sync {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        

                    }
                }
            }
        }
    }
    
    @IBOutlet weak var soundCell: UITableViewCell!
    @IBOutlet weak var priorityCell: UITableViewCell!
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
        
    }
    
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var priorityButton: MyButton!
    @IBAction func priority(_ sender: Any) {
        setupPickerView(sender: priorityButton)

    }
    
    @IBAction func repeatSelection(_ sender: Any) {
        if repeatLevel == "Never" {
            repeatLabel.text = "Always"
            repeatLevel = "Always"
        } else {
            repeatLabel.text = "Never"
            repeatLevel = "Never"
        }
        
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prioritySelection.text = "High"
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        priorityLevel = "High"
        repeatLevel = "Never"
        print("nil")
    }
    
}
var repeatLevel: String = "Never"
var priorityLevel: String = "High"
extension chooseTimeTask: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 10122006 {
            return 1
        } else {
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 10122006 {
            return 3
        } else {
            return pickerView.tag + 1

        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 10122006 {
            switch row {
            case 0:
                priorityLevel = "High"
            case 1:
                priorityLevel = "Medium"
            case 2:
                priorityLevel = "Low"
            default:
                break
            }
        } else {

        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""

        if pickerView.tag == 10122006 {
            switch row {
            case 0:
                string = "High"
            case 1:
                string = "Medium"
            case 2:
                string = "Low"
            default:
                string = ""
            }
        } else {
            string = "\(row)"
        }
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView.tag == 10122006 {
            return UIScreen.main.bounds.width - 80
        } else {
            return UIScreen.main.bounds.width / 2
        }
    }

}
class MyButton: UIButton {
    var myView: UIView? = UIView()
    var toolBarView: UIView? = UIView()
    
    override var inputView: UIView? {
        get {
            myView
        }
        
        set {
            myView = newValue
        }
    }

    override var inputAccessoryView: UIView? {
        get {
            toolBarView
        }
        set {
            toolBarView = newValue
            becomeFirstResponder()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
       true
    }

}




extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
//reward system + custom notif sounds
