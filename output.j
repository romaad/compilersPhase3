.source test1
.class public test
.super java/lang/Object

.method public <init>()V
aload_0
invokenonvirtual java/lang/Object/<init>()V
return
.end method

.method public static main([Ljava/lang/String;)V
.limit locals 100
.limit stack 100
iconst_0
istore 1
fconst_0
fstore 2
.line 1
iconst_0
istore 3
.line 2
L_0:
iconst_0
istore 4
.line 3
L_1:
iconst_0
istore 5
.line 4
L_2:
ldc 2
istore 3
.line 5
L_3:
L_4:
iload 3
ldc 0
if_icmpgt L_5
goto L_20
.line 6
L_5:
.line 7
ldc 2
istore 4
.line 8
L_6:
L_7:
iload 4
ldc 0
if_icmpgt L_8
goto L_19
.line 9
L_8:
.line 10
ldc 2
istore 5
.line 11
L_9:
L_10:
iload 5
ldc 0
if_icmpgt L_11
goto L_18
.line 12
L_11:
.line 13
iload 3
iload 4
if_icmpeq L_12
goto L_16
L_12:
iload 4
iload 5
if_icmpeq L_13
goto L_16
L_13:
.line 14
iload 3
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 15
L_14:
iload 4
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 16
L_15:
iload 5
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 17
goto L_17
.line 18
L_16:
.line 19
ldc 0
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 20
.line 21
L_17:
iload 5
ldc 1
isub
istore 5
.line 22
.line 23
goto L_10
.line 24
L_18:
iload 4
ldc 1
isub
istore 4
.line 25
.line 26
goto L_7
.line 27
L_19:
iload 3
ldc 1
isub
istore 3
.line 28
.line 29
goto L_4
.line 30
L_20:
ldc 55
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
L_21:
return
.end method
