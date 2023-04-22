Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911DB8C15
	for <kvmarm@lists.linux.dev>; Sat, 22 Apr 2023 20:09:31 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1a950b982d4so141455ad.0
        for <kvmarm@lists.linux.dev>; Sat, 22 Apr 2023 13:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682194171; x=1684786171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w8jFIlGhqnylD+Ou7GErzwOPZferzkUMYBr2W0WKmRM=;
        b=XjaJS6+2PDAKX+Bz+ZnugmYdvfLIeRAtichteII1QTfoeveCz5S4kuIoFX011m1ZUR
         NBW3FM5JTQ9ILo8HuTcjgkp5+4R1iEgRexgskzajKCRduqzNX0bI9VL3w3tgj1nKj/hc
         DyrJYvOA9arGHDUjrWJwKW+qceERnbrEPV3vh0UJL/149y/mZBIIn8+uqibUtH9bzVVh
         o2MA+gRQ/GkC0sXvToSXMCPWr4wZvMVslYw7k69UGxG6Oo7GHNK57yOLPjt0Fd10tFs1
         lbPTiy9hz1w0YzCLzfyOD7iKKu1X1/CcP3QMQqICbw/ZgMgxIUwKo3oBmyHWX+vq9HC9
         Aspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682194171; x=1684786171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8jFIlGhqnylD+Ou7GErzwOPZferzkUMYBr2W0WKmRM=;
        b=dnqQURvFAhwIM3E/1HaU0MJzbJ7rSS6wh5gdBcvmxKPlA7ofhGjx0wROhYOugAiITC
         TDr6koAQ7TMyBFjvu/MjNx2iPNUVmg+Aw55fIPTQvvY3gbBmsYaOQyO4I6NRYIsqSNrO
         PRBjqRdGzwY4oF1+b+f5meiV8/GNrZzefsNxt7cpYpDWnjTplj2Y/WcMP9F2zWh00uTo
         REn8o3U+fKV3y4zjTZYoBfaxj6einDzmp+uoIOkMjii/UnyAWz6DO378h5LkQm1twODu
         QP/1DU7YUvKJIQa2eniA7oWP1GEnClosjTEtjOilxGzTD0XYocy+99HazSGKS+n3t78/
         6ekA==
X-Gm-Message-State: AAQBX9dUQfUys8rYirvY5DIu6bWVHFKj7AN0Xjzlf/kYrGboZ0TiNg2c
	SR32keFKkSsELQ8z4Prx6supGA==
X-Google-Smtp-Source: AKy350YpcThMN9M4t6SsXAMpgez9Pntw09c8BFmv3jdMj6cqDwJFvMV/dbanKEs0VH5c4ybWd6ZTog==
X-Received: by 2002:a17:902:d092:b0:1a6:6a2d:18f0 with SMTP id v18-20020a170902d09200b001a66a2d18f0mr170458plv.9.1682194170914;
        Sat, 22 Apr 2023 13:09:30 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t9-20020a6549c9000000b0051b3ef1295csm4233580pgs.53.2023.04.22.13.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 13:09:30 -0700 (PDT)
Date: Sat, 22 Apr 2023 13:09:26 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Gavin Shan <gshan@redhat.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com,
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com,
	suzuki.poulose@arm.com, eric.auger@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <ZEQ+9kyXcQS+1i81@google.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-5-ricarkol@google.com>
 <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cb621b0-7174-a7c7-1524-801b06f94e8f@redhat.com>

