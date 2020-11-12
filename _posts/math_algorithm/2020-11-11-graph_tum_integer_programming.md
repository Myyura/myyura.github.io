---
layout: post
mathjax: true
title: 数七・图与整数规划之全单模矩阵
category: mathematics
tags: [mathematics, graph-theory, integer-programming]
---

图（Graph）与整数规划（Integer Programming）之全单模矩阵（Totally Unimodular Matrix）


## 前言
想起来半年之前曾经写过一篇整数规划与图描画的文章，在其中我们提出了一种将图描画中的交叉点计算温度抽象为整数规划的方式，但倘若大家有所尝试的话就会发现，尽管模型看起来非常的漂亮，解起来却非常的缓慢---即便输入是$K_5$，得到结果也需要花费数十分钟。
刚好工作最近有了一个组合优化的活，借此机会来复习一下整数规划中一个非常重要的概念---全单模矩阵。


## 1.线性规划与多面体
线性规划可以说是运筹优化中最基本也是最重要的概念之一，其一般具有如下形式

$$
\text{maximize } c^Tx
$$

$$
\text{subject to } Ax \le b
$$

其中$x = (x_1, x_2, \ldots, x_n) \in \mathcal{R}^n$，而其中的每个$x_j$被称之为决策变量（Decision Variable）。
矩阵$A \in \mathcal{R}^{m \times n}$与向量$b = (b_1, b_2, \ldots, b_m) \in \mathcal{R}^m$决定了$m$条不等式约束（Inequality Constraints），其中$A$的第$i$行$A_i$与$b_i$组成了约束$(A_i)^Tx \le b_i$。
而向量$c \in \mathcal{R}^n$可以看做是决策向量中每一部分的权重。
我们把满足约束条件的$x$称之为解，而所有的解所构成的集合我们称之为解空间（Solution Space）。
我们的最终目的是希望得到一个使得目标函数（Objective Function）$c^Tx$最大的解，也成为最优解（Optimal Solution）。

此外，对于最大化问题，倘若目标函数可以取到无穷大，亦或者是解空间为空集，我们说该线性规划问题的解是不存在的。

如下便是线性规划的一个实例

$$
\text{maximize } 7x_1 + 2x_2
$$

$$
\begin{align}
\text{subject to } &-x_1 + 2x_2 \le 4 \\
&x_1 + x_2 \le 20 \\
\end{align}
$$

显然

$$x_1 = 0, x_2 = 0$$

是上述实例的一个解，而

$$
x_1 = 12, x_2 = 8
$$

则是上述实例的一个最优解。

但仅仅是几条向量，几个不等式，对于我们来说还是太抽象了---我们来考虑一些简单的情况。
当$x$的维度为$3$时，每条约束实际上是三维空间中的一个平面，于是我们可以发现，这时候线性规划的解空间实际上便是这些平面所围成的一个多面体（Polyhedron）的内部及表面。
很明显，这个多面体是一个凸多面体（Convex polyhedron）---多面体中的任意两点$x,y$的凸组合（Convex Combination）$z = \alpha x + (1-\alpha)y$任然位于多面体之中，因为

$$
Az = \alpha Ax + (1-\alpha)Ay \le \alpha b + (1 - \alpha)b = b
$$

如此来看解空间几乎是无穷多的，那么最优解会存在于何处呢？
大家如果对高中所学习的线性规划部分尚有印象的话，应该会记得最优解似乎总是在多面体的顶点处。
事实上这并不是巧合，不过在此之前，我们应该给出一个凸多面体的顶点的数学定义，我们同样以三维空间为例，
考虑到顶点存在于面的相交处，其应该是三个平面的交点，且这三个平面之间应是线性无关的---平行的两个平面是无法产生交点的。

于是我们定义，对于两条约束$A_ix \le b_i$与$A_jx \le b_j$，假定有$A_i = (a_{i1}, a_{i2}, \ldots, a_{in}), A_j = (a_{j1}, a_{j2}, \ldots, a_{jn})$，我们称两条约束线性无关如果向量$(a_{i1}, a_{i2}, \ldots,a_{in})$与$(a_{j1}, a_{j2}, \ldots, a_{jn})$线性无关。

