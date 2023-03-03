Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177241FA1
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 08:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677832039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WFYFQuvsCyfJ0+bFj+XRdwBAghKkfS/2B2bALcaq8I0=;
	b=TtCNj4oEoNLgWBrhJG5gx2Rb+cLGhF0vpdXmGz76Wcl+mvRsBuf0PynmeUgFOKF/K44lpr
	AqdMdMuzVSm0dmkf9uiNO5QzfUXNpKbxkPC5X68OJktNkndz9FGmWsLXax8iIMj/iz6+nA
	CFWHxNc0UhQXR/aLIyktTj5NmG+t+uM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-qto15gTBM22DY_G-N20lUA-1; Fri, 03 Mar 2023 03:27:17 -0500
X-MC-Unique: qto15gTBM22DY_G-N20lUA-1
Received: by mail-pl1-f199.google.com with SMTP id la3-20020a170902fa0300b0019ca5ddecedso1070115plb.1
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 00:27:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677832036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WFYFQuvsCyfJ0+bFj+XRdwBAghKkfS/2B2bALcaq8I0=;
        b=SmBnCYkYvsYL3pTwQEENXLw8r3mglGRsGfCZzksDXSkX0oyuVxDQDt8jxb7fWVMScN
         L2Fdgimo2jufeBIVMuYeYuv/pGF7SChOnB6tyw6Y/GPoAbCX8GoidL6BxK3Q1vpj1l9+
         e/K0qhKmZxS/QdHHBs0xLDPufCPpEc2laCiQVoHULRSbEoiJmu3GMKIpFArNaE3jOCS7
         2PZuaIvLwNiwTzhWdLscPjteHSByGmWJKwXzB21Ui4qb9QPP+BYRQ/AhfGsMhj8bmM1k
         uNAQ6SlprgTAtcloJcNWpcE7a2rbUybRu1LxfTF7x6YruhKYT0py0CLWMjYsmNKE6UWi
         L0VA==
X-Gm-Message-State: AO0yUKV4qeLr3NmDh5kvpsMN+mHyjbHXX65OzdoaJ681Kllp6SsAO0bE
	T2q4elB2IEmqISG8CMRdlEdeXrcWCXPTHKT8yxHH1QjyeV8YxW6UmNfaPUDHdGVehE8INwBsOhE
	UTOksJmkxDsoDDUbT
X-Received: by 2002:a17:90a:bc08:b0:233:f0f3:238b with SMTP id w8-20020a17090abc0800b00233f0f3238bmr744845pjr.1.1677832036178;
        Fri, 03 Mar 2023 00:27:16 -0800 (PST)
X-Google-Smtp-Source: AK7set+Wr2bZuvSFKz/cAicpQiICTNIQFjRhK/ZFhIw1m4T8ynIQkFj+4HQi9iOfucgCtEhSQ9TwZQ==
X-Received: by 2002:a17:90a:bc08:b0:233:f0f3:238b with SMTP id w8-20020a17090abc0800b00233f0f3238bmr744826pjr.1.1677832035861;
        Fri, 03 Mar 2023 00:27:15 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c21-20020a17090a8d1500b002347475e71fsm1022385pjo.14.2023.03.03.00.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 00:27:15 -0800 (PST)
Message-ID: <de02c88a-e948-5a88-a873-614d87d23041@redhat.com>
Date: Fri, 3 Mar 2023 16:27:07 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 01/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-2-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-2-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ricardo,

On 3/2/23 05:09, Ricardo Koller wrote:
> Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
> KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
> perform break-before-make (BBM) nor cache maintenance operations
> (CMO). This will by a future commit to create unlinked tables not
> accessible to the HW page-table walker.  This is safe as these removed
/s/removed/unlinked

And how about switch the sequence of the Patch 1 and 2, I think first 
Rename the removed to unlinked, and then use the unlinked make more sense.
> tables are not visible to the HW page-table walker.
> 

But anyway, this patch LGTM.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

Thanks,
Shaoqin
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
>   2 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 63f81b27a4e3..252b651f743d 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -188,12 +188,20 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>    *					children.
>    * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
>    *					with other software walkers.
> + * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
> + *					without Break-before-make
> + *					requirements.
> + * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> + *					without Cache maintenance
> + *					operations required.
>    */
>   enum kvm_pgtable_walk_flags {
>   	KVM_PGTABLE_WALK_LEAF			= BIT(0),
>   	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
>   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
>   	KVM_PGTABLE_WALK_SHARED			= BIT(3),
> +	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(4),
> +	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(5),
>   };
>   
>   struct kvm_pgtable_visit_ctx {
> @@ -215,6 +223,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
>   	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
>   }
>   
> +static inline bool kvm_pgtable_walk_skip_bbm(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM;
> +}
> +
> +static inline bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO;
> +}
> +
>   /**
>    * struct kvm_pgtable_walker - Hook into a page-table walk.
>    * @cb:		Callback function to invoke during the walk.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11cf2c618a6..e093e222daf3 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -717,14 +717,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>   	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
>   		return false;
>   
> -	/*
> -	 * Perform the appropriate TLB invalidation based on the evicted pte
> -	 * value (if any).
> -	 */
> -	if (kvm_pte_table(ctx->old, ctx->level))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> -	else if (kvm_pte_valid(ctx->old))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +	if (!kvm_pgtable_walk_skip_bbm(ctx)) {
> +		/*
> +		 * Perform the appropriate TLB invalidation based on the
> +		 * evicted pte value (if any).
> +		 */
> +		if (kvm_pte_table(ctx->old, ctx->level))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +		else if (kvm_pte_valid(ctx->old))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +				     ctx->addr, ctx->level);
> +	}
>   
>   	if (stage2_pte_is_counted(ctx->old))
>   		mm_ops->put_page(ctx->ptep);
> @@ -808,11 +811,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>   		return -EAGAIN;
>   
>   	/* Perform CMOs before installation of the guest stage-2 PTE */
> -	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> +	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
> +	    stage2_pte_cacheable(pgt, new))
>   		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> +					       granule);
>   
> -	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> +	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
> +	    stage2_pte_executable(new))
>   		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>   
>   	stage2_make_pte(ctx, new);

-- 
Shaoqin

