Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E1438DFC
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2464FEC;
	Mon,  9 Oct 2023 11:51:01 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 530473F5A1;
	Mon,  9 Oct 2023 11:50:19 -0700 (PDT)
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
Subject: [PATCH v4 02/12] arm64/mm: Update range-based tlb invalidation routines for FEAT_LPA2
Date: Mon,  9 Oct 2023 19:49:58 +0100
Message-Id: <20231009185008.3803879-3-ryan.roberts@arm.com>
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

The BADDR field of the range-based tlbi instructions is specified in
64KB units when LPA2 is in use (TCR.DS=1), whereas it is in page units
otherwise.

When LPA2 is enabled, use the non-range tlbi instructions to forward
align to a 64KB boundary first, then use range-based tlbi from there on,
until we have either invalidated all pages or we have a single page
remaining. If the latter, that is done with non-range tlbi. (Previously
we invalidated a single odd page first, but we can no longer do this
because it could wreck our 64KB alignment). When LPA2 is not in use, we
don't need the initial alignemnt step. However, the bigger impact is
that we can no longer use the previous method of iterating from smallest
to largest 'scale', since this would likely unalign the boundary again
for the LPA2 case. So instead we iterate from highest to lowest scale,
which guarrantees that we remain 64KB aligned until the last op (at
scale=0).

The original commit (d1d3aa98 "arm64: tlb: Use the TLBI RANGE feature in
arm64") stated this as the reason for incrementing scale:

  However, in most scenarios, the pages = 1 when flush_tlb_range() is
  called. Start from scale = 3 or other proper value (such as scale
  =ilog2(pages)), will incur extra overhead. So increase 'scale' from 0
  to maximum, the flush order is exactly opposite to the example.

But pages=1 is already special cased by the non-range invalidation path,
which will take care of it the first time through the loop (both in the
original commit and in my change), so I don't think switching to
decrement scale should have any extra performance impact after all.

Note: This patch uses LPA2 range-based tlbi based on the new lpa2 param
passed to __flush_tlb_range_op(). This allows both KVM and the kernel to
opt-in/out of LPA2 usage independently. But once both are converted over
(and keyed off the same static key), the parameter could be dropped and
replaced by the static key directly in the macro.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/tlb.h      |  6 +++-
 arch/arm64/include/asm/tlbflush.h | 46 ++++++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/tlb.c     |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c      |  2 +-
 4 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
index 93c537635dbb..396ba9b4872c 100644
--- a/arch/arm64/include/asm/tlb.h
+++ b/arch/arm64/include/asm/tlb.h
@@ -25,7 +25,6 @@ static void tlb_flush(struct mmu_gather *tlb);
  * get the tlbi levels in arm64.  Default value is TLBI_TTL_UNKNOWN if more than
  * one of cleared_* is set or neither is set - this elides the level hinting to
  * the hardware.
- * Arm64 doesn't support p4ds now.
  */
 static inline int tlb_get_level(struct mmu_gather *tlb)
 {
@@ -48,6 +47,11 @@ static inline int tlb_get_level(struct mmu_gather *tlb)
 				   tlb->cleared_p4ds))
 		return 1;
 
+	if (tlb->cleared_p4ds && !(tlb->cleared_ptes ||
+				   tlb->cleared_pmds ||
+				   tlb->cleared_puds))
+		return 0;
+
 	return TLBI_TTL_UNKNOWN;
 }
 
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index e688246b3b13..4d34035fe7d6 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -136,10 +136,14 @@ static inline unsigned long get_trans_granule(void)
  * The address range is determined by below formula:
  * [BADDR, BADDR + (NUM + 1) * 2^(5*SCALE + 1) * PAGESIZE)
  *
+ * If LPA2 is in use, BADDR holds addr[52:16]. Else BADDR holds page number.
+ * See ARM DDI 0487I.a C5.5.21.
+ *
  */