此外，当某点$x$位于约束平面$A_i$之上时，我们有$A_i x = b$，即此时约束是严格相等的（Tight）。

进而，对于多面体$P = \\{x \in \mathcal{R}^n \mid Ax \le b\\}$，我们称$\bar{x} \in P$是多面体$P$的顶点（平面）如果存在$n$条线性无关的约束使得其在$\bar{x}$上是严格相等的。

关于顶点，我们首先证明一个其关于凸组合的性质

> 令多面体$P=\\{x \in \mathcal{R}^n \mid Ax \le b\\}, A = (A_1, \ldots, A_m) \in \mathcal{R}^{m \times n}, b = (b_1, \ldots, b_m) \in \mathcal{R}^m$，则$\bar{x} \in P$是多面体的一个顶点当且仅当$\bar{x} = \alpha y + (1-\alpha)z, \alpha \in [0, 1], y, z \in P$可推出$\bar{x} = y$或者$\bar{x} = z$。

由顶点的定义，我们知道有$n$条线性无关的约束在其之上是严格等的，因此我们令$A^\star \in \mathcal{R}^{n \times n}, b \in \mathcal{R}^n$对应这$n$条线性无关的约束，则有$A^\star \bar{x} = b^\star$。

不妨设$\bar{x} = \alpha y + (1-\alpha)z$，其中$\alpha \in [0,1], y,z \in P$且$y \neq \bar{x}, z \neq \bar{x}$。
因而有$A^\star y \le b^\star$，$A^\star z \le b^\star$，进而

$$
A^\star \bar{x} = b^\star = \alpha A^\star y + (1-\alpha) A^\star z
$$

很显然$\alpha \in (0, 1)$，否则$\bar{x}$要么为$y$要么为$z$。
此时由等式可以推出$A^\star \bar{x} = A^\star y = A^\star z = b^\star$，而由于$A^\star$可逆，意味着此时$\bar{x} = y = z$。

假设$\bar{x}$不是一个顶点，那么根据定义，不存在$n$条线性无关的约束使得其于$\bar{x}$上是严格等的。
令$I = \\{i \mid A_i^T \bar{x} = b_i\\}$，$I$中线性无关的向量至多有$n - 1$个，不妨设其为$(A_1, A_2, \ldots, A_{n - 1})$，则应存在一个非零向量$d$使得$(A_1^T, A_2^T, \ldots, A_{n - 1}^T) d = 0$。

令$y = \bar{x} + \epsilon d, z = \bar{x} - \epsilon d$，其中$\epsilon > 0$为一个标量。
- 对于$i \in I$，由$A_i^T d = 0$可得$A_i^T y = A_i^T z = b_i$
- 对于$i \notin I$，$A_i^T y = A_i^T \bar{x} + \epsilon A_i^T d < b_i +  \epsilon A_i^T d$，由于$\epsilon$的任意性，我们总能取得充分小的$\epsilon$，使得$A_i^T y \le b_i$。同理有$A_i^T z \le b_i$。因此$y, z \in P$。
即$\bar{x} = \frac{y}{2} + \frac{z}{2}$。

--------------------------

换句话说，多面体的顶点不能够被其自身以外的两点的凸组合表示。
根据顶点的定义，当$m < n$时，多面体是不存在顶点的，且顶点是有限的，其数量为

$$
\binom{m}{n} = \frac{m!}{n!(m - n)!}
$$


接下来我们就要进入到最关键的部分了---线性规划的最优解，倘若存在的情况下，是否总是存在于其多面体的顶点处呢？
这个答案是肯定的，我们将其表述为如下定理

> 对于线性规划$\text{maximize } \\{c^Tx \mid Ax \le b\\}$，令$P = \\{Ax \le b\\}$为其所对应的多面体，假设$P$至少拥有一个顶点，则若线性规划存在最优解，该解一定是$P$的某个顶点。

