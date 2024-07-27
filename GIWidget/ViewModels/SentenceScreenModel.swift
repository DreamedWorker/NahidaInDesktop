//
//  SentenceScreenModel.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/24.
//

import Foundation


class SentenceScreenModel : ObservableObject {
    let sentenceFile = rootFileURL?.appending(component: "sentences.json")
    @Published var sentences: [[String : Any]] = [[:]]
    private var filteredList: [[String : Any]] = [[:]]
    @Published var loadSuccess = false
    private var loadedJSON: JSON? = nil
    
    func loadSentences(){
        sentences.removeAll()
        if initialSentence() {
            let oriData = sentenceFile!.getPathWithoutEscape().readString().data(using: .utf8)!
            do {
                loadedJSON = try JSON(data: oriData)
                sentences = loadedJSON!["context"].arrayValue.map{$0.dictionaryObject!}
                loadSuccess = true
            } catch {
                loadSuccess = false
            }
        } else {
            loadSuccess = false
        }
    }
    
    func getGroups() -> [String] {
        do {
            let groupFile = rootFileURL!.appending(component: "groups.json").getPathWithoutEscape()
                .readString().data(using: .utf8)!
            let loadedJSON = try JSON(data: groupFile)
            return loadedJSON["context"].arrayValue.map{ $0.stringValue }
        } catch {
            return []
        }
    }
    
    func removeTile(index: Int){
        sentences.remove(at: index)
    }
    
    func showWantedList(requiredKey: String){
        filteredList.removeAll()
        filteredList = sentences.filter{ ($0["group"] as! String).contains(requiredKey) }
        sentences.removeAll()
        sentences = filteredList
    }
    
    func addSingleSentence(context: String, group: String) {
        sentences.append(["value": context, "group": group])
    }
    
    func saveSentences() -> Bool {
        do {
            let jsonp = SentenceEntry(context: sentences.map { SingleSentence(value: $0["value"] as! String, group: $0["group"] as! String)})
            let encoder = JSONEncoder()
            let transferData = try encoder.encode(jsonp)
            let final: String = String(data: transferData, encoding: .utf8)!
            return final.writeString(filePath: sentenceFile!.getPathWithoutEscape())
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private func initialSentence() -> Bool {
        if checkForExist(filePath: sentenceFile!.getPathWithoutEscape()) {
            return true
        } else {
            let defaultValue = """
{"context": [{"value": "世界，充满未解之谜…", "group": "Traveller"}]}
"""
            return defaultValue.writeString(filePath: sentenceFile!.getPathWithoutEscape())
        }
    }
}
