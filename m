Return-Path: <SRS0=Qgx2=LI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4999CC48BE6
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:05:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D8EC461380
	for <kvmarm@archiver.kernel.org>; Mon, 14 Jun 2021 09:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8EC461380
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF3C4066E;
	Mon, 14 Jun 2021 05:05:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 02vIFIU9y5dd; Mon, 14 Jun 2021 05:05:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADDC849F82;
	Mon, 14 Jun 2021 05:05:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EFF949E8A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:05:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ebFQDjIoAEcT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jun 2021 05:05:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A00749F82
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jun 2021 05:05:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA644113E;
 Mon, 14 Jun 2021 02:05:43 -0700 (PDT)
Received: from e112269-lin.arm.com (autoplooker.cambridge.arm.com
 [10.1.194.57])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A8A33F694;
 Mon, 14 Jun 2021 02:05:40 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v15 1/7] arm64: mte: Handle race when synchronising tags
Date: Mon, 14 Jun 2021 10:05:19 +0100
Message-Id: <20210614090525.4338-2-steven.price@arm.com>
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

mte_sync_tags() used test_and_set_bit() to set the PG_mte_tagged flag
before restoring/zeroing the MTE tags. However if another thread were to
race and attempt to sync the tags on the same page before the first
thread had completed restoring/zeroing then it would see the flag is
already set and continue without waiting. This would potentially expose
the previous contents of the tags to user space, and cause any updates
that user space makes before the restoring/zeroing has completed to
potentially be lost.

Since this code is run from atomic contexts we can't just lock the page
during the process. Instead implement a new (global) spinlock to protect
the mte_sync_page_tags() function.

Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kernel/mte.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 125a10e413e9..a3583a7fd400 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -25,6 +25,7 @@
 u64 gcr_kernel_excl __ro_after_init;
 
 static bool report_fault_once = true;
+static DEFINE_SPINLOCK(tag_sync_lock);
 
 #ifdef CONFIG_KASAN_HW_TAGS
 /* Whether the MTE asynchronous mode is enabled. */
@@ -34,13 +35,22 @@ EXPORT_SYMBOL_GPL(mte_async_mode);
 
 static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
 {
+	unsigned long flags;
 	pte_t old_pte = READ_ONCE(*ptep);
 
+	spin_lock_irqsave(&tag_sync_lock, flags);
+
+	/* Recheck with the lock held */
+	if (test_bit(PG_mte_tagged, &page->flags))
+		goto out;
+
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
-			return;
+		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
+			set_bit(PG_mte_tagged, &page->flags);
+			goto out;
+		}
 	}
 
 	page_kasan_tag_reset(page);
@@ -53,6 +63,10 @@ static void mte_sync_page_tags(struct page *page, pte_t *ptep, bool check_swap)
 	 */
 	smp_wmb();
 	mte_clear_page_tags(page_address(page));
+	set_bit(PG_mte_tagged, &page->flags);
+
+out:
+	spin_unlock_irqrestore(&tag_sync_lock, flags);
 }
 
 void mte_sync_tags(pte_t *ptep, pte_t pte)
@@ -63,7 +77,7 @@ void mte_sync_tags(pte_t *ptep, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!test_bit(PG_mte_tagged, &page->flags))
 			mte_sync_page_tags(page, ptep, check_swap);
 	}
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
