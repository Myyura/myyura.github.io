---
layout: post
mathjax: true
title: 数四・AKS算法・预备知识・数学篇
category: mathematics
tags: [primality-test, number-theory, mathematics]
---

AKS算法（AKS algorithm）・预备知识・数学篇

## ***前言***

主要会是一些数论与有限域（Finite Field）的知识。就像我们在算法篇中提到的那样，内容可能看起来会有些零散，但都是最终证明AKS算法复杂度与正确性之时不可或缺的东西。

## 1.素数定理
计数总是一切研究的开始，既然有了素数这个概念，自然我们就希望知道对于给定的（正，下同）整数$n$，不大于$n$的素数究竟有多少个。我们用$\pi(n)$来表示不大于$n$的素数个数，这个函数也被称为素数计数函数。

我们希望知道$\pi(n)$的增长速率，但这并不是一件容易的事情。不过稍有些数论基础的读者可能会立即指出，由素数定理（Prime Number Theorem）可知，

$$
\lim_{x \to \infty} \frac{\pi (x)}{x / \ln x} = 1
$$

注意到这里的$x$是一个正实数，于是我们的问题便完美的解决了---我们本可以就此结束，不过这样就失去学习的意义了。还是让我们来看看这个结论是如何被证明的吧。

考虑到实际上我们只想要知道$\pi (n)$的渐进分布与素数定理证明的复杂程度，在这里我决定介绍Erdős所写的一个弱一些的素数定理，即

$$
\pi (n) \sim \frac{n}{\log n}
$$

的证明。

### 1.1 上界
首先是$\pi (n)$上界的证明。

一个直接的观察是$\pi (n) \le n$，因为至多只有$n$个（正整）数小于等于$n$。它看起来似乎还差点意思，于是我们退而求其次，考虑一些比$n$小的数字。一个简单的计算可知$\sqrt{n} \le \frac{n}{\log n}$，因而我们有

$$
\pi (\sqrt{n}) \le \sqrt(n) \le \frac{n}{ \log n}
$$

接下来的思路便是寻找$\pi (n)$与$\pi (\sqrt{n})$之间的关系，首先我们将这两项相减，由$\pi (n)$定义可知（注意接下来文中所有出现的字母$p$均指素数$p$）

$$
\pi (n) - \pi (\sqrt{n}) = \sum_{\sqrt(n) < p \le n} 1
$$

我们可以对式子中的$1$进行一些适当的放大，本着由小到大的原则，让我们首先试试对数。于是我们有

$$
(\pi (n) - \pi (\sqrt{n}))\log \sqrt{n} = \sum_{\sqrt(n) < p \le n} \log \sqrt{n} \le \sum_{p \le n} \log p
$$

从而问题转变为了估计$\prod_{p \le n} p$。

为了得到想要的结果，我们希望对于某个正整数$c$，有

$$
\prod_{p \le n} p \le c^n
$$

在选定$c$的值之后，我们便可以使用万能的数学归纳法来进行证明。就算毫无头绪，也可以从$c = 2$开始慢慢尝试，这实际上是非常幸运的情况了。这里我们选定$c = 4$来完成我们的证明。

显然$1 \le n \le 4$的时候命题是成立的，当$n \ge 5$的时候，首先我们考虑$n$为奇数的情况，则有

$$
\prod_{p \le n} p = \Bigg ( \prod_{p \le (n + 1) / 2} p \Bigg ) \times \Bigg ( \prod_{(n + 3) / 2 \le p \le n} p \Bigg )
$$

由归纳假设可知，

$$
\prod_{p \le (n + 1) / 2} p \le 4^{(n + 1) / 2} 
$$

又因$n\ge 5$，我们有$(n+3)/2 \ge 4$，既而可知$p$一定是个奇数。

联系到我们之前介绍过的二项式系数，我们发现有一个组合数是包含了$[(n+3)/2, n]$中所有奇数的乘积的，即

$$
\frac{\frac{n+3}{2} \frac{n+5}{2} \ldots n}{(\frac{n - 1}{2})!} = \binom{n}{(n+1) / 2}
$$

且很显然这个组合数是可以被任意的$(n + 3) / 2 \le p \le n$整除的，因而我们有

$$
\begin{align}
\prod_{(n + 3) / 2 \le p \le n} p &\le \binom{n}{(n+1) / 2} \\
&= \frac{1}{2} \Bigg ( \binom{n}{(n+1)/2} + \binom{n}{(n-1)/2} \Bigg) \\
&\le \frac{1}{2} \times 2^n = 2^{n-1}
\end{align}
$$

