package com.tdr.getface;

import org.opencv.core.*;
import org.opencv.core.Point;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;
import org.opencv.objdetect.CascadeClassifier;
 
import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
public class getFaceDetector {
	static {
		System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
	}
	//设置默认参数
	String Detectorrootpath="D:/opencv/sources/data/haarcascades_cuda/";//CascadeClassifier(级联分类器，即训练出来的供识别特征用的模型参数)
	
	/* 可用来检测睁开或闭着的眼睛：
	haarcascade_mcs_lefteye.xml
	haarcascade_lefteye_2splits.xml
	仅可以检测睁开的眼睛：
	haarcascade_eye.xml
	haarcascade_eye_tree_eyeglasses.xml [仅在带被检测者戴眼镜时方可检测]
	 */
	/*
	 * 检测性别
	 */
	public String checksex(String imagePath) {
		String sex="未知";
		Mat image = Imgcodecs.imread(imagePath);  //读取图片
		// 从配置文件中创建一个人脸眼镜识别器
 		CascadeClassifier eyeglassesDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_eye_tree_eyeglasses.xml");
        // 在图片中检测人眼
        MatOfRect eyeglassesDetections = new MatOfRect();
  
        eyeglassesDetector.detectMultiScale(image, eyeglassesDetections, 1.1,2,0,new Size(20,20),new Size(30,30));
        //eyeglassesDetector.detectMultiScale(image, eyeglassesDetections);
        if (eyeglassesDetections.toArray().length>2)
        	return "检验不通过，检测出"+eyeglassesDetections.toArray().length+"只眼镜";
        System.out.println("检测出的眼镜："+eyeglassesDetections.toArray().length);
        for(Rect rect:eyeglassesDetections.toArray()) {
            Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                    + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
        }
		return sex;
	}
	/*
	 * 判断输入的图片是否达到可以识别的标准，否则返回错误信息（不符合的原因）
	 */
	public String isphotook(String imagePath) {
		
		// 载入opencv的库
		//System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
		 
        Mat image = Imgcodecs.imread(imagePath);  //读取图片
        
        /*// 从配置文件中创建一个人脸眼镜识别器
 		CascadeClassifier eyeglassesDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_eye_tree_eyeglasses.xml");
        // 在图片中检测人眼
        MatOfRect eyeglassesDetections = new MatOfRect();
  
        eyeglassesDetector.detectMultiScale(image, eyeglassesDetections, 1.1,2,0,new Size(20,20),new Size(30,30));
        //eyeglassesDetector.detectMultiScale(image, eyeglassesDetections);
        if (eyeglassesDetections.toArray().length>2)
        	return "检验不通过，检测出"+eyeglassesDetections.toArray().length+"只眼镜";
        System.out.println("检测出的眼镜："+eyeglassesDetections.toArray().length);
        for(Rect rect:eyeglassesDetections.toArray()) {
            Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                    + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
        }*/
 
		// 从配置文件中创建一个人脸眼睛识别器
		CascadeClassifier eyeDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_eye.xml");
        // 在图片中检测人眼
        MatOfRect eyeDetections = new MatOfRect();
 
        //eyeDetector.detectMultiScale(image, eyeDetections, 2.0,1,1,new Size(20,20),new Size(20,20));
        eyeDetector.detectMultiScale(image, eyeDetections);
        //if (eyeDetections.toArray().length!=2)
        //	return "检验不通过，检测出"+eyeDetections.toArray().length+"只眼睛";
        //画出边框
        for(Rect rect:eyeDetections.toArray()) {
            Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                    + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
        }

        // 从配置文件中创建一个人脸鼻子识别器
 		CascadeClassifier noseDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_mcs_nose.xml");
 		// 在图片中检测鼻子
        MatOfRect noseDetections = new MatOfRect();
  
        //noseDetector.detectMultiScale(image, noseDetections, 2.0,1,1,new Size(20,20),new Size(20,20));
        noseDetector.detectMultiScale(image, noseDetections);
        //if (noseDetections.toArray().length!=1)
        //	return "检验不通过，检测出"+noseDetections.toArray().length+"个鼻子";
        //画出边框
        for(Rect rect:noseDetections.toArray()) {
            Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                    + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
        }
        
        // 从配置文件中创建一个人脸嘴巴识别器
		CascadeClassifier mouthDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_mcs_mouth.xml");
		// 在图片中检测鼻子
        MatOfRect mouthDetections = new MatOfRect();
   
        //mouthDetector.detectMultiScale(image, mouthDetections, 2.0,1,1,new Size(20,20),new Size(20,20));
        mouthDetector.detectMultiScale(image, mouthDetections);
        //if (mouthDetections.toArray().length!=1)
        //	return "检验不通过，检测出"+mouthDetections.toArray().length+"个嘴巴";
        //画出边框
        for(Rect rect:mouthDetections.toArray()) {
            Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                    + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
        }
        
        // 从配置文件中创建一个人脸识别器
 		CascadeClassifier smileDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_frontalface_alt.xml");
        // 在图片中检测人脸
        MatOfRect smileDetections = new MatOfRect();
  
        //smileDetector.detectMultiScale(image, smileDetections, 2.0,1,1,new Size(50,50),new Size(50,50));
        smileDetector.detectMultiScale(image, smileDetections);
        //if (smileDetections.toArray().length!=1)
        //	return "检验不通过，检测出"+smileDetections.toArray().length+"只眼睛";
        //画出边框
        for(Rect rect:smileDetections.toArray()) {
        	Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                     + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
        }
        
        Imgcodecs.imwrite(imagePath+"0.jpg", image);
        System.out.println("输出画出特征的照片："+imagePath+"0.jpg");
        
		return "检验通过";
	}
	
