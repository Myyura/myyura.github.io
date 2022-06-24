---
layout: post
mathjax: true
title: 算数・强化学习其一・策略学习
category: AI
tags: [machine-learning, reinforcement-learning]
---

强化学习（Reinforcement Learning）其一・策略学习（Policy-based Learning）

## 前言

考虑到这次AI热潮可以说就是AlphaGo引爆的，强化学习这个名词大多数人可能并不陌生。
正好最近在学习并做一些有关于强化学习的简单研究，因此诞生了开辟这个新科普系列（新坑）的想法---这次不会鸽的那么彻底，至少会讲完AlphaGo的。


## 1. 强化学习

回想一下人类自身是怎么进行学习的---除了那些被刻在基因中的恐惧，绝大多数事情是需要亲自尝试之后才能知道好坏。
对于得到好结果的行为，例如螃蟹可以吃并且很好吃，会被认为是可行的，并在接下来的相似的场合被继续执行。
反之，对于那些得到坏结果的行为，人们会将其禁止并作为知识记录，传授给下一代---这某种程度上就是一种监督学习了。
这种正向或者负向激励实施行为的过程，便被称作为强化（Reinforce）。
而就像监督学习模仿的是人类的教育过程一样，强化学习模仿的便是人类面对未知环境时进行探索，强化的过程。


强化学习对上述过程进行了一个简单的抽象，将其中的要素分为了四大部分---环境（Enviroment），智能体（Agent），动作（Action）与奖励（Reward），如下图

<figure style="text-align:center;">
  <img src="{{ site.BASE_PATH }}/assets/images/rl_4elements.png" width="500" alt="1"/>
</figure>

智能体（人类）通过对环境的观察，抽象出信息（即图中的状态，State），并做出相应的动作。
该动作一方面会作用并改变我们身处的环境，另一方面会产生某种反馈，也即奖励。

以围棋为例，从环境中抽象出的状态便是我们看到的棋盘与落子，我们能够进行的动作便是在棋盘上空余之处选出一个位置进行落子，
落子本身会改变棋盘的状态，也可能影响到这局游戏的输赢---如果赢了，那么可以说你这一手的下法就是不错的，从而给予你正向的奖励。

那么如何描述我们落子的策略呢？毕竟这才是我们真正想要学习的东西。
从上述描述中可以看出，策略的输入应该是环境状态$s$，而输出应该与可执行动作$a$相关联。
在强化学习中，描述策略的函数也遵循这一点---我们使用函数

$$\pi: (s,a)\rightarrow[0,1]$$

来对选定动作的策略进行描述，该函数的输入为状态$s$，而输出则为动作$a$的概率分布，或者说“动作$a$在状态$s$下被采取的概率”。
有了动作$a$的概率分布，我们只需要基于此分布做一次采样，就能够得到具体应该采取的动作了。

一局游戏或者说棋局便是将状态输入策略函数$\pi$，采样动作得到动作并更新状态的反复，直到终局为止。这样一局游戏就会产生如下的一组序列

$$
\tau = s_0, a_0, r_0, s_1, a_1, r_1, \ldots, s_n, a_n, r_n
$$

其中元组$(s_i, a_i, r_i)$为$i$时刻（以围棋来看的话便是“你”的第$i$次落子）玩家所观察到的状态，做出的动作与得到的奖励。
我们通常把这样的序列$\tau$称为一次游戏的轨迹（Trajectory），同时为了后续方便，我们会记

$$
\tau_t = s_t, a_t, r_t, \ldots, s_n, a_n, r_n
$$

也即$t$时刻开始的游戏轨迹。

到此我们完成了整个探索过程的抽象，那么强化，或者说我们的目标呢？
一个最直接的想法便是希望我们的“强化”过程能够使我们逐渐学习，最终能够最大化每次动作的收益（奖励），
考虑到在一局游戏中单次动作的收益往往是难以衡量的，尤其是在游戏尚未结束之前。
因此，为了量化我们的收益，我们定义一个新的概念---回报（Return），即一个轨迹的累计收益。

$$
R(\tau) = \sum_{i=0}^n \gamma^i r_i
$$

这里的$\gamma \in (0, 1]$是一个超参数，被称为折扣率。
因为奖励也像钱一样，未来能够得到钱肯定不如现在的钱来的重要。

