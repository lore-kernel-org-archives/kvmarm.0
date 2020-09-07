Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45391C2BB84
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB004217A0
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 15:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9nYYfVz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB004217A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58EA34B438;
	Mon,  7 Sep 2020 11:24:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bon2S2upmyTl; Mon,  7 Sep 2020 11:24:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3BA4B29A;
	Mon,  7 Sep 2020 11:24:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 804674B4EE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 84bnAD343bZz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 11:24:15 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 765A64B234
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 11:24:15 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C6FCE21481;
 Mon,  7 Sep 2020 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599492254;
 bh=mz6zGPVdFUjtHJ7Ufc8fyGMFPpxz8XxXwEdr0IkJC/4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=F9nYYfVzP3BdfedlTKDXpKrpk6P+9ep8RUwAoDMnBPqkWXv0UvQTCxH1zCa7cEgxl
 wcxykSjbTa0tyn2kFZ6n3AkG0g12QyN1g1TsCuiNuGrCJTH7/0oYWxXi9d0R/5+tJM
 AtcRx4iADz3OIt8Oc8gnU+MQe+TtEenl7gWN3V9U=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 09/21] KVM: arm64: Convert unmap_stage2_range() to generic
 page-table API
Date: Mon,  7 Sep 2020 16:23:32 +0100
Message-Id: <20200907152344.12978-10-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907152344.12978-1-will@kernel.org>
References: <20200907152344.12978-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Convert unmap_stage2_range() to use kvm_pgtable_stage2_unmap() instead
of walking the page-table directly.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 62 ++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 704b471a48ce..a7021509231c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -39,6 +39,38 @@ static bool is_iomap(unsigned long flags)
 	return flags & KVM_S2PTE_FLAG_IS_IOMAP;
 }
 
+/*
+ * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
+ * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
+ * CONFIG_LOCKUP_DETECTOR, CONFIG_LOCKDEP. Additionally, holding the lock too
+ * long will also starve other vCPUs. We have to also make sure that the page
+ * tables are not freed while we released the lock.
+ */
+static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
+			      phys_addr_t end,
+			      int (*fn)(struct kvm_pgtable *, u64, u64),
+			      bool resched)
+{
+	int ret;
+	u64 next;
+
+	do {
+		struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+		if (!pgt)
+			return -EINVAL;
+
+		next = stage2_pgd_addr_end(kvm, addr, end);
+		ret = fn(pgt, addr, next - addr);
+		if (ret)
+			break;
+
+		if (resched && next != end)
+			cond_resched_lock(&kvm->mmu_lock);
+	} while (addr = next, addr != end);
+
+	return ret;
+}
+
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
@@ -220,8 +252,8 @@ static inline void kvm_pgd_populate(pgd_t *pgdp, p4d_t *p4dp)
  * end up writing old data to disk.
  *
  * This is why right after unmapping a page/section and invalidating
- * the corresponding TLBs, we call kvm_flush_dcache_p*() to make sure
- * the IO subsystem will never hit in the cache.
+ * the corresponding TLBs, we flush to make sure the IO subsystem will
+ * never hit in the cache.
  *
  * This is all avoided on systems that have ARM64_HAS_STAGE2_FWB, as
  * we then fully enforce cacheability of RAM, no matter what the guest
@@ -344,32 +376,12 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 				 bool may_block)
 {
 	struct kvm *kvm = mmu->kvm;
-	pgd_t *pgd;
-	phys_addr_t addr = start, end = start + size;
-	phys_addr_t next;
+	phys_addr_t end = start + size;
 
 	assert_spin_locked(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-
-	pgd = mmu->pgd + stage2_pgd_index(kvm, addr);
-	do {
-		/*
-		 * Make sure the page table is still active, as another thread
-		 * could have possibly freed the page table, while we released
-		 * the lock.
-		 */
-		if (!READ_ONCE(mmu->pgd))
-			break;
-		next = stage2_pgd_addr_end(kvm, addr, end);
-		if (!stage2_pgd_none(kvm, *pgd))
-			unmap_stage2_p4ds(mmu, pgd, addr, next);
-		/*
-		 * If the range is too large, release the kvm->mmu_lock
-		 * to prevent starvation and lockup detector warnings.
-		 */
-		if (may_block && next != end)
-			cond_resched_lock(&kvm->mmu_lock);
-	} while (pgd++, addr = next, addr != end);
+	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
+				   may_block));
 }
 
 static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)
-- 
2.28.0.526.ge36021eeef-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
