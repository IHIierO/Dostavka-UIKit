//
//  RealmConfigurator.swift
//  DostavkaUIkit
//
//  Created by Artem Vorobev on 12.08.2022.
//

import RealmSwift

enum RealmMigrator {
  // 1
  static private func migrationBlock(
    migration: Migration,
    oldSchemaVersion: UInt64
  ) {
    // 2
    if oldSchemaVersion < 1 {
        
    }
  }
  static var configuration: Realm.Configuration {
    Realm.Configuration(schemaVersion: 1, migrationBlock: migrationBlock)
  }
}
