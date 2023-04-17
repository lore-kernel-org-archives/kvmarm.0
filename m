Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4952F1848
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 06:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681711850;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KdemsBQQ4DOQKWwtl2Z4p0X5uD/zbkNR6MG+QW9jbGQ=;
	b=c7V8enNBGcYi4qIJX3rzbfhQxxDEFE+CHWL82Kv5C89/0AwIBUOcSp9802282MIgRUBsul
	W8dUKlKMjCAWuJdIO4ZhDRsn3h/MvSzofDKmTKhAp0NvcEHjclfl1NQTUMp2XuGzTflwyI
	5TW28trsJKybJNSrBQBFygJ+6KEKkJY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-dnGF7VnvOhOWdY752v0qLg-1; Mon, 17 Apr 2023 02:10:48 -0400
X-MC-Unique: dnGF7VnvOhOWdY752v0qLg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DE293C0F196;
	Mon, 17 Apr 2023 06:10:47 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55C27492B03;
	Mon, 17 Apr 2023 06:10:20 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com, Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-3-ricarkol@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <af0cae47-d7dd-eacb-c6f5-6392f392756f@redhat.com>
Date: Mon, 17 Apr 2023 14:10:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-3-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
> KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
> perform break-before-make (BBM) nor cache maintenance operations
> (CMO). This will be used by a future commit to create unlinked tables
> not accessible to the HW page-table walker.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 37 +++++++++++++++++++---------
>   2 files changed, 34 insertions(+), 11 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 26a4293726c14..3f2d43ba2b628 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -195,6 +195,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
>    *					with other software walkers.
>    * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
>    *					invoked from a fault handler.
> + * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
> + *					without Break-before-make's
> + *					TLB invalidation.
> + * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
> + *					without Cache maintenance
> + *					operations required.
>    */
>   enum kvm_pgtable_walk_flags {
>   	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> @@ -202,6 +208,8 @@ enum kvm_pgtable_walk_flags {
>   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
>   	KVM_PGTABLE_WALK_SHARED			= BIT(3),
>   	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
> +	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
> +	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
>   };
>   
>   struct kvm_pgtable_visit_ctx {
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index a3246d6cddec7..633679ee3c49a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -62,6 +62,16 @@ struct kvm_pgtable_walk_data {
>   	u64				end;
>   };
>   
> +static bool kvm_pgtable_walk_skip_bbm_tlbi(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM_TLBI);
> +}
> +
> +static bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO);
> +}
> +
>   static bool kvm_phys_is_valid(u64 phys)
>   {
>   	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
> @@ -741,14 +751,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
> +	if (!kvm_pgtable_walk_skip_bbm_tlbi(ctx)) {
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
> @@ -832,11 +845,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
> 

