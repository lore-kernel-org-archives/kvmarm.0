From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v10 07/15] update public Linux headers for GICv3 ITS
 emulation
Date: Tue, 25 Apr 2017 15:39:24 +0100
Message-ID: <20170425143932.17235-8-andre.przywara@arm.com>
References: <20170425143932.17235-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D977A40CC6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Dz38IbTBtB9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 10:34:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7B540D88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:45 -0400 (EDT)
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

The GICv3 ITS emulation brings some additions to the headers, so
lets update kvmtool's version of the headers to Linux' v4.11-rc7-57.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch32/include/asm/kvm.h | 26 ++++++++++++++++++++--
 arm/aarch64/include/asm/kvm.h | 15 +++++++++++++
 include/linux/kvm.h           | 50 +++++++++++++++++++++++++++++++++++++++----
 mips/include/asm/kvm.h        |  2 ++
 powerpc/include/asm/kvm.h     | 27 +++++++++++++++++++++++
 x86/include/asm/kvm.h         |  6 +++---
 6 files changed, 117 insertions(+), 9 deletions(-)

diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
index df3f60c..6ebd3e6 100644
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
@@ -172,10 +181,23 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
 #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
 #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
+#define   KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT 32
+#define   KVM_DEV_ARM_VGIC_V3_MPIDR_MASK \
+			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
+#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
+#define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
+#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
+			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
+#define VGIC_LEVEL_INFO_LINE_LEVEL	0
+
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
 
 /* KVM_IRQ_LINE irq field index values */
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index f209ea1..c286035 100644
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
@@ -199,10 +201,23 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
 #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
 #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
