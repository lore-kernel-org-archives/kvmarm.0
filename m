Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965638C17
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 22:23:20 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id y2so13483096pjg.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 15:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678746200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9l5Ve0UxgoLMBKMksZkfdofXsYRc9aQSH3fLV3MAlQ8=;
        b=Sd+XqeZjfeCfN+mlYZ7bilJKS6Z5hy0nd1zrxE1d0QkSdbA/9FxyS4/n8nqRwWjkaS
         4wlBRhfwQejcy9OtyTDeOeBUPZmC3WDTXeKreVji3M6KPVFeejPQ6Bs9GeBTf8F9qAY2
         J/YJ9MvyXNIQa1LsEx4ffShhGVENHwEBNAJswR4JqdiKeKAKb2CP3EnDfY/O9SvFIaXb
         cCpBnjFQe6PTBHjly2cqcW9Z9lRZcTRmSiCnVmt9lT6g2AoByiUGUuj1gjXtixx84oFa
         +68bv+Wa9fTPulXfZS68RELW7AEpYjuRqX27DcXKLGdKeY1PA5gY8dmJZzwD4iYvDiEm
         piuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9l5Ve0UxgoLMBKMksZkfdofXsYRc9aQSH3fLV3MAlQ8=;
        b=rfgtAxuL9869DG8HnKym+/w9T/B9vFeYxqQNE6S39k5rsGq5aiCaxFWOYv6s0lR1qX
         vEPRPvkAOg4UsNmm1cS9VzaoxTugGTty3k1CyS+4fhqZbXy7jgHrIozs2Fh1JenWmqay
         +MhJVRsRByouvSb8/C4dcoIC/V37ZqxA8k/p7wLP30kh7bQ00oQFJuUkhXsr1rP36C9p
         E4Z/YDkyw0fVsEm0dcEBPq5K2KEDTXC3OvrF0biZGhNTc/9GJ04Y1ZobuOXjeCHN/24J
         HgQrTpQgnXAsPcczDLGPwYKcV+nzvv7Qd6qsnikd/e36oJ2nu4NPa0xPkOM8M3hxEaeu
         0J0w==
X-Gm-Message-State: AO0yUKW28Qzxm1omtHErcZGJr45RHfSmqCWNSZPpbTRxcC2PPXG29hnv
	nNCMLpC94vVAnWenIRim7tOw+Q==
X-Google-Smtp-Source: AK7set//QUqUX6ZCcfpvgMx+4HW1VhG91pmb65zEKddSQ+I0+3EbP7qVICvv53G6hvCvnF2y+YSlcQ==
X-Received: by 2002:a17:902:ba92:b0:19b:c61:2867 with SMTP id k18-20020a170902ba9200b0019b0c612867mr25178pls.15.1678746199707;
        Mon, 13 Mar 2023 15:23:19 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id u15-20020a17090a6a8f00b0023cfa3f7c9fsm63029pjj.10.2023.03.13.15.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 15:23:19 -0700 (PDT)
Date: Mon, 13 Mar 2023 15:23:15 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: pbonzini@redhat.com, oupton@google.com, yuzenghui@huawei.com,
	dmatlack@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	qperret@google.com, catalin.marinas@arm.com, andrew.jones@linux.dev,
	seanjc@google.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v6 03/12] KVM: arm64: Add helper for creating unlinked
 stage2 subtrees
Message-ID: <ZA+iU4EZvL8B0xgM@google.com>
References: <20230307034555.39733-1-ricarkol@google.com>
 <20230307034555.39733-4-ricarkol@google.com>
 <87bkky5ivc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkky5ivc.wl-maz@kernel.org>

