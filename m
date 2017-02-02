From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 08/15] arm: allow vGICv3 emulation
Date: Thu,  2 Feb 2017 16:32:16 +0000
Message-ID: <20170202163223.15372-9-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

KVM/arm recently got support for vGICv3 (and vITS), which is evident
in the updated header file. So as now ARM has feature parity when it
comes to the GIC emulation, we can remove the special defines we had
in place to allow compilation for ARM(32).
For simplicity we now use 64K sized GIC regions everywhere, as GICv3
mandates them.
[Andre: some update, reword commit message]

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch32/arm-cpu.c              | 2 +-
 arm/aarch32/include/kvm/kvm-arch.h | 3 ---
 arm/aarch64/include/kvm/kvm-arch.h | 3 ---
 arm/gic.c                          | 9 ---------
 arm/include/arm-common/kvm-arch.h  | 2 ++
 5 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
index 27a8e17..16bba55 100644
--- a/arm/aarch32/arm-cpu.c
+++ b/arm/aarch32/arm-cpu.c
@@ -12,7 +12,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
 
-	gic__generate_fdt_nodes(fdt, IRQCHIP_GICV2);
+	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 }
 
diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index 1632e3c..cd31e72 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -1,9 +1,6 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
-#define ARM_GIC_DIST_SIZE	0x1000
-#define ARM_GIC_CPUI_SIZE	0x2000
-
 #define ARM_KERN_OFFSET(...)	0x8000
 
 #define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 4925736..9de623a 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -1,9 +1,6 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
-#define ARM_GIC_DIST_SIZE	0x10000
-#define ARM_GIC_CPUI_SIZE	0x20000
-
 #define ARM_KERN_OFFSET(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
 				0x8000				:	\
 				0x80000)
diff --git a/arm/gic.c b/arm/gic.c
index ff032d2..8479b89 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -9,15 +9,6 @@
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 
-/* Those names are not defined for ARM (yet) */
-#ifndef KVM_VGIC_V3_ADDR_TYPE_DIST
-#define KVM_VGIC_V3_ADDR_TYPE_DIST 2
-#endif
-
-#ifndef KVM_VGIC_V3_ADDR_TYPE_REDIST
-#define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
-#endif
-
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 0f5fb7f..c83c45f 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -18,6 +18,8 @@
 #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
 #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
 #define ARM_GIC_SIZE		(ARM_GIC_DIST_SIZE + ARM_GIC_CPUI_SIZE)
+#define ARM_GIC_DIST_SIZE	0x10000
+#define ARM_GIC_CPUI_SIZE	0x20000
 
 #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
 #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
-- 
2.9.0
