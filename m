From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH v2 3/5] lib: arm: Use ns16550a UART when
 --vmm=kvmtool
Date: Fri,  1 Feb 2019 11:16:39 +0000
Message-ID: <20190201111641.8299-4-alexandru.elisei@arm.com>
References: <20190201111641.8299-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDBBE4A391
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:17:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eX9xWzoZZQBb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 06:16:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C0F4A39B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 06:16:58 -0500 (EST)
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

When kvm-unit-tests is configured with --vmm=kvmtool, use the address for
the ns16550a UART that kvmtool emulates. When the virtual machine manager
is QEMU, use the address for the pl011 UART, as before.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure    | 10 +++++++---
 lib/arm/io.c | 27 ++++++++++++++++++---------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/configure b/configure
index 0786e1604dba..f81352243dd8 100755
--- a/configure
+++ b/configure
@@ -114,7 +114,11 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
-    if [ "$vmm" != "qemu" ] && [ "$vmm" != "kvmtool" ]; then
+    if [ "$vmm" = "qemu" ]; then
+        arm_uart_early_addr=0x09000000
+    elif [ "$vmm" = "kvmtool" ]; then
+        arm_uart_early_addr=0x3f8
+    else
         echo '--vmm must be one of "qemu" or "kvmtool"!'
         usage
     fi
@@ -216,11 +220,11 @@ cat <<EOF > lib/config.h
  * Generated file. DO NOT MODIFY.
  *
  */
+
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
 cat <<EOF >> lib/config.h
-
-#define UART_EARLY_BASE (unsigned long)0x09000000
+#define UART_EARLY_BASE (unsigned long)${arm_uart_early_addr}
 
 EOF
 fi
diff --git a/lib/arm/io.c b/lib/arm/io.c
index 0973885d19f5..0d5ab9510ec8 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -21,32 +21,41 @@ extern void halt(int code);
 
 static struct spinlock uart_lock;
 /*
- * Use this guess for the pl011 base in order to make an attempt at
+ * Use this guess for the uart base in order to make an attempt at
  * having earlier printf support. We'll overwrite it with the real
  * base address that we read from the device tree later. This is
- * the address we expect QEMU's mach-virt machine type to put in
+ * the address we expect the virtual machine manager to put in
  * its generated device tree.
  */
 static volatile u8 *uart0_base = (u8 *)UART_EARLY_BASE;
 
 static void uart0_init(void)
 {
-	const char *compatible = "arm,pl011";
+	/*
+	 * kvm-unit-tests uses the uart only for output. Both uart models have
+	 * the TX register at offset 0 from the base address, so there is no
+	 * need to treat them separately.
+	 */
+	const char *compatible[] = {"arm,pl011", "ns16550a"};
 	struct dt_pbus_reg base;
-	int ret;
+	int i, ret;
 
 	ret = dt_get_default_console_node();
 	assert(ret >= 0 || ret == -FDT_ERR_NOTFOUND);
 
 	if (ret == -FDT_ERR_NOTFOUND) {
 
-		ret = dt_pbus_get_base_compatible(compatible, &base);
-		assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+		for (i = 0; i < ARRAY_SIZE(compatible); i++) {
+			ret = dt_pbus_get_base_compatible(compatible[i], &base);
+			assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+
+			if (ret == 0)
+				break;
+		}
 
 		if (ret) {
-			printf("%s: %s not found in the device tree, "
-				"aborting...\n",
-				__func__, compatible);
+			printf("%s: Compatible uart not found in the device tree, "
+				"aborting...\n", __func__);
 			abort();
 		}
 
-- 
2.17.0
