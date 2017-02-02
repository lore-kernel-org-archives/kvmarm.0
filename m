From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 07/15] update public Linux headers for GICv3 ITS
 emulation
Date: Thu,  2 Feb 2017 16:32:15 +0000
Message-ID: <20170202163223.15372-8-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FCAC40992
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:31:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NGG8mBX-Liiw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Feb 2017 11:31:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D01A40A63
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Feb 2017 11:30:59 -0500 (EST)
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

The GICv3 ITS emulation brings some additions to the headers, so
lets update kvmtool's version of the headers to Linux' v4.10-rc6.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch32/include/asm/kvm.h | 13 +++++++++++--
 arm/aarch64/include/asm/kvm.h |  2 ++
 include/linux/kvm.h           | 31 +++++++++++++++++++++++++++----
 powerpc/include/asm/kvm.h     |  5 +++++
 x86/include/asm/kvm.h         |  6 +++---
 5 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
index df3f60c..af05f8e 100644
--- a/arm/aarch32/include/asm/kvm.h
+++ b/arm/aarch32/include/asm/kvm.h
@@ -84,6 +84,15 @@ struct kvm_regs {
 #define KVM_VGIC_V2_DIST_SIZE		0x1000
 #define KVM_VGIC_V2_CPU_SIZE		0x2000
 
+/* Supported VGICv3 address types  */
+#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
+#define KVM_VGIC_ITS_ADDR_TYPE		4
+
+#define KVM_VGIC_V3_DIST_SIZE		SZ_64K
+#define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
+
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_PSCI_0_2		1 /* CPU uses PSCI v0.2 */
 
@@ -139,8 +148,8 @@ struct kvm_arch_memory_slot {
 #define ARM_CP15_REG64(...) __ARM_CP15_REG64(__VA_ARGS__)
 
 #define KVM_REG_ARM_TIMER_CTL		ARM_CP15_REG32(0, 14, 3, 1)
-#define KVM_REG_ARM_TIMER_CNT		ARM_CP15_REG64(1, 14) 
-#define KVM_REG_ARM_TIMER_CVAL		ARM_CP15_REG64(3, 14) 
+#define KVM_REG_ARM_TIMER_CNT		ARM_CP15_REG64(1, 14)
+#define KVM_REG_ARM_TIMER_CVAL		ARM_CP15_REG64(3, 14)
 
 /* Normal registers are mapped as coprocessor 16. */
 #define KVM_REG_ARM_CORE		(0x0010 << KVM_REG_ARM_COPROC_SHIFT)
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
index a7f1f80..cac48ed 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -651,6 +651,9 @@ struct kvm_enable_cap {
 };
 
 /* for KVM_PPC_GET_PVINFO */
+
+#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+
 struct kvm_ppc_pvinfo {
 	/* out */
 	__u32 flags;
@@ -682,8 +685,6 @@ struct kvm_ppc_smmu_info {
 	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
 };
 
-#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
-
 #define KVMIO 0xAE
 
 /* machine type bits, to be used as argument to KVM_CREATE_VM */
@@ -865,6 +866,11 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_SPAPR_TCE_64 125
 #define KVM_CAP_ARM_PMU_V3 126
 #define KVM_CAP_VCPU_ATTRIBUTES 127
+#define KVM_CAP_MAX_VCPU_ID 128
+#define KVM_CAP_X2APIC_API 129
+#define KVM_CAP_S390_USER_INSTR0 130
+#define KVM_CAP_MSI_DEVID 131
+#define KVM_CAP_PPC_HTM 132
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -877,7 +883,10 @@ struct kvm_irq_routing_msi {
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
@@ -964,12 +973,19 @@ struct kvm_irqfd {
 	__u8  pad[16];
 };
 
+/* For KVM_CAP_ADJUST_CLOCK */
+
+/* Do not use 1, KVM_CHECK_EXTENSION returned it before we had flags.  */
+#define KVM_CLOCK_TSC_STABLE		2
+
 struct kvm_clock_data {
 	__u64 clock;
 	__u32 flags;
 	__u32 pad[9];
 };
 
+/* For KVM_CAP_SW_TLB */
+
 #define KVM_MMU_FSL_BOOKE_NOHV		0
 #define KVM_MMU_FSL_BOOKE_HV		1
 
@@ -1023,12 +1039,14 @@ struct kvm_one_reg {
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
@@ -1073,6 +1091,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
 	KVM_DEV_TYPE_ARM_VGIC_V3,
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
+	KVM_DEV_TYPE_ARM_VGIC_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1312,4 +1332,7 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
 
+#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index c93cf35..3603b6f 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -573,6 +573,10 @@ struct kvm_get_htab_header {
 #define KVM_REG_PPC_SPRG9	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xba)
 #define KVM_REG_PPC_DBSR	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbb)
 
+/* POWER9 registers */
+#define KVM_REG_PPC_TIDR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbc)
+#define KVM_REG_PPC_PSSCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbd)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
@@ -596,6 +600,7 @@ struct kvm_get_htab_header {
 #define KVM_REG_PPC_TM_VSCR	(KVM_REG_PPC_TM | KVM_REG_SIZE_U32 | 0x67)
 #define KVM_REG_PPC_TM_DSCR	(KVM_REG_PPC_TM | KVM_REG_SIZE_U64 | 0x68)
 #define KVM_REG_PPC_TM_TAR	(KVM_REG_PPC_TM | KVM_REG_SIZE_U64 | 0x69)
+#define KVM_REG_PPC_TM_XER	(KVM_REG_PPC_TM | KVM_REG_SIZE_U64 | 0x6a)
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
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
