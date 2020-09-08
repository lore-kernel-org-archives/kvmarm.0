Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46D7C433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 00:03:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3A7DE21941
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 00:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SV2YGLFr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A7DE21941
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EC324B571;
	Mon,  7 Sep 2020 20:03:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lC2uGkT6XcCo; Mon,  7 Sep 2020 20:03:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52184B577;
	Mon,  7 Sep 2020 20:03:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E51A4B574
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 20:03:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EMHOTuHNux8R for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 20:03:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39EB14B571
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 20:03:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599523421;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=F8qChRccbxf6sTNlS1nCvn1v5FyjnQP0UFymv30usRs=;
 b=SV2YGLFr/MzGiyZ3M5shntXOU2Luw8/VIrY3v9dwYEhmMhv07PT/mRDL6ESOCw6NPCHDAa
 gvF8B6PLv+KBpXnryIKH1iMPdPTau3Q/nMySMYD0c6R1pO10XehAbj6h4vgjvdxoNawkWJ
 XDLoQGYyN8/YA+tYuZc04H6wM9U/tkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-YjbFrd2tPfyujiYjummaeA-1; Mon, 07 Sep 2020 20:03:38 -0400
X-MC-Unique: YjbFrd2tPfyujiYjummaeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A73A802B75;
 Tue,  8 Sep 2020 00:03:36 +0000 (UTC)
Received: from [10.64.54.90] (vpn2-54-90.bne.redhat.com [10.64.54.90])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4067B60BE2;
 Tue,  8 Sep 2020 00:03:33 +0000 (UTC)
Subject: Re: [PATCH v4 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-3-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <56510d79-ce08-c058-03f8-10b1a37d05b0@redhat.com>
Date: Tue, 8 Sep 2020 10:03:30 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200907152344.12978-3-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 9/8/20 1:23 AM, Will Deacon wrote:
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

It looks good to me. However, If you get a chance to respin, I guess
it would be nice to add some comments about kvm_block_mapping_supported().
More details are provoided below.

Reviewed-by: Gavin Shan <gshan@redhat.com>

>   arch/arm64/include/asm/kvm_pgtable.h | 101 ++++++++++
>   arch/arm64/kvm/hyp/Makefile          |   2 +-
>   arch/arm64/kvm/hyp/pgtable.c         | 285 +++++++++++++++++++++++++++
>   3 files changed, 387 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
>   create mode 100644 arch/arm64/kvm/hyp/pgtable.c
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> new file mode 100644
> index 000000000000..1c5d981e15c3
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
> + * @KVM_PGTABLE_PROT_X:		Execute permission.
> + * @KVM_PGTABLE_PROT_W:		Write permission.
> + * @KVM_PGTABLE_PROT_R:		Read permission.
> + * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
> + */
> +enum kvm_pgtable_prot {
> +	KVM_PGTABLE_PROT_X			= BIT(0),
> +	KVM_PGTABLE_PROT_W			= BIT(1),
> +	KVM_PGTABLE_PROT_R			= BIT(2),
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
>   		    -DDISABLE_BRANCH_PROFILING		\
>   		    $(DISABLE_STACKLEAK_PLUGIN)
>   
> -obj-$(CONFIG_KVM) += vhe/ nvhe/
> +obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
>   obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> new file mode 100644
> index 000000000000..3fb9d1949a3f
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -0,0 +1,285 @@
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
> +	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
> +	return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
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
> +

If you get a chance to respin, it would be nice to have more comments to
explain why 4TB block mapping is rejected here. I guess it depends on the
fact: hugeTLB/THP doesn't support such kind of huge block mapping yet?

> +static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
> +{
> +	u64 shift = kvm_granule_shift(level);
> +	u64 mask = BIT(PAGE_SHIFT - 3) - 1;
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
> +	kvm_pte_t pte = *ptep;
> +	WRITE_ONCE(*ptep, pte & ~KVM_PTE_VALID);
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
> +		.walker	= walker,
> +	};
> +
> +	return _kvm_pgtable_walk(&walk_data);
> +}
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
