Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB9D18E24
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FF931570;
	Fri, 27 Oct 2023 04:57:32 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 708C43F738;
	Fri, 27 Oct 2023 04:56:48 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Ard Biesheuvel <ardb@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [RFC PATCH v1 3/3] arm64/mm: Update tlb invalidation routines for FEAT_LPA2
Date: Fri, 27 Oct 2023 12:56:34 +0100
Message-Id: <20231027115634.1432154-4-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231027115634.1432154-1-ryan.roberts@arm.com>
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FEAT_LPA2 impacts tlb invalidation in 2 ways; Firstly, the TTL field in
the non-range tlbi instructions can now validly take a 0 value as a
level hint for the 4KB granule (this is due to the extra level of
translation) - previously TTL=0b0100 meant no hint and was treated as
0b0000. Secondly, The BADDR field of the range-based tlbi instructions
is specified in 64KB units when LPA2 is in use (TCR.DS=1), whereas it is
in page units otherwise. Changes are required for tlbi to continue to
operate correctly when LPA2 is in use.

Solve the first problem by always adding the level hint if the level is
between [0, 3] (previously anything other than 0 was hinted, which
breaks in the new level -1 case from kvm). When running on non-LPA2 HW,
0 is still safe to hint as the HW will fall back to non-hinted. While we
are at it, we replace the notion of 0 being the non-hinted sentinel with
a macro, TLBI_TTL_UNKNOWN. This means callers won't need updating
if/when translation depth increases in future.

The second issue is more complex: When LPA2 is in use, use the non-range
tlbi instructions to forward align to a 64KB boundary first, then use
range-based tlbi from there on, until we have either invalidated all
pages or we have a single page remaining. If the latter, that is done
with non-range tlbi. We determine whether LPA2 is in use based on
lpa2_is_enabled() (for kernel calls) or kvm_lpa2_is_enabled() (for kvm
calls).

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/tlb.h      | 15 ++++--
 arch/arm64/include/asm/tlbflush.h | 90 ++++++++++++++++++++-----------
 2 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 2c29239d05c3..396ba9b4872c 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -22,15 +22,15 @@ static void tlb_flush(struct mmu_gather *tlb);
 #include <asm-generic/tlb.h>

 /*
- * get the tlbi levels in arm64.  Default value is 0 if more than one
- * of cleared_* is set or neither is set.
- * Arm64 doesn't support p4ds now.
+ * get the tlbi levels in arm64.  Default value is TLBI_TTL_UNKNOWN if more than
+ * one of cleared_* is set or neither is set - this elides the level hinting to
+ * the hardware.
  */
 static inline int tlb_get_level(struct mmu_gather *tlb)
 {
 	/* The TTL field is only valid for the leaf entry. */
 	if (tlb->freed_tables)
-		return 0;
+		return TLBI_TTL_UNKNOWN;

 	if (tlb->cleared_ptes && !(tlb->cleared_pmds ||
 				   tlb->cleared_puds ||
@@ -47,7 +47,12 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
 				   tlb->cleared_p4ds))
 		return 1;

-	return 0;
+	if (tlb->cleared_p4ds && !(tlb->cleared_ptes ||
+				   tlb->cleared_pmds ||
+				   tlb->cleared_puds))
+		return 0;
+
+	return TLBI_TTL_UNKNOWN;
 }

 static inline void tlb_flush(struct mmu_gather *tlb)
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index e8153c16fcdf..cbc9ad4db32d 100644
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

