//
//  DropboxFile.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/22.
//

import Foundation

struct DropboxFile {
    var id: UUID
    var title: String
    var body: String
    var clientModified: TimeInterval
    
    init(id: String, title: String, body: String, clientModified: Date) {
        self.id = UUID(uuidString: id) ?? UUID()
        self.title = title
        self.body = body
        self.clientModified = clientModified.timeIntervalSince1970
    }
}