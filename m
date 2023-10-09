Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE73236B0E
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D446EC15;
	Mon,  9 Oct 2023 11:50:59 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90E4D3F5A1;
	Mon,  9 Oct 2023 11:50:17 -0700 (PDT)
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
Subject: [PATCH v4 01/12] arm64/mm: Update non-range tlb invalidation routines for FEAT_LPA2
Date: Mon,  9 Oct 2023 19:49:57 +0100
Message-Id: <20231009185008.3803879-2-ryan.roberts@arm.com>
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

FEAT_LPA2 impacts tlb invalidation in 2 ways; Firstly, the TTL field in
the non-range tlbi instructions can now validly take a 0 value for the
4KB granule (this is due to the extra level of translation). Secondly,
the BADDR field in the range tlbi instructions must be aligned to 64KB
when LPA2 is in use (TCR.DS=1). Changes are required for tlbi to
continue to operate correctly when LPA2 is in use.

KVM only uses the non-range (__tlbi_level()) routines. Therefore we only
solve the first problem with this patch.

It is solved by always adding the level hint if the level is between [0,
3] (previously anything other than 0 was hinted, which breaks in the new
level -1 case from kvm). When running on non-LPA2 HW, 0 is still safe to
hint as the HW will fall back to non-hinted. While we are at it, we
replace the notion of 0 being the non-hinted seninel with a macro,
TLBI_TTL_UNKNOWN. This means callers won't need updating if/when
translation depth increases in future.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/tlb.h      |  9 ++++---
 arch/arm64/include/asm/tlbflush.h | 43 +++++++++++++++++++------------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 2c29239d05c3..93c537635dbb 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -22,15 +22,16 @@ static void tlb_flush(struct mmu_gather *tlb);
 #include <asm-generic/tlb.h>
 
 /*
- * get the tlbi levels in arm64.  Default value is 0 if more than one
- * of cleared_* is set or neither is set.
+ * get the tlbi levels in arm64.  Default value is TLBI_TTL_UNKNOWN if more than
+ * one of cleared_* is set or neither is set - this elides the level hinting to
+ * the hardware.
  * Arm64 doesn't support p4ds now.
  */
 static inline int tlb_get_level(struct mmu_gather *tlb)
 {
 	/* The TTL field is only valid for the leaf entry. */
 	if (tlb->freed_tables)
-		return 0;
+		return TLBI_TTL_UNKNOWN;
 
 	if (tlb->cleared_ptes && !(tlb->cleared_pmds ||
 				   tlb->cleared_puds ||
@@ -47,7 +48,7 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
 				   tlb->cleared_p4ds))
 		return 1;
 
-	return 0;
+	return TLBI_TTL_UNKNOWN;
 }
 
 static inline void tlb_flush(struct mmu_gather *tlb)
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b149cf9f91bc..e688246b3b13 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -94,19 +94,22 @@ static inline unsigned long get_trans_granule(void)
  * When ARMv8.4-TTL exists, TLBI operations take an additional hint for
  * the level at which the invalidation must take place. If the level is
  * wrong, no invalidation may take place. In the case where the level
- * cannot be easily determined, a 0 value for the level parameter will
- * perform a non-hinted invalidation.
+ * cannot be easily determined, the value TLBI_TTL_UNKNOWN will perform
+ * a non-hinted invalidation. Any provided level outside the hint range
+ * will also cause fall-back to non-hinted invalidation.
  *
  * For Stage-2 invalidation, use the level values provided to that effect
  * in asm/stage2_pgtable.h.
  */
 #define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
 
+#define TLBI_TTL_UNKNOWN	(-1)
+
 #define __tlbi_level(op, addr, level) do {				\
 	u64 arg = addr;							\
 									\
 	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&		\
-	    level) {							\
+	    level >= 0 && level <= 3) {					\
 		u64 ttl = level & 3;					\
 		ttl |= get_trans_granule() << 2;			\
 		arg &= ~TLBI_TTL_MASK;					\
@@ -134,16 +137,17 @@ static inline unsigned long get_trans_granule(void)
  * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
  *
  */
-#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)		\
-	({							\
-		unsigned long __ta = (addr) >> PAGE_SHIFT;	\
-		__ta &= GENMASK_ULL(36, 0);			\
-		__ta |= (unsigned long)(ttl) << 37;		\
-		__ta |= (unsigned long)(num) << 39;		\
-		__ta |= (unsigned long)(scale) << 44;		\
-		__ta |= get_trans_granule() << 46;		\
-		__ta |= (unsigned long)(asid) << 48;		\
-		__ta;						\
+#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)				\
+	({									\
+		unsigned long __ta = (addr) >> PAGE_SHIFT;			\
+		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;		\
+		__ta &= GENMASK_ULL(36, 0);					\
+		__ta |= __ttl << 37;						\
+		__ta |= (unsigned long)(num) << 39;				\
+		__ta |= (unsigned long)(scale) << 44;				\
+		__ta |= get_trans_granule() << 46;				\
+		__ta |= (unsigned long)(asid) << 48;				\
+		__ta;								\
 	})
 
 /* These macros are used by the TLBI RANGE feature. */
@@ -216,12 +220,16 @@ static inline unsigned long get_trans_granule(void)
  *		CPUs, ensuring that any walk-cache entries associated with the
  *		translation are also invalidated.
  *
- *	__flush_tlb_range(vma, start, end, stride, last_level)
+ *	__flush_tlb_range(vma, start, end, stride, last_level, tlb_level)
  *		Invalidate the virtual-address range '[start, end)' on all
  *		CPUs for the user address space corresponding to 'vma->mm'.
  *		The invalidation operations are issued at a granularity
  *		determined by 'stride' and only affect any walk-cache entries
- *		if 'last_level' is equal to false.
+ *		if 'last_level' is equal to false. tlb_level is the level at
+ *		which the invalidation must take place. If the level is wrong,
+ *		no invalidation may take place. In the case where the level
+ *		cannot be easily determined, the value TLBI_TTL_UNKNOWN will
+ *		perform a non-hinted invalidation.
  *
  *
  *	Finally, take a look at asm/tlb.h to see how tlb_flush() is implemented
@@ -442,9 +450,10 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
 	/*
 	 * We cannot use leaf-only invalidation here, since we may be invalidating
 	 * table entries as part of collapsing hugepages or moving page tables.
-	 * Set the tlb_level to 0 because we can not get enough information here.
+	 * Set the tlb_level to TLBI_TTL_UNKNOWN because we can not get enough
+	 * information here.
 	 */
-	__flush_tlb_range(vma, start, end, PAGE_SIZE, false, 0);
+	__flush_tlb_range(vma, start, end, PAGE_SIZE, false, TLBI_TTL_UNKNOWN);
 }
 
 static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end)
-- 
2.25.1

