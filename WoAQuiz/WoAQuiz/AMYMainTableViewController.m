//
//  AMYMainTableViewController.m
//  DreamGame
//
//  Created by Amy Joscelyn on 1/19/16.
//  Copyright © 2016 Amy Joscelyn. All rights reserved.
//

#import "AMYMainTableViewController.h"
#import "AMYStoryDataStore.h"
#import "ZhuLi.h"

@interface AMYMainTableViewController ()

@property (nonatomic, strong) AMYStoryDataStore *dataStore;
@property (strong, nonatomic) Question *currentQuestion;
@property (strong, nonatomic) NSArray *sortedChoices;
@property (strong, nonatomic) NSMutableArray *choicesArray;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSMutableArray *colorsArray;
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;

@property (nonatomic) CGFloat textHue;
@property (nonatomic) CGFloat saturation;
//@property (nonatomic) NSUInteger colorInteger;

@end

@implementation AMYMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataStore = [AMYStoryDataStore sharedStoryDataStore];
    
    [self.dataStore fetchData];
    
    [self setCurrentQuestionOfStory:self.dataStore.playthrough.currentQuestion];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0]; //maybe play around with this to see if i can make it not turn gray at the bottom
    
    self.colorsArray = [[NSMutableArray alloc] init];
    
    self.topColor = [UIColor colorWithRed:255/255.0 green:233/255.0 blue:200/255.0 alpha:1.0];
    [self.colorsArray addObject:(id)self.topColor.CGColor];
    [self.colorsArray addObject:(id)self.topColor.CGColor];
    
    [self changeBackgroundColor];
}

- (void)changeBackgroundColor
{
    NSNumber *charm = @(self.dataStore.playerCharacter.charm);
    NSNumber *practical = @(self.dataStore.playerCharacter.practical);
    NSNumber *history = @(self.dataStore.playerCharacter.history);
    NSNumber *potions = @(self.dataStore.playerCharacter.potions);
    NSNumber *healing = @(self.dataStore.playerCharacter.healing);
    NSNumber *divining = @(self.dataStore.playerCharacter.divining);
    NSNumber *animalia = @(self.dataStore.playerCharacter.animalia);
    
    NSArray *arrayOfMajors = @[ @{ @"major" : @"charm"      ,
                                   @"value" : charm },
                                @{ @"major" : @"practical"  ,
                                   @"value" : practical },
                                @{ @"major" : @"history"    ,
                                   @"value" : history },
                                @{ @"major" : @"potions"    ,
                                   @"value" : potions },
                                @{ @"major" : @"healing"    ,
                                   @"value" : healing },
                                @{ @"major" : @"divining"   ,
                                   @"value" : divining },
                                @{ @"major" : @"animalia"   ,
                                   @"value" : animalia },
                                @{ @"major" : @"new game"   ,
                                   @"value" : @1 }
                                ];
    
    NSSortDescriptor *sortByHighestValue = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO];
    NSArray *sortedArrayOfMajors = [arrayOfMajors sortedArrayUsingDescriptors:@[sortByHighestValue]];
    
    NSDictionary *highestValueMajor = sortedArrayOfMajors.firstObject;
    NSLog(@"major: %@", highestValueMajor);
    
    NSDictionary *secondHighestValueMajor = sortedArrayOfMajors[1];
    //should this be a property/attribute?  since i'll have to call on it later for the prereq check? or will i handle that all here???? just to see if it's divining...
    //i need to prepare for the use case that secondhighestvaluemajor might be tied!!!!
    
    NSString *major = highestValueMajor[@"major"];
    
    if ([major isEqualToString:@"charm"])
    {
        self.bottomColor = [UIColor colorWithRed:192/255.0 green:0.0 blue:0.0 alpha:1.0];
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.charm;
    }
    else if ([major isEqualToString:@"practical"])
    {
        self.bottomColor = [UIColor colorWithRed:192/255.0 green:96/255.0 blue:0.0 alpha:1.0];
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.practical;
    }
    else if ([major isEqualToString:@"history"])
    {
        self.bottomColor = [UIColor colorWithRed:0.0 green:96/255.0 blue:192/255.0 alpha:1.0]; //should this just be 0,0,192, like green and red?
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.history;
    }
    else if ([major isEqualToString:@"potions"])
    {
        self.bottomColor = [UIColor colorWithRed:96/255.0 green:0.0 blue:192/255.0 alpha:1.0];
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.potions;
    }
    else if ([major isEqualToString:@"healing"])
    {
        self.bottomColor = [UIColor colorWithRed:0.0 green:192/255.0 blue:0.0 alpha:1.0];
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.healing;
    }
    else if ([major isEqualToString:@"divining"])
    {
        self.bottomColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.divining;
    }
    else if ([major isEqualToString:@"animalia"])
    {
        self.bottomColor = [UIColor colorWithRed:192/255.0 green:192/255.0 blue:0.0 alpha:1.0];
        self.dataStore.playerCharacter.chosenMajorValue = self.dataStore.playerCharacter.animalia;
    }
    else
    {
        self.bottomColor = [UIColor colorWithRed:255/255.0 green:233/255.0 blue:200/255.0 alpha:1.0];
    }
    [self.colorsArray replaceObjectAtIndex:1 withObject:(id)self.bottomColor.CGColor];
    
    self.gradientLayer.colors = self.colorsArray;
}

