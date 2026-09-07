Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376EC233941
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802801; cv=none; b=ZVHdTlDRNUjO62mUm2r6sXh9KNIotBrl1Y1BQlefeub2h1NiR8dK7OKckysEFg3XDoomUqsEqFvwr18AClzTxbxFKj1ceqnikM7l4hnldFXZjihJzU2iK3+geY4HSh0Erwf5qxjv7GE45LQ6J3PcCWrDeso38LyRmHrlC5VaiWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802801; c=relaxed/simple;
	bh=mCHv8QWREL9tLi9nn5djqU0KYHo3eIWOT8BOVsSNXw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHUWVCIJ7V+n6AAWMKV7x1pUKpyQ6J1028H4IkdE6TE8eOLQZxbdKStg9Kl2OS0QegbhQNMWLSwz6HLUEOT2ZvHH3goD2XGzqQczvXVGlfSH4yDaUXEFuDOFmH4OoNbJZyEWsnb3PVwgdxLcPGlDUnIiApUc33fWamBFCdW4YVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a9BI2JpV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a9BI2JpV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3FA01476;
	Mon,  7 Sep 2026 10:39:54 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C70AF3F7B4;
	Mon,  7 Sep 2026 10:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788802798; bh=mCHv8QWREL9tLi9nn5djqU0KYHo3eIWOT8BOVsSNXw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a9BI2JpVBxSSDS+m72CeeDX6ffb3EdfOglJnSPo8Q2Q0vtvNkoEdGWkcTa9FZcrQ4
	 eT6/EPai5xqzDJl42RBKYXWRYiWCigTExzwUcjS81YiovTgqcAtMkxDIyd1Qv6knDE
	 odbfWY6LJEZi0WNC05ggjRe17GBa2PKE177pzLx4=
Date: Mon, 7 Sep 2026 18:39:49 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 16/20] KVM: arm64: Add __pkvm_host_split_guest HVC
Message-ID: <hrhbuwdfu625jtzm75t6wnva6odgreshchyv75ebqntlymslz7@adyxhe7oyypc>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-17-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-17-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:09:00AM +0100, Vincent Donnefort wrote:

[...]

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 41a8687938eb..355573d53fed 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -824,8 +824,7 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   * kvm_pgtable_stage2_split() is best effort: it tries to break as many
>   * blocks in the input range as allowed by @mc_capacity.

Maybe also adjust the comment and remove @mc_capacity while changing
this, looks like it was included by mistake.

>   */
> -int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
> -			     struct kvm_mmu_memory_cache *mc);
> +int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size, void *mc);
>  

[...]

> +static int host_stage2_split_gfn_meta(phys_addr_t phys, u64 ipa, u64 size, struct pkvm_hyp_vm *vm)
> +{
> +	pkvm_handle_t handle;
> +	kvm_pte_t pte;
> +	u64 gfn, end;
> +	s8 level;
> +	int ret;
> +
> +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
> +	if (ret)
> +		return ret;
> +
> +	if (kvm_granule_size(level) != size)
> +		return -EINVAL;
> +
> +	ret = host_stage2_decode_gfn_meta(pte, &handle, &gfn);
> +	if (ret)
> +		return ret;
> +
> +	if (handle != vm->kvm.arch.pkvm.handle || gfn != (ipa >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	end = phys + size;
> +	while (phys < end) {
> +		u64 meta = host_stage2_encode_gfn_meta(vm, gfn);
> +		kvm_pte_t annotation = FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_GUEST) |
> +				       FIELD_PREP(KVM_HOST_DONATION_PTE_EXTRA_MASK, meta);
> +
> +		ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> +				      phys, PAGE_SIZE, &host_s2_pool,
> +				      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
> +		if (WARN_ON(ret))
> +			return ret;
> +
> +		phys += PAGE_SIZE;
> +		gfn++;

Annotating every PTE is required here because patch 2's
stage2_map_prefault_idmap() copies the same annotation to each PTE, so
the resulting PTEs all contain the same gfn.

In other words patch 2 simply leaves wrong annotations in this case, and
we make up for it here.

We can't just remove patch 2 because a HYP owned block needs to be
broken down with HYP owned annotations when a single page is donated
back to the host.

With this, would it be a better design to have an annotation-aware
helper that splits a host block properly including the annotations, and
call it whenever pKVM annotates or maps host stage-2?

>  	}
>  
> -	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
>  	return 0;
>  }
>  

[...]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c4ebae0544d4..986b5a19b07a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1537,9 +1537,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  			       enum kvm_pgtable_walk_flags visit)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
> -	struct kvm_mmu_memory_cache *mc = ctx->arg;
> -	struct kvm_s2_mmu *mmu;
> +	struct stage2_map_data *data = ctx->arg;
>  	kvm_pte_t pte = ctx->old, new, *childp;
> +	struct kvm_s2_mmu *mmu = data->mmu;
> +	void *mc = data->memcache;
>  	enum kvm_pgtable_prot prot;
>  	s8 level = ctx->level;
>  	bool force_pte;
> @@ -1554,30 +1555,37 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	if (!kvm_pte_valid(pte))
>  		return 0;
>  
> -	nr_pages = stage2_block_get_nr_page_tables(level);
> -	if (nr_pages < 0)
> -		return nr_pages;
> -
> -	if (mc->nobjs >= nr_pages) {
> -		/* Build a tree mapped down to the PTE granularity. */
> +	if (unlikely(is_protected_kvm_enabled())) {
> +		/* pKVM only supports splitting PMD-level blocks */
> +		if (level != KVM_PGTABLE_LAST_LEVEL - 1)
> +			return -EINVAL;
>  		force_pte = true;
>  	} else {
> -		/*
> -		 * Don't force PTEs, so create_unlinked() below does
> -		 * not populate the tree up to the PTE level. The
> -		 * consequence is that the call will require a single
> -		 * page of level 2 entries at level 1, or a single
> -		 * page of PTEs at level 2. If we are at level 1, the
> -		 * PTEs will be created recursively.
> -		 */
> -		force_pte = false;
> -		nr_pages = 1;
> +		struct kvm_mmu_memory_cache *host_mc = mc;
> +
> +		nr_pages = stage2_block_get_nr_page_tables(level);
> +		if (nr_pages < 0)
> +			return nr_pages;
> +
> +		if (host_mc->nobjs >= nr_pages) {
> +			/* Build a tree mapped down to the PTE granularity. */
> +			force_pte = true;
> +		} else if (host_mc->nobjs) {
> +			/*
> +			 * Don't force PTEs, so create_unlinked() below does
> +			 * not populate the tree up to the PTE level. The
> +			 * consequence is that the call will require a single
> +			 * page of level 2 entries at level 1, or a single
> +			 * page of PTEs at level 2. If we are at level 1, the
> +			 * PTEs will be created recursively.
> +			 */
> +			force_pte = false;
> +			nr_pages = 1;
> +		} else {
> +			return -ENOMEM;
> +		}
>  	}
>  
> -	if (mc->nobjs < nr_pages)
> -		return -ENOMEM;
> -
> -	mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>  	phys = kvm_pte_to_phys(pte);
>  	prot = kvm_pgtable_stage2_pte_prot(pte);

I feel like this change is trying too hard to make the pKVM case fit
in stage2_split_walker(). The assumptions differ by much: the original
usage assumes kvm_mmu_memory_cache, can potentially split more than one
level, and makes decisions base on the memcache's reserve.

Perhaps create another function for pKVM?

Thanks,
Wei-Lin Chang

[...]