即有

$$
\prod_{p \le n} p \le 4^{(n+1)/2} 2^{n-1} = 4^n
$$

当$n$为偶数时，由于$n$必然不是一个素数，我们有

$$
\prod_{p \le n} p = \prod_{p \le n-1} p \le 4^{n-1} \le 4^n
$$

回到$\pi (n)$，我们有

$$
(\pi (n) - \pi (\sqrt{n}))\log \sqrt{n} \le \sum_{p \le n} \log p \le 2n
$$

用上之前提到的$\pi (\sqrt{n}) \le \frac{n}{\log n}$和一些代数运算，可以得到

$$
\pi (n) \le \frac{5n}{\log n}
$$

### 1.2 下界
下界的证明是一个叫做Nair的人于1982年发表在《The American Mathematical Monthly（Vol. 89, No. 2）》上的。他的基本想法是借助[算数基本定理][ftoa]与[最小公倍数][lcm]。

令$p_1, \ldots, p_k$为小于或等于$n$的素数，则由算数基本定理可知，我们可以将任意一个正整数$m \le n$写作

$$
m = \prod_{i=1}^k p_i^{a_{mi}}, \quad 1 \le a_{mi} \le k
$$

此时考虑$1, \ldots, n$的最小公倍数$d_n$，它可以被写作

$$
d_n = \prod_{i=1}^k p_i^{\max (a_{1i}, \ldots, a_{ni})}
$$

并且注意到$p_i^{\max (a_{1i}, \ldots, a_{ni})} \le n$，因而有

$$
d_n \le \prod_{i=1}^k n = n^{\pi (n)}
$$

于是靠着这一串奇特的操作，我们将$\pi (n)$与$d_n$联系了起来。

那么接下来就是给$d_n$寻找一个下界了。Nair在这里巧妙的构造了一个积分$I = \int_0^1 x^n (1-x)^n dx$。当$0 \le x \le 1$时，我们有$0 \le x(1-x) \le \frac{1}{4}$，因此

$$
0 \le I \le (\frac{1}{4})^n
$$

回忆起我们在[数一][myyura1]中学到的东西，我们有

$$
\begin{align}
I &= \int_0^1 x^n \sum_{k=0}^n (-1)^k \binom{n}{k}x^k dx \\
&= \sum_{k=0}^n (-1)^k \binom{n}{k} \int_0^1 x^{n+k} dx \\
& = \sum_{k=0}^n (-1)^k \binom{n}{k} \frac{1}{n+k+1}
\end{align}
$$

因为$n+k+1$最大只能为$2n + 1$，我们有$I \times d_{2n+1} \in \mathbb{N}_+ $。即有

$$
d_{2n+1} \ge \frac{1}{I} \ge 4^n
$$

也就是$d_n \ge 2^{n-1}$。于是得到了想要的下界，虽然看起来似乎有些讨巧。

## 2.群与有限域
阅读接下来的部分需要一些有关于[抽象代数][aa]（Abstract Algebra）的知识---至少得知道群（Group）、环（Ring）等基础概念的定义。虽然这些文章本质上是在抄书造轮子，但事无巨细也稍显无趣。

令$p$是一个素数，$d \ge 1$为一个整数。我们知道[剩余类环][mg]$\mathbb{Z}_p$也同样是一个[域（field）][field]。证明这一点并不是一件难事，按照定义一条条来就可以。不过在之后的部分中，我们主要考虑与多项式有关的东西---毕竟文章的初衷是介绍一些与AKS算法相关的背景知识。令$h(x)$为度数为$d$的于$\mathbb{Z}_p[x]$上的不可约多项式。也就是说，$\mathbb{Z}_p[x]$中不存在度数低于$d$的多项式$a(x),b(x)$使得$h(x) = a(x)b(x)$。

[多项式环（polynomial ring）][pr]的定义与符号（即上文中的$\mathbb{Z}_p[x]$）也是相当常见的东西了，稍有些基础的读者对此应该都不会太陌生，在这里也就不再赘述了。

-------------------------------------------------------------------------------
我们首先考虑商环$F = \mathbb{Z}_p[x] / h(x)$的一些性质。

> $F$是一个大小为$p^d$的域（即$F$中包含有$p^d$个元素）。

