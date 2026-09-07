Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535004E80CC
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 13:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789537; cv=none; b=qOvuzZ0gN79QUszTAa1opkuI9VchDQO8KeQCaKOauyuK4Sa539eBoFF1X5aH0IaoKmvbyRLDRBseknWxJeisMmYWsXTQayY+zg/TS945FyiubEoNIP98VutRRq4ii9tyFmCC/TFYjz70UNxkjq9pcxgLAvgS+qphRwyzLuxdtCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789537; c=relaxed/simple;
	bh=NzNTBAk83y8XbyUgLM1mh1qrc9Ozm93iuKTO8tf07XU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLsc9DR9mbQ75OasmBI9qfmQjS0ApTB+usDYi6MDt5d8H22qHm8mvlKQkoQZxiTO2BJm/1YSZU8sZ6nmAxBddG4DbPPLcC7tJCRCI1rhO60Iug5baKEqgEDZ0XVXIx51iR7r5DhoWHiD6hZlNPqotv/8Fwzo2PiQEjMDccevBYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MRKClLKv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MRKClLKv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FBF31476;
	Mon,  7 Sep 2026 06:58:50 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D385A3F528;
	Mon,  7 Sep 2026 06:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788789534; bh=NzNTBAk83y8XbyUgLM1mh1qrc9Ozm93iuKTO8tf07XU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRKClLKvPgio3jdXujlosyDA32qA3RlgTkFD4Q2tAWuc05NA41F2XQnz+X4BHuCHL
	 PRcb0JZJ+oU9MskoG6yXVymOI/mM5/nFqpNvW6++qLhmZHLpHH8ymeBmBwFaIZ4KXz
	 T+UHNx3k6wbHuZdHECJJd6BUStNCTgCc38wgi77s=
Date: Mon, 7 Sep 2026 14:58:41 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 02/20] KVM: arm64: Propagate host stage-2 annotated
 entries on block split
Message-ID: <s3p6em2fovzkpyy5lpslxl7nl6ojhoilyqlydidy4unef6wnuw@mzgrpwwkbaxn>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-3-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-3-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:08:46AM +0100, Vincent Donnefort wrote:

[...]

>  static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
>  {
>  	kvm_pte_t block_pte = ctx->old;
> +	bool counted, valid;
>  	u64 pa;
>  	int i;
>  
> -	if (!kvm_pte_valid(block_pte))
> +	counted = stage2_pte_is_counted(block_pte);
> +	valid = kvm_pte_valid(block_pte);
> +
> +	if (!valid && !counted)
> +		return;
> +
> +	/*
> +	 * Shared walks not supported: cannot rollback refcounts on break
> +	 * failure.
> +	 */
> +	if (counted && WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))

Doesn't patch 1 also need this shared walk check,

>  		return;
>  
>  	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
>  	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
> -		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
> +		kvm_pte_t pte = valid ?
> +			kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1) :
> +			block_pte;
>  
>  		/*
>  		 * Skip ptes in the range being modified by the caller if we're
> @@ -1053,8 +1066,11 @@ static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, k
>  		 * that should happen very infrequently.
>  		 */
>  		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
> -		    (pa < ctx->addr) || (pa >= ctx->end))
> +		    (pa < ctx->addr) || (pa >= ctx->end)) {
>  			*ptep = pte;
> +			if (counted)
> +				ctx->mm_ops->get_page(ptep);

and this get_page() ?

Thanks,
Wei-Lin Chang

[...]
