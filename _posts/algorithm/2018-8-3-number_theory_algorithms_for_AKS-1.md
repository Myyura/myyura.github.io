---
layout: post
mathjax: true
title: 算二・AKS算法・预备知识・算法篇
category: algorithm
tags: [algorithm, primality-test, number-theory, mathematics]
---

AKS算法(AKS algorithm)・预备知识・算法篇

## ***前言***
尽管AKS算法本身并不算复杂，但要完全理解其背后的数学思想与时间复杂度的计算却并没有其看上去那么容易---坚实的数论基础是必不可少的。我对数论并不太熟悉，这一度让我思考着是否要放弃这个坑。不过，就此停下未免太过可惜。

于是我们从基本的数论相关的算法说起（学起）---这部分内容大概率会使用在对于AKS算法的复杂度分析之中，它们很重要，我们之后会证明AKS算法是一个多项式时间的算法，因而在此之前，我们得知道什么事情是可以在多项式时间内完成的，但也不局限于此。

这里的多项式时间是针对于输入数字的比特位数来说的，由于素性测试算法的复杂度与输入整数的大小密切相关，因而我们需要一个合适的方式去衡量输入数据的大小---存储这个数字所需要的空间便非常的合适，对于整数$n$来说，我们通常需要$\mathcal{O}(\log n)$个比特位去存储它。随着比特位的增加，很明显，在[算一・素性测试][ma1]中提到的枚举算法的复杂度增长是指数级的。牢记这一点，这有助于你理解之后文章频繁提到的多项式与指数复杂度。

### 1.简单的开始
如若没有特殊声明的话，以下提到的数总是指正整数。


在学校学到的方法告诉我们，两个数（假设这两个数均小于一个整数$n$）之间乘除法和取余运算是可以在$\mathcal{O}(\log^2 n)$时间内完成的，从存储这两个数需要的比特数来看待的话，是多项式时间的---这或许不是最快的，但是无关紧要，重要的是我们知道它们是可以在多项式时间内完成的。

一个稍微复杂些的运算，计算两个数的最大公约数的，广为人知的[辗转相除法（Euclidean algorithm）][ea]，也是可以在多项式时间内完成的---这个分析出现在各类算法书籍中，这里就不再赘述了。

理所当然的，幂运算也是可以在多项式时间内完成的。给定整数$a$和$b$，则$n = a^b$可以在$\mathcal{O}(\log^2 n \log \log n)$时间内被计算出来---只需要一个简单的分治，即$a^b = a^{\frac{b}{2}}a^{\frac{b}{2}}$。它看起来是这个样子的
{% highlight python %}
def power(a, b):
    result = 1
    base = a
    while b > 0:
        if b % 2 == 0:
            result *= base
        base *= base
        b //= 2
    return result
{% endhighlight %}
更进一步的话，给定三个整数$a$，$b$与$p$，幂模运算$a^b \mod p$能够在多项式内完成么？

当然其实[算一・素性测试][ma1]中的快速幂取模算法已经剧透了这个问题的答案。这个算法的核心基于，对于任意三个整数$a$，$b$与$c$，我们有

$$
(a \cdot b) \mod c = ((a \mod c) \cdot (b \mod c)) \mod c
$$

证明并不难，假设

$$
a = ck_1 + r_1
$$

$$
b = ck_2 + r_2
$$

其中$k_1,k_2,r_1$与$r_2$为整数，则有

$$
\begin{align}
(a \cdot b) \mod c &= (r_1r_2 + c(r_2k_1 + r_1k_2 + ck_1k_2)) \mod c \\
&= r_1r_2 \mod c \\
&= ((a \mod c) \cdot (b \mod c)) \mod c
\end{align}
$$

结合上我们在计算$a^b$时所用到的分治策略，快速幂取模算法可以说是呼之欲出了。

### 2.完美幂
给定两个整数$a$与$b$，计算$a^b$是一件非常容易的事情---正如我们在第一节所做的。但如果反过来，给定一个整数$n$，我们是否能在多项式时间内找到两个整数$a$与$b$，使得$n = a^b$呢？这个问题被叫做[完美幂（Perfect power）][pp]问题。

