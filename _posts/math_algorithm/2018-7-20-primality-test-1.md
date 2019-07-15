---
layout: post
mathjax: true
title: 算一・素性测试
category: algorithm
tags: [algorithm, primality-test, number-theory, mathematics]
---

素性测试（Primality test）

## ***前言***
这是一个一时兴起而造的轮子了，也是因为在刷[Project Euler][pe]发现了许许多多需要判断一个数是否为素数的问题，于是去学习了一下几个常用的素性测试的算法。

另一方面距离上一次学习如何写一个判断素数的程序已经是五六年前的事情了，而这五六年以来一直都在用着某种意义上的暴力枚举。或许是时候稍微武装一下自己愚笨的脑壳了，嗯，是时候了。

## 1.从学校出发
素数(Prime number)是指在大于$1$的自然数中，除了$1$和该数自身之外，无法被其他自然数整除的数。例如$5$是素数，但$10$却不是，因为$10$能够被$5$整除。

从定义本身出发，我们可以直接得到一个判断素数的算法。即给定一个数（自然数）$n$，判断是否有$2$到$\sqrt{n}$的数可以整除它，即
{% highlight python %}
def brute_force(n):
    if all(n % p for p in range(2, int(n ** 0.5) + 1)):
        return True
    return False
{% endhighlight %}
由于近来正在学习如何玩蛇，因而我选择使用蟒蛇来描述（实现）算法---它其实还算不错，相对于贴近自然语言并且正被大量使用着。另一方面Mathjax似乎并不支持几个常用的算法包，因而目前我决定以伪代码与蟒蛇混写来描述算法---它可能有时候看起来有点遭，但。

很快就能注意到$2$和$3$的倍数是相当好剔除的---令$k$为一个自然数，则显然$6k$，$6k + 2$和$6k + 4$能够被$2$整除，且有$6k + 3$能够被$3$整除，因而一个改进的枚举算法已经呼之欲出了，即
{% highlight python %}
def brute_force_6k(n):
    if n <= 3:
        return True
    elif n % 2 == 0 or n % 3 == 0:
        return False
    else:
        for p in range(5, int(n ** 0.5) + 1, 6):
            if n % p == 0 or n % (p + 2) == 0:
                return False
    return True
{% endhighlight %}
我们通常把这个做法叫做$6k$优化。很显然这两个布鲁特福斯算法的复杂度均为$\mathcal{O}(\sqrt{n})$。

除此之外，相信大家还在课堂上学习过埃拉托斯特尼筛法（sieve of Eratosthenes）用以求得一个区间内的所有素数。它的基本思想非常简单---每个素数的各个倍数一定是一个合数，即有
{% highlight python %}
def eratosthenes_sieve(n):
    is_prime = [True for _ in range(n + 1)]
    for p in range(2, int(n ** 0.5) + 1):
        if is_prime[p]:
            for i in range(p * 2, n + 1, p):
                is_prime[i] = False
    return [p for p in range(2, n + 1) if is_prime[p] == True]
{% endhighlight %}
让我们来一起分析一下埃拉托斯特尼筛法的复杂度，可以观察到，对于每一个素数，内循环会执行$n/p$次，因而问题转变为了求解以下和式。

$$
n \sum_{\text{p is a prime}} \frac{1}{p}
$$

别忘了$p \ge n$，尽管我们没有将其写在和式之中，但你不应该忘了它。这个和式看起来似乎和调和级数非常类似，让我们回想起调和级数的定义

$$
1 + \frac{1}{2} + \frac{1}{3} + \cdots
$$

由[算数基本定理][ftoa]可知，调和级数可以写为如下形式

$$
(1 + \frac{1}{2} + \frac{1}{4} + \cdots)(1 + \frac{1}{3} + \frac{1}{9} + \cdots)(1 + \frac{1}{5} + \cdots) \cdots
$$

即

$$ 
\prod_{\text{p is prime}} \sum_{k = 0}^{\infty} \frac{1}{p^k} = \prod_{\text{p is prime}} \frac{1}{1 - \frac{1}{p}}
$$

