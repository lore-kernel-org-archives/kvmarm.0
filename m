Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920FDC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 17:05:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5EF149B0E;
	Fri, 24 Jun 2022 13:05:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KP4itl6u4d0Q; Fri, 24 Jun 2022 13:05:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6802548F94;
	Fri, 24 Jun 2022 13:05:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E49843482
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 13:05:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O4QR83N8aaad for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 13:05:30 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B88DD40FF0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 13:05:30 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DE915B82AC8;
 Fri, 24 Jun 2022 17:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FC0C34114;
 Fri, 24 Jun 2022 17:05:25 +0000 (UTC)
Date: Fri, 24 Jun 2022 18:05:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <YrXu0Uzi73pUDwye@arm.com>
References: <20220623234944.141869-1-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220623234944.141869-1-pcc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andy Lutomirski <luto@amacapital.net>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
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

+ Steven as he added the KVM and swap support for MTE.

On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> depend on being able to map guest memory as MAP_SHARED. The current
> restriction on sharing MAP_SHARED pages with the guest is preventing
> the use of those features with MTE. Therefore, remove this restriction.

We already have some corner cases where the PG_mte_tagged logic fails
even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
KVM MAP_SHARED will potentially make things worse (or hard to reason
about; for example the VMM sets PROT_MTE as well). I'm more inclined to
get rid of PG_mte_tagged altogether, always zero (or restore) the tags
on user page allocation, copy them on write. For swap we can scan and if
all tags are 0 and just skip saving them.

Another aspect is a change in the KVM ABI with this patch. It's probably
not that bad since it's rather a relaxation but it has the potential to
confuse the VMM, especially as it doesn't know whether it's running on
older kernels or not (it would have to probe unless we expose this info
to the VMM in some other way).

> To avoid races between multiple tasks attempting to clear tags on the
> same page, introduce a new page flag, PG_mte_tag_clearing, and test-set it
> atomically before beginning to clear tags on a page. If the flag was not
> initially set, spin until the other task has finished clearing the tags.

TBH, I can't mentally model all the corner cases, so maybe a formal
model would help (I can have a go with TLA+, though not sure when I find
a bit of time this summer). If we get rid of PG_mte_tagged altogether,
this would simplify things (hopefully).

As you noticed, the problem is that setting PG_mte_tagged and clearing
(or restoring) the tags is not an atomic operation. There are places
like mprotect() + CoW where one task can end up with stale tags. Another
is shared memfd mappings if more than one mapping sets PROT_MTE and
there's the swap restoring on top.

> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index f6b00743c399..8f9655053a9f 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -57,7 +57,18 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>  	 * the new page->flags are visible before the tags were updated.
>  	 */
>  	smp_wmb();
> -	mte_clear_page_tags(page_address(page));
> +	mte_ensure_page_tags_cleared(page);
> +}
> +
> +void mte_ensure_page_tags_cleared(struct page *page)
> +{
> +	if (test_and_set_bit(PG_mte_tag_clearing, &page->flags)) {
> +		while (!test_bit(PG_mte_tagged, &page->flags))
> +			;
> +	} else {
> +		mte_clear_page_tags(page_address(page));
> +		set_bit(PG_mte_tagged, &page->flags);
> +	}
>  }

mte_sync_tags() already sets PG_mte_tagged prior to clearing the page
tags. The reason was so that multiple concurrent set_pte_at() would not
all rush to clear (or restore) the tags. But we do have the risk of one
thread accessing the page with the stale tags (copy_user_highpage() is
worse as the tags would be wrong in the destination page). I'd rather be
consistent everywhere with how we set the flags.

However, I find it easier to reason about if we used the new flag as a
lock. IOW, if PG_mte_tagged is set, we know that tags are valid. If not
set, take the PG_mte_locked flag, check PG_mte_tagged again and
clear/restore the tags followed by PG_mte_tagged (and you can use
test_and_set_bit_lock() for the acquire semantics).

It would be interesting to benchmark the cost of always zeroing the tags
on allocation and copy when MTE is not in use:

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 0dea80bf6de4..d31708886bf9 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,7 +21,7 @@ void copy_highpage(struct page *to, struct page *from)
 
 	copy_page(kto, kfrom);
 
-	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
+	if (system_supports_mte()) {
 		set_bit(PG_mte_tagged, &to->flags);
 		page_kasan_tag_reset(to);
 		/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index c5e11768e5c1..b42cad9b9349 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -913,12 +913,7 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 {
 	gfp_t flags = GFP_HIGHUSER_MOVABLE | __GFP_ZERO;
 
-	/*
-	 * If the page is mapped with PROT_MTE, initialise the tags at the
-	 * point of allocation and page zeroing as this is usually faster than
-	 * separate DC ZVA and STGM.
-	 */
-	if (vma->vm_flags & VM_MTE)
+	if (system_supports_mte())
 		flags |= __GFP_ZEROTAGS;
 
 	return alloc_page_vma(flags, vma, vaddr);

If that's negligible, we can hopefully get rid of PG_mte_tagged. For
swap we could move the restoring to arch_do_swap_page() (but move the
call one line above set_pte_at() in do_swap_page()).

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
