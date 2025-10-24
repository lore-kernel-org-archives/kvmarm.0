Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDA427FD52
	for <kvmarm@lists.linux.dev>; Fri, 24 Oct 2025 04:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761278547; cv=none; b=Ja+GnX16hF43DT7wBADDJRfb8dc8sOZOmNPbgQ3ieHNpuw6MzQAjywFMRQPJWgcNEvabjSULsF6Zf4xbY2LEYOAMt1gmt0UkSClbxBBnV1ZRRn26wRvWbXKw+ccRkQ+dSVj40FMDhjPhmf4ustDzGsbjq4/avK4cltYesn2JmkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761278547; c=relaxed/simple;
	bh=p1x3yfNabVQuscvbTifWqUUt0Hxg5hMFTO56+9c3QuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KGR02S1xhBJpF0hir1n0gdFES9RahSMJ/BMU4e/fOkh1OizB5ZJyBEJ7yCjVODEFFB3pYhABYbCR4zt/C8lHqvR1Nr8770u1mUto4liygepy32vWSaChEc3ceIDXnJGkIH8X9Cptaq9+6cMnjbScS/1nGtwyLDu/ERH2iQ3tROw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B9AF1D13;
	Thu, 23 Oct 2025 21:02:17 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4E5213F59E;
	Thu, 23 Oct 2025 21:02:23 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: ben.horgan@arm.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH V2 2/2] arm64/mm: Add remaining TLBI_XXX_MASK macros
Date: Fri, 24 Oct 2025 05:02:07 +0100
Message-Id: <20251024040207.137480-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251024040207.137480-1-anshuman.khandual@arm.com>
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add remaining TLBI_XXX_MASK macros and replace current open encoded fields.
While here replace hard coded page size based shifts but with derived ones
via ilog2() thus adding some required context.

TLBI_TTL_MASK has been split into separate TLBI_TTL_MASK and TLBI_TG_MASK
as appropriate because currently it simultaneously contains both page size
and translation table level information. KVM on arm64 has been updated to
accommodate these changes to TLBI_TTL_MASK.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 26 ++++++++++++++++++--------
 arch/arm64/kvm/nested.c           |  8 +++++---
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 131096094f5b..cf75fc2a06c3 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -57,9 +57,10 @@
 /* This macro creates a properly formatted VA operand for the TLBI */
 #define __TLBI_VADDR(addr, asid)				\
 	({							\
-		unsigned long __ta = (addr) >> 12;		\
-		__ta &= GENMASK_ULL(43, 0);			\
-		__ta |= (unsigned long)(asid) << 48;		\
+		unsigned long __ta = (addr) >> ilog2(SZ_4K);	\
+		__ta &= TLBI_BADDR_MASK;			\
+		__ta &= ~TLBI_ASID_MASK;			\
+		__ta |= FIELD_PREP(TLBI_ASID_MASK, asid);	\
 		__ta;						\
 	})
 
@@ -100,8 +101,17 @@ static inline unsigned long get_trans_granule(void)
  *
  * For Stage-2 invalidation, use the level values provided to that effect
  * in asm/stage2_pgtable.h.
+ *
+ * +----------+------+-------+--------------------------------------+
+ * |   ASID   |  TG  |  TTL  |                 BADDR                |
+ * +-----------------+-------+--------------------------------------+
+ * |63      48|47  46|45   44|43                                   0|
+ * +----------+------+-------+--------------------------------------+
  */
-#define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
+#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
+#define TLBI_TG_MASK		GENMASK_ULL(47, 46)
+#define TLBI_TTL_MASK		GENMASK_ULL(45, 44)
+#define TLBI_BADDR_MASK		GENMASK_ULL(43, 0)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
@@ -110,10 +120,10 @@ static inline unsigned long get_trans_granule(void)
 									\
 	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) &&	\
 	    level >= 0 && level <= 3) {					\
-		u64 ttl = level;					\
-		ttl |= get_trans_granule() << 2;			\
+		arg &= ~TLBI_TG_MASK;					\
+		arg |= FIELD_PREP(TLBI_TG_MASK, get_trans_granule());	\
 		arg &= ~TLBI_TTL_MASK;					\
-		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);			\
+		arg |= FIELD_PREP(TLBI_TTL_MASK, level);		\
 	}								\
 									\
 	__tlbi(op, arg);						\
@@ -383,7 +393,7 @@ do {									\
 	typeof(pages) __flush_pages = pages;				\
 	int num = 0;							\
 	int scale = 3;							\
-	int shift = lpa2 ? 16 : PAGE_SHIFT;				\
+	int shift = lpa2 ? ilog2(SZ_64K) : PAGE_SHIFT;			\
 	unsigned long addr;						\
 									\
 	while (__flush_pages > 0) {					\
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f04cda40545b..614629179333 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -540,7 +540,7 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 	unsigned long max_size;
 	u8 ttl;
 
-	ttl = FIELD_GET(TLBI_TTL_MASK, val);
+	ttl = FIELD_GET(TLBI_TTL_MASK, val) | FIELD_GET(TLBI_TG_MASK, val) << 2;
 
 	if (!ttl || !kvm_has_feat(kvm, ID_AA64MMFR2_EL1, TTL, IMP)) {
 		/* No TTL, check the shadow S2 for a hint */
@@ -963,7 +963,8 @@ static void compute_s1_tlbi_range(struct kvm_vcpu *vcpu, u32 inst, u64 val,
 	case OP_TLBI_VALE1ISNXS:
 	case OP_TLBI_VALE1OSNXS:
 		scope->type = TLBI_VA;
-		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
+		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val) |
+					  FIELD_GET(TLBI_TG_MASK, val) << 2);
 		if (!scope->size)
 			scope->size = SZ_1G;
 		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
@@ -991,7 +992,8 @@ static void compute_s1_tlbi_range(struct kvm_vcpu *vcpu, u32 inst, u64 val,
 	case OP_TLBI_VAALE1ISNXS:
 	case OP_TLBI_VAALE1OSNXS:
 		scope->type = TLBI_VAA;
-		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
+		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val) |
+					  FIELD_GET(TLBI_TG_MASK, val) << 2);
 		if (!scope->size)
 			scope->size = SZ_1G;
 		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
-- 
2.30.2

