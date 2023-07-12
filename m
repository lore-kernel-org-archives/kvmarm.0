Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631171F959
	for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 12:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689163287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M50K9pHZDJbPCSbFBAjVuTHYjYYq1J4ree9VestSKoQ=;
	b=S/8GqSH/sOXhPA+unLRcXOey22JdBl+ZZaTzmtHKY7abSFeBdpMtDjKCx5gkpV5zOGK+Xa
	84F9zjk3hVesuMgm19pNJyncP9moj6IBmTOL2K49RlUl/cLxUsNpSTyUfcr8zCSvlETNKy
	YSMXujJ5nkG3Lsj+lTwX8JSkGdUajpo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-QvUmVuMSOZyMyGFB8prIKQ-1; Wed, 12 Jul 2023 08:01:25 -0400
X-MC-Unique: QvUmVuMSOZyMyGFB8prIKQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-767edbf73cbso13529785a.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Jul 2023 05:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689163284; x=1689768084;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M50K9pHZDJbPCSbFBAjVuTHYjYYq1J4ree9VestSKoQ=;
        b=KG5lIVqrsFdd2+F2iMuvBsOAi/+lxcrvU0e1k6p3PTDlD9k7Ey2fu7Ybwmg2nSQcTN
         4SIihFenOvE/BLnnFfT7oNXRpP6cfr4XOOZS2esKWFfQr9XPI+PiTm/VTNC9GOz5JOMK
         T5TBc2IIq51xAdzf3QIi7zUvRii2XyZFY/BnNN1phEjHemu4s37KqWEEAirGiCw1KcZo
         UT/f0pCGJ7c2VVhQCsyXisnvstBxbH99z6pE7FDaC97M/mFBr6a7vj5N6yJsvy90Wjpr
         YeosQ1d/qwAJEVJ76Di7nksxdws2ejMOq9c1pwXih9WD6+cUuwdpdFG4Ib3MaL1nhhqF
         WYVg==
X-Gm-Message-State: ABy/qLbPRa83KohGrxdo2KVhMLrlGiXn+3UU+GuiwSUFX+BBOU/aZeBQ
	YTUh7BuMfUPGbnxa/gA+4E6yPqV0epoBYxNk+PwhqXQCcyPWmEiQ7hCKSmt/wKcVxxkemNrXR/x
	LZ4J5s2ck1xid+wdW
X-Received: by 2002:a05:620a:4516:b0:765:435c:a4fa with SMTP id t22-20020a05620a451600b00765435ca4famr20075434qkp.0.1689163283705;
        Wed, 12 Jul 2023 05:01:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFrmOiSLvKoZMbc2ZYZOP/uHSGo5Z6b/QRPJPNxULdpDoUhJDrm9WxMNDbJm2moFqQgqr2oQw==
X-Received: by 2002:a05:620a:4516:b0:765:435c:a4fa with SMTP id t22-20020a05620a451600b00765435ca4famr20075410qkp.0.1689163283395;
        Wed, 12 Jul 2023 05:01:23 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m13-20020a05622a118d00b00403b1fb1f48sm2188092qtk.17.2023.07.12.05.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 05:01:23 -0700 (PDT)
Message-ID: <df0eb9d8-9166-ab26-aa1b-0f5243cba715@redhat.com>
Date: Wed, 12 Jul 2023 20:01:18 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] KVM: arm64: Correctly handle page aging notifiers for
 unaligned memslot
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Reiji Watanabe <reijiw@google.com>,
 stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>
