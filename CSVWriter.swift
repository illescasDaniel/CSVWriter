/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

extension NumberFormatter {
	convenience init(decimalSeparator: String, numberStyle: NumberFormatter.Style) {
		self.init()
		self.currencyDecimalSeparator = decimalSeparator
		self.numberStyle = numberStyle
	}
}

class CSVWriter {
	
	private(set) var outputCSV: String = ""
	let numberFormatter: NumberFormatter?
	
	let separator: String
	let columns: [String]
	
	init(separator: String, columns: String..., useDefaultNumberFormatter: Bool = false) {
		
		self.separator = separator
		self.columns = columns
		self.numberFormatter = useDefaultNumberFormatter ? NumberFormatter(decimalSeparator: ",", numberStyle: .decimal) : nil
		
		self.addRow(columns)
	}
	
	init(separator: String, columns: [String], useDefaultNumberFormatter: Bool = false) {
		
		self.separator = separator
		self.columns = columns
		self.numberFormatter = useDefaultNumberFormatter ? NumberFormatter(decimalSeparator: ",", numberStyle: .decimal) : nil
		
		self.addRow(columns)
	}
	
	init(separator: String, columns: String..., numberFormatter: NumberFormatter) {
		
		self.separator = separator
		self.columns = columns
		self.numberFormatter = numberFormatter
		
		self.addRow(columns)
	}
	
	@discardableResult func addNumbersRow(withValues columnValues: Any..., withTitle title: String = "") -> CSVWriter {
		self.addNumbersRow(withValues: columnValues, withTitle: title)
		return self
	}
	
	@discardableResult func addNumbersRow(_ columnValues: [Any], withTitle title: String = "") -> CSVWriter {
		
		let stringColumnValues: [String] = columnValues.map { value in
			if let numberFormatter = numberFormatter, let number = value as? NSNumber, let validString = numberFormatter.string(from: number) {
				return validString
			}
			return String(describing: value)
		}
		
		self.addRow([title] + stringColumnValues)
		return self
	}
	
	@discardableResult func addRow(_ columnValues: [String]) -> CSVWriter {
		if columnValues.count == self.columns.count {
			self.outputCSV += columnValues.joined(separator: self.separator) + "\n"
		}
		return self
	}
	
	func save(to path: URL, restartWriterAfterSaving: Bool = false) {

		File.save(self.outputCSV, to: path)
		
		if restartWriterAfterSaving {
			self.restartWriter()
		}
	}
	
	func restartWriter() {
		self.outputCSV = ""
		self.addRow(self.columns)
	}
}

extension CSVWriter {
	
	convenience init<Type: CustomStringConvertible>(separator: String, columns: [Type], useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map{ $0.description }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	convenience init<Type: CustomStringConvertible>(separator: String, columns: Type..., useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map{ $0.description }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	convenience init(separator: String, columns: [Any], useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map { String(describing: $0) }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	convenience init(separator: String, columns: Any..., useDefaultNumberFormatter: Bool = false) {
		self.init(separator: separator, columns: columns.map { String(describing: $0) }, useDefaultNumberFormatter: useDefaultNumberFormatter)
	}
	
	@discardableResult func addRow(withValues columnValues: Any...) -> CSVWriter {
		self.addRow(withValues: columnValues)
		return self
	}
	
	@discardableResult func addRow(_ columnValues: [Any]) -> CSVWriter {
		self.addRow(columnValues.map { String(describing: $0) })
		return self
	}
}