- (void)setCurrentQuestionOfStory:(Question *)currentQuestion
{
    _currentQuestion = currentQuestion;
    _sortedChoices = [currentQuestion.choiceOuts sortedArrayUsingDescriptors:@[self.dataStore.sortByStoryIDAsc]];
    
    _dataStore.playthrough.currentQuestion = currentQuestion;
    
    [_dataStore saveContext];
    
    [self generateChoicesArrayForCurrentQuestion:currentQuestion];
}

- (void)generateChoicesArrayForCurrentQuestion:(Question *)currentQuestion
{
    self.choicesArray = [[NSMutableArray alloc] init];
    
    if (self.sortedChoices.count > 0)
    {
        for (Choice *choice in currentQuestion.choiceOuts)
        {
            if (choice.prerequisites.count == 0)
            {
                [self.choicesArray addObject:choice];
            }
            else
            {
                ZhuLi *zhuLi = [ZhuLi new];
                BOOL passesCheck = NO;
                
                for (Prerequisite *prereq in choice.prerequisites)
                {
                    //this needs to come back as YES to be displayed among the choices
                    passesCheck = [zhuLi checkPrerequisite:prereq];
                    //                    NSLog(@"passesCheck 3? %d", passesCheck);
                    if (passesCheck)
                    {
                        NSLog(@"%@ should be displayed", choice.content);
                        [self.choicesArray addObject:choice];
                    }
                    else //I don't really need this but I'll keep it here for now to make sure it works
                    {
                        NSLog(@"%@ should NOT be displayed", choice.content);
                    }
                }
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
        case 1:
        {
            NSInteger choiceOutsCount = self.choicesArray.count;
            if (choiceOutsCount > 0)
            {
                return choiceOutsCount;
            }
            else
            {
                return 1;
            }
        }
        default:
        {
            return 0;
        }
    }
}

//this is a messy, messy method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoryCell" forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    //    cell.backgroundColor = [UIColor colorWithHue:self.textHue saturation:self.saturation brightness:0.85 alpha:1.0];
    
    if (self.dataStore.playthrough.fontChange)
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"Palatino" size:22.5]];
    }
    else
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:23.5]];
    }
    
    if (section == 0)
    {
        cell.textLabel.text = self.currentQuestion.content;
        cell.textLabel.textColor = [UIColor colorWithHue:self.textHue saturation:1.0 brightness:0.25 alpha:1.0];
        cell.textLabel.numberOfLines = 0;
        
        cell.detailTextLabel.hidden = YES;
        
        cell.userInteractionEnabled = NO;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 45;
    }
    else if (section == 1)
    {
        if (self.choicesArray.count > 0)
        {
            Choice *choice = self.choicesArray[row];
            cell.textLabel.text = choice.content;
        }
        else if (self.currentQuestion.questionAfter)
        {//maybe this should be in section 3, and hide section 2?
            cell.textLabel.text = @"Continue";
        }
        else if ([self.currentQuestion.content isEqualToString:@"THE END."])
        {
            cell.textLabel.text = @"(tap to restart)";
        }
        else
        {
            cell.textLabel.text = @"You have reached a precarious end with no further content! (Hang here for a bit or tap to restart)";
        }
        cell.textLabel.textColor = [UIColor colorWithHue:self.textHue saturation:1.0 brightness:0.5 alpha:1.0];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.hidden = YES;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger indentation = 0;
    
    if (section)
    {
        indentation += 3;
    }
    return indentation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { return; }
    
    NSUInteger row = indexPath.row;
    
    ZhuLi *zhuLi = [ZhuLi new];
    
    if (self.currentQuestion.effects.count > 0)
    { //this takes care of effects the currentQuestion might incur
        for (Effect *thing in self.currentQuestion.effects)
        {
            [zhuLi doThe:thing];
        }
    }
    
    if (self.currentQuestion.questionAfter)
    {
        [self setCurrentQuestionOfStory:self.currentQuestion.questionAfter];
    }
    else if (self.choicesArray.count > 0)
    {
        Choice *selectedChoice = self.choicesArray[row];
        
        if (selectedChoice.effects.count)
        {
            for (Effect *thing in selectedChoice.effects)
            {
                if ([thing.stringValue isEqualToString:@""])
                {
                    Choice *selectedChoice = self.choicesArray[row];
                    thing.stringValue = selectedChoice.content;
                }
                [zhuLi doThe:thing];
            }
        }
        [self setCurrentQuestionOfStory:selectedChoice.questionOut];
    }
    else
    {
        [self setCurrentQuestionOfStory:self.dataStore.questions[0]];
        
        // below resets the properties
        self.dataStore.playthrough.fontChange = NO;
        
        self.dataStore.playthrough.answerQ1 = @"";
        self.dataStore.playthrough.answerQ2 = @"";
        self.dataStore.playthrough.answerQ3 = @"";
        self.dataStore.playthrough.answerQ3A = @"";
        self.dataStore.playthrough.answerQ3B = @"";
        self.dataStore.playthrough.answerQ4 = @"";
        self.dataStore.playthrough.answerQ5 = @"";
        self.dataStore.playthrough.answerQ6 = @"";
        self.dataStore.playthrough.answerQ7 = @"";
        self.dataStore.playthrough.answerQ7A = @"";
        self.dataStore.playthrough.answerQ8 = @"";
        self.dataStore.playthrough.answerQ9 = @"";
        self.dataStore.playthrough.answerQ10 = @"";
        self.dataStore.playthrough.answerQ11 = @"";
        
        self.dataStore.playerCharacter.charm = 0;
        self.dataStore.playerCharacter.practical = 0;
        self.dataStore.playerCharacter.history = 0;
        self.dataStore.playerCharacter.potions = 0;
        self.dataStore.playerCharacter.healing = 0;
        self.dataStore.playerCharacter.divining = 0;
        self.dataStore.playerCharacter.animalia = 0;
        
        self.dataStore.playthrough.creativityChosen = NO;
        self.dataStore.playthrough.intelligenceChosen = NO;
        self.dataStore.playthrough.obedienceChosen = NO;
        self.dataStore.playthrough.empathyChosen = NO;
        self.dataStore.playthrough.instinctChosen = NO;
        self.dataStore.playthrough.perseveranceChosen = NO;
        self.dataStore.playthrough.kindnessChosen = NO;
        
        self.textHue = 0;
        self.saturation = 0.8;
        
        [_dataStore saveContext];
        
        // go to next chapter or restart
    }
    //    self.colorInteger += 3; //5 is a little jarring, 3 is good, but probably less will be better and more subtle without needing animation
    //    [self changeBackgroundColor:self.colorInteger];
    
    [self changeBackgroundColor];
    
    [self.tableView reloadData];
}

