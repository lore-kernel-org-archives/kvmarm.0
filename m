Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8E8C4338F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:31:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D69D611CB
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:31:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1D69D611CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBA0F4B0F0;
	Fri,  6 Aug 2021 07:31:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k7s89gfMPo00; Fri,  6 Aug 2021 07:31:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7824B0E5;
	Fri,  6 Aug 2021 07:31:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 421834B0E0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:31:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JDHKiMI+7Lb0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 07:31:24 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03F7A4B0E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:31:24 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8259961058;
 Fri,  6 Aug 2021 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628249483;
 bh=mo5wDPhEHYGqKKM336AjWzR67zEBISf0qmWTSG4w3FU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=sOW8954Np0TRki2NQdRgjPDxmAZzhqGNSxZXmycNwYPxzXwddUObeqilT03yvpj1T
 lKefspovDCqksqUaPtilAvlMfADzP/44EdArMZh7ECFvLrJdui1+jOMdCKfZVZy4qD
 fxXQK/7nzgDNYuxMmDTEi39066TBaVNpzhmWG2mqrfUhE5WcS3LzMs0ns82bs4CJ7q
 BI44cpMQf3KErVQMPnx5QaeTh1mDPqNCKPI6CfsCBZBH/KpQWQk+cWi7JPm2ulIGkN
 PDEUuFFHlIG9o1SujCaSVINBHOXjmEU6A1AapxAY5tf+Kn6eNSnM9PBiq5aqERLJCs
 +e3F+WCTV8qFQ==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] arm64: mm: Fix TLBI vs ASID rollover
Date: Fri,  6 Aug 2021 12:31:04 +0100
Message-Id: <20210806113109.2475-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806113109.2475-1-will@kernel.org>
References: <20210806113109.2475-1-will@kernel.org>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jade Alglave <jade.alglave@arm.com>
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

When switching to an 'mm_struct' for the first time following an ASID
rollover, a new ASID may be allocated and assigned to 'mm->context.id'.
This reassignment can happen concurrently with other operations on the
mm, such as unmapping pages and subsequently issuing TLB invalidation.

Consequently, we need to ensure that (a) accesses to 'mm->context.id'
are atomic and (b) all page-table updates made prior to a TLBI using the
old ASID are guaranteed to be visible to CPUs running with the new ASID.

This was found by inspection after reviewing the VMID changes from
Shameer but it looks like a real (yet hard to hit) bug.

Cc: <stable@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Jade Alglave <jade.alglave@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/mmu.h      | 29 +++++++++++++++++++++++++----
 arch/arm64/include/asm/tlbflush.h | 11 ++++++-----
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 75beffe2ee8a..e9c30859f80c 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -27,11 +27,32 @@ typedef struct {
 } mm_context_t;
 
 /*
- * This macro is only used by the TLBI and low-level switch_mm() code,
- * neither of which can race with an ASID change. We therefore don't
- * need to reload the counter using atomic64_read().
+ * We use atomic64_read() here because the ASID for an 'mm_struct' can
+ * be reallocated when scheduling one of its threads following a
+ * rollover event (see new_context() and flush_context()). In this case,
+ * a concurrent TLBI (e.g. via try_to_unmap_one() and ptep_clear_flush())
+ * may use a stale ASID. This is fine in principle as the new ASID is
+ * guaranteed to be clean in the TLB, but the TLBI routines have to take
+ * care to handle the following race:
+ *
+ *    CPU 0                    CPU 1                          CPU 2
+ *
+ *    // ptep_clear_flush(mm)
+ *    xchg_relaxed(pte, 0)
+ *    DSB ISHST
+ *    old = ASID(mm)
+ *         |                                                  <rollover>
+ *         |                   new = new_context(mm)
+ *         \-----------------> atomic_set(mm->context.id, new)
+ *                             cpu_switch_mm(mm)
+ *                             // Hardware walk of pte using new ASID
+ *    TLBI(old)
+ *
+ * In this scenario, the barrier on CPU 0 and the dependency on CPU 1
+ * ensure that the page-table walker on CPU 1 *must* see the invalid PTE
+ * written by CPU 0.
  */
-#define ASID(mm)	((mm)->context.id.counter & 0xffff)
+#define ASID(mm)	(atomic64_read(&(mm)->context.id) & 0xffff)
 
 static inline bool arm64_kernel_unmapped_at_el0(void)
 {
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index cc3f5a33ff9c..36f02892e1df 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -245,9 +245,10 @@ static inline void flush_tlb_all(void)
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
-	unsigned long asid = __TLBI_VADDR(0, ASID(mm));
+	unsigned long asid;
 
 	dsb(ishst);
+	asid = __TLBI_VADDR(0, ASID(mm));
 	__tlbi(aside1is, asid);
 	__tlbi_user(aside1is, asid);
 	dsb(ish);
@@ -256,9 +257,10 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 static inline void flush_tlb_page_nosync(struct vm_area_struct *vma,
 					 unsigned long uaddr)
 {
-	unsigned long addr = __TLBI_VADDR(uaddr, ASID(vma->vm_mm));
+	unsigned long addr;
 
 	dsb(ishst);
+	addr = __TLBI_VADDR(uaddr, ASID(vma->vm_mm));
 	__tlbi(vale1is, addr);
 	__tlbi_user(vale1is, addr);
 }
@@ -283,9 +285,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 {
 	int num = 0;
 	int scale = 0;
-	unsigned long asid = ASID(vma->vm_mm);
-	unsigned long addr;
-	unsigned long pages;
+	unsigned long asid, addr, pages;
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -305,6 +305,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	}
 
 	dsb(ishst);
+	asid = ASID(vma->vm_mm);
 
 	/*
 	 * When the CPU does not support TLB range operations, flush the TLB
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
