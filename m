Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A551C4708C
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D517D4B628;
	Tue,  6 Dec 2022 09:00:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xOM68hzHfLqk; Tue,  6 Dec 2022 09:00:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB9014B63E;
	Tue,  6 Dec 2022 09:00:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B94B40B6C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LyG7N+zElBHT for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 09:00:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDA3A4B62F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17BDE113E;
 Tue,  6 Dec 2022 06:00:28 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B33A93F73D;
 Tue,  6 Dec 2022 06:00:19 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 10/12] KVM: arm64: Rework logic to en/decode VTCR_EL2.{SL0,
 SL2} fields
Date: Tue,  6 Dec 2022 13:59:28 +0000
Message-Id: <20221206135930.3277585-11-ryan.roberts@arm.com>
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

In order to support 5 level translation, FEAT_LPA2 introduces the 1-bit
SL2 field within VTCR_EL2 to extend the existing 2-bit SL0 field. The
SL2[0]:SL0[1:0] encodings have no simple algorithmic relationship to the
start levels they represent (that I can find, at least), so replace the
existing macros with functions that do lookups to encode and decode the
values. These new functions no longer make hardcoded assumptions about
the maximum level and instead rely on KVM_PGTABLE_FIRST_LEVEL and
KVM_PGTABLE_LAST_LEVEL.

This is preparatory work for enabling 52-bit IPA for 4KB and 16KB pages
with FEAT_LPA2.

No functional change intended.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h        | 75 ++++++++++++++-----------
 arch/arm64/include/asm/kvm_pgtable.h    | 33 +++++++++++
 arch/arm64/include/asm/stage2_pgtable.h | 13 ++++-
 arch/arm64/kvm/hyp/pgtable.c            | 67 +++++++++++++++++++++-
 4 files changed, 150 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index f9619a10d5d9..94bbb05e348f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -150,58 +150,65 @@
 				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
 
 /*
- * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
- * Interestingly, it depends on the page size.
- * See D.10.2.121, VTCR_EL2, in ARM DDI 0487C.a
+ * VTCR_EL2.{SL0, SL2} indicates the entry level for Stage2 translation.
+ * Interestingly, it depends on the page size. See D17.2.157, VTCR_EL2, in ARM
+ * DDI 0487I.a
  *
- *	-----------------------------------------
- *	| Entry level		|  4K  | 16K/64K |
- *	------------------------------------------
- *	| Level: 0		|  2   |   -     |
- *	------------------------------------------
- *	| Level: 1		|  1   |   2     |
- *	------------------------------------------
- *	| Level: 2		|  0   |   1     |
- *	------------------------------------------
- *	| Level: 3		|  -   |   0     |
- *	------------------------------------------
+ *      ----------------------------------------------------------
+ *      | Entry level           |    4K    |    16K   |    64K   |
+ *      |                       |  SL2:SL0 |  SL2:SL0 |  SL2:SL0 |
+ *      ----------------------------------------------------------
+ *      | Level: -1             |  0b100   |     -    |     -    |
+ *      ----------------------------------------------------------
+ *      | Level: 0              |  0b010   |  0b011   |     -    |
+ *      ----------------------------------------------------------
+ *      | Level: 1              |  0b001   |  0b010   |  0b010   |
+ *      ----------------------------------------------------------
+ *      | Level: 2              |  0b000   |  0b001   |  0b001   |
+ *      ----------------------------------------------------------
+ *      | Level: 3              |  0b011   |  0b000   |  0b000   |
+ *      ----------------------------------------------------------
  *
- * The table roughly translates to :
- *
- *	SL0(PAGE_SIZE, Entry_level) = TGRAN_SL0_BASE - Entry_Level
- *
- * Where TGRAN_SL0_BASE is a magic number depending on the page size:
- * 	TGRAN_SL0_BASE(4K) = 2
- *	TGRAN_SL0_BASE(16K) = 3
- *	TGRAN_SL0_BASE(64K) = 3
- * provided we take care of ruling out the unsupported cases and
- * Entry_Level = 4 - Number_of_levels.
+ * There is no concise algorithm to convert between the SLx encodings and the
+ * level numbers, so we implement 2 helpers kvm_vtcr_el2_sl_encode()
+ * kvm_vtcr_el2_sl_decode() which can convert between the representations. These
+ * helpers use a concatenated form of SLx: SL2[0]:SL0[1:0] as the 3 LSBs in u8.
+ * If an invalid input value is provided, VTCR_EL2_SLx_ENC_INVAL is returned. We
+ * declare the appropriate encoded values here for the compiled in page size.
  *
+ * See kvm_pgtable.h for documentation on the helpers.
  */