References: <20230627235405.4069823-1-oliver.upton@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230627235405.4069823-1-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 6/28/23 07:54, Oliver Upton wrote:
> Userspace is allowed to select any PAGE_SIZE aligned hva to back guest
> memory. This is even the case with hugepages, although it is a rather
> suboptimal configuration as PTE level mappings are used at stage-2.
> 
> The arm64 page aging handlers have an assumption that the specified
> range is exactly one page/block of memory, which in the aforementioned
> case is not necessarily true. All together this leads to the WARN() in
> kvm_age_gfn() firing.
Is there any easy way to reproduce the WARN() in the kvm_age_gfn()?
> 
> However, the WARN is only part of the issue as the table walkers visit
> at most a single leaf PTE. For hugepage-backed memory in a memslot that
> isn't hugepage-aligned, page aging entirely misses accesses to the
> hugepage beyond the first page in the memslot.
> 
> Add a new walker dedicated to handling page aging MMU notifiers capable
> of walking a range of PTEs. Convert kvm(_test)_age_gfn() over to the new
> walker and drop the WARN that caught the issue in the first place. The
> implementation of this walker was inspired by the test_clear_young()
> implementation by Yu Zhao [*], but repurposed to address a bug in the
> existing aging implementation.
> 
> Cc: stable@vger.kernel.org # v5.15
> Fixes: 056aad67f836 ("kvm: arm/arm64: Rework gpa callback handlers")
> Link: https://lore.kernel.org/kvmarm/20230526234435.662652-6-yuzhao@google.com/
> Co-developed-by: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 26 ++++++------------
>   arch/arm64/kvm/hyp/pgtable.c         | 41 ++++++++++++++++++++++------
>   arch/arm64/kvm/mmu.c                 | 18 ++++++------
>   3 files changed, 49 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dc3c072e862f..75f437e8cd15 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -556,22 +556,26 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
>   kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
>   
>   /**
> - * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
> + * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
> + *					   flag in a page-table entry.With this change, the description should change to:

s/a page-table entry/multiple page-table entries.

Others looks good to me.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
>    * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
>    * @addr:	Intermediate physical address to identify the page-table entry.
> + * @size:	Size of the address range to visit.
> + * @mkold:	True if the access flag should be cleared.
>    *
>    * The offset of @addr within a page is ignored.
>    *
> - * If there is a valid, leaf page-table entry used to translate @addr, then
> - * clear the access flag in that entry.
> + * Tests and conditionally clears the access flag for every valid, leaf
> + * page-table entry used to translate the range [@addr, @addr + @size).
>    *
>    * Note that it is the caller's responsibility to invalidate the TLB after
>    * calling this function to ensure that the updated permissions are visible
>    * to the CPUs.
>    *
> - * Return: The old page-table entry prior to clearing the flag, 0 on failure.
> + * Return: True if any of the visited PTEs had the access flag set.
>    */
> -kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
> +bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
> +					 u64 size, bool mkold);
>   
>   /**
>    * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
> @@ -593,18 +597,6 @@ kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
>   int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>   				   enum kvm_pgtable_prot prot);
>   
> -/**
> - * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
> - *				   access flag set.
> - * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
> - * @addr:	Intermediate physical address to identify the page-table entry.
> - *
> - * The offset of @addr within a page is ignored.
> - *
> - * Return: True if the page-table entry has the access flag set, false otherwise.
> - */
> -bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> -
>   /**
>    * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
>    * 				      of Coherency for guest stage-2 address
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5282cb9ca4cf..5d701e9adf5c 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1153,25 +1153,48 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
>   	return pte;
>   }
>   
> -kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> +struct stage2_age_data {
> +	bool	mkold;
> +	bool	young;
> +};
> +
> +static int stage2_age_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +			     enum kvm_pgtable_walk_flags visit)
>   {
> -	kvm_pte_t pte = 0;
> -	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
> -				 &pte, NULL, 0);
> +	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +	struct stage2_age_data *data = ctx->arg;
> +
> +	if (!kvm_pte_valid(ctx->old) || new == ctx->old)
> +		return 0;
> +
> +	data->young = true;
> +
> +	if (data->mkold && !stage2_try_set_pte(ctx, new))
> +		return -EAGAIN;
> +
>   	/*
>   	 * "But where's the TLBI?!", you scream.
>   	 * "Over in the core code", I sigh.
>   	 *
>   	 * See the '->clear_flush_young()' callback on the KVM mmu notifier.
>   	 */
> -	return pte;
> +	return 0;
>   }
>   
> -bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> +bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
> +					 u64 size, bool mkold)
>   {
> -	kvm_pte_t pte = 0;
> -	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte, NULL, 0);
> -	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +	struct stage2_age_data data = {
> +		.mkold		= mkold,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_age_walker,
> +		.arg		= &data,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
> +	return data.young;
>   }
>   
>   int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 3b9d4d24c361..8a7e9381710e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1639,27 +1639,25 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
>   	u64 size = (range->end - range->start) << PAGE_SHIFT;
> -	kvm_pte_t kpte;
> -	pte_t pte;
>   
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> -
> -	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt,
> -					range->start << PAGE_SHIFT);
> -	pte = __pte(kpte);
> -	return pte_valid(pte) && pte_young(pte);
> +	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
> +						   range->start << PAGE_SHIFT,
> +						   size, true);
>   }
>   
>   bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> +	u64 size = (range->end - range->start) << PAGE_SHIFT;
> +
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> -	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt,
> -					   range->start << PAGE_SHIFT);
> +	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
> +						   range->start << PAGE_SHIFT,
> +						   size, false);
>   }
>   
>   phys_addr_t kvm_mmu_get_httbr(void)
> 
> base-commit: 44c026a73be8038f03dbdeef028b642880cf1511

-- 
Shaoqin

