//
//  NBStudent.m
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/23/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBStudent.h"

@implementation NBStudent

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        NSArray *firstNames = [[NSArray alloc] initWithObjects:
                               @"Alex",@"Tran", @"Lenore", @"Bud", @"Fredda", @"Katrice",
                               @"Clyde", @"Hildegard", @"Vernell", @"Nellie", @"Rupert",
                               @"Billie", @"Tamica", @"Crystle", @"Kandi", @"Caridad",
                               @"Vanetta", @"Taylor", @"Pinkie", @"Ben", @"Rosanna",
                               @"Eufemia", @"Britteny", @"Ramon", @"Jacque", @"Telma",
                               @"Colton", @"Monte", @"Pam", @"Tracy", @"Tresa",
                               @"Willard", @"Mireille", @"Roma", @"Elise", @"Trang",
                               @"Ty", @"Pierre", @"Floyd", @"Savanna", @"Arvilla",
                               @"Whitney", @"Denver", @"Norbert", @"Meghan", @"Tandra",
                               @"Jenise", @"Brent", @"Elenor", @"Sha", @"Jessie", nil];
        
        NSArray *lastNames = [[NSArray alloc] initWithObjects:
                              
                              @"Farrah", @"Laviolette", @"Heal", @"Sechrest", @"Roots",
                              @"Homan", @"Starns", @"Oldham", @"Yocum", @"Mancia",
                              @"Prill", @"Lush", @"Piedra", @"Castenada", @"Warnock",
                              @"Vanderlinden", @"Simms", @"Gilroy", @"Brann", @"Bodden",
                              @"Lenz", @"Gildersleeve", @"Wimbish", @"Bello", @"Beachy",
                              @"Jurado", @"William", @"Beaupre", @"Dyal", @"Doiron",
                              @"Plourde", @"Bator", @"Krause", @"Odriscoll", @"Corby",
                              @"Waltman", @"Michaud", @"Kobayashi", @"Sherrick", @"Woolfolk",
                              @"Holladay", @"Hornback", @"Moler", @"Bowles", @"Libbey",
                              @"Spano", @"Folson", @"Arguelles", @"Burke", @"Rook", nil];

        
        self.firstName = [firstNames objectAtIndex:arc4random() % [firstNames count]];
        self.lastName = [lastNames objectAtIndex:arc4random() % [lastNames count]];
        self.gender = arc4random() % 2;
        self.birhYear = arc4random() % 31 + 1970;
        
        CLLocationCoordinate2D location;
        location.latitude = (((float)arc4random()/0x100000000)*(50.491186 - 50.405115) + 50.405115);
        location.longitude = (((float)arc4random()/0x100000000)*(30.522401 - 30.399289) + 30.399289);
        
        self.coordinate = location;
        self.title = [NSString stringWithFormat:@"%@ %@", self.firstName, self. lastName];
        self.subtitle = [NSString stringWithFormat:@"%ld", (long)self.birhYear];
    }
    
    return self;
}


- (NSString*) description {
    
    NSString* description = [NSString stringWithFormat:@"\rFirst name - %@\rLast name - %@\rLocation - {%f, %f}",
                             self.firstName, self.lastName, self.coordinate.latitude, self.coordinate.longitude];
    
    return description;
}

@end
