From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 4/4] pre_init: add ARM implementations
Date: Wed, 24 Feb 2016 15:33:08 +0000
Message-ID: <1456327988-31568-5-git-send-email-andre.przywara@arm.com>
References: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1456327988-31568-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The pre_init stub consists of two syscalls mouting the host's FS
via 9pfs and then calling the actual init binary, which can now
use normal dynamic linking.
Based on the x86 code provide an ARM and ARM64 implementation of
that. Beside removing the need for static linkage it reduces the
size of the kvmtool binary by quite a lot (numbers for aarch64):

-rwxr-xr-x 1 root root     9952 Nov 16 14:37 guest/init
-rwxr-xr-x 1 root root      512 Nov 16 14:37 guest/pre_init
-rwxr-xr-x 2 root root  1284704 Nov 16 14:37 lkvm
vs. the old version:
-rwxr-xr-x 1 root root   776024 Nov 16 14:38 guest/init
-rwxr-xr-x 2 root root  2050112 Nov 16 14:38 lkvm

Tested on Midway and Juno.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile           |  2 ++
 arm/aarch32/init.S | 44 ++++++++++++++++++++++++++++++++++++++++++++
 arm/aarch64/init.S | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+)
 create mode 100644 arm/aarch32/init.S
 create mode 100644 arm/aarch64/init.S

diff --git a/Makefile b/Makefile
index 54bdd31..57b0bdd 100644
--- a/Makefile
+++ b/Makefile
@@ -161,6 +161,7 @@ ifeq ($(ARCH), arm)
 	OBJS		+= $(OBJS_ARM_COMMON)
 	OBJS		+= arm/aarch32/arm-cpu.o
 	OBJS		+= arm/aarch32/kvm-cpu.o
+	ARCH_PRE_INIT	=  arm/aarch32/init.S
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch32/include
 	CFLAGS		+= -march=armv7-a
@@ -174,6 +175,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= $(OBJS_ARM_COMMON)
 	OBJS		+= arm/aarch64/arm-cpu.o
 	OBJS		+= arm/aarch64/kvm-cpu.o
+	ARCH_PRE_INIT	=  arm/aarch64/init.S
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch32/init.S b/arm/aarch32/init.S
new file mode 100644
index 0000000..c023195
--- /dev/null
+++ b/arm/aarch32/init.S
@@ -0,0 +1,44 @@
+/*
+ * #!/bin/sh
+ * mount -t 9p -o trans=virtio,version=9p2000.L hostfs /host
+ * /virt/init $*
+ */
+
+#include <asm/unistd.h>
+
+.text
+.globl _start
+_start:
+
+	mov	r7, #__NR_mount
+	ldr	r0, =.m_dev
+	ldr	r1, =.m_dir
+	ldr	r2, =.m_typ
+	mov	r3, #1			// MS_RDONLY
+	ldr	r4, =.m_opt
+	svc	#0
+
+	mov	r7, #__NR_execve
+	ldr	r0, =.e_nam		// 1st arg: filename
+	add	r1, sp, #4		// 2nd arg: argv[0]
+	str	r0, [r1]		// change argv[0]
+	ldr	r2, [sp]
+	add	r2, r2, #1		// r2 = argc + 1
+	add	r2, r1, r2, lsl #2	// 3rd arg: envp = argv[0] + argc + 1
+	svc	#0
+
+	mov	r7, #__NR_exit
+	mov	r0, #1
+	svc	#0			// panic
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
diff --git a/arm/aarch64/init.S b/arm/aarch64/init.S
new file mode 100644
index 0000000..567bf97
--- /dev/null
+++ b/arm/aarch64/init.S
@@ -0,0 +1,44 @@
+/*
+ * #!/bin/sh
+ * mount -t 9p -o trans=virtio,version=9p2000.L hostfs /host
+ * /virt/init $*
+ */
+
+#include <asm/unistd.h>
+
+.text
+.globl _start
+_start:
+
+	mov	x8, #__NR_mount
+	ldr	x0, =.m_dev
+	ldr	x1, =.m_dir
+	ldr	x2, =.m_typ
+	mov	x3, #1			// MS_RDONLY
+	ldr	x4, =.m_opt
+	svc	#0
+
+	mov	x8, #__NR_execve
+	ldr	x0, =.e_nam		// 1st arg: filename
+	add	x1, sp, #8		// 2nd arg: argv (passed through)
+	str	x0, [x1]		// change argv[0] to contain filename
+	ldr	x2, [sp]
+	add	x2, x2, #1		// x2 = argc + 1
+	add	x2, x1, x2, lsl #3	// 3rd arg: envp = argv[0] + argc + 1
+	svc	#0
+
+	mov	x8, #__NR_exit
+	mov	x0, #1
+	svc	#0			// panic
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

