''' 
This file is used to: 
    1. receive image data from torcs
    2. store data in hdf5 format
'''

import zmq
import torcs_data_pb2
import sys
import matplotlib.pyplot as plt
import numpy as np
import cv2
# uncomment h5py related lines to be able to save array of images from the screen
# import h5py


class screenpipe():
    def __init__(self):

        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REQ)
        port = "5555"
        self.socket.connect("tcp://localhost:%s" %port)
        # print "Connecting to pipe..."

        # Set up protobuf class
        self.serialized_data = torcs_data_pb2.TorcsData()

        # self.image_dataset = []
        # h5_dataset_name = "/home/torcs_dataset/dataset.hdf5"
        # hf = h5py.File(h5_dataset_name, "wb")

    def get_image(self):
        
        # Receive data and parse it
        self.socket.send("LD")
        message = self.socket.recv()
        self.serialized_data.ParseFromString(message)

        
        width = list(self.serialized_data.width)[0]
        height = list(self.serialized_data.height)[0]
        save_falg = list(self.serialized_data.save_flag)[0]
        red_array = list(self.serialized_data.red)[0]
        green_array = list(self.serialized_data.green)[0]
        blue_array = list(self.serialized_data.blue)[0]
        red = np.empty(len(red_array), dtype = np.uint8)
        green = np.empty(len(green_array), dtype = np.uint8)
        blue = np.empty(len(blue_array), dtype = np.uint8)

        # image_array = list(serialized_data.image)[0]
        # image = np.empty(len(image_array), dtype = np.uint8)

        # for j in range(width * height * 3):
        #     image[j] = np.uint8(ord(image_array[j]))

        # Convert uchar to uint8
        red = np.fromstring(red_array, dtype=np.uint8)
        green = np.fromstring(green_array, dtype=np.uint8)
        blue = np.fromstring(blue_array, dtype=np.uint8)
        
        #for j in range(width * height):
        #    red[j] = np.uint8(ord(red_array[j]))
        #    green[j] = np.uint8(ord(green_array[j]))
        #    blue[j] = np.uint8(ord(blue_array[j]))

        red = red.reshape(height, width)
        green = green.reshape(height, width)
        blue = blue.reshape(height, width)
        
        return np.concatenate([red[np.newaxis,:,:], green[np.newaxis,:,:], blue[np.newaxis,:,:]], axis=0)

        # image = cv2.merge([red, green, blue])

        # plt.imshow(image)
        # plt.show()

        # print "[width, height] = [{}, {}]".format(width, height)

        # image_dataset.append(image)
        # if save_falg == 1:
            # image_np_dataset = np.array(image_dataset)
            # print "****image_np_dataset.shape =", image_np_dataset.shape
            # hf.create_dataset('h5_image', data = image_np_dataset)
            # print "dataset saved at: " + h5_dataset_name
            # break
            