+#define TLBI_TTL_UNKNOWN	INT_MAX
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
@@ -122,28 +125,34 @@ static inline unsigned long get_trans_granule(void)
 } while (0)

 /*
- * This macro creates a properly formatted VA operand for the TLB RANGE.
- * The value bit assignments are:
+ * This macro creates a properly formatted VA operand for the TLB RANGE. The
+ * value bit assignments are:
  *
  * +----------+------+-------+-------+-------+----------------------+
  * |   ASID   |  TG  | SCALE |  NUM  |  TTL  |        BADDR         |
  * +-----------------+-------+-------+-------+----------------------+
  * |63      48|47  46|45   44|43   39|38   37|36                   0|
  *
- * The address range is determined by below formula:
- * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
+ * The address range is determined by below formula: [BADDR, BADDR + (NUM + 1) *
+ * 2^(5*SCALE + 1) * PAGESIZE)
+ *
+ * Note that the first argument, baddr, is pre-shifted; If LPA2 is in use, BADDR
+ * holds addr[52:16]. Else BADDR holds page number. See for example ARM DDI
+ * 0487J.a section C5.5.60 "TLBI VAE1IS, TLBI VAE1ISNXS, TLB Invalidate by VA,
+ * EL1, Inner Shareable".
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
+#define __TLBI_VADDR_RANGE(baddr, asid, scale, num, ttl)			\
+	({									\
+		unsigned long __ta = (baddr);					\
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
@@ -216,12 +225,16 @@ static inline unsigned long get_trans_granule(void)
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
@@ -346,34 +359,44 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  * @tlb_level:	Translation Table level hint, if known
  * @tlbi_user:	If 'true', call an additional __tlbi_user()
  *              (typically for user ASIDs). 'flase' for IPA instructions
+ * @lpa2:	If 'true', the lpa2 scheme is used as set out below
  *
  * When the CPU does not support TLB range operations, flush the TLB
  * entries one by one at the granularity of 'stride'. If the TLB
  * range ops are supported, then:
  *
- * 1. The minimum range granularity is decided by 'scale', so multiple range
+ * 1. If FEAT_LPA2 is in use, the start address of a range operation must be
+ *    64KB aligned, so flush pages one by one until the alignment is reached
+ *    using the non-range operations. This step is skipped if LPA2 is not in
+ *    use.
+ *
+ * 2. The minimum range granularity is decided by 'scale', so multiple range
  *    TLBI operations may be required. Start from scale = 3, flush the largest
  *    possible number of pages ((num+1)*2^(5*scale+1)) that fit into the
  *    requested range, then decrement scale and continue until one or zero pages
- *    are left.
+ *    are left. We must start from highest scale to ensure 64KB start alignment
+ *    is maintained in the LPA2 case.
  *
- * 2. If there is 1 page remaining, flush it through non-range operations. Range
- *    operations can only span an even number of pages.
+ * 3. If there is 1 page remaining, flush it through non-range operations. Range
+ *    operations can only span an even number of pages. We save this for last to
+ *    ensure 64KB start alignment is maintained for the LPA2 case.
  *
  * Note that certain ranges can be represented by either num = 31 and
  * scale or num = 0 and scale + 1. The loop below favours the latter
  * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
  */
 #define __flush_tlb_range_op(op, start, pages, stride,			\
-				asid, tlb_level, tlbi_user)		\
+				asid, tlb_level, tlbi_user, lpa2)	\
 do {									\
 	int num = 0;							\
 	int scale = 3;							\
+	int shift = lpa2 ? 16 : PAGE_SHIFT;				\
 	unsigned long addr;						\
 									\
 	while (pages > 0) {						\
 		if (!system_supports_tlb_range() ||			\
-		    pages == 1) {					\
+		    pages == 1 ||					\
+		    (lpa2 && start != ALIGN(start, SZ_64K))) {		\
 			addr = __TLBI_VADDR(start, asid);		\
 			__tlbi_level(op, addr, tlb_level);		\
 			if (tlbi_user)					\
@@ -385,8 +408,8 @@ do {									\
 									\
 		num = __TLBI_RANGE_NUM(pages, scale);			\
 		if (num >= 0) {						\
-			addr = __TLBI_VADDR_RANGE(start, asid, scale,	\
-						  num, tlb_level);	\
+			addr = __TLBI_VADDR_RANGE(start >> shift, asid, \
+						scale, num, tlb_level);	\
 			__tlbi(r##op, addr);				\
 			if (tlbi_user)					\
 				__tlbi_user(r##op, addr);		\
@@ -398,7 +421,7 @@ do {									\
 } while (0)

 #define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
-	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false)
+	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false, kvm_lpa2_is_enabled());

 static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
@@ -428,9 +451,11 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	asid = ASID(vma->vm_mm);

 	if (last_level)
-		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true);
+		__flush_tlb_range_op(vale1is, start, pages, stride, asid,
+				     tlb_level, true, lpa2_is_enabled());
 	else
-		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
+		__flush_tlb_range_op(vae1is, start, pages, stride, asid,
+				     tlb_level, true, lpa2_is_enabled());

 	dsb(ish);
 	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
@@ -442,9 +467,10 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
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

