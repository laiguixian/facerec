"""Performs face alignment and calculates L2 distance between the embeddings of images."""
#识别模块，，，赖桂显，，，2018年09月10日
# MIT License
# 
# Copyright (c) 2016 David Sandberg
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from scipy import misc
import tensorflow as tf
import numpy as np
import sys
import os
import copy
import argparse
import facenet
import align.detect_face
import time
import redis

def main(args):
    comparepath="E:\\chuangyelei\\ruanjian\\facenet\\compare\\";
    with tf.Graph().as_default():

        with tf.Session() as sess:
            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':加载模型')
            # Load the model
            facenet.load_model(args.model)
            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':获取Tensorflow的输入输出')
            # Get input and output tensors
            images_placeholder = tf.get_default_graph().get_tensor_by_name("input:0")
            embeddings = tf.get_default_graph().get_tensor_by_name("embeddings:0")
            phase_train_placeholder = tf.get_default_graph().get_tensor_by_name("phase_train:0")
            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':标识服务的运行状态')
            file_handle =open(comparepath+"comparerunning.txt",mode='a+')#以读写方式打开文件
            file_handle.write('人脸识别服务运行文件，请勿删除，否则人脸识别服务器将停止')
            file_handle.close()
            #imagesfs = ("compare/01/1.jpg", "compare/01/2.jpg", "compare/01/3.jpg", "compare/01/4.jpg", "compare/01/5.jpg")
            #images = load_and_align_data(args.image_files, args.image_size, args.margin, args.gpu_memory_fraction)
            while os.path.exists(comparepath+"comparerunning.txt"):
                list = os.listdir("compare") #列出文件夹下所有的目录与文件
                for i in range(0,len(list)):
                    if list[i].startswith("tocompare") and list[i].endswith(".txt"):
                        try:
                            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':找到需要识别的任务')
                            file_handle =open(comparepath+list[i],mode='r')#以读方式打开任务文件，读取任务图片路径
                            content = file_handle.readline().strip()#读取识别内容
                            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':内容：'+content)
                            if (content.find(",")<0):
                                specid=file_handle.readline().strip()#读取特征串
                                print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':特征串：'+specid)
                                #file_handle =open(comparepath+"photobase\\photobase.txt",mode='r')#以读方式打开文件，读取任务图片库图片路径
                                #photobaselist = file_handle.read()
                                #file_handle.close()
                                print('执行到1')
                                r = redis.Redis(host='127.0.0.1',password='bxvDq0305107226*', port=8693, decode_responses=True)
                                #r.set(specid,'00000000000000000000000000000000');
                                print('执行到2')
                                photobaselist=r.get(specid)   #读取特征值对应的图片库字符串
                                if photobaselist is None:
                                    photobaselist="";
                                print('执行到3')
                                # print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':测试redis：'+r.get('redissuccess'))
                                print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':执行断点')
                                print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':图片库字符串：'+photobaselist)
                                print('执行到4')
                                if len(photobaselist)>0:
                                    content=content+","+photobaselist;
                                print('执行到5')
                            file_handle.close()
                            # os.remove(comparepath+list[i])
                            os.rename(comparepath+list[i],comparepath+list[i]+".do")
                            imagesfs=content.split(",");
                            images = load_and_align_data(imagesfs, args.image_size, args.margin, args.gpu_memory_fraction)
                            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':Run forward pass to calculate embeddings')
                            # Run forward pass to calculate embeddings
                            feed_dict = { images_placeholder: images, phase_train_placeholder:False }
                            emb = sess.run(embeddings, feed_dict=feed_dict)
                             
                            #nrof_images = len(args.image_files)
                            nrof_images = len(imagesfs)
                         
                            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':Images:')
                            for k in range(nrof_images):
                                print('%1d: %s' % (k, imagesfs[k]))
                            print('')
                             
                            # Print distance matrix
                            print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+':Distance matrix')
                            print('    ', end='')
                            for l in range(nrof_images):
                                print('    %1d     ' % l, end='')
                            print('')
                            resultstr="";
                            sultminnum=10.0;
                            sultminstr="";
                            for j in range(nrof_images):
                                dist = np.sqrt(np.sum(np.square(np.subtract(emb[0,:], emb[j,:]))))
                                if j!=0 and sultminnum>dist:
                                    sultminstr=imagesfs[j]+","+('%1.4f' % dist);
                                    sultminnum=dist
                                #resultstr=resultstr+(","+('%1.4f' % dist) if len(resultstr)>0 else ('%1.4f' % dist))
                                #print('  %1.4f  ' % dist, end='')
                            #print('')
                            resultstr=sultminstr;
                            file_handle =open(comparepath+list[i]+'.done',mode='a')#以读写方式打开任务文件，写入结果信息
                            file_handle.write('\n'+resultstr)
                            file_handle.close()
                        except Exception as e:
                            file_handle =open(comparepath+list[i]+'.done',mode='a')#以读写方式打开任务文件，写入异常信息
                            file_handle.write('\n识别出错')
                            file_handle.close()
                            print ("出现错误:",e)
                        print ("识别完成")
                time.sleep(1) # 暂停 1 秒
            print ("识别服务关闭")
                        
                        
             
            
            
def load_and_align_data(image_paths, image_size, margin, gpu_memory_fraction):

    minsize = 20 # minimum size of face
    threshold = [ 0.6, 0.7, 0.7 ]  # three steps's threshold
    factor = 0.709 # scale factor
    
    print('Creating networks and loading parameters')
    with tf.Graph().as_default():
        gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=gpu_memory_fraction)
        sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options, log_device_placement=False))
        with sess.as_default():
            pnet, rnet, onet = align.detect_face.create_mtcnn(sess, None)
  
    tmp_image_paths=copy.copy(image_paths)
    img_list = []
    for image in tmp_image_paths:
        img = misc.imread(os.path.expanduser(image), mode='RGB')
        img_size = np.asarray(img.shape)[0:2]
        bounding_boxes, _ = align.detect_face.detect_face(img, minsize, pnet, rnet, onet, threshold, factor)
        if len(bounding_boxes) < 1:
          image_paths.remove(image)
          print("can't detect face, remove ", image)
          continue
        det = np.squeeze(bounding_boxes[0,0:4])
        bb = np.zeros(4, dtype=np.int32)
        bb[0] = np.maximum(det[0]-margin/2, 0)
        bb[1] = np.maximum(det[1]-margin/2, 0)
        bb[2] = np.minimum(det[2]+margin/2, img_size[1])
        bb[3] = np.minimum(det[3]+margin/2, img_size[0])
        cropped = img[bb[1]:bb[3],bb[0]:bb[2],:]
        aligned = misc.imresize(cropped, (image_size, image_size), interp='bilinear')
        prewhitened = facenet.prewhiten(aligned)
        img_list.append(prewhitened)
    images = np.stack(img_list)
    return images

def parse_arguments(argv):
    parser = argparse.ArgumentParser()
    
    parser.add_argument('model', type=str, 
        help='Could be either a directory containing the meta_file and ckpt_file or a model protobuf (.pb) file')
    #parser.add_argument('image_files', type=str, nargs='+', help='Images to compare')
    parser.add_argument('--image_size', type=int,
        help='Image size (height, width) in pixels.', default=160)
    parser.add_argument('--margin', type=int,
        help='Margin for the crop around the bounding box (height, width) in pixels.', default=44)
    parser.add_argument('--gpu_memory_fraction', type=float,
        help='Upper bound on the amount of GPU memory that will be used by the process.', default=1.0)
    return parser.parse_args(argv)

if __name__ == '__main__':
    main(parse_arguments(sys.argv[1:]))
