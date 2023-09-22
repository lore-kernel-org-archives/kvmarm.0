Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540BFCA48
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 15:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CCEC433C7;
	Fri, 22 Sep 2023 15:24:14 +0000 (UTC)
Date: Fri, 22 Sep 2023 16:24:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	will@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhukeqian1@huawei.com,
	jonathan.cameron@huawei.com, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Message-ID: <ZQ2xmzZ0H5v5wDSw@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>

On Fri, Aug 25, 2023 at 10:35:23AM +0100, Shameer Kolothum wrote:
> +static bool stage2_pte_writeable(kvm_pte_t pte)
> +{
> +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +}
> +
> +static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx,
> +			      kvm_pte_t new)
> +{
> +	kvm_pte_t old_pte, pte = ctx->old;
> +
> +	/* Only set DBM if page is writeable */
> +	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM) && !stage2_pte_writeable(pte))
> +		return;
> +
> +	/* Clear DBM walk is not shared, update */
> +	if (!kvm_pgtable_walk_shared(ctx)) {
> +		WRITE_ONCE(*ctx->ptep, new);
> +		return;
> +	}

I was wondering if this interferes with the OS dirty tracking (not the
KVM one) but I think that's ok, at least at this point, since the PTE is
already writeable and a fault would have marked the underlying page as
dirty (user_mem_abort() -> kvm_set_pfn_dirty()).

I'm not particularly fond of relying on this but I need to see how it
fits with the rest of the series. IIRC KVM doesn't go around and make
Stage 2 PTEs read-only but rather unmaps them when it changes the
permission of the corresponding Stage 1 VMM mapping.

My personal preference would be to track dirty/clean properly as we do
for stage 1 (e.g. DBM means writeable PTE) but it has some downsides
like the try_to_unmap() code having to retrieve the dirty state via
notifiers.

Anyway, assuming this works correctly, it means that live migration via
DBM is only tracked for PTEs already made dirty/writeable by some guest
write.

> @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	    stage2_pte_executable(new))
>  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>  
> +	/* Save the possible hardware dirty info */
> +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> +	    stage2_pte_writeable(ctx->old))
> +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >> PAGE_SHIFT);
> +
>  	stage2_make_pte(ctx, new);

Isn't this racy and potentially losing the dirty state? Or is the 'new'
value guaranteed to have the S2AP[1] bit? For stage 1 we normally make
the page genuinely read-only (clearing DBM) in a cmpxchg loop to
preserve the dirty state (see ptep_set_wrprotect()).

-- 
Catalin
