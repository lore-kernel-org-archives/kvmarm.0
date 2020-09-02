Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4205C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 10:36:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 508562071B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 10:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeRA3wU6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 508562071B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5584B277;
	Wed,  2 Sep 2020 06:36:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZUYoJKsldLUs; Wed,  2 Sep 2020 06:36:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A51574B1B1;
	Wed,  2 Sep 2020 06:36:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EAB04B179
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 06:36:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UCawrEUShbDf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 06:36:54 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C0DA4B117
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 06:36:54 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0558D2071B;
 Wed,  2 Sep 2020 10:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599043013;
 bh=KYQU/1AZaeeller7OqNszZ//HzPO7daN7JxytFc/APg=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=ZeRA3wU6hJhAbym2EENEm8GdnNzeGkCoqnzEbglDMFCiH9VjbROPKxI8EW0PBSDVN
 2DWVNb14qT9YgOGfyTmzNUcNHIuWojU1nWUYR7EzL+FB3Ah/gLtXzYkBJCkdaSp/xI
 157/FDjXwVSJ6ibikCmsHmEvTFcJRCKxwBSqo6CQ=
Date: Wed, 2 Sep 2020 11:36:49 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 02/21] KVM: arm64: Add stand-alone page-table walker
 infrastructure
Message-ID: <20200902103648.GC5567@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-3-will@kernel.org>
 <9de812eb-1067-08bf-69cd-eb205dfbda35@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9de812eb-1067-08bf-69cd-eb205dfbda35@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

On Thu, Aug 27, 2020 at 05:27:13PM +0100, Alexandru Elisei wrote:
> It looks to me like the fact that code doesn't take into account the fact that we
> can have concatenated pages at the initial level of lookup. Am I missing
> something? Is it added in later patches and I missed it? I've commented below in a
> few places where I noticed that.

(seems like you figured some of this out in a later reply).

> On 8/25/20 10:39 AM, Will Deacon wrote:
> > The KVM page-table code is intricately tied into the kernel page-table
> > code and re-uses the pte/pmd/pud/p4d/pgd macros directly in an attempt
> > to reduce code duplication. Unfortunately, the reality is that there is
> > an awful lot of code required to make this work, and at the end of the
> > day you're limited to creating page-tables with the same configuration
> > as the host kernel. Furthermore, lifting the page-table code to run
> > directly at EL2 on a non-VHE system (as we plan to to do in future
> > patches) is practically impossible due to the number of dependencies it
> > has on the core kernel.
> >
> > Introduce a framework for walking Armv8 page-tables configured
> > independently from the host kernel.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 101 ++++++++++
> >  arch/arm64/kvm/hyp/Makefile          |   2 +-
> >  arch/arm64/kvm/hyp/pgtable.c         | 290 +++++++++++++++++++++++++++
> >  3 files changed, 392 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
> >  create mode 100644 arch/arm64/kvm/hyp/pgtable.c

[...]

> > +static u64 kvm_granule_shift(u32 level)
> > +{
> > +	return (KVM_PGTABLE_MAX_LEVELS - level) * (PAGE_SHIFT - 3) + 3;
> 
> Isn't that the same same thing as the macro ARM64_HW_PGTABLE_LEVEL_SHIFT(n) from
> pgtable-hwdef.h? I think the header is already included, as this file uses
> PTRS_PER_PTE and that's the only place I found it defined.

Hmm, that's an interesting one. If we ever want to adjust KVM_PGTABLE_MAX_LEVELS
things will break, so we just need to take that into account should future
architecture extensions add an extra level. I suppose I can add a comment
to that effect and use ARM64_HW_PGTABLE_LEVEL_SHIFT() instead.

> 
> > +}
> > +
> > +static u64 kvm_granule_size(u32 level)
> > +{
> > +	return BIT(kvm_granule_shift(level));
> > +}
> > +
> > +static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
> > +{
> > +	u64 granule = kvm_granule_size(level);
> > +
> > +	/*
> > +	 * Reject invalid block mappings and don't bother with 4TB mappings for
> > +	 * 52-bit PAs.
> > +	 */
> > +	if (level == 0 || (PAGE_SIZE != SZ_4K && level == 1))
> > +		return false;
> > +
> > +	if (granule > (end - addr))
> > +		return false;
> > +
> > +	return IS_ALIGNED(addr, granule) && IS_ALIGNED(phys, granule);
> > +}
> 
> This is a very nice rewrite of fault_supports_stage2_huge_mapping, definitely
> easier to understand.

