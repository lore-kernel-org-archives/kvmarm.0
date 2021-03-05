Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EBFC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 14:39:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B86AA64F34
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 14:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B86AA64F34
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D354B543;
	Fri,  5 Mar 2021 09:39:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CmRfqkwo0SH5; Fri,  5 Mar 2021 09:39:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8A5F4B559;
	Fri,  5 Mar 2021 09:39:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 542734B532
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 09:39:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I4M2zC4UHc8M for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 09:39:49 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EDDFC4B234
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 09:39:48 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4222B64F48;
 Fri,  5 Mar 2021 14:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614955187;
 bh=VaLrtV+MHU4qWVPa/LzAdaTtbUGASh0bgmLZUIbg9Io=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=RUA6MS8JxyNhI6v8hXtjOkeNTLoys8qlrSFSFYksTa9xdyS3iimTi0+J9ZrhZ0Iq9
 6psCeP+4TzPatiioUvcDUiQWgNcAGhgxmXefpH2HwMl8pxFiwnijw+YHowheSAkh7o
 lE6YRCePljoU4AKvXeDmSRYpJ9l2Gpf/aEntLb1Px/I0bW8GbNRUvkJQRKcw1lYOVn
 TzD2XoKjdcxMaYe0Prh8rnVugeiUHtJiRRD3Ox8AUXbV3IA51PjpXTqD5G36LnB+Tu
 BqUFvF3tVHaG6aZYSaYXEm6/EYJkF5cff2mxpAfCVLtUhgEaYSWiF2jJvNm0x/Hmre
 VFS8kuTA3xLtw==
