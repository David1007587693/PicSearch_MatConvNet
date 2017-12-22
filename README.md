演示视频：http://player.youku.com/embed/XMzI1NDQzMjIxNg== 

环境：matlab2014a（64）及以上，vs2015（64）及以上  

准备：按需下载预训练模型存入./res/，其它模型可以自定义模型调用  

>>1.imagenet-vgg-f.mat:http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat  
>>2.imagenet-vgg-verydeep-19.mat:http://www.vlfeat.org/matconvnet/models/imagenet-vgg-verydeep-19.mat
>>3.vgg-face.mat:http://www.vlfeat.org/matconvnet/models/vgg-face.mat  

运行：运行PicSearch.m  

>>1.点击模型选择设置所需预训练模型  
>>2.设置检索结果显示数量  
>>3.加载图库，此过程会使用预训练模型进行特征提取，耗时略长，加载完毕可以查看所加载的图片信息  
>>4.选择检索图片，该过程会对此图片进行特征提取  
>>5.检索，该过程是卷积过程，卷积获得的值越大，图片近似成都越高，检索结果会按近似程度重命名存入./result/文件夹  

注意：  
>>1.Matconvnet需使用vs进行编译，本文件夹所包含Matconvnet已编译完成,若重新下载需自行编译 
>>2.使用预训练模型时，注意对低版本进行升级(使用vl_simplenn_tidy()函数)  