似乎出现了我们想要的东西，尽管还有些差距，因为我们希望得到一个和式而不是连乘。幸运的是，我们有一种方法能将这个连乘变为和式---取对数，且有

$$
\ln(1 + x) = \sum_k^{\infty} \frac{(-1)^{k+1}}{k}x^k, \quad \forall x \in (-1, 1]
$$

（自然对数的[麦克劳林级数（Maclaurin series）][ms]），则有

$$
\begin{align}
\ln (\sum_{k=1}^n \frac{1}{k}) &= \ln (\prod_{\text{p is prime}} \frac{1}{1 - \frac{1}{p}}) \\
&= - \sum_{\text{p is prime}} {\ln (1-\frac{1}{p})} \\
&= \sum_{\text{p is prime}} \frac{1}{p} + \sum_{\text{p is prime}} \frac{1}{2p^2} + \sum_{\text{p is prime}} \frac{1}{3p^3} + \cdots \\
\end{align}
$$

则有（略去高阶项）

$$
\ln (\sum_{k=1}^n \frac{1}{k}) \sim \sum_{\text{p is prime}} \frac{1}{p}
$$

即

$$
\ln \ln n \sim \sum_{\text{p is prime}} \frac{1}{p}
$$

因而我们能知道，埃拉托斯特尼筛法的时间复杂度是$\mathcal{O}(n\log \log n)$。它并不是线性的，所以我们有可能有一个线性的算法来完成这件事情么？

实际上，如果你足够细心，你会发现在埃拉托斯特尼筛法中，如果一个合数他是多个素数的倍数，那么我们会访问多次，浪费了时间。这意味着如果我们能够保证每个数只被筛选一次，我们就可以得到一个线性时间的算法。

一个简单的想法便是，**我们总是用一个合数的最小素因子将其筛掉**。这样我们便不会访问一个合数多次了，实现同样非常简单，在此比较鼓励自己去试着思考并实现一下。[这里][esm]准备了一份并不那么优美的实现。

## 2.加点骰子
线性的筛法在理论上有着优异的渐进时间复杂度，这让人欣慰。很自然的，我们也希望拥有一个效率更高的单个数的素性测试的算法。这并不是一件容易的事，实际上素性测试究竟是不是$P$问题曾困扰了业界数十年。在这段时间里，人们于是退而求其次，开始寻求一些会“犯错”但却高效的算法。


### 2.1.费马素性检验（Fermat primality test）
一个简单的算法源于[费马小定理][fermat]
>若$p$是一个素数，$a$是小于$p$的正整数，我们有
>$$ a^{p-1} \equiv 1 \pmod  p $$

于是很容易的我们可以设计出如下素性检验的算法
{% highlight python %}
def fermat(n):
    # we always assume that n >= 2
    if n <= 3:
        return True
    if n == 4:
        return False

    a = random.randint(2, n - 2)
    if power(a, n - 1, n) != 1:
        return False
    return True
{% endhighlight %}
其中$\text{power}(a, n-1, n)$会计算$a^{n-1} \mod n$，我们使用了一个被称之为快速幂取模的算法，他可以在对数时间内计算出$a^{n-1} \mod n$。受益于这个算法，费马素性检验算法的时间复杂度为$\mathcal{O}(\log n)$。

费马小定理向我们保证了如果$n$是一个素数，那么算法总会回答“真”。但当$n$不是素数的时候，他却有可能犯错，一个可能的例子是$n = 341$，$a = 2$。

我们希望这个犯错的概率尽可能小，一个简单的做法是，我们执行这个算法多次。然而一个叫做卡迈克尔（Carmichael）的人发现，有一些合数$n$非常的坏，对于任意跟$n$互素的整数$b$，都有$b^{n-1} \equiv 1 \pmod n$，例如$561$，现如今我们称之为卡迈克尔数（Carmichael number）。这种数的存在使得费马素性检验在某些情况下会变得非常不可靠，于是我们不得不尝试着去寻找一种新的算法。

### 2.2.米勒-拉宾素性检验（Miller–Rabin primality test）
在介绍新的算法之前，我们需要一些预备知识。

