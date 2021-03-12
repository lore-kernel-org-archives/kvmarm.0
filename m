Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D2EC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 06:23:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2716E64F84
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 06:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2716E64F84
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 684434B678;
	Fri, 12 Mar 2021 01:23:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G42YJGkKOmbw; Fri, 12 Mar 2021 01:23:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEECF4B698;
	Fri, 12 Mar 2021 01:23:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FB44B698
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 01:23:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rvLkyzotW5Am for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 01:23:05 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 347A84B678
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 01:23:05 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id
 n11-20020a05600c4f8bb029010e5cf86347so3983278wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 22:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wLF9+hllwZQb6lUbqKASy10z/RO/Q28UjMoBJgQA7tw=;
 b=d6hKdxaB5cSq/6Ojr6GjVEwYC8cdV2akx9ggw9MewgFONAuVbQvzXMjU0gW6sn8BH+
 4x+NiaNHvcLwXI3GOJNrTl+F2Myp+3SMV3BIQ3VSn3tqAgz0/wT2kZwbbE1pwGKLJ6ho
 9o72x8YhyEH9/1qZ+4yWM7mTa+/Zgd5GomXPSfYlASrNzSfjbAjBH7DGBu78T+anhO+r
 KBG+GEXi9+RJv3m40KAKZzZQ9q1VPC0xTYbxmZqcbhp4sKCPgpbuKcpLX+dkNYnOcDix
 4bR8xDHUDg36MY05KosYoFIBqIKLXUPJXip330atDQHi91ND4u4MEPXzUAJBlczXlujz
 VCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wLF9+hllwZQb6lUbqKASy10z/RO/Q28UjMoBJgQA7tw=;
 b=LQ2uAZTl4RJ36PSQtZPKX2286PKumnPqpyDJHUCFCl6pMhdSol1Xs6y5UG7vozfAyD
 KC/Pgm1Gn9vrxly+1RrKSIWYSsKtz8pqqHD2YbMtgv+rq16TvPgWPiJlB+RiwX5Vr/Xc
 +is+458JygnoIAR4Y7S688C41LcQXi58CKJzUcapbII6irQ0J2uKfhsHOO7Bhfzbscv9
 DvYtN6KnqSJCbcQIPkP6kmX7tTLPuADlCFf5oq0o5eBzGetDZVNyh+a26zvOM2GNYJik
 HiytXE+tlJHUJEezC7+reKFxxSJXdKmqnIW1HMSQrV4X3WyjdjaAC31tr8fi+GtuERpy
 jUew==
X-Gm-Message-State: AOAM5321pD2S6bSn/nx4/rTe/Cs8G513H6/ABx1aHV+aa6l8oJqqDaeK
 wNFG4mwh30g1vnnP5JCs9U6Rmg==
X-Google-Smtp-Source: ABdhPJxaXO91zCQUlIx8xgLdwTPSLHPfsTX4zhn7X3mh9DxDj5rmb+KW09JYdGkhJaRGSSoOpkR08Q==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr11274638wmj.54.1615530183931; 
 Thu, 11 Mar 2021 22:23:03 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id s12sm1021005wmj.28.2021.03.11.22.23.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 22:23:03 -0800 (PST)
Date: Fri, 12 Mar 2021 06:23:00 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 28/34] KVM: arm64: Use page-table to track page
 ownership
Message-ID: <YEsIxA/fKaDlSaio@google.com>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-29-qperret@google.com>
 <20210311183834.GC31378@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210311183834.GC31378@willie-the-truck>
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

