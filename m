Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03D0449B17
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 10:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321978; cv=none; b=RhbmgM9qMqPaozK2EdScojVcV6F/5tPeYak16HPKyawk9gNx4LVVSCIzA72kYzCVRYBQz02G0Rr4Wxmbs65CbSlHqt/HQEiC3Ts8h6VdIz6G3HNX90yybCX55OTSfbOxG8zTTVN4cGEAAa2tOXXS4z0LoBnlZiPO9LBihtyrDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321978; c=relaxed/simple;
	bh=MScJpOAXXAfbQ2u1dA0zQvloHLJtfbWH0IBTDlX9ou8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JB9QvZd/3apFKH7X16R91OReWq3/wULTvjXZTVNwGFGVmbSA6GrC71lo+E2DvZcK5fD9q19bgXtv6cz74jt1fmtAYceW5Hyexxflh2qDVsHf4j2y7+pAgO0VnZIzVyC3A+3QCNDZhSaz6IuvyDvgXIAP9YE20xNFuy6M10PKzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=e/MmoJw4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="e/MmoJw4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40B38168F;
	Wed, 29 Jul 2026 03:46:12 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 59C743F66F;
	Wed, 29 Jul 2026 03:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785321976; bh=MScJpOAXXAfbQ2u1dA0zQvloHLJtfbWH0IBTDlX9ou8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/MmoJw4DqtRP7j6iVYsL3vdEnFBhovh0MugXM3mIgj6/8pkz+m9kEipEAUv6NYka
	 UeDJTzfGLsIwseivZ6Mhsyr9dzsCARxip0pKCRykeIsxoo3ym4+FE3Af6tB3ExX3Wo
	 h+26Q0BYL37fExFp9uluuy6n1kSotDlINE/C6jZA=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 01/11] KVM: arm64: HDBSS bits
Date: Wed, 29 Jul 2026 11:45:36 +0100
Message-ID: <20260729104548.3439958-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729104548.3439958-1-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12475; i=leo.bras@arm.com; h=from:subject; bh=MScJpOAXXAfbQ2u1dA0zQvloHLJtfbWH0IBTDlX9ou8=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLIyb17l4ymw1v+kXVbjKDLp4O1+s2vScrcy1F8KLRSoE FFP4mjpKGVhEONikBVTZJF9NH8Vz/cpGUeu/FgAM4eVCWQIAxenAExEYj4jQ4tff0sen4f/B8f+ rZN85bb0zbcO3XTvVt/FU9PCvHh/WjP84VR+5/Jo3SMfs2UTvpeELItVnKX2+vYbdaUuq5PcU4L 28wEA
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

All those bits should come from a future version of HDBSS patchset:
https://lore.kernel.org/all/20260709104026.2612599-1-zhengtian10@huawei.com/

I added them here in order to fulfill the dependencies and be able to
easily build and test this patchset, but this particular patch should *not*
be merged upstream.

It also sets a default nonzero value for chunksize, which will force eager
splitting, and allow this patchset to be properly tested. While
lazy-splitting should be possible in the next HDBSS patchset, it introduces
no new behaviours in how HACDBS shoud work, so having eager splitting
should be enough for testing.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/cpufeature.h    |  5 +++++
 arch/arm64/include/asm/kvm_dirty_bit.h | 12 ++++++++++++
 arch/arm64/include/asm/kvm_pgtable.h   |  3 +++
 arch/arm64/kernel/cpufeature.c         | 12 ++++++++++++
 arch/arm64/kvm/dirty_bit.c             | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c           | 15 +++++++++++++--
 arch/arm64/kvm/mmu.c                   |  8 ++++++--
 arch/arm64/kvm/Makefile                |  2 +-
 arch/arm64/tools/cpucaps               |  1 +
 9 files changed, 69 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
 create mode 100644 arch/arm64/kvm/dirty_bit.c

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db..bdfab086fd94 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -856,20 +856,25 @@ static inline bool system_supports_poe(void)
 static inline bool system_supports_gcs(void)
 {
 	return alternative_has_cap_unlikely(ARM64_HAS_GCS);
 }
 
 static inline bool system_supports_haft(void)
 {
 	return cpus_have_final_cap(ARM64_HAFT);
 }
 
+static inline bool system_supports_hdbss(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_HDBSS);
+}
+
 static __always_inline bool system_supports_mpam(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM);
 }
 
 static __always_inline bool system_supports_mpam_hcr(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
 }
 
diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
new file mode 100644
index 000000000000..dd16438f0651
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ * Author: Leonardo Bras <leo.bras@arm.com>
+ */
+
+#ifndef __ARM64_KVM_DIRTY_BIT_H__
+#define __ARM64_KVM_DIRTY_BIT_H__
+
+#include <asm/kvm_pgtable.h>
+
+#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..646ff88e0258 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -86,20 +86,22 @@ typedef u64 kvm_pte_t;
 #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 50)
 
 #define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 #define KVM_PTE_LEAF_ATTR_HI_S1_UXN	BIT(54)
 #define KVM_PTE_LEAF_ATTR_HI_S1_PXN	BIT(53)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 /* pKVM invalid pte encodings */
 #define KVM_INVALID_PTE_TYPE_MASK	GENMASK(63, 60)
 #define KVM_INVALID_PTE_ANNOT_MASK	~(KVM_PTE_VALID | \
 					  KVM_INVALID_PTE_TYPE_MASK)
@@ -246,20 +248,21 @@ struct kvm_pgtable_mm_ops {
 };
 
 /**
  * enum kvm_pgtable_stage2_flags - Stage-2 page-table flags.
  * @KVM_PGTABLE_S2_IDMAP:	Only use identity mappings.
  * @KVM_PGTABLE_S2_AS_S1:	Final memory attributes are that of Stage-1.
  */
 enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_IDMAP			= BIT(0),
 	KVM_PGTABLE_S2_AS_S1			= BIT(1),
