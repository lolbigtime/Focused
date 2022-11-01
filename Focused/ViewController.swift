//
//  ViewController.swift
//  Focused
//
//  Created by Tai Wong on 7/27/22.
//

import UIKit
import BEMCheckBox
import AVFoundation
import UserNotifications



class ViewController: UIViewController {
    @IBOutlet weak var nonimportant: UIButton!
    @IBAction func nonimportant(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false

        let pulse = PulseAnimation(numberOfPulses: 1, radius: 1000, position: sender.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "nonimportant", sender: self)
            sender.isUserInteractionEnabled = true
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
        sender.isUserInteractionEnabled = false

        let pulse = PulseAnimation(numberOfPulses: 1, radius: 1000, position: sender.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "important", sender: self)
            sender.isUserInteractionEnabled = true
        }
        pulse.animationDuration = 2
        pulse.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.6901960784, blue: 0.7803921569, alpha: 1).cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }
    
    @IBOutlet weak var veryimportant: UIButton!
    @IBAction func veryimportantcheck(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let pulse = PulseAnimation(numberOfPulses: 1, radius: 1000, position: sender.center)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "veryimportant", sender: self)
            sender.isUserInteractionEnabled = true
        }
        pulse.animationDuration = 2
        pulse.backgroundColor = #colorLiteral(red: 1, green: 0.8274509804, blue: 0.6274509804, alpha: 1).cgColor
        self.view.layer.insertSublayer(pulse, below: self.view.layer)
    }
    let center = UNUserNotificationCenter.current()
    
    @IBAction func openMusic(_ sender: Any) {
        performSegue(withIdentifier: "music", sender: self)
    }
    fileprivate func addObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc fileprivate func applicationDidBecomeActive() {
        var htasks = UserDefaults.standard.array(forKey: "High") as? [String] ?? []
        var hCollection: [String] = []
        
        var mtasks = UserDefaults.standard.array(forKey: "Medium") as? [String] ?? []
        var mCollection: [String] = []
        
        var ltasks = UserDefaults.standard.array(forKey: "Low") as? [String] ?? []
        var lCollection: [String] = []
        
        var tasksCollection: [UNNotificationRequest] = []
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                
                
                if mtasks.contains(request.identifier) {
                    mCollection.append(request.identifier)
                    tasksCollection.append(request)
                } else {
                    mtasks = mtasks.filter { $0 != request.identifier }
                }
                
                if htasks.contains(request.identifier) {
                    hCollection.append(request.identifier)
                    tasksCollection.append(request)
                } else {
                    htasks = htasks.filter { $0 != request.identifier }
                }
                
                if ltasks.contains(request.identifier) {
                    lCollection.append(request.identifier)
                    tasksCollection.append(request)
                } else {
                    ltasks = ltasks.filter { $0 != request.identifier }
                }
            }
            UserDefaults.standard.set(mCollection, forKey: "Medium")
            UserDefaults.standard.set(hCollection, forKey: "High")
            UserDefaults.standard.set(lCollection, forKey: "Low")

            
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
    deinit {
        removeObservers()
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
        
        var tasksCollection: [UNNotificationRequest] = []
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                
                
                if mtasks.contains(request.identifier) {
                    tasksCollection.append(request)
                    mCollection.append(request.identifier)
                } else {
                    mtasks = mtasks.filter { $0 != request.identifier }
                }
                
                if htasks.contains(request.identifier) {
                    tasksCollection.append(request)

                    hCollection.append(request.identifier)
                } else {
                    htasks = htasks.filter { $0 != request.identifier }
                }
                
                if ltasks.contains(request.identifier) {
                    tasksCollection.append(request)

                    lCollection.append(request.identifier)
                } else {
                    ltasks = ltasks.filter { $0 != request.identifier }
                }
            }
            UserDefaults.standard.set(mCollection, forKey: "Medium")
            UserDefaults.standard.set(hCollection, forKey: "High")
            UserDefaults.standard.set(lCollection, forKey: "Low")

            for task in tasksCollection {
                let trigger = task.trigger as? UNCalendarNotificationTrigger
                let dateNow: Date = Calendar.current.date(from: trigger!.dateComponents)!
                let timer = Timer(fireAt: dateNow, interval: 0, target: self, selector: #selector(self.applicationDidBecomeActive), userInfo: nil, repeats: false)
                RunLoop.main.add(timer, forMode: .common)
            }
            
            
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
        addObservers()
        // Do any additional setup after loading the view.
    }
}
class dismissViewController: UIViewController {
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
class musicViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVAudioPlayerDelegate {
    func getRidOfData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    @IBAction func help(_ sender: Any) {
        performSegue(withIdentifier: "help", sender: self)
    }
    var colors = [UIColor.systemRed, UIColor.systemGreen, UIColor.systemBlue, UIColor.brown, UIColor.systemYellow]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! vinylCell
        cell.backgroundColor = colors[indexPath.row]
        cell.isUserInteractionEnabled = false
        switch indexPath.row {
        case 0:
            cell.vinyl.image = UIImage(systemName: "clipartVinyl")
            cell.title.text = "Focused"
            cell.isUserInteractionEnabled = true
        case 1:
            if numberOfTasksFinished >= 5 {
                cell.title.text = "Playful"
                cell.isUserInteractionEnabled = true
            } else {
                cell.title.text = "Unlock - Finish 5 Tasks Early"
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.isUserInteractionEnabled = false
            }
        case 2:
            if numberOfTasksFinished >= 10 {
                cell.vinyl.image = UIImage(systemName: "clipartVinyl")
                cell.title.text = "Waves"
                cell.isUserInteractionEnabled = true

            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 10 Tasks Early"
            }
        case 3:
            if numberOfTasksFinished >= 15 {
                cell.vinyl.image = UIImage(systemName: "clipartVinyl")
                cell.title.text = "Beats"
                cell.isUserInteractionEnabled = true
            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 10 Tasks Early"
            }
        case 4:
            if numberOfTasksFinished >= 20 {
                cell.vinyl.image = UIImage(systemName: "clipartVinyl")
                cell.title.text = "End"
                cell.isUserInteractionEnabled = true
            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 10 Tasks Early"
            }
        default:
            cell.vinyl.image = UIImage(systemName: "clipartVinyl")
            cell.isUserInteractionEnabled = false
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
            
            
            
            
        } else {
            soundtrack.tintColor = .white
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
            soundtrack.tintColor = .white
            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layoutIfNeeded()
        }
    }
    @IBAction func fullSoundTrack(_ sender: Any) {
        soundtrack.tintColor = .systemPurple

        if selectedRunningCell != nil {
            audioPlayer?.stop()

            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layoutIfNeeded()
            
            
            
            
        }
        
        do {
            try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
            try audioSession.setActive(true)

        } catch {
            print("Failed to set audio session category.")

        }
        
        
        do {
        
        let pathToSound = Bundle.main.path(forResource: "Soundtrack", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
            
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            audioPlayer?.delegate = self
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1
            audioPlayer?.play()
            
        }
        catch
        {
            soundtrack.tintColor = .white
            print(error.localizedDescription)
        }
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
    
    
    
    
    @IBOutlet weak var soundtrack: UIButton!
    
    @IBOutlet weak var tasknumber: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var numberOfTasksFinished = UserDefaults.standard.integer(forKey: "tasks")
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberOfTasksFinished = UserDefaults.standard.integer(forKey: "tasks")
        
        tasknumber.text = "\(numberOfTasksFinished) Tasks Finished Early"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundtrack.tintColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}
var selectedSound: String = ""
class musicChooseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AVAudioPlayerDelegate {
    @IBOutlet weak var exit: UIButton!
    @IBAction func exit(_ sender: Any) {
        audioPlayer?.stop()
        do {
            try audioSession.setActive(false)
        } catch {
            print("unable to deactivate")
        }
        selectedSound = "Default - System"
        
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveexit(_ sender: Any) {
        audioPlayer?.stop()
        do {
            try audioSession.setActive(false)
        } catch {
            print("unable to deactivate")
        }
        if selectedRunningCell == nil {
            selectedSound = "Default - System"
        } else {
            selectedSound = selectedRunningCell!.title.text ?? "Default - System"
        }
        //if selected cell == nil then return default

        dismiss(animated: true, completion: nil)
    }
    
    var colors = [UIColor.systemGray, UIColor.systemRed, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemBrown, UIColor.systemYellow]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! vinylCell
        cell.backgroundColor = colors[indexPath.row]
        cell.title.textColor = .white
        cell.isUserInteractionEnabled = false
        
        if selectedRunningCell != nil {
            selectedRunningCell?.title.textColor = .systemIndigo
        } else {
            if indexPath.row == 0 {
                cell.title.textColor = .systemIndigo
            }
        }
        switch indexPath.row {
        case 0:
            cell.title.text = "Default - System"
            cell.vinyl.image = UIImage(named: "clipartVinyl")
            cell.isUserInteractionEnabled = true
        case 1:
            cell.title.text = "Focused"
            cell.vinyl.image = UIImage(named: "clipartVinyl")
            cell.isUserInteractionEnabled = true
        case 2:
            if numberOfTasksFinished >= 5 {
                cell.title.text = "Playful"
                cell.isUserInteractionEnabled = true

            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 5 Tasks Early"
            }
        case 3:
            if numberOfTasksFinished >= 10 {
                cell.title.text = "Waves"
                cell.isUserInteractionEnabled = true

            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 10 Tasks Early"
            }
        case 4:
            if numberOfTasksFinished >= 15 {
                cell.title.text = "Beats"
                cell.isUserInteractionEnabled = true

            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 10 Tasks Early"
            }
        case 5:
            if numberOfTasksFinished >= 20 {
                cell.title.text = "End"
                cell.isUserInteractionEnabled = true

            } else {
                cell.isUserInteractionEnabled = false
                cell.vinyl.image = UIImage(systemName: "lock.fill")
                cell.title.text = "Unlock - Finish 10 Tasks Early"
            }
        default:
            cell.isUserInteractionEnabled = false
            cell.vinyl.image = UIImage(named: "clipartVinyl")
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
    
    var selectedRunningCell: vinylCell?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedRunningCell != nil {
            audioPlayer?.stop()

            selectedRunningCell!.vinyl.layer.removeAllAnimations()
            selectedRunningCell!.vinyl.layoutIfNeeded()
            selectedRunningCell?.title.textColor = .white

            if selectedRunningCell != collectionView.cellForItem(at: indexPath) as? vinylCell {
                selectedRunningCell = collectionView.cellForItem(at: indexPath) as? vinylCell
                playAudioFile()
                selectedRunningCell!.vinyl.rotate()
            } else {
                selectedRunningCell = nil
            }
           
        } else {
            selectedRunningCell = collectionView.cellForItem(at: indexPath) as? vinylCell
            selectedRunningCell!.vinyl.rotate()
            selectedRunningCell?.title.textColor = .systemIndigo
            playAudioFile()
        }
    }
    
    var audioPlayer: AVAudioPlayer?
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        selectedRunningCell!.vinyl.layer.removeAllAnimations()
        selectedRunningCell!.vinyl.layer.removeAllAnimations()
        selectedRunningCell!.vinyl.layoutIfNeeded()
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
    var numberOfTasksFinished = UserDefaults.standard.integer(forKey: "tasks")

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfTasksFinished = UserDefaults.standard.integer(forKey: "tasks")

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




class veryImportantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, BEMCheckBoxDelegate, UICollectionViewDelegateFlowLayout {
    var tasks: [String] = []
    var tasksCollection: [UNNotificationRequest] = []
    func animationDidStop(for checkBox: BEMCheckBox) {
        let buttonTag = checkBox.tag
        tasks = tasks.filter { $0 != tasksCollection[buttonTag].identifier }
        center.removePendingNotificationRequests(withIdentifiers: [tasksCollection[buttonTag].identifier])
        tasksCollection.remove(at: buttonTag)
        var tasksFinished = UserDefaults.standard.integer(forKey: "tasks")
        tasksFinished += 1
        UserDefaults.standard.set(tasksFinished, forKey: "tasks")
        collectionView.reloadSections(IndexSet(integer: 0))
        if tasks.isEmpty == true {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    let center = UNUserNotificationCenter.current()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! taskCell
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        
        
        if let trigger = tasksCollection[indexPath.row].trigger as? UNCalendarNotificationTrigger {
            
            var secondsRemaining = trigger.nextTriggerDate()?.timeIntervalSinceNow ?? 0
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining >= -1 {
                        let formattedString = formatter.string(from: trigger.nextTriggerDate()?.timeIntervalSinceNow ?? 0)

                        secondsRemaining -= 1
                        
                        if trigger.repeats == true {
                            cell.taskTime.text = "Due and repeats ↻ in \(formattedString!)"
                        } else {
                            cell.taskTime.text = "Due in \(formattedString!)"
                        }
                        
                        
                    } else {
                        self.applicationDidBecomeActive()
                        Timer.invalidate()
                    }
                }
            
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
    
    fileprivate func addObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc fileprivate func applicationDidBecomeActive() {
        tasksCollection = []
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

            print("reloading")

            
            DispatchQueue.main.sync {
                if self.tasksCollection.isEmpty == false {
                    self.collectionView.reloadData()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    deinit {
        removeObservers()
    }
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksCollection = []
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
            /*
            for task in self.tasksCollection {
                var trigger = task.trigger as? UNCalendarNotificationTrigger
                let dateNow: Date
                var dateComponentsNow = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.now)

                if (trigger?.dateComponents.month == nil) && (trigger?.dateComponents.year == nil) {
                    dateComponentsNow.hour = trigger?.dateComponents.hour
                    dateComponentsNow.minute = trigger?.dateComponents.minute
                    dateComponentsNow.second = trigger?.dateComponents.second
                    dateNow = Calendar.current.date(from: dateComponentsNow)!
                } else {
                    dateNow = Calendar.current.date(from: trigger!.dateComponents)!
                }
                
                let timer = Timer(fireAt: dateNow, interval: 0, target: self, selector: #selector(self.applicationDidBecomeActive), userInfo: nil, repeats: false)
               // RunLoop.main.add(timer, forMode: .common)
            }
             */
            DispatchQueue.main.sync {
                if self.tasksCollection.isEmpty == false {
                    self.collectionView.reloadData()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 5, height: 100)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        addObservers()
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
        var tasksFinished = UserDefaults.standard.integer(forKey: "tasks")
        tasksFinished += 1
        UserDefaults.standard.set(tasksFinished, forKey: "tasks")
        collectionView.reloadSections(IndexSet(integer: 0))
        if tasks.isEmpty == true {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    let center = UNUserNotificationCenter.current()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! taskCell
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        
        //unfinished - ill do tn
        
        if let trigger = tasksCollection[indexPath.row].trigger as? UNCalendarNotificationTrigger {
            
            var secondsRemaining = trigger.nextTriggerDate()?.timeIntervalSinceNow ?? 0
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining >= -1 {
                        let formattedString = formatter.string(from: trigger.nextTriggerDate()?.timeIntervalSinceNow ?? 0)

                        secondsRemaining -= 1
                        
                        if trigger.repeats == true {
                            cell.taskTime.text = "Due and repeats ↻ in \(formattedString!)"
                        } else {
                            cell.taskTime.text = "Due in \(formattedString!)"
                        }
                        
                        
                    } else {
                        self.applicationDidBecomeActive()
                        Timer.invalidate()
                    }
                }
            
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
    
    fileprivate func addObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc fileprivate func applicationDidBecomeActive() {
        tasksCollection = []

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
                if self.tasksCollection.isEmpty == false {
                    self.collectionView.reloadData()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    deinit {
        removeObservers()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksCollection = []

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
                if self.tasksCollection.isEmpty == false {
                    self.collectionView.reloadData()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
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
        var tasksFinished = UserDefaults.standard.integer(forKey: "tasks")
        tasksFinished += 1
        UserDefaults.standard.set(tasksFinished, forKey: "tasks")
        collectionView.reloadSections(IndexSet(integer: 0))
        print(tasks, "tasks")
        if tasks.isEmpty == true {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    let center = UNUserNotificationCenter.current()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "task", for: indexPath) as! taskCell
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        
        //unfinished - ill do tn
        
        if let trigger = tasksCollection[indexPath.row].trigger as? UNCalendarNotificationTrigger {
            
            var secondsRemaining = trigger.nextTriggerDate()?.timeIntervalSinceNow ?? 0
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining >= -1 {
                        let formattedString = formatter.string(from: trigger.nextTriggerDate()?.timeIntervalSinceNow ?? 0)

                        secondsRemaining -= 1
                        
                        if trigger.repeats == true {
                            cell.taskTime.text = "Due and repeats ↻ in \(formattedString!)"
                        } else {
                            cell.taskTime.text = "Due in \(formattedString!)"
                        }
                        
                        
                    } else {
                        self.applicationDidBecomeActive()
                        Timer.invalidate()
                    }
                }
            
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
    
    fileprivate func addObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc fileprivate func applicationDidBecomeActive() {
        tasksCollection = []

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
                if self.tasksCollection.isEmpty == false {
                    self.collectionView.reloadData()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    deinit {
        removeObservers()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksCollection = []

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
                if self.tasksCollection.isEmpty == false {
                    self.collectionView.reloadData()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
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
            let htasks = UserDefaults.standard.array(forKey: "High") as? [String] ?? []
            
            let mtasks = UserDefaults.standard.array(forKey: "Medium") as? [String] ?? []
            
            let ltasks = UserDefaults.standard.array(forKey: "Low") as? [String] ?? []
            
            let allTasks = htasks + mtasks + ltasks
            if allTasks.contains(textField.text ?? "") {
                submit.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
                submit.backgroundColor = .white.withAlphaComponent(0.25)
                submit.isUserInteractionEnabled = false
            } else {
                submit.isUserInteractionEnabled = true
                submit.setTitleColor(.white, for: .normal)
                submit.backgroundColor = phColor
            }
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
        var dateComponents: DateComponents
        if repeating == false {
            dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        } else {
            dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: date)
        }
                
        
        let uuidString = title
        
        
        
        
        let content = UNMutableNotificationContent()
        content.title = "Task Due"
        content.body = "Deadline for \(title) has ended"
        
        switch selectedSound {
        case "Default - System":
            content.sound = UNNotificationSound.default
        case "Focused":
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "DefaultTune.caf"))
        case "Playful":
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "PlayfulTune.caf"))
        case "Wave":
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "WaveTune.caf"))
        case "Beats":
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "BeatsTune.caf"))
        case "End":
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "EndTune.caf"))
        default:
            content.sound = UNNotificationSound.default
        }
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeating)
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        let differenceDate = date.timeIntervalSinceNow / 2
        
        let earlyDate = Date.now.addingTimeInterval(differenceDate)
        
        
        var earlyComponents: DateComponents
        if repeating == false {
            earlyComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: earlyDate)
        } else {
            earlyComponents = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: earlyDate)
        }
        
        
        let earlycontent = content
        earlycontent.title = "Task Notification"
        earlycontent.body = "Deadline for \(title) is halfway due"
        
        let earlytrigger = UNCalendarNotificationTrigger(dateMatching: earlyComponents, repeats: repeating)
        
        let earlyrequest = UNNotificationRequest(identifier: UUID().uuidString, content: earlycontent, trigger: earlytrigger)
        
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
                center.add(earlyrequest) { (error) in
                    if error != nil {
                        print("erorr unable to creatse early req, \(error)")
                    }
                }
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
                center.add(earlyrequest) { (error) in
                    if error != nil {
                        print("erorr unable to creatse early req, \(error)")
                    }
                }
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
    
    @IBAction func sound(_ sender: Any) {
        performSegue(withIdentifier: "chooseTune", sender: self)
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
        soundLabel.text = selectedSound

    }
    @IBOutlet weak var soundLabel: UILabel!
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSound = "Default - System"
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
//make very important notifs bypass do not disturb
//swap between pickerview and calendar swift
//redesign notif view controllers
//resizing views collectionview
//add description to tasks
//playlist - add all songs into one sound file - need songs
