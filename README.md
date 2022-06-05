# iOSToAndroid
代码简单转换
<img width="450" alt="image" src="https://user-images.githubusercontent.com/20348189/172049615-d472a75c-70cf-473c-883f-18a5151669ad.png">


因为公司只有一个App开发,所以我又要写iOS又要写安卓,因为iOS熟悉一些,所以先把iOS写完,再照着业务逻辑写一遍安卓,每次这样好麻烦,想到做一个工具,来帮我尽可能转换一些业务代码

直接上效果

效果1:转换属性复制

转换之前
<img width="499" alt="WeChat46c1e150206fe61bc80ff41e2f05fbd6" src="https://user-images.githubusercontent.com/20348189/172048852-7e028d3f-1715-4b67-82d4-50ad09ab5a2e.png">

转换之后
<img width="487" alt="image" src="https://user-images.githubusercontent.com/20348189/172048915-0c2ac49a-93de-4ea3-9849-62e4e23d3292.png">


效果2:转换控件引用

转换之前
<img width="470" alt="image" src="https://user-images.githubusercontent.com/20348189/172048948-7b9fa8a2-26ce-43b8-872f-66767e9724f1.png">

转换之后
<img width="491" alt="image" src="https://user-images.githubusercontent.com/20348189/172048964-e464b347-03cc-4681-b4a7-74a31e626a71.png">

效果3:转换方法声明

转换之前
<img width="314" alt="image" src="https://user-images.githubusercontent.com/20348189/172049017-c2fcafaf-5a91-4dfe-abce-9fb05dd6b593.png">

转换之后
<img width="291" alt="image" src="https://user-images.githubusercontent.com/20348189/172049022-a6bd5524-c1bd-49fe-9ddf-6d33b6f38402.png">

除此之外,还有其它,比如函数调用等等一些语法,关键词等等转换,虽然没能达到转换完直接能编译运行起来的效果,但优点如下
1.原理简单,可以说就是字符串查找和替换,代码量非常少
2.支持字符串替换规则自定义,也就是说,你有特殊的替换需求可以自定义

我常用的替换规则
<img width="1387" alt="image" src="https://user-images.githubusercontent.com/20348189/172049130-8a228cc3-e75f-4916-b8a9-9d4e949264c7.png">

<img width="1387" alt="image" src="https://user-images.githubusercontent.com/20348189/172049141-b1715c7b-3ed2-4bf1-afc4-d91bb69e21f9.png">

总结,这是一个简单的项目,但如果您刚好像我这样需要转换业务代码,那这个工具可以帮您节省非常的时间,我公司的项目iOS写了一个月,安卓只花了7天


彩蛋1:有朋友就会问了,既然业务代码能转,那界面布局呢?重新写一遍布局,很多属性,边距等等,很麻烦,不想重写一遍,怎么办?
回答:可以的,已经写好了,过两天上传上来,iOS xib,stroyboard 转安卓 xml,直接能用的那种

彩蛋2:蓝湖,Sketch,竟然可以生成HTML,H5,小程序的界面代码,但生成iOS,安卓xml代码支持性不友好,有没有快速快速搭界面的办法?
回答:有的,已经在写了,iPad模拟器上运行,您只需要动动鼠标,原样给您导出iOS,安卓布局,什么颜色,字体大小,等等,全部不用再管了,敬请期待
