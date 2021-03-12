Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E2FC433E0
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 05:32:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5C45064DAF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 05:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C45064DAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEF6F4B72A;
	Fri, 12 Mar 2021 00:32:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dbIUaCRUeY7B; Fri, 12 Mar 2021 00:32:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8035A4B651;
	Fri, 12 Mar 2021 00:32:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E254B614
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 00:32:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 34FPof5ASIvX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 00:32:18 -0500 (EST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
 [209.85.221.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF2344B604
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 00:32:17 -0500 (EST)
Received: by mail-wr1-f46.google.com with SMTP id l11so4099937wrp.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 21:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=5A3nvq8VEOu9DY7gsHpSl1K1VDNI7/9L/4JQKSZqiFk=;
 b=FwsQ2M3NHGDruc9OHswIGsix60JeffjTo+HASUiHoIVGMqZuh/NDBR/+Sm2K7r2Okr
 0nuM9xCtcIojBQDTEk4zDfABucbqWLTzvxJTR4JHoM+mCQP3rwca1tCUYEN0dToTvFah
 BALBINBUAND0Na5kKDkOoe1xhf66tJ4oVN3lGFX53Ygfum+Oq0kHyUQLw1aY2kQ7sKFq
 88yTraHfeVAeRO/ps6wICW6P5fgM4QepeiI5Ec0sDFwKxhWoWvXnWjlZhcxSYAdSwmqv
 ETfPxVXZY+hDmS2hvIJSutKknMCtBRC+9+N6DT6HBrrp+HixWU5yNs057JYRs2nWut7c
 aVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=5A3nvq8VEOu9DY7gsHpSl1K1VDNI7/9L/4JQKSZqiFk=;
 b=AYOt4DXWiXqocLoMDFA8D/HEMS3xf2TaGPMuMHekvpyVAutjq7gkZh8KyJE+cKiUHi
 R4THwm2cPZcXgpCcrQ+pzzyJj5VeVO19tKCqX9UfYbd+T5xjPcRKPfjQPavZ6soO14aT
 U8nClDr+UyHavdCIDVzlbSFRGQonnMtGFrAGPc3gFWcAlpbTU1+AwwTdmdw3d6CYFVRQ
 Tfw+0izjZUs8313uhVL3SlsrFu39sJmAQZbYt0eEGk5vp7f/QdqcHEblY/nHHi3GH3Ee
 URI/x7oL61PqtHE72wz1TQrXjbb/iSFX5L3FNgqMGub77GOgmItLZSMMmqvrzjoBRYRo
 5YLA==
X-Gm-Message-State: AOAM531V8Vt+ztCHprEzL3ZICxNaM94uIbaGiiJrYocLOG1RzieP9KOq
 f/QQLtbFviF+OAtPL4O3oNg4iQ==
X-Google-Smtp-Source: ABdhPJyp7LwKuRx6QmT+XNuvJd5g+sgFjnxxVCZQWaPznIpQ4YgD0rwz4AVbfbvNkBDGHen6klohOQ==
X-Received: by 2002:adf:b355:: with SMTP id k21mr12128350wrd.156.1615527136604; 
 Thu, 11 Mar 2021 21:32:16 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id v13sm7271586wrt.45.2021.03.11.21.32.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 11 Mar 2021 21:32:16 -0800 (PST)
Date: Fri, 12 Mar 2021 05:32:13 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 30/34] KVM: arm64: Add kvm_pgtable_stage2_find_range()
Message-ID: <YEr83QKZnEd4a6Ba@google.com>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-31-qperret@google.com>
 <20210311190406.GB31586@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210311190406.GB31586@willie-the-truck>
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

On Thursday 11 Mar 2021 at 19:04:07 (+0000), Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:57:47PM +0000, Quentin Perret wrote:
> > Since the host stage 2 will be identity mapped, and since it will own
> > most of memory, it would preferable for performance to try and use large
> > block mappings whenever that is possible. To ease this, introduce a new
> > helper in the KVM page-table code which allows to search for large
> > ranges of available IPA space. This will be used in the host memory
> > abort path to greedily idmap large portion of the PA space.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 30 ++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 90 +++++++++++++++++++++++++++-
> >  2 files changed, 117 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index b09af4612656..477bf10c48a9 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -94,6 +94,16 @@ enum kvm_pgtable_prot {
> >  #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
> >  #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
> >  
> > +/**
> > + * struct kvm_mem_range - Range of Intermediate Physical Addresses
> > + * @start:	Start of the range.
> > + * @end:	End of the range.
> > + */
> > +struct kvm_mem_range {
> > +	u64 start;
> > +	u64 end;
> > +};
> > +
> >  /**
> >   * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
> >   * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
> > @@ -398,4 +408,24 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
> >  int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >  		     struct kvm_pgtable_walker *walker);
> >  
> > +/**
> > + * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
> > + *				     Addresses with compatible permission
> > + *				     attributes.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	Address that must be covered by the range.
> > + * @prot:	Protection attributes that the range must be compatible with.
> > + * @range:	Range structure used to limit the search space at call time and
> > + *		that will hold the result.
> > + *
> > + * The offset of @addr within a page is ignored. An existing mapping is defined
> > + * as compatible with @prot if it is invalid and not owned by another entity, or
> > + * if its permission attributes are strictly similar to @prot and it has no
> > + * software bits set.
> 
> nit: I think the 'or' is ambigious here, as it makes it sound like an
> invalid entry that _is_ owned by another entity is compatible if the
> permissions attribute match. How about:
> 
>   | An IPA is compatible with prot iff its corresponding stage-2 page-table
>   | entry has default ownership and, if valid, is mapped with protection
>   | attributes identical to @prot.

Works for me.

> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
> > +				  enum kvm_pgtable_prot prot,
> > +				  struct kvm_mem_range *range);
> >  #endif	/* __ARM64_KVM_PGTABLE_H__ */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index c16e0306dd9a..f20287bb3e41 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -48,6 +48,8 @@
> >  					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
> >  					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
> >  
> > +#define KVM_PTE_LEAF_ATTR_S2_RES	GENMASK(58, 55)
> 
> Please make this IGN instead of RES, to match the architecture (and because
> RES is usually used in the context of RES0 or RES1).

Ack, maybe I'll even say 'IGNORED' in full to match the Arm ARM -- IGN
sounds like an acronym otherwise.

> >  #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 32)
> >  
> >  struct kvm_pgtable_walk_data {
> > @@ -69,10 +71,8 @@ static u64 kvm_granule_size(u32 level)
> >  	return BIT(kvm_granule_shift(level));
> >  }
> >  
> > -static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
> > +static bool kvm_level_support_block_mappings(u32 level)
> >  {
> > -	u64 granule = kvm_granule_size(level);
> > -
> >  	/*
> >  	 * Reject invalid block mappings and don't bother with 4TB mappings for
> >  	 * 52-bit PAs.
> > @@ -80,6 +80,16 @@ static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
> >  	if (level == 0 || (PAGE_SIZE != SZ_4K && level == 1))
> >  		return false;
> >  
> > +	return true;
> 
> return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
> 
> > +static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
> > +{
> > +	u64 granule = kvm_granule_size(level);
> > +
> > +	if (!kvm_level_support_block_mappings(level))
> > +		return false;
> > +
> >  	if (granule > (end - addr))
> >  		return false;
> >  
> > @@ -1042,3 +1052,77 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
> >  	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
> >  	pgt->pgd = NULL;
> >  }
> > +
> > +#define KVM_PTE_LEAF_S2_COMPAT_MASK	(KVM_PTE_LEAF_ATTR_S2_PERMS | \
> > +					 KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | \
> > +					 KVM_PTE_LEAF_ATTR_S2_RES)
> > +
> > +static int stage2_check_permission_walker(u64 addr, u64 end, u32 level,
> > +					  kvm_pte_t *ptep,
> > +					  enum kvm_pgtable_walk_flags flag,
> > +					  void * const arg)
> > +{
> > +	kvm_pte_t old_attr, pte = *ptep, *new_attr = arg;
> > +
> > +	/*
> > +	 * Compatible mappings are either invalid and owned by the page-table
> > +	 * owner (whose id is 0), or valid with matching permission attributes.
> > +	 */
> > +	if (kvm_pte_valid(pte)) {
> > +		old_attr = pte & KVM_PTE_LEAF_S2_COMPAT_MASK;
> > +		if (old_attr != *new_attr)
> > +			return -EEXIST;
> > +	} else if (pte) {
> > +		return -EEXIST;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
> > +				  enum kvm_pgtable_prot prot,
> > +				  struct kvm_mem_range *range)
> > +{
> > +	kvm_pte_t attr;
> > +	struct kvm_pgtable_walker check_perm_walker = {
> > +		.cb		= stage2_check_permission_walker,
> > +		.flags		= KVM_PGTABLE_WALK_LEAF,
> > +		.arg		= &attr,
> > +	};
> > +	u64 granule, start, end;
> > +	u32 level;
> > +	int ret;
> > +
> > +	ret = stage2_set_prot_attr(prot, &attr);
> > +	if (ret)
> > +		return ret;
> > +	attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
> > +
> > +	for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
> > +		granule = kvm_granule_size(level);
> > +		start = ALIGN_DOWN(addr, granule);
> > +		end = start + granule;
> > +
> > +		if (!kvm_level_support_block_mappings(level))
> > +			continue;
> > +
> > +		if (start < range->start || range->end < end)
> > +			continue;
> > +
> > +		/*
> > +		 * Check the presence of existing mappings with incompatible
> > +		 * permissions within the current block range, and try one level
> > +		 * deeper if one is found.
> > +		 */
> > +		ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
> > +		if (ret != -EEXIST)
> > +			break;
> > +	}
> 
> Can you write this as a:
> 
> 	do {
> 		...
> 	} while (level < KVM_PGTABLE_MAX_LEVELS && ret == -EEXIST);
> 
> loop?

I tried it but found it a little less pretty -- the pre-assignment of
level and the increment at the end make it really feel like a for loop
to me:

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1098,26 +1098,23 @@ int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
                return ret;
        attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;
 
-       for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
+       ret = -EEXIST;
+       level = pgt->start_level;
+       do {
                granule = kvm_granule_size(level);
                start = ALIGN_DOWN(addr, granule);
                end = start + granule;
 
-               if (!kvm_level_support_block_mappings(level))
-                       continue;
-
-               if (start < range->start || range->end < end)
-                       continue;
-
                /*
                 * Check the presence of existing mappings with incompatible
                 * permissions within the current block range, and try one level
                 * deeper if one is found.
                 */
-               ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
-               if (ret != -EEXIST)
-                       break;
-       }
+               if (kvm_level_support_block_mappings(level) && start >= range->start && range->end >= end)
+                       ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
+
+               level++;
+       } while (level < KVM_PGTABLE_MAX_LEVELS && ret == -EEXIST);
 
        if (!ret) {


I'm guessing you're not a fan of the break case in existing loop?
Another option could be:

--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1098,7 +1098,7 @@ int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
                return ret;
        attr &= KVM_PTE_LEAF_S2_COMPAT_MASK;

-       for (level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS; level++) {
+       for (ret = -EEXIST, level = pgt->start_level; level < KVM_PGTABLE_MAX_LEVELS && ret == -EEXIST; level++) {
                granule = kvm_granule_size(level);
                start = ALIGN_DOWN(addr, granule);
                end = start + granule;
@@ -1115,8 +1115,6 @@ int kvm_pgtable_stage2_find_range(struct kvm_pgtable *pgt, u64 addr,
                 * deeper if one is found.
                 */
                ret = kvm_pgtable_walk(pgt, start, granule, &check_perm_walker);
-               if (ret != -EEXIST)
-                       break;
        }

        if (!ret) {

No strong opinion either way. Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
