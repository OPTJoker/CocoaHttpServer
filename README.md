# CocoaHttpServer
利用开源库CocoaHttpServer搭建iOS手机本地服务器

直接从pod下载CocoaHttpServer，然后import <CocoaHttpServer.h>即可导入。

检测步骤：
	1.运行该demo，从console控制台找到CocoaHttpServer生成的随机端口号(5位数)。
	2.打开safari浏览器，在地址栏输入："http://localhost:你的端口号"即可。例：[http://localhost:55454]
	3.如果成功，会看到浏览器内显示"恭喜你 服务器运行成功字样"。

API介绍：
```objc
	_localHttpServer = [[HTTPServer alloc] init]	//初始化一个本地服务器
	
	[_localHttpServer setType:@"_http._tcp."];`	//设置服务器类型
	
	[_localHttpServer setDocumentRoot:webLocalPath];	//指定本地服务器web root文件夹根目录（可以随意指定位置，也可在代码运行过程中改变目录）
	
	[_localHttpServer start:&error]		//启动服务器
	
	[_localHttpServer stop]		//停止服务器

	注：服务器一直启动会浪费资源，可根据需要随时开启或关闭服务器。`
```
	
具体请看demo代码。<br>
推广博客链接:[http://blog.csdn.net/u012241552/article/details/49024749/](http://blog.csdn.net/u012241552/article/details/49024749/)