Date: Fri, 5 Mar 2021 14:39:42 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 28/32] KVM: arm64: Add kvm_pgtable_stage2_idmap_greedy()
Message-ID: <20210305143941.GA23017@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-29-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-29-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:58PM +0000, Quentin Perret wrote:
> Add a new map function to the KVM page-table library that allows to
> greedily create block identity-mappings. This will be useful to create
> lazily the host stage 2 page-table as it will own most of memory and
> will always be identity mapped.
> 
> The new helper function creates the mapping in 2 steps: it first walks
> the page-table to compute the largest possible granule that can be used
> to idmap a given address without overriding existing incompatible
> mappings; and then creates a mapping accordingly.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  37 +++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 119 +++++++++++++++++++++++++++
>  2 files changed, 156 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index c9f6ed76e0ad..e51dcce69a5e 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -96,6 +96,16 @@ enum kvm_pgtable_prot {
>  #define PAGE_HYP_RO		(KVM_PGTABLE_PROT_R)
>  #define PAGE_HYP_DEVICE		(PAGE_HYP | KVM_PGTABLE_PROT_DEVICE)
>  
> +/**
> + * struct kvm_mem_range - Range of Intermediate Physical Addresses
> + * @start:	Start of the range.
> + * @end:	End of the range.
> + */
> +struct kvm_mem_range {
> +	u64 start;
> +	u64 end;
> +};
> +
>  /**
>   * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
>   * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
> @@ -379,4 +389,31 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		     struct kvm_pgtable_walker *walker);
>  
> +/**
> + * kvm_pgtable_stage2_idmap_greedy() - Identity-map an Intermediate Physical
> + *				       Address with a leaf entry at the highest
> + *				       possible level.

Not sure it's worth mentioning "highest possible level" here, as
realistically the caller still has to provide a memcache to deal with the
worst case and the structure of the page-table shouldn't matter.

> + * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> + * @addr:	Input address to identity-map.
> + * @prot:	Permissions and attributes for the mapping.
> + * @range:	Boundaries of the maximum memory region to map.
> + * @mc:		Cache of pre-allocated memory from which to allocate page-table
> + *		pages.
> + *
> + * This function attempts to install high-level identity-mappings covering @addr

"high-level"? (again, I think I'd just drop this)

> + * without overriding existing mappings with incompatible permissions or
> + * attributes. An existing table entry may be coalesced into a block mapping
> + * if and only if it covers @addr and all its leafs are either invalid and/or

s/leafs/leaf entries/

> + * have permissions and attributes strictly matching @prot. The mapping is
> + * guaranteed to be contained within the boundaries specified by @range at call
> + * time. If only a subset of the memory specified by @range is mapped (because
> + * of e.g. alignment issues or existing incompatible mappings), @range will be
> + * updated accordingly.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_idmap_greedy(struct kvm_pgtable *pgt, u64 addr,
> +				    enum kvm_pgtable_prot prot,
> +				    struct kvm_mem_range *range,
> +				    void *mc);
>  #endif	/* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 8aa01a9e2603..6897d771e2b2 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -987,3 +987,122 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
>  	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
>  	pgt->pgd = NULL;
>  }
> +
> +struct stage2_reduce_range_data {
> +	kvm_pte_t attr;
> +	u64 target_addr;
> +	u32 start_level;
> +	struct kvm_mem_range *range;
> +};
> +
> +static int __stage2_reduce_range(struct stage2_reduce_range_data *data, u64 addr)
> +{
> +	u32 level = data->start_level;
> +
> +	for (; level < KVM_PGTABLE_MAX_LEVELS; level++) {
> +		u64 granule = kvm_granule_size(level);
> +		u64 start = ALIGN_DOWN(data->target_addr, granule);
> +		u64 end = start + granule;
> +
> +		/*
> +		 * The pinned address is in the current range, try one level
> +		 * deeper.
> +		 */
> +		if (start == ALIGN_DOWN(addr, granule))
> +			continue;
> +
> +		/*
> +		 * Make sure the current range is a reduction of the existing
> +		 * range before updating it.
> +		 */
> +		if (data->range->start <= start && end <= data->range->end) {
> +			data->start_level = level;
> +			data->range->start = start;
> +			data->range->end = end;
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +#define KVM_PTE_LEAF_S2_COMPAT_MASK	(KVM_PTE_LEAF_ATTR_S2_PERMS | \
> +					 KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR | \
> +					 KVM_PTE_LEAF_SW_BIT_PROT_NONE)
> +
> +static int stage2_reduce_range_walker(u64 addr, u64 end, u32 level,
> +				      kvm_pte_t *ptep,
> +				      enum kvm_pgtable_walk_flags flag,
> +				      void * const arg)
> +{
> +	struct stage2_reduce_range_data *data = arg;
> +	kvm_pte_t attr;
> +	int ret;
> +
> +	if (addr < data->range->start || addr >= data->range->end)
> +		return 0;
> +
> +	attr = *ptep & KVM_PTE_LEAF_S2_COMPAT_MASK;
> +	if (!attr || attr == data->attr)
> +		return 0;
> +
> +	/*
> +	 * An existing mapping with incompatible protection attributes is
> +	 * 'pinned', so reduce the range if we hit one.
> +	 */
> +	ret = __stage2_reduce_range(data, addr);
> +	if (ret)
> +		return ret;
> +
> +	return -EAGAIN;
> +}
> +
> +static int stage2_reduce_range(struct kvm_pgtable *pgt, u64 addr,
> +			       enum kvm_pgtable_prot prot,
> +			       struct kvm_mem_range *range)
> +{
> +	struct stage2_reduce_range_data data = {
> +		.start_level	= pgt->start_level,
> +		.range		= range,
> +		.target_addr	= addr,
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb		= stage2_reduce_range_walker,
> +		.flags		= KVM_PGTABLE_WALK_LEAF,
> +		.arg		= &data,
> +	};
> +	int ret;
> +
> +	data.attr = stage2_get_prot_attr(prot) & KVM_PTE_LEAF_S2_COMPAT_MASK;
> +	if (!data.attr)
> +		return -EINVAL;

(this will need updating based on the other discussion we had)

> +	/* Reduce the kvm_mem_range to a granule size */
> +	ret = __stage2_reduce_range(&data, range->end);
> +	if (ret)
> +		return ret;
> +
> +	/* Walk the range to check permissions and reduce further if needed */
> +	do {
> +		ret = kvm_pgtable_walk(pgt, range->start, range->end, &walker);

(we spent some time debugging an issue here and you spotted that you're
passing range->end instead of the size ;)

> +	} while (ret == -EAGAIN);

I'm a bit nervous about this loop -- what guarantees forward progress here?
Can we return to the host after a few tries instead?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
