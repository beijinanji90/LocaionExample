//
//  ViewController.m
//  YSLocation
//
//  Created by chenfenglong on 2017/3/4.
//  Copyright © 2017年 chenfenglong. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationMgr;

@property (nonatomic,strong) CLGeocoder *geocoder;

@property (weak, nonatomic) IBOutlet UILabel *textLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationMgr = [[CLLocationManager alloc] init];
    self.locationMgr.delegate = self;
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationMgr.distanceFilter = kCLDistanceFilterNone;
    [self.locationMgr requestAlwaysAuthorization];
    [self.locationMgr startUpdatingLocation];
    
    self.geocoder = [[CLGeocoder alloc] init];
    self.textLbl.numberOfLines = 0;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f 速度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude, currLocation.speed);
    
    __weak typeof(self) _weakSelf = self;
    [self.geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks lastObject];
        NSLog(@"详细信息:%@",placeMark.addressDictionary);
        [placeMark.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *keyName = key;
            NSString *valueName = obj;
            NSString *newString = [NSString stringWithFormat:@"%@ -> %@",keyName,valueName];
            NSString *text = _weakSelf.textLbl.text;
            _weakSelf.textLbl.text = [NSString stringWithFormat:@"%@\n%@",text,newString];
        }];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        NSLog(@"用户拒绝");
    }
    
    if (error.code == kCLErrorLocationUnknown) {
        NSLog(@"用户未知的地理位置");
    }
}




@end