-#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl)				\
+#define __TLBI_VADDR_RANGE(addr, asid, scale, num, ttl, lpa2)			\
 	({									\
-		unsigned long __ta = (addr) >> PAGE_SHIFT;			\
+		unsigned long __addr_shift = lpa2 ? 16 : PAGE_SHIFT;		\
+		unsigned long __ta = (addr) >> __addr_shift;			\
 		unsigned long __ttl = (ttl >= 1 && ttl <= 3) ? ttl : 0;		\
 		__ta &= GENMASK_ULL(36, 0);					\
 		__ta |= __ttl << 37;						\
@@ -354,34 +358,44 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  * @tlb_level:	Translation Table level hint, if known
  * @tlbi_user:	If 'true', call an additional __tlbi_user()
  *              (typically for user ASIDs). 'flase' for IPA instructions
+ * @lpa2:	If 'true', the lpa2 scheme is used as set out below
  *
  * When the CPU does not support TLB range operations, flush the TLB
  * entries one by one at the granularity of 'stride'. If the TLB
  * range ops are supported, then:
  *
- * 1. If 'pages' is odd, flush the first page through non-range
- *    operations;
+ * 1. If FEAT_LPA2 is in use, the start address of a range operation
+ *    must be 64KB aligned, so flush pages one by one until the
+ *    alignment is reached using the non-range operations. This step is
+ *    skipped if LPA2 is not in use.
  *
  * 2. For remaining pages: the minimum range granularity is decided
  *    by 'scale', so multiple range TLBI operations may be required.
- *    Start from scale = 0, flush the corresponding number of pages
- *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
- *    until no pages left.
+ *    Start from scale = 3, flush the corresponding number of pages
+ *    ((num+1)*2^(5*scale+1) starting from 'addr'), then descrease it
+ *    until one or zero pages are left. We must start from highest scale
+ *    to ensure 64KB start alignment is maintained in the LPA2 case.
+ *
+ * 3. If there is 1 page remaining, flush it through non-range
+ *    operations. Range operations can only span an even number of
+ *    pages. We save this for last to ensure 64KB start alignment is
+ *    maintained for the LPA2 case.
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
-	int scale = 0;							\
+	int scale = 3;							\
 	unsigned long addr;						\
 									\
 	while (pages > 0) {						\
 		if (!system_supports_tlb_range() ||			\
-		    pages % 2 == 1) {					\
+		    pages == 1 ||					\
+		    (lpa2 && start != ALIGN(start, SZ_64K))) {		\
 			addr = __TLBI_VADDR(start, asid);		\
 			__tlbi_level(op, addr, tlb_level);		\
 			if (tlbi_user)					\
@@ -394,19 +408,19 @@ do {									\
 		num = __TLBI_RANGE_NUM(pages, scale);			\
 		if (num >= 0) {						\
 			addr = __TLBI_VADDR_RANGE(start, asid, scale,	\
-						  num, tlb_level);	\
+						num, tlb_level, lpa2);	\
 			__tlbi(r##op, addr);				\
 			if (tlbi_user)					\
 				__tlbi_user(r##op, addr);		\
 			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT; \
 			pages -= __TLBI_RANGE_PAGES(num, scale);	\
 		}							\
-		scale++;						\
+		scale--;						\
 	}								\
 } while (0)
 
-#define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
-	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false)
+#define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level, lpa2) \
+	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false, lpa2)
 
 static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
@@ -436,9 +450,9 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	asid = ASID(vma->vm_mm);
 
 	if (last_level)
-		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true);
+		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true, false);
 	else
-		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
+		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true, false);
 
 	dsb(ish);
 	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 1b265713d6be..d42b72f78a9b 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -198,7 +198,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt, false);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
 
 	dsb(ish);
 	__tlbi(vmalle1is);
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 46bd43f61d76..6041c6c78984 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -161,7 +161,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
-	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
+	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0, false);
 
 	dsb(ish);
 	__tlbi(vmalle1is);
-- 
2.25.1