$F$的大小是很显然的，因为$\mathbb{Z}_p[x]$中度数低于$d$的多项式数量就是$p^d$---多项式一共有$d$项，而每一项的系数可以选取$0, \ldots, p-1$中的任意一个。接下来我们主要证明对于$F$中任意一个非零多项式$f(x)$，都存在对应的乘法逆元$f^{-1}(x)$。

这实际上很容易，由于$h(x)$不可约性质，我们有$GCD(f(x), h(x)) = 1$，这里$GCD$表示最大公约数---或许最大公约多项式的说法会更好一些。

因而根据辗转相除法，我们能够得到两个在$\mathbb{Z}_p[x]$中多项式$a(x)$和$b(x)$，使得

$$
a(x)f(x) + b(x)h(x) = 1
$$

因而，在$F$中，我们有

$$
a(x)f(x) + b(x)h(x) \equiv a(x)f(x) \equiv 1
$$

也就是说此时$a(x)$可以作为$f(x)$的一个乘法逆元，于是我们选取$f^{-1}(x) = a(x) \mod h(x)$即可。

-------------------------------------------------------------------------------
我们还需要两个有关于多项式环的性质，但在那之前，我们需要几条与乘法群相关的基本性质，
> 令$G$为一个大小为$n$的有限乘法群，其单位元为$1$。令$a\in G$为$G$中的一个元素，则有$a^n = 1$。

