---
layout: post
mathjax: true
title: 算数・强化学习其二・价值学习
category: AI
tags: [machine-learning, reinforcement-learning]
---

强化学习（Reinforcement Learning）其二・价值学习（Value-based Learning）

## 前言

直接学习动作价值函数从某些角度来说要更加的容易理解---动作价值本身就是在某局面下选择动作能够带来的期望收益，而我们的目标又是希望期望收益最大。
因此，如果我们能够学习出动作价值函数，那么只要在每个状态下，根据动作价值函数去选择那个价值最大的动作，则万事休矣。
这便是价值学习的指导思想，所谓价值，指的便是动作价值。


## 1. Temporal Difference (TD) Error

学习动作价值的思路非常的简单，让我们首先回顾一个概念---回报。
回报指的是一个给定轨迹$\tau_t = s_t, a_t, r_t, \ldots, s_n, a_n, r_n$的累计收益，即

$$
R(\tau_t) = \sum_{i=t}^n \gamma^{i-t} r_i
$$

从回报的定义，我们可以轻松推导出

$$
R(\tau_t) = r_t + \gamma R(\tau_{t+1})
$$

假定我们的轨迹$\tau_t$是由某个策略$\pi$以起始状态$s_t$，起始动作$a_t$生成的（尽管$t+1$时刻的状态$s_{t+1}$在$t$时刻的状态与动作都固定的情况下通常也是固定的，但动作$a_{t+1}$由策略$\pi$随机采样得到，具有随机性。因此，为了方便区分，我们使用大写字母表示随机变量），于是我们可以对两边求期望，则可以得到

$$
\mathbb{E}_{\tau_t \sim \pi} [R(\tau_t) \mid S_t=s_t, A_t=a_t] = \mathbb{E}_{\tau_t \sim \pi} [r_t + \gamma R(\tau_{t+1}) \mid S_t=s_{t}, A_t=a_{t}]
$$

根据动作价值函数的定义

$$
Q^\pi(s,a) = \mathbb{E}_{\tau_t \sim \pi}[R(\tau_t) \mid S_t=s_t, A_t=a_t]
$$

我们可以得到

$$
Q^\pi(s_t, a_t) = \mathbb{E}_{\tau_t \sim \pi} [r_t + \gamma Q^\pi (s_{t+1}, A_{t+1}) \mid S_t=s_t, A_t=a_t]
$$

等式右边的期望项我们可以通过蒙特卡洛近似的方法，根据策略采样出具体动作$a_{t+1}$，使用$r_t + Q^\pi (s_{t+1}, a_{t+1})$对该期望进行近似。即有

$$
Q^\pi(s_t, a_t) \approx r_t + \gamma Q^\pi (s_{t+1}, a_{t+1})
$$

而该式便是价值学习的核心，我们通常把式子右边的$y_t = r_t + \gamma Q^\pi (s_{t+1}, a_{t+1})$称为TD Target。
等式左右之差便被称为TD Error。
借助TD Error，我们便可以想办法来学习动作价值函数---
让$Q^\pi(s_t, a_t)$尽可能接近TD Target 
$r_t + \gamma Q^\pi (s_{t+1}, a_{t+1})$。
从逻辑上来说，这是因为，TD Target中包含了我们真实观测到的奖励$r_t$，相比于完全是估计的$Q^\pi(s_t, a_t)$，要更加可靠。

## 2. SARSA与Q-Learning

有了在第一节最后得到的等式，我们可以很简单的给出一个算法来学习我们的动作价值函数。
这里我们和在策略学习中一样，使用一个权重为$\theta$的神经网络$Q(s,a;\theta)$来对动作价值函数$Q^\pi(s,a;\theta)$进行近似。

> Algorithm parameters: discounted ratio $\gamma \in [0, 1]$, learning rate $\alpha \in (0, 1]$
> 1. Observe a transition $(s_t, a_t, r_t, s_{t+1})$
> 2. Sample $a_{t+1}$ from a policy $\pi(\cdot \mid s_{t+1})$ (The policy is usually derived from Q-values)
> 3. TD Target: $y_t = r_t + \gamma Q(s_{t+1}, a_{t+1}; \theta)$
> 4. Loss (TD Error): $L = \frac{1}{2} (y_t - Q(s_t, a_t; \theta))^2$
> 5. Update: $\theta \leftarrow \theta - \alpha \frac{\partial L}{\partial \theta}$

