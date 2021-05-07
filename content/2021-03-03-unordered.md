+++
title = "Unordered Numbers"
date = 2021-03-01
updated = 2021-04-29

slug = "unordered"
[taxonomies]
categories = ["Technical", "All"]
tags = ["Math", "Azul"]
+++
While working on my azul AI I needed a cheap way to store combinations of combinations of tiles to copy around in memory.
The more compact this could be done the faster my `memcpy`s become, and the more gamestates can be cached in working memory.

<!-- more -->

The main idea is to create a number that represents a single uniqe combination of elements, without the order of those elements mattering.

for example `u([1, 2, 3])` = `u([1, 2, 3])` = \\(65\\) if all the elements are base 10.

<details>
<summary>Note about A009994</summary>

if you know there are three elements which can be 10 different values, then the number is the same as what's found in [A009994](https://oeis.org/A009994)

{% python() %}
from itertools import combinations_with_replacement

# Taken from [OESIS](https://oeis.org/A009994)
# Thanks  Chai Wah Wu
def A009994generator(max):
    l = 1
    while l < max:
        for i in combinations_with_replacement('123456789', l):
            yield int(''.join(i))
        l += 1

for n,i in enumerate(A009994generator(4), start=1):
    print("{}: {}".format(n, i))

{% end %}

<details>
<summary>Alternative nonjs log</summary>

```
1: 1
2: 2
3: 3
4: 4
5: 5
6: 6
7: 7
8: 8
9: 9
10: 11
11: 12
12: 13
13: 14
14: 15
15: 16
16: 17
17: 18
18: 19
19: 22
20: 23
21: 24
22: 25
23: 26
24: 27
25: 28
26: 29
27: 33
28: 34
29: 35
30: 36
31: 37
32: 38
33: 39
34: 44
35: 45
36: 46
37: 47
38: 48
39: 49
40: 55
41: 56
42: 57
43: 58
44: 59
45: 66
46: 67
47: 68
48: 69
49: 77
50: 78
51: 79
52: 88
53: 89
54: 99
55: 111
56: 112
57: 113
58: 114
59: 115
60: 116
61: 117
62: 118
63: 119
64: 122
65: 123
66: 124
67: 125
68: 126
69: 127
70: 128
71: 129
72: 133
73: 134
74: 135
75: 136
76: 137
77: 138
78: 139
79: 144
80: 145
81: 146
82: 147
83: 148
84: 149
85: 155
86: 156
87: 157
88: 158
89: 159
90: 166
91: 167
92: 168
93: 169
94: 177
95: 178
96: 179
97: 188
98: 189
99: 199
100: 222
101: 223
102: 224
103: 225
104: 226
105: 227
106: 228
107: 229
108: 233
109: 234
110: 235
111: 236
112: 237
113: 238
114: 239
115: 244
116: 245
117: 246
118: 247
119: 248
120: 249
121: 255
122: 256
123: 257
124: 258
125: 259
126: 266
127: 267
128: 268
129: 269
130: 277
131: 278
132: 279
133: 288
134: 289
135: 299
136: 333
137: 334
138: 335
139: 336
140: 337
141: 338
142: 339
143: 344
144: 345
145: 346
146: 347
147: 348
148: 349
149: 355
150: 356
151: 357
152: 358
153: 359
154: 366
155: 367
156: 368
157: 369
158: 377
159: 378
160: 379
161: 388
162: 389
163: 399
164: 444
165: 445
166: 446
167: 447
168: 448
169: 449
170: 455
171: 456
172: 457
173: 458
174: 459
175: 466
176: 467
177: 468
178: 469
179: 477
180: 478
181: 479
182: 488
183: 489
184: 499
185: 555
186: 556
187: 557
188: 558
189: 559
190: 566
191: 567
192: 568
193: 569
194: 577
195: 578
196: 579
197: 588
198: 589
199: 599
200: 666
201: 667
202: 668
203: 669
204: 677
205: 678
206: 679
207: 688
208: 689
209: 699
210: 777
211: 778
212: 779
213: 788
214: 789
215: 799
216: 888
217: 889
218: 899
219: 999
```

</details>
</details>

I believe this could be useful to compress bitfields:
```rust

//An enum with four variants:
enum Stuff {
  One,
  Two,
  Three,
  Four
}
```
If you put this into a bitfield you could store, `[One, Two, Three, Four]` as something like `00100111`.  
But if you don't care about whether or not it's `[One, Two, Three, Four]` or `[Two, One, Four, Three]` you could sort the list so that it's `[One, Two, Three, Four]` every time.  
You can then use the fact that the first element could be any of the four variants, the second element can be any of the 4 variants, but the third element can only be one of three variants, since the last one was `Two`, namely `Two`, `Three`, or `Four`. Spending two whole bits on that would be a 25% waste of space!  
If we use the "index" of the available options as the bit value we might be able to save a lot of space.  
```
000000  [One, One, One, One]
000001  [One, One, One, Two]
000010  [One, One, One, Three]
000011  [One, One, One, Four]
000100  [One, One, Two, Two]
000101  [One, One, Two, Three]
000110  [One, One, Two, Four]
000111  [One, One, Three, Three]
001000  [One, One, Three, Four]
001001  [One, One, Four, Four]
001010  [One, Two, Two, Two]
001011  [One, Two, Two, Three]
001100  [One, Two, Two, Four]
001101  [One, Two, Three, Three]
001110  [One, Two, Three, Four]
001111  [One, Two, Four, Four]
010000  [One, Three, Three, Three]
010001  [One, Three, Three, Four]
010010  [One, Three, Four, Four]
010011  [One, Four, Four, Four]
010100  [Two, Two, Two, Two]        
010101  [Two, Two, Two, Three]      
010110  [Two, Two, Two, Four]       
010111  [Two, Two, Three, Three]    
011000  [Two, Two, Three, Four]
011001  [Two, Two, Four, Four]
011010  [Two, Three, Three, Three]
011011  [Two, Three, Three, Four]
011100  [Two, Three, Four, Four]
011101  [Two, Four, Four, Four]
011110  [Three, Three, Three, Three]
011111  [Three, Three, Three, Four]
100000  [Three, Three, Four, Four]
100001  [Three, Four, Four, Four]
100010  [Four, Four, Four, Four]
```

