Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DF649CF4C;
	Wed,  2 Sep 2026 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355001; cv=none; b=YDHlyow8wwjqBlzUFZ0oTRYfYY9s4rPfL4Hn+WxGJfjpA3tsq4r8weTR7dYfifGR0YnCwfE+0uqSIm38NGtwvSN+NxyPl0aVjiW0p9IojoJ7EaePiIm8rRS0xPxt1s5qrKoWbpUGxYrAIoiwLJ5mk00CFRhDdOzOZ/PXbkRJJY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355001; c=relaxed/simple;
	bh=EEj/IqgjIH10x26odgxcdN5+m52mq6BOJ7mkONw/e7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=OLylpa1BBXAWB4A9Os2ztwza9emjYrfEFJSEzrQqhyV1eSP8QYB31vlHYvOFfXs/KXxl+aGY3j49uy0mm5b215k1ceThmJ4O2Pwb9E3OA3BgLOC2hVlIbZHggtw5dtEDrVe9K4ZkUZgGA22YQ6yb0ACxtBGMBVlJb2drn2WVDyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hA2HBPBU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hA2HBPBU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14CFD165C;
	Wed,  2 Sep 2026 06:16:34 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12B423F85F;
	Wed,  2 Sep 2026 06:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788354997; bh=EEj/IqgjIH10x26odgxcdN5+m52mq6BOJ7mkONw/e7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA2HBPBUz92C+n/weV0lyjGaKbAM8pTQhmP/dQ8sth/u0sI64jaacup2LxEHdlcUm
	 KaNhX435SfRFqzqCVznznz2DO+Qo9hMEgD6dnwAO8ZKigMaLomxrykJbEtxLOv9bW5
	 hiBVLNzhzJpogOROiSIvLIZHpeAaRsgjJe0hyP/U=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Wed,  2 Sep 2026 14:16:31 +0100
Message-ID: <apghr-z0qXzTy_Hm@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901174941.7C56A1F000E9@smtp.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <20260901174941.7C56A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 05:49:41PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] Data race and TOCTOU on `kvm->arch.mmu.vtcr` between vCPU setup and memslot updates, breaking dirty logging.
> - [High] Missing context-wide TLB invalidation after modifying `VTCR_EL2.HD` results in hardware bypassing write-protection.
> - [High] Disabling HAFDBS globally for dirty logging causes massive performance degradation on non-logging memslots due to unnecessary permission faults.
> - [Low] Unreachable `KVM_MR_DELETE` check inside `log_dirty_pages` block.
> --
> 
> commit 54d7950cd735bc1edc3a9503d03ebffb8e6ca046
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Enable HAFDBS for guests not on migration
> 
> This patch enables hardware management of access and dirty bits (HAFDBS)
> for KVM guests on arm64 when dirty logging is disabled. It modifies
> vCPU setup and memslot commit paths to dynamically toggle VTCR_EL2.HD
> based on the presence of dirty-logged memslots.
> 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 1e528d53d0931..76aebaa95cdab 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> 
> [ ... ]
> 
> > @@ -1683,6 +1683,13 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
> >  	if (!ret && vcpu_has_nv(vcpu))
> >  		ret = kvm_vcpu_init_nested(vcpu);
> >  
> > +	/* Enable HAFDBS by default if VHE && !nested  */
> > +	if (kvm_supports_hafdbs(kvm) &&
> > +	    atomic_read(&kvm->nr_memslots_dirty_logging) == 0)
> > +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
> > +	else
> > +		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
> > +
> 
> [Severity: Critical]
> Does this read-modify-write of kvm->arch.mmu.vtcr (holding config_lock)
> create a data race against kvm->slots_lock?
> 
> In kvm_set_hafdbs() below, this same variable is modified while holding
> kvm->slots_lock. If userspace concurrently initializes vCPUs and enables
> dirty logging, VTCR_EL2_HD could be incorrectly left at 1. This would cause
> the hardware to silently update dirty bits without trapping, bypassing
> software dirty logging and resulting in lost dirty pages during migration.

I think that this may be a hard to hit scenario, but to be sure I think it 
should not hurt to hold the slots lock here as well.

