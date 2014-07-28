/* Copyright 2014 The MathWorks, Inc. */
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>

int setupSerialPort(const char* device, unsigned int baud) {
    /* Open the serial port */
    int spHandle = open(device, O_RDWR | O_NOCTTY | O_NDELAY);
    if (spHandle <= 0) {
        fprintf(stderr,"Error opening '%s': ", device);
        perror("");
        return spHandle;
    }
    
    /* Determine baud rate */
    speed_t baudRate;
    switch(baud) {
        case 1200:
            baudRate = B1200;
            break;
        case 1800:
            baudRate = B1800;
            break;
        case 2400:
            baudRate = B2400;
            break;
        case 4800:
            baudRate = B4800;
            break;
        case 9600:
            baudRate = B9600;
            break;
        case 19200:
            baudRate = B19200;
            break;
        case 38400:
            baudRate = B38400;
            break;
        case 57600:
            baudRate = B57600;
            break;
        case 115200:
            baudRate = B115200;
            break;
        default:
            printf("Unsupported baudrate %d for '%c', using 57600\n", baud, device);
            baudRate = B57600;
    }
    struct termios options;
	tcgetattr(spHandle, &options);
	options.c_cflag = baudRate | CS8 | CLOCAL | CREAD;
	options.c_iflag = IGNPAR;
	options.c_oflag = 0;
	options.c_lflag = 0;
	tcflush(spHandle, TCIFLUSH);
	tcsetattr(spHandle, TCSANOW, &options);
    
    return spHandle;
}