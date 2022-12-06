Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D619FC4708E
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD744B355;
	Tue,  6 Dec 2022 09:00:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RJyvnpU-LhMz; Tue,  6 Dec 2022 09:00:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0914B5E8;
	Tue,  6 Dec 2022 09:00:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7D24B3F5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8N+tkJvxHAOv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 09:00:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1514B5EE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B20C143D;
 Tue,  6 Dec 2022 06:00:20 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 428383F73D;
 Tue,  6 Dec 2022 06:00:12 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 06/12] KVM: arm64: Use LPA2 page-tables for stage2 if HW
 supports it
Date: Tue,  6 Dec 2022 13:59:24 +0000
Message-Id: <20221206135930.3277585-7-ryan.roberts@arm.com>
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
page size we are using, always use LPA2-style page-tables for stage 2,
regardless of the VMM-requested IPA size or HW-implemented PA size. When
in use we can now support up to 52-bit IPA and PA sizes.

We use the preparitory work that tracks the page-table format in struct
kvm_pgtable and passes the pgt pointer to all kvm_pgtable functions that
need to modify their behavior based on the format.

Note that FEAT_LPA2 brings support for bigger block mappings (512GB with
4KB, 64GB with 16KB). We explicitly don't enable these in the library
because stage2_apply_range() works on batch sizes of the largest used
block mapping, and increasing the size of the batch would lead to soft
lockups. See commit 5994bc9e05c2 ("KVM: arm64: Limit
stage2_apply_range() batch size to largest block").

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 42 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 12 +++----
 arch/arm64/kvm/hyp/pgtable.c          | 45 ++++++++++++++++++++++-----
 3 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 744e224d964b..a7fd547dcc71 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,12 +25,32 @@
 #define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
 #endif
 
-static inline u64 kvm_get_parange(u64 mmfr0)
+static inline bool kvm_supports_stage2_lpa2(u64 mmfr0)
 {
+	unsigned int tgran;
+
+	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
+						ID_AA64MMFR0_EL1_TGRAN_2_SHIFT);
+	return (tgran == ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2 &&
+		PAGE_SIZE != SZ_64K);
+}
+
+static inline u64 kvm_get_parange_max(bool lpa2_ena)
+{
+	if (lpa2_ena ||
+	   (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && PAGE_SIZE == SZ_64K))
+		return ID_AA64MMFR0_EL1_PARANGE_52;
+	else
+		return ID_AA64MMFR0_EL1_PARANGE_48;
+}
+
+static inline u64 kvm_get_parange(u64 mmfr0, bool lpa2_ena)
+{
+	u64 parange_max = kvm_get_parange_max(lpa2_ena);
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
 				ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	if (parange > ID_AA64MMFR0_EL1_PARANGE_MAX)
-		parange = ID_AA64MMFR0_EL1_PARANGE_MAX;
+	if (parange > parange_max)
+		parange = parange_max;
 
 	return parange;
 }
@@ -41,6 +61,8 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
 #define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
