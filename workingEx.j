.class public Array
.super java/lang/Object

.method public <init>()V
aload_0
invokenonvirtual java/lang/Object/<init>()V
return
.end method


.method public static main([Ljava/lang/String;)V
.limit locals 100
.limit stack 100

nop 
ldc 1
istore 1
nop 
ldc 2
istore 2
nop 
iload 1
iload 2
iadd 
istore 3
getstatic      java/lang/System/out Ljava/io/PrintStream;

iload 3
invokevirtual  java/io/PrintStream/println(I)V
return
.end method