从轨迹的定义我们可以看到，轨迹主要由两个参数确定---初始状态$s_0$与我们在轨迹（或者说，这局游戏）中所采取的策略$\pi$。
因此，对于一个给定的初始状态$s_0 = s$，我们的目标可以认为是需要寻找到一个好的策略$\pi$，使得在依照该策略进行行动时，能够得到最大的期望回报（即$\mathbb{E}_{\tau\sim\pi}[R(\tau)\mid s_0 = s]$）。

我们把这个期望回报称为状态价值（State-Value），用$V^{\pi}(s)$表示。
这个称呼是非常合适的，因为它确确实实描述了一个策略$\pi$在给定起始状态$s$的情况下所对应的价值---该策略所能获得的期望回报。

当然，只能够应对特定的一些状态的策略肯定是不太够的，要能够应对千奇百怪得初始状态。
因此我们“强化”的最终目标，便是能够学得一个好的策略$\pi$，使得$\mathbb{E}_s[V^{\pi}(s))]$尽可能得大。

在现在这个深度学习当道的年代，我们的策略函数$\pi$自然也会使用神经网络来进行拟合。

对于一个参数为$\theta$的策略网络$\pi_{\theta}$，增大$J(\theta) = \mathbb{E}_s[V^{\pi_{\theta}}(s))]$的方法实际上非常简单，
我们只需要在观察到一个状态$s$之后，做一个简单的梯度上升即可（$\alpha$为学习率）

$$
\theta \leftarrow \theta + \alpha \frac{\partial V^{\pi_{\theta}}(s)}{\partial \theta}
$$

## 2.策略学习
当然，虽说我们可以简单的做一个梯度上升，但对于状态价值$V^{\pi_{\theta}}(s))$的求导却不那么容易。

神经网络的求导相信大家都会，不会至少也可以交给Pytorch。
但这个状态价值显然离我们的策略网络还有一定的距离。

考虑到状态价值实际上是在某个给定状态$s$下依据策略$\pi_{\theta}$采样动作最终获得的期望收益。
为了简便，我们不妨设我们的动作空间是离散的，就像下围棋一样，只有$19 \times 19=361$个位置（动作）可选。
那么根据期望的定义，我们可以将$V^{\pi_{\theta}}(s)$写做

$$
V^{\pi_{\theta}}(s) = \sum_{a} \pi_{\theta} (a\mid s) Q^{\pi_{\theta}}(s,a)
$$

其中

$$Q^{\pi_{\theta}}(s,a) = \mathbb{E}_{\tau \sim \pi_{\theta}}[R(\tau) \mid s_0=s, a_0=a]$$

这个$Q^{\pi_{\theta}}(s,a)$所表述的是，在给定状态$s$的情况下，执行动作$a$之后，
依照策略$\pi_{\theta}$进行行动所能得到的期望收益。
与之前的状态价值略有不同，我们可以认为$Q^{\pi_{\theta}}(s,a)$所评价的是策略$\pi_{\theta}$在状态$s$下采取动作$a$的价值。
因此，$Q^{\pi_{\theta}}(s,a)$往往也被称为动作价值（Action-Value）。


我们在这里做一个简化，假设动作价值跟$\theta$无关
（实际上动作价值$Q^{\pi_{\theta}}(s,a)$与$\pi_{\theta}$是有关联的，严格一点的证明参考附录）。
那么第一节末尾的梯度可以写为

$$
\begin{align}
\frac{\partial V^{\pi_{\theta}}(s)}{\partial \theta} &= \frac{\partial \sum_{a} \pi_{\theta} (a\mid s) Q^{\pi_{\theta}}(s,a)}{\partial \theta} \\
&= \sum_{a} \pi_{\theta} (a\mid s) \frac{\partial \log \pi_{\theta} (a \mid s)}{\partial \theta} Q^{\pi_{\theta}}(s,a) \\
&= \mathbb{E}_a [\frac{\partial \log \pi_{\theta} (a \mid s)}{\partial \theta} Q^{\pi_{\theta}}(s,a)]
\end{align}
$$

中间应用了一个简单的对数技巧，并根据期望的定义，得到了最终的结果。

此时问题就变的比较简单了，对于给定的状态$s$，
我们首先根据策略网络所输出的概率分布采样得到动作$a$，
接着使用某种方式对这个跟$\theta$无关的动作价值$Q^{\pi_{\theta}}(s,a)$进行估计，
最后使用万能的Pytorch对策略网络进行求导，我们就能够得到

