Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436B4FBE3
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC9651477;
	Mon,  9 Oct 2023 11:51:08 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 697233F5A1;
	Mon,  9 Oct 2023 11:50:26 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v4 06/12] KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
Date: Mon,  9 Oct 2023 19:50:02 +0100
Message-Id: <20231009185008.3803879-7-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009185008.3803879-1-ryan.roberts@arm.com>
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
page size we are using, always use LPA2-style page-tables for stage 2
and hyp stage 1, regardless of the VMM-requested IPA size or
HW-implemented PA size. When in use we can now support up to 52-bit IPA
and PA sizes.

We use the previously created cpu feature to track whether LPA2 is
supported for deciding whether to use the LPA2 or classic pte format.

Note that FEAT_LPA2 brings support for bigger block mappings (512GB with
4KB, 64GB with 16KB). We explicitly don't enable these in the library
because stage2_apply_range() works on batch sizes of the largest used
block mapping, and increasing the size of the batch would lead to soft
lockups. See commit 5994bc9e05c2 ("KVM: arm64: Limit
stage2_apply_range() batch size to largest block").

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 47 +++++++++++++++++++++-------
 arch/arm64/kvm/arm.c                 |  2 ++
 arch/arm64/kvm/hyp/nvhe/tlb.c        |  3 +-
 arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++--
 arch/arm64/kvm/hyp/vhe/tlb.c         |  3 +-
 5 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d3e354bb8351..b240158e1218 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,12 +25,22 @@
 #define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
 #endif
 
+static inline u64 kvm_get_parange_max(void)
+{
+	if (system_supports_lpa2() ||
+	   (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && PAGE_SIZE == SZ_64K))
+		return ID_AA64MMFR0_EL1_PARANGE_52;
+	else
+		return ID_AA64MMFR0_EL1_PARANGE_48;
+}
+
 static inline u64 kvm_get_parange(u64 mmfr0)
 {
+	u64 parange_max = kvm_get_parange_max();
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
 				ID_AA64MMFR0_EL1_PARANGE_SHIFT);
-	if (parange > ID_AA64MMFR0_EL1_PARANGE_MAX)
-		parange = ID_AA64MMFR0_EL1_PARANGE_MAX;
+	if (parange > parange_max)
+		parange = parange_max;
 
 	return parange;
 }
@@ -41,6 +51,8 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
 #define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
+#define KVM_PTE_ADDR_MASK_LPA2		GENMASK(49, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_50_LPA2		GENMASK(9, 8)
 
 #define KVM_PHYS_INVALID		(-1ULL)
 
@@ -51,21 +63,34 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
 
 static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
 {
-	u64 pa = pte & KVM_PTE_ADDR_MASK;
-
-	if (PAGE_SHIFT == 16)
-		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
+	u64 pa;
+
+	if (system_supports_lpa2()) {
+		pa = pte & KVM_PTE_ADDR_MASK_LPA2;
+		pa |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;
+	} else {
+		pa = pte & KVM_PTE_ADDR_MASK;
+		if (PAGE_SHIFT == 16)
+			pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
+	}
 
 	return pa;
 }
 
 static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
 {
-	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
-
-	if (PAGE_SHIFT == 16) {
-		pa &= GENMASK(51, 48);
-		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
+	kvm_pte_t pte;
+
+	if (system_supports_lpa2()) {
+		pte = pa & KVM_PTE_ADDR_MASK_LPA2;
+		pa &= GENMASK(51, 50);
+		pte |= FIELD_PREP(KVM_PTE_ADDR_51_50_LPA2, pa >> 50);
+	} else {
+		pte = pa & KVM_PTE_ADDR_MASK;
+		if (PAGE_SHIFT == 16) {
+			pa &= GENMASK(51, 48);
+			pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
+		}
 	}
 
 	return pte;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..73cc67c2a8a7 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1747,6 +1747,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	}
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
+	if (system_supports_lpa2())
+		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
 
 	params->pgd_pa = kvm_mmu_get_httbr();
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d42b72f78a9b..c3cd16c6f95f 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -198,7 +198,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt, false);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0,
+				system_supports_lpa2());
 
 	dsb(ish);
 	__tlbi(vmalle1is);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f155b8c9e98c..062eb7bcdb8a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -79,7 +79,10 @@ static bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
 
 static bool kvm_phys_is_valid(u64 phys)
 {
-	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
+	u64 parange_max = kvm_get_parange_max();
+	u8 shift = id_aa64mmfr0_parange_to_phys_shift(parange_max);
+
+	return phys < BIT(shift);
 }
 
 static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx, u64 phys)
@@ -408,7 +411,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	}
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
-	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
+	if (!system_supports_lpa2())
+		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
@@ -654,6 +658,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 		vtcr |= VTCR_EL2_HA;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 
+	if (system_supports_lpa2())
+		vtcr |= VTCR_EL2_DS;
+
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
 		VTCR_EL2_VS_16BIT :
@@ -711,7 +718,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
-	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+	if (!system_supports_lpa2())
+		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 6041c6c78984..40cea2482a76 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -161,7 +161,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0,
+				system_supports_lpa2());
 
 	dsb(ish);
 	__tlbi(vmalle1is);
-- 
2.25.1

