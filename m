From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v5 21/18] kvmtool: arm64: Switch memory layout
Date: Mon, 17 Sep 2018 11:41:43 +0100
Message-ID: <20180917104144.19188-22-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BACFF4A211
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:43:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qNPCcj6CWtTi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Sep 2018 06:43:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 844174A205
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Sep 2018 06:43:21 -0400 (EDT)
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, dave.martin@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If the guest wants to use a larger physical address space place
the RAM at upper half of the address space. Otherwise, it uses the
default layout.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch32/include/kvm/kvm-arch.h |  6 ++++--
 arm/aarch64/include/kvm/kvm-arch.h | 15 ++++++++++++---
 arm/include/arm-common/kvm-arch.h  | 11 ++++++-----
 arm/kvm.c                          |  2 +-
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index cd31e72..bcd382b 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -3,8 +3,10 @@
 
 #define ARM_KERN_OFFSET(...)	0x8000
 
-#define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
-
 #include "arm-common/kvm-arch.h"
 
+#define ARM_MAX_MEMORY(...)	ARM32_MAX_MEMORY
+#define ARM_MEMORY_AREA(...)	ARM32_MEMORY_AREA
+
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 9de623a..bad35b9 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -1,14 +1,23 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
+#include "arm-common/kvm-arch.h"
+
+#define ARM64_MEMORY_AREA(phys_shift)	(1UL << (phys_shift - 1))
+#define ARM64_MAX_MEMORY(phys_shift)	\
+	((1ULL << (phys_shift)) - ARM64_MEMORY_AREA(phys_shift))
+
+#define ARM_MEMORY_AREA(kvm)	((kvm)->cfg.arch.aarch32_guest ?	\
+				 ARM32_MEMORY_AREA		:	\
+				 ARM64_MEMORY_AREA(kvm->cfg.arch.phys_shift))
+
 #define ARM_KERN_OFFSET(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
 				0x8000				:	\
 				0x80000)
 
 #define ARM_MAX_MEMORY(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
-				ARM_LOMAP_MAX_MEMORY		:	\
-				ARM_HIMAP_MAX_MEMORY)
+				ARM32_MAX_MEMORY		:	\
+				ARM64_MAX_MEMORY(kvm->cfg.arch.phys_shift))
 
-#include "arm-common/kvm-arch.h"
 
 #endif /* KVM__KVM_ARCH_H */
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b9d486d..b29b4b1 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -6,14 +6,15 @@
 #include <linux/types.h>
 
 #include "arm-common/gic.h"
-
 #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
 #define ARM_MMIO_AREA		_AC(0x0000000000010000, UL)
 #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
-#define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
 
-#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
-#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
+#define ARM32_MEMORY_AREA	_AC(0x0000000080000000, UL)
+#define ARM32_MAX_MEMORY	((1ULL << 32) - ARM32_MEMORY_AREA)
+
+#define ARM_IOMEM_AREA_END	ARM32_MEMORY_AREA
+
 
 #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
 #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
@@ -24,7 +25,7 @@
 #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
 #define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
 #define ARM_PCI_CFG_SIZE	(1ULL << 24)
-#define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
+#define ARM_PCI_MMIO_SIZE	(ARM_IOMEM_AREA_END - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
 
 #define KVM_IOPORT_AREA		ARM_IOPORT_AREA
diff --git a/arm/kvm.c b/arm/kvm.c
index b824f63..eac2ad2 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -30,7 +30,7 @@ void kvm__init_ram(struct kvm *kvm)
 	u64 phys_start, phys_size;
 	void *host_mem;
 
-	phys_start	= ARM_MEMORY_AREA;
+	phys_start	= ARM_MEMORY_AREA(kvm);
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
-- 
2.19.0