+#define KVM_PTE_ADDR_MASK_LPA2		GENMASK(49, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_50_LPA2		GENMASK(9, 8)
 
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
@@ -178,10 +200,16 @@ struct kvm_pgtable {
 
 static inline u64 kvm_pte_to_phys(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
-	u64 pa = pte & KVM_PTE_ADDR_MASK;
+	u64 pa;
 
-	if (PAGE_SHIFT == 16)
-		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
+	if (pgt->lpa2_ena) {
+		pa = pte & KVM_PTE_ADDR_MASK_LPA2;
+		pa |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;
+	} else {
+		pa = pte & KVM_PTE_ADDR_MASK;
+		if (PAGE_SHIFT == 16)
+			pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
+	}
 
 	return pa;
 }
@@ -287,7 +315,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_get_vtcr() - Helper to construct VTCR_EL2
  * @mmfr0:	Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
  * @mmfr1:	Sanitized value of SYS_ID_AA64MMFR1_EL1 register.
- * @phys_shfit:	Value to set in VTCR_EL2.T0SZ.
+ * @phys_shift:	Value to set in VTCR_EL2.T0SZ, or 0 to infer from parange.
  *
  * The VTCR value is common across all the physical CPUs on the system.
  * We use system wide sanitised values to fill in different fields,
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 6bf54c8daffa..43e729694deb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -105,14 +105,12 @@ static int prepare_s2_pool(void *pgt_pool_base)
 
 static void prepare_host_vtcr(void)
 {
-	u32 parange, phys_shift;
-
-	/* The host stage 2 is id-mapped, so use parange for T0SZ */
-	parange = kvm_get_parange(id_aa64mmfr0_el1_sys_val);
-	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
-
+	/*
+	 * The host stage 2 is id-mapped; passing phys_shift=0 forces parange to
+	 * be used for T0SZ.
+	 */
 	host_kvm.arch.vtcr = kvm_get_vtcr(id_aa64mmfr0_el1_sys_val,
-					  id_aa64mmfr1_el1_sys_val, phys_shift);
+					  id_aa64mmfr1_el1_sys_val, 0);
 }
 
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c7799cd50af8..8ed7353f07bc 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -61,7 +61,10 @@ struct kvm_pgtable_walk_data {
 
 static bool kvm_phys_is_valid(struct kvm_pgtable *pgt, u64 phys)
 {
-	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
+	u64 parange_max = kvm_get_parange_max(pgt->lpa2_ena);
+	u8 shift = id_aa64mmfr0_parange_to_phys_shift(parange_max);
+
+	return phys < BIT(shift);
 }
 
 static bool kvm_block_mapping_supported(struct kvm_pgtable *pgt,
@@ -125,10 +128,16 @@ static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 
 static kvm_pte_t kvm_phys_to_pte(struct kvm_pgtable *pgt, u64 pa)
 {
-	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
+	kvm_pte_t pte;
 
-	if (PAGE_SHIFT == 16)
-		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
+	if (pgt->lpa2_ena) {
+		pte = pa & KVM_PTE_ADDR_MASK_LPA2;
+		pte |= FIELD_PREP(KVM_PTE_ADDR_51_50_LPA2, pa >> 50);
+	} else {
+		pte = pa & KVM_PTE_ADDR_MASK;
+		if (PAGE_SHIFT == 16)
+			pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
+	}
 
 	return pte;
 }
@@ -585,8 +594,24 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	u8 lvls;
+	u64 parange;
+	bool lpa2_ena = false;
+
+	/*
+	 * If stage 2 reports that it supports FEAT_LPA2 for our page size, then
+	 * we always use the LPA2 format regardless of IA and OA size.
+	 */
+	lpa2_ena = kvm_supports_stage2_lpa2(mmfr0);
+
+	parange = kvm_get_parange(mmfr0, lpa2_ena);
 
-	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
+	/*
+	 * Infer IPA size to be equal to PA size if phys_shift is 0.
+	 */
+	if (phys_shift == 0)
+		phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
+
+	vtcr |= parange << VTCR_EL2_PS_SHIFT;
 	vtcr |= VTCR_EL2_T0SZ(phys_shift);
 	/*
 	 * Use a minimum 2 level page table to prevent splitting
@@ -604,6 +629,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	 */
 	vtcr |= VTCR_EL2_HA;
 
+	if (lpa2_ena)
+		vtcr |= VTCR_EL2_DS;
+
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
 		VTCR_EL2_VS_16BIT :
@@ -641,7 +669,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
-	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+	if (!pgt->lpa2_ena)
+		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
@@ -1182,6 +1212,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
+	bool lpa2_ena = (vtcr & VTCR_EL2_DS) != 0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
 	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
@@ -1191,7 +1222,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
-	pgt->lpa2_ena		= false;
+	pgt->lpa2_ena		= lpa2_ena;
 	pgt->mmu		= mmu;
 	pgt->flags		= flags;
 	pgt->force_pte_cb	= force_pte_cb;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