假设该问题的最优值（Optimal Value，即最优解所取得的目标函数值）为$k$，令$Q = \\{x \mid Ax \le b, c^Tx = k\\}$为最优解的集合。
很明显$Q \subseteq P$。
由于$P$是有顶点的，不难证明$Q$也至少应该含有一个顶点（这实际上非常符合直觉---在一个封闭/半封闭的空间里框出的一个子空间，同样也应该是封闭/半封闭的）。
令$x^\star$为$Q$的一个顶点，假设其不为$P$的顶点，则存在$y \neq x^\star, z \neq x^\star, \alpha \in [0, 1]$使得

$$
x^\star = \alpha y + (1 - \alpha)z
$$

左右同乘$c^T$，我们有

$$
c^T x^\star = k = \alpha c^T y + (1-\alpha)c^T z
$$

由于$k$已经是最优值，而该线性规划是一个最大化问题，因此我们有

$$
c^T y \le k, c^T z \le k
$$

结合起来可以得到

$$
c^T y = c^T z = k
$$

即$y, z \in Q$，这说明$x^\star$并非$Q$的顶点，矛盾。

--------------------------

这意味着，尽管线性规划的解空间近乎无限，但由于最优解会出现在其所对应的多面体的顶点之处，我们并不需要遍历无限的解空间，而只需要搜索有限的顶点即可---这极大的简化了计算复杂度，而基于这个想法所设计的算法便是单纯形法（Simplex Method）。


# 2.整数规划与全单模矩阵
对于一个典型的整数规划问题

$$
\text{maximaize } c^T x
$$

$$
\text{subject to } Ax \le b, x \in \mathbb{Z}_+^n
$$

我们可以写出其所对应的线性松弛问题

$$
\text{maximaize } c^T x
$$

$$
\text{subject to } Ax \le b
$$

也即去掉决策变量必须为整数的约束。
此时，整数规划问题的解空间很明显是其线性松弛问题的一个子集。

我们知道，整数规划问题是非常难以求解的---其为NP困难问题。
但若其所对应的线性松弛问题的最优解是整数解，那么问题就变的简单起来了。
于是接下来的问题便是，什么样的线性规划问题的最优解，或者说其所对应的多面体的顶点都是整数点呢？

首先我们来看看顶点应该具备什么样的形式。
设多面体$P=\\{x \in \mathcal{R}^n \mid Ax \le b\\}$至少含有一个顶点$\bar{x}$，其所对应的$n$个线性无关的严格等约束为$A^\star \bar{x} = b^\star$。

由$A^\star$的可逆性，我们有$\bar{x} = (A^\star)^{-1} b^\star$。因此，首先我们需要向量$b^\star$为整数，进而根据克莱姆法则（Cramer's Rule），设$\bar{x} = (\bar{x}_1, \ldots, \bar{x}_n)$我们有

$$
\bar{x}_j = \frac{\text{det}(A^\star)_j}{\text{det}(A^\star)}
$$

其中$(A^\star)_j$是将$A^\star$的第$j$列替换为$b$的矩阵。
因此，为了保证$\bar{x}_j$为整数，我们可以提出如下充分条件

> 设线性规划问题所对应的多面体$P=\\{x \in \mathcal{R}^n \mid Ax \le b\\}$至少含有一个顶点$\bar{x}$，其所对应的$n$个线性无关的严格等约束为$A^\star \bar{x} = b^\star$，向量$b$为整数向量，若$\text{det}(A^\star)=\pm 1$，则线性规划问题的最优解是整数解。

进而

> 设线性规划问题所对应的多面体$P=\\{x \in \mathcal{R}^n \mid Ax \le b\\}$至少含有一个顶点$\bar{x}$，向量$b$为整数向量，若$A$的任意子阵的行列式均为$0, 1$或者$-1$，则线性规划的最优解为整数解。

而这个任意子阵的行列式均为$0, 1$或者$-1$的矩阵，我们称其为全单模矩阵（Totally Unimodular Matrix）。

