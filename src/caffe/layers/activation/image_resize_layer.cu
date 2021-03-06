#include <vector>
#include <vector>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/highgui/highgui_c.h>
#include "caffe/layers/activation/image_resize_layer.hpp"
#include "caffe/util/math_functions.hpp"

namespace caffe {



template <typename Dtype>
void ImageResizeLayer<Dtype>::Forward_gpu(const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) 
{
		int num = bottom[0]->num();
	int channels = bottom[0]->channels();
  int height = bottom[0]->height();
  int width = bottom[0]->width();
  
  cv::Mat cv_interp_im(height/interp_ratio,width/interp_ratio,CV_32FC3);
	cv::Mat cv_im(height,width,CV_32FC3);
	
	Dtype * top_data = top[0]->mutable_cpu_data();
	for (int n=0;n<num;n++)
	{
		const Dtype * bottom_data = bottom[0]->cpu_data() + bottom[0]->offset(n);
		for (int h = 0;h < height; h++)
	  {
    	Dtype * data_ptr = cv_im.ptr<Dtype>(h);
    	for (int w = 0;w < width; w++)
    		for(int c = 0;c < 3; c++)
      		data_ptr[w*3+c] = bottom_data[((c*height)+h)*width+w];
    }		
    

		cv::resize(cv_im,cv_interp_im,cv::Size(width/interp_ratio,height/interp_ratio),0,0,CV_INTER_AREA);
		
	  Dtype * top_data = top[0]->mutable_cpu_data() + top[0]->offset(n);
		for (int h = 0; h < height/interp_ratio; h++)
	  {
    	const Dtype * data_ptr = cv_interp_im.ptr<Dtype>(h);
    	for (int w = 0;w < width/interp_ratio; w++)
    		for(int c = 0;c < 3; c++)
      		top_data[int(((c*height/interp_ratio)+h)*width/interp_ratio+w)] = data_ptr[w*3+c];
    }		
  }
	

}

template <typename Dtype>
void ImageResizeLayer<Dtype>::Backward_gpu(const vector<Blob<Dtype>*>& top, const vector<Blob<Dtype>*>& bottom) 
{
	
}
template <typename Dtype>
void ImageResizeLayer<Dtype>::SecForward_gpu(const vector<Blob<Dtype>*>& bottom, const vector<Blob<Dtype>*>& top) 
{

}

INSTANTIATE_LAYER_GPU_FUNCS(ImageResizeLayer);
}  // namespace caffe
		
