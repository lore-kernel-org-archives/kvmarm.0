Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BB46FD5
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 19:55:07 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F8531C14;
	Mon,  6 Mar 2023 11:55:50 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56A963F71A;
	Mon,  6 Mar 2023 11:55:05 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 05/12] KVM: arm64: Use LPA2 page-tables for stage2 if HW supports it
Date: Mon,  6 Mar 2023 19:54:31 +0000
Message-Id: <20230306195438.1557851-6-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306195438.1557851-1-ryan.roberts@arm.com>
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
page size we are using, always use LPA2-style page-tables for stage 2,
regardless of the VMM-requested IPA size or HW-implemented PA size. When
in use we can now support up to 52-bit IPA and PA sizes.

We use the previously created cpu feature to track whether LPA2 is
supported for deciding whether to use the LPA2 or classic pte format.

Note that FEAT_LPA2 brings support for bigger block mappings (512GB with
4KB, 64GB with 16KB). We explicitly don't enable these in the library
because stage2_apply_range() works on batch sizes of the largest used
block mapping, and increasing the size of the batch would lead to soft
lockups. See commit 5994bc9e05c2 ("KVM: arm64: Limit
stage2_apply_range() batch size to largest block").

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>

TMP
---
 arch/arm64/include/asm/kvm_pgtable.h | 47 +++++++++++++++++++++-------
 arch/arm64/kvm/hyp/pgtable.c         | 12 +++++--
 2 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..4164b336c1e7 100644
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
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..414a5dbf233d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -64,7 +64,10 @@ struct kvm_pgtable_walk_data {
 
 static bool kvm_phys_is_valid(u64 phys)
 {
-	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
+	u64 parange_max = kvm_get_parange_max();
+	u8 shift = id_aa64mmfr0_parange_to_phys_shift(parange_max);
+
+	return phys < BIT(shift);
 }
 
 static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx, u64 phys)
@@ -615,6 +618,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	vtcr |= VTCR_EL2_HA;
 #endif /* CONFIG_ARM64_HW_AFDBM */
 
+	if (system_supports_lpa2())
+		vtcr |= VTCR_EL2_DS;
+
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
 		VTCR_EL2_VS_16BIT :
@@ -652,7 +658,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
-	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+	if (!system_supports_lpa2())
+		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
+
 	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
-- 
2.25.1

