Return-Path: <SRS0=Zq7J=CF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FAAC433DF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Aug 2020 16:26:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1200522B4D
	for <kvmarm@archiver.kernel.org>; Thu, 27 Aug 2020 16:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1200522B4D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F624BFCF;
	Thu, 27 Aug 2020 12:26:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y-D-c82O8zw5; Thu, 27 Aug 2020 12:26:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1BD4BFCB;
	Thu, 27 Aug 2020 12:26:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9001E4BFC2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2020 12:26:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZSYByabWxKz7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Aug 2020 12:26:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F4174BFBC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Aug 2020 12:26:14 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A829431B;
 Thu, 27 Aug 2020 09:26:13 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0CF63F66B;
 Thu, 27 Aug 2020 09:26:12 -0700 (PDT)
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9de812eb-1067-08bf-69cd-eb205dfbda35@arm.com>
Date: Thu, 27 Aug 2020 17:27:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-3-will@kernel.org>
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

It looks to me like the fact that code doesn't take into account the fact that we
can have concatenated pages at the initial level of lookup. Am I missing
something? Is it added in later patches and I missed it? I've commented below in a
few places where I noticed that.

On 8/25/20 10:39 AM, Will Deacon wrote:
> The KVM page-table code is intricately tied into the kernel page-table
> code and re-uses the pte/pmd/pud/p4d/pgd macros directly in an attempt
> to reduce code duplication. Unfortunately, the reality is that there is
> an awful lot of code required to make this work, and at the end of the
> day you're limited to creating page-tables with the same configuration
> as the host kernel. Furthermore, lifting the page-table code to run
> directly at EL2 on a non-VHE system (as we plan to to do in future
> patches) is practically impossible due to the number of dependencies it
> has on the core kernel.
>
> Introduce a framework for walking Armv8 page-tables configured
> independently from the host kernel.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 101 ++++++++++
>  arch/arm64/kvm/hyp/Makefile          |   2 +-
>  arch/arm64/kvm/hyp/pgtable.c         | 290 +++++++++++++++++++++++++++
>  3 files changed, 392 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
>  create mode 100644 arch/arm64/kvm/hyp/pgtable.c
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> new file mode 100644
> index 000000000000..51ccbbb0efae
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 Google LLC
> + * Author: Will Deacon <will@kernel.org>
> + */
> +
> +#ifndef __ARM64_KVM_PGTABLE_H__
> +#define __ARM64_KVM_PGTABLE_H__
> +
> +#include <linux/bits.h>
> +#include <linux/kvm_host.h>
> +#include <linux/types.h>
> +
> +typedef u64 kvm_pte_t;
> +
> +/**
> + * struct kvm_pgtable - KVM page-table.
> + * @ia_bits:		Maximum input address size, in bits.
> + * @start_level:	Level at which the page-table walk starts.
> + * @pgd:		Pointer to the first top-level entry of the page-table.
> + * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
> + */
> +struct kvm_pgtable {
> +	u32					ia_bits;
> +	u32					start_level;
> +	kvm_pte_t				*pgd;
> +
> +	/* Stage-2 only */
> +	struct kvm_s2_mmu			*mmu;
> +};
> +
> +/**
> + * enum kvm_pgtable_prot - Page-table permissions and attributes.
> + * @KVM_PGTABLE_PROT_R:		Read permission.
> + * @KVM_PGTABLE_PROT_W:		Write permission.
> + * @KVM_PGTABLE_PROT_X:		Execute permission.
> + * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
> + */
> +enum kvm_pgtable_prot {
> +	KVM_PGTABLE_PROT_R			= BIT(0),
> +	KVM_PGTABLE_PROT_W			= BIT(1),
> +	KVM_PGTABLE_PROT_X			= BIT(2),
> +
> +	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
> +};
> +
> +/**
> + * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
> + * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
> + *					entries.
> + * @KVM_PGTABLE_WALK_TABLE_PRE:		Visit table entries before their
> + *					children.
> + * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
> + *					children.
> + */
> +enum kvm_pgtable_walk_flags {
> +	KVM_PGTABLE_WALK_LEAF			= BIT(0),
> +	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
> +	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> +};
> +
> +typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
> +					kvm_pte_t *ptep,
> +					enum kvm_pgtable_walk_flags flag,
> +					void * const arg);
> +
> +/**
> + * struct kvm_pgtable_walker - Hook into a page-table walk.
> + * @cb:		Callback function to invoke during the walk.
> + * @arg:	Argument passed to the callback function.
> + * @flags:	Bitwise-OR of flags to identify the entry types on which to
> + *		invoke the callback function.
> + */
> +struct kvm_pgtable_walker {
> +	const kvm_pgtable_visitor_fn_t		cb;
> +	void * const				arg;
> +	const enum kvm_pgtable_walk_flags	flags;
> +};
> +
> +/**
> + * kvm_pgtable_walk() - Walk a page-table.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
> + * @addr:	Input address for the start of the walk.
> + * @size:	Size of the range to walk.
> + * @walker:	Walker callback description.
> + *
> + * The walker will walk the page-table entries corresponding to the input
> + * address range specified, visiting entries according to the walker flags.
> + * Invalid entries are treated as leaf entries. Leaf entries are reloaded
> + * after invoking the walker callback, allowing the walker to descend into
> + * a newly installed table.
> + *
> + * Returning a negative error code from the walker callback function will
> + * terminate the walk immediately with the same error code.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +		     struct kvm_pgtable_walker *walker);
> +
> +#endif	/* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index f54f0e89a71c..607b8a898826 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -10,5 +10,5 @@ subdir-ccflags-y := -I$(incdir)				\
>  		    -DDISABLE_BRANCH_PROFILING		\
>  		    $(DISABLE_STACKLEAK_PLUGIN)
>  
> -obj-$(CONFIG_KVM) += vhe/ nvhe/
> +obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
>  obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> new file mode 100644
> index 000000000000..462001bbe028
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -0,0 +1,290 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Stand-alone page-table allocator for hyp stage-1 and guest stage-2.
> + * No bombay mix was harmed in the writing of this file.
> + *
> + * Copyright (C) 2020 Google LLC
> + * Author: Will Deacon <will@kernel.org>
> + */
> +
> +#include <linux/bitfield.h>
> +#include <asm/kvm_pgtable.h>
> +
> +#define KVM_PGTABLE_MAX_LEVELS		4U
> +
> +#define KVM_PTE_VALID			BIT(0)
> +
> +#define KVM_PTE_TYPE			BIT(1)
> +#define KVM_PTE_TYPE_BLOCK		0
> +#define KVM_PTE_TYPE_PAGE		1
> +#define KVM_PTE_TYPE_TABLE		1
> +
> +#define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
> +#define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
> +
> +#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
> +
> +#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
> +
> +struct kvm_pgtable_walk_data {
> +	struct kvm_pgtable		*pgt;
> +	struct kvm_pgtable_walker	*walker;
> +
> +	u64				addr;
> +	u64				end;
> +};
> +
> +static u64 kvm_granule_shift(u32 level)
> +{
> +	return (KVM_PGTABLE_MAX_LEVELS - level) * (PAGE_SHIFT - 3) + 3;

Isn't that the same same thing as the macro ARM64_HW_PGTABLE_LEVEL_SHIFT(n) from
pgtable-hwdef.h? I think the header is already included, as this file uses
PTRS_PER_PTE and that's the only place I found it defined.

> +}
> +
> +static u64 kvm_granule_size(u32 level)
> +{
> +	return BIT(kvm_granule_shift(level));
> +}
> +
> +static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
> +{
> +	u64 granule = kvm_granule_size(level);
> +
> +	/*
> +	 * Reject invalid block mappings and don't bother with 4TB mappings for
> +	 * 52-bit PAs.
> +	 */
> +	if (level == 0 || (PAGE_SIZE != SZ_4K && level == 1))
> +		return false;
> +
> +	if (granule > (end - addr))
> +		return false;
> +
> +	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
> +}

