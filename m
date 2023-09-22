Received: from out-208.mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E22436B1
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 17:49:07 +0000 (UTC)
Date: Fri, 22 Sep 2023 17:49:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695404945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yWuya+6N9+7BTSlOuj84T8LL44d++YMtdnE2EXlJ65Q=;
	b=gHYjf5dc1QB8Xn3bItq2aA450TW2y+qAb32zmwoTAMpAjILjlfiu3Ebq97l/ioV1UzZ6Pe
	gfrRIqsyLqkAkXhCExidjRzzUcPD+GzKtfDlwpuhdxUV0Kok8Z/6CRxoyQomtxDA169KDd
	P22eWFdau/9obDGPbQGrhbMWT9AFuM4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, zhukeqian1@huawei.com,
	jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Message-ID: <ZQ3TjMcc0FhZCR0r@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
 <ZQ2xmzZ0H5v5wDSw@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQ2xmzZ0H5v5wDSw@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 22, 2023 at 04:24:11PM +0100, Catalin Marinas wrote:
> On Fri, Aug 25, 2023 at 10:35:23AM +0100, Shameer Kolothum wrote:
> > +static bool stage2_pte_writeable(kvm_pte_t pte)
> > +{
> > +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +}
> > +
> > +static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx,
> > +			      kvm_pte_t new)
> > +{
> > +	kvm_pte_t old_pte, pte = ctx->old;
> > +
> > +	/* Only set DBM if page is writeable */
> > +	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM) && !stage2_pte_writeable(pte))
> > +		return;
> > +
> > +	/* Clear DBM walk is not shared, update */
> > +	if (!kvm_pgtable_walk_shared(ctx)) {
> > +		WRITE_ONCE(*ctx->ptep, new);
> > +		return;
> > +	}
> 
> I was wondering if this interferes with the OS dirty tracking (not the
> KVM one) but I think that's ok, at least at this point, since the PTE is
> already writeable and a fault would have marked the underlying page as
> dirty (user_mem_abort() -> kvm_set_pfn_dirty()).
> 
> I'm not particularly fond of relying on this but I need to see how it
> fits with the rest of the series. IIRC KVM doesn't go around and make
> Stage 2 PTEs read-only but rather unmaps them when it changes the
> permission of the corresponding Stage 1 VMM mapping.
> 
> My personal preference would be to track dirty/clean properly as we do
> for stage 1 (e.g. DBM means writeable PTE) but it has some downsides
> like the try_to_unmap() code having to retrieve the dirty state via
> notifiers.

KVM's usage of DBM is complicated by the fact that the dirty log
interface w/ userspace is at PTE granularity. We only want the page
table walker to relax PTEs, but take faults on hugepages so we can do
page splitting.

> Anyway, assuming this works correctly, it means that live migration via
> DBM is only tracked for PTEs already made dirty/writeable by some guest
> write.

I'm hoping that we move away from this combined write-protection and DBM
scheme and only use a single dirty tracking strategy at a time.

> > @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  	    stage2_pte_executable(new))
> >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> >  
> > +	/* Save the possible hardware dirty info */
> > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > +	    stage2_pte_writeable(ctx->old))
> > +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >> PAGE_SHIFT);
> > +
> >  	stage2_make_pte(ctx, new);
> 
> Isn't this racy and potentially losing the dirty state? Or is the 'new'
> value guaranteed to have the S2AP[1] bit? For stage 1 we normally make
> the page genuinely read-only (clearing DBM) in a cmpxchg loop to
> preserve the dirty state (see ptep_set_wrprotect()).

stage2_try_break_pte() a few lines up does a cmpxchg() and full
break-before-make, so at this point there shouldn't be a race with
either software or hardware table walkers.

But I'm still confused by this one. KVM only goes down the map
walker path (in the context of dirty tracking) if:

 - We took a translation fault

 - We took a write permission fault on a hugepage and need to split

In both cases the 'old' translation should have DBM cleared. Even if the
PTE were dirty, this is wasted work since we need to do a final scan of
the stage-2 when userspace collects the dirty log.

Am I missing something?

-- 
Thanks,
Oliver
