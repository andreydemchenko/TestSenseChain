//
//  URL+Ext.swift
//  TestSenseChain
//
//  Created by zuzex-62 on 05.12.2022.
//

import Foundation

extension URL {
    
    var getFileSize: String {
        var fileSize: Int?
        do {
            let resources = try self.resourceValues(forKeys:[.fileSizeKey])
            fileSize = resources.fileSize!
            print ("\(String(describing: fileSize))")
        } catch {
            print("Error: \(error)")
        }
        if let fileSize {
            if fileSize < 999 {
                return String(format: "%lu bytes", CUnsignedLong(bitPattern: fileSize))
            }
            
            var floatSize = Float(fileSize / 1000)
            if floatSize < 999 {
                return String(format: "%.1f KB", floatSize)
            }
            
            floatSize = floatSize / 1000
            if floatSize < 999 {
                return String(format: "%.1f MB", floatSize)
            }
            
            floatSize = floatSize / 1000
            return String(format: "%.1f GB", floatSize)
        }
        return "0 KB"
    }
    
}