这个问题看起来似乎麻烦一点，但实际上，考虑到$n \neq 1$时，$a$至少为$2$，因而我们有$b \le \log_2 n$。这一下子将问题缩小了很多，也意味着我们可以遍历$b \in [1, \lfloor \log_2 n \rfloor]$。

于是问题变成了如何在多项式时间内去确定$a$---这变得尤为容易，于区间$[1,n]$做一个二分查找即可。考虑到在进行这个二分查找的时候我们需要计算$a^b$，这需要$\mathcal{O}(\log^2 n \log \log n)$，最终计算量为$\mathcal{O}(\log^4 n \log \log n)$。也就是说，完美幂问题可以在多项式时间内被解决。这个算法最终看起来是这样子的
{% highlight python %}
def perfect_power(n):
    b_upper = int(math.log2(n)) + 1
    for b in range(1, b_upper):
        if binary_search(range(1, n), b):
            return True
    return False
{% endhighlight %}
这里的binary_search(range($1$, $n$), $b$)返回真当且仅当存在一个$a \in [1, n]$使得$a^b = n$。当然这个算法和我们实际描述的完美幂问题的输出有些许差距---当使得$a^b = n$的$a$和$b$存在的时候，我们希望能够输出这样的$a$和$b$。不过这并没有实际上的影响，你可以自己去修改并实现它，毕竟我也没实际去完成这个二分查找不是？


另一个解决该问题的方法是使用我们在高中课堂上学过的[牛顿法][nm]，直接求得$n^{\frac{1}{b}}$。它看起来是下面这个样子的
{% highlight python %}
def root(n, b):
    x = n # x_0
    y = x
    while x ** b > n:
        y = int((b - 1) * x + n / (x ** (b - 1)) / b) # x_{i + 1}
        x = y
    return x
{% endhighlight %}
算法的正确性这里就不再赘述了，关于牛顿法的敛散性的证明网上有很多，不过我偶然间发现了一个从算法复杂度的角度出发去分析牛顿法的证明，由[Michiel Simd][ms]所书写，它有些复杂且取巧，但我仍然认为值得介绍一番。

这里我们先假设这个迭代数列为$\<x_i\>$（回忆一下我们在[数二・递推式与生成函数][m2]中使用过的符号，这里我们记$x_0=n$，也就是下标从$0$开始）。注意到这时候算法中的递推式可以写作

$$
x_{i+1} = \lfloor ((b - 1)x_i + ((n / x_i^{b-1})) / b) \rfloor
$$

注意到这个数列实际上是一个单调递减数列，这个证明并不难，大家可以亲自去验证一下。

那么让我们开始介绍Michiel Simd的想法，他首先指出
> 如果$ n^{1/b} \le x_i le 2n^{1/b} $，则有
> 
> $$
> x_{i+1} - n^{1/b} \le \frac{b - 1}{b + 1} (x_i - n^{1/b})
> \label{e0}
> $$

这个定理可以直接从$\<x_i\>$单调递减的性质得到---我们有

$$
\begin{equation}
x_{i+1} - n^{1/b} \le ((b - 1)x_i + ((n / x_i^{b-1})) / b) - n^{1/b}
\label{e1}
\end{equation}
$$

我们希望$\eqref{e1}$要小于$\frac{b - 1}{b + 1} (x_i - n^{1/b})$，于是我们把它们相减，得到

$$
(b - 1)x_i^b - 2bn^{1/b}x_i^{b-1} + (b+1)n \le 0
$$

我们想证明这个等式在$ n^{1/b} \le x_i le 2n^{1/b} $内成立，一个直接的方法便是借助导函数，我们令$f(x) = (b - 1)x^b - 2bn^{1/b}x^{b-1} + (b+1)n$，则有

$$
f'(x) = b(b-1)x^{b-2}(x-2n^{1/b})
$$

不难看出当$ n^{1/b} \le x \le 2n^{1/b} $时我们有$f'(x) < 0$，又有$f(n^{1/b})=0$，命题得证。


这个结论有什么用呢？如果我们假设初始值$x_0 < 2n^{1/b}$，算法中迭代执行的次数是$m$，则有