>若$p$是一个素数，$a$是一个小于$p$的正整数，且有$a^2 \equiv 1 \pmod p$，则要么$a=1$，要么$a=p-1$。

这个定理的证明相对容易，由于$a^2 \equiv 1 \pmod p$，我们知道$p$能够整除$(a+1)(a-1)$，而这会给出$a=1$或者$a=p-1$。

那么，若$p$是一个奇素数，$a$是一个小于$p$的正整数，由费马小定理我们可以知道$a^{p-1} \equiv 1 \pmod  p$，由于$p$是一个奇数，那么它可以被写为$a^{2k} \equiv 1  \pmod p$对于某个整数$k$。由上面提到的定理我们有

$$a^k \equiv 1  \pmod p$$

或者

$$a^k \equiv -1  \pmod p$$

如果我们不断重复这个过程，则可以得到如下定理
> 令$p$为一个奇素数。记$p-1=2^kd$，其中$d$是一个奇数，$k$是一个正整数。令$a$是一个小于$p$的正整数，则下列两项至少有一项成立
> - $a^{2^kd}, a^{2^{k-1}d}, a^{2^{k-2}d},\cdots,a^d$中至少有一个与$-1$同余模$p$。
> - $a^d \equiv 1 \pmod p$。

被称之为米勒-拉宾素性检验的算法便基于此定理的逆否命题，正如我们在费马素性检验中所做的那样，它看起来是这样的
{% highlight python %}
def miller_rabin(n):
    # we always assume that n >= 2
    if n <= 3:
        return True
    if n == 4:
        return False

    # find d s.t. n - 1 = d * 2^k
    d = n - 1
    while d % 2 == 0:
        d //= 2
    
    a = random.randint(2, n - 2)
    r = power(a, d, n)
    if r == 1 or r == n - 1:
        return True
    
    while d != n - 1:
        r = (r * r) % n
        d *= 2
        if r == 1:
            return False
        if r == n - 1:
            return True
    
    return False
{% endhighlight %}
[这里][mr]有一个完整的实现，其时间复杂度与费马素性检验相同，均为$\mathcal{O}(\log n)$。这个算法是目前应用最广泛的算法，这里还有一些关于这个算法的有趣结论。
- 如果被测数小于$4759123141$，那么测试三个底数$2, 7$和$61$足矣。
- 如果你每次都使用前$7$个素数进行测试，那么不大于$341550071728320$的数都会给出准确答案。
- 如果选用$2,3,7,61$和$24251$作为底数，那么不大于$10^{16}$的数中仅有$46856248255981$无法给出准确答案。

我在[matrix67][matrix67]的博文中看到这几个结论，可以想象的是，在一些OJ中，它们可以带来非常大的帮助。

## 3.后记
事实上第一个被提出的素性测试随机算法名叫[Solovay–Strassen primality test][ss]，它稍有些繁琐，且实际效果并不出色，于漫长思考过后，我决定放弃了对这个算法的介绍。不过我仍然试着实现了它，参见[这里][ssi]。

前面提到，素性测试是否为$P$问题曾困扰了业界数十年之久。直到2002年，$AKS$素性测试算法的横空出世才回答了这个问题，轰动一时。$AKS$算法具有非常重要的理论意义，但其在实际中的表现却不尽人意，因此本文并没有将其囊括（其实因为自己懒癌发作，或许会在之后的某个篇章中补上）。

[pe]: https://projecteuler.net/
[ftoa]: https://en.wikipedia.org/wiki/Fundamental_theorem_of_arithmetic
[fermat]: https://en.wikipedia.org/wiki/Fermat%27s_little_theorem
[esm]: https://github.com/Myyura/Exercises/blob/master/classic_problems/primality_test/eratosthenes_sieve.py
[mr]: https://github.com/Myyura/Exercises/blob/master/classic_problems/primality_test/miller_rabin.py
[ss]: https://en.wikipedia.org/wiki/Solovay%E2%80%93Strassen_primality_test
[ssi]: https://github.com/Myyura/Exercises/blob/master/classic_problems/primality_test/solovay_strassen.py
[matrix67]: http://www.matrix67.com/
[ms]: https://en.wikipedia.org/wiki/Taylor_series