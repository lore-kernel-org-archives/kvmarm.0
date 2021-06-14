Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA12C48BE6
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:05:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 598A3611CA
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:05:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 598A3611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D42A40667;
	Mon, 14 Jun 2021 05:05:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vAzsq6vjigMX; Mon, 14 Jun 2021 05:05:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA40C49F82;
	Mon, 14 Jun 2021 05:05:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EEFD40762
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:05:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sEAqfkPy2czq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 05:05:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE7649F5F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:05:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11D1911D4;
 Mon, 14 Jun 2021 02:05:47 -0700 (PDT)
Received: from e112269-lin.arm.com (autoplooker.cambridge.arm.com
 [10.1.194.57])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 110F73F694;
 Mon, 14 Jun 2021 02:05:43 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v15 2/7] arm64: mte: Sync tags for pages where PTE is untagged
Date: Mon, 14 Jun 2021 10:05:20 +0100
Message-Id: <20210614090525.4338-3-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210614090525.4338-1-steven.price@arm.com>
References: <20210614090525.4338-1-steven.price@arm.com>
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

A KVM guest could store tags in a page even if the VMM hasn't mapped
the page with PROT_MTE. So when restoring pages from swap we will
need to check to see if there are any saved tags even if !pte_tagged().

However don't check pages for which pte_access_permitted() returns false
as these will not have been swapped out.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/mte.h     |  4 ++--
 arch/arm64/include/asm/pgtable.h | 22 +++++++++++++++++++---
 arch/arm64/kernel/mte.c          | 17 +++++++++++++----
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index bc88a1ced0d7..347ef38a35f7 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -37,7 +37,7 @@ void mte_free_tag_storage(char *storage);
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
-void mte_sync_tags(pte_t *ptep, pte_t pte);
+void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
 void mte_thread_switch(struct task_struct *next);
@@ -53,7 +53,7 @@ int mte_ptrace_copy_tags(struct task_struct *child, long request,
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
-static inline void mte_sync_tags(pte_t *ptep, pte_t pte)
+static inline void mte_sync_tags(pte_t old_pte, pte_t pte)
 {
 }
 static inline void mte_copy_page_tags(void *kto, const void *kfrom)
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 0b10204e72fc..db5402168841 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -314,9 +314,25 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 	if (pte_present(pte) && pte_user_exec(pte) && !pte_special(pte))
 		__sync_icache_dcache(pte);
 
-	if (system_supports_mte() &&
-	    pte_present(pte) && pte_tagged(pte) && !pte_special(pte))
-		mte_sync_tags(ptep, pte);
+	/*
+	 * If the PTE would provide user space access to the tags associated
+	 * with it then ensure that the MTE tags are synchronised.  Although
+	 * pte_access_permitted() returns false for exec only mappings, they
+	 * don't expose tags (instruction fetches don't check tags).
+	 */
+	if (system_supports_mte() && pte_access_permitted(pte, false) &&
+	    !pte_special(pte)) {
+		pte_t old_pte = READ_ONCE(*ptep);
+		/*
+		 * We only need to synchronise if the new PTE has tags enabled
+		 * or if swapping in (in which case another mapping may have
+		 * set tags in the past even if this PTE isn't tagged).
+		 * (!pte_none() && !pte_present()) is an open coded version of
+		 * is_swap_pte()
+		 */
+		if (pte_tagged(pte) || (!pte_none(old_pte) && !pte_present(old_pte)))
+			mte_sync_tags(old_pte, pte);
+	}
 
 	__check_racy_pte_update(mm, ptep, pte);
 
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index a3583a7fd400..ae0a3c68fece 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -33,10 +33,10 @@ DEFINE_STATIC_KEY_FALSE(mte_async_mode);
 EXPORT_SYMBOL_GPL(mte_async_mode);
 #endif
 
-static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
+static void mte_sync_page_tags(struct page *page, pte_t old_pte,
+			       bool check_swap, bool pte_is_tagged)
 {
 	unsigned long flags;
-	pte_t old_pte = READ_ONCE(*ptep);
 
 	spin_lock_irqsave(&tag_sync_lock, flags);
 
@@ -53,6 +53,9 @@ static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
 		}
 	}
 
+	if (!pte_is_tagged)
+		goto out;
+
 	page_kasan_tag_reset(page);
 	/*
 	 * We need smp_wmb() in between setting the flags and clearing the
@@ -69,16 +72,22 @@ static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
 	spin_unlock_irqrestore(&tag_sync_lock, flags);
 }
 
-void mte_sync_tags(pte_t *ptep, pte_t pte)
+void mte_sync_tags(pte_t old_pte, pte_t pte)
 {
 	struct page *page = pte_page(pte);
 	long i, nr_pages = compound_nr(page);
 	bool check_swap = nr_pages == 1;
+	bool pte_is_tagged = pte_tagged(pte);
+
+	/* Early out if there's nothing to do */
+	if (!check_swap && !pte_is_tagged)
+		return;
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
 		if (!test_bit(PG_mte_tagged, &page->flags))
-			mte_sync_page_tags(page, ptep, check_swap);
+			mte_sync_page_tags(page, old_pte, check_swap,
+					   pte_is_tagged);
 	}
 }
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
