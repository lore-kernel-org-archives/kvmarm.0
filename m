From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 04/14] FDT: introduce global phandle allocation
Date: Mon, 20 Jul 2015 14:02:06 +0100
Message-ID: <1437397336-21385-5-git-send-email-andre.przywara@arm.com>
References: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
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
index a9c13d7..363129d 100644
--- a/Makefile
+++ b/Makefile
@@ -100,6 +100,7 @@ OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
 OBJS	+= hw/i8042.o
+OBJS	+= kvm-fdt.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
diff --git a/arm/fdt.c b/arm/fdt.c
index 3657108..4b68a97 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -117,7 +117,7 @@ static int setup_fdt(struct kvm *kvm)
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
2.3.5

