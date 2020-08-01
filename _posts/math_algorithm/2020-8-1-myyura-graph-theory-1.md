---
layout: post
mathjax: true
title: 数六・图论其一・基本定义及其表示
category: AI
tags: [mathematics, graph-theory]
---

图论（Graph Theory）其一・基本定义及其表示（Definitions and Representations）


## 前言
好的今天我们讲图论---不对，应该说是图论学习笔记。
昨天在一个相当简单的图论题目上折腾了两个多小时，让我对自己不扎实的基础感到非常痛心，痛定思痛，决定复习一下。
当然，说是学习笔记，我想最后应该会变成自选主题的，满是自娱自乐的杂谈。

## 1.基本定义
图的定义是一个很奇怪的东西，十本书中可能会看到九种不同的写法。
考虑到以后的内容应该会主要集中在简单图，因此我们用一种相当简略的定义---我们认为图$G$即为一个有序的二元组$(V, E)$，
其中$V$是一个非空有限集，也称之为点集（Vertex Set），而$E$则为点集中的元素的二元组的多重集合（Multi-Set），通常称之为边集（Edge Set）。

举例来说，我们有图$G = (V, E)$，那么点集$V$和边集$E$应该看起来是下面这样子的

$$
\begin{align}
V = \{v_1, v_2, v_3, v_4, v_5\}\\
E = \{v_1v_2, v_2v_3, v_3v_3, v_3v_4,v_2v_4, v_4v_5, v_2v_5, v_2v_5\}
\end{align}
$$

这个例子实际上是我从Graph Theory with Applications - J.A.Bondy & U.S.R.Murty中抄过来的---以我们定义的形式。我们可以通过如下形式将这张图画在平面上，并给边安排上一些名字---相信绝大多数人最初是以这种方式认识到图的

<figure style="text-align:center;">
  <img src="{{ site.BASE_PATH }}/assets/images/graph_theroy_1_1.pdf" width="360" height="270" alt="1"/>
</figure>

可以看到，图中有一些看起来相对特殊的情况。
例如边$e_3 = v_3v_3$，是一条“自己连接着自己的”的边，我们把这样的边称为自圈（Self-Loop）。
此外，边$e_7$与$e_8$实际上是两条相同的边，我们把这种情况称为多重边（Multi-Edge）。

而我们主要想要关注的，实际上是不包含自圈与多重边的图，我们通常称这样的图为简单图（Simple Graph）。

> Theorem.令$G$是一个拥有$n$个点的简单图，矩阵$A$为$G$的邻接矩阵。若$A$的特征值（于复数域上）互不相同，则$G$的自同构群是阿贝尔群（即可交换的）。

证明：从图同构的定义出发，很容意识到其自同构是一个置换矩阵（Permutation Matrix）$P$使得$PAP' = A$。
且因置换矩阵$P$为正交矩阵，因此有$P' = P^{-1}$，进而有$AP = PA$。

因此，假定$P,Q$为$G$的自同构群中任意两个元素，则我们有$AP = PA$且$QA = AQ$。
且由于$A$具有互不相同的特征值，其应与对角矩阵$D = \text{diag}(d_{11}, d_{22}, \ldots, d_{nn})$相似，其中$d_{ii} \neq d_{jj}$对于任意的$i \neq j$。

于是我们有$A = S^{-1}DS$对于某个可逆矩阵$S$，进而有

$$
\begin{align}
P(S^{-1}DS) &= (S^{-1}DS)P \\
(SPS^{-1})D = D(SPS^{-1})
\end{align}
$$

对于一个矩阵$X$，我们用$(X)_{ij}$来表示矩阵的第$i$行第$j$列的元素，且令$X_P = SPS^{-1}$则有

$$
\begin{align}
(X_P D)_{ij} = (X_P)_{ij} \times d_{ii} \\
(D X_P)_{ij} = (X_P)_{ij} \times d_{jj}
\end{align}
$$

考虑到当$i \neq j$时，$d_{ii} \neq d_{jj}$，因而此时有$(X_P)_{ij} = 0$，即$X_P$是一个对角矩阵。
同理，$X_Q$也是一个对角矩阵，因此有$X_P X_Q = X_Q X_P$，也就有$PQ = QP$，命题得证。 