这个算法又被称为SARSA (State-Action-Reward-State-Action)算法。
在算法的第一步和第二步，我们都需要根据当前的状态选择需要执行的动作。
考虑到动作价值的定义---选择动作所获得的期望收益---我们直接选择动作价值最高的动作来作为我们的策略便是一个非常好的选择。
当然，我们需要在选择的过程中加入一点随机性，譬如有$\epsilon$的概率随机选择一个动作，来避免训练总是陷入某些尴尬的局部最优。
这样的机制又被称为$\epsilon$-greedy。

通过SARSA算法学习得到了策略$\pi$的动作价值函数$Q^\pi$。
这可能并不能让许多人满意---如果我们的策略$\pi$并不好，我们学习到的动作价值本身可能也好不到哪里去。
因此，我们可以考虑一步到位，直接学习最优动作价值

$$
Q^\star(s,a) = \max_\pi Q^\pi (s,a)
$$

那么根据第一章节中的推导，令$\pi^\star$表示最优策略，我们有

$$
Q^{\pi^\star}(s_t, a_t) = \mathbb{E}_{\tau_t \sim \pi^\star} [r_t + \gamma Q^{\pi^\star} (s_{t+1}, A_{t+1}) \mid S_t=s_t, A_t=a_t]
$$

即

$$
Q^\star(s_t, a_t) = \mathbb{E}_{\tau_t \sim \pi^\star} [r_t + \gamma Q^\star (s_{t+1}, A_{t+1}) \mid S_t=s_t, A_t=a_t]
$$

而由于$Q^\star$是最优动作价值，我们理应选择最优动作价值最大的动作（也即最优策略），即

$$
A_{t+1} = \text{argmax}_a Q^\star(s_{t+1}, a)
$$

因此我们有

$$
Q^\star(s_t, a_t) = \mathbb{E}_{\tau_t \sim \pi^\star} [r_t + \gamma \max_a Q^\star (s_{t+1}, a) \mid S_t=s_t, A_t=a_t]
$$

也即

$$
Q^\star(s_t, a_t) \approx r_t + \gamma \max_a Q^\star (s_{t+1}, a)
$$

因此我们只需要将SARSA算法中计算TD Target的部分更改为

> TD Target: $y_t = r_t + \gamma \max_a Q(s_{t+1}, a_{t+1}; \theta)$

这个学习最优动作价值的算法便是Q-learning算法。
从形式上来说，Q-learning与SARSA非常相似，但却有本质的不同。
在SARSA中，学习和行动我们使用了相同的策略，即两次使用相同的$\epsilon$-greedy方法得到动作价值$Q(s_t,a_t)$与$Q(s_{t+1}, a_{t+1})$。
我们把SARSA这种算法称为在线学习（On Policy）算法。
而在Q-learning中，学习和行动使用的是不同的策略，在行动时我们使用$\epsilon$-greedy进行动作选择，而在学习时我们使用max来计算动作价值。
我们把Q-learning这种算法称为离线学习（Off Policy）算法。

## 3. 过估计（Overestimation）与目标网络（Target Network）

Q-learning看起来非常好，但却存在一个非常严重的问题，被称为过估计（或者高估），即我们学习到的动作价值往往是被高估的。
当这种高估不均匀的时候，可能会导致我们选到不好的动作。
譬如在某状态$s$下有两个可选动作$a_1$与$a_2$，其最优状态动作价值分别为

$$Q^\star(s,a_1)=50, Q^\star(s,a_2)=80$$

按理说我们应该选择动作$a_2$，但若动作价值存在非均匀的高估，例如我们实际计算得到的动作价值分别为

$$Q^\star(s,a_1)=100, Q^\star(s,a_2)=90$$

那么我们就可能选择动作价值较低的动作$a_1$。

造成这种非均匀过估计的原因主要有两个---最大化（Maximization）与自举（Bootstrapping）。

### 3.1 最大化带来的高估

在这里我们非严谨的给出一个解释。

考虑一个状态动作元组$(s_t,a_t)$，根据动作价值的定义与第一节的推导，我们有

$$
Q^\pi(s_t, a_t) = \mathbb{E}_{\tau_t \sim \pi} [r_t + \gamma Q^\pi (s_{t+1}, A_{t+1}) \mid S_t=s_t, A_t=a_t]
$$

