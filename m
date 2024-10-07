Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54D41DE3D4
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 21:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728336179; cv=none; b=N4L113fRsYiZaiXIC256+i4LpqmEckx5tUJKKN6WXo3wpZGTgpQjUPC9oA0cehEpqtsW1FK6k0GvcnASE5P0jkIWmYCsngIIDRXK8/LS1UqpMt2JN31nSWMpLIImsIo/AamUVGMDryXECjqfzm4qjNXFAlguZZ6vryz9x6WLRqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728336179; c=relaxed/simple;
	bh=+3Xq1L9Z+cDoW5859NX2iKw3QsMpRaG5ruZlLNJrMNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Maj9VngQ10SLG4U1f9k1nBxmCCO5La+ZsAEV2tGBN6YwBkkpkfwaWxX7AO2C6ioMsUM4KTO0wnHA8QfW+eJJvzSNgnJ4N0xtP92Ny49j5Jd6wxDwsMAP4eCQI5hHUOjy7piqpi8Tc8FQxi5YZ4bUunjxhUbnPbJLjzPvD55njVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hGmbKtHa; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hGmbKtHa"
Date: Mon, 7 Oct 2024 14:22:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728336174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Svf1HSqB/5Y8lR3Mow6ln7+WIxyUWryr8gHcRxFPYwc=;
	b=hGmbKtHaYZUjxGnU4tiwFWcDav7+z5u4yBuCz0LzEZGJWkOUyRgpWq0jJZoR0F3/mtQU8T
	mpsejjMNfiVtcpBFiZfmSnnxECgTpKfvcjQlUs/uSfgOEezFqvZJkO3mVdsJXhQb4Q1jrJ
	rFn5cZ7uh10j6DG6CcsATYyKnX0Mg8g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU
 when scheduled out
Message-ID: <ZwRRKM5dMZ22KYKf@linux.dev>
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
 <20241007164256.1795250-2-oliver.upton@linux.dev>
 <ZwQq6Vk5_7Or4hW1@google.com>
 <ZwQwCqR11wlADRUA@linux.dev>
 <ZwQ8EMcZYtUb6wk_@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwQ8EMcZYtUb6wk_@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 07, 2024 at 12:52:48PM -0700, Sean Christopherson wrote:
> On Mon, Oct 07, 2024, Oliver Upton wrote:
> > On Mon, Oct 07, 2024 at 11:39:37AM -0700, Sean Christopherson wrote:
> > > > @@ -674,10 +681,18 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> > > >  
> > > >  void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
> > > >  {
> > > > -	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
> > > > +	/*
> > > > +	 * Keep a reference on the associated stage-2 MMU if the vCPU is
> > > > +	 * scheduling out and not in WFI emulation, suggesting it is likely to
> > > > +	 * reuse the MMU sometime soon.
> > > > +	 */
> > > > +	if (vcpu->scheduled_out && !vcpu_get_flag(vcpu, IN_WFI))
> > > > +		return;
> > > 
> > > Assuming KVM arm64 supports halt-polling, I think it makes more sense to check
> > > kvm_vcpu_is_blocking() instead of IN_WFI.  That way, KVM will keep the MMU resident
> > > if the vCPU happens to be preempted and halt-polling is successful.
> > > 
> > > And somewhat of a side topic, calling kvm_vgic_put() from kvm_arch_vcpu_blocking()
> > > instead of kvm_vcpu_wfi() would provide the same optimization for the GIC, as KVM
> > > would only need to put/reload the vGIC if the vCPU is actually scheduled out.
> > 
> > That wouldn't be an optimization, it'd render the halt polling loop
> > useless.

<snip>

> Hmm, but what happens if the wakeup event arrives before IN_WFI is set?  Ah, IIUC,
> GICR_VPENDBASER_PendingLast tracks if there's a pending event, KVM makes sure to
> read PendingLast after making vPE non-resident, and hardware is required to ensure
> either PendingLast=1 or a doorbell is signaled.
> 
> Niave question time: why not query GICR_VPENDBASER_PendingLast directly in
> kvm_vgic_vcpu_pending_irq() instead of putting the vGIC?

The GIC is only required to update GICR_VPENDBASER.PendingLast when
software deschedules the loaded vPE, meaning GICR_VPENDBASER.Valid goes
from 1 => 0. It is not updated for virtual interrupts that arrive after
the vPE has been descheduled.

So a polling loop that tests PendingLast would need to repeatedly mark
the vPE as scheduled/descheduled to get the GIC to process the LPI
pending table. You'd at minimum need a dsb(sy) to ensure the
redistributor has seen the new configuration *and* poll it to make sure
the LPI pending state has been completely serialized/deserialized into
memory:

	while !GICR_VPENDBASER.PendingLast:
		GICR_VPENDBASER.Valid = 1
		dsb(sy)
		while GICR_VPENDBASER.Dirty:
			cpu_relax()
		GICR_VPENDBASER.Valid = 0
		while GICR_VPENDBASER.Dirty:
			cpu_relax()

Conceptually, the redistributor is a 'far' piece of hardware, likely
running at a different clock from your CPU. So it is safe to assume that
interactions with it are pretty slow, and this overall scheme would be
quite expensive.

> E.g. if safely querying
> PendingLast is "heavy", wouldn't it still make sense to do a slow check of
> PendingLast in kvm_vgic_vcpu_pending_irq() if IN_WFI=1?  Or is putting the vGIC
> as lightweight as things get when it comes to checking PendingLast?

I believe I've answered this above, since the status bit only makes
sense when hardware has done a state transition.

> > On top of that, we need to activate the doorbell IRQ for GICv4 to give
> > KVM a kick when something arrives for the vPE.
> 
> Right, but KVM needs to "manually" detect pending events to account for events
> that arrive before the doorbell is activated, so from a functional perspective,
> it shouldn't matter when KVM activates the doorbell (with respect to halt-polling).

Like I said earlier:

<paste>

> > The most recent view of the guest's CPU interface is sitting in
> > hardware at this point, so we need to synchronize KVM's view of
> > the CPUIF with it to determine if a pending interrupt exceeds the
> > priority mask.

</paste>

The guest's enable bits and priority mask are in ICH_VMCR_EL2, and we
need to read that out of the CPU in order for this loop to work:

int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
{
	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
	struct vgic_irq *irq;
	bool pending = false;
	unsigned long flags;
	struct vgic_vmcr vmcr;

	if (!vcpu->kvm->arch.vgic.enabled)
		return false;

	if (vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last)
		return true;

	vgic_get_vmcr(vcpu, &vmcr);

	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);

	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
		raw_spin_lock(&irq->irq_lock);
		pending = irq_is_pending(irq) && irq->enabled &&
			  !irq->active &&
			  irq->priority < vmcr.pmr;		<====== Need latest PMR
		raw_spin_unlock(&irq->irq_lock);

		if (pending)
			break;
	}

	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);

	return pending;
}

KVM's in-memory view of VMCR is updated in vgic_put(). So even w/o GICv4
direct injection, the seemingly premature GIC save/restore is essential
for halt polling to actually do something useful.

-- 
Thanks,
Oliver
