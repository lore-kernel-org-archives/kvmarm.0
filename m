From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 07/15] TEMPORARY: update public headers for GICv3 ITS emulation
Date: Wed, 20 Jul 2016 18:04:27 +0100
Message-ID: <20160720170435.28090-8-andre.przywara@arm.com>
References: <20160720170435.28090-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160720170435.28090-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch is preliminary and updates the headers from a kernel with
ITS emulation and ARM GSI routing support. It should be replaced by a
proper header update once the kernel patches have been merged and all
merge conflict have been sorted out.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch64/include/asm/kvm.h |  2 ++
 include/linux/kvm.h           | 13 +++++++++++--
 x86/include/asm/kvm.h         |  6 +++---
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index f209ea1..3051f86 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -87,9 +87,11 @@ struct kvm_regs {
 /* Supported VGICv3 address types  */
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+#define KVM_VGIC_ITS_ADDR_TYPE		4
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a7f1f80..91226f4 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -865,6 +865,8 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_SPAPR_TCE_64 125
 #define KVM_CAP_ARM_PMU_V3 126
 #define KVM_CAP_VCPU_ATTRIBUTES 127
+#define KVM_CAP_MAX_VCPU_ID 128
+#define KVM_CAP_MSI_DEVID 131
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -877,7 +879,10 @@ struct kvm_irq_routing_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 devid;
+	};
 };
 
 struct kvm_irq_routing_s390_adapter {
@@ -1023,12 +1028,14 @@ struct kvm_one_reg {
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
@@ -1073,6 +1080,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
 	KVM_DEV_TYPE_ARM_VGIC_V3,
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
+	KVM_DEV_TYPE_ARM_VGIC_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index cd54147..739c0c5 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -216,9 +216,9 @@ struct kvm_cpuid_entry2 {
 	__u32 padding[3];
 };
 
-#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
-#define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
-#define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
+#define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		(1 << 0)
+#define KVM_CPUID_FLAG_STATEFUL_FUNC		(1 << 1)
+#define KVM_CPUID_FLAG_STATE_READ_NEXT		(1 << 2)
 
 /* for KVM_SET_CPUID2 */
 struct kvm_cpuid2 {
-- 
2.9.0

