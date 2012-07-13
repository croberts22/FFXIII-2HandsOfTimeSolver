//
//  Common.h
//  HandsOfTimeSolver
//
//  Created by Corey Roberts on 6/1/12.
//  Copyright (c) 2012 SpacePyro Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define API_VERSION_NUMBER @"1.1"
//#define API_BASE_URL  @"http://www.ffxiii-2handsoftimesolver.coreyjustinroberts.com/api"

#define API_VERSION_NUMBER @"v1.1"
#define API_BASE_URL @"http://ffxiii-2.texasdrums.com/api"
#define API_APP_UPDATE [NSString stringWithFormat:@"%@/app_update.php?", API_BASE_URL]
#define API_REGISTER_USERNAME [NSString stringWithFormat:@"%@/%@/add_user.php?", API_BASE_URL, API_VERSION_NUMBER]
#define API_SUBMIT_PUZZLE [NSString stringWithFormat:@"%@/%@/submit_puzzle.php?", API_BASE_URL, API_VERSION_NUMBER]
#define API_UPDATE_LIST [NSString stringWithFormat:@"%@/%@/update.php?", API_BASE_URL, API_VERSION_NUMBER]

@interface Common : NSObject

@end
