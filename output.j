.source test6
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
ldc 0
istore 3
L_2:
iload 3
ldc 10
if_icmplt L_4
goto L_9
L_3:
iload 3
ldc 1
iadd
istore 3
goto L_2
.line 4
L_4:
.line 5
iload 3
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 6
L_5:
iload 3
istore 4
L_6:
iload 4
iload 3
ldc 10
iadd
if_icmplt L_8
goto L_3
L_7:
iload 4
ldc 1
iadd
istore 4
goto L_6
.line 7
L_8:
.line 8
iload 4
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 9
goto L_7
.line 10
goto L_3
.line 11
.line 12
L_9:
L_10:
iload 4
ldc 5
if_icmpgt L_11
goto L_13
.line 13
L_11:
.line 14
iload 4
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
.line 15
L_12:
iload 4
ldc 1
isub
istore 4
.line 16
goto L_10
L_13:
return
.end method
