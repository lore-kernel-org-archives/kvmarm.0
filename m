Return-Path: <SRS0=mzoY=IG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDA4C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 12:46:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C999651FE
	for <kvmarm@archiver.kernel.org>; Mon,  8 Mar 2021 12:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C999651FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 808014B6FF;
	Mon,  8 Mar 2021 07:46:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v4ReK5RugCha; Mon,  8 Mar 2021 07:46:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A9694B700;
	Mon,  8 Mar 2021 07:46:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F0B4B6E8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 07:46:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hV0weWwWhFcn for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Mar 2021 07:46:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 186374B6E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Mar 2021 07:46:15 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D481C651FC;
 Mon,  8 Mar 2021 12:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615207573;
 bh=EmPbvP31FO4CQ1gnsMfb4yOYcyyKbW6zA6cc/EyQbBQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Y1wmwl4ngiq0/xsZR5mXhTTZ6KM8bWFDCw7KJEqHLm3+aiGnl3Rg1C7h/dXRFf4Dj
 jTp80OT6gJLcvPVUg7zMbQk8Go7AfsUXrsUio2A/YpCdDV3JtQN4XOFHX/LnZizsS/
 pjz5zzaBdKkHEX8iGi3OAucIUiLZ8gOi2hzKeRm5/TGkPSCo5mCxka1PHdY2TsEIeo
 pfYyEg6teQ7O+G5cuUzimzKJuR8l7DMT2cHRKAhiQpy6xCWeqX0F4K6iu8cFWfhE0T
 rLFyhdy64JRNLdAVmvMtFk4ltKlSpWL9FUspLsQ+uyw3QyBYuhONpD41vsFRpzHsv/
 6TbamoaBPiu6Q==
Date: Mon, 8 Mar 2021 12:46:07 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 29/32] KVM: arm64: Wrap the host with a stage 2
Message-ID: <20210308124606.GA25879@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-30-qperret@google.com>
 <20210305192905.GE23633@willie-the-truck>
 <YEXs1cOlmhHg4u8x@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YEXs1cOlmhHg4u8x@google.com>
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

On Mon, Mar 08, 2021 at 09:22:29AM +0000, Quentin Perret wrote:
> On Friday 05 Mar 2021 at 19:29:06 (+0000), Will Deacon wrote:
> > On Tue, Mar 02, 2021 at 02:59:59PM +0000, Quentin Perret wrote:
> > > +static __always_inline void __load_host_stage2(void)
> > > +{
> > > +	if (static_branch_likely(&kvm_protected_mode_initialized))
> > > +		__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
> > > +	else
> > > +		write_sysreg(0, vttbr_el2);
> > 
> > I realise you've just moved the code, but why is this needed? All we've
> > done is point the stage-2 ttb at 0x0 (i.e. we haven't disabled anything).
> 
> Right, but that is also used for tlb maintenance operations, e.g.
> __tlb_switch_to_host() and friends.

Good point, the VMID is needed in that situation.

> > > +int __pkvm_prot_finalize(void)
> > > +{
> > > +	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
> > > +	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
> > > +
> > > +	params->vttbr = kvm_get_vttbr(mmu);
> > > +	params->vtcr = host_kvm.arch.vtcr;
> > > +	params->hcr_el2 |= HCR_VM;
> > > +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> > > +		params->hcr_el2 |= HCR_FWB;
> > > +	kvm_flush_dcache_to_poc(params, sizeof(*params));
> > > +
> > > +	write_sysreg(params->hcr_el2, hcr_el2);
> > > +	__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
> > 
> > AFAICT, there's no ISB here. Do we need one before the TLB invalidation?
> 
> You mean for the ARM64_WORKAROUND_SPECULATIVE_AT case? __load_stage2()
> should already add one for me no?

__load_stage2() _only_ has the ISB if ARM64_WORKAROUND_SPECULATIVE_AT is
present, whereas I think you need one unconditionall here so that the
system register write has taken effect before the TLB invalidation.

It's similar to the comment at the end of __tlb_switch_to_guest().

Having said that, I do worry that ARM64_WORKAROUND_SPECULATIVE_AT probably
needs a closer look in the world of pKVM, since it currently special-cases
the host.

> > > +	__tlbi(vmalls12e1is);
> > > +	dsb(ish);
> > 
> > Given that the TLB is invalidated on the boot path, please can you add
> > a comment here about the stale entries which you need to invalidate?
> 
> Sure -- that is for HCR bits cached in TLBs for VMID 0. Thinking about
> it I could probably reduce the tlbi scope as well.
> 
> > Also, does this need to be inner-shareable? I thought this function ran on
> > each CPU.
> 
> Hmm, correct, nsh should do.

Cool, then you can do that for both the TLBI and the DSB instructions (and
please add a comment that the invalidation is due to the HCR bits).

> > > +static void host_stage2_unmap_dev_all(void)
> > > +{
> > > +	struct kvm_pgtable *pgt = &host_kvm.pgt;
> > > +	struct memblock_region *reg;
> > > +	u64 addr = 0;
> > > +	int i;
> > > +
> > > +	/* Unmap all non-memory regions to recycle the pages */
> > > +	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
> > > +		reg = &hyp_memory[i];
> > > +		kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> > > +	}
> > > +	kvm_pgtable_stage2_unmap(pgt, addr, ULONG_MAX);
> > 
> > Is this just going to return -ERANGE?
> 
> Hrmpf, yes, that wants BIT(pgt->ia_bits) I think. And that wants testing
> as well, clearly.

Agreed, maybe it's worth checking the return value.

> > > +static int host_stage2_idmap(u64 addr)
> > > +{
> > > +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> > > +	struct kvm_mem_range range;
> > > +	bool is_memory = find_mem_range(addr, &range);
> > > +	struct hyp_pool *pool = is_memory ? &host_s2_mem : &host_s2_dev;
> > > +	int ret;
> > > +
> > > +	if (is_memory)
> > > +		prot |= KVM_PGTABLE_PROT_X;
> > > +
> > > +	hyp_spin_lock(&host_kvm.lock);
> > > +	ret = kvm_pgtable_stage2_idmap_greedy(&host_kvm.pgt, addr, prot,
> > > +					      &range, pool);
> > > +	if (is_memory || ret != -ENOMEM)
> > > +		goto unlock;
> > > +	host_stage2_unmap_dev_all();
> > > +	ret = kvm_pgtable_stage2_idmap_greedy(&host_kvm.pgt, addr, prot,
> > > +					      &range, pool);
> > 
> > I find this _really_ hard to reason about, as range is passed by reference
> > and we don't reset it after the first call returns -ENOMEM for an MMIO
> > mapping. Maybe some commentary on why it's still valid here?
> 
> Sure, I'll add something. FWIW, that is intended -- -ENOMEM can only be
> caused by the call to kvm_pgtable_stage2_map() which leaves the range
> untouched. So, as long as we don't release the lock, the range returned
> by the first call to kvm_pgtable_stage2_idmap_greedy() should still be
> valid. I suppose I could call kvm_pgtable_stage2_map() directly the
> second time to make it obvious but I thought this would expose the
> internal of kvm_pgtable_stage2_idmap_greedy() a little bit too much.

I can see it both ways, but updating the kerneldoc for
kvm_pgtable_stage2_idmap_greedy() to state in which cases the range is
updated and how would be helpful. It just says "negative error code on
failure" at the moment.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