	/*
	 * 截取图片区域并返回截图图片路径列表（以逗号隔开的字符串）
	 */
	public boolean dealrects(Rect[] rects,String outFile,Mat image,String[] results) {
		try {
			results[0]="";
			for(int i=0;i<rects.length;i++) {
		    	// 在每一个识别出来的人脸周围画出一个方框
		        Rect rect = rects[i];
		 
		        Imgproc.rectangle(image, new Point(rect.x-2, rect.y-2),
		                          new Point(rect.x + rect.width, rect.y + rect.height),
		                          new Scalar(0, 255, 0));
		        imageCutbyimage(image,rect.x, rect.y,rect.width,rect.height,160,160,outFile+(i+1)+".jpg");
		        //Imgcodecs.imwrite(outFile, image);
		        
		        results[0]=results[0]+(results[0].length()>0?",":"")+outFile+(i+1)+".jpg";
		        //System.out.println(String.format("人脸识别成功，人脸图片文件为： %s", outFile+(i+1)+".jpg"));
		    }
			//Imgcodecs.imwrite(outFile+"0.jpg", image);
			return true;
		}catch(Exception ee) {
			System.out.println("识别结果析出出错："+ee.getMessage());
			return false;
		}
	}
    /**
     * opencv实现人脸识别
     * @param imagePath 要识别的图片路径
     * @param dettype 要识别的类型：1（1个人脸），0（n个人脸）
     * 返回值为一个字符数组，用数组不用json或xml，是想提高效率，返回的数组第一个值是返回的图片路径（可能多个图片，多个图片用逗号隔
     * 开，单个图片无逗号，第二个值是返回的人脸数，第三个值是识别状态：success（识别成功），failed（识别失败），识别成功是指识别类型为1，实际识别
     * 1个人脸为成功，但识别1个人脸以上时照样为失败，识别类型为0，则可能识别任意个人脸（包含0个）
     * @throws Exception
     */
    public String[] detectFace(String imagePath,  int dettype)
    {
        
    	String[] resultsl= {"","0","不符合识别条件，没有找到人脸"};
    	try {
    		// 载入opencv的库
    		//System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    		
	        // 从配置文件lbpcascade_frontalface.xml中创建一个人脸识别器，该文件位于opencv安装目录中
	        CascadeClassifier faceDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_frontalface_alt.xml");
	 
	        Mat image = Imgcodecs.imread(imagePath);
	        
	        // 定义人脸检测
	        MatOfRect faceDetections = new MatOfRect();
	 
	        faceDetector.detectMultiScale(image, faceDetections);
	 
	        // 在图片中检测人脸数
	 
	        Rect[] rects = faceDetections.toArray();
	        
	        if(rects != null && rects.length > 0){
		        if(dettype==1) {
		        	if(rects.length == 1){
		        		dealrects(rects,imagePath,image,resultsl);
		        		resultsl[1]="1";
		        		resultsl[2]="符合识别条件";
		        	}else if(rects.length >1){
		        		resultsl[1]=String.valueOf(rects.length);
		        		resultsl[2]="不符合识别条件，多于一个人脸";
		        	}else{
		        		resultsl[1]=String.valueOf(rects.length);
		        		resultsl[2]="不符合识别条件，没有找到人脸";
		        	}
		        }else if(dettype==0) {
		        	
	        		if(rects.length >0){
	        			dealrects(rects,imagePath,image,resultsl);
			        	resultsl[1]=String.valueOf(rects.length);
		        		resultsl[2]="符合识别条件";
		        	}else{
		        		resultsl[1]=String.valueOf(rects.length);
		        		resultsl[2]="不符合识别条件，没有找到人脸";
		        	}
		        }
	        }
        }catch(Exception ee) {
        	System.out.println("识别出现异常："+ee.getMessage());
        }
        return resultsl;
 
    }
 
 
    /**
     * opencv实现人眼识别
     * @param imagePath
     * @param outFile
     * @throws Exception
     */
    public boolean detectEye(String imagePath,  String outFile){
 
    	try {
    		// 载入opencv的库
    		//System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    		
    		CascadeClassifier eyeDetector = new CascadeClassifier(Detectorrootpath+"haarcascade_eye.xml");
	 
	        Mat image = Imgcodecs.imread(imagePath);  //读取图片
	 
	        // 在图片中检测人脸
	        MatOfRect faceDetections = new MatOfRect();
	 
	        eyeDetector.detectMultiScale(image, faceDetections, 2.0,1,1,new Size(20,20),new Size(20,20));
	 
	        System.out.println(String.format("Detected %s eyes", faceDetections.toArray().length));
	        Rect[] rects = faceDetections.toArray();
	        if(rects != null && rects.length <2){
	            throw new RuntimeException("不是一双眼睛");
	        }
	        Rect eyea = rects[0];
	        Rect eyeb = rects[1];
	        System.out.println("a-中心坐标 " + eyea.x + " and " + eyea.y);
	        System.out.println("b-中心坐标 " + eyeb.x + " and " + eyeb.y);
	        //获取两个人眼的角度
	        double dy=(eyeb.y-eyea.y);
	        double dx=(eyeb.x-eyea.x);
	        double len=Math.sqrt(dx*dx+dy*dy);
	        System.out.println("dx is "+dx);
	        System.out.println("dy is "+dy);
	        System.out.println("len is "+len);
	        double angle=Math.atan2(Math.abs(dy),Math.abs(dx))*180.0/Math.PI;
	        System.out.println("angle is "+angle);
	        for(Rect rect:faceDetections.toArray()) {
	            Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
	                    + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
	        }
	        Imgcodecs.imwrite(outFile, image);
	        System.out.println(String.format("人眼识别成功，人眼图片文件为： %s", outFile));
	        return true;
    	}catch(Exception ee) {
        	System.out.println("识别出现异常："+ee.getMessage());
        	return false;
        }
    }
    /**
     * 从图片路径载入图片，裁剪图片并重新装换大小
     * @param imagePath
     * @param posX
     * @param posY
     * @param width
     * @param height
     * @param outFile
     */
    public boolean imageCut(String imagePath,String outFile, int posX,int posY,int width,int height ){
        try {
	    	//原始图像
	        Mat image = Imgcodecs.imread(imagePath);
	        //截取的区域：参数,坐标X,坐标Y,截图宽度,截图长度
	        Rect rect = new Rect(posX,posY,width,height);
	        //两句效果一样
	        Mat sub = image.submat(rect);   //Mat sub = new Mat(image,rect);
	        Mat mat = new Mat();
	        Size size = new Size(300, 300);
	        Imgproc.resize(sub, mat, size);//将人脸进行截图并保存
	        Imgcodecs.imwrite(outFile, mat);
	        return true;
    	}catch(Exception ee) {
        	System.out.println("裁剪出现异常："+ee.getMessage());
        	return false;
        }
    }
    
