## CSVWriter

A CSV writer made in Swift.

Main features:

* Use a NumberFormatter

* Use a custom separator

* Add rows with any type

* Concatenate multiple methods:

  * ```swift
    CSVWriter(separator: ";", columns: historyKeys, useDefaultNumberFormatter: true)
    		.addNumbersRow(historyValues, withTitle: "Fitness")
    		.save(to: URL(fileURLWithPath: "\(directoryRoot)/4/Output/SimulatedAnnealing-3.csv"))
    ```

    