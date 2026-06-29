Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B26A3B7747;
	Mon, 29 Jun 2026 11:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731918; cv=none; b=nM6MP7JhLm9gssyuE+G0Cf/4BZXztC7An1gchp8D2aW0aLwWkOnjEvFKpjOMtiMjFr5uAwPswtC2eOzTt5XN4eoNDeA4NJDWuoEh1sM9+PCfjSuXqKan5XhHXKxGFfMixG1r7Ved5a4T54nL4YKtIsvUGDeYlaZ9xtgITD9ro98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731918; c=relaxed/simple;
	bh=LiSOVEk6j0lnEElTZRcxJ53LwB/7YbOnZLcgoUEWj24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBNxIffeqxOGIbsZNgCRijBfXfYNadoEUgKyapILCmSh5Se2ZESIrlTppe6IAkTZdIV7w/aMfshi7fvsHq2Uu/ySNpawQOrl1ZQK/ECJztup14bduTgkZ9mNz8dzU9j67hGR1GoqNxT3JKqp1i76hoUwvWp34LuODeH1sqLqinU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kmFymY0s; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kmFymY0s"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 318AF168F;
	Mon, 29 Jun 2026 04:18:31 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C68A03F905;
	Mon, 29 Jun 2026 04:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731915; bh=LiSOVEk6j0lnEElTZRcxJ53LwB/7YbOnZLcgoUEWj24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmFymY0sdTal9FlDCfQdfk6O0AG+pMlZy1jsHpc3yrkEVj2ksKsuMSEg1N6/u8PIZ
	 QOvqRBnHaGRcu3wqAPVLd3wN/sjd7gW8sDzQfL2pvBBheZlJ/I5j8F5ri1hdUaKCG9
	 PVJb5nC0iYtQYNszxPMKrDA7hyXMObNY1sWsCl4Q=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 01/13] KVM: arm64: HDBSS bits
Date: Mon, 29 Jun 2026 12:17:49 +0100
Message-ID: <20260629111820.1873540-2-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629111820.1873540-1-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11057; i=leo.bras@arm.com; h=from:subject; bh=LiSOVEk6j0lnEElTZRcxJ53LwB/7YbOnZLcgoUEWj24=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQhIuTb0V9iIu9Qzz5srY5vVvzZesWcFo35tg7BT7e /dFT8d3HaUsDGJcDLJiiiyyj+av4vk+JePIlR8LYOawMoEMYeDiFICJ8H5m+J8my2t/byKzvbJ1 3EPzX08sgqM2qetNTHp8uEVW8cyy9ysY/tk3JXqXvzy4qiSlfcmEl1PvOcbmyU3sr6xZOf1UT0B 0Iz8A
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

All those bits should come from a future version of HDBSS patchset:
https://lore.kernel.org/lkml/20260225040421.2683931-1-zhengtian10@huawei.com

I added them here in order to fulfill the dependencies and be able to
easily build this patchset, but this particular patch should not be merged
upstream.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/cpufeature.h    |  5 +++++
 arch/arm64/include/asm/kvm_dirty_bit.h | 12 ++++++++++++
 arch/arm64/include/asm/kvm_pgtable.h   |  3 +++
 arch/arm64/kernel/cpufeature.c         | 12 ++++++++++++
 arch/arm64/kvm/dirty_bit.c             | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c           | 15 +++++++++++++--
 arch/arm64/kvm/Makefile                |  2 +-
 arch/arm64/tools/cpucaps               |  1 +
 8 files changed, 63 insertions(+), 3 deletions(-)
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
index 91a7dfad6686..e16729f0b7bd 100644
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
 	ret = stage2_set_xn_attr(prot, &xn);
 	if (ret)
 		return ret;
 
 	set |= xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
 	clr |= ~xn & KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
@@ -1578,20 +1586,23 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
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
2.54.0