On Mon, Apr 17, 2023 at 02:18:26PM +0800, Gavin Shan wrote:
> On 4/9/23 2:29 PM, Ricardo Koller wrote:
> > Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> > creating unlinked tables (which is the opposite of
> > kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> > useful for splitting level 1 and 2 entries into subtrees of PAGE_SIZE
> > PTEs.  For example, a level 1 entry can be split into PAGE_SIZE PTEs
> > by first creating a fully populated tree, and then use it to replace
> > the level 1 entry in a single step.  This will be used in a subsequent
> > commit for eager huge-page splitting (a dirty-logging optimization).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >   arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++++++++++
> >   arch/arm64/kvm/hyp/pgtable.c         | 49 ++++++++++++++++++++++++++++
> >   2 files changed, 75 insertions(+)
> > 
> 
> With the following nits addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index 3f2d43ba2b628..c8e0e7d9303b2 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -458,6 +458,32 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >    */
> >   void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> > +/**
> > + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @phys:	Physical address of the memory to map.
> > + * @level:	Starting level of the stage-2 paging structure to be created.
> > + * @prot:	Permissions and attributes for the mapping.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
>                 ^^^^^^^^
> Alignment.

This seems to be due to the "+ ". It looks like this without it:

 * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
 * @pgt:        Page-table structure initialised by kvm_pgtable_stage2_init*().
 * @phys:       Physical address of the memory to map.
 * @level:      Starting level of the stage-2 paging structure to be created.
 * @prot:       Permissions and attributes for the mapping.
 * @mc:         Cache of pre-allocated and zeroed memory from which to allocate
 *              page-table pages.

> 
> > + *		page-table pages.
> > + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> > + *
> > + * Returns an unlinked page-table tree.  This new page-table tree is
> > + * not reachable (i.e., it is unlinked) from the root pgd and it's
> > + * therefore unreachableby the hardware page-table walker. No TLB
> > + * invalidation or CMOs are performed.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: The fully populated (unlinked) stage-2 paging structure, or
> > + * an ERR_PTR(error) on failure.
> > + */
> > +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +					      u64 phys, u32 level,
> > +					      enum kvm_pgtable_prot prot,
> > +					      void *mc, bool force_pte);
> > +
> >   /**
> >    * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >    * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 633679ee3c49a..477d2be67d401 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1222,6 +1222,55 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >   	return kvm_pgtable_walk(pgt, addr, size, &walker);
> >   }
> > +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +					      u64 phys, u32 level,
> > +					      enum kvm_pgtable_prot prot,
> > +					      void *mc, bool force_pte)
> > +{
> > +	struct stage2_map_data map_data = {
> > +		.phys		= phys,
> > +		.mmu		= pgt->mmu,
> > +		.memcache	= mc,
> > +		.force_pte	= force_pte,
> > +	};
> > +	struct kvm_pgtable_walker walker = {
> > +		.cb		= stage2_map_walker,
> > +		.flags		= KVM_PGTABLE_WALK_LEAF |
> > +				  KVM_PGTABLE_WALK_SKIP_BBM_TLBI |
> > +				  KVM_PGTABLE_WALK_SKIP_CMO,
> > +		.arg		= &map_data,
> > +	};
> > +	/* .addr (the IPA) is irrelevant for an unlinked table */
> > +	struct kvm_pgtable_walk_data data = {
> > +		.walker	= &walker,
> > +		.addr	= 0,
> > +		.end	= kvm_granule_size(level),
> > +	};
> 
> The comment about '.addr' seems incorrect. The IPA address is still
> used to locate the page table entry, so I think it would be something
> like below:
> 
> 	/* The IPA address (.addr) is relative to zero */
> 

Extended it to say this:

         * The IPA address (.addr) is relative to zero. The goal is to
         * map "kvm_granule_size(level) - 0" worth of pages.

> > +	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> > +	kvm_pte_t *pgtable;
> > +	int ret;
> > +
> > +	if (!IS_ALIGNED(phys, kvm_granule_size(level)))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	ret = stage2_set_prot_attr(pgt, prot, &map_data.attr);
> > +	if (ret)
> > +		return ERR_PTR(ret);
> > +
> > +	pgtable = mm_ops->zalloc_page(mc);
> > +	if (!pgtable)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	ret = __kvm_pgtable_walk(&data, mm_ops, (kvm_pteref_t)pgtable,
> > +				 level + 1);
> > +	if (ret) {
> > +		kvm_pgtable_stage2_free_unlinked(mm_ops, pgtable, level);
> > +		mm_ops->put_page(pgtable);
> > +		return ERR_PTR(ret);
> > +	}
> > +
> > +	return pgtable;
> > +}
> >   int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >   			      struct kvm_pgtable_mm_ops *mm_ops,
> > 
> 
> Thanks,
> Gavin
> 
