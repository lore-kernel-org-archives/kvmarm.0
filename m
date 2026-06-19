Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79033815E6;
	Fri, 19 Jun 2026 11:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870066; cv=none; b=TPqN8n8YJ5NRgNc5L/2utmMM3cBffJVkUegcj/rIrLR56nWJtB1/voClZFstGtlR4iQ79TGMcADACtZpjOgjvb/A5NFvsKFLT5a8AFnDOT2RGk+GOmMfUkmCy0lTOYw91GF42Dp0cJDNn8p7eJc7WnMyHHzDaaqTZUTow4bfSsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870066; c=relaxed/simple;
	bh=AdT7ZBoKVfjSy+OJB8XPWq+2hlx0CtGfw8a/VwsBf1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulgzp0X2E2gMcjXj5N1b4iAJTbk+dJZaaSBtW1jwnnoppMc+YlDsFeJKe8djEkzVeRdWjKsAGljlujb/bxJ8uIZIRtezRkWMMgRzWMJyCx3gSGAJAdxWqZAIXb5oJvAy0M9+l1xeVwWAHOw7R09Q/EYWcAvrWh5RwpI3/0q2Pig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQYlbYgp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQYlbYgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D437B1F00A3A;
	Fri, 19 Jun 2026 11:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781870064;
	bh=ociPDbOoWU6NxqCMN3/vK3D67oXjtrc2oiWYhzbZMi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQYlbYgpIqHQ2ujZbYRkr1jwhPvlJmTSFvOfM1FO4oBOAmQgghMfjMnnnsOfelnPQ
	 DaXDjbJDEZLQ0Q+4W85+An/6nDF7bPknNKauRlBonMUr8R4F2P8qktcIk8TSQQalgR
	 A9Juwt9cvYCNzCz7wzB4AwxfdAQO5Yh/51pwQT31axRMnkCZOv/6PWLccDkw3TEuqh
	 iv9FgJi4zXtAVZ1mF/TTALr5X/RWFdkRSHEb/V4xX/GN+jB1VX8CRk7EtbmoVZ2C2E
	 v4DxKgScmkixBaC0pOo2VxoZqN8P5QrWqD1zAbY/PXJGbuMpK/iW01jYvJCeWrK9aZ
	 FkZABfN1m4Vqw==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 1/4] Sync kernel UAPI headers with v7.1
Date: Fri, 19 Jun 2026 12:54:11 +0100
Message-ID: <20260619115415.5475-2-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115415.5475-1-will@kernel.org>
References: <20260619115415.5475-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Generated using util/update_headers.sh.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arm64/include/asm/kvm.h     |  1 +
 include/linux/kvm.h         | 53 ++++++++++++++++++++++++++++++++-----
 include/linux/virtio_ring.h |  5 +---
 riscv/include/asm/kvm.h     | 11 +++++---
 x86/include/asm/kvm.h       | 21 +++++++++------
 5 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index a792a59..1c13bfa 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -428,6 +428,7 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_USERSPACE_PPIS	5
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index dddb781..6c8afa2 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,9 +11,14 @@
 #include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/stddef.h>
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
 
