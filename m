From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [KVMTOOL PATCH 14/15] kvm: update/sync the uapi headers from
 kernel(v5.0)
Date: Thu, 28 Feb 2019 16:07:36 +0000
Message-ID: <20190228160737.3323-15-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3ED14A464
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nHJimhsONgHC for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186DD4A492
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:24 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Since the existing versions of the uapi headers in kvmtool are quite
outdated, let bring in the latest copy of the following uapi headers
from the kernel v5.0:
	include/uapi/linux/kvm.h
	arch/arm64/include/uapi/asm/kvm.h

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arm/aarch64/include/asm/kvm.h |  41 +++++-
 include/linux/kvm.h           | 248 +++++++++++++++++++++++++++++++++-
 2 files changed, 282 insertions(+), 7 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index c2860358ae3e..97c3478ee6e7 100644
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
index f51d5082a377..6d4ea4b6c922 100644
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

@@ -702,8 +762,21 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2

+/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
+#define KVM_VM_MIPS_TE		0
+#define KVM_VM_MIPS_VZ		1
+
 #define KVM_S390_SIE_PAGE_OFFSET 1

+/*
+ * On arm64, machine type can be used to request the physical
+ * address size for the VM. Bits[7-0] are reserved for the guest
+ * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
+ * value 0 implies the default IPA size, 40bits.
+ */
+#define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
+#define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
+	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 /*
  * ioctls for /dev/kvm fds:
  */
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
--
2.17.1
