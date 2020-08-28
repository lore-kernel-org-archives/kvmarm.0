Return-Path: <SRS0=xBPq=CG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F19C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 15:34:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28D1F20825
	for <kvmarm@archiver.kernel.org>; Fri, 28 Aug 2020 15:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28D1F20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82B054B697;
	Fri, 28 Aug 2020 11:34:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CSXretxuHzfh; Fri, 28 Aug 2020 11:34:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D8674B7BB;
	Fri, 28 Aug 2020 11:34:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46CAF4B697
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 11:34:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2El67mAsJoal for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Aug 2020 11:34:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC484B694
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Aug 2020 11:34:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45B9931B;
 Fri, 28 Aug 2020 08:34:30 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 750213F71F;
 Fri, 28 Aug 2020 08:34:29 -0700 (PDT)
Subject: Re: [PATCH v3 03/21] KVM: arm64: Add support for creating
 kernel-agnostic stage-1 page tables
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-4-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <57e40fa8-f6e3-d442-3bd4-412f04d88a4b@arm.com>
Date: Fri, 28 Aug 2020 16:35:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-4-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>
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

On 8/25/20 10:39 AM, Will Deacon wrote:
> The generic page-table walker is pretty useless as it stands, because it
> doesn't understand enough to allocate anything. Teach it about stage-1
> page-tables, and hook up an API for allocating these for the hypervisor
> at EL2.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  34 +++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 131 +++++++++++++++++++++++++++
>  2 files changed, 165 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 51ccbbb0efae..ec9f98527dcc 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -77,6 +77,40 @@ struct kvm_pgtable_walker {
>  	const enum kvm_pgtable_walk_flags	flags;
>  };
>  
> +/**
> + * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
> + * @pgt:	Uninitialised page-table structure to initialise.
> + * @va_bits:	Maximum virtual address bits.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits);
> +
> +/**
> + * kvm_pgtable_hyp_destroy() - Destroy an unused hypervisor stage-1 page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_hyp_init().
> + *
> + * The page-table is assumed to be unreachable by any hardware walkers prior
> + * to freeing and therefore no TLB invalidation is performed.
> + */
> +void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
> +
> +/**
> + * kvm_pgtable_hyp_map() - Install a mapping in a hypervisor stage-1 page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_hyp_init().
> + * @addr:	Virtual address at which to place the mapping.
> + * @size:	Size of the mapping.
> + * @phys:	Physical address of the memory to map.
> + * @prot:	Permissions and attributes for the mapping.
> + *
> + * If device attributes are not explicitly requested in @prot, then the
> + * mapping will be normal, cacheable.
> + *
> + * Return: 0 on success, negative error code on failure.

From my understanding of the code, when the caller replaces an existing leaf entry
or a table with a different one, KVM will print a warning instead of using
break-before-make (if necessary). It might be worth pointing out that it is
expected from the callers not to do that, because it's not immediately obvious.

> + */
> +int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
> +			enum kvm_pgtable_prot prot);
> +
>  /**
>   * kvm_pgtable_walk() - Walk a page-table.
>   * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 462001bbe028..d75166823ad9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -24,8 +24,18 @@
>  
>  #define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
>  
> +#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
> +#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
> +#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
> +#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
> +
>  #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
>  
> +#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)

I compared the macros to the Arm ARM attribute fields in stage 1 VMSAv8-64 block
and page descriptors, and they match.

I looked at the algorithm below, and for what it's worth it looks alright to me.

Thanks,

Alex

> +
>  struct kvm_pgtable_walk_data {
>  	struct kvm_pgtable		*pgt;
>  	struct kvm_pgtable_walker	*walker;
> @@ -288,3 +298,124 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  
>  	return _kvm_pgtable_walk(&walk_data);
>  }
> +
> +struct hyp_map_data {
> +	u64		phys;
> +	kvm_pte_t	attr;
> +};
> +
> +static int hyp_map_set_prot_attr(enum kvm_pgtable_prot prot,
> +				 struct hyp_map_data *data)
> +{
> +	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
> +	u32 mtype = device ? MT_DEVICE_nGnRE : MT_NORMAL;
> +	kvm_pte_t attr = FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX, mtype);
> +	u32 sh = KVM_PTE_LEAF_ATTR_LO_S1_SH_IS;
> +	u32 ap = (prot & KVM_PGTABLE_PROT_W) ? KVM_PTE_LEAF_ATTR_LO_S1_AP_RW :
> +					       KVM_PTE_LEAF_ATTR_LO_S1_AP_RO;
> +
> +	if (!(prot & KVM_PGTABLE_PROT_R))
> +		return -EINVAL;
> +
> +	if (prot & KVM_PGTABLE_PROT_X) {
> +		if (prot & KVM_PGTABLE_PROT_W)
> +			return -EINVAL;
> +
> +		if (device)
> +			return -EINVAL;
> +	} else {
> +		attr |= KVM_PTE_LEAF_ATTR_HI_S1_XN;
> +	}
> +
> +	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
> +	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
> +	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
> +	data->attr = attr;
> +	return 0;
> +}
> +
> +static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> +				    kvm_pte_t *ptep, struct hyp_map_data *data)
> +{
> +	u64 granule = kvm_granule_size(level), phys = data->phys;
> +
> +	if (!kvm_block_mapping_supported(addr, end, phys, level))
> +		return false;
> +
> +	WARN_ON(!kvm_set_valid_leaf_pte(ptep, phys, data->attr, level));
> +	data->phys += granule;
> +	return true;
> +}
> +
> +static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +			  enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	kvm_pte_t *childp;
> +
> +	if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
> +		return 0;
> +
> +	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
> +		return -EINVAL;
> +
> +	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
> +	if (!childp)
> +		return -ENOMEM;
> +
> +	kvm_set_table_pte(ptep, childp);
> +	return 0;
> +}
> +
> +int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
> +			enum kvm_pgtable_prot prot)
> +{
> +	int ret;
> +	struct hyp_map_data map_data = {
> +		.phys	= ALIGN_DOWN(phys, PAGE_SIZE),
> +	};
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= hyp_map_walker,
> +		.flags	= KVM_PGTABLE_WALK_LEAF,
> +		.arg	= &map_data,
> +	};
> +
> +	ret = hyp_map_set_prot_attr(prot, &map_data);
> +	if (ret)
> +		return ret;
> +
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	dsb(ishst);
> +	isb();
> +	return ret;
> +}
> +
> +int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
> +{
> +	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
> +	if (!pgt->pgd)
> +		return -ENOMEM;
> +
> +	pgt->ia_bits		= va_bits;
> +	pgt->start_level	= kvm_start_level(va_bits);
> +	pgt->mmu		= NULL;
> +	return 0;
> +}
> +
> +static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +			   enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	free_page((unsigned long)kvm_pte_follow(*ptep));
> +	return 0;
> +}
> +
> +void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
> +{
> +	struct kvm_pgtable_walker walker = {
> +		.cb	= hyp_free_walker,
> +		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
> +	};
> +
> +	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
> +	free_page((unsigned long)pgt->pgd);
> +	pgt->pgd = NULL;
> +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
