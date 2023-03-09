Received: from out-61.mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A145321E
	for <kvmarm@lists.linux.dev>; Thu,  9 Mar 2023 08:53:11 +0000 (UTC)
Date: Thu, 9 Mar 2023 08:53:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1678351988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i51WF518w1JT78ILCAznI/9c0YZ/t6rmLavMpyMR6Ig=;
	b=fbrjrJoe2PMEFPIRtAU8PI83RS4oDNe9Is4Sb+h3nSENK3sUcVhsOoCSypFnUWdHe2kDbX
	6Q8M2IO89iDbCt9qDfzN86Laz9Qstw1FZ20Hocm+C6IpBFSB4XzRtabL7FjbzRU2DwCD1L
	BgAY3pDEM57ILg5Pjaoy+sdjK8yhtc4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH] KVM: arm64: Avoid inverted vcpu->mutex v. kvm->lock
 ordering
Message-ID: <ZAmecSTqWxzrZEEx@linux.dev>
References: <20230308083947.3760066-1-oliver.upton@linux.dev>
 <ZAi0nAHRLWa/Tqjx@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAi0nAHRLWa/Tqjx@google.com>
X-Migadu-Flow: FLOW_OUT

Hey Sean,

On Wed, Mar 08, 2023 at 08:15:24AM -0800, Sean Christopherson wrote:
> On Wed, Mar 08, 2023, Oliver Upton wrote:
> > I'm somewhat annoyed with the fix here, but annoyance alone isn't enough
> > to justify significantly reworking our locking scheme, and especially
> > not to address an existing bug.
> > 
> > I believe all of the required mutual exclusion is preserved, but another
> > set of eyes looking at this would be greatly appreciated. Note that the
> > issues in arch_timer were separately addressed by a patch from Marc [*].
> > With both patches applied I no longer see any lock inversion warnings w/
> > selftests nor kvmtool.
> 
> Oof.  Would it make sense to split this into ~3 patches, one for each logical
> area? E.g. PMU, PSCI, and vGIC?

So much sense that I had done so originally! I wanted to keep all the
surrounding context from lockdep together with the change, but that made
a bit more of a mess.

So yes.

> That would help reviewers and would give you
> the opportunity to elaborate on the safety of the change.  Or maye even go a step
> further and add multiple locks?  The PMU mess in particular would benefit from
> a dedicated lock.

The PMU is the exact reason I didn't want to retool the locking, especially
considering the serialization we have around KVM_ARCH_FLAG_HAS_RAN_ONCE.
Opinions on the current state of affairs be damned, the locking we currently
have ensures the PMU configuration is visible before any vCPU has had
the chance to run.

Correctly nesting the respective dedicated locks would be fine, but that's yet
another layer for us to get wrong elsewhere :)

> > @@ -961,17 +961,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >  		     filter.action != KVM_PMU_EVENT_DENY))
> >  			return -EINVAL;
> >  
> > -		mutex_lock(&kvm->lock);
> > +		mutex_lock(&kvm->arch.lock);
> >  
> >  		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> > -			mutex_unlock(&kvm->lock);
> > +			mutex_unlock(&kvm->arch.lock);
> >  			return -EBUSY;
> >  		}
> >  
> >  		if (!kvm->arch.pmu_filter) {
> >  			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
> 
> I believe there's an existing bug here.  nr_events is grabbed from kvm_pmu_event_mask(),
> i.e. which depends on kvm->arch.arm_pmu->pmuver, outside of the lock. 
> 
> kvm_arm_pmu_v3_set_pmu() disallows changing the PMU type after a filter has been
> set, but the ordering means nr_events can be computed on a stale PMU.  E.g. if
> userspace does KVM_ARM_VCPU_PMU_V3_SET_PMU and KVM_ARM_VCPU_PMU_V3_FILTER
> concurrently on two different tasks.
> 
> KVM_ARM_VCPU_PMU_V3_IRQ is similarly sketchy.  pmu_irq_is_valid() iterates over
> all vCPUs without holding any locks, which in and of itself is safe, but then it
> it checks vcpu->arch.pmu.irq_num for every vCPU.  I believe concurrent calls to
> KVM_ARM_VCPU_PMU_V3_IRQ would potentially result in pmu_irq_is_valid() returning
> a false postive.
> 
> I don't see anything that would break by holding a lock for the entire function,
> e.g. ending up with something like this

Yeah, that'd certainly be the cleaner thing to do.

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 07444fa22888..2394c598e429 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -957,7 +957,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
>  
>         switch (attr->group) {
>         case KVM_ARM_VCPU_PMU_V3_CTRL:
> +               mutex_lock(&vcpu->kvm->arch.pmu_lock);
>                 ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
> +               mutex_unlock(&vcpu->kvm->arch.pmu_lock);
>                 break;
>         case KVM_ARM_VCPU_TIMER_CTRL:
>                 ret = kvm_arm_timer_set_attr(vcpu, attr);
> 
> >  			if (!kvm->arch.pmu_filter) {
> > -				mutex_unlock(&kvm->lock);
> > +				mutex_unlock(&kvm->arch.lock);
> >  				return -ENOMEM;
> >  			}
> >  
> > @@ -373,7 +373,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
> >  }
> >  
> > -/* To be called with kvm->lock held */
> > +/* To be called with kvm->arch.lock held */
> 
> Opportunistically convert to lockdep?

Agreed (there's a few stragglers I didn't touch as well).

> >  static void __kvm_vgic_destroy(struct kvm *kvm)
> >  {
> >  	struct kvm_vcpu *vcpu;
> 
> ...
> 
> > @@ -441,7 +441,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> >  	if (likely(vgic_ready(kvm)))
> >  		return 0;
> >  
> > -	mutex_lock(&kvm->lock);
> > +	mutex_lock(&kvm->arch.lock);
> >  	if (vgic_ready(kvm))
> >  		goto out;
> 
> This is buggy.  KVM_CREATE_IRQCHIP and KVM_CREATE_DEVICE protect vGIC creation
> with kvm->lock, whereas this (obviously) now takes only kvm->arch.lock.
> kvm_vgic_create() sets
> 
> 	kvm->arch.vgic.in_kernel = true;
> 
> before it has fully initialized "vgic", and so all of these flows that are being
> converted can race with the final setup of the vGIC.

Oops -- the intention was to have a lock that can nest within both vcpu->mutex
and kvm->lock, but the latter part of this is missing.

-- 
Thanks,
Oliver
