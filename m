Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B6CC43219
	for <kvmarm@archiver.kernel.org>; Tue, 15 Nov 2022 23:27:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6924B8DF;
	Tue, 15 Nov 2022 18:27:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R4EUJoMh+0-P; Tue, 15 Nov 2022 18:27:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E5394B885;
	Tue, 15 Nov 2022 18:27:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E04FE4B86B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 18:27:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QqHIpcIjCzqH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Nov 2022 18:27:24 -0500 (EST)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
 [209.85.216.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C6544B845
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 18:27:24 -0500 (EST)
Received: by mail-pj1-f44.google.com with SMTP id
 v4-20020a17090a088400b00212cb0ed97eso640285pjc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Nov 2022 15:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=BcYVK3KaTBkQeFoNX2OW1U3l6SR7et/VkSr5AlqHjlI=;
 b=oK6Rm59tVlj0NeQ1/JwvaEVo1JJlAD+djNn86ZA3gUX6E9eOHMad9SuDyVcj+LGkY2
 7wKh7gW4tdgVVPAOECYKXu51+L3Kdd5m2HI4fXrhWbm17vJu35S0qbZ1jbRX9Obw9kNu
 TjkO7NFq6N4+PXdQHEIpoN2WThTOFPsuTBDpmajzjsepZbPDLYmNFFNDFn473Olg8Q/A
 esv9agR1jM6wwyASo++smnTUBR2kVRCwyWuX5pIyMQp58dTUsTup5XtJL0/lL/piCkd4
 bsrVTavN6wKhL563Wmd6MUO2jSucqj+LaHldnISnOw7ug9GN8Bz71M+KTGf2nzDLk7Yk
 dYvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=BcYVK3KaTBkQeFoNX2OW1U3l6SR7et/VkSr5AlqHjlI=;
 b=SQJGaFNtxQCQ/kkg+qjq2e6JgjwKedhiNxlqfOERRV81f41Jg6VjkKcX9uzcjENbLn
 iyuTb2a6mAzAKxK+QT4G6HPqvt+g74LHRC79gXIBwkw6R9t5OYMIDBjNy0zuP+rZJwBc
 59EBoCWbN03wq9YeUh+oMCzgSUCZ02tkIUPO84xeqpt6WkslGk1mi9H4zJM2fwtZhc2S
 X5mlItZ06HxGalz23IPkVhwVTThAZi6fUWzGbwzcniN09vuhbFXA4ZFJF/UOdym5Sx1g
 m3umyT+KG50Du8sI8D3MUlJJxAmDiv4ykajW/4BOPvZ4YUchcUbwJIs2ZVF9q6bPU0dL
 i5jw==
X-Gm-Message-State: ANoB5pkevPPdZf4ZYpN7N6GKC6mFvchooNhnPBbQBmh3xt8+TCbQbi2m
 38PE6HWcwqnTn3m9O4lkr26InA==
X-Google-Smtp-Source: AA0mqf4RsjoeOb2GmbtBKDdgQ+7Yeabu0A1nOuZNhHIDJBsr3S1XLcg3ufhWUez3zn07g0ISAHUOzw==
X-Received: by 2002:a17:902:6b8c:b0:188:6ccd:f2c5 with SMTP id
 p12-20020a1709026b8c00b001886ccdf2c5mr6278339plk.6.1668554843178; 
 Tue, 15 Nov 2022 15:27:23 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com.
 [34.82.181.220]) by smtp.gmail.com with ESMTPSA id
 k13-20020a170902ce0d00b0017f5ad327casm10453887plg.103.2022.11.15.15.27.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Nov 2022 15:27:22 -0800 (PST)
Date: Tue, 15 Nov 2022 15:27:18 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <Y3QgVqSUCm8kdbeN@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-5-ricarkol@google.com>
 <Y3KrHG4WMXMUquUy@google.com> <Y3QazjAUVE+T6rHh@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y3QazjAUVE+T6rHh@google.com>
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