/*
 I have the entities set up already for prerequisites and effects.
 Effects: write some into the content, attribute them to choices, then write code to read those effects--properties that will change when the effect is triggered
 Prerequisites: write some into the choices (if there are two choices that are superficially the same, but lead to different corresponding questions because of different prerequisites, the properties should filter through the prereqs and only display one of those similar choices to avoid confusion and apparent duplication), write code to have them read the properties.  Only display the ones that pass the check--the check is a BOOL, and if the BOOL is YES, display the choice.  If it is NO, ignore it.
 
 I still need to set up some entities, for the story, the world, and the character.
 Playthrough: this entity should hold the state of the entire story--the current question the app is closed on, as well as the latest saved state if the story's progress is manually saved.  It should also hold relationships with the World and the PlayerCharacter as well as Question.
 World: this should have attributes for all of the appropriate world details that are dynamic and can be changed by effects from the player's choices.
 PlayerCharacter: this should have attributes for the character that differs player to player, game to game: Name, PhysicalCharacteristics, Traits, Skills, and Inventory.  Some of those might be better suited as their own Entities than as mere attributes, but I can decide that when I get there.
 */


/*
 Now I'm on to the tricky bit.
 
 I have QUESTIONS with prerequisites.  BUT INSTEAD OF THAT I should have CHOICES with prerequisites.  Because that's the code I've just handled to write, see?
 If I have a number of choices (6, in this case) that lead out to a different question, I won't have to worry about which Question will be displayed.
 So I have Three Prerequisites: Accepted?, Diviner?, and Skilled?
 I have 6 different options for Questions, 3 for Accepted?=YES, and 3 for Accepted?=NO.
 A tree is already starting to form!
 2 of each of those 3 require Diviner?=YES
 1 of those subsequent 2 require Skilled?=YES, while the other 1 requires Skilled?=NO.
 
 Okay.  I have my tree all laid out on paper.  It looks like it should work!  Since only one can be chosen, whichever one of those the logic lands on will be added to the choicesArray.  Yay!
 
 So what I need to do now is make sure I have properties for those prerequisites to check
 Accepted is easy: if their chosen major is >= 10, they are accepted
 Then I need an array for top two majors.  This is also easy.  It's just taking the first and second indexes of the sorted array
 To check for the top two majors, I refer to this new array.
 If Divining is one of them, Divining?=YES
 Then I need to know whether they're skilled at Divining or not.  So diviningSkill = the integerValue.  Easy peasy!
 
 Because these are prereqs, they need to be attributes of Playthrough.  Or maybe Character, because I haven't done anything with that one here yet.  Yeah.  Let's go with Character.
 */

/*
 choices were missing for Qs 7/7A.  Why?  See what's up with this.
 it loses choices gradually over time... i'm not resetting the properties properly at end of game
 suggestion to make everything clear or blurry, but not the awkward gray of the background right now
 maybe a different text color--a gray, brown, or black, perhaps
 */

@end
