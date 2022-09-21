Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EAFC6FA8B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C36FC4B811;
	Tue, 20 Sep 2022 23:53:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UXhbiL4SvOEE; Tue, 20 Sep 2022 23:53:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5584B808;
	Tue, 20 Sep 2022 23:53:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EFC4B795
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gi02QaCtIwj5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:53:05 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CE624B81A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:04 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k14-20020a25e80e000000b006aa1160dfe3so4024520ybd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date;
 bh=SLV2jLXntv1aFSq9HP7hS4Hr2LAjy4Jk9IJOj6LE8fY=;
 b=fDETX5YpWQ7Fa9xfmhDrvmyPuIhMTbRqSE3IWEy9cBWYtJil0dxkDh5Rn49dMDNWL4
 bCIR+VjZKDvRQM1VLXP0Z4okqWtBK7wB3W+7Bs+Q/fSa4MX/CRVhy5ium3yDbGtyGpN7
 KYUV6vKWWvAJhTXLu2n3aGJOqdGYSn28mE3Q+mvFToLYQGMOTv01P6/oUqP0SJ87gDU0
 bL44/bJfsMIbSAt5Qgc1o29EPcsHoisg9Vgmj8REH/BlynoLDP0ae3yoHufEqAIhZGbr
 J+qX64tHbH4Z5rdIpn+afM+hya58uevyYjqBXN4bgaUyhu1EpdXO3RAdlaT9P77iV3GE
 3pDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=SLV2jLXntv1aFSq9HP7hS4Hr2LAjy4Jk9IJOj6LE8fY=;
 b=fTsu6HPD25tsPBwP5dktBn/IRHTw3itYitUeI1ZdeCgH+smbk0lLvWr/o8ryc4IHTJ
 Dp5DXI9yoW5PayuauofaOAoIylNSp26Blb32mtiihAdoEYonsSU0XhbAaTEDyisjoj8+
 CsOTjfE7PXrQjuFsV3vhQz8AFooPVl2ipjFw1Ph8mOFhmLVOQNCCESNr/7HZfYZeuQQl
 lNyR69G1yU0VY8lX8mxECVm2QKoqvXkjR0VMrV1gIMkAe+HALgYofsy+Y+SVjgwD5Ij7
 Zl9Xr/6w2u9OB5J3Bhvty5ctn/0K8bOPT+XZjD+odhG22GXN+BrPkhd/cvdb8Fiby/4m
 zRJg==
X-Gm-Message-State: ACrzQf29Ug3P1vrcODXP8EnThG5sFn8/4SUqHT0Q8elbU/KflXvxpg3M
 eoATkJHOtAZJjcp3v89E/LpSv4s=
X-Google-Smtp-Source: AMsMyM5UvmopOauysksrJIX39TxaUZ0ewsAzQPjTuZiJ12G5njtEkkB7UgnFHR543Ks6f9h6SuTTelA=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a81:a04f:0:b0:34d:1817:94af with SMTP id
 x76-20020a81a04f000000b0034d181794afmr9160474ywg.367.1663732384294; Tue, 20
 Sep 2022 20:53:04 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:37 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-6-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 5/8] arm64: mte: Lock a page for MTE tag initialisation
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>
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

From: Catalin Marinas <catalin.marinas@arm.com>

Initialising the tags and setting PG_mte_tagged flag for a page can race
between multiple set_pte_at() on shared pages or setting the stage 2 pte
via user_mem_abort(). Introduce a new PG_mte_lock flag as PG_arch_3 and
set it before attempting page initialisation. Given that PG_mte_tagged
is never cleared for a page, consider setting this flag to mean page
unlocked and wait on this bit with acquire semantics if the page is
locked:

- try_page_mte_tagging() - lock the page for tagging, return true if it
  can be tagged, false if already tagged. No acquire semantics if it
  returns true (PG_mte_tagged not set) as there is no serialisation with
  a previous set_page_mte_tagged().

- set_page_mte_tagged() - set PG_mte_tagged with release semantics.

The two-bit locking is based on Peter Collingbourne's idea.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/mte.h     | 35 +++++++++++++++++++++++++++++++-
 arch/arm64/include/asm/pgtable.h |  4 ++--
 arch/arm64/kernel/cpufeature.c   |  2 +-
 arch/arm64/kernel/mte.c          | 12 +++++------
 arch/arm64/kvm/guest.c           | 16 +++++++++------
 arch/arm64/kvm/mmu.c             |  2 +-
 arch/arm64/mm/copypage.c         |  2 ++
 arch/arm64/mm/fault.c            |  2 ++
 arch/arm64/mm/mteswap.c          | 11 +++++-----
 9 files changed, 64 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 46618c575eac..be6560e1ff2b 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -25,7 +25,7 @@ unsigned long mte_copy_tags_to_user(void __user *to, void *from,
 				    unsigned long n);
 int mte_save_tags(struct page *page);
 void mte_save_page_tags(const void *page_addr, void *tag_storage);
-bool mte_restore_tags(swp_entry_t entry, struct page *page);
+void mte_restore_tags(swp_entry_t entry, struct page *page);
 void mte_restore_page_tags(void *page_addr, const void *tag_storage);
 void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