This is a very nice rewrite of fault_supports_stage2_huge_mapping, definitely
easier to understand.

> +
> +static u32 kvm_start_level(u64 ia_bits)
> +{
> +	u64 levels = DIV_ROUND_UP(ia_bits - PAGE_SHIFT, PAGE_SHIFT - 3);

Isn't that the same same thing as the macro ARM64_HW_PGTABLE_LEVELS from
pgtable-hwdef.h?

> +	return KVM_PGTABLE_MAX_LEVELS - levels;

I tried to verify this formula and I think there's something that I don't
understand or I'm missing. For the default KVM setup, where the user doesn't
specify an IPA size different from the 40 bits default: ia_bits = 40 (IPA =
[39:0]), 4KB pages, translation starting at level 1 with 2 concatenated level 1
tables (VTCR_EL2.T0SZ = 24, VTCR_EL2.SL0 = 1, VTCR_EL2.TG0 = 0, starting level
from table D5-13 at page D5-2566, ARM DDI 0487F.b), according to the formula I get:

levels = DIV_ROUND_UP(40 - 12, 12 -3) = DIV_ROUND_UP(28, 9) = 4
return 4 - 4 = 0

which means the resulting starting level is 0 instead of 1.

> +}
> +
> +static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
> +{
> +	u64 shift = kvm_granule_shift(level);
> +	u64 mask = BIT(PAGE_SHIFT - 3) - 1;

This doesn't seem to take into account the fact that we can have concatenated
initial page tables.

> +
> +	return (data->addr >> shift) & mask;
> +}
> +
> +static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +{
> +	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
> +	u64 mask = BIT(pgt->ia_bits) - 1;
> +
> +	return (addr & mask) >> shift;
> +}
> +
> +static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
> +{
> +	return __kvm_pgd_page_idx(data->pgt, data->addr);
> +}
> +
> +static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
> +{
> +	struct kvm_pgtable pgt = {
> +		.ia_bits	= ia_bits,
> +		.start_level	= start_level,
> +	};
> +
> +	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +}
> +
> +static bool kvm_pte_valid(kvm_pte_t pte)
> +{
> +	return pte & KVM_PTE_VALID;
> +}
> +
> +static bool kvm_pte_table(kvm_pte_t pte, u32 level)
> +{
> +	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
> +		return false;
> +
> +	if (!kvm_pte_valid(pte))
> +		return false;
> +
> +	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
> +}
> +
> +static u64 kvm_pte_to_phys(kvm_pte_t pte)
> +{
> +	u64 pa = pte & KVM_PTE_ADDR_MASK;
> +
> +	if (PAGE_SHIFT == 16)
> +		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
> +
> +	return pa;
> +}
> +
> +static kvm_pte_t kvm_phys_to_pte(u64 pa)
> +{
> +	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
> +
> +	if (PAGE_SHIFT == 16)
> +		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
> +
> +	return pte;
> +}
> +
> +static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte)
> +{
> +	return __va(kvm_pte_to_phys(pte));
> +}
> +
> +static void kvm_set_invalid_pte(kvm_pte_t *ptep)
> +{
> +	kvm_pte_t pte = 0;
> +	WRITE_ONCE(*ptep, pte);
> +}
> +
> +static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
> +{
> +	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(__pa(childp));
> +
> +	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
> +	pte |= KVM_PTE_VALID;
> +
> +	WARN_ON(kvm_pte_valid(old));
> +	smp_store_release(ptep, pte);
> +}
> +
> +static bool kvm_set_valid_leaf_pte(kvm_pte_t *ptep, u64 pa, kvm_pte_t attr,
> +				   u32 level)
> +{
> +	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(pa);
> +	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
> +							   KVM_PTE_TYPE_BLOCK;
> +
> +	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
> +	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
> +	pte |= KVM_PTE_VALID;
> +
> +	/* Tolerate KVM recreating the exact same mapping. */
> +	if (kvm_pte_valid(old))
> +		return old == pte;
> +
> +	smp_store_release(ptep, pte);
> +	return true;
> +}
> +
> +static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
> +				  u32 level, kvm_pte_t *ptep,
> +				  enum kvm_pgtable_walk_flags flag)
> +{
> +	struct kvm_pgtable_walker *walker = data->walker;
> +	return walker->cb(addr, data->end, level, ptep, flag, walker->arg);
> +}
> +
> +static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> +			      kvm_pte_t *pgtable, u32 level);
> +
> +static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> +				      kvm_pte_t *ptep, u32 level)
> +{
> +	int ret = 0;
> +	u64 addr = data->addr;
> +	kvm_pte_t *childp, pte = *ptep;
> +	bool table = kvm_pte_table(pte, level);
> +	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> +
> +	if (table && (flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
> +		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> +					     KVM_PGTABLE_WALK_TABLE_PRE);

I see that below we check if the visitor modified the leaf entry and turned into a
table. Is it not allowed for a visitor to turn a table into a block mapping?

> +	}
> +
> +	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
> +		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> +					     KVM_PGTABLE_WALK_LEAF);
> +		pte = *ptep;
> +		table = kvm_pte_table(pte, level);
> +	}
> +
> +	if (ret)
> +		goto out;
> +
> +	if (!table) {
> +		data->addr += kvm_granule_size(level);
> +		goto out;
> +	}
> +
> +	childp = kvm_pte_follow(pte);
> +	ret = __kvm_pgtable_walk(data, childp, level + 1);
> +	if (ret)
> +		goto out;
> +
> +	if (flags & KVM_PGTABLE_WALK_TABLE_POST) {

We check that ptep is a valid table when we test the KVM_PGTABLE_WALK_TABLE_PRE
flag, why aren't we doing that here?

> +		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> +					     KVM_PGTABLE_WALK_TABLE_POST);
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
> +			      kvm_pte_t *pgtable, u32 level)
> +{
> +	u32 idx;
> +	int ret = 0;
> +
> +	if (WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS))
> +		return -EINVAL;
> +
> +	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
> +		kvm_pte_t *ptep = &pgtable[idx];
> +
> +		if (data->addr >= data->end)
> +			break;
> +
> +		ret = __kvm_pgtable_visit(data, ptep, level);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> +{
> +	u32 idx;
> +	int ret = 0;
> +	struct kvm_pgtable *pgt = data->pgt;
> +	u64 limit = BIT(pgt->ia_bits);
> +
> +	if (data->addr > limit || data->end > limit)
> +		return -ERANGE;
> +
> +	if (!pgt->pgd)
> +		return -EINVAL;
> +
> +	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> +		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];

