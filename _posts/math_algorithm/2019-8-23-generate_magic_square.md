---
layout: post
mathjax: true
title: 算四・构造幻方
category: mathematics
tags: [mathematics, combinatorics]
---

构造幻方（Constructing Magic Square）

## ***前言***
权当是纪念六年前第一次做幻方的课后习题了。

最早关于幻方---一组排列在方格中的整数，使得其每行，每列以及对角线上的数的和均相等---的记录可以追溯到公元前2200年的《河图洛书》，传其中记载了如下的三阶幻方。

<div style="text-align: center;"><img  width="196" height="172" alt="" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Lo_Shu_3x3_magic_square.svg/1024px-Lo_Shu_3x3_magic_square.svg.png" /></div>

翻译成今天我们所熟知的样子的话，即如下幻方。

$$
\begin{array} {|c|c|}\hline 4 & 9 & 2 \\ \hline 3 & 5 & 7 \\ \hline 8 & 1 & 6 \\ \hline  \end{array}
$$

可以验证的是每行每列以及对角线上数字的和均为$15$，不难发现，若以整数$1$到$n^2$来填充一个$n$行$n$列的方格的话，这个每行每列以及对角线上的数字的和为定数

$$
M(n) = \frac{n^2 (1 + n^2)}{2n} = \frac{n(1+n^2)}{2}
$$

我们通常把这个定数称为幻数（Magic Constant）。而今天主题，便是在给定整数$n$的情况下，如何去构造一个$n$行$n$列的幻方。

## 1.简单的奇数阶