+#define   KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT 32
+#define   KVM_DEV_ARM_VGIC_V3_MPIDR_MASK \
+			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
+#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
+#define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
+#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
+			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
+#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
+#define VGIC_LEVEL_INFO_LINE_LEVEL	0
+
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
 /* Device Control API on vcpu fd */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index a7f1f80..f51d508 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -218,7 +218,8 @@ struct kvm_hyperv_exit {
 struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
-	__u8 padding1[7];
+	__u8 immediate_exit;
+	__u8 padding1[6];
 
 	/* out */
 	__u32 exit_reason;
@@ -651,6 +652,9 @@ struct kvm_enable_cap {
 };
 
 /* for KVM_PPC_GET_PVINFO */
+
+#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+
 struct kvm_ppc_pvinfo {
 	/* out */
 	__u32 flags;
@@ -682,7 +686,12 @@ struct kvm_ppc_smmu_info {
 	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
 };
 
-#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
+struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+};
 
 #define KVMIO 0xAE
 
@@ -865,6 +874,15 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_SPAPR_TCE_64 125
 #define KVM_CAP_ARM_PMU_V3 126
 #define KVM_CAP_VCPU_ATTRIBUTES 127
+#define KVM_CAP_MAX_VCPU_ID 128
+#define KVM_CAP_X2APIC_API 129
+#define KVM_CAP_S390_USER_INSTR0 130
+#define KVM_CAP_MSI_DEVID 131
+#define KVM_CAP_PPC_HTM 132
+#define KVM_CAP_SPAPR_RESIZE_HPT 133
+#define KVM_CAP_PPC_MMU_RADIX 134
+#define KVM_CAP_PPC_MMU_HASH_V3 135
+#define KVM_CAP_IMMEDIATE_EXIT 136
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -877,7 +895,10 @@ struct kvm_irq_routing_msi {
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
@@ -964,12 +985,19 @@ struct kvm_irqfd {
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
 
@@ -1023,12 +1051,14 @@ struct kvm_one_reg {
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
@@ -1073,6 +1103,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
 	KVM_DEV_TYPE_ARM_VGIC_V3,
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
+	KVM_DEV_TYPE_ARM_VGIC_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1167,6 +1199,13 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_SET_DEVICE_ADDR	  _IOW(KVMIO,  0xab, struct kvm_arm_device_addr)
 /* Available with KVM_CAP_PPC_RTAS */
 #define KVM_PPC_RTAS_DEFINE_TOKEN _IOW(KVMIO,  0xac, struct kvm_rtas_token_args)
+/* Available with KVM_CAP_SPAPR_RESIZE_HPT */
+#define KVM_PPC_RESIZE_HPT_PREPARE _IOR(KVMIO, 0xad, struct kvm_ppc_resize_hpt)
+#define KVM_PPC_RESIZE_HPT_COMMIT  _IOR(KVMIO, 0xae, struct kvm_ppc_resize_hpt)
+/* Available with KVM_CAP_PPC_RADIX_MMU or KVM_CAP_PPC_HASH_MMU_V3 */
+#define KVM_PPC_CONFIGURE_V3_MMU  _IOW(KVMIO,  0xaf, struct kvm_ppc_mmuv3_cfg)
+/* Available with KVM_CAP_PPC_RADIX_MMU */
+#define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1312,4 +1351,7 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
 
+#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/mips/include/asm/kvm.h b/mips/include/asm/kvm.h
index 6985eb5..a8a0199 100644
--- a/mips/include/asm/kvm.h
+++ b/mips/include/asm/kvm.h
@@ -19,6 +19,8 @@
  * Some parts derived from the x86 version of this file.
  */
 
+#define __KVM_HAVE_READONLY_MEM
+
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  *
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index c93cf35..4edbe4b 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -413,6 +413,26 @@ struct kvm_get_htab_header {
 	__u16	n_invalid;
 };
 
+/* For KVM_PPC_CONFIGURE_V3_MMU */
+struct kvm_ppc_mmuv3_cfg {
+	__u64	flags;
+	__u64	process_table;	/* second doubleword of partition table entry */
+};
+
+/* Flag values for KVM_PPC_CONFIGURE_V3_MMU */
+#define KVM_PPC_MMUV3_RADIX	1	/* 1 = radix mode, 0 = HPT */
+#define KVM_PPC_MMUV3_GTSE	2	/* global translation shootdown enb. */
+
+/* For KVM_PPC_GET_RMMU_INFO */
+struct kvm_ppc_rmmu_info {
+	struct kvm_ppc_radix_geom {
+		__u8	page_shift;
+		__u8	level_bits[4];
+		__u8	pad[3];
+	}	geometries[8];
+	__u32	ap_encodings[8];
+};
+
 /* Per-vcpu XICS interrupt controller state */
 #define KVM_REG_PPC_ICP_STATE	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x8c)
 
@@ -573,6 +593,10 @@ struct kvm_get_htab_header {
 #define KVM_REG_PPC_SPRG9	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xba)
 #define KVM_REG_PPC_DBSR	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbb)
 
+/* POWER9 registers */
+#define KVM_REG_PPC_TIDR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbc)
+#define KVM_REG_PPC_PSSCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbd)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
@@ -596,6 +620,7 @@ struct kvm_get_htab_header {
 #define KVM_REG_PPC_TM_VSCR	(KVM_REG_PPC_TM | KVM_REG_SIZE_U32 | 0x67)
 #define KVM_REG_PPC_TM_DSCR	(KVM_REG_PPC_TM | KVM_REG_SIZE_U64 | 0x68)
 #define KVM_REG_PPC_TM_TAR	(KVM_REG_PPC_TM | KVM_REG_SIZE_U64 | 0x69)
+#define KVM_REG_PPC_TM_XER	(KVM_REG_PPC_TM | KVM_REG_SIZE_U64 | 0x6a)
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
@@ -608,5 +633,7 @@ struct kvm_get_htab_header {
 #define  KVM_XICS_LEVEL_SENSITIVE	(1ULL << 40)
 #define  KVM_XICS_MASKED		(1ULL << 41)
 #define  KVM_XICS_PENDING		(1ULL << 42)
+#define  KVM_XICS_PRESENTED		(1ULL << 43)
+#define  KVM_XICS_QUEUED		(1ULL << 44)
 
 #endif /* __LINUX_KVM_POWERPC_H */
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