Thanks!

> > +static u32 kvm_start_level(u64 ia_bits)
> > +{
> > +	u64 levels = DIV_ROUND_UP(ia_bits - PAGE_SHIFT, PAGE_SHIFT - 3);
> 
> Isn't that the same same thing as the macro ARM64_HW_PGTABLE_LEVELS from
> pgtable-hwdef.h?

Yes, although this is slightly more idiomatic due to its use of
DIV_ROUND_UP imo. But happy to replace it.

> 
> > +	return KVM_PGTABLE_MAX_LEVELS - levels;
> 
> I tried to verify this formula and I think there's something that I don't
> understand or I'm missing. For the default KVM setup, where the user doesn't
> specify an IPA size different from the 40 bits default: ia_bits = 40 (IPA =
> [39:0]), 4KB pages, translation starting at level 1 with 2 concatenated level 1
> tables (VTCR_EL2.T0SZ = 24, VTCR_EL2.SL0 = 1, VTCR_EL2.TG0 = 0, starting level
> from table D5-13 at page D5-2566, ARM DDI 0487F.b), according to the formula I get:
> 
> levels = DIV_ROUND_UP(40 - 12, 12 -3) = DIV_ROUND_UP(28, 9) = 4
> return 4 - 4 = 0
> 
> which means the resulting starting level is 0 instead of 1.

Yeah, this is fiddly. kvm_start_level() doesn't cater for concatenation at
all and it's only used to determine the start level for the hypervisor
stage-1 table. For the stage-2 page-tables, we actually extract the start
level back out of the vtcr, as that gets configured separately and so we
just parameterise ourselves around that.

I think I'll remove kvm_start_level() entirely, and just inlined it into
its single call site (which will be neater using ARM64_HW_PGTABLE_LEVELS).

> 
> > +}
> > +
> > +static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
> > +{
> > +	u64 shift = kvm_granule_shift(level);
> > +	u64 mask = BIT(PAGE_SHIFT - 3) - 1;
> 
> This doesn't seem to take into account the fact that we can have concatenated
> initial page tables.

This is ok, as we basically process the PGD one page at a time so that the
details of concatenation only really need to be exposed to the iterator.
See the use of kvm_pgd_page_idx() in _kvm_pgtable_walk().

> > +static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
> > +				      kvm_pte_t *ptep, u32 level)
> > +{
> > +	int ret = 0;
> > +	u64 addr = data->addr;
> > +	kvm_pte_t *childp, pte = *ptep;
> > +	bool table = kvm_pte_table(pte, level);
> > +	enum kvm_pgtable_walk_flags flags = data->walker->flags;
> > +
> > +	if (table && (flags & KVM_PGTABLE_WALK_TABLE_PRE)) {
> > +		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep,
> > +					     KVM_PGTABLE_WALK_TABLE_PRE);
> 
> I see that below we check if the visitor modified the leaf entry and turned into a
> table. Is it not allowed for a visitor to turn a table into a block mapping?

It is allowed, but in that case we don't revisit the block entry, as there's
really no need. Compare that with installing a table, where you may well
want to descend into the new table to initialise the new entries in there.

The kerneldoc for kvm_pgtable_walk() talks a bit about this. (aside: that
function isn't actually used, but it felt useful to expose it as an
interface).

Thanks for the review,

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
