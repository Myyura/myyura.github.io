---
layout: post
mathjax: true
title: 算三・拟阵与贪心算法
category: algorithm
tags: [algorithm, greedy-algorithm, matroid, mathematics]
---

拟阵（Matroid）与贪心算法（Greedy Algorithm）

## ***前言***

于是这个月来复习一下贪心算法。贪心算法虽说容易理解与，但却有些微妙---它并不能总是给与我们目标问题的全局最优解。所以究竟什么情况下贪心算法是“完美”的呢？这也便是这次的主题---一种名为拟阵的结构。


## 1.拟阵
Hassler Whitney于1935年首次提出了拟阵这个概念，源于其想要给出一种独立性（Independence）的一般描述。自此之后关于拟阵的理论得到了大幅的发展，其中最重要的一部分之一便是其与贪心算法的联系---贪心策略可以得到全局最优解当且仅当其被应用在拟阵结构上的时候。那么拟阵究竟是什么呢？

### 1.1.定义
令$E$为一个有限集（Finite Set），$\mathcal{F}$为一个由$E$的子集构成的族（Family），一个有限的拟阵$M = (E, \mathcal{F})$是一个满足以下条件的二元组（也被称为拟阵三公理）：

&nbsp;&nbsp;&nbsp;&nbsp;(1) 空集$\phi \in \mathcal{F}$。

&nbsp;&nbsp;&nbsp;&nbsp;(2) 对于每个子集$F_1 \subseteq F_2 \subseteq E$，若有$F_2 \in \mathcal{F}$，则$F_1 \in \mathcal{F}$。（通常我们称之为遗传性（Hereditary））

&nbsp;&nbsp;&nbsp;&nbsp;(3) 若有子集$F_1,F_2 \in \mathcal{F}, \lvert F_1 \rvert < \lvert F_2 \rvert$，则存在一个元素$a \in F_2 \setminus F_1$使得$F_1 \cup \\{a\\} \in \mathcal{F}$。（通常我们称之为交换性（Exchange Property））

------------

值得说明的是，我们也通常把$\mathcal{F}$中的集合称为独立集合（Independent Sets），且极大独立集合通常被称为基（Base）。不过这样的定义着实是让人难以理解，它太过于抽象了。或许我们应该从一两个例子出发。


### 1.2.线性无关（Linear Independent）与生成树（Spanning Tree）
实际上拟阵相关的理论是由线性代数发展而来（这也是拟阵（Matroid）名字与矩阵（Matrix）如此相似的原因），于是首先我们来看一个与线性代数相关联的例子。

假设我们有一个由$m$个$n$元向量$\vec{v}_1, \ldots, \vec{v}_m$构成的矩阵$A$（不妨假定$n < m$且$A$的秩为$n$），那么此时如果我们定义

$$
E \triangleq \{\vec{v}_1, \ldots, \vec{v}_m\}
$$

且有

$$
\mathcal{F} \triangleq \{F \subseteq E \mid F\text{是一组线性无关的向量}\}
$$

则此时元组$M = (E, \mathcal{F})$是一个拟阵（也被称为线性拟阵（Linear Matroid）。我们可以直接检验于1.1节中给出的三公理，来证明$M$是一个拟阵。

**证明：** 由定义可直接得到空集$\phi \in \mathcal{F}$。而很显然线性无关的向量组的子集仍然是线性无关的，遗传性也自此得证。于是重点在于检验交换性。

假定有子集$F_1, F_2 \in \mathcal{F}, \lvert F_1 \rvert < \lvert F_2 \rvert$，则由线性无关的定义可知，以$F_1$作为基（Base）的向量空间（Vector Space）$V_1$的维度为$\lvert F_1 \rvert$，而以$F_2$作为基的向量空间$V_2$的维度为$\lvert F_2 \rvert$。由于$\lvert F_2 \rvert > \lvert F_1 \rvert$，因而一定至少有一个$V_2$中的向量$\vec{v}$不存在与$V_1$中，即无法表示为$F_1$中向量的线性组合，因而$\\{\vec{v}\\} \cup F_1$也是一组线性无关的向量，交换性得证。

