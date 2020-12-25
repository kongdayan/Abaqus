# Abaqus

## 简介
[源代码](file/plastic.for),[输入文件](file/Job-1.inp)
这是我的本科毕设代码，使用Fortran语言编写的Abaqus用户子程序。
运行环境是abaqus6.14+ivf
毕设的目的是使用abaqus模拟仿真使用激光热源和焊接热源的焊接和冷却过程，并通过abaqus输出其仿真后的残余应力大小。
使用了UMAT和DFLUX两个子程序入口，分别计算了不同时间步下材料的应力和热源分布

## 使用
在模型中
定义材料的属性    
>UMAT Property->General->User material    

定义载荷部分
>Load->Body heat flux->User-defined


### 启动命令

```
abaqus job=Job-1 user=plastic.for
```

## 变量解释


|变量名|解释|
|---|---|
|M_VF|马氏体体积分数|
|A_VF|奥氏体体积分数|
|M_TMP_YS|计算混合屈服强度的临时变量M|
|A_TMP_YS|计算混合屈服强度的临时变量A|
|M_YS|马氏体屈服强度|
|A_YS|奥氏体屈服强度|
|MIX_YS|混合体屈服强度|
|EQ_STRESS|等效应力|
|MIX_YS|混合屈服应力|
|A_YS|奥氏体屈服强度|
|MA_th_strain_Diff|马氏体相变引起的奥氏体与马氏体的热应变之差|
|K|相变塑性系数|
|F_M|马氏体相变速率|
|Sij|偏应变张量|
|Tp_strain|相变塑性应变|
|M_VF|马氏体体积分数|
|A_VF|奥氏体体积分数||
|P_eq|平衡状态奥氏体体积转变分数|
|T_r|为与形核率有关的量|
|n|Avrami|指数|
|M_s|马氏体相变起始温度，计算时取400度|(C)|
|T|当前温度|
|k_vf|常数|
|KTIME|时间（防混淆）|
## 部分参考资料汇总

1. [一个Abaqus用户子程序的小例子(初学者)](./file/ABAQUS初学者用户子程序小例子.pdf)
2. [如何将工程应力应变转变为真实应力应变](https://info.simuleon.com/blog/converting-engineering-stress-strain-to-true-stress-strain-in-abaqus)
3. [有关UMAT符号的说明](./file/UMAT符号说明.pdf)
4. [Write a UMAT](./file/../Abaqus/file/Writing%20a%20UMAT.pdf)
5. [一起学习UMAT的一些公式注释](../file/../Abaqus/file/一起学习UMAT%20的一些公式注释.doc)
6. [在vs2012中调试 Abaqus 用户子程序 by wdhust for simwe](./file/Debugging%20ABAQUS%20User%20Subroutines%20with%20Visual%20Studio%20Debugger%20(by%20wdhust%20for%20simwe).png)
   
## PS
如果本项目帮到你了，请给我个Star,谢谢。