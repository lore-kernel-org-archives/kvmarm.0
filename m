Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63900C433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 15:29:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD87022450
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 15:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD87022450
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213CE4B2C1;
	Tue,  8 Sep 2020 11:29:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A5qjXwKU4DPy; Tue,  8 Sep 2020 11:29:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6EAE4B21A;
	Tue,  8 Sep 2020 11:29:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C6B4B209
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 11:29:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4U0EZGO6rRl3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 11:29:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B0014B1FF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 11:29:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9305F169C;
 Tue,  8 Sep 2020 08:29:16 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5647D3F73C;
 Tue,  8 Sep 2020 08:29:15 -0700 (PDT)
Subject: Re: [PATCH v4 10/21] KVM: arm64: Add support for stage-2 page-aging
 in generic page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-11-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <080cd3d9-4979-1d72-0c5a-188334b5a26a@arm.com>
Date: Tue, 8 Sep 2020 16:30:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907152344.12978-11-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

The patch looks good to me, I have a question below.

On 9/7/20 4:23 PM, Will Deacon wrote:
> Add stage-2 mkyoung(), mkold() and is_young() operations to the generic
> page-table code.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 38 ++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 86 ++++++++++++++++++++++++++++
>  2 files changed, 124 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 7258966d3daa..01cad6bbc81b 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -175,6 +175,44 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   */
>  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  
> +/**
> + * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + *
> + * If there is a valid, leaf page-table entry used to translate @addr, then
> + * set the access flag in that entry.
> + *
> + * Return: The old page-table entry prior to setting the flag, 0 on failure.
> + */
> +kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
> +
> +/**
> + * kvm_pgtable_stage2_mkold() - Clear the access flag in a page-table entry.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + *
> + * If there is a valid, leaf page-table entry used to translate @addr, then
> + * clear the access flag in that entry.
> + *
> + * Note that it is the caller's responsibility to invalidate the TLB after
> + * calling this function to ensure that the updated permissions are visible
> + * to the CPUs.
> + *
> + * Return: The old page-table entry prior to clearing the flag, 0 on failure.
> + */
> +kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr);
> +
> +/**
> + * kvm_pgtable_stage2_is_young() - Test whether a page-table entry has the
> + *				   access flag set.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address to identify the page-table entry.
> + *
> + * Return: True if the page-table entry has the access flag set, false otherwise.
> + */
> +bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 4623380cf9de..87ff56d8bcb5 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -690,6 +690,92 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>  
> +struct stage2_attr_data {
> +	kvm_pte_t	attr_set;
> +	kvm_pte_t	attr_clr;
> +	kvm_pte_t	pte;
> +};
> +
> +static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +			      enum kvm_pgtable_walk_flags flag,
> +			      void * const arg)
> +{
> +	kvm_pte_t pte = *ptep;
> +	struct stage2_attr_data *data = arg;
> +
> +	if (!kvm_pte_valid(pte))
> +		return 0;
> +
> +	data->pte = pte;
> +	pte &= ~data->attr_clr;
> +	pte |= data->attr_set;
> +
> +	/*
> +	 * We may race with the CPU trying to set the access flag here,
> +	 * but worst-case the access flag update gets lost and will be
> +	 * set on the next access instead.
> +	 */
> +	if (data->pte != pte)
> +		WRITE_ONCE(*ptep, pte);
> +
> +	return 0;
> +}
> +
> +static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
> +				    u64 size, kvm_pte_t attr_set,
> +				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte)
> +{
> +	int ret;
> +	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
> +	struct stage2_attr_data data = {
> +		.attr_set	= attr_set & attr_mask,
> +		.attr_clr	= attr_clr & attr_mask,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_attr_walker,
> +		.arg		= &data,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +	};
> +
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (ret)
> +		return ret;
> +
> +	if (orig_pte)
> +		*orig_pte = data.pte;
> +	return 0;
> +}
> +
> +kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	kvm_pte_t pte = 0;
> +	stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
> +				 &pte);
> +	dsb(ishst);

I am curious about the DSB above. We don't do it when we clear the AF bit, because
in the clear_flush_young() mmu notifier, kvm_age_hva() is followed by
kvm_flush_remote_tlbs() -> kvm_flush_remote_tlbs(), which does a DSB ISHST.

When AF is zero, the entry is not allowed to be stored in a TLB, and that's why we
don't need to issue a TLBI instruction. Do we do the DSB here to make sure all PEs
in the inner shareability domain see the updated translation tables? Or there's
another reason I'm not seeing?

Thanks,
Alex
> +	return pte;
> +}
> +
> +kvm_pte_t kvm_pgtable_stage2_mkold(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	kvm_pte_t pte = 0;
> +	stage2_update_leaf_attrs(pgt, addr, 1, 0, KVM_PTE_LEAF_ATTR_LO_S2_AF,
> +				 &pte);
> +	/*
> +	 * "But where's the TLBI?!", you scream.
> +	 * "Over in the core code", I sigh.
> +	 *
> +	 * See the '->clear_flush_young()' callback on the KVM mmu notifier.
> +	 */
> +	return pte;
> +}
> +
> +bool kvm_pgtable_stage2_is_young(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	kvm_pte_t pte = 0;
> +	stage2_update_leaf_attrs(pgt, addr, 1, 0, 0, &pte);
> +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +}
> +
>  int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm)
>  {
>  	size_t pgd_sz;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