+#define VTCR_EL2_SLx_ENC_INVAL		255
+
 #ifdef CONFIG_ARM64_64K_PAGES
 
 #define VTCR_EL2_TGRAN			VTCR_EL2_TG0_64K
-#define VTCR_EL2_TGRAN_SL0_BASE		3UL
+#define VTCR_EL2_SLx_ENC_Lm1		VTCR_EL2_SLx_ENC_INVAL
+#define VTCR_EL2_SLx_ENC_L0		VTCR_EL2_SLx_ENC_INVAL
+#define VTCR_EL2_SLx_ENC_Lp1		2
+#define VTCR_EL2_SLx_ENC_Lp2		1
+#define VTCR_EL2_SLx_ENC_Lp3		0
 
 #elif defined(CONFIG_ARM64_16K_PAGES)
 
 #define VTCR_EL2_TGRAN			VTCR_EL2_TG0_16K
-#define VTCR_EL2_TGRAN_SL0_BASE		3UL
+#define VTCR_EL2_SLx_ENC_Lm1		VTCR_EL2_SLx_ENC_INVAL
+#define VTCR_EL2_SLx_ENC_L0		3
+#define VTCR_EL2_SLx_ENC_Lp1		2
+#define VTCR_EL2_SLx_ENC_Lp2		1
+#define VTCR_EL2_SLx_ENC_Lp3		0
 
 #else	/* 4K */
 
 #define VTCR_EL2_TGRAN			VTCR_EL2_TG0_4K
-#define VTCR_EL2_TGRAN_SL0_BASE		2UL
+#define VTCR_EL2_SLx_ENC_Lm1		4
+#define VTCR_EL2_SLx_ENC_L0		2
+#define VTCR_EL2_SLx_ENC_Lp1		1
+#define VTCR_EL2_SLx_ENC_Lp2		0
+#define VTCR_EL2_SLx_ENC_Lp3		3
 
 #endif
 
