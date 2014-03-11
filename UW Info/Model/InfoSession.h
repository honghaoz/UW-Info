//
//  InfoSession.h
//  UW Info
//
//  Created by Zhang Honghao on 2/7/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface InfoSession : NSObject <NSCopying, NSCoding>

//attribute that not changed
@property (nonatomic, assign) NSUInteger sessionId;
@property (nonatomic, copy) NSString *employer;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *audience;
@property (nonatomic, copy) NSString *programs;
@property (nonatomic, copy) NSString *description;
//@property (nonatomic, readonly, unsafe_unretained) NSURL *logoImageURL;
@property (nonatomic, assign) NSUInteger weekNum;

// alerts related attributes
@property (nonatomic, assign) BOOL alertIsOn;
@property (nonatomic, strong) NSMutableArray *alerts;

// calendar EKEvent
@property (nonatomic, strong) EKEvent *ekEvent;

// two id related to Calendar Event
@property (nonatomic, copy) NSString *calendarId;
@property (nonatomic, copy) NSString *eventId;

// other attributes
@property (nonatomic, assign) BOOL isCancelled;
@property (nonatomic, copy) NSString *note;

// Dictionary of alerts description, interval and sequence
+ (NSDictionary *) alertChoiceDictionary;
+ (NSString *)getAlertDescription:(NSNumber *)alertChoice;
+ (NSDictionary *) alertIntervalDictionary;
+ (NSDictionary *) alertSequenceDictionary;
+ (NSString *)getAlertSequence:(NSNumber *)alertChoice;

+ (NSDictionary *) alertDescriptionForNotificationDictionary;

// Used for manage calendar event, only initiate once!
+ (EKEventStore *) eventStore;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

- (NSComparisonResult)compareTo:(InfoSession *)anotherInfoSession;

- (BOOL)isEqual:(InfoSession *)anotherInfoSession;

- (BOOL)isChangedCompareTo:(InfoSession *)anotherInfoSession;

//- (NSURL *)logoImageURL;

// alerts related methods
- (BOOL)addOneAlert;
- (BOOL)alertsIsFull;

- (id)getValueFromAlertDictionaryAtIndex:(NSInteger)index ForKey:(NSString *)key;
- (void)setAlertChoiceForAlertDictionaryAtIndex:(NSInteger)index newChoice:(NSInteger)alertChoice;

- (BOOL)isRemovedAfterRefreshingAlerts;
// calendar alerts
- (NSArray *)getEKAlarms;

- (void)cancelNotifications;
- (void)scheduleNotifications;

// get an unique identifier string
- (NSString *)getIdentifier;

+ (NSDateFormatter *)estDateFormatter;
@end
