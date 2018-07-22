---
layout: post
mathjax: true
title: 数补一・斐波那契数列
category: mathematics
tags: [mathematics, number-theory, integer-sequence]
---

斐波那契数列(Fibonacci number)

## ***前言***
斐波那契数列恐怕是日常生活与学习中最常遇见的数列之一，它简单且优雅。在刷[Project Euler][pe]的过程中，时不时能够遇到一道有关于斐波那契数列的问题，且往往每次都用到了一个新的，我不知道的有关于斐波那契数列的性质。

这燃起了我的好奇心，而这篇文章，便是这好奇心的结果。

## 1.定义
“If by chance I have omitted anything more or less proper or necessary, I beg forgiveness, since there is no one who is without fault and circumspect in all matters.” - Leonardo Fibonacci

尽管斐波那契数列并不是斐波那契最先描述的，但他是西方最先研究该数列的人。斐波那契于其所著的《计算之书（Liber Abaci）》中使用著名的兔子生长数目来描述这个数列：
- 在第一个月初有一对刚诞生的兔子
- 在第二个月之后（第三个月初）它们可以生育
- 每月每对可生育的兔子会诞生下一对新兔子
- 兔子永不死去
那么在第$n \in \mathbb{N}_{>0}$个月，有多少对兔子呢？

在数学上，令$F_n, n \in \mathbb{N}_{\ge 0}$为第$n$个月时存活的兔子（对），我们可以定义如下的递推式来描述这个问题

$$
\begin{align}
F_0 &= 0, \\
F_1 &= 1, \\
F_n &= F_{n-1} + F_{n-2}, n \ge 2
\end{align}
$$

前几个斐波那契数为$0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, \cdots$.

## 2.从递推式出发
有很多有关于斐波那契数列的简单恒等式可以从递推式出发直接计算得到，譬如

$$
\sum_{k=0}^n F_k = F_{n+2} - 1
$$

这个简单的恒等式可以藉由累加法证明，将下列式子

$$
\begin{align}
F_0 &= F_2 - F_1 \\
F_1 &= F_3 - F_2 \\
&\vdots \\
F_n &= F_{n+2} - F_{n+1}
\end{align}
$$

进行累加即可。

这是一个很好的开始，从这个恒等式出发可以直接得到

$$
\begin{equation}
F_2 + \cdots + F_{2n} = F_{2n+1} - 1
\label{e1}
\end{equation}
$$

$$
\begin{equation}
F_1 + F_3 + \cdots + F_{2n - 1} = F_{2n}
\label{e2}
\end{equation}
$$

进而我们用$\eqref{e2}$减去$\eqref{e1}$，得到

$$
F_1 - F_2 + \cdots + F_{2n-1} - F_{2n} = F_{2n} - F_{2n+1} + 1
$$

$$
F_1 - F_2 + \cdots + F_{2n-1} - F_{2n} + F_{2n+1} = F_{2n} + 1
$$

即有

$$
\begin{equation}
\sum_{k=0}^n (-1)^{k+1} F_k =(-1)^{n+1} F_{n-1} + 1
\label{e3}
\end{equation}
$$

### 2.1.继续前进
通过对递推式的观察，我们可以发现

$$
\begin{equation}
F_n F_{n+1} - F_n F_{n - 1} = F_n (F_{n+1} - F_{n-1}) = F_n^2
\label{e4} 
\end{equation}
$$

累加$\eqref{e4}$，即可得到（注意这里$n$并不能为$0$）

$$
\begin{equation}
F_1^2 + F_2^2 + \cdots + F_n^2 = \sum_{k=1}^n F_n F_{n+1}
\label{e5}
\end{equation}
$$

有趣的是，这个恒等式的某种对称形式，即

$$
\begin{equation}
\sum_{k=1}^{2n+1} F_k F_{k+1} = F_{2n+1}^2
\end{equation}
$$

也是成立的。实际上，从这两个式子已经开始暗示我们斐波那契数列似乎与黄金分割存在某些联系了。我们考虑$\eqref{e5}$，左边可以看成边长为$F_k, k \in \mathbb{N}$正方形的面积和，而右边是一个长和宽分别为$F_n,F_{n+1}$的矩形的面积。即，这个式子实际上给出了一种将这个矩形分割为多个多个某些大小的正方形的方案。而如果你搜索黄金分割，你将会看见一个类似的将矩形分割为多个正方形的方案。

同样，不难发现以下这个等式是成立的（简单的数学归纳法）

$$
\begin{equation}
F_{n+m} = F_{n-1}F_m + F_nF_{m+1}
\label{e6}
\end{equation}
$$

我们令$\eqref{e6}$中$m=n$，则有

$$
\begin{equation}
F_{2n} = F_{n}(F_{n-1} + F_{n+1})
\end{equation}
$$

进而可以得到

$$
\begin{equation}
F_{2n} = F_{n+1}^2 - F_{n-1}^2
\end{equation}
$$

### 2.2.留作思考
最后还有一个被称为“邻项公式”的恒等式，他看起来是这样的

$$
F_{n+1}F_{n-1} - F_n^2 = (-1)^n
$$

## 3.与组合数
在数音[之一]中我们介绍了二项式系数，其有一个与斐波那契数列类似的递归定义，即

  $$
  \begin{align}
  {r \choose k} &= {r-1 \choose k-1} + {r-1 \choose k} \\
  {0 \choose 0} &= 1 \\
  {r \choose k} &= 0,\ when\ k\ <\ 0 \\
  \end{align}
  $$

