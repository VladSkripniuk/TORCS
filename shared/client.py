#!/usr/bin/python

from matplotlib import pyplot as plt

import snakeoil
import screenpipe
from time import sleep

if __name__ == "__main__":
    C = snakeoil.Client()
    pipe = screenpipe.screenpipe()

    for step in xrange(C.maxSteps,0,-1):
        
		img = pipe.get_image()
        #plt.imshow(img)
        #plt.show()
        #print 1
        C.get_servers_input()
        snakeoil.drive_example(C)
        C.respond_to_server()

    #    print 2
    C.shutdown()