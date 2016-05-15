.class public bytecodeOutput
	.super java/lang/Object
	; standard initializer
	.method public <init>()V
		aload_0
		invokenonvirtual java/lang/Object/<init>()V
		return
	.end method

	.method public static main([Ljava/lang/String;)V
		; set limits used by this method
		.limit locals 50
		.limit stack 50
		L0:
			bipush 0.0
		L1:
			fstore 1
			getstatic java/lang/System/out Ljava/io/PrintStream;
			ldc "1: "
			invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V
			getstatic java/lang/System/out Ljava/io/PrintStream;
			fload 1
			invokevirtual java/io/PrintStream/println(F)V
		L2:
		return
	.end method