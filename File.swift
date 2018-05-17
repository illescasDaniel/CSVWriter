//
//  File.swift
//  P1-MH
//
//  Created by Daniel Illescas Romero on 04/03/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

struct File {
	
	@discardableResult static func save(_ content: String, to path: URL?) -> Bool {
		do {
			if let validURL = path {
				try content.write(to: validURL, atomically: true, encoding: .utf8)
			} else {
				return false
			}
		}
		catch {
			return false
		}
		return true
	}
	
	static func read(from filePath: URL?) -> String? {
		
		var content = String()
		do {
			if let validURL = filePath {
				content = try String(contentsOf: validURL, encoding: .utf8)
			} else {
				return nil
			}
		}
		catch {
			return nil
		}
		
		return content
	}
	
	@discardableResult static func remove(file: String, from directory: String) -> Bool {
		
		do {
			try FileManager.default.removeItem(atPath: "\(directory)/\(file)")
		} catch {
			return false
		}
		return true
	}
	
	static var documentsDirectory: URL? {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	static var currentDirectory: URL? {
		return URL(string: FileManager.default.currentDirectoryPath)
	}
}