+	KVM_PGTABLE_S2_DBM			= BIT(2),
 };
 
 /**
  * enum kvm_pgtable_prot - Page-table permissions and attributes.
  * @KVM_PGTABLE_PROT_UX:	Unprivileged execute permission.
  * @KVM_PGTABLE_PROT_PX:	Privileged execute permission.
  * @KVM_PGTABLE_PROT_X:		Privileged and unprivileged execute permission.
  * @KVM_PGTABLE_PROT_W:		Write permission.
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120..aa327eebaf1c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2124,20 +2124,25 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
 
 	return true;
 }
 
 static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
 			  int __unused)
 {
 	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
 }
 
+static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
+{
+	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
+}
+
 bool cpu_supports_bbml2_noabort(void)
 {
 	/*
 	 * We want to allow usage of BBML2 in as wide a range of kernel contexts
 	 * as possible. This list is therefore an allow-list of known-good
 	 * implementations that both support BBML2 and additionally, fulfill the
 	 * extra constraint of never generating TLB conflict aborts when using
 	 * the relaxed BBML2 semantics (such aborts make use of BBML2 in certain
 	 * kernel contexts difficult to prove safe against recursive aborts).
 	 *
@@ -2774,20 +2779,27 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		 * cannot be emulated in software (no access fault will occur).
 		 * Therefore this should be used only if it's supported system
 		 * wide.
 		 */
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.capability = ARM64_HAFT,
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HAFT)
 	},
 #endif
+	{
+		.desc = "Hardware Dirty state tracking structure (HDBSS)",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_HDBSS,
+		.matches = has_vhe_hdbss,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HDBSS)
+	},
 	{
 		.desc = "CRC32 instructions",
 		.capability = ARM64_HAS_CRC32,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64ISAR0_EL1, CRC32, IMP)
 	},
 	{
 		.desc = "Speculative Store Bypassing Safe (SSBS)",
 		.capability = ARM64_SSBS,
diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
new file mode 100644
index 000000000000..32fe938d6bf7
--- /dev/null
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ * Author: Leonardo Bras <leo.bras@arm.com>
+ */
+
+#include <asm/kvm_dirty_bit.h>
+
+/* HDBSS entry field definitions */
+#define HDBSS_ENTRY_VALID BIT(0)
+#define HDBSS_ENTRY_TTWL_SHIFT (1)
+#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
+#define HDBSS_ENTRY_TTWL(x) \
+	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
+#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
+#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..0e2ab3fc6910 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -724,23 +724,27 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 		attr = KVM_S2_MEMATTR(pgt, NORMAL);
 	}
 
 	r = stage2_set_xn_attr(prot, &attr);
 	if (r)
 		return r;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
-	if (prot & KVM_PGTABLE_PROT_W)
+	if (prot & KVM_PGTABLE_PROT_W) {
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
+		if (pgt->flags & KVM_PGTABLE_S2_DBM)
+			attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	}
+
 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
 
 	return 0;
 }
 
@@ -1360,23 +1364,27 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	kvm_pte_t xn = 0, set = 0, clr = 0;
 	s8 level;
 	int ret;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
 		return -EINVAL;
 
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
-	if (prot & KVM_PGTABLE_PROT_W)
+	if (prot & KVM_PGTABLE_PROT_W) {
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
+		if (pgt->flags & KVM_PGTABLE_S2_DBM)
+			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	}
+
 	if (prot & KVM_PGTABLE_PROT_X) {
 		ret = stage2_set_xn_attr(prot, &xn);
 		if (ret)
 			return ret;
 
 		set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
 		clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
 	}
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
@@ -1581,20 +1589,23 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u64 vtcr = mmu->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
 	pgt->pgd = (kvm_pteref_t)mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
+	if (system_supports_hdbss())
+		flags |= KVM_PGTABLE_S2_DBM;
+
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= mmu;
 	pgt->flags		= flags;
 	pgt->force_pte_cb	= force_pte_cb;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
 	dsb(ishst);
 	return 0;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..e086c01a9325 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1020,22 +1020,26 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 
 	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
 	if (!mmu->last_vcpu_ran) {
 		err = -ENOMEM;
 		goto out_destroy_pgtable;
 	}
 
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
-	 /* The eager page splitting is disabled by default */
-	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+	 /* The eager page splitting is disabled by default if system has no HDBSS */
+	if (system_supports_hdbss())
+		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
+	else
+		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
+
 	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
 
 	mmu->pgd_phys = __pa(pgt->pgd);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
 	return 0;
 
 out_destroy_pgtable:
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 59612d2f277c..6faacd857346 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -17,21 +17,21 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o config.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
 	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o \
-	 vgic/vgic-v5.o
+	 vgic/vgic-v5.o dirty_bit.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
 kvm-$(CONFIG_NVHE_EL2_TRACING) += hyp_trace.o
 
 always-y := hyp_constants.h hyp-constants.s
 
 define rule_gen_hyp_constants
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd4..a87706c9d160 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -62,20 +62,21 @@ HAS_RASV1P1_EXTN
 HAS_RNG
 HAS_SB
 HAS_STAGE2_FWB
 HAS_TCR2
 HAS_TIDCP1
 HAS_TLB_RANGE
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HAS_XNX
+HAS_HDBSS
 HAFT
 HW_DBM
 KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MPAM
 MPAM_HCR
 MTE
 MTE_ASYMM
 MTE_FAR
-- 
2.55.0