-----------

或许线性无关的例子还不够直观，那么接下来我们来介绍一个与图论相关联的例子。让我们从生成树这个概念出发---这当然不是随意选择的，考虑到实际上的主题并不是单纯的介绍拟阵的性质而是讲述其与贪心算法的联系，因而最小生成树（Minimum Spanning Tree）这个例子恐怕是难以绕开了。

不过在考虑最小生成树之前，我们先来看看树这个结构。如果你有仔细阅读那个生涩难懂的三公理的话，你或许能意识到对于给出一个拟阵而言，最重要是给出族$\mathcal{F}$的描述，而对于树结构来说，这个描述某种意义上是现成的---树是没有圈（Cycle）的。

于是给定一个无向图$G = (V(G), E(G))$，对于边集$F \subseteq E(G)$，我们使用$G[F]$来表示导出子图（Induced Subgraph）$(V(F), F)$。 接着我们定义

$$
E \triangleq E(G)
$$

且有

$$
\mathcal{F} \triangleq \{F \subseteq E \mid G[F]\text{是一棵树}\}
$$

则此时元组$M = (E, \mathcal{F})$便是一个拟阵（通常被称为图拟阵（Graph Matroid））。考虑到遗传性的证明是非常自然的，这里我们主要来说明一下交换性的证明。

**证明：** 假定有子集$F_1, F_2 \in \mathcal{F}, \lvert F_1 \rvert < \lvert F_2 \rvert$，由于$G[F_1]$与$G[F_2]$均为树，这意味着它们的顶点数分别为$\lvert F_1 \rvert+1$与$\lvert F_2 \rvert+1$。很显然我们有$\lvert F_2 \rvert+1 > \lvert F_1 \rvert+1$，这意味着一定存在一个顶点$u \in V(F_2) \setminus V(F_1)$，那么我们便可把$F_2$中连接点$u$的边（很显然这条边是不存在于$F_1$之中的）加入到$\lvert F_1 \rvert$之中，从而得到一个新的树。交换性得证。

------------

实际上，空集以及遗传性并不是什么不得了的条件---不如说很多问题都能满足，是相当普适的。真正重要的地方是以其为前提的交换性。拟阵具有相当多有意思的性质，但那些并不是今天的主题---该说贪心算法了。


## 2.与贪心算法
仅仅是有拟阵，我们并没有办法在其之上去描述贪心算法---我们需要解决的是最小生成树，而不是寻找一个生成树的问题，不是么？因此首先，我们需要给我们的拟阵加上一个权值函数（Weight Function）。

### 2.1.带权拟阵（Weighted Matroid）
一个带权拟阵$M_w = (M = (E, \mathcal{F}), w)$是一个拟阵$M$与权值函数$w: E \rightarrow R_+$组成的二元组。对于任意一个$E$的子集$E'$，我们有

$$
w(E') = \sum_{e \in E'} w(e)
$$

如此定义的权值函数偶尔也会被称为“线性”权值函数。


### 2.2.带权拟阵上贪心算法
有了带权拟阵$M_w = (M = (E, \mathcal{F}), w)$之后，我们可以简单的给出一个其之上的贪心算法（$\text{Greedy}(M_w)$）的描述。

&nbsp;&nbsp;&nbsp;&nbsp;(1) 对$E$中的元素按照其权值的大小顺序进行排序。这里假设有
 
$$
w(e_1) \le w(e_2) \le \cdots \le w(e_{\lvert E \rvert})
$$

其中$e_i, i \in [1, \lvert E \rvert]$为$E$中的元素。
 
&nbsp;&nbsp;&nbsp;&nbsp;(2) 集合$F$由空集$\phi$开始，依次向$F$中按照权重由小到大的顺序添加使得$F \cup \\{e_i\\} \in \mathcal{F}$的$e_i, i \in [1, \lvert E \rvert]$。

------------

而基于这个贪心算法，我们有如下结论。

> $\text{Greedy}(M_w)$总会输出$M$上权值最小的基。

