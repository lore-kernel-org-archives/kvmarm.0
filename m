From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 01/15] FDT: use static phandles
Date: Thu,  2 Feb 2017 16:32:09 +0000
Message-ID: <20170202163223.15372-2-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0908840992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:30:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BStOw2Q68zDi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 11:30:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C1E40969
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:30:52 -0500 (EST)
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The current implementation of fdt__alloc_phandle() suffers from being
implemented in a static inline function situated in a header file.
This will only create expected results within a single compilation
unit.
It seems a bit over the top to use a function to allocate phandles,
when at the end of the day a phandle is just a unique identifier.
To simplify things - especially with upcoming patches - we just
introduce an enum per architecture to hold all possible phandle sources
and use that instead of the dynamic allocation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch32/include/kvm/fdt-arch.h | 6 ++++++
 arm/aarch64/include/kvm/fdt-arch.h | 6 ++++++
 arm/fdt.c                          | 7 +++----
 arm/include/arm-common/fdt-arch.h  | 6 ++++++
 include/kvm/fdt.h                  | 8 ++------
 mips/include/kvm/fdt-arch.h        | 6 ++++++
 powerpc/include/kvm/fdt-arch.h     | 6 ++++++
 powerpc/kvm.c                      | 2 --
 x86/include/kvm/fdt-arch.h         | 6 ++++++
 9 files changed, 41 insertions(+), 12 deletions(-)
 create mode 100644 arm/aarch32/include/kvm/fdt-arch.h
 create mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 create mode 100644 arm/include/arm-common/fdt-arch.h
 create mode 100644 mips/include/kvm/fdt-arch.h
 create mode 100644 powerpc/include/kvm/fdt-arch.h
 create mode 100644 x86/include/kvm/fdt-arch.h

diff --git a/arm/aarch32/include/kvm/fdt-arch.h b/arm/aarch32/include/kvm/fdt-arch.h
new file mode 100644
index 0000000..e448bf1
--- /dev/null
+++ b/arm/aarch32/include/kvm/fdt-arch.h
@@ -0,0 +1,6 @@
+#ifndef KVM__KVM_FDT_H
+#define KVM__KVM_FDT_H
+
+#include "arm-common/fdt-arch.h"
+
+#endif /* KVM__KVM_FDT_H */
diff --git a/arm/aarch64/include/kvm/fdt-arch.h b/arm/aarch64/include/kvm/fdt-arch.h
new file mode 100644
index 0000000..e448bf1
--- /dev/null
+++ b/arm/aarch64/include/kvm/fdt-arch.h
@@ -0,0 +1,6 @@
+#ifndef KVM__KVM_FDT_H
+#define KVM__KVM_FDT_H
+
+#include "arm-common/fdt-arch.h"
+
+#endif /* KVM__KVM_FDT_H */
diff --git a/arm/fdt.c b/arm/fdt.c
index 381d48f..bcd0c3a 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -114,7 +114,6 @@ static int setup_fdt(struct kvm *kvm)
 {
 	struct device_header *dev_hdr;
 	u8 staging_fdt[FDT_MAX_SIZE];
-	u32 gic_phandle		= fdt__alloc_phandle();
 	u64 mem_reg_prop[]	= {
 		cpu_to_fdt64(kvm->arch.memory_guest_start),
 		cpu_to_fdt64(kvm->ram_size),
@@ -134,7 +133,7 @@ static int setup_fdt(struct kvm *kvm)
 
 	/* Header */
 	_FDT(fdt_begin_node(fdt, ""));
-	_FDT(fdt_property_cell(fdt, "interrupt-parent", gic_phandle));
+	_FDT(fdt_property_cell(fdt, "interrupt-parent", PHANDLE_GIC));
 	_FDT(fdt_property_string(fdt, "compatible", "linux,dummy-virt"));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 0x2));
 	_FDT(fdt_property_cell(fdt, "#size-cells", 0x2));
