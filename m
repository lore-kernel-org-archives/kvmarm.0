Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929BEC4332F
	for <kvmarm@archiver.kernel.org>; Wed,  9 Nov 2022 22:54:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F0DF4B9F6;
	Wed,  9 Nov 2022 17:54:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M6wVUjENcTf7; Wed,  9 Nov 2022 17:54:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A856F4BA0B;
	Wed,  9 Nov 2022 17:54:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 125234B9F9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:54:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8CEGeOzt32Ji for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Nov 2022 17:54:51 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE8254B9F6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Nov 2022 17:54:51 -0500 (EST)
Date: Wed, 9 Nov 2022 22:54:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668034486;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=4eBpAl0Bh9NbuP8Ymsao9EXIdBXAUBLyzei2R+zKTK8=;
 b=uhfXgpyEfhg4Ga1kHg1dG1UjMBRbTcsJYPhEvleu3pIn5o6JkiV3G0MJUARNHQWtBwdZfO
 Q3JulEggtEgv8DaRX5dfmSTgDs8ICLIy8tc2l7+wgxjTKy0UC+TxffojFH2TbMkz65+BlC
 A8ewu8EoWavvaOt+sYbKUsKJa2UEAl0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v5 05/14] KVM: arm64: Add a helper to tear down unlinked
 stage-2 subtrees
Message-ID: <Y2wvsR6DvyM5YzqN@google.com>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-6-oliver.upton@linux.dev>
 <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANgfPd_vAmVR0BTLTFAXuQhS-bP7+B_+2s6cDmTeM5=mf440Gg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
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

On Wed, Nov 09, 2022 at 02:23:33PM -0800, Ben Gardon wrote:
> On Mon, Nov 7, 2022 at 1:57 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > A subsequent change to KVM will move the tear down of an unlinked
> > stage-2 subtree out of the critical path of the break-before-make
> > sequence.
> >
> > Introduce a new helper for tearing down unlinked stage-2 subtrees.
> > Leverage the existing stage-2 free walkers to do so, with a deep call
> > into __kvm_pgtable_walk() as the subtree is no longer reachable from the
> > root.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 11 +++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 23 +++++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index a752793482cb..93b1feeaebab 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -333,6 +333,17 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >   */
> >  void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >
> > +/**
> > + * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
> > + * @mm_ops:    Memory management callbacks.
> > + * @pgtable:   Unlinked stage-2 paging structure to be freed.
> > + * @level:     Level of the stage-2 paging structure to be freed.
> > + *
> > + * The page-table is assumed to be unreachable by any hardware walkers prior to
> > + * freeing and therefore no TLB invalidation is performed.
> > + */
> > +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +
> >  /**
> >   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >   * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 93989b750a26..363a5cce7e1a 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1203,3 +1203,26 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> >         pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> >         pgt->pgd = NULL;
> >  }
> > +
> > +void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
> > +{
> > +       kvm_pte_t *ptep = (kvm_pte_t *)pgtable;
> > +       struct kvm_pgtable_walker walker = {
> > +               .cb     = stage2_free_walker,
> > +               .flags  = KVM_PGTABLE_WALK_LEAF |
> > +                         KVM_PGTABLE_WALK_TABLE_POST,
> > +       };
> > +       struct kvm_pgtable_walk_data data = {
> > +               .walker = &walker,
> > +
> > +               /*
> > +                * At this point the IPA really doesn't matter, as the page
> > +                * table being traversed has already been removed from the stage
> > +                * 2. Set an appropriate range to cover the entire page table.
> > +                */
> > +               .addr   = 0,
> > +               .end    = kvm_granule_size(level),
> > +       };
> > +
> > +       WARN_ON(__kvm_pgtable_walk(&data, mm_ops, ptep, level));
> > +}
> 
> Will this callback be able to yield? In my experience, if processing a
> large teardown (i.e. level >=3 / maps 512G region) it's possible to
> hit scheduler tick warnings.

No, but this is a pretty obvious problem with all of our table walkers,
which led to commit 5994bc9e05c2 ("KVM: arm64: Limit
stage2_apply_range() batch size to largest block").

We're lucky in that the largest supported granule across all page table
sizes is 1GB (no true 5-level paging yet), so it may not be too
horrendous.

But yeah, it is on the list of things to fix :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