这里我们简单的改写为

$$
Q^\pi(s,a) = \mathbb{E} [r + \gamma Q^\pi(s', a')]
$$

而我们希望估计的最优动作价值为

$$
Q^\star(s,a) = \max_\pi Q^\pi(s,a) = r + \gamma \max_\pi \mathbb{E} [Q^\pi(s', a')] 
$$

记住这里，我们是在求一个“期望的最大值”。
而我们实际计算的TD Target是怎么样的呢？

$$
    y' = r + \gamma \max_a Q(s',a; \theta) \\
$$

其中$\max_a Q(s',a; \theta)$是对最优动作价值$Q^\star(s',a')$的估计。而根据最优动作价值的定义，

$$
Q^\star(s',a') = \max_\pi Q^\pi(s',a')
$$

根据蒙特卡罗方法的思想，$\max_\pi Q^\pi(s',a')$只能作为期望

$$\mathbb{E} [\max_\pi Q^\pi(s',a')]$$

的估计，也即“最大值的期望”。那么根据熟悉的[琴生不等式（Jensen's inequality）][ji]，我们知道最大值的期望肯定是不小于期望的最大值的，因此Q-learning中的maximization带来了高估。

### 3.2 自举带来的高估

所谓自举（Bootstrapping），描述的就是一直左脚踩右脚上天的情况。
这在现实中当然是不可能出现的，但在我们更新动作价值的过程中，
所用到的TD Target，它也有一部分是由高估的动作价值本身组成的，即

$$
y_t = r_t + \gamma \max_a Q(s_{t+1}, a_{t+1}; \theta)
$$

中的$\max_a Q(s_{t+1}, a_{t+1}; \theta)$。
这样一来，就形成了用被高估的动作价值去更新它自身的情况，形成了左脚踩右脚，最终会将这个高估推向无穷大。

### 3.3 目标网络

在DeepMind的开天辟地《Playing Atari with Deep Reinforcement Learning》与《Human-level control through deep reinforcement learning》，以及后来的《Deep Reinforcement Learning with Double Q-learning》论文中，
为了解决Q-learning高估的问题，采取了分离动作选择与价值估计的方法。

具体来说，我们准备一个结构与$Q(s,a;\theta)$相同的网络，
记作$Q(s,a;\theta')$。
该网络也被称之为目标网络。
在训练过程中，我们每间隔若干Training Step，便将$Q(s,a;\theta)$网络的权重与$Q(s,a;\theta')$进行同步（即将$\theta$的权重赋予$\theta'$）。

同时，我们对Q-learning的算法进行少许更改---在选择动作的时候，我们使用$Q(s,a;\theta)$进行选择，在估计动作价值时，我们使用目标网络$Q(s,a;\theta')$，即

> Algorithm parameters: discounted ratio $\gamma \in [0, 1]$, learning rate $\alpha \in (0, 1]$
> 1. Observe a transition $(s_t, a_t, r_t, s_{t+1})$
> 2. Select an action of maximum action-values, $a^\star_{t+1} = argmax_a Q(s_{t+1}, a; \theta)$
> 3. TD Target: $y_t = r_t + \gamma Q(s_{t+1}, a^\star_{t+1}; \theta')$
> 4. Loss (TD Error): $L = \frac{1}{2} (y_t - Q(s_t, a_t; \theta))^2$
> 5. Update: $\theta \leftarrow \theta - \alpha \frac{\partial L}{\partial \theta}$

通过将动作选择与价值估计分离，能够有效的解决自举带来的高估。
同时，通过$Q(s,a;\theta)$选择的动作并非一定是目标网络价值最大的动作，即有

$$
Q(s_{t+1}, a^\star_{t+1}; \theta') \le \max_a Q(s_{t+1}, a; \theta')
$$

缓解了maximization带来的高估问题。
这个方法被称为Double Q-learning。
不过值得注意的是，该方法并不能够彻底解决Q-learning的高估问题，只是能够尽可能的去缓解。

### 4. 后记

到这里我们学习了强化学习中的两大基本流派---策略学习与价值学习。
可以看到这两种基本想法都是非常朴素简单的。
下一篇我们将正式开始讲述强化学习最广为人知的应用案例，AlphaGo。
届时让我们来看看这些抽象的概念是如何应用在实际案例中的。

[ji]: https://en.wikipedia.org/wiki/Jensen%27s_inequality