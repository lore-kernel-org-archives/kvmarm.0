From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 3/4] pre_init: add support for i386 also
Date: Wed, 24 Feb 2016 15:33:07 +0000
Message-ID: <1456327988-31568-4-git-send-email-andre.przywara@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently the pre_init support is provided only for x86_64. Since
having 32-bit x86 supported as well is not far off, just add an
implementation using i386 assembly instructions and the respective
syscall ABI.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile     |  1 +
 x86/init32.S | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)
 create mode 100644 x86/init32.S

diff --git a/Makefile b/Makefile
index e26afa3..54bdd31 100644
--- a/Makefile
+++ b/Makefile
@@ -106,6 +106,7 @@ ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
 ifeq ($(ARCH),i386)
 	ARCH         := x86
 	DEFINES      += -DCONFIG_X86_32
+	ARCH_PRE_INIT = x86/init32.S
 endif
 ifeq ($(ARCH),x86_64)
 	ARCH         := x86
diff --git a/x86/init32.S b/x86/init32.S
new file mode 100644
index 0000000..8937deb
--- /dev/null
+++ b/x86/init32.S
@@ -0,0 +1,50 @@
+/*
+ * #!/bin/sh
+ * mount -t 9p -o trans=virtio,version=9p2000.L hostfs /host
+ * /virt/init $*
+ */
+
+#include <asm/unistd.h>
+.text
+.globl _start
+_start:
+
+# Linux syscall ABI
+# i386/int 0x80:  nr = eax, args: ebx ecx edx esi edi ebp
+# x86_64/syscall: nr = rax, args: rdi rsi rdx r10 r8  r9
+
+	mov	$__NR_mount, %eax
+	mov	$.m_dev, %ebx
+	mov	$.m_dir, %ecx
+	mov	$.m_typ, %edx
+	mov	$1, %esi		# MS_RDONLY
+	mov	$.m_opt, %edi
+	int	$0x80
+
+	mov	$__NR_execve, %eax
+	mov	$.e_nam, %ebx		# filename: "/virt/init"
+	lea	4(%esp), %ecx		# pass through argv
+	mov	%ebx, (%ecx)		# overwrite argv[0] with "/virt/init"
+	mov	(%esp), %edx		# read argc
+	inc	%edx
+	lea	(%ecx,%edx,4), %edx	# envp = argv + argc + 1
+	int	$0x80
+
+	mov	$__NR_exit, %eax
+	mov	$1, %ebx
+	int	$0x80			# panic
+
+loop:	hlt
+	jmp	loop
+
+.m_dev:
+.string "hostfs"
+.m_dir:
+.string "/host"
+.m_typ:
+.string "9p"
+.m_opt:
+.string "trans=virtio,version=9p2000.L"
+
+.e_nam:
+.string "/virt/init"
-- 
2.6.4

