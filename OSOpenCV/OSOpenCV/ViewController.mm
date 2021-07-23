//
//  ViewController.m
//  OSOpenCV
//
//  Created by prliu on 2017/8/10.
//  Copyright © 2017年 pingan. All rights reserved.
//
#import <opencv2/opencv.hpp>
//#import <opencv2/imgcodecs/ios.h>
#import "ViewController.h"

using namespace cv;
using namespace std;

@interface ViewController ()
{
    cv::CascadeClassifier faceDetection;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self imageDetection];
   
}

-(void)imageDetection{
    
    NSString *xml = [[NSBundle mainBundle]pathForResource:@"cascade" ofType:@"xml"];

    faceDetection.load(xml.UTF8String);
    //摄像头
    [self detectionFromeCapture];
}

-(void)detectionFromeCapture{
    
    VideoCapture cap;
    cap.open(0); //打开摄像头
    if(!cap.isOpened())
        return;
    Mat frame;
     while(1)
     {
        cap>>frame;//等价于cap.read(frame);
        //Canny(frame, frame, 30, 100);//canny边缘检测，去掉这一行就是纯粹的读取摄像头了
        if(frame.empty())
            break;
         if(waitKey(20)>0)//按下任意键退出摄像头　　因电脑环境而异，有的电脑可能会出现一闪而过的情况
             break;
         cv::resize(frame, frame, cv::Size(frame.cols*0.8,frame.rows*0.8));
         cvtColor(frame, frame, CV_RGB2GRAY);
         std::vector<cv::Rect> faces_rect;
         cv::flip(frame,frame,1);
         faceDetection.detectMultiScale(frame, faces_rect,1.2,3,0,cv::Size(60,60),cv::Size(frame.cols*0.8,frame.cols*0.8));
         printf("face_count:%lu\n",faces_rect.size());
         for (int i = 0 ; i < faces_rect.size() ; i ++) {

             cv::rectangle(frame, faces_rect[i], cv::Scalar(255,0,255) , 2);

         }
         cvtColor(frame, frame, CV_GRAY2RGB);
         imshow("video", frame);

     }
    cap.release();
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end
