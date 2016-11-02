From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2] kvmtool/arm: add support for vGICv3 and vITS
Date: Wed,  2 Nov 2016 13:16:53 +0000
Message-ID: <1478092613-49128-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7FE94025C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 09:16:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XPtnuA4wdOOI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2016 09:16:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66359401D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2016 09:16:50 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

KVM/arm got support for vGICv3 and vITS recently, so make use of it.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
This patch is against its/v8 branch at [1]

[1] git://www.linux-arm.org/kvmtool.git

Changelog:

   v1 -> v2
      - move GIC defines to common place

arm/aarch32/arm-cpu.c              |    2 +-
 arm/aarch32/include/kvm/kvm-arch.h |    3 ---
 arm/aarch64/include/kvm/kvm-arch.h |    3 ---
 arm/include/arm-common/kvm-arch.h  |    2 ++
 4 files changed, 3 insertions(+), 7 deletions(-)

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
1.7.9.5
