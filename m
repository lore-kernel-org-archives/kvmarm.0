Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C96FC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 23:03:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C684B8F9;
	Tue, 15 Nov 2022 18:03:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zDoZaqUffoFg; Tue, 15 Nov 2022 18:03:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 737064B8CF;
	Tue, 15 Nov 2022 18:03:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B34C04B6BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 18:03:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aId+HSskSxvR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 18:03:47 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 503644B644
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 18:03:47 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id
 u8-20020a17090a5e4800b002106dcdd4a0so573404pji.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 15:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=TM8ZdzPY8VeCgsKf+mKszlJ7zUv1Tn1f4qoClWbV9mo=;
 b=BmG3IRmGqa6sSXc7X5ymjmBqJaVvVnv1G8UM2GvrkOLZPq7P/z0BGh+/mNT7YQ2eRc
 A46tBakC/1l6o+WNXGSpYoRzV+ssLP0VRrezbi1aOHPtqIQuDWC4RHdkYlTdBbjJlceX
 6FY1ofXCLSBBblzs0/fagqt4I1sHsOGRvi8wMzM4ElQigsfeoC23Xp5IvDM+Fj6t5pyT
 YFwG1CFKcEmbDjdgTP1VIr8Thso8mDtOruzE89XXPPTGjy4183N0nc1QKNG5iZF0ujqX
 7MS8CNh6pZrgC9qZe5WeDlcJMo7CGigRknomBv/aA4Yi7ckFWu/Q3lIx/uqKqJBF4hXf
 yEvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=TM8ZdzPY8VeCgsKf+mKszlJ7zUv1Tn1f4qoClWbV9mo=;
 b=ItEz7IcWcn3n/yJ9sqU83ApemZLrnRwT3ZBWWQeExN4fnd/fYKTwOuIiAjuLhBNLzZ
 rw/QFIAiJcVdw/NpVJtbAeM72Z8tT0DaHDRdnwcHk7nLEsCo9G1u0m2yjOuAwWtIDdFA
 FqWDTKWeBFp/xLBbUkWd15KrafEmkZ+6s07phskfBIfW+wnK+jxb4KkW+ZeZW+Kt2dWh
 oB/ElwuZb6ZXT0YlvDt8sB36Kr5cnlYzexRHObLxR9j7FMulEq9yJTN1kVQbP25TkxAL
 2EGAYgLD6tWrFzzyH4vSVjdk2oHfqkD8vGQSonczDnfrWJo9NEpuDiCWdabXjHV1LzWg
 Kz3w==
X-Gm-Message-State: ANoB5pl6qE8LWRfSQpjrg9FePyagFUFg4XWe5GYoQ4hcYOAYbOLDBaPL
 uQQsJFqGAIhqzwG/Nj7h/mHUzw==
X-Google-Smtp-Source: AA0mqf7LfXsB/10HJv75H+dYIS42WcgKPLR/Zxv/4knjej8JRdnsPljaNjB0k7wvSobjL6dcK8km+g==
X-Received: by 2002:a17:902:8c95:b0:17c:1c61:4aec with SMTP id
 t21-20020a1709028c9500b0017c1c614aecmr6314073plo.112.1668553426142; 
 Tue, 15 Nov 2022 15:03:46 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 g3-20020a170902868300b00168dadc7354sm10473426plo.78.2022.11.15.15.03.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Nov 2022 15:03:45 -0800 (PST)
Date: Tue, 15 Nov 2022 15:03:42 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3QazjAUVE+T6rHh@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
 <Y3KrHG4WMXMUquUy@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3KrHG4WMXMUquUy@google.com>
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

On Mon, Nov 14, 2022 at 08:54:52PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Sat, Nov 12, 2022 at 08:17:06AM +0000, Ricardo Koller wrote:
> 
> [...]
> 
> > +/**
> > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > + *				to PAGE_SIZE guest pages.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @addr:	Intermediate physical address from which to split.
> > + * @size:	Size of the range.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > + *		page-table pages.
> > + *
> > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > + * the top level huge-page block size. This is an exampe using 1GB
> > + * huge-pages and 4KB granules.
> > + *
> > + *                          [---input range---]
> > + *                          :                 :
> > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > + *                          :                 :
> > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > + *                          :                 :
> > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > + *                          :                 :
> > + *
> > + * Return: 0 on success, negative error code on failure. Note that
> > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > + * blocks in the input range as allowed by the size of the memcache. It
> > + * will fail it wasn't able to break any block.
> > + */
> > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > +
> >  /**
> >   * kvm_pgtable_walk() - Walk a page-table.
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index d1f309128118..9c42eff6d42e 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
> >  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
> >  }
> >  
> > +struct stage2_split_data {
> > +	struct kvm_s2_mmu		*mmu;
> > +	void				*memcache;
> > +	struct kvm_pgtable_mm_ops	*mm_ops;
> 
> You can also get at mm_ops through kvm_pgtable_visit_ctx
> 
> > +};
> > +
> > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > +			       enum kvm_pgtable_walk_flags visit)
> > +{
> > +	struct stage2_split_data *data = ctx->arg;
> > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > +	kvm_pte_t pte = ctx->old, attr, new;
> > +	enum kvm_pgtable_prot prot;
> > +	void *mc = data->memcache;
> > +	u32 level = ctx->level;
> > +	u64 phys;
> > +
> > +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> > +		return -EINVAL;
> > +
> > +	/* Nothing to split at the last level */
> > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > +		return 0;
> > +
> > +	/* We only split valid block mappings */
> > +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > +		return 0;
> > +
> > +	phys = kvm_pte_to_phys(pte);
> > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> > +
> > +	/*
> > +	 * Eager page splitting is best-effort, so we can ignore the error.
> > +	 * The returned PTE (new) will be valid even if this call returns
> > +	 * error: new will be a single (big) block PTE.  The only issue is
> > +	 * that it will affect dirty logging performance, as the huge-pages
> > +	 * will have to be split on fault, and so we WARN.
> > +	 */
> > +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
> 
> I don't believe we should warn in this case, at least not
> unconditionally. ENOMEM is an expected outcome, for example.

Given that "eager page splitting" is best-effort, the error must be
ignored somewhere: either here or by the caller (in mmu.c). It seems
that ignoring the error here is not a very good idea.

> 
> Additionally, I believe you'll want to bail out at this point to avoid
> installing a potentially garbage PTE as well.

It should be fine as stage2_create_removed() is also best-effort. The
returned PTE is valid even when it fails; it just returns a big block
PTE.

> 
> > +	stage2_put_pte(ctx, data->mmu, mm_ops);
> 
> Ah, I see why you've relaxed the WARN in patch 1 now.
> 
> I would recommend you follow the break-before-make pattern and use the
> helpers here as well. stage2_try_break_pte() will demote the store to
> WRITE_ONCE() if called from a non-shared context.
> 

ACK, I can do that. The only reason why I didnt' is because I would have
to handle the potential error from stage2_try_break_pte(). It would feel
wrong not to, even if it's !shared. On the other hand, I would like to
easily experiment with both the !shared and the shared approaches
easily.

> Then the WARN will behave as expected in stage2_make_pte().
> 
> > +	/*
> > +	 * Note, the contents of the page table are guaranteed to be made
> > +	 * visible before the new PTE is assigned because
> > +	 * stage2_make__pte() writes the PTE using smp_store_release().
> 
> typo: stage2_make_pte()
> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