+#ifdef __KERNEL__
+#include <linux/kvm_types.h>
+#endif
+
 #define KVM_API_VERSION 12
 
 /*
@@ -135,6 +140,12 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_snp_req_certs {
+	__u64 gpa;
+	__u64 npages;
+	__u64 ret;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -180,6 +191,8 @@ struct kvm_xen_exit {
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
 #define KVM_EXIT_ARM_SEA          41
+#define KVM_EXIT_ARM_LDST64B      42
+#define KVM_EXIT_SNP_REQ_CERTS    43
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -402,7 +415,7 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
-		/* KVM_EXIT_ARM_NISV */
+		/* KVM_EXIT_ARM_NISV / KVM_EXIT_ARM_LDST64B */
 		struct {
 			__u64 esr_iss;
 			__u64 fault_ipa;
@@ -482,6 +495,8 @@ struct kvm_run {
 			__u64 gva;
 			__u64 gpa;
 		} arm_sea;
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs snp_req_certs;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -528,7 +543,7 @@ struct kvm_coalesced_mmio {
 
 struct kvm_coalesced_mmio_ring {
 	__u32 first, last;
-	struct kvm_coalesced_mmio coalesced_mmio[];
+	__DECLARE_FLEX_ARRAY(struct kvm_coalesced_mmio, coalesced_mmio);
 };
 
 #define KVM_COALESCED_MMIO_MAX \
@@ -578,7 +593,7 @@ struct kvm_clear_dirty_log {
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
-	__u8  sigset[];
+	__DECLARE_FLEX_ARRAY(__u8, sigset);
 };
 
 /* for KVM_TPR_ACCESS_REPORTING */
@@ -689,6 +704,11 @@ struct kvm_enable_cap {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+#define KVM_VM_TYPE_ARM_PROTECTED	(1UL << 31)
+#define KVM_VM_TYPE_ARM_MASK		(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
+					 KVM_VM_TYPE_ARM_PROTECTED)
+
 /*
  * ioctls for /dev/kvm fds:
  */
@@ -974,6 +994,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
+#define KVM_CAP_S390_KEYOP 247
+#define KVM_CAP_S390_VSIE_ESAMODE 248
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1036,7 +1058,7 @@ struct kvm_irq_routing_entry {
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
-	struct kvm_irq_routing_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_irq_routing_entry, entries);
 };
 
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
@@ -1127,7 +1149,7 @@ struct kvm_dirty_tlb {
 
 struct kvm_reg_list {
 	__u64 n; /* number of regs */
-	__u64 reg[];
+	__DECLARE_FLEX_ARRAY(__u64, reg);
 };
 
 struct kvm_one_reg {
@@ -1209,6 +1231,10 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_LOONGARCH_DMSINTC,
+#define KVM_DEV_TYPE_LOONGARCH_DMSINTC	KVM_DEV_TYPE_LOONGARCH_DMSINTC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
 
 	KVM_DEV_TYPE_MAX,
 
@@ -1219,6 +1245,16 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
+#define KVM_S390_KEYOP_ISKE 0x01
+#define KVM_S390_KEYOP_RRBE 0x02
+#define KVM_S390_KEYOP_SSKE 0x03
+struct kvm_s390_keyop {
+	__u64 guest_addr;
+	__u8  key;
+	__u8  operation;
+	__u8  pad[6];
+};
+
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
@@ -1238,6 +1274,7 @@ struct kvm_vfio_spapr_tce {
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
+#define KVM_S390_KEYOP           _IOWR(KVMIO, 0x53, struct kvm_s390_keyop)
 
 /* Device model IOC */
 #define KVM_CREATE_IRQCHIP        _IO(KVMIO,   0x60)
@@ -1579,7 +1616,11 @@ struct kvm_stats_desc {
 	__u16 size;
 	__u32 offset;
 	__u32 bucket_size;
-	char name[];
+#ifdef __KERNEL__
+	char name[KVM_STATS_NAME_SIZE];
+#else
+	__DECLARE_FLEX_ARRAY(char, name);
+#endif
 };
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index f8c20d3..3c47858 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -31,9 +31,6 @@
  * SUCH DAMAGE.
  *
  * Copyright Rusty Russell IBM Corporation 2007. */
-#ifndef __KERNEL__
-#include <stdint.h>
-#endif
 #include <linux/types.h>
 #include <linux/virtio_types.h>
 
@@ -202,7 +199,7 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = (struct vring_avail *)((char *)p + num * sizeof(struct vring_desc));
-	vr->used = (void *)(((uintptr_t)&vr->avail->ring[num] + sizeof(__virtio16)
+	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__virtio16)
 		+ align-1) & ~(align - 1));
 }
 
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 54f3ad7..504e733 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -110,6 +110,10 @@ struct kvm_riscv_timer {
 	__u64 state;
 };
 
+/* Possible states for kvm_riscv_timer */
+#define KVM_RISCV_TIMER_STATE_OFF	0
+#define KVM_RISCV_TIMER_STATE_ON	1
+
 /*
  * ISA extension IDs specific to KVM. This is not the same as the host ISA
  * extension IDs as that is internal to the host and should not be exposed
@@ -192,6 +196,9 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZFBFMIN,
 	KVM_RISCV_ISA_EXT_ZVFBFMIN,
 	KVM_RISCV_ISA_EXT_ZVFBFWMA,
+	KVM_RISCV_ISA_EXT_ZCLSD,
+	KVM_RISCV_ISA_EXT_ZILSD,
+	KVM_RISCV_ISA_EXT_ZALASR,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -235,10 +242,6 @@ struct kvm_riscv_sbi_fwft {
 	struct kvm_riscv_sbi_fwft_feature pointer_masking;
 };
 
-/* Possible states for kvm_riscv_timer */
-#define KVM_RISCV_TIMER_STATE_OFF	0
-#define KVM_RISCV_TIMER_STATE_ON	1
-
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 7ceff65..5f2b30d 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -197,13 +197,13 @@ struct kvm_msrs {
 	__u32 nmsrs; /* number of msrs in entries */
 	__u32 pad;
 
-	struct kvm_msr_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_msr_entry, entries);
 };
 
 /* for KVM_GET_MSR_INDEX_LIST */
 struct kvm_msr_list {
 	__u32 nmsrs; /* number of msrs in entries */
-	__u32 indices[];
+	__DECLARE_FLEX_ARRAY(__u32, indices);
 };
 
 /* Maximum size of any access bitmap in bytes */
@@ -245,7 +245,7 @@ struct kvm_cpuid_entry {
 struct kvm_cpuid {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_cpuid_entry, entries);
 };
 
 struct kvm_cpuid_entry2 {
@@ -267,7 +267,7 @@ struct kvm_cpuid_entry2 {
 struct kvm_cpuid2 {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry2 entries[];
+	__DECLARE_FLEX_ARRAY(struct kvm_cpuid_entry2, entries);
 };
 
 /* for KVM_GET_PIT and KVM_SET_PIT */
@@ -398,7 +398,7 @@ struct kvm_xsave {
 	 * the contents of CPUID leaf 0xD on the host.
 	 */
 	__u32 region[1024];
-	__u32 extra[];
+	__DECLARE_FLEX_ARRAY(__u32, extra);
 };
 
 #define KVM_MAX_XCRS	16
@@ -476,6 +476,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
 #define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
+#define KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM (1 << 10)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
@@ -503,6 +504,7 @@ struct kvm_sync_regs {
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
 #  define KVM_X86_SNP_POLICY_BITS	1
+#  define KVM_X86_SEV_SNP_REQ_CERTS	2
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -564,7 +566,7 @@ struct kvm_pmu_event_filter {
 	__u32 fixed_counter_bitmap;
 	__u32 flags;
 	__u32 pad[4];
-	__u64 events[];
+	__DECLARE_FLEX_ARRAY(__u64, events);
 };
 
 #define KVM_PMU_EVENT_ALLOW 0
@@ -743,6 +745,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_ENABLE_REQ_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
@@ -914,8 +917,10 @@ struct kvm_sev_snp_launch_finish {
 	__u64 pad1[4];
 };
 
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+#define KVM_X2APIC_API_USE_32BIT_IDS			_BITULL(0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK		_BITULL(1)
+#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST	_BITULL(2)
+#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST	_BITULL(3)
 
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

