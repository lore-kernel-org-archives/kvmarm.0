Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817017;
	b=x1v4LmfW+J1DrgiWFBPBHxks7Uus5XfMvehrkMEwz0qZgLPPMBZ+QBvDqb+6cw+DPpi6
	 qYUwdykqEpsRPkqigWlWIWHdTT/BySminmT2S79RJb38vRz48TwcheVCH2ulkyfFUtfti
	 knEr/zIN3jv8hwVWiFc27sYLVCxPyytbXhFJxmiySArP+Y/WxbEMoU1yrQJOJ4QXKwDyy
	 I4LQ+mLoajrEWc7qTd2xn+BguQJwdH0lAqrInINJ+b2BYyg4bUdweyTdu3CJ+08KuBo+2
	 pzzylolQJT2mrdOaJlW9zVLS0frMs7FzF2PemlVB7Hc0sp0NoMAIgKYMkinbxbzG6PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817017;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Nt+81HHtiHnBiA7pn+cJHgsmdV5CCfFRd8Ev2wKd/3g=;
	b=QtDhA2OCQeQ6yFubi6giIHvW8FMdmGIGPteCRfwa/6vXATK35LrSVrowlQ+FyV5j+q+q
	 0QQeU5mmuCJ1GCaCi5epL2i1naK8uah9FI8qBC7bRXY7RBSBZ4JHdBXO4f+0pOziWvXgH
	 z3+JgywRMzxjoS3nkMpn64PtAUHxM2tt1AW8qzISi0RHhxtFRKZW2JbTDA54bdzLtj6bY
	 dw73NN6QVr1B7SNl93evBFt04cWuyPblWjTO/gfb9kegMXL2HnfcT8zG56H4swAXbCMJ/
	 k8elxKbx3ko8dcBOpQlMHExPiIxZshMwHbT7HTEojiRhv+BhHW9SQSDHewYrL8yrJWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=elH7mX4H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F229606A330;
	Wed,  4 Nov 2026 18:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=elH7mX4H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7D71F00919;
	Wed,  4 Nov 2026 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793817017;
	bh=Nt+81HHtiHnBiA7pn+cJHgsmdV5CCfFRd8Ev2wKd/3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=elH7mX4HK4EFG5r7P1A8+P4wn8bxjv1UqwezlkDMypNqjhfjhbPvSHKQCg32lP213
	 XfkMyjQKgQNxm0d5+g6Mct7o3aNxE6vlHgDxthdoXT20nPwMP5YaOU4xw/rUlQya+J
	 HZjXPIGPh3zgPuwLTgx5neURh0la1TP6CPCBsCaIOeLviJZCqR/5BIWL7eB81ANC1J
	 xIGPhyqvEDP4YyEd95zYj+tVFLfiAfYwFxWFBMBck3jJaIJIQFDdDQd2TyE66HfFsA
	 wAogChq8x0fzjQg6+WcCOxvQcflDvxNjSUgIKuQ56cg7R0BVqiFqx53YOCp4Y2vSQ+
	 MkGbdydfuhL+w==
Date: Wed, 4 Nov 2026 10:30:15 -0800
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Resume stage-2 teardown where the
 walk stopped
Message-ID: <aut5t605onnuBWfk@kernel.org>
References: <20261104124451.2148724-1-fuad.tabba@linux.dev>
 <20261104124451.2148724-2-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104124451.2148724-2-fuad.tabba@linux.dev>

Hi Fuad,

On Wed, Nov 04, 2026 at 12:44:50PM +0000, Fuad Tabba wrote:
> +u64 kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> +				     u64 addr, u64 size)

Returning a signed value here would be a good idea so you can percolate
walk failures back up to the caller. Since that WARN_ON() below may as
well be a BUG_ON() in hyp code.

Otherwise, rest looks good.

Thanks,
Oliver

>  {
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_free_walker,
>  		.flags	= KVM_PGTABLE_WALK_LEAF |
>  			  KVM_PGTABLE_WALK_TABLE_POST,
>  	};
> +	struct kvm_pgtable_walk_data data = {
> +		.walker	= &walker,
> +		.start	= addr,
> +		.addr	= addr,
> +		.end	= addr + size,
> +	};
>  
> -	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
> +	if (WARN_ON(_kvm_pgtable_walk(pgt, &data)))
> +		return addr + size;
> +
> +	return data.addr;
>  }
>  
>  void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..4f1adadeffb8b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1011,8 +1011,8 @@ static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
>  
>  	do {
>  		next = stage2_range_addr_end(addr, end);
> -		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
> -							     next - addr);
> +		next = KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr, next - addr);
> +		next = min(next, end);
>  		if (next != end)
>  			cond_resched();
>  	} while (addr = next, addr != end);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 016997288fd23..f21c3326dda68 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -499,14 +499,14 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
>  	return 0;
>  }
>  
> -void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> -					u64 addr, u64 size)
> +u64 pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> +				      u64 addr, u64 size)
>  {
>  	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>  	pkvm_handle_t handle = kvm->arch.pkvm.handle;
>  
>  	if (!handle)
> -		return;
> +		return addr + size;
>  
>  	if (pkvm_hyp_vm_is_created(kvm) && !kvm->arch.pkvm.is_dying) {
>  		WARN_ON(kvm_call_hyp_nvhe(__pkvm_start_teardown_vm, handle));
> @@ -517,6 +517,8 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>  		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
>  	else
>  		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> +
> +	return addr + size;
>  }
>  
>  void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
> -- 
> 2.47.3
> 