@@ -166,7 +165,7 @@ static int setup_fdt(struct kvm *kvm)
 	/* CPU and peripherals (interrupt controller, timers, etc) */
 	generate_cpu_nodes(fdt, kvm);
 	if (generate_cpu_peripheral_fdt_nodes)
-		generate_cpu_peripheral_fdt_nodes(fdt, kvm, gic_phandle);
+		generate_cpu_peripheral_fdt_nodes(fdt, kvm, PHANDLE_GIC);
 
 	/* Virtio MMIO devices */
 	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
@@ -185,7 +184,7 @@ static int setup_fdt(struct kvm *kvm)
 	}
 
 	/* PCI host controller */
-	pci__generate_fdt_nodes(fdt, gic_phandle);
+	pci__generate_fdt_nodes(fdt, PHANDLE_GIC);
 
 	/* PSCI firmware */
 	_FDT(fdt_begin_node(fdt, "psci"));
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/arm-common/fdt-arch.h
new file mode 100644
index 0000000..53ba633
--- /dev/null
+++ b/arm/include/arm-common/fdt-arch.h
@@ -0,0 +1,6 @@
+#ifndef ARM__FDT_H
+#define ARM__FDT_H
+
+enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLES_MAX};
+
+#endif /* ARM__FDT_H */
diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
index 53d85a4..beadc7f 100644
--- a/include/kvm/fdt.h
+++ b/include/kvm/fdt.h
@@ -7,6 +7,8 @@
 
 #include <linux/types.h>
 
+#include "kvm/fdt-arch.h"
+
 #define FDT_MAX_SIZE	0x10000
 
 /* Those definitions are generic FDT values for specifying IRQ
@@ -33,10 +35,4 @@ enum irq_type {
 		}							\
 	} while (0)
 
-static inline u32 fdt__alloc_phandle(void)
-{
-	static u32 phandle = 0;
-	return ++phandle;
-}
-
 #endif /* KVM__FDT_H */
diff --git a/mips/include/kvm/fdt-arch.h b/mips/include/kvm/fdt-arch.h
new file mode 100644
index 0000000..b030245
--- /dev/null
+++ b/mips/include/kvm/fdt-arch.h
@@ -0,0 +1,6 @@
+#ifndef KVM__KVM_FDT_H
+#define KVM__KVM_FDT_H
+
+enum phandles {PHANDLE_RESERVED = 0, PHANDLES_MAX};
+
+#endif /* KVM__KVM_FDT_H */
diff --git a/powerpc/include/kvm/fdt-arch.h b/powerpc/include/kvm/fdt-arch.h
new file mode 100644
index 0000000..d48c055
--- /dev/null
+++ b/powerpc/include/kvm/fdt-arch.h
@@ -0,0 +1,6 @@
+#ifndef KVM__KVM_FDT_H
+#define KVM__KVM_FDT_H
+
+enum phandles {PHANDLE_RESERVED = 0, PHANDLE_XICP, PHANDLES_MAX};
+
+#endif /* KVM__KVM_FDT_H */
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 3c1596d..c738c1d 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -40,8 +40,6 @@
 
 #define HUGETLBFS_PATH "/var/lib/hugetlbfs/global/pagesize-16MB/"
 
-#define PHANDLE_XICP		0x00001111
-
 static char kern_cmdline[2048];
 
 struct kvm_ext kvm_req_ext[] = {
diff --git a/x86/include/kvm/fdt-arch.h b/x86/include/kvm/fdt-arch.h
new file mode 100644
index 0000000..eebd73f
--- /dev/null
+++ b/x86/include/kvm/fdt-arch.h
@@ -0,0 +1,6 @@
+#ifndef X86__FDT_ARCH_H
+#define X86__FDT_ARCH_H
+
+enum phandles {PHANDLE_RESERVED = 0, PHANDLES_MAX};
+
+#endif /* KVM__KVM_FDT_H */
-- 
2.9.0
