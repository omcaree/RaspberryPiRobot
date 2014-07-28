%% Detect the presence of a target with the Raspberry Pi Camera
% Copyright 2014 The MathWorks, Inc.

%% Connect to the Raspberry Pi
myPi = raspi('192.168.0.1','pi','raspberry')

%% Connect to the camera board
myCam = cameraboard(myPi,'Resolution', '320x240')

%% Set up GPIO as input
configureDigitalPin(myPi, 18, 'input')

%% Connect to the serial port
mySP = serialdev(myPi,'/dev/ttyAMA0', 57600)

%% Send a message to the motor controller
pan = 0;
tilt = -20;
data = formatMotorMessage(128, 128, pan, tilt);
write(mySP,data);

%% Keep reading images from the camera until we press the button
figure
subplot(1,3,1);

while (~readDigitalPin(myPi,18))
    mySnapshot = snapshot(myCam);
    imshow(mySnapshot);
    title('Live');
end
hold on;
title('Snapshot');
%% Display green channel
red = mySnapshot(:,:,1);
green = mySnapshot(:,:,2);
blue = mySnapshot(:,:,3);

subplot(1,3,2);
imshow(green);
title('Green Channel');

%% Calculate green intensity
greenIntensity = green - red/2 - blue/2;

subplot(1,3,2);
imshow(greenIntensity);
title('Green Intensity');

%% Threshold the intensity image to create a binary image
greenThreshold = 40;
greenBinary = greenIntensity > greenThreshold;

subplot(1,3,3);
imshow(greenBinary)
title('Green Binary');

%% Determine how many pixels big the target is
numberOfGreenPixels = sum(greenBinary(:))

%% Close connection to camera and Raspberry Pi
clear myCam myPi mySP