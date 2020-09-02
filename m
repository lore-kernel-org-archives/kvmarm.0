Return-Path: <SRS0=SHPB=CL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2580C433E7
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:46:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4FDD02078B
	for <kvmarm@archiver.kernel.org>; Wed,  2 Sep 2020 11:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="PH5utKcR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FDD02078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 022134B298;
	Wed,  2 Sep 2020 07:46:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w0ervnWod3zb; Wed,  2 Sep 2020 07:46:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BD8F4B2A2;
	Wed,  2 Sep 2020 07:46:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F7F74B289
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:46:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j8zp1-I0vKsm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2020 07:46:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F18D74B27D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2020 07:46:22 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D1AD620758;
 Wed,  2 Sep 2020 11:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599047182;
 bh=9sowLhEdyJyrL74X2cUlbGudzcwYOP4PxB6NjJVvhJs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=PH5utKcRcuNmYJPFB/ueqyw6yLz26hjxHQHScXkTtuXtV2wjAKtExCFyJPRvlr3/k
 KrtxoeaIOO96akB1tSWyKbgyu7pSlsWLJOUGerCDXYSemRMmpVnk2acO3AHxP0E4Sr
 CtTenlOLEWb96jU+GBOEYIJjViIGvugOv6syMO18=
Date: Wed, 2 Sep 2020 12:46:17 +0100
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v3 06/21] KVM: arm64: Add support for stage-2
 map()/unmap() in generic page-table
Message-ID: <20200902114617.GC5838@willie-the-truck>
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-7-will@kernel.org>
 <19e86b8b-3a65-9e65-ffa4-0a1ba3384f18@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19e86b8b-3a65-9e65-ffa4-0a1ba3384f18@arm.com>
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

On Tue, Sep 01, 2020 at 05:24:58PM +0100, Alexandru Elisei wrote:
> On 8/25/20 10:39 AM, Will Deacon wrote:
> > Add stage-2 map() and unmap() operations to the generic page-table code.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Quentin Perret <qperret@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h |  39 ++++
> >  arch/arm64/kvm/hyp/pgtable.c         | 262 +++++++++++++++++++++++++++
> >  2 files changed, 301 insertions(+)

[...]

> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index b8550ccaef4d..41ee8f3c0369 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -32,10 +32,19 @@
> >  #define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
> >  #define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
> >  
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
> > +#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
> > +
> >  #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
> >  
> >  #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
> >  
> > +#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
> 
> Checked the bitfields against ARM DDI 0487F.b, they match.

Phew! ;)

> > +static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
> > +				       kvm_pte_t *ptep,
> > +				       struct stage2_map_data *data)
> > +{
> > +	u64 granule = kvm_granule_size(level), phys = data->phys;
> > +
> > +	if (!kvm_block_mapping_supported(addr, end, phys, level))
> > +		return false;
> > +
> > +	if (kvm_set_valid_leaf_pte(ptep, phys, data->attr, level))
> > +		goto out;
> > +
> > +	kvm_set_invalid_pte(ptep);
> > +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
> > +	kvm_set_valid_leaf_pte(ptep, phys, data->attr, level);
> 
> One has to read the kvm_set_valid_leaf_pte code very carefully to understand why
> we're doing the above (found an old, valid entry in the stage 2 code, the page
> tables are in use so we're doing break-before-make to replace it with the new
> one), especially since we don't this with the hyp tables. Perhaps a comment
> explaining what's happening would be useful.

Sure, I can add something here, but it sounds like you figured it out.

> > +static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> > +			     enum kvm_pgtable_walk_flags flag, void * const arg)
> > +{
> > +	struct stage2_map_data *data = arg;
> > +
> > +	switch (flag) {
> > +	case KVM_PGTABLE_WALK_TABLE_PRE:
> > +		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
> > +	case KVM_PGTABLE_WALK_LEAF:
> > +		return stage2_map_walk_leaf(addr, end, level, ptep, data);
> > +	case KVM_PGTABLE_WALK_TABLE_POST:
> > +		return stage2_map_walk_table_post(addr, end, level, ptep, data);
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> 
> As I understood the algorithm, each of the pre, leaf and post function do two
> different things: 1. free/invalidate the tables/leaf entries if we can create a
> block mapping at a previously visited level (stage2_map_data->anchor != NULL); and
> create an entry for the range at the correct level. To be honest, to me this
> hasn't been obvious from the code and I think some comments to the functions and
> especially to the anchor field of stage2_map_data would go a long way to making it
> easier for others to understand the code.

I can also add something here as the anchor thing is quite unusual. We
basically use it to mark an existing table entry which we want to replace
with a block entry, but before we can do that we have to descend into the
page table under that table entry freeing everything as we go. Then we'll
see the marked entry on the way back up and install the block entry then.

I had a few goes at implementing this with only LEAF and TABLE_POST but
it was really ugly, and actually it turns out TABLE_PRE is really useful
for debugging if you just want to print out the page-table.

> With that in mind, the functions look solid to me: every get_page has a
> corresponding put_page in stage2_map_walk_leaf or in the unmap walker, and the
> algorithm looks sound. I still want to re-read the functions a few times (probably
> in the next iteration) because they're definitely not trivial and I don't want to
> miss something.

Thanks. I'll post a v4 with some comments, so maybe that will help.

> > +	/*
> > +	 * This is similar to the map() path in that we unmap the entire
> > +	 * block entry and rely on the remaining portions being faulted
> > +	 * back lazily.
> > +	 */
> > +	kvm_set_invalid_pte(ptep);
> > +	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
> > +	put_page(virt_to_page(ptep));
> > +
> > +	if (need_flush) {
> > +		stage2_flush_dcache(kvm_pte_follow(pte),
> > +				    kvm_granule_size(level));
> > +	}
> 
> The curly braces are unnecessary; I'm only mentioning it because you don't use
> them in this function for the rest of the one line if statements.

Hmm, but this is a two-line statement so I think it reads better.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
