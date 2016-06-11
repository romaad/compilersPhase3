.source input_code.txt
.class public test
.super java/lang/Object

.method public <init>()V
aload_0
invokenonvirtual java/lang/Object/<init>()V
return
.end method

.method public static main([java/lang/String)V
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
iload 3
ldc 5
ifcmpeq L_2
goto L_3
.line 4
L_2:
.line 5
ldc 8
istore 3
.line 6
.line 7
.line 8
L_3:
.line 9
ldc 9
istore 3
.line 10
.line 11
L_4:
iload 3
istore 1
getstatic      java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
L_5:
return
.end method
