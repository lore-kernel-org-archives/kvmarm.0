From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v10 08/15] arm: allow vGICv3 emulation
Date: Tue, 25 Apr 2017 15:39:25 +0100
Message-ID: <20170425143932.17235-9-andre.przywara@arm.com>
References: <20170425143932.17235-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A3B940D38
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JwQMcvErMHiJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 10:34:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF33E40CD4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:46 -0400 (EDT)
In-Reply-To: <20170425143932.17235-1-andre.przywara@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