换句话说，这个贪心算法总能得到一个全局最优解。这里如果以图拟阵为例的话，这问题便是最小生成树问题---或许你已经发现了一个盲点，以最小生成树问题来说，所有基（即最终得到的生成树）都具有相同的大小，这是一个巧合么？其实并不是，于是让我们先来试着证一证下面这条性质，作为热身。

> $E$的所有基拥有相同的大小。

**证明：** 这里使用反证法，假设存在两个基$F_1, F_2$大小不一。不妨设$\lvert F_2 \rvert > \lvert F_1 \rvert$。
因而由交换性我们可以从$F_2$中取出某个元素置于$F_1$中，从而得到一个更大的$F_1$，这与$F_1$的极大性相矛盾。

------------

实际上，这个性质可以推广为以下形式。

> 对于任意的集合$E' \subseteq E$，包含于$E'$中的所有极大独立集合均拥有相同的大小。

热身完毕，于是让我们接上之前的话题。我们需要证明于带权拟阵上的贪心算法总能够得到最优解。

**证明：** 那么假设$B = \\{b_1, b_2, \ldots, b_r\\}$为贪心算法输出的基，那么很显然有
 
$$
w(b_1) \le w(b_2) \le \cdots \le w(b_r)
$$

我们使用反证法证明我们想要的结论，这里假设$B$不是权值最小的基，且令最优解（即权值最小的基）为$A = \\{a_1, a_2, \ldots, a_r\\}$。因而一定至少存在一个整数$k$使得$w(b_k) > w(a_k)$，我们这里不妨使用这些整数$k$中最小的那个。
考虑集合$B' = \\{b_1, b_2, \ldots, b_{k-1}\\}$与$A' = \\{a_1, a_2, \ldots, a_k\\}$，由于$\lvert A' \rvert > \lvert B' \rvert$，则此时由交换性可知，存在一个元素$a \in A' \setminus B'$使得$B' \cup \\{a\\}$仍然是一个独立集合。

注意到此时有$w(a) \le w(a_k) < w(b_k)$，则由贪心算法的流程可知在取元素$b_k$之前，会先取$a$，矛盾。

------------

对于一个独立集合$F$来说，若定义$f(\lvert F \rvert)$为检验$F \cup \\{e_i\\}$是否为独立集的时间，那么贪心算法的时间复杂度便为$\mathcal{O}(\lvert E \rvert \log \lvert E \rvert + \lvert E \rvert f(\lvert E \rvert))$。

### 2.3.更进一步
在2.2的证明当中我们可以注意到，拟阵的交换性保证了贪心算法能够得到最优解。于是很自然的我们会想到，反过来又会是一番什么样的情况呢？即，能够适用贪心算法而得到最优解的问题，是否一定能够抽象成一种拟阵结构呢？

为了探求这一点，同时考虑到公理一与公理二的显然性，我们于拟阵中删去公理三，定义如下结构。

令$E$为一个有限集，$\mathcal{F}$为一个由$E$的子集构成的族，一个独立系统（Independence System）$S = (E, \mathcal{F})$是一个满足公理一与二的二元组。类似的，我们也能够定义一个加权独立系统$S_w = (S, w)$。

实际上许多耳熟能详的组合优化问题可以使用加权独立系统来进行表达，例如最短路问题（Shortest Path），背包问题（Knapsack Problem）。
以背包问题为例，给定非负数$n, c_i, w_i (1 \le i \le n)$，和$W$，我们希望求得一个集合$\\{1, \ldots, n\\}$的子集$K$，其满足$\sum_{j \in K} w_j \le W$且使得$\sum_{j \in K} c_j$最大。于此，我们可令

$$
E = \\{1, \ldots, n\\}, \mathcal{F} = \\{F \subseteq E \mid \sum_{j \in F} w_j \le W\\}
$$

这也从侧面说明了公理一二的普适性。此外，注意到2.2节的贪心算法是可以直接应用在这样的加权独立系统之上的。这也是我们接下来内容的关键点之一。

于是，我们的问题转变为：

