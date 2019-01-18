From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 02/12] update_headers: Sync kvm UAPI headers with linux
 v5.0-rc2
Date: Fri, 18 Jan 2019 16:14:11 +0000
Message-ID: <1547828061-20462-3-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 253874A3B5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qBgu03eBJgBC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C61B4A3AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:19 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The local copies of the kvm user API headers are getting stale.

In preparation for some arch-specific updated, this patch reflects
a re-run of util/update_headers.sh to pull in upstream updates from
linux v5.0-rc2.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch32/include/asm/kvm.h |  55 +++++++++-
 arm/aarch64/include/asm/kvm.h |  41 ++++++-
 include/linux/kvm.h           | 248 +++++++++++++++++++++++++++++++++++++++++-
 mips/include/asm/kvm.h        |  23 +++-
 powerpc/include/asm/kvm.h     |  39 +++++++
 x86/include/asm/kvm.h         |  69 +++++++++++-
 6 files changed, 461 insertions(+), 14 deletions(-)

diff --git a/arm/aarch32/include/asm/kvm.h b/arm/aarch32/include/asm/kvm.h
index 6ebd3e6..4602464 100644
--- a/arm/aarch32/include/asm/kvm.h
+++ b/arm/aarch32/include/asm/kvm.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * Copyright (C) 2012 - Virtual Open Systems and Columbia University
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
@@ -26,6 +27,9 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_VCPU_EVENTS
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
@@ -88,6 +92,7 @@ struct kvm_regs {
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
 #define KVM_VGIC_ITS_ADDR_TYPE		4
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
@@ -114,11 +119,25 @@ struct kvm_debug_exit_arch {
 };
 
 struct kvm_sync_regs {
+	/* Used with KVM_CAP_ARM_USER_IRQ */
+	__u64 device_irq_level;
 };
 
 struct kvm_arch_memory_slot {
 };
 
+/* for KVM_GET/SET_VCPU_EVENTS */
+struct kvm_vcpu_events {
+	struct {
+		__u8 serror_pending;
+		__u8 serror_has_esr;
+		/* Align it to 8 bytes */
+		__u8 pad[6];
+		__u64 serror_esr;
+	} exception;
+	__u32 reserved[12];
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
@@ -130,6 +149,15 @@ struct kvm_arch_memory_slot {
 #define KVM_REG_ARM_CRM_SHIFT		7
 #define KVM_REG_ARM_32_CRN_MASK		0x0000000000007800
 #define KVM_REG_ARM_32_CRN_SHIFT	11
+/*
+ * For KVM currently all guest registers are nonsecure, but we reserve a bit
+ * in the encoding to distinguish secure from nonsecure for AArch32 system
+ * registers that are banked by security. This is 1 for the secure banked
+ * register, and 0 for the nonsecure banked register or if the register is
+ * not banked by security.
+ */
+#define KVM_REG_ARM_SECURE_MASK	0x0000000010000000
+#define KVM_REG_ARM_SECURE_SHIFT	28
 
 #define ARM_CP15_REG_SHIFT_MASK(x,n) \
 	(((x) << KVM_REG_ARM_ ## n ## _SHIFT) & KVM_REG_ARM_ ## n ## _MASK)
@@ -147,6 +175,12 @@ struct kvm_arch_memory_slot {
 	(__ARM_CP15_REG(op1, 0, crm, 0) | KVM_REG_SIZE_U64)
 #define ARM_CP15_REG64(...) __ARM_CP15_REG64(__VA_ARGS__)
 
+/* PL1 Physical Timer Registers */
+#define KVM_REG_ARM_PTIMER_CTL		ARM_CP15_REG32(0, 14, 2, 1)
+#define KVM_REG_ARM_PTIMER_CNT		ARM_CP15_REG64(0, 14)
+#define KVM_REG_ARM_PTIMER_CVAL		ARM_CP15_REG64(2, 14)
+
+/* Virtual Timer Registers */
 #define KVM_REG_ARM_TIMER_CTL		ARM_CP15_REG32(0, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CNT		ARM_CP15_REG64(1, 14)
 #define KVM_REG_ARM_TIMER_CVAL		ARM_CP15_REG64(3, 14)
@@ -175,6 +209,12 @@ struct kvm_arch_memory_slot {
 #define KVM_REG_ARM_VFP_FPINST		0x1009
 #define KVM_REG_ARM_VFP_FPINST2		0x100A
 
+/* KVM-as-firmware specific pseudo-registers */
+#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM | KVM_REG_SIZE_U64 | \
+					 KVM_REG_ARM_FW | ((r) & 0xffff))
+#define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
@@ -192,13 +232,26 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
+#define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK 0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
+/* Device Control API on vcpu fd */
+#define KVM_ARM_VCPU_PMU_V3_CTRL	0
+#define   KVM_ARM_VCPU_PMU_V3_IRQ	0
+#define   KVM_ARM_VCPU_PMU_V3_INIT	1
+#define KVM_ARM_VCPU_TIMER_CTRL		1
+#define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
+#define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_ITS_SAVE_TABLES		1
+#define   KVM_DEV_ARM_ITS_RESTORE_TABLES	2
+#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
+#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index c286035..97c3478 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * Copyright (C) 2012,2013 - ARM Ltd
  * Author: Marc Zyngier <marc.zyngier@arm.com>
@@ -38,6 +39,9 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_VCPU_EVENTS
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
@@ -88,6 +92,7 @@ struct kvm_regs {
 #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
 #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
 #define KVM_VGIC_ITS_ADDR_TYPE		4
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
 
 #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
@@ -143,11 +148,25 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW		(1 << 17)
 
 struct kvm_sync_regs {
+	/* Used with KVM_CAP_ARM_USER_IRQ */
+	__u64 device_irq_level;
 };
 
 struct kvm_arch_memory_slot {
 };
 
+/* for KVM_GET/SET_VCPU_EVENTS */
+struct kvm_vcpu_events {
+	struct {
+		__u8 serror_pending;
+		__u8 serror_has_esr;
+		/* Align it to 8 bytes */
+		__u8 pad[6];
+		__u64 serror_esr;
+	} exception;
+	__u32 reserved[12];
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
@@ -191,10 +210,22 @@ struct kvm_arch_memory_slot {
 
 #define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64)
 
+/* Physical Timer EL0 Registers */
+#define KVM_REG_ARM_PTIMER_CTL		ARM64_SYS_REG(3, 3, 14, 2, 1)
+#define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
+#define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
+
+/* EL0 Virtual Timer Registers */
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
 #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
 
+/* KVM-as-firmware specific pseudo-registers */
+#define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
+					 KVM_REG_ARM_FW | ((r) & 0xffff))
+#define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
@@ -212,18 +243,26 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
+#define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
 #define VGIC_LEVEL_INFO_LINE_LEVEL	0
 
-#define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
+#define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
+#define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
+#define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
+#define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
+#define KVM_ARM_VCPU_TIMER_CTRL		1
+#define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
+#define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f51d508..6d4ea4b 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef __LINUX_KVM_H
 #define __LINUX_KVM_H
 
@@ -155,6 +156,35 @@ struct kvm_s390_skeys {
 	__u32 reserved[9];
 };
 
+#define KVM_S390_CMMA_PEEK (1 << 0)
+
+/**
+ * kvm_s390_cmma_log - Used for CMMA migration.
+ *
+ * Used both for input and output.
+ *
+ * @start_gfn: Guest page number to start from.
+ * @count: Size of the result buffer.
+ * @flags: Control operation mode via KVM_S390_CMMA_* flags
+ * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
+ *             pages are still remaining.
+ * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
+ *        in the PGSTE.
+ * @values: Pointer to the values buffer.
+ *
+ * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
+ */
+struct kvm_s390_cmma_log {
+	__u64 start_gfn;
+	__u32 count;
+	__u32 flags;
+	union {
+		__u64 remaining;
+		__u64 mask;
+	};
+	__u64 values;
+};
+
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
@@ -366,6 +396,10 @@ struct kvm_run {
 		char padding[256];
 	};
 
+	/* 2048 is the size of the char array used to bound/pad the size
+	 * of the union that holds sync regs.
+	 */
+	#define SYNC_REGS_SIZE_BYTES 2048
 	/*
 	 * shared registers between kvm and userspace.
 	 * kvm_valid_regs specifies the register classes set by the host
@@ -377,7 +411,7 @@ struct kvm_run {
 	__u64 kvm_dirty_regs;
 	union {
 		struct kvm_sync_regs regs;
-		char padding[2048];
+		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
 };
 
@@ -386,13 +420,19 @@ struct kvm_run {
 struct kvm_coalesced_mmio_zone {
 	__u64 addr;
 	__u32 size;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 pio;
+	};
 };
 
 struct kvm_coalesced_mmio {
 	__u64 phys_addr;
 	__u32 len;
-	__u32 pad;
+	union {
+		__u32 pad;
+		__u32 pio;
+	};
 	__u8  data[8];
 };
 
@@ -452,6 +492,17 @@ struct kvm_dirty_log {
 	};
 };
 
+/* for KVM_CLEAR_DIRTY_LOG */
+struct kvm_clear_dirty_log {
+	__u32 slot;
+	__u32 num_pages;
+	__u64 first_page;
+	union {
+		void __user *dirty_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
@@ -600,9 +651,9 @@ struct kvm_s390_irq {
 
 struct kvm_s390_irq_state {
 	__u64 buf;
-	__u32 flags;
+	__u32 flags;        /* will stay unused for compatibility reasons */
 	__u32 len;
-	__u32 reserved[4];
+	__u32 reserved[4];  /* will stay unused for compatibility reasons */
 };
 
 /* for KVM_SET_GUEST_DEBUG */
@@ -642,6 +693,13 @@ struct kvm_ioeventfd {
 	__u8  pad[36];
 };
 
+#define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
+#define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
+#define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
+#define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
+                                              KVM_X86_DISABLE_EXITS_HLT | \
+                                              KVM_X86_DISABLE_EXITS_PAUSE)
+
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
 	/* in */
@@ -678,11 +736,13 @@ struct kvm_ppc_one_seg_page_size {
 
 #define KVM_PPC_PAGE_SIZES_REAL		0x00000001
 #define KVM_PPC_1T_SEGMENTS		0x00000002
+#define KVM_PPC_NO_HASH			0x00000004
 
 struct kvm_ppc_smmu_info {
 	__u64 flags;
 	__u32 slb_size;
-	__u32 pad;
+	__u16 data_keys;	/* # storage keys supported for data */
+	__u16 instr_keys;	/* # storage keys supported for instructions */
 	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
 };
 
@@ -702,9 +762,22 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
+/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
+#define KVM_VM_MIPS_TE		0
+#define KVM_VM_MIPS_VZ		1
+
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
 /*
+ * On arm64, machine type can be used to request the physical
+ * address size for the VM. Bits[7-0] are reserved for the guest
+ * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
+ * value 0 implies the default IPA size, 40bits.
+ */
+#define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
+#define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
+	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+/*
  * ioctls for /dev/kvm fds:
  */
 #define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
@@ -726,6 +799,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
 #define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
 #define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
+#define KVM_GET_MSR_FEATURE_INDEX_LIST    _IOWR(KVMIO, 0x0a, struct kvm_msr_list)
 
 /*
  * Extension capability list.
@@ -883,6 +957,37 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_MMU_RADIX 134
 #define KVM_CAP_PPC_MMU_HASH_V3 135
 #define KVM_CAP_IMMEDIATE_EXIT 136
+#define KVM_CAP_MIPS_VZ 137
+#define KVM_CAP_MIPS_TE 138
+#define KVM_CAP_MIPS_64BIT 139
+#define KVM_CAP_S390_GS 140
+#define KVM_CAP_S390_AIS 141
+#define KVM_CAP_SPAPR_TCE_VFIO 142
+#define KVM_CAP_X86_DISABLE_EXITS 143
+#define KVM_CAP_ARM_USER_IRQ 144
+#define KVM_CAP_S390_CMMA_MIGRATION 145
+#define KVM_CAP_PPC_FWNMI 146
+#define KVM_CAP_PPC_SMT_POSSIBLE 147
+#define KVM_CAP_HYPERV_SYNIC2 148
+#define KVM_CAP_HYPERV_VP_INDEX 149
+#define KVM_CAP_S390_AIS_MIGRATION 150
+#define KVM_CAP_PPC_GET_CPU_CHAR 151
+#define KVM_CAP_S390_BPB 152
+#define KVM_CAP_GET_MSR_FEATURES 153
+#define KVM_CAP_HYPERV_EVENTFD 154
+#define KVM_CAP_HYPERV_TLBFLUSH 155
+#define KVM_CAP_S390_HPAGE_1M 156
+#define KVM_CAP_NESTED_STATE 157
+#define KVM_CAP_ARM_INJECT_SERROR_ESR 158
+#define KVM_CAP_MSR_PLATFORM_INFO 159
+#define KVM_CAP_PPC_NESTED_HV 160
+#define KVM_CAP_HYPERV_SEND_IPI 161
+#define KVM_CAP_COALESCED_PIO 162
+#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS 163
+#define KVM_CAP_EXCEPTION_PAYLOAD 164
+#define KVM_CAP_ARM_VM_IPA_SIZE 165
+#define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
+#define KVM_CAP_HYPERV_CPUID 167
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1087,6 +1192,7 @@ struct kvm_device_attr {
 #define  KVM_DEV_VFIO_GROUP			1
 #define   KVM_DEV_VFIO_GROUP_ADD			1
 #define   KVM_DEV_VFIO_GROUP_DEL			2
+#define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE		3
 
 enum kvm_device_type {
 	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
@@ -1108,6 +1214,11 @@ enum kvm_device_type {
 	KVM_DEV_TYPE_MAX,
 };
 
+struct kvm_vfio_spapr_tce {
+	__s32	groupfd;
+	__s32	tablefd;
+};
+
 /*
  * ioctls for VM fds
  */
@@ -1206,6 +1317,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_CONFIGURE_V3_MMU  _IOW(KVMIO,  0xaf, struct kvm_ppc_mmuv3_cfg)
 /* Available with KVM_CAP_PPC_RADIX_MMU */
 #define KVM_PPC_GET_RMMU_INFO	  _IOW(KVMIO,  0xb0, struct kvm_ppc_rmmu_info)
+/* Available with KVM_CAP_PPC_GET_CPU_CHAR */
+#define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1300,6 +1413,112 @@ struct kvm_s390_ucas_mapping {
 #define KVM_S390_GET_IRQ_STATE	  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_state)
 /* Available with KVM_CAP_X86_SMM */
 #define KVM_SMI                   _IO(KVMIO,   0xb7)
+/* Available with KVM_CAP_S390_CMMA_MIGRATION */
+#define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
+#define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
+/* Memory Encryption Commands */
+#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
+
+struct kvm_enc_region {
+	__u64 addr;
+	__u64 size;
+};
+
+#define KVM_MEMORY_ENCRYPT_REG_REGION    _IOR(KVMIO, 0xbb, struct kvm_enc_region)
+#define KVM_MEMORY_ENCRYPT_UNREG_REGION  _IOR(KVMIO, 0xbc, struct kvm_enc_region)
+
+/* Available with KVM_CAP_HYPERV_EVENTFD */
+#define KVM_HYPERV_EVENTFD        _IOW(KVMIO,  0xbd, struct kvm_hyperv_eventfd)
+
+/* Available with KVM_CAP_NESTED_STATE */
+#define KVM_GET_NESTED_STATE         _IOWR(KVMIO, 0xbe, struct kvm_nested_state)
+#define KVM_SET_NESTED_STATE         _IOW(KVMIO,  0xbf, struct kvm_nested_state)
+
+/* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT */
+#define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
+
+/* Available with KVM_CAP_HYPERV_CPUID */
+#define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
+
+/* Secure Encrypted Virtualization command */
+enum sev_cmd_id {
+	/* Guest initialization commands */
+	KVM_SEV_INIT = 0,
+	KVM_SEV_ES_INIT,
+	/* Guest launch commands */
+	KVM_SEV_LAUNCH_START,
+	KVM_SEV_LAUNCH_UPDATE_DATA,
+	KVM_SEV_LAUNCH_UPDATE_VMSA,
+	KVM_SEV_LAUNCH_SECRET,
+	KVM_SEV_LAUNCH_MEASURE,
+	KVM_SEV_LAUNCH_FINISH,
+	/* Guest migration commands (outgoing) */
+	KVM_SEV_SEND_START,
+	KVM_SEV_SEND_UPDATE_DATA,
+	KVM_SEV_SEND_UPDATE_VMSA,
+	KVM_SEV_SEND_FINISH,
+	/* Guest migration commands (incoming) */
+	KVM_SEV_RECEIVE_START,
+	KVM_SEV_RECEIVE_UPDATE_DATA,
+	KVM_SEV_RECEIVE_UPDATE_VMSA,
+	KVM_SEV_RECEIVE_FINISH,
+	/* Guest status and debug commands */
+	KVM_SEV_GUEST_STATUS,
+	KVM_SEV_DBG_DECRYPT,
+	KVM_SEV_DBG_ENCRYPT,
+	/* Guest certificates commands */
+	KVM_SEV_CERT_EXPORT,
+
+	KVM_SEV_NR_MAX,
+};
+
+struct kvm_sev_cmd {
+	__u32 id;
+	__u64 data;
+	__u32 error;
+	__u32 sev_fd;
+};
+
+struct kvm_sev_launch_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 dh_uaddr;
+	__u32 dh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_launch_update_data {
+	__u64 uaddr;
+	__u32 len;
+};
+
+
+struct kvm_sev_launch_secret {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+struct kvm_sev_launch_measure {
+	__u64 uaddr;
+	__u32 len;
+};
+
+struct kvm_sev_guest_status {
+	__u32 handle;
+	__u32 policy;
+	__u32 state;
+};
+
+struct kvm_sev_dbg {
+	__u64 src_uaddr;
+	__u64 dst_uaddr;
+	__u32 len;
+};
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
@@ -1354,4 +1573,21 @@ struct kvm_assigned_msix_entry {
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
+/* Available with KVM_CAP_ARM_USER_IRQ */
+
+/* Bits for run->s.regs.device_irq_level */
+#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
+#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
+#define KVM_ARM_DEV_PMU			(1 << 2)
+
+struct kvm_hyperv_eventfd {
+	__u32 conn_id;
+	__s32 fd;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
+#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
+
 #endif /* __LINUX_KVM_H */
diff --git a/mips/include/asm/kvm.h b/mips/include/asm/kvm.h
index a8a0199..edcf717 100644
--- a/mips/include/asm/kvm.h
+++ b/mips/include/asm/kvm.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -21,6 +22,8 @@
 
 #define __KVM_HAVE_READONLY_MEM
 
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
 /*
  * for KVM_GET_REGS and KVM_SET_REGS
  *
@@ -54,9 +57,14 @@ struct kvm_fpu {
  * Register set = 0: GP registers from kvm_regs (see definitions below).
  *
  * Register set = 1: CP0 registers.
- *  bits[15..8]  - Must be zero.
- *  bits[7..3]   - Register 'rd'  index.
- *  bits[2..0]   - Register 'sel' index.
+ *  bits[15..8]  - COP0 register set.
+ *
+ *  COP0 register set = 0: Main CP0 registers.
+ *   bits[7..3]   - Register 'rd'  index.
+ *   bits[2..0]   - Register 'sel' index.
+ *
+ *  COP0 register set = 1: MAARs.
+ *   bits[7..0]   - MAAR index.
  *
  * Register set = 2: KVM specific registers (see definitions below).
  *
@@ -115,6 +123,15 @@ struct kvm_fpu {
 
 
 /*
+ * KVM_REG_MIPS_CP0 - Coprocessor 0 registers.
+ */
+
+#define KVM_REG_MIPS_MAAR	(KVM_REG_MIPS_CP0 | (1 << 8))
+#define KVM_REG_MIPS_CP0_MAAR(n)	(KVM_REG_MIPS_MAAR | \
+					 KVM_REG_SIZE_U64 | (n))
+
+
+/*
  * KVM_REG_MIPS_KVM - KVM specific control registers.
  */
 
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index 4edbe4b..8c876c1 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License, version 2, as
@@ -29,6 +30,9 @@
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_GUEST_DEBUG
 
+/* Not always available, but if it is, this is the correct offset.  */
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
 struct kvm_regs {
 	__u64 pc;
 	__u64 cr;
@@ -57,6 +61,12 @@ struct kvm_regs {
 
 #define KVM_SREGS_E_FSL_PIDn	(1 << 0) /* PID1/PID2 */
 
+/* flags for kvm_run.flags */
+#define KVM_RUN_PPC_NMI_DISP_MASK		(3 << 0)
+#define   KVM_RUN_PPC_NMI_DISP_FULLY_RECOV	(1 << 0)
+#define   KVM_RUN_PPC_NMI_DISP_LIMITED_RECOV	(2 << 0)
+#define   KVM_RUN_PPC_NMI_DISP_NOT_RECOV	(3 << 0)
+
 /*
  * Feature bits indicate which sections of the sregs struct are valid,
  * both in KVM_GET_SREGS and KVM_SET_SREGS.  On KVM_SET_SREGS, registers
@@ -433,6 +443,31 @@ struct kvm_ppc_rmmu_info {
 	__u32	ap_encodings[8];
 };
 
+/* For KVM_PPC_GET_CPU_CHAR */
+struct kvm_ppc_cpu_char {
+	__u64	character;		/* characteristics of the CPU */
+	__u64	behaviour;		/* recommended software behaviour */
+	__u64	character_mask;		/* valid bits in character */
+	__u64	behaviour_mask;		/* valid bits in behaviour */
+};
+
+/*
+ * Values for character and character_mask.
+ * These are identical to the values used by H_GET_CPU_CHARACTERISTICS.
+ */
+#define KVM_PPC_CPU_CHAR_SPEC_BAR_ORI31		(1ULL << 63)
+#define KVM_PPC_CPU_CHAR_BCCTRL_SERIALISED	(1ULL << 62)
+#define KVM_PPC_CPU_CHAR_L1D_FLUSH_ORI30	(1ULL << 61)
+#define KVM_PPC_CPU_CHAR_L1D_FLUSH_TRIG2	(1ULL << 60)
+#define KVM_PPC_CPU_CHAR_L1D_THREAD_PRIV	(1ULL << 59)
+#define KVM_PPC_CPU_CHAR_BR_HINT_HONOURED	(1ULL << 58)
+#define KVM_PPC_CPU_CHAR_MTTRIG_THR_RECONF	(1ULL << 57)
+#define KVM_PPC_CPU_CHAR_COUNT_CACHE_DIS	(1ULL << 56)
+
+#define KVM_PPC_CPU_BEHAV_FAVOUR_SECURITY	(1ULL << 63)
+#define KVM_PPC_CPU_BEHAV_L1D_FLUSH_PR		(1ULL << 62)
+#define KVM_PPC_CPU_BEHAV_BNDS_CHK_SPEC_BAR	(1ULL << 61)
+
 /* Per-vcpu XICS interrupt controller state */
 #define KVM_REG_PPC_ICP_STATE	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x8c)
 
@@ -597,6 +632,10 @@ struct kvm_ppc_rmmu_info {
 #define KVM_REG_PPC_TIDR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbc)
 #define KVM_REG_PPC_PSSCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbd)
 
+#define KVM_REG_PPC_DEC_EXPIRY	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xbe)
+#define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
+#define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 739c0c5..dabfcf7 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _ASM_X86_KVM_H
 #define _ASM_X86_KVM_H
 
@@ -9,6 +10,9 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
+#define KVM_PIO_PAGE_OFFSET 1
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 2
+
 #define DE_VECTOR 0
 #define DB_VECTOR 1
 #define BP_VECTOR 3
@@ -284,6 +288,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SIPI_VECTOR	0x00000002
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
+#define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -295,7 +300,7 @@ struct kvm_vcpu_events {
 		__u8 injected;
 		__u8 nr;
 		__u8 has_error_code;
-		__u8 pad;
+		__u8 pending;
 		__u32 error_code;
 	} exception;
 	struct {
@@ -318,7 +323,9 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u32 reserved[9];
+	__u8 reserved[27];
+	__u8 exception_has_payload;
+	__u64 exception_payload;
 };
 
 /* for KVM_GET/SET_DEBUGREGS */
@@ -350,11 +357,67 @@ struct kvm_xcrs {
 	__u64 padding[16];
 };
 
-/* definition of registers in kvm_run */
+#define KVM_SYNC_X86_REGS      (1UL << 0)
+#define KVM_SYNC_X86_SREGS     (1UL << 1)
+#define KVM_SYNC_X86_EVENTS    (1UL << 2)
+
+#define KVM_SYNC_X86_VALID_FIELDS \
+	(KVM_SYNC_X86_REGS| \
+	 KVM_SYNC_X86_SREGS| \
+	 KVM_SYNC_X86_EVENTS)
+
+/* kvm_sync_regs struct included by kvm_run struct */
 struct kvm_sync_regs {
+	/* Members of this structure are potentially malicious.
+	 * Care must be taken by code reading, esp. interpreting,
+	 * data fields from them inside KVM to prevent TOCTOU and
+	 * double-fetch types of vulnerabilities.
+	 */
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct kvm_vcpu_events events;
 };
 
 #define KVM_X86_QUIRK_LINT0_REENABLED	(1 << 0)
 #define KVM_X86_QUIRK_CD_NW_CLEARED	(1 << 1)
+#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	(1 << 2)
+
+#define KVM_STATE_NESTED_GUEST_MODE	0x00000001
+#define KVM_STATE_NESTED_RUN_PENDING	0x00000002
+#define KVM_STATE_NESTED_EVMCS		0x00000004
+
+#define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
+#define KVM_STATE_NESTED_SMM_VMXON	0x00000002
+
+struct kvm_vmx_nested_state {
+	__u64 vmxon_pa;
+	__u64 vmcs_pa;
+
+	struct {
+		__u16 flags;
+	} smm;
+};
+
+/* for KVM_CAP_NESTED_STATE */
+struct kvm_nested_state {
+	/* KVM_STATE_* flags */
+	__u16 flags;
+
+	/* 0 for VMX, 1 for SVM.  */
+	__u16 format;
+
+	/* 128 for SVM, 128 + VMCS size for VMX.  */
+	__u32 size;
+
+	union {
+		/* VMXON, VMCS */
+		struct kvm_vmx_nested_state vmx;
+
+		/* Pad the header to 128 bytes.  */
+		__u8 pad[120];
+	};
+
+	__u8 data[0];
+};
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.1.4