Unfortuanetly I've been unable to make a function to convert between them without a map. Though I'm working on it...  
Until that I guess sorting the elements and looking it up in a table will work 😕


# Update 2021-04-26 Encoding!

After a lot of attempts, and this problem burning in the back of my mind, 2 months later I've found a solution.  
The breakthrough was figuring out that if you can figure out how to count how many options there are left, you can work out which option you're at.

You could do this by initializing a loop for counting at some state
{% python() %}

count = 0
for i in range (0,4):
  for j in range (i, 4):
    for k in range(j, 4):
      for l in range(k, 4):
        count += 1
print(count)
{% end %}

Which we knew, but for some reason it didn't click that we could easilly count the states above our original number by just starting at it.

expressing this as mafs would be:

{% katex(block=true) %}
\sum_{i = 1}^4 \sum_{j = i}^4 \sum_{k = j}^4 \sum_{l = k}^4 1
{% end %}

Similarly you can count just the last two digits, and then remove those from the total.  
This way you can find out which one of those options are the initial state.

{% katex(block=true) %}
\begin{alignedat}{2}
&S_4(O, A) &&= \sum_{i = A}^O \sum_{j = i}^O \sum_{k = j}^O \sum_{l = k}^O 1 \\
&S_3(O, B) &&= \sum_{i = B}^O \sum_{j = i}^O \sum_{k = j}^O 1 \\
&S_2(O, C) &&= \sum_{i = C}^O \sum_{j = i}^O 1 \\
&S_1(O, D) &&= O - D \\
&E(O, A, B, C, D) &&= \underbrace{S_3(O, 1)}_{\text{All options}} - 
\underbrace{(S_1(O,D) + S_2(O, C+2) + S_3(O, B+2) + S_4(O, A+2))}_{\text{All options above the initial state}}
\end{alignedat}{2}
{% end %}

Where O is the base (`4`), and the set size being 4 in this case.

You could probably just, uh, count up instead, but I didn't really think of that at the time...

In the end though you end up with some nice numbers:
```
E(4, 0,0,0,0) =  0
E(4, 0,0,0,1) =  1
E(4, 0,0,0,2) =  2
E(4, 0,0,0,3) =  3
E(4, 0,0,1,1) =  5
E(4, 0,0,1,2) =  6
...
E(4, 3,3,3,3) = 35
```

# Update 2021-04-28

What I am actually looking for is apparently something called "Arithmetic coding".  
I can generate a statistical model for which "symbols" should be available in each step really easilly.  

Typical that you find the answer a couple of days after having made progress 🤣

<details>
<summary>2020-03-01 failed attempt at impementation</summary>

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

**Update 2021-03-03**

I've turned the ideas into a functions which are a little more concise.

{% katex(block=true) %}
\begin{aligned}
&n(x)=\lfloor \log x \rfloor + 1 \\
&f(x, y) = \frac{(y \mod 10^{n(y)+1-x}) - (y \mod 10^{n(y)-x})}{10^{n(y)-x}} \\
&u(o) = \sum_{i = 1}^{n(o)} f(i,o)*(10-f(i-1, o))^{n(o)-i}  &o \in \text{A009994} \\
&o(u) = \sum_{i=1}^{n(u)} \frac{f(i, u)*10^{n(u)-i}}{(10-f(i-1, u))^{n(u)-i}}*10^{n(u)-i} &u \in \text{A009994}
\end{aligned}
{% end %}

\\(f(x, y)\\) takes an index \\(x\\) and a number \\(y\\), then gives you the digit at that position from left to right.

\\(n(x)\\) is used to count how many digits there are in a number.

\\(u(o)\\) encodes a number to it's unordered representation (digits must be in increasing order)
\\(o(u)\\) decodes an unordered number back into a "ordered" number.

**Update #2 2021-03-03**

{% python() %}
from math import log10,floor

def n(x):
    return floor(log10(x))+1

def f(x, y):
    return (y%10**(n(y)+1-x) - y%10**(n(y)-x))/(10**(n(y)-x))

def u(o):
    sum = 0
    for i in range(1, n(o)+1):
        sum += f(i, o)*(10-f(i-1, o))**(n(o)-i)
    return sum

def o(u):
    sum = 0
    for i in range(1, n(u)+1):
        sum += (f(i, u)*10**(n(u)-i)/((10-f(i-1,u))**(n(u)-i)))*10**(n(u)-i)
    return sum

print(u(256))
print(o(246))
{% end %}

<details>
<summary>Alternative nonjs log</summary>

```
246.0
256.0
```

</details>

**Update #3 2021-03-03**

Unfortuanetly these functions do not give a perfect compression level.  
_It is better_, just not perfect, and probably not worth it

</details>
