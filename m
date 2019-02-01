From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH v2 1/5] lib: arm: Use UART address from
 generated config.h
Date: Fri,  1 Feb 2019 11:16:37 +0000
Message-ID: <20190201111641.8299-2-alexandru.elisei@arm.com>
References: <20190201111641.8299-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8C324A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:16:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cpXf2Ki9pmLk for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 06:16:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EDFA4A39B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:16:55 -0500 (EST)
In-Reply-To: <20190201111641.8299-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Generate lib/config.h when configuring kvm-unit-tests. The file is empty
for all architectures except for arm and arm64, where it is used to store
the UART base address. This removes the hardcoded address from lib/arm/io.c
and provides a mechanism for using different UART addresses in the future.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure    | 17 +++++++++++++++++
 Makefile     |  2 +-
 lib/arm/io.c |  5 ++---
 .gitignore   |  1 +
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/configure b/configure
index df8581e3a906..44708b026422 100755
--- a/configure
+++ b/configure
@@ -198,3 +198,20 @@ ENVIRON_DEFAULT=$environ_default
 ERRATATXT=errata.txt
 U32_LONG_FMT=$u32_long
 EOF
+
+cat <<EOF > lib/config.h
+#ifndef CONFIG_H
+#define CONFIG_H 1
+/*
+ * Generated file. DO NOT MODIFY.
+ *
+ */
+EOF
+if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
+cat <<EOF >> lib/config.h
+
+#define UART_EARLY_BASE (unsigned long)0x09000000
+
+EOF
+fi
+echo "#endif" >> lib/config.h
diff --git a/Makefile b/Makefile
index e9f02272e156..643af05678ad 100644
--- a/Makefile
+++ b/Makefile
@@ -115,7 +115,7 @@ libfdt_clean:
 	$(LIBFDT_objdir)/.*.d
 
 distclean: clean libfdt_clean
-	$(RM) lib/asm config.mak $(TEST_DIR)-run msr.out cscope.* build-head
+	$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.* build-head
 	$(RM) -r tests logs logs.old
 
 cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/asm-generic
diff --git a/lib/arm/io.c b/lib/arm/io.c
index d2c1a07c19ee..0973885d19f5 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -11,6 +11,7 @@
 #include <libcflat.h>
 #include <devicetree.h>
 #include <chr-testdev.h>
+#include <config.h>
 #include <asm/spinlock.h>
 #include <asm/io.h>
 
@@ -18,6 +19,7 @@
 
 extern void halt(int code);
 
+static struct spinlock uart_lock;
 /*
  * Use this guess for the pl011 base in order to make an attempt at
  * having earlier printf support. We'll overwrite it with the real
@@ -25,9 +27,6 @@ extern void halt(int code);
  * the address we expect QEMU's mach-virt machine type to put in
  * its generated device tree.
  */
-#define UART_EARLY_BASE 0x09000000UL
-
-static struct spinlock uart_lock;
 static volatile u8 *uart0_base = (u8 *)UART_EARLY_BASE;
 
 static void uart0_init(void)
diff --git a/.gitignore b/.gitignore
index 2405a8087ae5..483f7c7a09ea 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,6 +10,7 @@ patches
 cscope.*
 *.swp
 /lib/asm
+/lib/config.h
 /config.mak
 /*-run
 /msr.out
-- 
2.17.0
