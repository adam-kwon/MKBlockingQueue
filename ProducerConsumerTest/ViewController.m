//
//  ViewController.m
//  ProducerConsumerTest
//
//  Created by Min Kwon on 5/28/14.
//  Copyright (c) 2014 Min Kwon. All rights reserved.
//

#import "ViewController.h"
#import "MKBlockingQueue.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) MKBlockingQueue *blockingQueue;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.blockingQueue = [[MKBlockingQueue alloc] init];
    
    [self performSelectorInBackground:@selector(producerThread) withObject:nil];
    [self performSelectorInBackground:@selector(consumerThread) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)producerThread
{
    while (YES)
    {
        [_blockingQueue enqueue:[NSString stringWithFormat:@"Test string %d", arc4random()%30000]];
        [NSThread sleepForTimeInterval:arc4random()%3+1];
    }
}

- (void)consumerThread
{
    while (YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _textView.text = [_textView.text stringByAppendingString:@"Waiting for data...\n"];
        });

        NSString *s = [_blockingQueue dequeue];
        dispatch_async(dispatch_get_main_queue(), ^{
            _textView.text = [_textView.text stringByAppendingString:[NSString stringWithFormat:@"\tDequeued: %@\n", s]];
        });
    }
}

@end
