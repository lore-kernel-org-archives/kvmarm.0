From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 3/3] arm/gic: move GICv2M gadget size into private
 header
Date: Wed, 25 Apr 2018 11:09:45 +0100
Message-ID: <20180425100945.19171-4-andre.przywara@arm.com>
References: <20180425100945.19171-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ADD54070F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:01:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1phGBx8cfyc7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Apr 2018 06:00:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85F174A047
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Apr 2018 06:00:43 -0400 (EDT)
In-Reply-To: <20180425100945.19171-1-andre.przywara@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The header files in arm/aarch*/include/asm/ are directly copied from
Linux, so we can't just put our own definitions in there.
Move the GICv2M MMIO frame size into a more private header, to avoid
breaking the build once the header files are synced from Linux.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch32/include/asm/kvm.h | 2 --
 arm/aarch64/include/asm/kvm.h | 2 --
 arm/include/arm-common/gic.h  | 2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
index 02206673..6ebd3e6a 100644
--- a/arm/aarch32/include/asm/kvm.h
+++ b/arm/aarch32/include/asm/kvm.h
@@ -84,8 +84,6 @@ struct kvm_regs {
 #define KVM_VGIC_V2_DIST_SIZE		0x1000
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
-#define KVM_VGIC_V2M_SIZE		0x1000
-
 /* Supported VGICv3 address types  */
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 7d14507b..c2860358 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -84,8 +84,6 @@ struct kvm_regs {
 #define KVM_VGIC_V2_DIST_SIZE		0x1000
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
-#define KVM_VGIC_V2M_SIZE		0x1000
-
 /* Supported VGICv3 address types  */
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index 687effc6..ae253c05 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -21,6 +21,8 @@
 #define GIC_MAX_CPUS			8
 #define GIC_MAX_IRQ			255
 
+#define KVM_VGIC_V2M_SIZE		0x1000
+
 enum irqchip_type {
 	IRQCHIP_GICV2,
 	IRQCHIP_GICV2M,
-- 
2.14.1
