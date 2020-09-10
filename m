Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C53C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 11:19:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8D9320C09
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 11:19:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8D9320C09
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D905D4B401;
	Thu, 10 Sep 2020 07:19:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VNhuXYysEC+b; Thu, 10 Sep 2020 07:19:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 194A54B3CD;
	Thu, 10 Sep 2020 07:19:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ECB24B3BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 07:19:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 85KRDqWcnHxk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 07:19:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F8804B3B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 07:19:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0E811045;
 Thu, 10 Sep 2020 04:19:42 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5E1C93F68F;
 Thu, 10 Sep 2020 04:19:41 -0700 (PDT)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-7-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f5939f12-56e8-794c-8d9b-9ae348bba3c0@arm.com>
Date: Thu, 10 Sep 2020 12:20:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907152344.12978-7-will@kernel.org>
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

On 9/7/20 4:23 PM, Will Deacon wrote:
> Add stage-2 map() and unmap() operations to the generic page-table code.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  39 ++++
>  arch/arm64/kvm/hyp/pgtable.c         | 273 +++++++++++++++++++++++++++
>  2 files changed, 312 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 85078bb632bb..7258966d3daa 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -136,6 +136,45 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm);
>   */
>  void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
>  
> +/**
> + * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address at which to place the mapping.
> + * @size:	Size of the mapping.
> + * @phys:	Physical address of the memory to map.
> + * @prot:	Permissions and attributes for the mapping.
> + * @mc:		Cache of pre-allocated GFP_PGTABLE_USER memory from which to
> + *		allocate page-table pages.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Note that this function will both coalesce existing table entries and split
> + * existing block mappings, relying on page-faults to fault back areas outside
> + * of the new mapping lazily.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +			   u64 phys, enum kvm_pgtable_prot prot,
> +			   struct kvm_mmu_memory_cache *mc);
> +
> +/**
> + * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address from which to remove the mapping.
> + * @size:	Size of the mapping.
> + *
> + * TLB invalidation is performed for each page-table entry cleared during the
> + * unmapping operation and the reference count for the page-table page
> + * containing the cleared entry is decremented, with unreferenced pages being
> + * freed. Unmapping a cacheable page will ensure that it is clean to the PoC if
> + * FWB is not supported by the CPU.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 96e21017830b..4623380cf9de 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -32,10 +32,19 @@
>  #define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
>  #define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
>  
> +#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
> +#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
> +#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
> +
>  #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
>  
>  #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
>  
> +#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
> +
>  struct kvm_pgtable_walk_data {
>  	struct kvm_pgtable		*pgt;
>  	struct kvm_pgtable_walker	*walker;
> @@ -417,6 +426,270 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
>  	pgt->pgd = NULL;
>  }
>  
> +struct stage2_map_data {
> +	u64				phys;
> +	kvm_pte_t			attr;
> +
> +	kvm_pte_t			*anchor;
> +
> +	struct kvm_s2_mmu		*mmu;
> +	struct kvm_mmu_memory_cache	*memcache;
> +};
> +
> +static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
> +				    struct stage2_map_data *data)
> +{
> +	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> +	kvm_pte_t attr = device ? PAGE_S2_MEMATTR(DEVICE_nGnRE) :
> +			    PAGE_S2_MEMATTR(NORMAL);
> +	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
> +
> +	if (!(prot & KVM_PGTABLE_PROT_X))
> +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
> +	else if (device)
> +		return -EINVAL;
> +
> +	if (prot & KVM_PGTABLE_PROT_R)
> +		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> +
> +	if (prot & KVM_PGTABLE_PROT_W)
> +		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +
> +	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
> +	attr |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
> +	data->attr = attr;
> +	return 0;
> +}
> +
> +static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> +				       kvm_pte_t *ptep,
> +				       struct stage2_map_data *data)
> +{
> +	u64 granule = kvm_granule_size(level), phys = data->phys;
> +
> +	if (!kvm_block_mapping_supported(addr, end, phys, level))
> +		return false;
> +
> +	if (kvm_set_valid_leaf_pte(ptep, phys, data->attr, level))
> +		goto out;
> +
> +	/* There's an existing valid leaf entry, so perform break-before-make */
> +	kvm_set_invalid_pte(ptep);
> +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> +	kvm_set_valid_leaf_pte(ptep, phys, data->attr, level);
> +out:
> +	data->phys += granule;
> +	return true;
> +}
> +
> +static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
> +				     kvm_pte_t *ptep,
> +				     struct stage2_map_data *data)
> +{
> +	if (data->anchor)
> +		return 0;
> +
> +	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
> +		return 0;
> +
> +	kvm_set_invalid_pte(ptep);
> +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, 0);
> +	data->anchor = ptep;
> +	return 0;
> +}
> +
> +static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +				struct stage2_map_data *data)
> +{
> +	kvm_pte_t *childp, pte = *ptep;
> +	struct page *page = virt_to_page(ptep);
> +
> +	if (data->anchor) {
> +		if (kvm_pte_valid(pte))
> +			put_page(page);
> +
> +		return 0;
> +	}
> +
> +	if (stage2_map_walker_try_leaf(addr, end, level, ptep, data))
> +		goto out_get_page;
> +
> +	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
> +		return -EINVAL;
> +
> +	if (!data->memcache)
> +		return -ENOMEM;
> +
> +	childp = kvm_mmu_memory_cache_alloc(data->memcache);
> +	if (!childp)
> +		return -ENOMEM;
> +
> +	/*
> +	 * If we've run into an existing block mapping then replace it with
> +	 * a table. Accesses beyond 'end' that fall within the new table
> +	 * will be mapped lazily.
> +	 */
> +	if (kvm_pte_valid(pte)) {
> +		kvm_set_invalid_pte(ptep);
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> +		put_page(page);
> +	}
> +
> +	kvm_set_table_pte(ptep, childp);
> +
> +out_get_page:
> +	get_page(page);
> +	return 0;
> +}
> +
> +static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
> +				      kvm_pte_t *ptep,
> +				      struct stage2_map_data *data)
> +{
> +	int ret = 0;
> +
> +	if (!data->anchor)
> +		return 0;
> +
> +	free_page((unsigned long)kvm_pte_follow(*ptep));
> +	put_page(virt_to_page(ptep));
> +
> +	if (data->anchor == ptep) {
> +		data->anchor = NULL;
> +		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
> +	}

I had another look at this function. If we're back to the anchor entry, then that
means that we know from the pre-order visitor that 1. the mapping is supported at
this level and 2. that the pte was invalidated. This means that
kvm_set_valid_leaf_pte() will succeed in changing the entry. How about instead of
calling stage2_map_walk_leaf() -> stage2_map_walker_try_leaf() ->
kvm_set_valid_leaf_pte() we call kvm_set_valid_leaf_pte() directly, followed by
get_page(virt_to_page(ptep)? It would make the code a lot easier to follow
(stage2_map_walk_leaf() is pretty complicated, imo, but that can't really be
avoided), and also slightly faster.

> +
> +	return ret;
> +}
> +
> +/*
> + * This is a little fiddly, as we use all three of the walk flags. The idea
> + * is that the TABLE_PRE callback runs for table entries on the way down,
> + * looking for table entries which we could conceivably replace with a
> + * block entry for this mapping. If it finds one, then it sets the 'anchor'
> + * field in 'struct stage2_map_data' to point at the table entry, before
> + * clearing the entry to zero and descending into the now detached table.
> + *
> + * The behaviour of the LEAF callback then depends on whether or not the
> + * anchor has been set. If not, then we're not using a block mapping higher
> + * up the table and we perform the mapping at the existing leaves instead.
> + * If, on the other hand, the anchor _is_ set, then we drop references to
> + * all valid leaves so that the pages beneath the anchor can be freed.
> + *
> + * Finally, the TABLE_POST callback does nothing if the anchor has not
> + * been set, but otherwise frees the page-table pages while walking back up
> + * the page-table, installing the block entry when it revisits the anchor
> + * pointer and clearing the anchor to NULL.
> + */

The comment does wonders at explaining what is going on, thank you.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
