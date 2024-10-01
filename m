Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FA61990A8
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727815304; cv=none; b=nWYieIVOp8hBMJOj1kvCJTvJ0lzW00KLFBO6bCfWfxgmcXjFb9S6ULViLBulRv/Cr++9Vf3jKblIXBHQBmMZYjEOgJwxxG6JJMmKJyfMkfmZ5nh8nL/5h2AQdq8Tv3yIORsmN2XEGnR/6r/Imrh1XfIRG0m+YJqbN2yJCJ8Qlvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727815304; c=relaxed/simple;
	bh=VarOVGYDD9N0J/h3yDhdjjHfqXzF1DB4XZXWrEbJihU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m0AoR+M7iH1fO+m6Q51VRPCju8UDYiL2bmzDde6URR+sSehSNAs/FQcoSUWxDunri5X0gJQpNVg1o6RPekfRUsfgrHrh2my7l5J0PIt7vg2Ew1EvSMYiBA0o1iCjw8Q9TGJ4q6mIcEAh98H5GZC4CCZZL1mCouDGlP793J/CcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QIr4F7gP; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QIr4F7gP"
Date: Tue, 1 Oct 2024 13:41:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727815299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=75I+P7eof1YL1Fgyo6OlTobTwQwJKciYu6JUYyV9SFs=;
	b=QIr4F7gPiSrsYdbGpgVBm3DAqehpPddIEtNQNQkW4rQfmf1aZc1qTpX5fS8y/u2ywViHcQ
	I9XImgApdbeYqyMkWX1Nwjo2PIRVwm9nUuifCO3cvzq2J+WGky7fMVfVbijVT4bjjEVse9
	e5/EsEiHBhOZL6HqhO2xccMnm5ikcBY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <ZvxeeVn8LphHxWeS@linux.dev>
References: <20241001001709.1303668-1-oliver.upton@linux.dev>
 <20241001001709.1303668-4-oliver.upton@linux.dev>
 <ZvxH3el9SNuNWwi8@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvxH3el9SNuNWwi8@google.com>
X-Migadu-Flow: FLOW_OUT

Hey,

sidebar: I was a bit confused by the diff for a second, since it looks
like your email client lowercased some stuff :)

On Tue, Oct 01, 2024 at 12:05:01PM -0700, Sean Christopherson wrote:
> On Tue, Oct 01, 2024, Oliver Upton wrote:
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 367f0d3d3194..ab7d387379a0 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1031,6 +1031,8 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  
> >  		if (kvm_dirty_ring_check_request(vcpu))
> >  			return 0;
> > +
> > +		check_nested_vcpu_requests(vcpu);
> >  	}
> >  
> >  	return 1;
> > diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> > index 1ba211541290..749babdbda81 100644
> > --- a/arch/arm64/kvm/nested.c
> > +++ b/arch/arm64/kvm/nested.c
> > @@ -632,9 +632,9 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	/* set the scene for the next search */
> >  	kvm->arch.nested_mmus_next = (i + 1) % kvm->arch.nested_mmus_size;
> >  
> > -	/* clear the old state */
> > +	/* make sure we don't forget to do the laundry */
> >  	if (kvm_s2_mmu_valid(s2_mmu))
> > -		kvm_stage2_unmap_range(s2_mmu, 0, kvm_phys_size(s2_mmu), false);
> > +		s2_mmu->pending_unmap = true;
> 
> Question time.  The code that's just out of sight modifies the nested MMU's tlb_vttbr:
> 
> 	s2_mmu->tlb_vttbr = vcpu_read_sys_reg(vcpu, vttbr_el2) & ~vttbr_cnp_bit;
> 	s2_mmu->tlb_vtcr = vcpu_read_sys_reg(vcpu, vtcr_el2);
> 	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, hcr_el2) & hcr_vm;
> 
> which is consumed by kvm_s2_mmu_iterate_by_vmid().  IIUC, kvm_s2_mmu_iterate_by_vmid()
> is used only when emulating some form of tlbi that's executed by the guest?  I.e.
> is guaranteed to do the right thing because KVM ensures the old state is purged
> prior to entering the guest?

