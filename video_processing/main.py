import cv2     # for capturing videos
import math   # for mathematical operations
import matplotlib.pyplot as plt    # for plotting the images
import pandas as pd
from keras.preprocessing import image   # for preprocessing the images
import numpy as np    # for mathematical operations
from keras.utils import np_utils
from skimage.transform import resize   # for resizing images
import imutils
import os

# Please refer to the websites below for original source code
# This code modifies their code
# https://www.geeksforgeeks.org/pedestrian-detection-using-opencv-python/
# https://www.pyimagesearch.com/2015/11/09/pedestrian-detection-opencv/


############################# Create People Detector #######################################
hog = cv2.HOGDescriptor() 
hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector()) 

############################# Get MP4 files ################################################
file_list = [f for f in os.listdir('.') if os.path.isfile(os.path.join('.', f)) and f.endswith('.mp4')]

####################### Create folders for each MP4 and loop over all ######################
parent_dir = os.getcwd()
for ii in range(0, len(file_list)):
    fn = file_list[ii]
    print(fn)
    directory = "%s/%s_results" % (parent_dir, fn[0:len(fn)-4:])
    os.mkdir(directory)

    ############################# Main Algorithm ###########################################
    count = 0
    videoFile = "%s/%s" % (parent_dir, fn)

    cap = cv2.VideoCapture(videoFile)   # capturing the video from the given path
    frameRate = cap.get(5)  # frame rate
    x = 1
    while(cap.isOpened()):
        frameId = cap.get(1)  # current frame number
        ret, frame = cap.read()
        if (ret != True):
            break
        if (frameId % math.floor(frameRate) == 0):
            filename = "frame%d.jpg" % count
            count += 1
            # cv2.imwrite(filename, frame)

            frame = imutils.resize(frame,
                                width=min(400, frame.shape[1]))

            # Detecting all the regions in the Image that has a pedestrians inside it
            (regions, _) = hog.detectMultiScale(frame,
                                                winStride=(4, 4),
                                                padding=(4, 4),
                                                scale=1.05)

            # Drawing the regions in the Image
            for (x, y, w, h) in regions:
                cv2.rectangle(frame, (x, y),
                            (x + w, y + h),
                            (0, 0, 255), 2)

            # Write to file only if person is detected
            if len(regions):
                new_filename = os.path.join(directory, filename)
                cv2.imwrite(new_filename, frame)
            
            # Showing the output Image
            cv2.imshow("Image", frame)
            if cv2.waitKey(25) & 0xFF == ord('q'):
                break

    cap.release()
    cv2.destroyAllWindows() 
    print("Done!")