不难证明，以下操作并不改变全单模矩阵$A$的全单模性，
- 转置
- 矩阵$(A, E)$是全单模的（其中$E$为单位矩阵）
- 去掉$A$的一行或一列
- 改变$A$的一行或一列的符号
- 互换$A$的两行（或两列）

这些性质也侧面说明了上述定理的正确性。
此外由全单模矩阵的定义可知，其矩阵中元素只能为$0, 1$或者$-1$。

接着让我们来看看一个矩阵为全单模矩阵的充要条件

> 令$A$为一个$m \times n$大小的矩阵，令$a_{ij}, i \in [1, m], j \in [1, n]$表示其第$i$行第$j$列的元素，且任意的$a_{ij}$均满足$a_{ij} \in \{-1, 0, 1\}$。则$A$为全单模矩阵，当且仅当对于任意的$R \subseteq \{1, 2, \ldots, n\}$存在$R$的分割$R_1, R_2$使得对于任意的$i \in \\{1, 2, \ldots, m\\}$，我们有$\sum_{j \in R_1} a_{ij} - \sum_{j \in R_2} a_{ij} \in \\{-1, 0, 1\\}$。

我们首先假设对于任意的$R \subseteq \\{1, 2, \ldots, n\\}$，命题中所描述的分割$R_1, R_2$存在，考虑到我们需要证明任意大小的$A$的子阵的行列式均为$0, 1$或者$-1$，令$B$为$A$的一个大小为$k \times k$的子阵，我们对$k$使用数学归纳法。

当$k = 1$时，命题是显然成立的。
于是我们假设$A$的所有$(k-1) \times (k-1)$大小的矩阵的行列式均为$0, 1$或者$-1$。

这里我们不妨设$\text{det}(B) \neq 0$，由归纳假设以及克莱姆法则可知

$$
B^{-1} = \frac{B^\star}{\text{det}(B)}
$$

其中$B^\star$的每个元素$b_{ij}^\star$为$A$的$(k-1) \times (k-1)$大小的子阵的行列式，根据归纳假设其值为$0, 1$或者$-1$。

令$b_1^\star$为$B^\star$的第一列，$e_1 = (1, 0, \ldots, 0)$为$k$维向量，则有$b_1^\star = B^\star e_1^T$。

进而有

$$
B b_1^\star = B B^\star e_1^T = B \text{det}(B) B^{-1} e_1^T = \text{det}(B) e_1^T
$$

因此$b_1^{\star}$为非零向量，
于是有

$$R=\{i \mid b_{i1}^\star \neq 0\}$$

非空，于是我们令

$$R'_1 = \{i \in R \mid b_{i1}^\star =1\}$$

$$R'_2=\{i \in R \mid b_{i1}^\star =-1\}$$

对于$i = 2, 3, \ldots, k$，我们有

$$
(B b_1^\star)_i = \sum b_{ij}b_{j1}^\star = \sum_{j \in R'_1} b_{ij} - \sum_{j \in R'_2} b_{ij} = 0
$$

因此$\lvert \\{i \in R \mid b_{ij} \neq 0\\} \rvert$为偶数。
因而，当$i = 2, 3, \ldots, k$时，对于$R$的任意分割，都有$\sum_{j} b_{ij} - \sum_{j} b_{ij}$的值为偶数。

而由归纳假设，存在$R$的一个分割$R_1$与$R_2$，使得对于任意的$i$，我们有

$$
\sum_{j \in R_1} a_{ij} - \sum_{j \in R_2} a_{ij} \in \{-1, 0, 1\}
$$

因此当$i = 2, 3, \ldots, k$时，我们有

$$
\sum_{j \in R_1} a_{ij} - \sum_{j \in R_2} a_{ij} = 0
$$

令$\alpha = \lvert \sum_{j \in R_1} a_{1j} - \sum_{j \in R_2} a_{1j} \rvert$，
我们定义

