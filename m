Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424337E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 15:53:12 +0000 (UTC)
Date: Thu, 13 Apr 2023 15:53:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681401188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DDhBJiuoLWfvR3buxL71Lhhnlb72RGsxq/NWY4TUF+U=;
	b=cokkdAAqL0Xwxvs+5WyToebqEUM68iu5hSg1tsHrLWnRk79gNHwX5Ejea5OnxB/g4lLfeN
	CVESEZsA39ZeQkEOgZP6btSXjPwQhajL29XOZdaU6KAr2+9Zl4XEEgciWldwjMANFb4fOW
	h22i6UfavfGiTO6ucMQnjMUpluktsFU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 2/5] KVM: arm64: nvhe: Synchronise with page table
 walker on TLBI
Message-ID: <ZDglYGkLVtkBd78e@linux.dev>
References: <20230413081441.165134-1-maz@kernel.org>
 <20230413081441.165134-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413081441.165134-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 13, 2023 at 09:14:38AM +0100, Marc Zyngier wrote:
> A TLBI from EL2 impacting EL1 involves messing with the EL1&0
> translation regime, and the page table walker may still be
> performing speculative walks.
> 
> Piggyback on the existing DSBs to always have a DSB ISH that
> will synchronise all load/store operations that the PTW may
> still have.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/hyp/nvhe/tlb.c | 38 ++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index d296d617f589..1da2fc35f94e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -15,8 +15,31 @@ struct tlb_inv_context {
>  };
>  
>  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
> -				  struct tlb_inv_context *cxt)
> +				  struct tlb_inv_context *cxt,
> +				  bool nsh)
>  {
> +	/*
> +	 * We have two requirements:
> +	 *
> +	 * - ensure that the page table updates are visible to all
> +         *   CPUs, for which a dsb(DOMAIN-st) is what we need, DOMAIN
> +         *   being either ish or nsh, depending on the invalidation
> +         *   type.
> +	 *
> +	 * - complete any speculative page table walk started before
> +         *   we trapped to EL2 so that we can mess with the MM
> +         *   registers out of context, for which dsb(nsh) is enough

Looks like a few of these lines are indented with spaces, not tabs. Mind
fixing this when you apply the patches?

-- 
Thanks,
Oliver