On Tue, Nov 15, 2022 at 03:03:42PM -0800, Ricardo Koller wrote:
> On Mon, Nov 14, 2022 at 08:54:52PM +0000, Oliver Upton wrote:
> > Hi Ricardo,
> > 
> > On Sat, Nov 12, 2022 at 08:17:06AM +0000, Ricardo Koller wrote:
> > 
> > [...]
> > 
> > > +/**
> > > + * kvm_pgtable_stage2_split() - Split a range of huge pages into leaf PTEs pointing
> > > + *				to PAGE_SIZE guest pages.
> > > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > > + * @addr:	Intermediate physical address from which to split.
> > > + * @size:	Size of the range.
> > > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > > + *		page-table pages.
> > > + *
> > > + * @addr and the end (@addr + @size) are effectively aligned down and up to
> > > + * the top level huge-page block size. This is an exampe using 1GB
> > > + * huge-pages and 4KB granules.
> > > + *
> > > + *                          [---input range---]
> > > + *                          :                 :
> > > + * [--1G block pte--][--1G block pte--][--1G block pte--][--1G block pte--]
> > > + *                          :                 :
> > > + *                   [--2MB--][--2MB--][--2MB--][--2MB--]
> > > + *                          :                 :
> > > + *                   [ ][ ][:][ ][ ][ ][ ][ ][:][ ][ ][ ]
> > > + *                          :                 :
> > > + *
> > > + * Return: 0 on success, negative error code on failure. Note that
> > > + * kvm_pgtable_stage2_split() is best effort: it tries to break as many
> > > + * blocks in the input range as allowed by the size of the memcache. It
> > > + * will fail it wasn't able to break any block.
> > > + */
> > > +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
> > > +
> > >  /**
> > >   * kvm_pgtable_walk() - Walk a page-table.
> > >   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > > index d1f309128118..9c42eff6d42e 100644
> > > --- a/arch/arm64/kvm/hyp/pgtable.c
> > > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > > @@ -1267,6 +1267,80 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
> > >  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
> > >  }
> > >  
> > > +struct stage2_split_data {
> > > +	struct kvm_s2_mmu		*mmu;
> > > +	void				*memcache;
> > > +	struct kvm_pgtable_mm_ops	*mm_ops;
> > 
> > You can also get at mm_ops through kvm_pgtable_visit_ctx
> > 
> > > +};
> > > +
> > > +static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > > +			       enum kvm_pgtable_walk_flags visit)
> > > +{
> > > +	struct stage2_split_data *data = ctx->arg;
> > > +	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
> > > +	kvm_pte_t pte = ctx->old, attr, new;
> > > +	enum kvm_pgtable_prot prot;
> > > +	void *mc = data->memcache;
> > > +	u32 level = ctx->level;
> > > +	u64 phys;
> > > +
> > > +	if (WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
> > > +		return -EINVAL;
> > > +
> > > +	/* Nothing to split at the last level */
> > > +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> > > +		return 0;
> > > +
> > > +	/* We only split valid block mappings */
> > > +	if (!kvm_pte_valid(pte) || kvm_pte_table(pte, ctx->level))
> > > +		return 0;
> > > +
> > > +	phys = kvm_pte_to_phys(pte);
> > > +	prot = kvm_pgtable_stage2_pte_prot(pte);
> > > +	stage2_set_prot_attr(data->mmu->pgt, prot, &attr);
> > > +
> > > +	/*
> > > +	 * Eager page splitting is best-effort, so we can ignore the error.
> > > +	 * The returned PTE (new) will be valid even if this call returns
> > > +	 * error: new will be a single (big) block PTE.  The only issue is
> > > +	 * that it will affect dirty logging performance, as the huge-pages
> > > +	 * will have to be split on fault, and so we WARN.
> > > +	 */
> > > +	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
> > 
> > I don't believe we should warn in this case, at least not
> > unconditionally. ENOMEM is an expected outcome, for example.
> 
> Given that "eager page splitting" is best-effort, the error must be
> ignored somewhere: either here or by the caller (in mmu.c). It seems
> that ignoring the error here is not a very good idea.

Actually, ignoring the error here simplifies the error handling.
stage2_create_removed() is best-effort; here's an example.  If
stage2_create_removed() was called to split a 1G block PTE, and it
wasn't able to split all 2MB blocks, it would return ENOMEM and a valid
PTE pointing to a tree like this:

		[---------1GB-------------]
		:                         :
		[--2MB--][--2MB--][--2MB--]
		:       :
		[ ][ ][ ]

If we returned ENOMEM instead of ignoring the error, we would have to
clean all the intermediate state.  But stage2_create_removed() is
designed to always return a valid PTE, even if the tree is not fully
split (as above).  So, there's no really need to clean it: it's a valid
tree. Moreover, this valid tree would result in better dirty logging
performance as it already has some 2M blocks split into 4K pages.

> 
> > 
> > Additionally, I believe you'll want to bail out at this point to avoid
> > installing a potentially garbage PTE as well.
> 
> It should be fine as stage2_create_removed() is also best-effort. The
> returned PTE is valid even when it fails; it just returns a big block
> PTE.
> 
> > 
> > > +	stage2_put_pte(ctx, data->mmu, mm_ops);
> > 
> > Ah, I see why you've relaxed the WARN in patch 1 now.
> > 
> > I would recommend you follow the break-before-make pattern and use the
> > helpers here as well. stage2_try_break_pte() will demote the store to
> > WRITE_ONCE() if called from a non-shared context.
> > 
> 
> ACK, I can do that. The only reason why I didnt' is because I would have
> to handle the potential error from stage2_try_break_pte(). It would feel
> wrong not to, even if it's !shared. On the other hand, I would like to
> easily experiment with both the !shared and the shared approaches
> easily.
> 
> > Then the WARN will behave as expected in stage2_make_pte().
> > 
> > > +	/*
> > > +	 * Note, the contents of the page table are guaranteed to be made
> > > +	 * visible before the new PTE is assigned because
> > > +	 * stage2_make__pte() writes the PTE using smp_store_release().
> > 
> > typo: stage2_make_pte()
> > 
> > --
> > Thanks,
> > Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
