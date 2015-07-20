From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 06/14] TEMPORARY: arm: update public headers for GICv3 ITS emulation
Date: Mon, 20 Jul 2015 14:02:08 +0100
Message-ID: <1437397336-21385-7-git-send-email-andre.przywara@arm.com>
References: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437397336-21385-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger@linaro.org, Pavel Fedin <p.fedin@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch is preliminary and updates the headers from a kernel with
ITS emulation support. It should be replaced by a proper header
update once ITS support is upstream.
Contains a "hack" to support compiling on ARM, too.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch64/include/asm/kvm.h | 3 +++
 arm/gic.c                     | 4 ++++
 include/linux/kvm.h           | 6 +++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index d268320..e42435c 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -82,8 +82,11 @@ struct kvm_regs {
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
 
+#define KVM_VGIC_V3_ADDR_TYPE_ITS	4
+
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/arm/gic.c b/arm/gic.c
index 2c1a547..93a8a1d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -18,6 +18,10 @@
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
 #endif
 
+#ifndef KVM_VGIC_V3_ADDR_TYPE_ITS
+#define KVM_VGIC_V3_ADDR_TYPE_ITS 4
+#endif
+
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 4b60056..39428d1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -815,6 +815,8 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_IRQ_STATE 114
 #define KVM_CAP_PPC_HWRNG 115
 
+#define KVM_CAP_MSI_DEVID 119
+
 #ifdef KVM_CAP_IRQ_ROUTING
 
 struct kvm_irq_routing_irqchip {
@@ -965,12 +967,14 @@ struct kvm_one_reg {
 	__u64 addr;
 };
 
+#define KVM_MSI_VALID_DEVID	(1U << 0)
 struct kvm_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
 	__u32 flags;
-	__u8  pad[16];
+	__u32 devid;
+	__u8  pad[12];
 };
 
 struct kvm_arm_device_addr {
-- 
2.3.5

