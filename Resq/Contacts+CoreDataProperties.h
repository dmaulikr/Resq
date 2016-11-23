//
//  Contacts+CoreDataProperties.h
//  
//
//  Created by Muhammad Ahsan on 11/24/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contacts.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contacts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *contact_id;
@property (nullable, nonatomic, retain) NSString *deviceToken;
@property (nullable, nonatomic, retain) NSNumber *frequentCount;
@property (nullable, nonatomic, retain) NSNumber *isBuddy;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *phoneNumber;

@end

NS_ASSUME_NONNULL_END