-#define VTCR_EL2_LVLS_TO_SL0(levels)	\
-	((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
-#define VTCR_EL2_SL0_TO_LVLS(sl0)	\
-	((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
-#define VTCR_EL2_LVLS(vtcr)		\
-	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
-
 #define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
 #define VTCR_EL2_IPA(vtcr)		(64 - ((vtcr) & VTCR_EL2_T0SZ_MASK))
 
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index a282a3d5ddbc..3e0b64052c51 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -328,6 +328,39 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
  */
 u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
 
+/**
+ * kvm_vtcr_el2_sl_encode() - Helper to encode start level for vtcr_el2.
+ * @sl_dec:     Start level to be encoded.
+ *
+ * Takes an unencoded translation start level value and returns it encoded for
+ * use in vtcr_el2 register. The returned value has SL0 (a 2 bit field) in bits
+ * [1:0] and SL2 (a 1 bit field) in bit [2]. The user is responsible for
+ * extracting and packing in the correct locations of vctr_el2.
+ *
+ * Do not call this function with a value that is out of range for the page size
+ * in operation. A warning will be output if this is detected and the function
+ * returns VTCR_EL2_SLx_ENC_INVAL. See comment in kvm_arm.h for more info.
+ *
+ * Return: 3 bit value containing SL2[0]:SL0[1:0], or VTCR_EL2_SLx_ENC_INVAL.
+ */
+u8 kvm_vtcr_el2_sl_encode(s8 sl_dec);
+
+/**
+ * kvm_vtcr_el2_sl_decode() - Helper to decode start level for vtcr_el2.
+ * @sl_enc:     Start level encoded as SL2[0]:SL0[1:0].
+ *
+ * Takes an encoded translation start level value, as used in the vtcr_el2
+ * register and returns it decoded. See kvm_vtcr_el2_sl_encode() for description
+ * of input encoding.
+ *
+ * Do not call this function with a value that is invalid for the page size in
+ * operation. A warning will be output if this is detected and the function
+ * returns VTCR_EL2_SLx_ENC_INVAL. See comment in kvm_arm.h for more info.
+ *
+ * Return: Decoded start level, or VTCR_EL2_SLx_ENC_INVAL.
+ */
+s8 kvm_vtcr_el2_sl_decode(u8 sl_enc);
+
 /**
  * kvm_get_vtcr() - Helper to construct VTCR_EL2
  * @mmfr0:	Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index c8dca8ae359c..02c5e04d4958 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -21,7 +21,18 @@
  * (IPA_SHIFT - 4).
  */
 #define stage2_pgtable_levels(ipa)	ARM64_HW_PGTABLE_LEVELS((ipa) - 4)
-#define kvm_stage2_levels(kvm)		VTCR_EL2_LVLS(kvm->arch.vtcr)
+static inline s8 kvm_stage2_levels(struct kvm *kvm)
+{
+	u64 vtcr = kvm->arch.vtcr;
+	u8 slx;
+	s8 start_level;
+
+	slx = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
+	slx |= FIELD_GET(VTCR_EL2_SL2_MASK, vtcr) << 2;
+	start_level = kvm_vtcr_el2_sl_decode(slx);
+
+	return KVM_PGTABLE_LAST_LEVEL + 1 - start_level;
+}
 
 /*
  * kvm_mmmu_cache_min_pages() is the number of pages required to install
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 274f839bd0d7..8ebd9aaed2c4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -595,12 +595,67 @@ struct stage2_map_data {
 	bool				force_pte;
 };
 
+u8 kvm_vtcr_el2_sl_encode(s8 sl_dec)
+{
+	u8 sl_enc = VTCR_EL2_SLx_ENC_INVAL;
+
+	BUILD_BUG_ON(KVM_PGTABLE_FIRST_LEVEL < -1);
+	BUILD_BUG_ON(KVM_PGTABLE_LAST_LEVEL > 3);
+
+	switch (sl_dec) {
+	case -1:
+		sl_enc = VTCR_EL2_SLx_ENC_Lm1;
+		break;
+	case 0:
+		sl_enc = VTCR_EL2_SLx_ENC_L0;
+		break;
+	case 1:
+		sl_enc = VTCR_EL2_SLx_ENC_Lp1;
+		break;
+	case 2:
+		sl_enc = VTCR_EL2_SLx_ENC_Lp2;
+		break;
+	case 3:
+		sl_enc = VTCR_EL2_SLx_ENC_Lp3;
+		break;
+	}
+
+	WARN_ON_ONCE(sl_enc == VTCR_EL2_SLx_ENC_INVAL);
+	return sl_enc;
+}
+
+s8 kvm_vtcr_el2_sl_decode(u8 sl_enc)
+{
+	s8 sl_dec = VTCR_EL2_SLx_ENC_INVAL;
+
+	BUILD_BUG_ON(KVM_PGTABLE_FIRST_LEVEL < -1);
+	BUILD_BUG_ON(KVM_PGTABLE_LAST_LEVEL > 3);
+
+	if (sl_enc == VTCR_EL2_SLx_ENC_Lm1)
+		sl_dec = -1;
+	else if (sl_enc == VTCR_EL2_SLx_ENC_L0)
+		sl_dec = 0;
+	else if (sl_enc == VTCR_EL2_SLx_ENC_Lp1)
+		sl_dec = 1;
+	else if (sl_enc == VTCR_EL2_SLx_ENC_Lp2)
+		sl_dec = 2;
+	else if (sl_enc == VTCR_EL2_SLx_ENC_Lp3)
+		sl_dec = 3;
+
+	if (WARN_ON_ONCE(sl_dec == VTCR_EL2_SLx_ENC_INVAL ||
+			 sl_enc == VTCR_EL2_SLx_ENC_INVAL))
+		sl_dec = VTCR_EL2_SLx_ENC_INVAL;
+
+	return sl_dec;
+}
+
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
 	s8 levels;
 	u64 parange;
 	bool lpa2_ena = false;
+	u8 slx;
 
 	/*
 	 * If stage 2 reports that it supports FEAT_LPA2 for our page size, then
@@ -625,7 +680,9 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	levels = stage2_pgtable_levels(phys_shift);
 	if (levels < 2)
 		levels = 2;
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(levels);
+	slx = kvm_vtcr_el2_sl_encode(KVM_PGTABLE_LAST_LEVEL + 1 - levels);
+	vtcr |= FIELD_PREP(VTCR_EL2_SL0_MASK, slx);
+	vtcr |= FIELD_PREP(VTCR_EL2_SL2_MASK, slx >> 2);
 
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
@@ -1215,10 +1272,14 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	size_t pgd_sz;
 	u64 vtcr = mmu->arch->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
-	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
-	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
+	u8 slx;
+	s8 start_level;
 	bool lpa2_ena = (vtcr & VTCR_EL2_DS) != 0;
 
+	slx = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
+	slx |= FIELD_GET(VTCR_EL2_SL2_MASK, vtcr) << 2;
+	start_level = kvm_vtcr_el2_sl_decode(slx);
+
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
 	pgt->pgd = mm_ops->zalloc_pages_exact(pgd_sz);
 	if (!pgt->pgd)
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