$$
y=(y_1, \ldots, y_k)=\left\{
\begin{aligned}
1,   \quad&i \in R_1 \\
-1,   \quad&i \in R_2 \\
0,   \quad&i \notin R
\end{aligned}
\right.
$$

倘若$\alpha = 0$，则会有$By = 0$。考虑到$\text{det}(B) \neq 0$，我们可知$y = 0$，这意味着$R = \emptyset$，因此$\alpha \neq 0$，由题设条件可知$\alpha = 1$。

因而有$By^T = \pm e_1^T$。注意到$B b_1^\star = \text{det}(B) e_1^T$，于是有

$$
y^T = \pm B^{-1} e_1^T = \pm \frac{1}{\text{det}(B)} b_1^\star
$$

因为$y$与$b_1^\star$均为$0, 1$或者$-1$所构成的向量，我们可以得到$\text{det}(B) = \pm 1$，命题得证。

--------------------------

# 3.图论中的组合优化

这个定理能够给予我们什么启发呢？倘若是有过图论中优化问题尤其是网络流问题的经验的话，可能会觉得该定理的表述看起来眼熟，让我们来看看最经典的网络流问题---最大流问题。

给定图$G = (V, E)$以及源$s$汇$t$，$s,t$-最大流问题可以如下表述

$$
\text{maximize } \sum_{v \in \delta^+(s)}
$$

$$
\begin{align}
\text{subject to } &\sum_{v \in \delta^-(u)} x_{vu} - \sum_{v \in \delta^+(u)} x_{uv} = 0 &\forall u \in V \setminus \{s, t\} \\
&0 \le x_{uv} \le c_{uv} &\forall u, v \in V
\end{align}
$$

假设容量$c_{uv}$均为非负整数，让我们来看看最大流问题的线性规划模型是否和全单模矩阵有所联系。
上述模型可以简单的表述为$\max\\{\sum_{v \in \delta^+(s)} \mid Ax = 0, x \le c\\}$，而此时的$A$，实际上是图$G$的关联矩阵---对于指向$u$的边$e$，我们有$A_{u,e} = 1$，对于$u$指出的边$e$，我们有$A_{u, e} = -1$。

因此$A$是一个仅包含$0,1$和$-1$的矩阵，且每列至多只包含两个非零元素（一条边仅能连接两个顶点），其中一个为$1$，一个为$-1$。

对于$k \times k$大小的$A$的子阵$B$，假设$(k - 1) \times (k - 1)$大小的$A$的子阵均为单模矩阵，
- 若$B$中所有列都恰好含有$1$和$-1$，则将所有行加到第一行可得$\text{det}(B) = 0$
- 若$B$中有全为零的列，则同样有$\text{det}(B) = 0$
- 若$B$中某列只含有$1$或$-1$其中的一个，那么其行列式为该非零元乘以其代数余子式，因此我们可以由归纳法知道其代数余子式的值均为$0, 1$或$-1$中的一个，进而有$\text{det}(B) \in \\{-1, 0, 1\\}$

因此，若容量均为整数，则最大流也将会是整数。

除开最大流之外，相信许多人在学习整数规划的过程中有过求解旅行商问题（TSP）的经历。
我们通常会通过行生成（Column Generation）的方式去求解---令$x_{uv} \in \\{0, 1\\}$表示边$uv$是否被选中，则通常我们用

$$
\sum_v x_uv = 1, \qquad \forall u
$$

$$
\sum_u x_uv = 1, \qquad \forall v
$$

来限定任意一点的度数为$2$。
在不添加圈判定的约束的情况下，不难证明，此时的约束所对应的矩阵恰好是一个全单模矩阵---尽管我们的决策变量是$0,1$-变量，但只需求解其线性松弛问题即可。
而这，实际上是该问题能够适用行生成的一个重要原因。


# 4.后记
在写这篇文章的时候才感觉，大学所学几乎已经全都吐回去了，惭愧啊，惭愧---最近的文章似乎都在说这个问题，想必还是写的太少，学习太慢。