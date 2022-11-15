Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D761C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 23:54:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E904B867;
	Tue, 15 Nov 2022 18:54:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Nh9k3MbdOaiL; Tue, 15 Nov 2022 18:54:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0509A4B8A4;
	Tue, 15 Nov 2022 18:54:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D0A4B8A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 18:54:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jQB8Eh7lZ1In for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 18:54:33 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB4D84B857
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 18:54:33 -0500 (EST)
Date: Tue, 15 Nov 2022 23:54:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668556472;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=SPoNWEOfxj5oSQUwc6fzPdArrPmggu306RyPVtoYCfI=;
 b=Al/mGR9paAD6/nP38vYFD2aWIq7kOV3sFxycN4oS5pPhRWH9PyLWQllRCHLvWsSOLcZkM8
 xWlAJ9WwNbafyI4tU4OgJoSJQV3pFNnzbA+zNcTGFtfaA91SqEFxeHRm7ctrSPc/wSZXSL
 WuYgXQCDJB9BcnYSpSyBI3xONITv5Og=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3Qms0lbCiLFJvG+@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
 <Y3KrHG4WMXMUquUy@google.com> <Y3QazjAUVE+T6rHh@google.com>
 <Y3QgVqSUCm8kdbeN@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3QgVqSUCm8kdbeN@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: ricarkol@gmail.com, kvm@vger.kernel.org, catalin.marinas@arm.com,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev, bgardon@google.com,
 maz@kernel.org, dmatlack@google.com, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Nov 15, 2022 at 03:27:18PM -0800, Ricardo Koller wrote:
> On Tue, Nov 15, 2022 at 03:03:42PM -0800, Ricardo Koller wrote:
> > On Mon, Nov 14, 2022 at 08:54:52PM +0000, Oliver Upton wrote:

[...]

> > > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > > index d1f309128118..9c42eff6d42e 100644
> > > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > > @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
> > > >  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
> > > >  }
> > > >  
> > > > +struct stage2_split_data {
> > > > +	struct kvm_s2_mmu		*mmu;
> > > > +	void				*memcache;
> > > > +	struct kvm_pgtable_mm_ops	*mm_ops;
> > > 
> > > You can also get at mm_ops through kvm_pgtable_visit_ctx
> > > 
> > > > +};
> > > > +
> > > > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > > +			       enum kvm_pgtable_walk_flags visit)
> > > > +{
> > > > +	struct stage2_split_data *data = ctx->arg;
> > > > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > > > +	kvm_pte_t pte = ctx->old, attr, new;
> > > > +	enum kvm_pgtable_prot prot;
> > > > +	void *mc = data->memcache;
> > > > +	u32 level = ctx->level;
> > > > +	u64 phys;
> > > > +
> > > > +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> > > > +		return -EINVAL;
> > > > +
> > > > +	/* Nothing to split at the last level */
> > > > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > > > +		return 0;
> > > > +
> > > > +	/* We only split valid block mappings */
> > > > +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > > > +		return 0;
> > > > +
> > > > +	phys = kvm_pte_to_phys(pte);
> > > > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > > > +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> > > > +
> > > > +	/*
> > > > +	 * Eager page splitting is best-effort, so we can ignore the error.
> > > > +	 * The returned PTE (new) will be valid even if this call returns
> > > > +	 * error: new will be a single (big) block PTE.  The only issue is
> > > > +	 * that it will affect dirty logging performance, as the huge-pages
> > > > +	 * will have to be split on fault, and so we WARN.
> > > > +	 */
> > > > +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
> > > 
> > > I don't believe we should warn in this case, at least not
> > > unconditionally. ENOMEM is an expected outcome, for example.
> > 
> > Given that "eager page splitting" is best-effort, the error must be
> > ignored somewhere: either here or by the caller (in mmu.c). It seems
> > that ignoring the error here is not a very good idea.
> 
> Actually, ignoring the error here simplifies the error handling.
> stage2_create_removed() is best-effort; here's an example.  If
> stage2_create_removed() was called to split a 1G block PTE, and it
> wasn't able to split all 2MB blocks, it would return ENOMEM and a valid
> PTE pointing to a tree like this:
> 
> 		[---------1GB-------------]
> 		:                         :
> 		[--2MB--][--2MB--][--2MB--]
> 		:       :
> 		[ ][ ][ ]
> 
> If we returned ENOMEM instead of ignoring the error, we would have to
> clean all the intermediate state.  But stage2_create_removed() is
> designed to always return a valid PTE, even if the tree is not fully
> split (as above).  So, there's no really need to clean it: it's a valid
> tree. Moreover, this valid tree would result in better dirty logging
> performance as it already has some 2M blocks split into 4K pages.

I have no issue with installing a partially-populated table, but
unconditionally ignoring the return code and marching onwards seems
dangerous. If you document the behavior of -ENOMEM on
stage2_create_removed() and return early for anything else it may read a
bit better.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
