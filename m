Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7D2C352A1
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 388C540397;
	Tue,  6 Dec 2022 09:00:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BgefcbxSGkyj; Tue,  6 Dec 2022 09:00:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 881D54B3FB;
	Tue,  6 Dec 2022 09:00:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9825E40B6C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aUBID1X2VAh3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 09:00:10 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0FC4B62C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D9E5113E;
 Tue,  6 Dec 2022 06:00:13 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8BB53F73D;
 Tue,  6 Dec 2022 06:00:04 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 02/12] arm64/mm: Update tlb invalidation routines for
 FEAT_LPA2
Date: Tue,  6 Dec 2022 13:59:20 +0000
Message-Id: <20221206135930.3277585-3-ryan.roberts@arm.com>
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

FEAT_LPA2 impacts tlb invalidation in 2 ways; Firstly, the TTL field in
the non-range tlbi instructions can now validly take a 0 value for the
4KB granule (this is due to the extra level of translation). Secondly,
the BADDR field in the range tlbi instructions must be aligned to 64KB
when LPA2 is in use (TCR.DS=1). Changes are required for tlbi to
continue to operate correctly when LPA2 is in use.

We solve the first by always adding the level hint if the level is
between [0, 3] (previously anything other than 0 was hinted, which
breaks in the new level -1 case from kvm). When running on non-LPA2 HW,
0 is still safe to hint as the HW will fall back to non-hinted. We also
update kernel code to take advantage of the new hint for p4d flushing.
While we are at it, we replace the notion of 0 being the non-hinted
seninel with a macro, TLBI_TTL_UNKNOWN. This means callers won't need
updating if/when translation depth increases in future.

The second problem is tricker. When LPA2 is in use, we need to use the
non-range tlbi instructions to forward align to a 64KB boundary first,
then we can use range-based tlbi from there on, until we have either
invalidated all pages or we have a single page remaining. If the latter,
that is done with non-range tlbi. (Previously we invalidated a single
odd page first, but we can no longer do this because it could wreck our
64KB alignment). When LPA2 is not in use, we don't need the initial
alignemnt step. However, the bigger impact is that we can no longer use
the previous method of iterating from smallest to largest 'scale', since
this would likely unalign the boundary again for the LPA2 case. So
instead we iterate from highest to lowest scale, which guarrantees that
we remain 64KB aligned until the last op (at scale=0).