I'm sorry, but I just don't understand this part:

- Why do we skip over PTRS_PER_PTE instead of visiting each idx?

- Why do we use PTRS_PER_PTE instead of PTRS_PER_PGD?

Would you mind explaining what the loop is doing?

I also don't see anywhere in the page table walking code where we take into
account that we can have concatenated tables at level 1 or 2, which means we have
more entries than PTRS_PER_P{U,M}D.

> +
> +		ret = __kvm_pgtable_walk(data, ptep, pgt->start_level);
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
> +		     struct kvm_pgtable_walker *walker)
> +{
> +	struct kvm_pgtable_walk_data walk_data = {
> +		.pgt	= pgt,
> +		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
> +		.end	= PAGE_ALIGN(walk_data.addr + size),

Shouldn't that be .end = PAGE_ALIGN(addr + size)? For example, for addr = 2 *
PAGE_SIZE -1 and size = PAGE_SIZE, PAGE_ALIGN(addr + size) = 3 * PAGE_SIZE, but
PAGE_ALIGN(walk_data.addr + size) = 2 * PAGE_SIZE.

What happens if addr < PAGE_SIZE - 1? It looks to me that according to the
definition of ALIGN_DOWN, addr will wrap around.

Thanks,

Alex

> +		.walker	= walker,
> +	};
> +
> +	return _kvm_pgtable_walk(&walk_data);
> +}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
