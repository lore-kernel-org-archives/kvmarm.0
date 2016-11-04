From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 01/16] FDT: introduce global phandle allocation
Date: Fri,  4 Nov 2016 17:31:48 +0000
Message-ID: <20161104173203.21168-2-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 505194041A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LKY74n+MKRGd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA7A40416
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:23 -0400 (EDT)
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Allocating an FDT phandle (a unique identifier) using a static
variable in a static inline function defined in a header file works
only if all users are in the same source file. So trying to allocate
a handle from two different compilation units fails.
Introduce global phandle allocation and reference code to properly
allocate unique phandles.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Makefile          |  1 +
 arm/fdt.c         |  2 +-
 arm/gic.c         |  2 +-
 include/kvm/fdt.h | 10 +++++-----
 kvm-fdt.c         | 26 ++++++++++++++++++++++++++
 5 files changed, 34 insertions(+), 7 deletions(-)
 create mode 100644 kvm-fdt.c

diff --git a/Makefile b/Makefile
index 1f0196f..e4a4002 100644
--- a/Makefile
+++ b/Makefile
@@ -98,6 +98,7 @@ OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
 OBJS	+= hw/i8042.o
+OBJS	+= kvm-fdt.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
diff --git a/arm/fdt.c b/arm/fdt.c
index 381d48f..8bcfffb 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -114,7 +114,7 @@ static int setup_fdt(struct kvm *kvm)
 {
 	struct device_header *dev_hdr;
 	u8 staging_fdt[FDT_MAX_SIZE];
-	u32 gic_phandle		= fdt__alloc_phandle();
+	u32 gic_phandle		= fdt__get_phandle(PHANDLE_GIC);
 	u64 mem_reg_prop[]	= {
 		cpu_to_fdt64(kvm->arch.memory_guest_start),
 		cpu_to_fdt64(kvm->ram_size),
diff --git a/arm/gic.c b/arm/gic.c
index d6d6dd0..b60437e 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -222,7 +222,7 @@ void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
 	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
-	_FDT(fdt_property_cell(fdt, "phandle", phandle));
+	_FDT(fdt_property_cell(fdt, "phandle", fdt__get_phandle(PHANDLE_GIC)));
 	_FDT(fdt_end_node(fdt));
 }
 
diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
index 53d85a4..cd2bb72 100644
--- a/include/kvm/fdt.h
+++ b/include/kvm/fdt.h
@@ -8,6 +8,10 @@
 #include <linux/types.h>
 
 #define FDT_MAX_SIZE	0x10000
+#define FDT_INVALID_PHANDLE 0
+#define FDT_IS_VALID_PHANDLE(phandle) ((phandle) != FDT_INVALID_PHANDLE)
+
+enum phandles {PHANDLE_GIC, PHANDLES_MAX};
 
 /* Those definitions are generic FDT values for specifying IRQ
  * types and are used in the Linux kernel internally as well as in
@@ -33,10 +37,6 @@ enum irq_type {
 		}							\
 	} while (0)
 
-static inline u32 fdt__alloc_phandle(void)
-{
-	static u32 phandle = 0;
-	return ++phandle;
-}
+u32 fdt__get_phandle(enum phandles phandle);
 
 #endif /* KVM__FDT_H */
diff --git a/kvm-fdt.c b/kvm-fdt.c
new file mode 100644
index 0000000..d05f3fe
--- /dev/null
+++ b/kvm-fdt.c
@@ -0,0 +1,26 @@
+/*
+ * Commonly used FDT functions.
+ */
+
+#include <stdio.h>
+#include "kvm/fdt.h"
+#include "kvm/util.h"
+
+u32 phandles[PHANDLES_MAX] = {};
+u32 next_phandle = 1;
+
+u32 fdt__get_phandle(enum phandles phandle)
+{
+	u32 ret;
+
+	if (phandle >= PHANDLES_MAX)
+		return FDT_INVALID_PHANDLE;
+
+	ret = phandles[phandle];
+	if (ret == FDT_INVALID_PHANDLE) {
+		ret = next_phandle++;
+		phandles[phandle] = ret;
+	}
+
+	return ret;
+}
-- 
2.9.0