The original commit (d1d3aa9 "arm64: tlb: Use the TLBI RANGE feature in
arm64") stated this as the reason for incrementing scale:

  However, in most scenarios, the pages = 1 when flush_tlb_range() is
  called. Start from scale = 3 or other proper value (such as scale
  =ilog2(pages)), will incur extra overhead. So increase 'scale' from 0
  to maximum, the flush order is exactly opposite to the example.

But pages=1 is already special cased by the non-range invalidation path,
which will take care of it the first time through the loop (both in the
original commit and in my change), so I don't think switching to
decrement scale should have any extra performance impact after all.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/pgtable-prot.h |  6 ++
 arch/arm64/include/asm/tlb.h          | 15 +++--
 arch/arm64/include/asm/tlbflush.h     | 83 +++++++++++++++++----------
 3 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 9b165117a454..308cc02fcdf3 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -40,6 +40,12 @@ extern bool arm64_use_ng_mappings;
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
 
+/*
+ * For now the kernel never uses lpa2 for its stage1 tables. But kvm does and
+ * this hook allows us to update the common tlbi code to handle lpa2.
+ */
+#define lpa2_is_enabled()	false
+
 /*
  * If we have userspace only BTI we don't want to mark kernel pages
  * guarded even if the system does support BTI.
diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index c995d1f4594f..3a189c435973 100644
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
index 412a3b9a3c25..903d95a4bef5 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -93,19 +93,22 @@ static inline unsigned long get_trans_granule(void)
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
@@ -132,17 +135,22 @@ static inline unsigned long get_trans_granule(void)
  * The address range is determined by below formula:
  * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
  *
+ * If LPA2 is in use, BADDR holds addr[52:16]. Else BADDR holds page number.
+ * See ARM DDI 0487I.a C5.5.21.
+ *
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
+#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl, lpa2_ena)		\
+	({									\
+		unsigned long __addr_shift = (lpa2_ena) ? 16 : PAGE_SHIFT;	\
+		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;		\
+		unsigned long __ta = (addr) >> __addr_shift;			\
+		__ta &= GENMASK_ULL(36, 0);					\
+		__ta |= __ttl << 37;						\
+		__ta |= (unsigned long)(num) << 39;				\
+		__ta |= (unsigned long)(scale) << 44;				\
+		__ta |= get_trans_granule() << 46;				\
+		__ta |= (unsigned long)(asid) << 48;				\
+		__ta;								\
 	})
 
 /* These macros are used by the TLBI RANGE feature. */
@@ -215,12 +223,16 @@ static inline unsigned long get_trans_granule(void)
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
@@ -284,8 +296,9 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     int tlb_level)
 {
 	int num = 0;
-	int scale = 0;
+	int scale = 3;
 	unsigned long asid, addr, pages;
+	bool lpa2_ena = lpa2_is_enabled();
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -309,17 +322,25 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 
 	/*
 	 * When the CPU does not support TLB range operations, flush the TLB
-	 * entries one by one at the granularity of 'stride'. If the TLB
-	 * range ops are supported, then:
+	 * entries one by one at the granularity of 'stride'. If the TLB range
+	 * ops are supported, then:
+	 *
+	 * 1. If FEAT_LPA2 is in use, the start address of a range operation
+	 *    must be 64KB aligned, so flush pages one by one until the
+	 *    alignment is reached using the non-range operations. This step is
+	 *    skipped if LPA2 is not in use.
 	 *
-	 * 1. If 'pages' is odd, flush the first page through non-range
-	 *    operations;
+	 * 2. For remaining pages: the minimum range granularity is decided by
+	 *    'scale', so multiple range TLBI operations may be required. Start
+	 *    from scale = 3, flush the corresponding number of pages
+	 *    ((num+1)*2^(5*scale+1) starting from 'addr'), then descrease it
+	 *    until one or zero pages are left. We must start from highest scale
+	 *    to ensure 64KB start alignment is maintained in the LPA2 case.
 	 *
-	 * 2. For remaining pages: the minimum range granularity is decided
-	 *    by 'scale', so multiple range TLBI operations may be required.
-	 *    Start from scale = 0, flush the corresponding number of pages
-	 *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
-	 *    until no pages left.
+	 * 3. If there is 1 page remaining, flush it through non-range
+	 *    operations. Range operations can only span an even number of
+	 *    pages. We save this for last to ensure 64KB start alignment is
+	 *    maintained for the LPA2 case.
 	 *
 	 * Note that certain ranges can be represented by either num = 31 and
 	 * scale or num = 0 and scale + 1. The loop below favours the latter
@@ -327,7 +348,8 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	 */
 	while (pages > 0) {
 		if (!system_supports_tlb_range() ||
-		    pages % 2 == 1) {
+		    pages == 1 ||
+		    (lpa2_ena && start != ALIGN(start, SZ_64K))) {
 			addr = __TLBI_VADDR(start, asid);
 			if (last_level) {
 				__tlbi_level(vale1is, addr, tlb_level);
@@ -344,7 +366,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 		num = __TLBI_RANGE_NUM(pages, scale);
 		if (num >= 0) {
 			addr = __TLBI_VADDR_RANGE(start, asid, scale,
-						  num, tlb_level);
+						  num, tlb_level, lpa2_ena);
 			if (last_level) {
 				__tlbi(rvale1is, addr);
 				__tlbi_user(rvale1is, addr);
@@ -355,7 +377,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT;
 			pages -= __TLBI_RANGE_PAGES(num, scale);
 		}
-		scale++;
+		scale--;
 	}
 	dsb(ish);
 }
@@ -366,9 +388,10 @@ static inline void flush_tlb_range(struct vm_area_struct *vma,
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
