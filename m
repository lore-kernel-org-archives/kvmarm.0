Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AC9C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:51:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 378CB4C85C;
	Thu, 21 Jul 2022 21:51:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z5lslDimS2ZS; Thu, 21 Jul 2022 21:51:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D13CD4C6EF;
	Thu, 21 Jul 2022 21:51:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6623B4C708
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mJ2uu4cU5DC6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:50:58 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F330F4C6EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:50:57 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 i9-20020a17090a65c900b001f03395643dso3571214pjs.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=G41tbuvTTPW6zkdCe8wHBosjwKpQceeHJL92UYH85/M=;
 b=QDn39yK9q01HYmpkQV+8GM3LGuqP0vzNlq/pA6C4RzjaTLXTYUKRCzPRxsTRmYme18
 J6Th6l8Hh3KTdoRnnNNZFRpB9KvAxCLk5fgCiBVGCgwto2MO1pgc3sBudTNCKENNGWP1
 VIvGrSpV+jSq+bM5Ssh4cyjBYQ0lo2R/RT7xO63h5yUjZ3RvZeWksOA6w5dzgzavkDQT
 2bVneD12EpTaWbEBDvhNkMuQdkXEI9AnO+xbHqwiLOx0apvVrbuvFVZf6fYoOw13Pekf
 pfgnrafAwwKJLGC/bBRuRiPrjKrDcivSZ0N8WQua9GCHGSs1+Cmvcm5jd+bWkomf5DLW
 /V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=G41tbuvTTPW6zkdCe8wHBosjwKpQceeHJL92UYH85/M=;
 b=CIpHCBYCwbpx+3qJHT5k9Gk1VOrBj+5DB6XOwkIN9lTtBxDUXulLh3UmzZSTjY/6bC
 LM+CL6a7hQ5nWtUorA+zeAGNFl/4293GdOrN3rdqyVMMRx9hDVPrSlxPHMW8NIzqop+6
 p3/RnQZCaHUPJoquX49eh+hkeeaZeMmD+bNNCToaySeWbsH5O8bl4sNwM8iKS78BSKRX
 dYbr+v0z/sEB5U9d2G63CvHe9J5KJDI4AzNWMTiMumS5h3izwfMsTqIx7UU4sOdICFQe
 HdzczqEa3l+rqZwHYxBbrwYaVJ4SYatp15sVD7Coy1OTB/FAq2wLnyQ7GqCf4O6leceZ
 6gHQ==
X-Gm-Message-State: AJIora9XijBZdD2sq7AyFmwee9bKio4C2fkWuNGtYjFB0TguZ/ST3dt7
 EXE276cYeyzfOeicoeTMzb+6LmI=
X-Google-Smtp-Source: AGRyM1ubxDRuTW9mlC85urAd+IAaVp2dWj91vy347i4RKelsCRO4mwADKJ+xjoFdUND5bBdmTHbxA+k=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a17:90a:49c4:b0:1f2:2448:60e9 with SMTP id
 l4-20020a17090a49c400b001f2244860e9mr1452545pjm.148.1658454656955; Thu, 21
 Jul 2022 18:50:56 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:27 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-2-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 1/7] arm64: mte: Fix/clarify the PG_mte_tagged semantics
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

Currently the PG_mte_tagged page flag mostly means the page contains
valid tags and it should be set after the tags have been cleared or
restored. However, in mte_sync_tags() it is set before setting the tags
to avoid, in theory, a race with concurrent mprotect(PROT_MTE) for
shared pages. However, a concurrent mprotect(PROT_MTE) with a copy on
write in another thread can cause the new page to have stale tags.
Similarly, tag reading via ptrace() can read stale tags of the
PG_mte_tagged flag is set before actually clearing/restoring the tags.

