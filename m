Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA05BC47090
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98C8F4B63A;
	Tue,  6 Dec 2022 09:00:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id io5aUr7Nb6ox; Tue,  6 Dec 2022 09:00:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 379AA4B3CA;
	Tue,  6 Dec 2022 09:00:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26EF240B6C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Om3lJXEIFRlx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 09:00:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8A84B3CA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:16 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A063D6E;
 Tue,  6 Dec 2022 06:00:22 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 216D23F73D;
 Tue,  6 Dec 2022 06:00:14 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 07/12] KVM: arm64: Use LPA2 page-tables for hyp stage1 if
 HW supports it
Date: Tue,  6 Dec 2022 13:59:25 +0000
Message-Id: <20221206135930.3277585-8-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
page size we are using, always use LPA2-style page-tables for hyp stage
1, regardless of the IPA or PA size requirements. When in use we can now
support up to 52-bit IPA and PA sizes.

For the protected kvm case, the host creates the initial page-tables
using either the lpa2 or `classic` format as determined by whats
reported in mmfr0 and also sets the TCR_EL2.DS bit in the params
structure. The hypervisor then looks at this DS bit to determine the
format that it should use to re-create the page-tables.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++++++-
 arch/arm64/kvm/arm.c                 |  2 ++
 arch/arm64/kvm/hyp/nvhe/setup.c      | 18 +++++++++++++-----
 arch/arm64/kvm/hyp/pgtable.c         |  7 ++++---
 arch/arm64/kvm/mmu.c                 |  3 ++-
 5 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index a7fd547dcc71..d6f4dcdd00fd 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,6 +25,21 @@
 #define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
 #endif
 
+static inline bool kvm_supports_hyp_lpa2(void)
+{
+#if defined(CONFIG_ARM64_4K_PAGES) || defined(CONFIG_ARM64_16K_PAGES)
+	u64 mmfr0;
+	unsigned int tgran;
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
+						ID_AA64MMFR0_EL1_TGRAN_SHIFT);
+	return (tgran == ID_AA64MMFR0_EL1_TGRAN_LPA2);
+#else
+	return false;
+#endif
+}
+
 static inline bool kvm_supports_stage2_lpa2(u64 mmfr0)
 {
 	unsigned int tgran;
@@ -253,11 +268,12 @@ struct kvm_pgtable_walker {
  * @pgt:	Uninitialised page-table structure to initialise.
  * @va_bits:	Maximum virtual address bits.
  * @mm_ops:	Memory management callbacks.
+ * @lpa2_ena:	Whether to use the lpa2 page-table format.
  *
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
-			 struct kvm_pgtable_mm_ops *mm_ops);
+			 struct kvm_pgtable_mm_ops *mm_ops, bool lpa2_ena);
 
 /**
  * kvm_pgtable_hyp_destroy() - Destroy an unused hypervisor stage-1 page-table.
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 803055da3ee3..a234c6252c3c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1537,6 +1537,8 @@ static void cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
+	if (kvm_supports_hyp_lpa2())
+		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
 
 	params->pgd_pa = kvm_mmu_get_httbr();
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 60a6821ae98a..b44e87b9d168 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -56,7 +56,7 @@ static int divide_memory_pool(void *virt, unsigned long size)
 
 static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 				 unsigned long *per_cpu_base,
-				 u32 hyp_va_bits)
+				 u32 hyp_va_bits, bool lpa2_ena)
 {
 	void *start, *end, *virt = hyp_phys_to_virt(phys);
 	unsigned long pgt_size = hyp_s1_pgtable_pages() << PAGE_SHIFT;
@@ -66,7 +66,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	/* Recreate the hyp page-table using the early page allocator */
 	hyp_early_alloc_init(hyp_pgt_base, pgt_size);
 	ret = kvm_pgtable_hyp_init(&pkvm_pgtable, hyp_va_bits,
-				   &hyp_early_alloc_mm_ops);
+				   &hyp_early_alloc_mm_ops, lpa2_ena);
 	if (ret)
 		return ret;
 
@@ -304,10 +304,11 @@ void __noreturn __pkvm_init_finalise(void)
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits)
 {
-	struct kvm_nvhe_init_params *params;
+	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
 	void *virt = hyp_phys_to_virt(phys);
 	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
 	int ret;
+	bool lpa2_ena;
 
 	BUG_ON(kvm_check_pvm_sysreg_table());
 
@@ -321,14 +322,21 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 	if (ret)
 		return ret;
 
-	ret = recreate_hyp_mappings(phys, size, per_cpu_base, hyp_va_bits);
+	/*
+	 * The host has already done the hard work to figure out if LPA2 is
+	 * supported at stage 1 and passed the info in the in the DS bit of the
+	 * TCR. Extract and pass on so that the page-tables are constructed with
+	 * the correct format.
+	 */
+	lpa2_ena = (params->tcr_el2 & TCR_EL2_DS) != 0;
+	ret = recreate_hyp_mappings(phys, size, per_cpu_base,
+				    hyp_va_bits, lpa2_ena);
 	if (ret)
 		return ret;
 
 	update_nvhe_init_params();
 
 	/* Jump in the idmap page to switch to the new page-tables */
-	params = this_cpu_ptr(&kvm_init_params);
 	fn = (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
 	fn(__hyp_pa(params), __pkvm_init_finalise);
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 8ed7353f07bc..cde852f91db8 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -369,7 +369,8 @@ static int hyp_set_prot_attr(struct kvm_pgtable *pgt,
 	}
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
-	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
+	if (!pgt->lpa2_ena)
+		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
@@ -528,7 +529,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 }
 
 int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
-			 struct kvm_pgtable_mm_ops *mm_ops)
+			 struct kvm_pgtable_mm_ops *mm_ops, bool lpa2_ena)
 {
 	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
 
@@ -539,7 +540,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	pgt->ia_bits		= va_bits;
 	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
 	pgt->mm_ops		= mm_ops;
-	pgt->lpa2_ena		= false;
+	pgt->lpa2_ena		= lpa2_ena;
 	pgt->mmu		= NULL;
 	pgt->force_pte_cb	= NULL;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e3fe3e194fd1..13e48539f022 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1684,7 +1684,8 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 		goto out;
 	}
 
-	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits, &kvm_hyp_mm_ops);
+	err = kvm_pgtable_hyp_init(hyp_pgtable, *hyp_va_bits,
+				   &kvm_hyp_mm_ops, kvm_supports_hyp_lpa2());
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