这个引理的证明的思路基于[拉格朗日定理（Lagrange's Theorem）][lt]。

令$H = \\{ 1, a, a^2, \ldots, a^{d-1}\\}$，若$H$是$G$的一个子群的话，那么根据拉格朗日定理，我们知道$d = \lvert H \rvert$是整除$n$的。因而存在一个正整数$k$，使得$a^n = (a^d)^k = 1$，便得到了我们想要的结论。

而从定义出发证明$H$是$G$的一个子群是一个相对机械的活，建议大家自己试一试，在这里就略过了。

另外一个广为人知的我们会用到的结论是
> 有限域上的乘法群是循环群。

一些整数域上的结论也同样可以推广至多项式中，譬如

> 令$F$为一个域，$f(x)$为$F[x]$中的一个度数为$d$的多项式，若$d \ge 1$，则有
> - $F$中至多只有$d$个元素$\alpha$使得$f(\alpha) = 0$。
> - $f(x)$可以写为$F[x]$中若干不可约多项式$p_1(x), \ldots, p_k(x)$的乘积，即$f(x) = \prod_{i=1}^k p_i(x)。

前者是[代数基本定理][ftoal]的直接应用，而后者则是算数基本定理的推广。

-------------------------------------------------------------------------------
接着让我们进入正题。
> 令$p$为一个素数，$f(x)$是$\mathbb{Z}_p [x]$上的一个多项式。则等式
> 
> $$
> f(x^p) = f(x)^p
> $$
>
>（于$\mathbb{Z}_p [x]$）上成立。

这里如果$d = 0$，那么这个引理就退化成了我们在[算一][a1]中提到过的费马小定理。所以这个引理实际上可以看做是费马小定理的一个推广。在接下来的证明中，我们始终假设$d \ge 1$。

既然$d = 0$的时候是成立的，我们不妨用数学归纳法来证明这个引理---假设对于度数低于$d$的多项式，该引理是成立的。那么我们不妨设$f(x) = ax^d + g(x)$，其中$a \in \mathbb{Z}_p$，$g(x)$是$\mathbb{Z}_p [x]$上的一个次数低于$d$的多项式，则有

$$
\begin{align}
f(x)^p &= (ax^d + g(x))^p \\
&= \sum_{i = 0}^p \binom{p}{i}a^i x^{id} g(x)^{p-i} \\
&= g(x)^p + a^p x^{pd}
\end{align}
$$

等式的最后一步源于对于任意的$1 \le i \le p - 1$，我们有$\binom{p}{i} \equiv 0 \pmod p$。归纳结束。

-------------------------------------------------------------------------------
于是终于到了最后一个。事实上我们前面提到的许多引理都是为马上要介绍的这一条做准备，这一条也将会是之后证明AKS算法正确性之时最核心的一条引理。
> 令$p$与$r$为不同的两个素数，令$d$为$p \mod r$的[乘法阶（multiplicative order）][mo]。则每一个$\mathbb{Z}_p [x]$上的能够整除$(x^r - 1) / (x - 1)$的不可约多项式的度数均为$d$。

这个引理的证明可能会稍有些长，我们首先假设$h(x)$是$\mathbb{Z}_p [x]$上的能够整除$(x^r - 1) / (x - 1)$的一个不可约多项式，其度数为$k$。我们将通过证明$k \mid d$且$d \mid k$来说明$k = d$。

由上面的结论可知，$\mathbb{Z}_p [x] / h(x)$是一个域且大小为$p^k$。令$g(x)$是$\mathbb{Z}_p [x] / h(x)$上的乘法群的一个生成元（generator）。因而$g(x)$的乘法阶为$p^k - 1$。且$\mathbb{Z}_p [x]$上有$g(x)^p = g(x^p)$，于是于$\mathbb{Z}_p [x]$上我们有

$$
g(x)^{p^d} = g(x^{p^d})
$$

而由于$p$与$r$互素，我们有$p^d \equiv 1 \pmod r$。于是存在一个整数$k$，使得我们可以将$p^d$写作$1 + kr$。

令$f(x)$为$\mathbb{Z}_p [x]$上的一个多项式且有$f(x)h(x) = x^r - 1$，则于$\mathbb{Z}_p [x]$上我们有

$$
x^{p^d} = x \times x^{kr} = x(1 + f(x)h(x))^k = x \mod h(x)
$$

进而有

$$
g(x)^{p^d} = g(x) \mod h(x)
$$

考虑到$g(x)$是一个生成元且$h(x)$不可约，我们知道$g(x) \neq 1 \mod h(x)$。因而$g(x)$在域$\mathbb{Z}_p [x] / h(x)$上有一个逆，即有

$$
g(x)^{p^d - 1} = 1 \mod h(x)
$$

结合到$g(x)$的乘法阶为$p^k - 1$，我们有$p^k - 1 \mid p^d - 1$。这里令$d = qa + b$，我们有

$$
\begin{align}
\frac{p^d - 1}{p^k - 1} &= \frac{p^b (p^{qa} - 1) + (p^b - 1)}{p^k - 1} \\
&= p^b (1 + p^a + \ldots + p^{(q-1)a}) + \frac{p^b - 1}{p^k - 1}
\end{align}
$$

因而$\frac{p^b - 1}{p^k - 1}$是一个整数，这也就决定了$r$必须为$0$。也就是说$k \mid d$。

$d \mid k$部分的证明相比起来要容易一些，在这里我决定偷个懒，如果有人读到这里且有一些抽代背景知识的话，不妨自己考虑考虑。

## 3.后记
到这里我们关于理解AKS算法的预备知识也就介绍完毕了，AKS篇章的内容主要参考了[Michiel Simd][ms]所写的证明。更多的有关于AKS算法的信息，可见[这里][AKS]。

由于我本身不太熟悉这方面相关的知识，内容或许有些纰漏，又或者是有些啰嗦的地方---毕竟总有些脑壳不太够用的时候，但大体上应该不会太影响阅读。

单靠一时兴起去学习一样东西果然还是略显枯燥了一些，这给了我一些警示，需要合理安排学习的方向与时间，但既然坑挖出来了，该填的还是要填的。

说起之后的计划，在结束AKS算法的介绍之后，应该会考虑讲一讲自己研究方向相关的东西---挺冷门的，但我觉得相当有趣。

以上。

[ftoa]: https://en.wikipedia.org/wiki/Fundamental_theorem_of_arithmetic
[lcm]: https://en.wikipedia.org/wiki/Least_common_multiple
[myyura1]: https://myyura.github.io/2018/07/05/myyura-1.html
[aa]: https://en.wikipedia.org/wiki/Abstract_algebra
[mg]: https://en.wikipedia.org/wiki/Multiplicative_group_of_integers_modulo_n
[field]: https://en.wikipedia.org/wiki/Field_(mathematics)
[pr]: https://en.wikipedia.org/wiki/Polynomial_ring
[a1]: https://myyura.github.io/2018/07/05/myyura-1.html
[a2]: https://myyura.github.io/2018/08/03/background_for_AKS-1.html
[ftoal]: https://en.wikipedia.org/wiki/Fundamental_theorem_of_algebra
[lt]: https://en.wikipedia.org/wiki/Lagrange%27s_theorem_(group_theory)
[mo]: https://en.wikipedia.org/wiki/Multiplicative_order
[ms]: http://people.scs.carleton.ca/~michiel/
[AKS]: http://fatphil.org/maths/AKS/