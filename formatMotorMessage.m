function [ data ] = formatMotorMessage( left, right, pan, tilt )
%FORMATMOTORMESSAGE Create the message buffer to send to the motor
%controller
%   Byte 1: 255 (start byte 1)
%   Byte 2: 255 (start byte 2)
%   Byte 3: Message ID (value 0x02 = command)
%   Byte 4: Message Length (Number of bytes being sent, 9 in this case)
%   Byte 5: Command for left motor (0-255, 128 is stopped)
%   Byte 6: Command for right motor
%   Byte 7: Command for pan servo (0-180, degrees)
%   Byte 8: Command for tilt servo
%   Byte 9: Checksum (complement of sum of bytes)
%
% Copyright 2014 The MathWorks, Inc.
messageID = 2;
messageLength = 9;

tilt = tilt + 80;
pan = pan + 90;

data = uint8([255 255 messageID messageLength left right pan tilt 0]);

% Checksum is the complement of the sum of each byte
% Excluding start characters
sum = uint32(0);
for i=3:(messageLength-1)
    sum = sum + uint32(data(i));
end
data(end) = uint8(bitcmp(sum,'uint32'));

end