$$
\frac{\partial \log \pi_{\theta} (a \mid s)}{\partial \theta} Q^{\pi_{\theta}}(s,a)
$$

这个梯度的值了。
虽然我们实际想要的是该梯度的期望，但这没关系，我们可以使用这单次交互所计算出的梯度作为期望的蒙特卡洛近似，去对网络进行更新。
这可能听起来有些不那么靠谱，但至少数学上是行得通的。

基于这种方法，我们最终能够训练得到一个策略网络$\pi_{\theta}$。
因此该方法也叫做策略学习，而梯度$\frac{\partial V^{\pi_{\theta}}(s)}{\partial \theta}$也被称为策略梯度（Policy Gradient）。

最终我们的算法看起来是这个样子的

> Algorithm parameters: learning rate $\alpha \in (0, 1]$
> 1. Observe state $s_t$
> 2. Randomly sample action $a_t$ according to $\pi_{\theta}(\cdot \mid s_t)$
> Estimate action-value $Q^{\pi_{\theta}}(s_t,a_t)$
> 3. Approximate policy gradient $\frac{\partial \log \pi_{\theta} (a \mid s)}{\partial \theta} Q^{\pi_{\theta}}(s,a)$
> 4. Update policy network $\theta \leftarrow \theta + \alpha \frac{\partial \log \pi_{\theta} (a \mid s)}{\partial \theta} Q^{\pi_{\theta}}(s,a)$

### 2.1 估计动作价值
那么动作价值要如何进行估计呢？其实在之前的讲述中已经给出两套估计动作价值的方案了。

考虑到动作价值实际上是在状态$s$下执行动作$a$之后依照策略$\pi_{\theta}$进行游戏的期望收益，
我们同样可以采取蒙特卡洛近似的方式对这个期望进行估计---只需要在状态$s$的时候执行动作$a$，并使用策略$\pi_{\theta}$打完整局游戏就行了。
假设这局游戏的轨迹为$\tau=s_0=s, a_0=a, \ldots, s_n, a_n, r_n$，
那么我们可以计算并使用回报

$$R(\tau) = \sum_{i=0}^n \gamma^i r_i$$

作为动作价值

$$Q^{\pi_{\theta}}(s,a) = \mathbb{E}_{\tau \sim \pi_{\theta}}[R(\tau) \mid s_0=s, a_0=a]$$

的估计。这种估计方案也被称作REINFORCE。
使用REINFORCE这种方案，由于需要在整局游戏结束之后才能对动作价值进行估计，因此对于网络的更新也需要在一局游戏结束之后，才能将上述的算法应用在轨迹中的每一个元组$(s_t, a_t, r_t)$之上，对网络参数进行更新。

除此之外，我们也可以采取更加深度学习的方式---使用另一个神经网络来对动作价值进行估计。
这会让训练过程看起来有点像生成对抗网络（GAN, Generative Adversarial Network）。
这种方法通常被称为Actor-Critic方法，不出意外的话会在未来的某期强化学习的文章中单独讲解。

从策略梯度的形式可以看出来，策略学习实际上就是根据动作价值对对应动作的被采样概率进行修正---如果动作价值是正的，那么说明这个动作是不错的，我们应该增加其下次被采样到的概率，这样就可以增加回报的期望值了；反之则减少其下次被采样到的概率，扣分的动作我们要尽可能少选。而动作价值的绝对值则决定了这种修正的幅度。

## 3.后记
策略学习是强化学习中一个非常重要的流派，但并非是唯一的选择。
如果我们能够很好的估计动作价值函数的话，则已经可以为我们的动作策略做出指导---我们只要选那个能让未来期望回报最大的动作不就可以了吗？
基于这个想法而诞生的便是另一个流派，价值学习（Value-based Learning）。
实际上从深度强化学习的发展来看，Deepmind的大能们首先是基于价值学习搞定了引起雅达利大崩溃的雅达利游戏，之后才慢慢进化得到AlphaGo的。
但考虑到策略学习中对于动作价值的利用，以及之后AlphaGo的讲解计划，遍先选择了策略学习。

强化学习总的来说还是有一些有趣的---倘若你不计较绝大多数论文都复现不出来其所宣称的效果的话。