> 给定一个独立系统$S$，若对于任意的权值函数$w$，$\text{Greedy}(S_w)$均可输出权值最小的基，则$S$是一个拟阵吗？

答案是肯定的，不然也就不会有这一节了不是？接下来便让我们试着证明一番。

**证明：** 我们使用反证法来证明我们想要的结论。假设$S$中存在两个独立集合$F_1$与$F_2$使得$\lvert F_2 \rvert > \lvert F_1 \rvert$且不满足公理三，即对于每一个$a \in F_2 \setminus F_1$，$F_1 \cup \\{a\\}$都不是独立集。
 
于是根据$F_1, F_2$，我们构建如下权值函数$w$：

$$
w(a)=\left\{
\begin{array}{ll}
w_1 = \epsilon / \lvert E \rvert & \text{if $a \in F_1 \cap F_2$} \\
w_2 = \epsilon / \lvert F_1  \setminus F_2 \rvert  & \text{if $a \in F_1 \setminus F_2$}\\
w_3 = (1 + \epsilon) / \lvert F_2  \setminus F_1 \rvert  & \text{if $a \in F_2 \setminus F_1$}\\
w_4 = 2 & \text{otherwise}
\end{array}
\right.
$$

其中$0 < \epsilon < 1$。
很自然的我们有$w_1 < w_2$且$w_3 < w_4$。而由$\lvert F_2 \rvert > \lvert F_1 \rvert$可知$w_3 w_2$。即有$w_1 < w_2 < w_3 < w_4$。

这意味着贪心算法会总是先取$F_1 \cap F_2$中的元素，然后是$F_1 \setminus F_2$。而由假设其并不会选取$F_2 \setminus F_1$中的元素，因为他们没法与原有的集合构成新的独立集了。

这样直接给出一个奇怪的权值函数让人有些摸不着头脑，不过思路上来说，我们实际上是希望由贪心算法输出的独立集的权值总是坏于某个将$F_2$包含在内的独立集（它是一定存在的，因为$F_2$本身便是一个独立集）。顺着这个思路，假设贪心算法输出的基的大小为$m$。则我们希望有
 
$$
\begin{align}
\lvert F_1  \cap F_2 \rvert w_1 + \lvert F_1  \setminus F_2 \rvert w_2 + (m - \lvert F_1 \rvert)w_4 > \\
\lvert F_1  \cap F_2 \rvert w_1 + \lvert F_2  \setminus F_1 \rvert w_3 + (m - \lvert F_2 \rvert)w_4
\end{align}
$$

即希望有

$$
(\lvert F_2 \rvert - \lvert F_1 \rvert)w_4 > \lvert F_2  \setminus F_1 \rvert w_3 - \lvert F_1  \setminus F_2 \rvert w_2
$$

结合到$w_i, i = 1,2,3,4$的定义，我们可有以下结论：

$$
\begin{align}
w_4 > 1 &= \frac{\lvert F_2  \setminus F_1 \rvert (1 + \epsilon)}{\lvert F_2  \setminus F_1 \rvert } - \frac{\lvert F_1  \setminus F_2 \rvert \epsilon}{\lvert F_1  \setminus F_2 \rvert } \\
&= \lvert F_2  \setminus F_1 \rvert w_3 - \lvert F_1  \setminus F_2 \rvert w_2
\end{align}
$$

回忆起$\lvert F_2 \rvert > \lvert F_1 \rvert$，即有$\lvert F_2 \rvert - \lvert F_1 \rvert \ge 1$，很自然的便能得到我们的结论。

------------

于是，结合起我们在2.2节的证明，我们可以得到如下结论：

> 给定一个独立系统$S$，以及一个任意的$S$上的非负权值函数$w$，贪心算法能够求得$S$上的一个权值最小（最大）基当且仅当$S$是一个拟阵。

## 3.后记
我们仅仅揭开了拟阵的冰山一角，实际上这优美的结构具有相当多的美妙性质，进而被应用于许多领域---不过我希望暂且结束有关于拟阵的话题，毕竟留下的坑已经太多了。