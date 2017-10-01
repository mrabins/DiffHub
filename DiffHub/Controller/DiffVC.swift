//
//  DiffVC.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/28/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class DiffVC: UIViewController {
    
    var pull: Pull!
    var diffPull: DiffPull!
    let currentOrientation = UIApplication.shared.statusBarOrientation
    var previousOrientation = Int()
    var files = NSMutableArray()

    @IBOutlet weak var diffTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOrientation()
        
        diffTableView.delegate = self
        diffTableView.dataSource = self
        files.add(pull)

    }
    
    func setOrientation() {
        
        if currentOrientation.isPortrait {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if previousOrientation == 1 {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    func setupTableView() {
        
        
        //header
        let nib = UINib(nibName: "DiffFileTableViewHeaderView", bundle: nil)
        self.diffTableView.register(nib, forHeaderFooterViewReuseIdentifier: "DiffFileTableViewHeaderView")
        
        //section title cell
        self.diffTableView.register(UINib(nibName: "SectionTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "sectionTitle")
        
        //left-right code cell
        self.diffTableView.register(UINib(nibName: "CodeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "code")
        
        //no seperatorLine
        self.diffTableView.separatorStyle = .none
        
        //auto height
        self.diffTableView.rowHeight = UITableViewAutomaticDimension
        self.diffTableView.estimatedRowHeight = 18
        
    }
}

extension DiffVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections" , self.files.count)
        return self.files.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let file = self.files.object(at: section) as? DiffFile else {
            return 0
        }
        print("I am the \(file.codeLines.count) ")
        return file.codeLines.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? PullFileTableViewHeaderView else {
            return UIView()
        }
        guard let file = self.files[section] as? DiffFile else {
            return headerView
        }
        
        if file.sourceFileA == "" && file.sourceFileB == "" {
            headerView.sectionTitle.text = file.title
        }
        else if file.sourceFileA == "" {
            headerView.sectionTitle.text = file.sourceFileB
        }
        else if file.sourceFileB == "" {
            headerView.sectionTitle.text = file.sourceFileA
        }
        else if file.sourceFileA == file.sourceFileB {
            headerView.sectionTitle.text = file.sourceFileA
        }
        else {
            headerView.sectionTitle.text = file.sourceFileA + " -> " + file.sourceFileB
        }
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let file = self.files.object(at: indexPath.section) as? DiffFile else {
            return UITableViewCell()
        }
        
        let codeLine = file.codeLines[indexPath.row]
        
        switch codeLine.type {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTitle", for: indexPath) as! TableViewCellSectionHeader
            cell.sectionTitleLabel.text = codeLine.sharedContent
            cell.selectionStyle = .none
            
            return cell
        case .common:
            let cell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath) as! CodeLineTableViewCell
            cell.leftCodeLabel.text = codeLine.leftContent
            cell.leftLineNumLabel.text = String(codeLine.leftNum)
            cell.leftCodeLabel.backgroundColor = UIColor.white
            cell.leftLineNumLabel.backgroundColor = UIColor.white
            
            cell.rightCodeLabel.text = codeLine.rightContent
            cell.rightLineNumLabel.text = String(codeLine.rightNum)
            cell.rightCodeLabel.backgroundColor = UIColor.white
            cell.rightLineNumLabel.backgroundColor = UIColor.white
            
            return cell
        case .plusOrMinus:
            let cell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath) as! CodeLineTableViewCell
            if codeLine.isLeftNull {
                cell.leftCodeLabel.text = codeLine.leftContent
                cell.leftLineNumLabel.text = ""
                cell.leftCodeLabel.backgroundColor = UIColor.getNoContentGrayColor()
                cell.leftLineNumLabel.backgroundColor = UIColor.getNoContentGrayColor()
            }
            else {
                cell.leftCodeLabel.text = codeLine.leftContent
                cell.leftLineNumLabel.text = String(codeLine.leftNum)
                cell.leftCodeLabel.backgroundColor = UIColor.getOriFileRedColor()
                cell.leftLineNumLabel.backgroundColor = UIColor.getOriLineNumRedColor()
            }
            
            if codeLine.isRightNull {
                cell.rightCodeLabel.text = codeLine.rightContent
                cell.rightLineNumLabel.text = ""
                cell.rightCodeLabel.backgroundColor = UIColor.getNoContentGrayColor()
                cell.rightLineNumLabel.backgroundColor = UIColor.getNoContentGrayColor()
            }
            else {
                cell.rightCodeLabel.text = codeLine.rightContent
                cell.rightLineNumLabel.text = String(codeLine.rightNum)
                cell.rightCodeLabel.backgroundColor = UIColor.getNewFileGreenColor()
                cell.rightLineNumLabel.backgroundColor = UIColor.getNewLineNumGreenColor()
            }
            
            return cell
        }
        
    }
}

extension DiffVC : FileParser {
    
    func parseDiff(diffString : String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let checkResults = self.parseStringToFiles(diffStr: diffString) else {
                return
            }
            let diffStrNS = diffString as NSString
            self.generateFiles(diffStrNS: diffStrNS, checkResults: checkResults)
        }
    }
    
    private func saveStringToFile(pull: Pull, content: String) {
        
        do {
            // get the documents folder url
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // create the destination url for the text file to be saved
            let fileDestinationUrl = documentDirectoryURL.appendingPathComponent(String(describing: pull.diffUrl) + ".diff")
            
            let text = content
            do {
                // writing to disk
                try text.write(to: fileDestinationUrl, atomically: false, encoding: .utf8)
                print("saving was successful")
                
            } catch let error {
                print("error writing to url \(fileDestinationUrl)")
                print(error.localizedDescription)
            }
        } catch let error {
            print("error getting documentDirectoryURL")
            print(error.localizedDescription)
        }
        
    }
    
    func readSavedStringFromFile(pull: Pull) -> String? {
        // reading from disk
        
        do {
            // get the documents folder url
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // create the destination url for the text file to be saved
            let fileDestinationUrl = documentDirectoryURL.appendingPathComponent(String(describing: pull.diffUrl) + ".diff")
            
            do {
                let diffString = try String(contentsOf: fileDestinationUrl)
                return diffString
                
            } catch let error as NSError {
                print("error loading contentsOf url \(String(describing: pull.diffUrl))")
                print(error.localizedDescription)
                
                return nil
            }
            
            
        } catch let error {
            print("error getting documentDirectoryURL")
            print(error.localizedDescription)
            
            return nil
        }
        
    }
    
    private func generateFiles(diffStrNS: NSString, checkResults: [NSTextCheckingResult]) {
        
        //re-fetch the pull item for multiThreading
        guard let fileUUID = self.pull.diffUrl else {
            print("fetch pull id failed")
            return
        }

        for (index, file) in checkResults.enumerated() {
            let lastIndex = checkResults.last == file ?
                diffStrNS.length - file.range.location - 1 :
                checkResults[index + 1].range.location - file.range.location - 1
            
            let diffFile = DiffFile()
            diffFile.startIndex = file.range.location
            diffFile.endIndex = lastIndex
            diffFile.title = diffStrNS.substring(with: file.range) as String
            diffFile.pullRequestId = Int(pull.diffUrl!)!
            
            //names
            let fileStr = diffFile.parseSource(sourceStr: diffStrNS as String)
            if let aAndBName = self.parseFileNames(fileStr: fileStr)  {
                diffFile.sourceFileA = aAndBName.0
                diffFile.sourceFileB = aAndBName.1
            }
            
            //sections
            guard let sectionResults = self.parseFileSections(fileStr: fileStr) else {
                print("parse section failed")
                continue
            }
            for (index, section) in sectionResults.enumerated() {
                
                let lastIndex = sectionResults.last == section ?
                    (fileStr as NSString).length - section.range.location :
                    sectionResults[index + 1].range.location - section.range.location - 1
                
                let fileSection = FileSection()
                fileSection.startIndex = section.range.location
                fileSection.endIndex = lastIndex
                let resultNS = fileSection.parseSource(sourceStr: fileStr) as NSString
                fileSection.sectionSource = resultNS.components(separatedBy: "\n")
                
                for line in fileSection.sectionSource {
                    diffFile.lines.append(line)
                }
                
                diffFile.sections.append(fileSection)
            }
            
            self.seperateLeftAndRight(diffFile: diffFile, index: index)
        }
        
    }
    
    private func seperateLeftAndRight(diffFile : DiffFile, index: Int) {
        
        let array = self.parseFileToArray(diffFile: diffFile)
        guard let codeLines = self.parseArrayToCodeLines(organizedArray: array) else {
            return
        }
        
        diffFile.codeLines = codeLines
        DispatchQueue.main.async {
            self.didFinishedProcessFile(diffFile: diffFile, index: index)
        }
        
    }
    
    private func didFinishedProcessFile(diffFile: DiffFile, index: Int) {
        //once one file processed, append and load it to tableView
        
        self.files.add(diffFile) //on main-thread
        
        UIView.performWithoutAnimation {
            //uitableview begin update animation not cool
            self.diffTableView.insertSections(IndexSet(integer: index) , with: .none)
        }
        
    }
    
    private func parseFileToArray(diffFile : DiffFile) -> NSMutableArray  {
        //parse file
        let allLines = diffFile.lines
        
        let organizedArray = NSMutableArray()
        var lastFirstChar : Character?
        var diffCodeBlock = DifferentCodeBlock()
        
        for line in allLines {
            
            let firstChar = line.characters.first
            let lastChar = line.characters.last
            
            var line = line
            //remove "\r"s
            if lastChar == "\r" {
                line = String(line.characters.dropLast())
            }
            if firstChar == "\r" {
                line = String(line.characters.dropFirst())
            }
            
            if firstChar != "+" && firstChar != "-" {
                if lastFirstChar != "+" && lastFirstChar != "-" {
                    //plain info
                    organizedArray.add(line)
                    lastFirstChar = firstChar
                }
                else {
                    //exit groupMode
                    diffCodeBlock.generateBlocks()
                    organizedArray.add(diffCodeBlock)
                    diffCodeBlock = DifferentCodeBlock()
                    
                    organizedArray.add(line)
                    lastFirstChar = firstChar
                    continue
                }
                
            }
            else {
                if lastFirstChar != "+" && lastFirstChar != "-" {
                    //enter groupMode
                    diffCodeBlock.append(line: line)
                    lastFirstChar = firstChar
                    
                }
                else {
                    //inside groupMode
                    diffCodeBlock.append(line: line)
                    lastFirstChar = firstChar
                }
                
            }
        }
        
        if diffCodeBlock.blockArray.count != 0 {
            diffCodeBlock.generateBlocks()
            organizedArray.add(diffCodeBlock)
            diffCodeBlock = DifferentCodeBlock()
        }
        
        return organizedArray
    }
}
