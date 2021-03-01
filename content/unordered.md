+++
title = "Unordered Numbers"
date = 2021-03-01

[taxonomies]
categories = ["Technical", "All"]
tags = ["Math", "Azul"]
+++
While working on my azul AI I needed a cheap way to store combinations of combinations of tiles to copy around in memory.
The more compact this could be done the faster my `memcpy`s become, and the more gamestates can be cached in working memory.

I won't go into much detail about that here, this blog post is about this "unordered number" discovery.
I'm sure someone somewhere has discovered such numbers already, but I have no idea what they're called.
If you do know, feel free to point it out to me [via email!](mailto:me@dandellion.xyz)

I'll do an example of given a \\(\text{base}_0 = 10\\) three digit number: \\(562\\).

First we must sort the digits in ascending order, I've named each position in the number \\(a\\), \\(b\\), and \\(c\\).

$$a \leq b \leq c$$

$$562 \to 256$$

Now we take the first digit (\\(a = 2\\) in this case), and do a "normal" step when turning digits into a number.
The next step does the same but since we know the digit cannot be smaller than the last number, we can remove those possibilities from the base.

{% katex(block=true) %}
\begin{alignedat}{3}
u &= a*(\text{base}_0)^2 &&+ b*(\text{base}_0-a)^1  &&+ c*(\text{base}_0-b)^0 \\
u &= 2*10^2 &&+ 5*8 &&+ 6*1 \\
  &= 200 &&+ 40 &&+ 6 \\
u & = 246
\end{alignedat}
{% end %}

And that's it! Now you have a number that represents the original number but without such pesky unimportant things encoded like digit position..

To go the other way is also quite simple with some integer math.

{% katex(block=true) %}
u = 246,
a_u = 2,
b_u = 4,
c_u = 6,
{% end %}

let's find \\(a\\) first:


{% katex(block=true) %}
\begin{alignedat}{2}
&u_a &&= u \\
&a &&= \bigg\lfloor \frac{u_a}{\text{base}_0^2} \bigg\rfloor \\
&a &&= \bigg\lfloor \frac{246}{10^2} \bigg\rfloor = \lfloor 2.4 \rfloor = 2 \\
&a_n &&= a * \text{base}_0^2 \\
&a_n &&= 2*10^2 = 200
\end{alignedat}
{% end %}


Continuing with \\(b\\):

We first remove from \\(a_n\\) from \\(u\\):

{% katex(block=true) %}
\begin{alignedat}{2}
&u_b &&= u_a - a_n \\
&u_b &&= 246 - 200 = 46
\end{alignedat}
{% end %}

Then we do just  the same thing as in we did to find \\(a\\), but this time we change the base similarly to how we did it when we encoded,
we're just dividing instead of multiplying.
NB: \\(a_u\\) the "unordered" "\\(a\\)" is what's being used here, NOT the original \\(a\\).

{% katex(block=true) %}
\begin{alignedat}{2}
&b &&= \bigg\lfloor \frac{u_b}{(\text{base}_0-a_u)^1} \bigg\rfloor \\
&b &&= \bigg\lfloor \frac{46}{(10-2)^1} \bigg\rfloor = \lfloor 5.75 \rfloor = 5 \\\\
&b_n &&= 5 * 8 = 40
\end{alignedat}
{% end %}

then \\(c\\):

{% katex(block=true) %}
\begin{alignedat}{2}
&u_c &&= 46 - 40 = 6 \\\\
&b &&= \bigg\lfloor \frac{u_c}{(\text{base}_0-b_u)^0} \bigg\rfloor \\
&b &&= \bigg\lfloor \frac{6}{(10-4)^0} \bigg\rfloor = 6 \\\\
&b_n &&= 6 * 1 = 6
\end{alignedat}
{% end %}

At last, now that we have \\(a\\), \\(b\\), and \\(c\\) we can construct \\(n\\):

{% katex(block=true) %}
\begin{alignedat}{2}
&n &&= a*10^2 + b * 10^1 + c * 10^0 \\
&n &&= 2 * 10^2 + 5 * 10^1 + 6 * 10^0 \\
&n &&= 256
\end{alignedat}
{% end %}

Success!!

I guess we'll have to see how much CPU time this takes versus the space savings. But I'm certain this kind of thing can be useful!  
Maybe for serializing unordered sets?
