Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F82345CA1;
	Mon,  3 Aug 2026 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773263; cv=none; b=SoKdltB2UnVk9NalJpzhgumQLgZORTuNX/74LX/0+I7Bg44++9Zn2+tP/C/+RDCvL3lLNbz/5VpyhhFwpga1cMdE3Jgr8QGTAjw7CHTekxaD0UEIn4oxWP15AtQ5E8XiQuKlKAkQn/2K4GjAXkRL3GdRdI/1vxs/AJA8oqF9L4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773263; c=relaxed/simple;
	bh=sWkupcXaQq2AWONhip5BTz605kCgTmldDCwSxh19n0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=p8Ok/Ueor9VT/kwqUezdW08cUb2mQZqVC1/IcD9Yco/msjoDRmT/SfT/q9I0MsPYNHt6hOJaU37gJbkha/noutaYV4cqp4xYU8N3C//Wu72JQ2c68u9rJLXa5Xjdbs2nfye14QhvOFOxq1H7fFfXJyGxsAGuG5qCSfiRd1gtfpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qYv0vl9o; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qYv0vl9o"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C0C9143D;
	Mon,  3 Aug 2026 09:07:36 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F2CA3F66F;
	Mon,  3 Aug 2026 09:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785773260; bh=sWkupcXaQq2AWONhip5BTz605kCgTmldDCwSxh19n0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYv0vl9o/lXSlPk9IVx02NBWVv4J6Xqp2vdhCaNxUMCHs8o0lWDl8uoQMp696bZPM
	 XcazZW8yUBsotTthlkiblV5wfrTJ6n4u/sMzGaEJNIN5XopJ2qWprrVze2RCx2jZ25
	 3xvcKmw1f9oMuomHqkiudyy/6rEbdpnBsVP/9C6Q=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v3 10/11] KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
Date: Mon,  3 Aug 2026 17:07:36 +0100
Message-ID: <anC8yHF6xC693paS@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729112124.F29F11F000E9@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-11-leo.bras@arm.com> <20260729112124.F29F11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:21:24AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [Critical] Hardware-accelerated dirty ring clear directly accesses EL2 system registers from the host kernel, causing fatal unhandled exceptions on nVHE and pKVM systems.
> - [High] The `hw_entries` buffer is allocated using kmalloc, which does not guarantee the page alignment strictly required by the `SYS_HACDBSBR_EL2` hardware register.
> 
> Pre-existing issues:
> - [High] Writes to control-plane system registers are batched without an intervening `isb()`, violating ARM64 architectural synchronization requirements.
> --
> 
> --- Patch [10]: [PATCH v3 10/11] KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine ---
> commit f9fc2a3f2ff348143923dea638ecd996e369580d
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
>     
> Implement arm64 version of kvm_arch_dirty_ring_clear() making use of
> FEAT_HACDBS.
>     
> It works by transversing the dirty-ring and converting its entries into
> HDBSS entries based on the slot offset.
>     
> The resulting HDBSS array is then fed to the HACDBS mechanism that walks
> the pagetable marking writable-dirty pages as writable-clean.
> 
> > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > index d368a23a84b30..f785a7aad9e88 100644
> > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > @@ -15,6 +15,9 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  			       unsigned long *bitmap,
> >  			       bool *flush);
> >  
> > +int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > +				int *nr_entries_reset);
> > +
> >  static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
> >  {
> >  	return system_supports_hacdbs() &&  kvm->arch.mmu.pgt &&
> >  	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
> >  }
> 
> [Severity: Critical]
> Does this gating function also need to verify the VHE execution mode?

it's already done before setting KVM_PGTABLE_S2_DBM.

> 
> By checking only system_supports_hacdbs(), it appears this permits the
> accelerated path to be invoked on nVHE and pKVM host systems.
> 
> Since dirty_bit_clear() performs direct accesses to EL2 system registers
> from the host kernel:
> 
> arch/arm64/kvm/dirty_bit.c:dirty_bit_clear() {
>     ...
>     __load_stage2(&kvm->arch.mmu);
>     sysreg_clear_set_hcr(0, HCR_EL2_VM);
>     ...
> }
> 
> Wouldn't this trigger an unhandled hypervisor trap or undefined instruction
> exception when triggered by userspace on nVHE systems?
> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > index d7e624f9b6308..ca9cfefe0893b 100644
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
> > @@ -359,3 +359,80 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  
> >  	return ret;
> >  }
> > +
> > +int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > +				int *nr_entries_reset)
> > +{
> > +	u64 *hw_entries __free(kfree) = NULL;
> > +	u64 ttwl;
> > +	s64 cur_slot = S64_MAX;
> > +	int i, ret;
> > +	struct kvm_memory_slot *memslot;
> > +
> > +	if (signal_pending(current))
> > +		return -EINTR;
> > +
> > +	ttwl = HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
> > +
> > +	hw_entries = kmalloc(max(ring->size * sizeof(u64), PAGE_SIZE), GFP_KERNEL);
> 
> [Severity: High]
> Could this allocation cause the hardware accelerator to read from the wrong
> memory address?
> 
> When debugging features like SLUB debugging are enabled, kmalloc allocations
> are not strictly page-aligned because of prepended metadata.
> 

Argh, I was not aware of this.
Will change it to use recommended allocators instead of kmalloc.


> The SYS_HACDBSBR_EL2 hardware register requires a page-aligned physical
> base address. When hacdbs_start() masks out the offset using
> HACDBSBR_EL2_BADDR_MASK, an unaligned base address gets truncated.
> 
> Will this result in the hardware reading from the start of the physical
> page instead of the actual hw_entries array? It might be necessary to use
> alloc_pages_exact() or __get_free_pages() here to guarantee alignment.
> 
> > +	if (!hw_entries)
> > +		return -ENOMEM;
> > +
> [ ... ]
> > +	if (i == 0)
> > +		return 0;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +	ret = dirty_bit_clear(kvm, hw_entries, i);
> 
> [Severity: High]
> This is a pre-existing issue, but is it possible that the hardware routines
> called here violate architectural synchronization requirements?
> 

Already discussed before.

> Looking at the underlying functions, writes to control-plane system
> registers seem to be batched without an intervening isb() as the very next
> instruction.
> 
> For example, in hacdbs_start():
> 
> arch/arm64/kvm/dirty_bit.c:hacdbs_start()
>     ...
>     sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
>                        HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
>                        
>     br = (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) | ...
>     ...
> 
> And in hacdbs_sched_in():
> 
> arch/arm64/kvm/dirty_bit.c:hacdbs_sched_in()
>     ...
>     write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
>     write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);
>     isb();
> 
> Could this allow the CPU to execute the intervening instructions in an
> architecturally undefined pipeline state?
> 
> > +	write_unlock(&kvm->mmu_lock);
> > +
> > +	/* Set as invalid all successfully cleaned entries */
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260729104548.3439958-1-leo.bras@arm.com?part=10


