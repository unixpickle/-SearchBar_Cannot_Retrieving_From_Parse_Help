//
//  SSViewController.m
//  SearchBar_Tutorial
//
//  Created by Mathias on 25/2/13.
//  Copyright (c) 2013 Mathias. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()
{
    NSMutableArray *totalStrings;
    NSMutableArray *filteredStrings;
    
    BOOL isFiltered;
}

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mySearchBar.delegate =self;
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
  
    [self retrieveFromParse];
    

}

- (void) retrieveFromParse {
    PFQuery *retrievePets = [PFQuery queryWithClassName:@"pets"];
    [retrievePets  whereKeyExists:@"pets"];  
    
    [retrievePets findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@", objects);
            totalStrings = [[NSMutableArray alloc] initWithArray:objects];
            
        }
        [self.myTableView reloadData];
    }];
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; 
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *) searchText{
    if (searchText.length ==0){
        isFiltered =NO;}
    else{
        isFiltered =YES;
        
        
        filteredStrings=[[NSMutableArray alloc]init];
        for(NSString *str in totalStrings) {
            NSRange stringRange =[str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (stringRange.location !=NSNotFound) {
                [filteredStrings addObject:str];
            }
        }
    }
    
    [self.myTableView reloadData];
}

//table view datasource and delegate method.....

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    if (isFiltered){
        return [filteredStrings count];
    }return [totalStrings count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
              
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(!isFiltered){
       
        PFObject *tempObject =[totalStrings objectAtIndex: indexPath.row];
        cell.textLabel.text = [tempObject objectForKey:@"pets"];
    }
    else
    {
      PFObject *tempObject2 =[filteredStrings objectAtIndex: indexPath.row];
        cell.textLabel.text =[tempObject2  objectForKey:@"pets"];
    }
    return cell;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