    /**
     * 直接从传入的图片裁剪图片并重新装换大小
     * @param image   传入的图片
     * @param posX    裁剪的x坐标
     * @param posY    裁剪的y坐标
     * @param width   裁剪的宽度
     * @param height  裁剪的高度
     * @param outFile 输出的文件名
     * @param newwidth新的宽度
     * @param newheight新的高度
     */
    public boolean imageCutbyimage(Mat image, int posX,int posY,int width,int height ,int newwidth,int newheight,String outFile){
        try {
	        //截取的区域：参数,坐标X,坐标Y,截图宽度,截图长度
	        Rect rect = new Rect(posX,posY,width,height);
	        //两句效果一样
	        Mat sub = image.submat(rect);   //Mat sub = new Mat(image,rect);
	        Mat mat = new Mat();
	        Size size = new Size(newwidth, newheight);
	        Imgproc.resize(sub, mat, size);//将人脸进行截图并保存
	        Imgcodecs.imwrite(outFile, mat);
	        return true;
    	}catch(Exception ee) {
        	System.out.println("裁剪出现异常："+ee.getMessage());
        	return false;
        }
    }
    
    /**
     *
     * @param imagePath
     * @param outFile
     */
    public boolean setAlpha(String imagePath,  String outFile) {
        /**
         * 增加测试项
         * 读取图片，绘制成半透明
         */
        try {
            ImageIcon imageIcon = new ImageIcon(imagePath);
            BufferedImage bufferedImage = new BufferedImage(imageIcon.getIconWidth(),
                              imageIcon.getIconHeight(), BufferedImage.TYPE_4BYTE_ABGR);
            Graphics2D g2D = (Graphics2D) bufferedImage.getGraphics();
            g2D.drawImage(imageIcon.getImage(), 0, 0, imageIcon.getImageObserver());
            //循环每一个像素点，改变像素点的Alpha值
            int alpha = 100;
            for (int j1 = bufferedImage.getMinY(); j1 < bufferedImage.getHeight(); j1++) {
                for (int j2 = bufferedImage.getMinX(); j2 < bufferedImage.getWidth(); j2++) {
                    int rgb = bufferedImage.getRGB(j2, j1);
                    rgb = ( (alpha + 1) << 24) | (rgb & 0x00ffffff);
                    bufferedImage.setRGB(j2, j1, rgb);
                }
            }
            g2D.drawImage(bufferedImage, 0, 0, imageIcon.getImageObserver());
            //生成图片为PNG
            ImageIO.write(bufferedImage, "png",  new File(outFile));
            System.out.println(String.format("绘制图片半透明成功，图片文件为： %s", outFile));
            return true;
    	}catch(Exception ee) {
        	System.out.println("绘制图片半透明出现异常："+ee.getMessage());
        	return false;
        }
    }
    /**
     * 为图像添加水印
     * @param buffImgFile 底图
     * @param waterImgFile 水印
     * @param outFile 输出图片
     * @param alpha   透明度
     * @throws IOException
     */
    private boolean watermark(String buffImgFile,String waterImgFile,String outFile, float alpha){
        try {
	    	// 获取底图
	        BufferedImage buffImg = ImageIO.read(new File(buffImgFile));
	        // 获取层图
	        BufferedImage waterImg = ImageIO.read(new File(waterImgFile));
	        // 创建Graphics2D对象，用在底图对象上绘图
	        Graphics2D g2d = buffImg.createGraphics();
	        int waterImgWidth = waterImg.getWidth();// 获取水印层图的宽度
	        int waterImgHeight = waterImg.getHeight();// 获取水印层图的高度
	        // 在图形和图像中实现混合和透明效果
	        g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP, alpha));
	        // 绘制
	        g2d.drawImage(waterImg, 0, 0, waterImgWidth, waterImgHeight, null);
	        g2d.dispose();// 释放图形上下文使用的系统资源
	        //生成图片为PNG
	        ImageIO.write(buffImg, "png",  new File(outFile));
	        System.out.println(String.format("图片添加水印成功，图片文件为： %s", outFile));
	        return true;
    	}catch(Exception ee) {
        	System.out.println("图片添加水印出现异常："+ee.getMessage());
        	return false;
        }
    }
    /**
     * 图片合成
     * @param image1
     * @param image2
     * @param posw
     * @param posh
     * @param outFile
     * @return
     */
    public boolean simpleMerge(String image1, String image2, int posw, int posh, String outFile){
        try {
	    	// 获取底图
	        BufferedImage buffImg1 = ImageIO.read(new File(image1));
	        // 获取层图
	        BufferedImage buffImg2 = ImageIO.read(new File(image2));
	        //合并两个图像
	        int w1 = buffImg1.getWidth();
	        int h1 = buffImg1.getHeight();
	        int w2 = buffImg2.getWidth();
	        int h2 = buffImg2.getHeight();
	        BufferedImage imageSaved = new BufferedImage(w1, h1, BufferedImage.TYPE_INT_ARGB); //创建一个新的内存图像
	        Graphics2D g2d = imageSaved.createGraphics();
	        g2d.drawImage(buffImg1, null, 0, 0);  //绘制背景图像
	        for (int i = 0; i < w2; i++) {
	            for (int j = 0; j < h2; j++) {
	                int rgb1 = buffImg1.getRGB(i + posw, j + posh);
	                int rgb2 = buffImg2.getRGB(i, j);
	                /*if (rgb1 != rgb2) {
	                    rgb2 = rgb1 & rgb2;
	                }*/
	                imageSaved.setRGB(i + posw, j + posh, rgb2); //修改像素值
	            }
	        }
	        ImageIO.write(imageSaved, "png", new File(outFile));
	        System.out.println(String.format("图片合成成功，合成图片文件为： %s", outFile));
	        return true;
    	}catch(Exception ee) {
        	System.out.println("图片合成出现异常："+ee.getMessage());
        	return false;
        }
    }
    /*** 
     * 功能 :调整图片大小 开发：wuyechun 2011-7-22 
     * @param srcImgPath 原图片路径 
     * @param distImgPath  转换大小后图片路径 
     * @param width   转换后图片宽度 
     * @param height  转换后图片高度 
     */  
    public void resizeImage(String srcImgPath, String distImgPath,  
            int width, int height) throws IOException {  
  
        File srcFile = new File(srcImgPath);  
        Image srcImg = ImageIO.read(srcFile);  
        BufferedImage buffImg = null;  
        buffImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);  
        buffImg.getGraphics().drawImage(  
                srcImg.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0,  
                0, null);  
  
        ImageIO.write(buffImg, "JPEG", new File(distImgPath));  
  
    } 
    /*public static void main(String[] args) throws Exception {
        //人脸识别
        detectFace("E:\\person.jpg", "E:\\personFaceDetect.png");
        //人眼识别
        detectEye("E:\\person.jpg",  "E:\\personEyeDetect.png");
        //图片裁切
        imageCut("E:\\person.jpg","E:\\personCut.png", 50, 50,100,100);
        //设置图片为半透明
        setAlpha("E:\\person.jpg", "E:\\personAlpha.png");
        //为图片添加水印
        watermark("E:\\person.jpg","E:\\ling.jpg","E:\\personWaterMark.png", 0.2f);
        //图片合成
        simpleMerge("E:\\person.jpg", "E:\\ling.jpg", 45, 50, "E:\\personMerge.png");
    }*/
	
	/*public String getfacesfile(String infile) {

	  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
      System.out.println("\nRunning FaceDetector");
      CascadeClassifier faceDetector = new CascadeClassifier();
      faceDetector.load("haarcascade_frontalface_alt.xml");
      Mat image = Imgcodecs.imread(infile);

      MatOfRect faceDetections = new MatOfRect();
      faceDetector.detectMultiScale(image, faceDetections);
      System.out.println(String.format("Detected %s faces", faceDetections.toArray().length));
      for (Rect rect : faceDetections.toArray())
      {
          Imgproc.rectangle(image, new Point(rect.x, rect.y),
                  new Point(rect.x + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
      }

      String filename = "F:\\ouput.jpg";
      Imgcodecs.imwrite(filename, image);
      return filename;
 }
  public boolean detectEye(String imagePath,  String outFile) throws Exception {
	  
	  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
	  CascadeClassifier eyeDetector = new CascadeClassifier();
	  eyeDetector.load("D:/opencv/sources/data/haarcascades_cuda/haarcascade_eye.xml");

      //Mat image = Imgcodecs.imread(imagePath);  //读取图片
      Mat image = Imgcodecs.imread("E:\\chuangyelei\\ruanjian\\facenet\\compare\\003.jpg");

      // 在图片中检测人脸
      MatOfRect faceDetections = new MatOfRect();

      eyeDetector.detectMultiScale(image, faceDetections, 2.0,1,1,new Size(20,20),new Size(20,20));

      System.out.println(String.format("Detected %s eyes", faceDetections.toArray().length));
      Rect[] rects = faceDetections.toArray();
      if(rects != null && rects.length <2){
          throw new RuntimeException("不是一双眼睛");
      }
      Rect eyea = rects[0];
      Rect eyeb = rects[1];
      System.out.println("a-中心坐标 " + eyea.x + " and " + eyea.y);
      System.out.println("b-中心坐标 " + eyeb.x + " and " + eyeb.y);
      //获取两个人眼的角度
      double dy=(eyeb.y-eyea.y);
      double dx=(eyeb.x-eyea.x);
      double len=Math.sqrt(dx*dx+dy*dy);
      System.out.println("dx is "+dx);
      System.out.println("dy is "+dy);
      System.out.println("len is "+len);
      double angle=Math.atan2(Math.abs(dy),Math.abs(dx))*180.0/Math.PI;
      System.out.println("angle is "+angle);
      for(Rect rect:faceDetections.toArray()) {
          Imgproc.rectangle(image, new Point(rect.x, rect.y), new Point(rect.x
                  + rect.width, rect.y + rect.height), new Scalar(0, 255, 0));
      }
      //Imgcodecs.imwrite(outFile, image);
      String filename = "F:\\ouput.jpg";
      Imgcodecs.imwrite(filename, image);
      System.out.println(String.format("人眼识别成功，人眼图片文件为： %s", outFile));
      return true;
  }*/
}
