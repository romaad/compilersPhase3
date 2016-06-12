.source test5
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
ldc 5
istore 3
.line 3
L_1:
iconst_0
istore 4
.line 4
L_2:
ldc 11
istore 4
.line 5
L_3:
L_4:
iload 3
ldc 5
if_icmpeq L_5
goto L_17
.line 6
L_5:
.line 7
L_6:
iload 4
ldc 11
if_icmpeq L_7
goto L_4
.line 8
L_7:
.line 9
L_8:
iload 3
ldc 5
if_icmpeq L_9
goto L_6
.line 10
L_9:
.line 11
L_10:
iload 4
ldc 112
if_icmplt L_11
goto L_8
.line 12
L_11:
.line 13
L_12:
iload 3
ldc 5
if_icmpeq L_13
goto L_15
.line 14
L_13:
.line 15
iload 3
ldc 1
iadd
istore 3
.line 16
L_14:
iload 3
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 17
goto L_12
.line 18
L_15:
iload 4
ldc 2
iadd
istore 4
.line 19
L_16:
iload 4
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 20
goto L_10
.line 21
goto L_8
.line 22
goto L_6
.line 23
goto L_4
.line 24
.line 25
L_17:
iload 4
ldc 10
if_icmpgt L_18
goto L_19
.line 26
L_18:
.line 27
iload 3
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 28
goto L_20
.line 29
.line 30
L_19:
.line 31
iload 4
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 32
L_20:
return
.end method