Have to properly check if I won't cause any kind of dead/live lock here, 
though.

> 
> >  	return ret;
> >  }
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9d4f70430bbea..94094ab56d90f 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1989,7 +1989,8 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> >  	if (s2vi->map_writable) {
> >  		*prot |= KVM_PGTABLE_PROT_W;
> >  
> > -		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
> > +		if (s2vi->device ||
> > +		    !(memslot_is_logging(s2fd->memslot) || kvm_supports_hafdbs(kvm)) ||
> >  		    kvm_is_write_fault(s2fd->vcpu))
> >  			*prot |= KVM_PGTABLE_PROT_DIRTY;
> 
> [Severity: High]
> Can checking the static capability kvm_supports_hafdbs() here instead of
> the dynamic vtcr state starve non-logging slots of the software fallback?
> 
> When dirty logging is enabled on one memslot, kvm_set_hafdbs() disables
> VTCR_EL2.HD globally. However, if a guest writes to an unrelated
> non-logging slot that was mapped writable-clean, won't the hardware now
> generate a stage-2 permission fault?
> 
> This could cause performance degradation across the entire VM whenever any
> single memslot (like a VGA framebuffer) enables dirty logging.
> 

Yes, that's an expected tradeoff. I believed it would be fine as the 
usecase I had in mind for dirty-tracking was live migration, which usually 
tracks all memory at once, causing no performance degradation.

If we are dirty-tracking a memslot during the whole VM runtime, as is the 
case for a VGA framebuffer, maybe this is a special scenario, and we should 
make the page dirty as well.

If there is a common use case for tracking a single memory slot of regular 
memory (not used as device memory and so on), then maybe this patch has to 
be reworked to take that into account.

> [ ... ]
> 
> > @@ -2577,6 +2578,20 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
> >  	return err;
> >  }
> >  
> > +static void kvm_set_hafdbs(struct kvm *kvm, bool set)
> > +{
> > +	/* Check if no action required */
> > +	if (!!(kvm->arch.mmu.vtcr & VTCR_EL2_HD) == set)
> > +		return;
> > +
> > +	if (set)
> > +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
> > +	else
> > +		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
> 
> [Severity: Critical]
> Does modifying kvm->arch.mmu.vtcr here under kvm->slots_lock race against
> the unprotected updates in kvm_setup_vcpu() as noted above?
> 

There is a comment on that above.

> > +
> > +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
> 
> [Severity: High]
> Is KVM_REQ_RELOAD_STAGE2 sufficient here to ensure the hardware observes
> the changed VTCR_EL2 state?
> 

This is called when we enable dirty-tracking, and the next steps after that 
will be to clean the dirty-bits and then do a TLBi, so it should be fine 
for that scenario.

Maybe I should add a comment to explain the caller is responsible to carry 
a TLBi.


> The ARM architecture permits translation regime registers like VTCR_EL2 to
> be cached in the TLB (or a context cache). Modifying this register
> typically requires a full VMID TLB invalidation (like calling
> kvm_flush_remote_tlbs(kvm)) to guarantee global visibility. 
> 
> Without it, the CPU might continue using cached translations with HD=1 in
> the write-protected memslot, silently bypassing write-protection.
> 
> > +}
> > +
> >  void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  				   struct kvm_memory_slot *old,
> >  				   const struct kvm_memory_slot *new,
> > @@ -2594,6 +2609,10 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >  		if (change == KVM_MR_DELETE)
> >  			return;
> 
> [Severity: Low]
> Is this KVM_MR_DELETE condition reachable?
> 
> The log_dirty_pages variable checked just before this is initialized as
> 'new && new->flags & KVM_MEM_LOG_DIRTY_PAGES'. During a KVM_MR_DELETE
> change, the 'new' parameter passed into kvm_arch_commit_memory_region() is
> strictly NULL. Therefore, log_dirty_pages will always be false for
> deletes, making this nested check dead code.

Not sure what this is trying to point. 

Yes, disabling HAFDBS will not happen if we are deleting the memslot, and 
also it will not enable it again if it's already enabled, so we should be 
safe.

Thanks!
Leo
