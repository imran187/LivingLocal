//
//  LLWebServiceManager.h
//  FeedApp
//
//  Created by TechLoverr on 24/09/16.
//
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

@interface LLWebServiceManager : AFHTTPSessionManager

@property(nonatomic, strong) NSString *bearerToken;
@property(nonatomic, strong) NSDate *expiryDate;
@property(nonatomic, strong) LLUser *loggedUser;
@property(nonatomic, strong) LLHood *selctedHood;
@property(nonatomic, strong) NSArray<LLHood *> *hoods;
@property(nonatomic, strong) NSArray<LLSection *> *sections;
@property(nonatomic, strong) NSArray<LLSection *> *selectedSections;

+ (instancetype)sharedManager;

- (void)authenticateUser:(NSString *)emailId
            withPassword:(NSString *)password
            onCompletion:(void (^)(BOOL success))completion;
- (void)loginUser:(NSString *)emailId
     withPassword:(NSString *)password
     onCompletion:(void (^)(BOOL success))completion;
- (void)forgotPasswordFor:(NSString *)emailId
             onCompletion:(void (^)(BOOL success))completion;
- (void)signUpFor:(LLUser *)user
     onCompletion:(void (^)(BOOL success))completion;
- (void)getHoodsOnCompletion:(void (^)(BOOL success))completion;
- (void)getSectionsOnCompletion:(void (^)(BOOL success))completion;
- (void)getTimelinePostsForSections:(NSString *)sections
                          ForHoodId:(NSInteger)hoodId
                      ForPageNumber:(NSInteger)pageNumber
                       OnCompletion:
                           (void (^)(BOOL success, NSArray *posts))completion;
- (void)updateBioFor:(LLUser *)user
        onCompletion:(void (^)(BOOL success))completion;
- (void)updateUserFor:(LLUser *)user
         onCompletion:(void (^)(BOOL success))completion;
- (void)updatePasswordFor:(LLUser *)user
             onCompletion:(void (^)(BOOL success))completion;
- (void)updateInterestsFor:(LLUser *)user
              onCompletion:(void (^)(BOOL success))completion;
- (void)getTopHoodersForHood:(NSInteger)hoodId
                onCompletion:
                    (void (^)(BOOL success, NSArray *arrData))completion;
- (void)getProfileFor:(NSString *)userId
         onCompletion:(void (^)(BOOL success, LLUser *user))completion;
- (void)updateRelevantForUserId:(NSString *)userId
                   ForContentId:(NSInteger)contentId
                   onCompletion:
                       (void (^)(BOOL success, NSInteger count))completion;
- (void)getGroupsForUserId:(NSString *)userId
                WithHoodId:(NSInteger)hoodId
              onCompletion:(void (^)(BOOL success, NSArray *groups))completion;
- (void)getEventsForFilter:(NSInteger)filter
                WithHoodId:(NSInteger)hoodId
              onCompletion:(void (^)(BOOL success, NSArray *groups))completion;
- (void)checkEmailFor:(LLUser *)user
         onCompletion:(void (^)(BOOL success))completion;
- (void)getVerificationCodeFor:(LLUser *)user
                  onCompletion:
                      (void (^)(BOOL success, NSString *code))completion;
- (void)updateCommentRelevantForUserId:(NSString *)userId
                          ForContentId:(NSInteger)commentId
                            IsRelevant:(BOOL)isRelevant
                          onCompletion:(void (^)(BOOL success,
                                                 NSInteger count))completion;
- (void)reportSpam:(LLPost *)post
      onCompletion:(void (^)(BOOL success))completion;
- (void)getPostDetail:(LLPost *)post
         onCompletion:(void (^)(BOOL success, LLPost *post))completion;
- (void)InsertCommentFor:(LLUser *)user
             commentText:(NSString *)comment
                 ForPost:(LLPost *)post
            onCompletion:(void (^)(BOOL success))completion;
- (void)getGroupTimelinePostsForGroupId:(NSInteger)groupId
                          ForPageNumber:(NSInteger)pageNumber
                           OnCompletion:(void (^)(BOOL success,
                                                  NSArray *posts))completion;
- (void)getGroupDetailForGroup:(LLGroup *)group
                  onCompletion:
                      (void (^)(BOOL success, NSArray *group))completion;
- (void)joinGroup:(LLGroup *)group
     onCompletion:(void (^)(BOOL success))completion;