Heh, yeah I meant to add some comments on why iterators that walk the
nested_mmus array are safe. But it's basically what you've said, if the
current MMU gets reclaimed when we're in the middle of unmapping it for
TLBI, then the intent of the TLBI is still upheld since all the
old crap gets kicked out before reuse.

The architecture requires the guest put its own stage-2 into a
consistent state before issuing a TLBI, so even if we wind up doing more
shadow stage-2 fills after relinquishing the lock it is still legal. And
until the TLBI instruction retires (i.e. ERET back to the guest), other
vCPUs can use stale 'TLB entries' all they want.

I'll happily add some comments to clarify all this.

> >  	/*
> >  	 * the virtual vmid (modulo cnp) will be used as a key when matching
> > @@ -649,6 +649,9 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
> >  	s2_mmu->nested_stage2_enabled = vcpu_read_sys_reg(vcpu, hcr_el2) & hcr_vm;
> >  
> >  out:
> > +	if (s2_mmu->pending_unmap)
> > +		kvm_make_request(kvm_req_nested_s2_unmap, vcpu);
> 
> If I followed everything correctly, I don't think a request is needed.  the
> request will never be cross-vCPU, and each vCPU holds a reference to the MMU, so
> the MMU can't be recycled, i.e. pending_unmap is guaranteed to be relevant to the
> vCPU's usage of the MMU.  More thoughts below in check_nested_vcpu_requests().

I'm (ab)using the request to prevent the vCPU thread from actually
entering the VM without first having done the laundry. We have other
examples of strictly per-vCPU tasks that are tracked with a request so
this doesn't stick out that much.

Otherwise we'd need an open-coded check in kvm_vcpu_exit_request() to
catch a 'dirty' MMU or take a pin on it from the point we check the
dirtiness to the point we disable preemption.

> Somewhat of a side topic, the handling of xfer_to_guest_mode_handle_work() in
> kvm_arch_vcpu_ioctl_run() is confusing.  If a signal is pending (ret == -eintr),
> KVM will skip checking requests, e.g. not unmap the nested stage-2, but then continue
> with other pieces of the entry flow.  I'm guessing that's intentional as it looks
> like KVM needs to flush hardware state in case that info is exposed to userspace.
> 
> But it really warps the mind when trying to reason about what will happen if
> there is a relevant request, e.g. if the below code needs to load a new stage-2
> for a new vmid, it could do so with the to-be-unmapped contents.

What you describe sounds worrying, but is still completely fine. Even
without VMID rollover, we're loading a potentially-stale MMU at the
point of vcpu_load().

What saves us is the fact that the EL1&0 translation regime is
out-of-context at EL2, meaning that hardware is disallowed from
speculatively using the translation regime. Ignoring the
ARM64_WORKAROUND_SPECULATIVE_AT turd :)

The point at which the MMU and translation tables *must* be consistent
is the ERET into EL1/EL0.

> > +void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
> > +{
> > +	if (kvm_check_request(kvm_req_nested_s2_unmap, vcpu)) {
> > +		CLASS(vcpu_hw_mmu, mmu)(vcpu);
> > +
> > +		write_lock(&vcpu->kvm->mmu_lock);
> > +		if (mmu->pending_unmap) {
> 
> I doubt it's a functional issue, but if multiple vCPUs are purging the same nested
> stage-2 MMU, and the first vCPU yields while unmapping, then KVM will end up with
> multiple vCPUs doing the unmap.  And irrespective of whether or not the first vCPU
> (or vCPUs) yields, they'll all contend for mmu_lock, which is especially problematic
> since pending writers will block future readers.
> 
> Would it instead make sense to do something like the below?  Checking for the
> need to unmap outside of mmu_lock would also more or less eliminate the need for
> a request.

Maybe? The intent of this change is to restore functional correctness
without _too_ much interest in the performance of it. The general aim of
the nested work on arm64 is getting something functional upstreamed
first, then fixing performance after. You'll notice we have no concept
of an rmap yet either...

I don't really see anything wrong with your approach, it's just that we
aren't necessarily committed to this allocation scheme and we may throw
the whole damn thing out in favor of something else in the future.

-- 
Thanks,
Oliver