@@ -36,6 +36,8 @@ void mte_free_tag_storage(char *storage);
 
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
+/* simple lock to avoid multiple threads tagging the same page */
+#define PG_mte_lock	PG_arch_3
 
 static inline void set_page_mte_tagged(struct page *page)
 {
@@ -60,6 +62,33 @@ static inline bool page_mte_tagged(struct page *page)
 	return ret;
 }
 
+/*
+ * Lock the page for tagging and return 'true' if the page can be tagged,
+ * 'false' if already tagged. PG_mte_tagged is never cleared and therefore the
+ * locking only happens once for page initialisation.
+ *
+ * The page MTE lock state:
+ *
+ *   Locked:	PG_mte_lock && !PG_mte_tagged
+ *   Unlocked:	!PG_mte_lock || PG_mte_tagged
+ *
+ * Acquire semantics only if the page is tagged (returning 'false').
+ */
+static inline bool try_page_mte_tagging(struct page *page)
+{
+	if (!test_and_set_bit(PG_mte_lock, &page->flags))
+		return true;
+
+	/*
+	 * The tags are either being initialised or may have been initialised
+	 * already. Check if the PG_mte_tagged flag has been set or wait
+	 * otherwise.
+	 */
+	smp_cond_load_acquire(&page->flags, VAL & (1UL << PG_mte_tagged));
+
+	return false;
+}
+
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
@@ -84,6 +113,10 @@ static inline bool page_mte_tagged(struct page *page)
 {
 	return false;
 }
+static inline bool try_page_mte_tagging(struct page *page)
+{
+	return false;
+}
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 98b638441521..8735ac1a1e32 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1049,8 +1049,8 @@ static inline void arch_swap_invalidate_area(int type)
 #define __HAVE_ARCH_SWAP_RESTORE
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
-	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_page_mte_tagged(&folio->page);
+	if (system_supports_mte())
+		mte_restore_tags(entry, &folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ab3312788d60..e2c0a707a941 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2049,7 +2049,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!page_mte_tagged(ZERO_PAGE(0))) {
+	if (try_page_mte_tagging(ZERO_PAGE(0))) {
 		mte_clear_page_tags(lm_alias(empty_zero_page));
 		set_page_mte_tagged(ZERO_PAGE(0));
 	}
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 2287316639f3..54ab6c4741db 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,17 +41,17 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
-			set_page_mte_tagged(page);
-			return;
-		}
+		if (!non_swap_entry(entry))
+			mte_restore_tags(entry, page);
 	}
 
 	if (!pte_is_tagged)
 		return;
 
-	mte_clear_page_tags(page_address(page));
-	set_page_mte_tagged(page);
+	if (try_page_mte_tagging(page)) {
+		mte_clear_page_tags(page_address(page));
+		set_page_mte_tagged(page);
+	}
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 817fdd1ab778..5626ddb540ce 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1068,15 +1068,19 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 					clear_user(tags, MTE_GRANULES_PER_PAGE);
 			kvm_release_pfn_clean(pfn);
 		} else {
+			/*
+			 * Only locking to serialise with a concurrent
+			 * set_pte_at() in the VMM but still overriding the
+			 * tags, hence ignoring the return value.
+			 */
+			try_page_mte_tagging(page);
 			num_tags = mte_copy_tags_from_user(maddr, tags,
 							MTE_GRANULES_PER_PAGE);
 
-			/*
-			 * Set the flag after checking the write
-			 * completed fully
-			 */
-			if (num_tags == MTE_GRANULES_PER_PAGE)
-				set_page_mte_tagged(page);
+			/* uaccess failed, don't leave stale tags */
+			if (num_tags != MTE_GRANULES_PER_PAGE)
+				mte_clear_page_tags(page);
+			set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5a131f009cf9..bebfd1e0bbf0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1066,7 +1066,7 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 		return;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!page_mte_tagged(page)) {
+		if (try_page_mte_tagging(page)) {
 			mte_clear_page_tags(page_address(page));
 			set_page_mte_tagged(page);
 		}
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 731d8a35701e..8dd5a8fe64b4 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -23,6 +23,8 @@ void copy_highpage(struct page *to, struct page *from)
 
 	if (system_supports_mte() && page_mte_tagged(from)) {
 		page_kasan_tag_reset(to);
+		/* It's a new page, shouldn't have been tagged yet */
+		WARN_ON_ONCE(!try_page_mte_tagging(to));
 		mte_copy_page_tags(kto, kfrom);
 		set_page_mte_tagged(to);
 	}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 629e886ceec4..b8b299d1736a 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -933,6 +933,8 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 
 void tag_clear_highpage(struct page *page)
 {
+	/* Newly allocated page, shouldn't have been tagged yet */
+	WARN_ON_ONCE(!try_page_mte_tagging(page));
 	mte_zero_clear_page_tags(page_address(page));
 	set_page_mte_tagged(page);
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index a78c1db23c68..cd508ba80ab1 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -46,16 +46,17 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-bool mte_restore_tags(swp_entry_t entry, struct page *page)
+void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 
 	if (!tags)
-		return false;
+		return;
 
-	mte_restore_page_tags(page_address(page), tags);
-
-	return true;
+	if (try_page_mte_tagging(page)) {
+		mte_restore_page_tags(page_address(page), tags);
+		set_page_mte_tagged(page);
+	}
 }
 
 void mte_invalidate_tags(int type, pgoff_t offset)
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