- (void)createPostFor:(LLUser *)user
         articleTitle:(NSString *)title
   articleDescription:(NSString *)articleDescription
              section:(LLSection *)section
                group:(LLGroup *)group
               photos:(NSArray *)photos
          recommended:(BOOL)isRecommended
             fileList:(NSArray *)arrFiles
         onCompletion:(void (^)(BOOL success))completion;
- (void)createGroupFor:(LLUser *)user
           description:(NSString *)desc
             groupName:(NSString *)groupName
               section:(LLSection *)section
       groupCoverPhoto:(NSString *)groupCoverPhoto
          onCompletion:(void (^)(BOOL success))completion;
- (void)getNotificationsForUserId:(NSString *)userID
                     OnCompletion:
                         (void (^)(BOOL success, NSArray *posts))completion;
- (void)deleteNotification:(LLNotification *)notification
              onCompletion:(void (^)(BOOL success))completion;
- (void)getUserTimelinePostsForSections:(NSString *)sections
                              ForHoodId:(NSInteger)hoodId
                          ForPageNumber:(NSInteger)pageNumber
                              ForUserId:(NSString *)userId
                           OnCompletion:(void (^)(BOOL success,
                                                  NSArray *posts))completion;
- (void)uploadBlobToContainer:(UIImage *)image
                 onCompletion:
                     (void (^)(BOOL success, NSString *path))completion;
- (void)leaveGroup:(LLGroup *)group
      onCompletion:(void (^)(BOOL success))completion;
- (void)createEvent:(LLEvent *)event
            forUser:(LLUser *)user
       onCompletion:(void (^)(BOOL success, NSString *eventId))completion;
- (void)addImages:(NSArray *)paths
         forEvent:(NSString *)eventId
     onCompletion:(void (^)(BOOL success))completion;
- (void)getIsInterestedForEvent:(NSInteger)eventId
                   onCompletion:(void (^)(BOOL success))completion;
- (void)getEvent:(NSInteger)eventId
    onCompletion:(void (^)(BOOL success, LLEvent *event))completion;
- (void)updateEventInterestForUserId:(NSString *)userId
                          ForEventId:(NSInteger)eventId
                        onCompletion:
                            (void (^)(BOOL success, NSInteger count))completion;
- (void)getAllImagesForEvent:(NSInteger)eventId
                OnCompletion:(void (^)(BOOL success, NSArray *paths))completion;
- (void)getEventCommentsForEvent:(NSInteger)eventId
                    onCompletion:
                        (void (^)(BOOL success, NSArray *comments))completion;
- (void)InsertCommentFor:(LLUser *)user
             commentText:(NSString *)comment
                ForEvent:(LLEvent *)event
            onCompletion:(void (^)(BOOL success))completion;
- (void)getRecommendationPostsForSections:(NSString *)sections
                                ForHoodId:(NSInteger)hoodId
                            ForPageNumber:(NSInteger)pageNumber
                             OnCompletion:(void (^)(BOOL success,
                                                    NSArray *posts))completion;
- (void)getGroupsForUserId:(NSString *)userId
              onCompletion:(void (^)(BOOL success, NSArray *groups))completion;
- (void)getIsInterestedForEvent:(NSInteger)eventId
                      ForUserId:(NSString *)userId
                   onCompletion:(void (^)(BOOL success))completion;
- (void)markNotificationRead:(NSInteger)notificationID
                onCompletion:(void (^)(BOOL success))completion;
- (void)searchHoodersForHood:(NSInteger)hoodId
                 WithKeyword:(NSString *)keyword
                onCompletion:
                    (void (^)(BOOL success, NSArray *arrData))completion;
- (void)getEventsForKeyword:(NSString *)text
                 WithHoodId:(NSInteger)hoodId
               onCompletion:(void (^)(BOOL success, NSArray *events))completion;
- (void)getEventsForUser:(NSInteger)userId
            onCompletion:(void (^)(BOOL success, NSArray *groups))completion;
- (void)getInterestedEventsForUser:(NSInteger)userId
                      onCompletion:(void (^)(BOOL success, NSArray *groups))completion;
- (void)getUserTimelinePostsForHoodId:(NSInteger)hoodId
                           ForKeyword:(NSString *)keyword
                         OnCompletion:(void (^)(BOOL success,
                                                NSArray *posts))completion;
@end
