//
//  TrieConvertor.swift
//  Backbase
//
//  Created by Zahra Aghajani on 10/16/18.
//  Copyright © 2018 Zahra Aghajani. All rights reserved.
//

//  Trie DataStructure From: https://github.com/raywenderlich/swift-algorithm-club

import Foundation

class TrieNode<T: Hashable, U> {
    weak var parentNode: TrieNode?
    
    var value: T?
    var data: U?
    var children: [T: TrieNode] = [:]
    var isTerminating = false
    var isLeaf: Bool {
        return children.count == 0
    }

    init(value: T? = nil, parentNode: TrieNode? = nil) {
        self.value = value
        self.parentNode = parentNode
    }
    
    func add(value: T) {
        guard children[value] == nil else {
            return
        }
        children[value] = TrieNode(value: value, parentNode: self)
    }
}


class Trie<T> {
    typealias Node = TrieNode<Character, T>
    
    fileprivate let root: Node
    fileprivate var wordCount: Int
    
    init() {
        root = Node()
        wordCount = 0
    }
    
    public var words: [T] {
        return wordsInSubtrie(rootNode: root, partialWord: "")
    }
}

extension Trie {
    func insert(word: String, data: T) {
        guard !word.isEmpty else { return }
        
        var currentNode = root
        for character in word.lowercased() {
            if let childNode = currentNode.children[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                currentNode = currentNode.children[character]!
            }
        }

        guard !currentNode.isTerminating else { return }
        wordCount += 1
        currentNode.isTerminating = true
        currentNode.data = data
    }
    
    private func findLastNodeOf(word: String) -> Node? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }
    
    fileprivate func wordsInSubtrie(rootNode: Node, partialWord: String) -> [T] {
        var subtrieWords = [T]()
        var previousLetters = partialWord
        
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        
        if rootNode.isTerminating {
            subtrieWords.append(rootNode.data!)
        }
        
        for childNode in rootNode.children.values {
            let childWords = wordsInSubtrie(rootNode: childNode, partialWord: previousLetters)
            subtrieWords += childWords
        }
        
        return subtrieWords
    }
    
    func findWordsWithPrefix(prefix: String) -> [T] {
        var words = [T]()
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isTerminating {
                words.append(lastNode.data!)
            }
            
            for childNode in lastNode.children.values {
                let childWords = wordsInSubtrie(rootNode: childNode, partialWord: prefixLowerCased)
                words += childWords
            }
        }
        return words
    }
}
