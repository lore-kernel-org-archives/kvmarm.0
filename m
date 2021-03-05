Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A9AC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 15:03:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDB6165016
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 15:03:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDB6165016
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4445A4B232;
	Fri,  5 Mar 2021 10:03:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jbY6iXrKcNaO; Fri,  5 Mar 2021 10:03:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8544B29B;
	Fri,  5 Mar 2021 10:03:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7B64B226
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 10:03:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id reYh8BAMnhBU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 10:03:40 -0500 (EST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 495354B1E6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 10:03:40 -0500 (EST)
Received: by mail-wm1-f43.google.com with SMTP id
 w203-20020a1c49d40000b029010c706d0642so6176844wma.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Mar 2021 07:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GpKc+xvCgCJSH13ZTIZLN2AMkxZK13gtHVewqGBpJ68=;
 b=cDP6bYf/Jne/eaTwyPukya/ajVOlbRSFeM9DU5NkgFY1C1PufCEwfcmjD4flOs6vvQ
 cEXq4jeuNQ9SwRjtFAmF8obyb3gMoMTaAKh6efRRsmNNQfTCbE0OIEg4yl2PRe4BWq94
 68tqXY756a6i6ineeXI+cO6KLABD1tkD0X33Vn11m9z8aKu5ToC3QPn/6v2buKjvnS6Y
 TbTrKWqjFHE8tW0/nt9TvX4zEF4yv1Jozi0/1i3+ZyguoIMJDww8jaK5s5drDILD7BsK
 sswTxLXiNvjLhxpVc+b4VWnNKKD8uVRNUiIilKtA6LZSyPmdQcH/Rw/MF9mj2rDNkhOE
 7miw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GpKc+xvCgCJSH13ZTIZLN2AMkxZK13gtHVewqGBpJ68=;
 b=ExM+OPvsvioRsqeI9oRy4T81TwRDO5LI7P4UiTugbphpHn+kbZTh8GfrgkivdaBuUT
 WA9qYH1BIu+t6EeN7hg3cBRjYfUxOj5L0UwxAFDTgbn1WDQEscz960ndD1b3XBSxipRc
 B2Tcl8dgV1ceD47y3WvN7eXWCrg7lPsDUSFqwFhnLoytT3h62ach7VEq7i8KJZmFEoiJ
 iG6GWh95+cfmxTGtzT6QtknmxCGyTvQNZi+eyLZfnrUoOWdYqO84E3ow9vX/EfRKeiX6
 G+/iOH7o6rEx9lnWr+kyDdmgW7Zg8CGvGr0yn/q50+G9FWE4gnQr6pgD4suVf2xr49iD
 ZdZg==
X-Gm-Message-State: AOAM531JHjvAet8Aze6SLpsN7/3bfoFBmuzZfUwgTzAKBC/v3ftNCkfc
 wtxsqsf9t4ZtAWkqpMgf7nuG1A==
X-Google-Smtp-Source: ABdhPJyIVygS7OGfQ/tnLuo3JNzZV/t4cpIfs6xJ3+AzFEa7C1ZYEN/vjbSjEeIhwx5P2PjxYvt8TA==
X-Received: by 2002:a7b:c151:: with SMTP id z17mr9405485wmi.189.1614956619109; 
 Fri, 05 Mar 2021 07:03:39 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v9sm4931146wrn.86.2021.03.05.07.03.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Mar 2021 07:03:38 -0800 (PST)
Date: Fri, 5 Mar 2021 15:03:36 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 28/32] KVM: arm64: Add kvm_pgtable_stage2_idmap_greedy()
Message-ID: <YEJISCQOHNbs363+@google.com>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-29-qperret@google.com>
 <20210305143941.GA23017@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210305143941.GA23017@willie-the-truck>
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Friday 05 Mar 2021 at 14:39:42 (+0000), Will Deacon wrote:
> On Tue, Mar 02, 2021 at 02:59:58PM +0000, Quentin Perret wrote:
> > +/**
> > + * kvm_pgtable_stage2_idmap_greedy() - Identity-map an Intermediate Physical
> > + *				       Address with a leaf entry at the highest
> > + *				       possible level.
> 
> Not sure it's worth mentioning "highest possible level" here, as
> realistically the caller still has to provide a memcache to deal with the
> worst case and the structure of the page-table shouldn't matter.

Right, we need to pass a range so I suppose that should be enough to
say 'this tries to cover large portions of memory'.

> > + * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> > + * @addr:	Input address to identity-map.
> > + * @prot:	Permissions and attributes for the mapping.
> > + * @range:	Boundaries of the maximum memory region to map.
> > + * @mc:		Cache of pre-allocated memory from which to allocate page-table
> > + *		pages.
> > + *
> > + * This function attempts to install high-level identity-mappings covering @addr
> 
> "high-level"? (again, I think I'd just drop this)
> 
> > + * without overriding existing mappings with incompatible permissions or
> > + * attributes. An existing table entry may be coalesced into a block mapping
> > + * if and only if it covers @addr and all its leafs are either invalid and/or
> 
> s/leafs/leaf entries/

Ack for both.

> > + * have permissions and attributes strictly matching @prot. The mapping is
> > + * guaranteed to be contained within the boundaries specified by @range at call
> > + * time. If only a subset of the memory specified by @range is mapped (because
> > + * of e.g. alignment issues or existing incompatible mappings), @range will be
> > + * updated accordingly.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_idmap_greedy(struct kvm_pgtable *pgt, u64 addr,
> > +				    enum kvm_pgtable_prot prot,
> > +				    struct kvm_mem_range *range,
> > +				    void *mc);
> >  #endif	/* __ARM64_KVM_PGTABLE_H__ */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 8aa01a9e2603..6897d771e2b2 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -987,3 +987,122 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> >  	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> >  	pgt->pgd = NULL;
> >  }
> > +
> > +struct stage2_reduce_range_data {
> > +	kvm_pte_t attr;
> > +	u64 target_addr;
> > +	u32 start_level;
> > +	struct kvm_mem_range *range;
> > +};
> > +
> > +static int __stage2_reduce_range(struct stage2_reduce_range_data *data, u64 addr)
> > +{
> > +	u32 level = data->start_level;
> > +
> > +	for (; level < KVM_PGTABLE_MAX_LEVELS; level++) {
> > +		u64 granule = kvm_granule_size(level);
> > +		u64 start = ALIGN_DOWN(data->target_addr, granule);
> > +		u64 end = start + granule;
> > +
> > +		/*
> > +		 * The pinned address is in the current range, try one level
> > +		 * deeper.
> > +		 */
> > +		if (start == ALIGN_DOWN(addr, granule))
> > +			continue;
> > +
> > +		/*
> > +		 * Make sure the current range is a reduction of the existing
> > +		 * range before updating it.
> > +		 */
> > +		if (data->range->start <= start && end <= data->range->end) {
> > +			data->start_level = level;
> > +			data->range->start = start;
> > +			data->range->end = end;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +#define KVM_PTE_LEAF_S2_COMPAT_MASK	(KVM_PTE_LEAF_ATTR_S2_PERMS | \
> > +					 KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | \
> > +					 KVM_PTE_LEAF_SW_BIT_PROT_NONE)
> > +
> > +static int stage2_reduce_range_walker(u64 addr, u64 end, u32 level,
> > +				      kvm_pte_t *ptep,
> > +				      enum kvm_pgtable_walk_flags flag,
> > +				      void * const arg)
> > +{
> > +	struct stage2_reduce_range_data *data = arg;
> > +	kvm_pte_t attr;
> > +	int ret;
> > +
> > +	if (addr < data->range->start || addr >= data->range->end)
> > +		return 0;
> > +
> > +	attr = *ptep & KVM_PTE_LEAF_S2_COMPAT_MASK;
> > +	if (!attr || attr == data->attr)
> > +		return 0;
> > +
> > +	/*
> > +	 * An existing mapping with incompatible protection attributes is
> > +	 * 'pinned', so reduce the range if we hit one.
> > +	 */
> > +	ret = __stage2_reduce_range(data, addr);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return -EAGAIN;
> > +}
> > +
> > +static int stage2_reduce_range(struct kvm_pgtable *pgt, u64 addr,
> > +			       enum kvm_pgtable_prot prot,
> > +			       struct kvm_mem_range *range)
> > +{
> > +	struct stage2_reduce_range_data data = {
> > +		.start_level	= pgt->start_level,
> > +		.range		= range,
> > +		.target_addr	= addr,
> > +	};
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb		= stage2_reduce_range_walker,
> > +		.flags		= KVM_PGTABLE_WALK_LEAF,
> > +		.arg		= &data,
> > +	};
> > +	int ret;
> > +
> > +	data.attr = stage2_get_prot_attr(prot) & KVM_PTE_LEAF_S2_COMPAT_MASK;
> > +	if (!data.attr)
> > +		return -EINVAL;
> 
> (this will need updating based on the other discussion we had)

Ack.

> > +	/* Reduce the kvm_mem_range to a granule size */
> > +	ret = __stage2_reduce_range(&data, range->end);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Walk the range to check permissions and reduce further if needed */
> > +	do {
> > +		ret = kvm_pgtable_walk(pgt, range->start, range->end, &walker);
> 
> (we spent some time debugging an issue here and you spotted that you're
> passing range->end instead of the size ;)

Yep, I have the fix applied locally, and ready to fly in v4 :)

> > +	} while (ret == -EAGAIN);
> 
> I'm a bit nervous about this loop -- what guarantees forward progress here?
> Can we return to the host after a few tries instead?

-EAGAIN only happens when we've been able to successfully reduce the
range to a potentially valid granule size. That can't happen infinitely.

We're guaranteed to fail when trying to reduce the range to a
granularity smaller than PAGE_SIZE (the -EINVAL case of
__stage2_reduce_range), which is indicative of a host memory abort in a
page it should not access (because marked PROT_NONE for instance).

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
