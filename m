Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357DB8469
	for <kvmarm@lists.linux.dev>; Mon, 14 Nov 2022 18:56:32 +0000 (UTC)
Date: Mon, 14 Nov 2022 18:56:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668452190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5udZ+ISDmPheWfBt897YJ48hWO5BmuEk3t0+EgBqyY=;
	b=qZZvxC+eJaT/x29y7C98Iv0te2QPyvqPHPnSQau+WHWzWl3J3lyFpvRx4+Q97icgQOWhUm
	ubcx7aaMR4ASeegeaahM1IxcIf844OwQpiN2QMgXJp39Zk0wFUcFYKCuJs8JeVMy47Ylps
	50eVXZsTXpHNMuCUdCq9f/UU1S2iSxo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, dmatlack@google.com,
	qperret@google.com, catalin.marinas@arm.com, andrew.jones@linux.dev,
	seanjc@google.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com,
	eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	ricarkol@gmail.com
Subject: Re: [RFC PATCH 06/12] KVM: arm64: Split block PTEs without using
 break-before-make
Message-ID: <Y3KPWTj0KwLtL535@google.com>
References: <20221112081714.2169495-1-ricarkol@google.com>
 <20221112081714.2169495-7-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112081714.2169495-7-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221114185625.qkJX8GkwdAbmjpEEz_jkGsqaP0T22WJOcsbbyoqIQcY@z>

On Sat, Nov 12, 2022 at 08:17:08AM +0000, Ricardo Koller wrote:
> Breaking a huge-page block PTE into an equivalent table of smaller PTEs
> does not require using break-before-make (BBM) when FEAT_BBM level 2 is
> implemented. Add the respective check for eager page splitting and avoid
> using BBM.
> 
> Also take care of possible Conflict aborts.  According to the rules
> specified in the Arm ARM (DDI 0487H.a) section "Support levels for changing
> block size" D5.10.1, this can result in a Conflict abort. So, handle it by
> clearing all VM TLB entries.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

I'd suggest adding the TLB conflict abort handler as a separate commit
prior to actually relaxing break-before-make requirements.

> ---
>  arch/arm64/include/asm/esr.h     |  1 +
>  arch/arm64/include/asm/kvm_arm.h |  1 +
>  arch/arm64/kvm/hyp/pgtable.c     | 10 +++++++++-
>  arch/arm64/kvm/mmu.c             |  6 ++++++
>  4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 15b34fbfca66..6f5b976396e7 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -114,6 +114,7 @@
>  #define ESR_ELx_FSC_ACCESS	(0x08)
>  #define ESR_ELx_FSC_FAULT	(0x04)
>  #define ESR_ELx_FSC_PERM	(0x0C)
> +#define ESR_ELx_FSC_CONFLICT	(0x30)
>  
>  /* ISS field definitions for Data Aborts */
>  #define ESR_ELx_ISV_SHIFT	(24)
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 0df3fc3a0173..58e7cbe3c250 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -333,6 +333,7 @@
>  #define FSC_SECC_TTW1	(0x1d)
>  #define FSC_SECC_TTW2	(0x1e)
>  #define FSC_SECC_TTW3	(0x1f)
> +#define FSC_CONFLICT	ESR_ELx_FSC_CONFLICT
>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9c42eff6d42e..36b81df5687e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1267,6 +1267,11 @@ static int stage2_create_removed(kvm_pte_t *ptep, u64 phys, u32 level,
>  	return __kvm_pgtable_visit(&data, mm_ops, ptep, level);
>  }
>  
> +static bool stage2_has_bbm_level2(void)
> +{
> +	return cpus_have_const_cap(ARM64_HAS_STAGE2_BBM2);
> +}
> +
>  struct stage2_split_data {
>  	struct kvm_s2_mmu		*mmu;
>  	void				*memcache;
> @@ -1308,7 +1313,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	 */
>  	WARN_ON(stage2_create_removed(&new, phys, level, attr, mc, mm_ops));
>  
> -	stage2_put_pte(ctx, data->mmu, mm_ops);
> +	if (stage2_has_bbm_level2())
> +		mm_ops->put_page(ctx->ptep);
> +	else
> +		stage2_put_pte(ctx, data->mmu, mm_ops);
>  
>  	/*
>  	 * Note, the contents of the page table are guaranteed to be made
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8f26c65693a9..318f7b0aa20b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1481,6 +1481,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		return 1;
>  	}
>  
> +	/* Conflict abort? */
> +	if (fault_status == FSC_CONFLICT) {
> +		kvm_flush_remote_tlbs(vcpu->kvm);

You don't need to perfom a broadcasted invalidation in this case. A
local invalidation using the guest's VMID should suffice.

--
Thanks,
Oliver