## 4.附录
这里我们来稍微严格一点的，讲述一下策略梯度计算，该证明参考了 [《Reinforcement Learning: An Introduction》(Richard S. Sutton and Andrew G. Barto) (Sec 13.2)][rl_book]。

让我们从

$$
\nabla_\theta V^{\pi_\theta}(s)
= \nabla_\theta \Big(\sum_{a  } \pi_\theta(a \vert s)Q^{\pi_\theta}(s, a) \Big)
$$

开始，首先我们根据微分的乘法法则，将上式写作

$$
\sum_{a  } \Big( \big( \nabla_\theta \pi_\theta(a \vert s) \big)Q^{\pi_\theta}(s, a) + \pi_\theta(a \vert s) \nabla_\theta Q^{\pi_\theta}(s, a) \Big)
$$

接着，我们根据动作价值$Q^\pi$的定义，将第二项进行扩展，得到

$$
\sum_{a  } \Big( \big( \nabla_\theta \pi_\theta(a \vert s) \big)Q^{\pi_\theta}(s, a) + \pi_\theta(a \vert s) \nabla_\theta \sum_{s', r} P(s',r \vert s,a)(r + V^{\pi_\theta}(s')) \Big)
$$

这里$P(s',r \vert s,a)$表示在当前状态$s$下采取动作$a$后转移到下一个状态$s′$并得到回报$r$的概率。
这个概率与参数$\theta$无关，因此我们有

$$
\sum_{a  } \Big( \big( \nabla_\theta \pi_\theta(a \vert s) \big)Q^{\pi_\theta}(s, a) + \pi_\theta(a \vert s) \sum_{s', r} P(s',r \vert s,a) \nabla_\theta V^{\pi_\theta}(s') \Big)
$$

且由于$P(s' \vert s,a) = \sum_r P(s',r \vert s,a)$，于是我们有

$$
\nabla_\theta V^{\pi_\theta}(s) = \sum_{a  } \Big( \big( \nabla_\theta \pi_\theta(a \vert s) \big)Q^{\pi_\theta}(s, a) + \pi_\theta(a \vert s) \sum_{s'} P(s' \vert s,a) \nabla_\theta V^{\pi_\theta}(s') \Big)
$$

可以看到这个式子呈现出良好的递归样式---等式左边为$V^{\pi_\theta}(s)$，
而右边有$\nabla_\theta V^{\pi_\theta}(s')$。
我们将右边含有$\nabla_\theta V^{\pi_\theta}(s')$的部分进行递归展开，
为了简化表示，我们记$\phi(s) = \sum_{a  } \big( \nabla_\theta \pi_\theta(a \vert s) \big)Q^{\pi_\theta}(s, a)$，即上式的左半部分。

$$
\begin{align}
\nabla_\theta V^{\pi_\theta}(s) &= \phi(s) + \sum_{a  } \pi_\theta(a \vert s) \sum_{s'} P(s' \vert s,a) \nabla_\theta V^{\pi_\theta}(s') \\
&= \phi(s) + \sum_{s'} \sum_a \pi_\theta(a \vert s) P(s' \vert s,a) \nabla_\theta V^{\pi_\theta}(s') \\
&= \phi(s) + \sum_{s'} \sum_a \pi_\theta(a \vert s) P(s' \vert s,a)\Big [\phi(s') + \sum_{s''} \sum_a \pi_\theta(a' \vert s') P(s'' \vert s',a') \nabla_\theta V^{\pi_\theta}(s'') \Big] \\
\end{align}
$$

倘若我们将这种展开一直做下去，最终的式子里也就不在包含有含$\nabla_\theta V^{\pi_\theta}(s)$的项，
而由于在

$$\phi(s) = \sum_{a  } \big( \nabla_\theta \pi_\theta(a \vert s) \big)Q^{\pi_\theta}(s, a)$$

中我们并不需要动作价值的梯度$\nabla Q^{\pi_\theta}(s,a)$。
因此，我们得到

$$
\frac{\partial V^{\pi_{\theta}}(s)}{\partial \theta} \propto \sum_a Q^{\pi_\theta}(s,a) \nabla_\theta \pi_\theta (a \vert s)
$$

[rl_book]: http://incompleteideas.net/book/bookdraft2017nov5.pdf