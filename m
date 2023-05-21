Received: from out-3.mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4F58F65
	for <kvmarm@lists.linux.dev>; Sun, 21 May 2023 20:08:22 +0000 (UTC)
Date: Sun, 21 May 2023 20:08:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684699700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q7WQkqZcm04N/jW9ZyNj+nzjjEZmdtn4IamLFYtE6cA=;
	b=Hh2SlnzhFD7KQb3gu2DVVV36KSCTEoYR8cfHjLW7JhOTOV6Wtd/aG6XbB2pSdQ/7bbHPDw
	Z0FJsMP3HpZwW2USrs4aOgzfQfZi4WQupxWYmZfDh+A017BkYU6dEZhA+a56qMTIYKl8ta
	0XE58PVn6TSBtzfBKJjFHerp9lYSKCc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH] KVM: arm64: Prevent unconditional donation of unmapped
 regions from the host
Message-ID: <ZGp6MeRfDOV8EIWz@linux.dev>
References: <20230518095844.1178-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518095844.1178-1-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hi Will,

On Thu, May 18, 2023 at 10:58:44AM +0100, Will Deacon wrote:
> Since host stage-2 mappings are created lazily, we cannot rely solely on
> the pte in order to recover the target physical address when checking a
> host-initiated memory transition as this permits donation of unmapped
> regions corresponding to MMIO or "no-map" memory.
> 
> Instead of inspecting the pte, move the addr_is_allowed_memory() check
> into the host callback function where it is passed the physical address
> directly from the walker.

nit: the subtext here is that the host's stage-2 is an identity map.
That part might not be entirely obvious, as you're passing through the
input address of the walk.

Not worth respinning, but I wonder if some additional documentation on
host stage-2 management would help folks outside of pKVM with reviewing
pKVM changes. Cache behavior could also use a bit more clarification so
folks understand why pKVM elides CMOs and doesn't use FWB.

Of course, I'm likely fooling myself in believing that additional
documentation will get non-pKVM folks to review pKVM changes :)

> Cc: Quentin Perret <qperret@google.com>
> Fixes: e82edcc75c4e ("KVM: arm64: Implement do_share() helper for sharing memory")
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 2e9ec4a2a4a3..a8813b212996 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -575,7 +575,7 @@ struct pkvm_mem_donation {
>  
>  struct check_walk_data {
>  	enum pkvm_page_state	desired;
> -	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
> +	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte, u64 addr);
>  };
>  
>  static int __check_page_state_visitor(const struct kvm_pgtable_visit_ctx *ctx,
> @@ -583,10 +583,7 @@ static int __check_page_state_visitor(const struct kvm_pgtable_visit_ctx *ctx,
>  {
>  	struct check_walk_data *d = ctx->arg;
>  
> -	if (kvm_pte_valid(ctx->old) && !addr_is_allowed_memory(kvm_pte_to_phys(ctx->old)))
> -		return -EINVAL;
> -
> -	return d->get_page_state(ctx->old) == d->desired ? 0 : -EPERM;
> +	return d->get_page_state(ctx->old, ctx->addr) == d->desired ? 0 : -EPERM;
>  }
>  
>  static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
> @@ -601,8 +598,11 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>  
> -static enum pkvm_page_state host_get_page_state(kvm_pte_t pte)
> +static enum pkvm_page_state host_get_page_state(kvm_pte_t pte, u64 addr)
>  {
> +	if (!addr_is_allowed_memory(addr))
> +		return PKVM_NOPAGE;
> +
>  	if (!kvm_pte_valid(pte) && pte)
>  		return PKVM_NOPAGE;
>  
> @@ -709,7 +709,7 @@ static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx
>  	return host_stage2_set_owner_locked(addr, size, host_id);
>  }
>  
> -static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
> +static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte, u64 addr)
>  {
>  	if (!kvm_pte_valid(pte))
>  		return PKVM_NOPAGE;
> -- 
> 2.40.1.698.g37aff9b760-goog
> 

-- 
Thanks,
Oliver
