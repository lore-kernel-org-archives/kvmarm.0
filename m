Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2824E96
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 19:42:34 +0000 (UTC)
Date: Fri, 26 May 2023 19:42:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685130152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+HOhs+G8tayqS3761Ku9853mJxQmfAAb4L3el4gd5LE=;
	b=bS1vv1nL1oS/LTlqvsDeymDsSStxmIRIHRiCTw+zLgtYEt9W3//Ckw/kZRjn9Fx+u+vmq2
	wQ2gFOeTvz5CuCvK3SdmIsKNBOZ8vxk2iDEA60l2Q87I8+3btPx8fkVxTzZe72R3B+6MDS
	KVgpD0I1sRp3shO7CjwLuP66nPmZpeE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	tabba@google.com, qperret@google.com, will@kernel.org,
	catalin.marinas@arm.com, yuzenghui@huawei.com,
	suzuki.poulose@arm.com, james.morse@arm.com, bgardon@google.com,
	gshan@redhat.com
Subject: Re: [PATCH v2] KVM: arm64: Use BTI for nvhe
Message-ID: <ZHELoziooIyk0d+t@linux.dev>
References: <20230517173552.163711-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517173552.163711-1-smostafa@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Mostafa,

On Wed, May 17, 2023 at 05:35:52PM +0000, Mostafa Saleh wrote:
> CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
> However, the nvhe code doesn't make use of it as it doesn't map any
> pages with Guarded Page(GP) bit.
> 
> This patch maps nvhe(and pKVM recreated mapping of) .text section
> with GP bit which matches the kernel handling for BTI.
> 
> A new flag is added to enum kvm_pgtable_prot: KVM_PGTABLE_PROT_GP_S1,
> which represents BTI guarded page in hypervisor stage-1 page table.
> 
> At hyp init, SCTLR_EL2.BT is set to 1 to match EL1 configuration
> (SCTLR_EL1.BT1) set in bti_enable().
> 
> hyp_init_valid_leaf_pte is added to avoid unnecessary considering GP
> bit for stage-2.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
> v1 -> v2:
> - Enable BTI for nvhe also.
> - Only set GP bit for executable pages from pgtable code.
> - Set SCTLR_EL2.BT when BTI is used.
> - use system_supports_bti() for consistency.
> - Add hyp_init_valid_leaf_pte.
> v1: https://lore.kernel.org/all/20230516141846.792193-1-smostafa@google.com/
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  3 +++
>  arch/arm64/include/asm/sysreg.h      |  1 +
>  arch/arm64/kvm/arm.c                 |  7 ++++++-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  7 +++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c      |  8 ++++++--
>  arch/arm64/kvm/hyp/pgtable.c         | 11 ++++++++++-
>  6 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 4cd6762bda80..5bcd06d664d3 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -151,6 +151,7 @@ enum kvm_pgtable_stage2_flags {
>   * @KVM_PGTABLE_PROT_W:		Write permission.
>   * @KVM_PGTABLE_PROT_R:		Read permission.
>   * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
> + * @KVM_PGTABLE_PROT_GP_S1:	GP(guarded page) used for BTI in stage-1 only
>   * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
>   * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
>   * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
> @@ -163,6 +164,8 @@ enum kvm_pgtable_prot {
>  
>  	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
>  
> +	KVM_PGTABLE_PROT_GP_S1			= BIT(50),
> +

This enumeration is used to generically describe permissions that could
be applied to either stage-1 or stage-2.

Can't we just have KVM_PGTABLE_PROT_X imply GP at hyp stage-1, assuming
BTI is available and we're using it for the kernel?

>  	KVM_PGTABLE_PROT_SW0			= BIT(55),
>  	KVM_PGTABLE_PROT_SW1			= BIT(56),
>  	KVM_PGTABLE_PROT_SW2			= BIT(57),

[...]

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3d61bd3e591d..9f68e4ce6d14 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -152,6 +152,13 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
>  	return pte;
>  }
>  
> +static kvm_pte_t hyp_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> +{
> +	kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, attr, level);
> +
> +	return pte | (attr & KVM_PGTABLE_PROT_GP_S1);

This is a bit of a hack to cram the GP bit back in. I'm guessing the
fact that our ATTR_HI mask doesn't include bit 50 led you here.

My interpretation DDI0487J D8.3.2 is that the upper attribute field is
63:50 for both stages of translation, but bit 50 is RES0 for stage-2.

So, rather than going this route, I'd recommend tweaking the ATTR_HI
mask to include bit 50.

> +}
> +
>  static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
>  {
>  	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
> @@ -371,6 +378,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>  
>  		if (device)
>  			return -EINVAL;
> +
> +		attr |= prot & KVM_PGTABLE_PROT_GP_S1;

With the above suggestions, this would become:

		if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) && system_supports_bti())
			attr |= KVM_PTE_LEAF_ATTR_HI_S1_GP;

>  	} else {
>  		attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
>  	}
> @@ -414,7 +423,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  		return false;
>  
>  	data->phys += granule;
> -	new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
> +	new = hyp_init_valid_leaf_pte(phys, data->attr, ctx->level);
>  	if (ctx->old == new)
>  		return true;
>  	if (!kvm_pte_valid(ctx->old))
> -- 
> 2.40.1.698.g37aff9b760-goog
> 

-- 
Thanks,
Oliver