Fix the PG_mte_tagged semantics so that it is only set after the tags
have been cleared or restored. This is safe for swap restoring into a
MAP_SHARED or CoW page since the core code takes the page lock. Add two
functions to test and set the PG_mte_tagged flag with acquire and
release semantics. The downside is that concurrent mprotect(PROT_MTE) on
a MAP_SHARED page may cause tag loss. This is already the case for KVM
guests if a VMM changes the page protection while the guest triggers a
user_mem_abort().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/include/asm/mte.h     | 30 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/arm64/kernel/cpufeature.c   |  4 +++-
 arch/arm64/kernel/elfcore.c      |  2 +-
 arch/arm64/kernel/hibernate.c    |  2 +-
 arch/arm64/kernel/mte.c          | 12 +++++++-----
 arch/arm64/kvm/guest.c           |  4 ++--
 arch/arm64/kvm/mmu.c             |  4 ++--
 arch/arm64/mm/copypage.c         |  4 ++--
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/mteswap.c          |  2 +-
 11 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index aa523591a44e..c69218c56980 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -37,6 +37,29 @@ void mte_free_tag_storage(char *storage);
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+	/*
+	 * Ensure that the tags written prior to this function are visible
+	 * before the page flags update.
+	 */
+	smp_wmb();
+	set_bit(PG_mte_tagged, &page->flags);
+}
+
+static inline bool page_mte_tagged(struct page *page)
+{
+	bool ret = test_bit(PG_mte_tagged, &page->flags);
+
+	/*
+	 * If the page is tagged, ensure ordering with a likely subsequent
+	 * read of the tags.
+	 */
+	if (ret)
+		smp_rmb();
+	return ret;
+}
+
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
@@ -54,6 +77,13 @@ size_t mte_probe_user_range(const char __user *uaddr, size_t size);
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
+static inline set_page_mte_tagged(struct page *page)
+{
+}
+static inline bool page_mte_tagged(struct page *page)
+{
+	return false;
+}
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index b5df82aa99e6..82719fa42c0e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1050,7 +1050,7 @@ static inline void arch_swap_invalidate_area(int type)
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_bit(PG_mte_tagged, &folio->flags);
+		set_page_mte_tagged(&folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index fae4c7a785d8..c66f0ffaaf47 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2020,8 +2020,10 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
+	if (!page_mte_tagged(ZERO_PAGE(0))) {
 		mte_clear_page_tags(lm_alias(empty_zero_page));
+		set_page_mte_tagged(ZERO_PAGE(0));
+	}
 
 	kasan_init_hw_tags_cpu();
 }
diff --git a/arch/arm64/kernel/elfcore.c b/arch/arm64/kernel/elfcore.c
index 27ef7ad3ffd2..353009d7f307 100644
--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -47,7 +47,7 @@ static int mte_dump_tag_range(struct coredump_params *cprm,
 		 * Pages mapped in user space as !pte_access_permitted() (e.g.
 		 * PROT_EXEC only) may not have the PG_mte_tagged flag set.
 		 */
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			put_page(page);
 			dump_skip(cprm, MTE_PAGE_TAG_STORAGE);
 			continue;
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index af5df48ba915..788597a6b6a2 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -271,7 +271,7 @@ static int swsusp_mte_save_tags(void)
 			if (!page)
 				continue;
 
-			if (!test_bit(PG_mte_tagged, &page->flags))
+			if (!page_mte_tagged(page))
 				continue;
 
 			ret = save_tags(page, pfn);
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index b2b730233274..2287316639f3 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,14 +41,17 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
+		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
+			set_page_mte_tagged(page);
 			return;
+		}
 	}
 
 	if (!pte_is_tagged)
 		return;
 
 	mte_clear_page_tags(page_address(page));
+	set_page_mte_tagged(page);
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -64,7 +67,7 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+		if (!page_mte_tagged(page))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
 	}
@@ -91,8 +94,7 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	 * pages is tagged, set_pte_at() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
-	if (test_bit(PG_mte_tagged, &page1->flags) ||
-	    test_bit(PG_mte_tagged, &page2->flags))
+	if (page_mte_tagged(page1) || page_mte_tagged(page2))
 		return addr1 != addr2;
 
 	return ret;
@@ -398,7 +400,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!page_mte_tagged(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 8c607199cad1..3b04e69006b4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1058,7 +1058,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		maddr = page_address(page);
 
 		if (!write) {
-			if (test_bit(PG_mte_tagged, &page->flags))
+			if (page_mte_tagged(page))
 				num_tags = mte_copy_tags_to_user(tags, maddr,
 							MTE_GRANULES_PER_PAGE);
 			else
@@ -1075,7 +1075,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			 * completed fully
 			 */
 			if (num_tags == MTE_GRANULES_PER_PAGE)
-				set_bit(PG_mte_tagged, &page->flags);
+				set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 87f1cd0df36e..c9012707f69c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1075,9 +1075,9 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 		return -EFAULT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			mte_clear_page_tags(page_address(page));
-			set_bit(PG_mte_tagged, &page->flags);
+			set_page_mte_tagged(page);
 		}
 	}
 
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 24913271e898..4223389b6180 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,9 +21,9 @@ void copy_highpage(struct page *to, struct page *from)
 
 	copy_page(kto, kfrom);
 
-	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
-		set_bit(PG_mte_tagged, &to->flags);
+	if (system_supports_mte() && page_mte_tagged(from)) {
 		mte_copy_page_tags(kto, kfrom);
+		set_page_mte_tagged(to);
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c33f1fad2745..d095bfa16771 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -931,5 +931,5 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 void tag_clear_highpage(struct page *page)
 {
 	mte_zero_clear_page_tags(page_address(page));
-	set_bit(PG_mte_tagged, &page->flags);
+	set_page_mte_tagged(page);
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 4334dec93bd4..a78c1db23c68 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -24,7 +24,7 @@ int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!test_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page))
 		return 0;
 
 	tag_storage = mte_allocate_tag_storage();
-- 
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
