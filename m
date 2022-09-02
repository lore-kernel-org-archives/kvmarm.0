Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E49C001B5
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 16:58:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D381D41173;
	Fri,  2 Sep 2022 12:58:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DrFxuG1hdBBg; Fri,  2 Sep 2022 12:58:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84FA640C1F;
	Fri,  2 Sep 2022 12:58:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 277D140C1F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 12:58:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L+P3YfwrO0AN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 12:58:27 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADF3040719
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 12:58:27 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 14194B82CCA;
 Fri,  2 Sep 2022 16:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA65C433D7;
 Fri,  2 Sep 2022 16:58:22 +0000 (UTC)
Date: Fri, 2 Sep 2022 17:58:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 4/7] arm64: mte: Lock a page for MTE tag initialisation
Message-ID: <YxI2KzTxnCP2vKDo@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-5-pcc@google.com>
 <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
 <YxIvP+a2P0DGIUrA@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YxIvP+a2P0DGIUrA@arm.com>
Cc: kvm@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Evgenii Stepanov <eugenis@google.com>,
 Marc Zyngier <maz@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 02, 2022 at 05:28:47PM +0100, Catalin Marinas wrote:
> On Fri, Sep 02, 2022 at 03:47:33PM +0100, Steven Price wrote:
> > On 10/08/2022 20:30, Peter Collingbourne wrote:
> > > diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
> > > index a78c1db23c68..cd5ad0936e16 100644
> > > --- a/arch/arm64/mm/mteswap.c
> > > +++ b/arch/arm64/mm/mteswap.c
> > > @@ -53,6 +53,9 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
> > >  	if (!tags)
> > >  		return false;
> > >  
> > > +	/* racing tag restoring? */
> > > +	if (!try_page_mte_tagging(page))
> > > +		return false;
> > >  	mte_restore_page_tags(page_address(page), tags);
> > 
> > I feel like adding a "set_page_mte_tagged(page);" in here would avoid
> > the need for the comments about mte_restore_tags() taking the lock.
> 
> Good point. I think I blindly followed the set_bit() places but it makes
> sense to move the bit setting to mte_restore_tags().

Something like this (and I need to do some more testing):

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index b956899467f0..be6560e1ff2b 100644
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
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e6b82ad1e9e6..7d91379382fd 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1049,9 +1049,8 @@ static inline void arch_swap_invalidate_area(int type)
 #define __HAVE_ARCH_SWAP_RESTORE
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
-	/* mte_restore_tags() takes the PG_mte_lock */
-	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_page_mte_tagged(&folio->page);
+	if (system_supports_mte())
+		mte_restore_tags(entry, &folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 634e089b5933..54ab6c4741db 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,11 +41,8 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		/* mte_restore_tags() takes the PG_mte_lock */
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
-			set_page_mte_tagged(page);
-			return;
-		}
+		if (!non_swap_entry(entry))
+			mte_restore_tags(entry, page);
 	}
 
 	if (!pte_is_tagged)
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index cd5ad0936e16..cd508ba80ab1 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -46,19 +46,17 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-bool mte_restore_tags(swp_entry_t entry, struct page *page)
+void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 
 	if (!tags)
-		return false;
+		return;
 
-	/* racing tag restoring? */
-	if (!try_page_mte_tagging(page))
-		return false;
-	mte_restore_page_tags(page_address(page), tags);
-
-	return true;
+	if (try_page_mte_tagging(page)) {
+		mte_restore_page_tags(page_address(page), tags);
+		set_page_mte_tagged(page);
+	}
 }
 
 void mte_invalidate_tags(int type, pgoff_t offset)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