On Sun, Mar 12, 2023 at 11:06:31AM +0000, Marc Zyngier wrote:
> On Tue, 07 Mar 2023 03:45:46 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > Add a stage2 helper, kvm_pgtable_stage2_create_unlinked(), for
> > creating unlinked tables (which is the opposite of
> > kvm_pgtable_stage2_free_unlinked()).  Creating an unlinked table is
> > useful for splitting PMD and PUD blocks into subtrees of PAGE_SIZE
> 
> Please drop the PMD/PUD verbiage. That's specially confusing when
> everything is described in terms of 'level'
> 
> > PTEs.  For example, a PUD can be split into PAGE_SIZE PTEs by first
> 
> for example: s/a PUD/a level 1 mapping/
> 
> > creating a fully populated tree, and then use it to replace the PUD in
> > a single step.  This will be used in a subsequent commit for eager
> > huge-page splitting (a dirty-logging optimization).
> > 
> > No functional change intended. This new function will be used in a
> > subsequent commit.
> 
> Drop this last sentence, it doesn't say anything that you haven't
> already said.
> 
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 28 +++++++++++++++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 46 ++++++++++++++++++++++++++++
> >  2 files changed, 74 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index c7a269cad053..b7b3fc0fa7a5 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -468,6 +468,34 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
> >   */
> >  void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
> >  
> > +/**
> > + * kvm_pgtable_stage2_create_unlinked() - Create an unlinked stage-2 paging structure.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > + * @phys:	Physical address of the memory to map.
> > + * @level:	Starting level of the stage-2 paging structure to be created.
> > + * @prot:	Permissions and attributes for the mapping.
> > + * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
> > + *		page-table pages.
> > + * @force_pte:  Force mappings to PAGE_SIZE granularity.
> > + *
> > + * Returns an unlinked page-table tree. If @force_pte is true or
> > + * @level is 2 (the PMD level), then the tree is mapped up to the
> > + * PAGE_SIZE leaf PTE; the tree is mapped up one level otherwise.
> 
> I wouldn't make this "one level" assumption, as this really depends on
> the size of what gets mapped (and future evolution of this code).
> 
> > + * This new page-table tree is not reachable (i.e., it is unlinked)
> > + * from the root pgd and it's therefore unreachableby the hardware
> > + * page-table walker. No TLB invalidation or CMOs are performed.
> > + *
> > + * If device attributes are not explicitly requested in @prot, then the
> > + * mapping will be normal, cacheable.
> > + *
> > + * Return: The fully populated (unlinked) stage-2 paging structure, or
> > + * an ERR_PTR(error) on failure.
> 
> What guarantees that this new unlinked structure is kept in sync with
> the original one? AFAICT, nothing does.
> 

That should be the job of the caller: kvm_pgtable_stage2_split() in this
series.

> > + */
> > +kvm_pte_t *kvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt,
> > +					      u64 phys, u32 level,
> > +					      enum kvm_pgtable_prot prot,
> > +					      void *mc, bool force_pte);
> > +
> >  /**
> >   * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> >   * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 4f703cc4cb03..6bdfcb671b32 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1212,6 +1212,52 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >  	return kvm_pgtable_walk(pgt, addr, size, &walker);
> >  }
> >  
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
> > +				  KVM_PGTABLE_WALK_SKIP_BBM |
> > +				  KVM_PGTABLE_WALK_SKIP_CMO,
> > +		.arg		= &map_data,
> > +	};
> > +	/* .addr (the IPA) is irrelevant for an unlinked table */
> > +	struct kvm_pgtable_walk_data data = {
> > +		.walker	= &walker,
> > +		.addr	= 0,
> 
> Is that always true? What if the caller expect a non-block-aligned
> mapping? You should at least check that phys is aligned to the granule
> size of 'level', or bad stuff may happen.
> 

Good point, it should be true, but I will add a check to fail with
EINVAL on that case. Will also double check the caller's code to be sure
mappings are always block-aligned.

> > +		.end	= kvm_granule_size(level),
> > +	};
> > +	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
> > +	kvm_pte_t *pgtable;
> > +	int ret;
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
> >  
> >  int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
> >  			      struct kvm_pgtable_mm_ops *mm_ops,
> 
> 	M.
> 
> -- 

ACK on all the other comments.

Thanks,
Ricardo

> Without deviation from the norm, progress is not possible.
