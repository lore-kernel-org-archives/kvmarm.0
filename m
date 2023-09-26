Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D9C241FC
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 15:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117E9C433C8;
	Tue, 26 Sep 2023 15:20:05 +0000 (UTC)
Date: Tue, 26 Sep 2023 16:20:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>, zhukeqian <zhukeqian1@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Message-ID: <ZRL2owYDvKF6gnlb@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
 <ZQ2xmzZ0H5v5wDSw@arm.com>
 <ZQ3TjMcc0FhZCR0r@linux.dev>
 <c4e12638b4874dc4809d24ce131d7b07@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e12638b4874dc4809d24ce131d7b07@huawei.com>

On Mon, Sep 25, 2023 at 08:04:39AM +0000, Shameerali Kolothum Thodi wrote:
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> > On Fri, Sep 22, 2023 at 04:24:11PM +0100, Catalin Marinas wrote:
> > > I was wondering if this interferes with the OS dirty tracking (not the
> > > KVM one) but I think that's ok, at least at this point, since the PTE is
> > > already writeable and a fault would have marked the underlying page as
> > > dirty (user_mem_abort() -> kvm_set_pfn_dirty()).
> > >
> > > I'm not particularly fond of relying on this but I need to see how it
> > > fits with the rest of the series. IIRC KVM doesn't go around and make
> > > Stage 2 PTEs read-only but rather unmaps them when it changes the
> > > permission of the corresponding Stage 1 VMM mapping.
> > >
> > > My personal preference would be to track dirty/clean properly as we do
> > > for stage 1 (e.g. DBM means writeable PTE) but it has some downsides
> > > like the try_to_unmap() code having to retrieve the dirty state via
> > > notifiers.
> > 
> > KVM's usage of DBM is complicated by the fact that the dirty log
> > interface w/ userspace is at PTE granularity. We only want the page
> > table walker to relax PTEs, but take faults on hugepages so we can do
> > page splitting.

Thanks for the clarification.

> > > > @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> > > >  	    stage2_pte_executable(new))
> > > >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> > > >
> > > > +	/* Save the possible hardware dirty info */
> > > > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > > > +	    stage2_pte_writeable(ctx->old))
> > > > +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >> PAGE_SHIFT);
> > > > +
> > > >  	stage2_make_pte(ctx, new);
> > >
> > > Isn't this racy and potentially losing the dirty state? Or is the 'new'
> > > value guaranteed to have the S2AP[1] bit? For stage 1 we normally make
> > > the page genuinely read-only (clearing DBM) in a cmpxchg loop to
> > > preserve the dirty state (see ptep_set_wrprotect()).
> > 
> > stage2_try_break_pte() a few lines up does a cmpxchg() and full
> > break-before-make, so at this point there shouldn't be a race with
> > either software or hardware table walkers.

Ah, I missed this. Also it was unrelated to this patch (or rather not
introduced by this patch).

> > In both cases the 'old' translation should have DBM cleared. Even if the
> > PTE were dirty, this is wasted work since we need to do a final scan of
> > the stage-2 when userspace collects the dirty log.
> > 
> > Am I missing something?
> 
> I think we can get rid of the above mark_page_dirty(). I will test it to confirm
> we are not missing anything here.

Is this the case for the other places of mark_page_dirty() in your
patches? If stage2_pte_writeable() is true, it must have been made
writeable earlier by a fault and the underlying page marked as dirty.

-- 
Catalin