On Thursday 11 Mar 2021 at 18:38:36 (+0000), Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:57:45PM +0000, Quentin Perret wrote:
> > As the host stage 2 will be identity mapped, all the .hyp memory regions
> > and/or memory pages donated to protected guestis will have to marked
> > invalid in the host stage 2 page-table. At the same time, the hypervisor
> > will need a way to track the ownership of each physical page to ensure
> > memory sharing or donation between entities (host, guests, hypervisor) is
> > legal.
> > 
> > In order to enable this tracking at EL2, let's use the host stage 2
> > page-table itself. The idea is to use the top bits of invalid mappings
> > to store the unique identifier of the page owner. The page-table owner
> > (the host) gets identifier 0 such that, at boot time, it owns the entire
> > IPA space as the pgd starts zeroed.
> > 
> > Provide kvm_pgtable_stage2_set_owner() which allows to modify the
> > ownership of pages in the host stage 2. It re-uses most of the map()
> > logic, but ends up creating invalid mappings instead. This impacts
> > how we do refcount as we now need to count invalid mappings when they
> > are used for ownership tracking.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 21 +++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 92 ++++++++++++++++++++++++----
> >  2 files changed, 101 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 4ae19247837b..b09af4612656 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -238,6 +238,27 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  			   u64 phys, enum kvm_pgtable_prot prot,
> >  			   void *mc);
> >  
> > +/**
> > + * kvm_pgtable_stage2_set_owner() - Annotate invalid mappings with metadata
> > + *				    encoding the ownership of a page in the
> > + *				    IPA space.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	Intermediate physical address at which to place the annotation.
> 
> This confused me a bit, as the annotation is stored in the page-table, not
> at the memory identified by @addr. How about:
> 
>   "Base intermediate physical address to annotate"
> 
> > + * @size:	Size of the IPA range to annotate.
> 
>   "Size of the annotated range"
> 
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > + *		page-table pages.
> > + * @owner_id:	Unique identifier for the owner of the page.
> > + *
> > + * The page-table owner has identifier 0.
> 
> Perhaps, "By default, all page-tables are owned by identifier 0"

Ack all of the above.

> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				 void *mc, u32 owner_id);
> 
> Is there a need for the owner_id to be 32-bit rather than e.g. 16-bit? Just
> strikes me that it might be difficult to recover these bits in future if we
> give them out freely now.

I figured we might want to use identifiers that are stable for the
lifetime of protected VMs. I wasn't sure using e.g. VMIDs would be a
better choice here as re-using them will cause a lot of pain for the
host stage 2 pgtable maintenance.

> > +
> >  /**
> >   * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index f37b4179b880..e4670b639726 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -48,6 +48,8 @@
> >  					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
> >  					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
> >  
> > +#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 32)
> 
> Ah, so that '02' earlier was a typo for '32'.
> 
> > +
> >  struct kvm_pgtable_walk_data {
> >  	struct kvm_pgtable		*pgt;
> >  	struct kvm_pgtable_walker	*walker;
> > @@ -186,6 +188,11 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> >  	return pte;
> >  }
> >  
> > +static kvm_pte_t kvm_init_invalid_leaf_owner(u32 owner_id)
> > +{
> > +	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
> > +}
> > +
> >  static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
> >  				  u32 level, kvm_pte_t *ptep,
> >  				  enum kvm_pgtable_walk_flags flag)
> > @@ -440,6 +447,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
> >  struct stage2_map_data {
> >  	u64				phys;
> >  	kvm_pte_t			attr;
> > +	u32				owner_id;
> >  
> >  	kvm_pte_t			*anchor;
> >  	kvm_pte_t			*childp;
> > @@ -506,6 +514,24 @@ static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> >  	return 0;
> >  }
> >  
> > +static bool stage2_is_permission_change(kvm_pte_t old, kvm_pte_t new)
> > +{
> > +	if (!kvm_pte_valid(old) || !kvm_pte_valid(new))
> > +		return false;
> > +
> > +	return !((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS));
> > +}
> 
> This new name throws me, because it will return true if old == new.

How about I invert it and call it 'stage2_pte_needs_update()' or so?

> > +static bool stage2_pte_is_counted(kvm_pte_t pte)
> > +{
> > +	/*
> > +	 * The refcount tracks valid entries as well as invalid entries if they
> > +	 * encode ownership of a page to another entity than the page-table
> > +	 * owner, whose id is 0.
> > +	 */
> > +	return !!pte;
> > +}
> > +
> >  static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  				      kvm_pte_t *ptep,
> >  				      struct stage2_map_data *data)
> > @@ -517,28 +543,36 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> >  	if (!kvm_block_mapping_supported(addr, end, phys, level))
> >  		return -E2BIG;
> >  
> > -	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> > -	if (kvm_pte_valid(old)) {
> > +	if (kvm_pte_valid(data->attr))
> 
> This feels like a bit of a hack to me: the 'attr' field in stage2_map_data
> is intended to correspond directly to the lower/upper attributes of the
> descriptor as per the architecture, so tagging the valid bit in there is
> pretty grotty. However, I can see the significant advantage in being able
> to re-use the stage2_map_walker functionality, so about instead of nobbling
> attr, you set phys to something invalid instead, e.g.:
> 
> 	#define KVM_PHYS_SET_OWNER	(-1ULL)

That'll confuse kvm_block_mapping_supported() and friends I think, at
least in their current form. If you _really_ don't like this, maybe we
could have an extra 'flags' field in stage2_map_data?

> > +		new = kvm_init_valid_leaf_pte(phys, data->attr, level);
> > +	else
> > +		new = kvm_init_invalid_leaf_owner(data->owner_id);
> > +
> > +	if (stage2_pte_is_counted(old)) {
> >  		/*
> >  		 * Skip updating the PTE if we are trying to recreate the exact
> >  		 * same mapping or only change the access permissions. Instead,
> >  		 * the vCPU will exit one more time from guest if still needed
> >  		 * and then go through the path of relaxing permissions.
> >  		 */
> > -		if (!((old ^ new) & (~KVM_PTE_LEAF_ATTR_S2_PERMS)))
> > +		if (stage2_is_permission_change(old, new))
> >  			return -EAGAIN;
> >  
> >  		/*
> > -		 * There's an existing different valid leaf entry, so perform
> > -		 * break-before-make.
> > +		 * Clear the existing PTE, and perform break-before-make with
> > +		 * TLB maintenance if it was valid.
> >  		 */
> >  		kvm_clear_pte(ptep);
> > -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> > +		if (kvm_pte_valid(old)) {
> > +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr,
> > +				     level);
> > +		}
> 
> Why do you clear the pte unconditionally here? I think you can move that
> into the 'if' as well.

Yep that should work.

> >  		mm_ops->put_page(ptep);
> >  	}
> >  
> >  	smp_store_release(ptep, new);
> > -	mm_ops->get_page(ptep);
> > +	if (stage2_pte_is_counted(new))
> > +		mm_ops->get_page(ptep);
> >  	data->phys += granule;
> >  	return 0;
> >  }
> > @@ -574,7 +608,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  	int ret;
> >  
> >  	if (data->anchor) {
> > -		if (kvm_pte_valid(pte))
> > +		if (stage2_pte_is_counted(pte))
> >  			mm_ops->put_page(ptep);
> >  
> >  		return 0;
> > @@ -599,9 +633,10 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >  	 * a table. Accesses beyond 'end' that fall within the new table
> >  	 * will be mapped lazily.
> >  	 */
> > -	if (kvm_pte_valid(pte)) {
> > +	if (stage2_pte_is_counted(pte)) {
> >  		kvm_clear_pte(ptep);
> > -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> > +		if (kvm_pte_valid(pte))
> > +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> 
> Same here.
> 
> >  		mm_ops->put_page(ptep);
> >  	}
> >  
> > @@ -683,6 +718,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  		.mmu		= pgt->mmu,
> >  		.memcache	= mc,
> >  		.mm_ops		= pgt->mm_ops,
> > +		.owner_id	= 0,
> 
> Not needed.
> 
> >  	};
> >  	struct kvm_pgtable_walker walker = {
> >  		.cb		= stage2_map_walker,
> > @@ -696,6 +732,33 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  	if (ret)
> >  		return ret;
> >  
> > +	/* Set the valid flag to distinguish with the set_owner() path. */
> > +	map_data.attr |= KVM_PTE_VALID;
> 
> (see earlier comments)
> 
> > +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> > +	dsb(ishst);
> > +	return ret;
> > +}
> > +
> > +int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
> > +				 void *mc, u32 owner_id)
> > +{
> > +	int ret;
> > +	struct stage2_map_data map_data = {
> > +		.mmu		= pgt->mmu,
> > +		.memcache	= mc,
> > +		.mm_ops		= pgt->mm_ops,
> > +		.owner_id	= owner_id,
> > +		.attr		= 0,
> 
> Not needed.
> 
> > +	};
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb		= stage2_map_walker,
> > +		.flags		= KVM_PGTABLE_WALK_TABLE_PRE |
> > +				  KVM_PGTABLE_WALK_LEAF |
> > +				  KVM_PGTABLE_WALK_TABLE_POST,
> 
> Oh man, now I see why phys is zero -- so that the table callbacks will
> put down the largest possible block. That needs a comment because it's
> pretty horrible, and also means my idea of using -1 won't help you. Hmm.

We're creating invalid mappings which by definition don't map to
physical pages (the annotation is purely in the _IPA_ space), so yeah
the best thing to do was to take phys 'out of the way'. Setting it to
e.g. @addr would be quite confusing IMO -- imagine if we ever decide to
annotate the stage 2 of guests one day.

And as you noticed, weird values will also happen to confuse
kvm_block_mapping_supported(), and/or to cause range issues, so 0 seemed
like a reasonable choice.

I'll stick a comment.

> Is there ever a reason to use kvm_pgtable_stage2_set_owner() to set an
> owner of 0, or should you just use the map/unmap APIs for that? If so,
> then maybe the key is simply if owner_id is non-zero, then an invalid
> entry is installed?

I couldn't find a good reason to restrict it, as that wouldn't change
the implementation much anyway. Also, if we added the right CMOs, we
could probably remove the unmap walker and re-express it in terms of
set_owner(0) ... But I suppose that is for later :-)

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
