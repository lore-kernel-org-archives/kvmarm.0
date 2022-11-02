Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB30C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:03:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA784B78C;
	Wed,  2 Nov 2022 19:03:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w8+x8UII+iH7; Wed,  2 Nov 2022 19:03:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FE074B731;
	Wed,  2 Nov 2022 19:03:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D534B731
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:03:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NI9cI5DxA9Ix for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:03:33 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 947D440011
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:03:33 -0400 (EDT)
Date: Wed, 2 Nov 2022 23:03:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667430212;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8fItX3vRxpcg1fIXQ7MC8RTpVUphAL0Q9POdM3EENmg=;
 b=v641THQDw6XI9nwIPdNT7rOvfbMaJ7JxR2WafFzpT2bm3X17BdA8VtYOWgpWrrBsFrM5ye
 WiULMqikaTV+/hGMhItUBi3gzmxzQQXg8k+D9U2J5ldxuVn+ZaTccXAPtCMsezjgtYavPf
 EjiM1ZpvZ/OoUOquC2pj986t8H7Lr+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 12/15] KVM: arm64: Make block->table PTE changes
 parallel-aware
Message-ID: <Y2L3Pwz6HsQ8mq17@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027222247.1685023-1-oliver.upton@linux.dev>
 <Y2HUebPnIgzLim0w@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y2HUebPnIgzLim0w@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Will Deacon <will@kernel.org>, Ben Gardon <bgardon@google.com>,
 David Matlack <dmatlack@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Nov 01, 2022 at 07:22:49PM -0700, Ricardo Koller wrote:
> On Thu, Oct 27, 2022 at 10:22:47PM +0000, Oliver Upton wrote:
> > In order to service stage-2 faults in parallel, stage-2 table walkers
> > must take exclusive ownership of the PTE being worked on. An additional
> > requirement of the architecture is that software must perform a
> > 'break-before-make' operation when changing the block size used for
> > mapping memory.
> > 
> > Roll these two concepts together into helpers for performing a
> > 'break-before-make' sequence. Use a special PTE value to indicate a PTE
> > has been locked by a software walker. Additionally, use an atomic
> > compare-exchange to 'break' the PTE when the stage-2 page tables are
> > possibly shared with another software walker. Elide the DSB + TLBI if
> > the evicted PTE was invalid (and thus not subject to break-before-make).
> > 
> > All of the atomics do nothing for now, as the stage-2 walker isn't fully
> > ready to perform parallel walks.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/hyp/pgtable.c | 82 +++++++++++++++++++++++++++++++++---
> >  1 file changed, 76 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 4c579b3beabf..1df858c21b2e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -49,6 +49,12 @@
> >  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
> >  #define KVM_MAX_OWNER_ID		1
> >  
> > +/*
> > + * Used to indicate a pte for which a 'break-before-make' sequence is in
> > + * progress.
> > + */
> > +#define KVM_INVALID_PTE_LOCKED		BIT(10)
> > +
> >  struct kvm_pgtable_walk_data {
> >  	struct kvm_pgtable_walker	*walker;
> >  
> > @@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >  	return !!pte;
> >  }
> >  
> > +static bool stage2_pte_is_locked(kvm_pte_t pte)
> > +{
> > +	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
> > +}
> > +
> >  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
> >  {
> >  	if (!kvm_pgtable_walk_shared(ctx)) {
> > @@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
> >  	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
> >  }
> >  
> > +/**
> > + * stage2_try_break_pte() - Invalidates a pte according to the
> > + *			    'break-before-make' requirements of the
> > + *			    architecture.
> > + *
> > + * @ctx: context of the visited pte.
> > + * @data: stage-2 map data
> > + *
> > + * Returns: true if the pte was successfully broken.
> > + *
> > + * If the removed pte was valid, performs the necessary serialization and TLB
> > + * invalidation for the old value. For counted ptes, drops the reference count
> > + * on the containing table page.
> > + */
> > +static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
> > +				 struct stage2_map_data *data)
> 
> Would it be possible to pass "kvm_s2_mmu *mmu" directly (instead of
> "stage2_map_data *data")? so this function can be reused by other
> walkers.

Sure, and I presume the ask is coming because you're layering eager page
splitting on top of this right? :-)

> Another option would be to stash "struct kvm_s2_mmu" in
> "struct kvm_pgtable_visit_ctx".

I don't think we'd want to do that. kvm_pgtable_visit_ctx is shared
amongst all walkers, including the hypervisor stage-1.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
