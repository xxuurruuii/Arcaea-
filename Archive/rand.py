from random import *

def check(l,r):
    if diejian==False and l==r:return -100
    if l-r>=3:return -100
    x=0
    if (l-r)%2==0:
        if l<=r:x=0
        if l>r:
            x=3
            if fanshou<0:x=-3
    else:
        if r%2==1:
            if l<r:x=1
            if l>r:x=2
        if r%2==0:
            if l<r:x=-1
            if l>r:x=-2
    if abs(x-fanshou)>2:return -100
    if abs(x)>maxfanshou:return -100
    if abs(fanshou)>=2 and abs(x)>=2 and randint(1,2)==1:return -100
    return x

def rand(n):
    global fanshou
    global output
    qishou=randint(0,1)
    l,r=randint(1,7),randint(1,7)
    while abs(l-r)<=1:l,r=randint(1,7),randint(1,7)
    if l>r:l,r=r,l
    fanshou=0
    fanshou=check(l,r)
    if qishou==0:
        output+=[l,r]
    else:
        output+=[r,l]
    for i in range(2,n):
        if i%2==qishou:
            l=randint(1,7)
            _=check(l,r)
            while _==-100:
                l=randint(1,7)
                _=check(l,r)
            fanshou=_
            output.append(l)
        else:
            r=randint(1,7)
            _=check(l,r)
            while _==-100:
                r=randint(1,7)
                _=check(l,r)
            fanshou=_
            output.append(r)

output=[]
fanshou=0   #1:左手在左上 2:左手在右上 3:左手在右
diejian=False
f=open('2.aff','w')
bpm=153
maxfanshou=1

for i in range(16):
    output.append(randint(1,7))
    output+=[0,0,0]
maxfanshou=2
for i in range(16):
    rand(5)
    output.append(0)
    rand(2)
    output.append(0)
    rand(2)
    output.append(0)
    rand(3)
    output.append(0)
maxfanshou=1
rand(63)
output.append(0)
rand(63)
output.append(0)

maxfanshou=2
rand(17)
output+=[0,0,0]
output.append(randint(1,7))
output+=[0,0,0]
output.append(randint(1,7))
output+=[0,0,0]
rand(21)
output+=[0,0,0]
output.append(randint(1,7))
output+=[0,0,0]
output.append(randint(1,7))
output+=[0,0,0]
rand(21)
output+=[0,0,0]
output.append(randint(1,7))
output+=[0,0,0]
output.append(randint(1,7))
output+=[0,0,0]
rand(37+64*4)
output+=[0,0,0]

for i in range(15):
    output.append(randint(1,7))
    output+=[0,0,0]
for i in range(3):
    output.append(randint(1,7))
    output+=[0]
    output.append(randint(1,7))
    output+=[0]
    rand(2)
    output+=[0,0]
    output.append(randint(1,7))
    output+=[0,0]
    rand(2)
    output+=[0]
    output.append(randint(1,7))
    output+=[0]
rand(2)
output+=[0,0]
output.append(randint(1,7))
output+=[0,0]
rand(2)
output+=[0]
output.append(randint(1,7))
output+=[0]
rand(3)
output+=[0]
for i in range(24):
    output.append(randint(1,7))
    output+=[0]
    rand(3)
    output+=[0]
    output.append(randint(1,7))
    output+=[0]
    rand(3)
    output+=[0]
    output.append(randint(1,7))
    output+=[0]
    output.append(randint(1,7))
    output+=[0]
maxfanshou=3
rand(64*4)


f.write('''AudioOffset:0
-
timing(0,153.00,4.00);
''')
for i in range(len(output)):
    t=int(60/153*i*1000/4)
    if output[i]==0:continue
    if output[i]%2==1:
        f.write(f'({t},{output[i]//2+1});\n')
    if output[i]%2==0:
        f.write(f'arc({t},{t+1},{(output[i]-2)/4},{(output[i]-2)/4},s,1.00,1.00,0,none,true)[arctap({t})];\n')
f.close()