$$
x_m \le n^{1/b} < x_{m-1} < \cdots < x_0 < 2n^{1/b}
$$

将$\eqref{e0}$的结论运用上，则有

$$
x_{m-2} - n^{1/b} \le (\frac{b-1}{b+1})^{m-2}(x_0 - n^{1/b}) \le (\frac{b-1}{b+1})^{m-2} n^{1/b}
$$

由于$n^{1/b} < x_{m-1} < x_{m-2}$，且$x_{m-1}$和$x_{m-2}$均为整数，因此

$$
1 < x_{m-2} - n^{1/b} \le (\frac{b-1}{b+1})^{m-2} n^{1/b}
$$

取对数

$$
\begin{align}
0 &< (m - 2) \log(\frac{b-1}{b+1}) + \log n^{1/b} \\
m - 2 &< \frac{\log n^{1/b}}{b \log ((b + 1) / (b - 1))}
\end{align}
$$

于是如果$b \log ((b + 1) / (b - 1))$有一个常数的上界，那么我们就有$m \sim \mathcal{O}(\log n)$。

这个式子似乎看起来有些眼熟，如果我们把对数外面的$b$拿进去的，则有

$$
(\frac{b+1}{b-1})^b = (1 + \frac{2}{b - 1})^{b - 1} (1 + \frac{2}{b - 1})
$$

回想起欧拉数$e$的定义，我们知道当$b \rightarrow \infty$，$(1 + \frac{2}{b - 1})^{b - 1} \rightarrow e^2$，问题解决了。但这个优良的复杂度依赖于$x_0<2n^{1/b}$，我们是否总是能在多项式时间内做到这一点呢？这是一个有趣的问题，希望大家能自行思考一下。

### 3.多项式
最后我们来说一说多项式。


和整数一样，多项式同样有着加减乘法以及[长除法][pld]。因而同样的模除运算是可以被定义的。那么如果有整数$n$，$r$以及$a$满足$2 \le r < n$和$1 \le a < n$，计算多项式$(x - a)^n \mod (x^r - 1)$需要多少时间呢？

这个复杂度不可避免的与$r$的大小成指数关系---毕竟这个多项式最坏总是有$r$项的，因而我们将更多的注意力放在$n$身上。

不过其实这个问题相当的无趣，但我们在之后介绍AKS算法的时候会出现此类计算的需求，因而提一下相关的内容还是必要的。它无趣的地方在于，如果我们把$x-a$看做一个整体，则只需要照抄快速幂取模，就有以下算法
{% highlight python %}
def poly_power(n, r, a):
    f(x) = 1, g(x) = x - a, y = n # this is not really the python code, but somehow pseudocode
    while y > 0:
        if y % 2 == 0:
            y = y // 2
            h(x) = g(x)g(x)
            g(x) = h(x) % (x^r - 1) # operation ^ here represents exponentiation
        if y % 2 == 1:
            y = y - 1
            h(x) = f(x)g(x)
            f(x) = h(x) % (x^r - 1)
    return f(x)
{% endhighlight %}
单看$n$的话，这个算法显然是$\mathcal{O}(\log n)$的。

### 4.后记
似乎又学习了一些奇奇怪怪的东西，但，这样就好。此次的三部分内容看起来有些混乱，相互之间并没有特别的关联---不过这也没什么办法，毕竟我们是在学习一个特定的算法而不是看某个领域的教科书。不过，分治策略可以说是贯穿本次的三个章节，就当做是一次对于分治思想的学习也相当不错。

AKS算法介绍部分的下一篇应该会介绍一些基本的数论相关的知识---对我愚笨的脑壳来说又是一个巨大的工程，它可能需要很长时间。

以上。


[ea]: https://en.wikipedia.org/wiki/Euclidean_algorithm
[pp]: https://en.wikipedia.org/wiki/Perfect_power
[ma1]: https://myyura.github.io/2018/07/20/primality-test-1.html
[nm]: https://en.wikipedia.org/wiki/Newton%27s_method
[m2]: https://myyura.github.io/2018/07/14/myyura-2.html
[ms]: http://people.scs.carleton.ca/~michiel/
[pld]: https://en.wikipedia.org/wiki/Polynomial_long_division