这让我自然想到，是否斐波那契数列可以藉由二项式系数，亦或者是组合数来进行表示呢？幸运的是，这里有一个这样一个式子$\sum_{k=0}^n \binom{n-k}{k}$可以被加法公式进行如下拆分

$$
\begin{align}
\sum_{k=0}^n \binom{n-k}{k} &= \sum_{k=0}^n \Big{(}\binom{n-k-1}{k} + \binom{n-k-1}{k-1}\Big{)} \\
&= \sum_{k=0}^{n-1} \Big{(}\binom{n-1-k}{k} + \binom{n-2 - (k-1)}{k-1}\Big{)} \\
&= \sum_{k=0}^{n-1} \binom{n-1-k}{k} + \sum_{k=0}^{n-1} \binom{n-2-(k-1)}{k-1} \\
&= \sum_{k=0}^{n-1} \binom{n-1-k}{k} + \sum_{l=0}{n-2} \binom{n-2-j}{j}
\end{align}
$$

因而有

$$
F_{n} = \sum_{k=0}^{n} \binom{n-k}{k}
$$

除此之外，我还发现了两个有趣的，有关于斐波那契数列以及组合数的恒等式

$$
\sum_{k=0}^{n} \binom{n}{k} F_k = F_{2n}
$$

$$
\sum_{k=0}^{n} (-1)^k F_k = -F_n
$$

遗憾的是我尚未发现其背后的组合解释，不过这两个恒等式均可藉由数学归纳法证明得到，在此便不再赘述了。

## 4.它能被整除吗
[Project Euler 2][pe2]让我思考了这样一系列问题，即给定两个正整数$n$和$d$，是否能快速判断$d$能否整除$F_n$呢？

幸运的是，对于一些小整数，我们有如下的结论
- [1]$F_n$能被$2$整除当且仅当$n$能被$3$整除；
- [2]$F_n$能被$3$整除当且仅当$n$能被$4$整除；
- [3]$F_n$能被$4$整除当且仅当$n$能被$6$整除；
- [4]$F_n$能被$5$整除当且仅当$n$能被$5$整除；
- [5]$F_n$能被$7$整除当且仅当$n$能被$8$整除；
- [6]$F_n$能被$11$整除当且仅当$n$能被$10$整除；
- [7]$F_n$能被$13$整除当且仅当$n$能被$7$整除；
- [8]$F_n$能被$9,12$和$16$整除当且仅当$n$能被$12$整除；
- [9]$F_n$能被$10$和$61$整除当且仅当$n$能被$15$整除；
- [10]$F_n$能被$15$整除当且仅当$n$能被$20$整除；
- [11]$F_n$能被$29$整除当且仅当$n$能被$14$整除。

对于这些结论的证明非常的简单，由简单的归纳法即可得到，如

$$
\begin{align}
F_4 &= 3, \\
F_{4k+4} &= F_{4k+3} + F_{4k+2} \\
&= 2F_{4k+2} + F_{4k+1} \\
&= 3F_{4k+1} + 2F_{4k}
\end{align}
$$

那么不同的斐波那契数之间是否存在诸如此类的联系呢？一个简单的观察可以得到的是
- [12]相邻的斐波那契数是互素的

除此之外，我还收集到了这样两个有趣的结论
- [13]令$n$和$m$为两个正整数。如果$n$被$m$整除，则$F_n$也被$F_m$整除

我们可以通过归纳法来证明这个结论。

设$n = mk, k \in \mathbb{N}$。

当$k=1$时，$n=m$，结论成立。


假设$F_{mk}$能被$F_m$整除，则由$\eqref{e6}$我们有

$$F_{m(k+1)} = F_{mk-1}F_m + F_{mk}F_{m+1}$$

显然$F_{mk-1}F_m + F_{mk}F_{m+1}$能被$F_m$整除，得证。


- [14]令$n$和$m$为两个正整数，记$(m, n)$为$m,n$的最大公约数，则有$(F_n,F_m) = F_{(n, m)}$。

这个定理的证明会用到辗转相减法及其相关的结论，不熟悉的读者可以事先搜索学习一下：

由$\eqref{e6}$我们有

$$
\begin{align}
(F_{m+n}, F_n) &= (F_{m-1}F_n+ F_mF_{n+1}, F_n) \\
&= (F_mF_{n+1}, F_n) = (F_m, F_n)
\end{align}
$$

等式的最后一步是由于[12]，即$(F_n, F_{n+1}) = 1$。

不妨设$n \ge m$，则由$(F_{m+n}, F_n)=(F_m, F_n)$我们可以得到

$$(F_n, F_m) = (F_m, F_{n-m}) = \cdots = (F_{(n,m)}, F_0)$$

即

$$(F_n, F_m) = (F_{(n,m)}, F_0) = F_{(n,m)}$$

正如我们在辗转相减法中所做的，不是么？

## 5.后记
考虑到斐波那契数列的通项公式已经某种意义上广为人知，于是在此鄙人并没有给出有关于斐波那契数列通项公式的内容。在第二节我们曾提到斐波那契数列与黄金分割有一些联系，作为计划，这部分内容会在日后介绍卢卡斯数（Lucas number）与黄金分割的时候给出--如果我尚且记得这个坑的话。

[pe]: https://projecteuler.net/
[pe2]: https://projecteuler.net/problem=2