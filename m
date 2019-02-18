From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 4/5] KVM: arm/arm64: lazily create perf events on enable
Date: Mon, 18 Feb 2019 09:57:31 +0000
Message-ID: <20190218095731.GF54124@e119886-lin.cambridge.arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-5-git-send-email-andrew.murray@arm.com>
 <bd21facb-4245-f583-e4a0-23399017579d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 102EB4A332
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 04:57:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y4r+icX-QXoC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 04:57:34 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 807D840A52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 04:57:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <bd21facb-4245-f583-e4a0-23399017579d@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 14, 2019 at 11:36:02AM +0000, Suzuki K Poulose wrote:
> Hi Andrew,
> 
> On 04/02/2019 16:53, Andrew Murray wrote:
> > To prevent re-creating perf events everytime the counter registers
> > are changed, let's instead lazily create the event when the event
> > is first enabled and destroy it when it changes.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >   virt/kvm/arm/pmu.c | 96 ++++++++++++++++++++++++++++++++++++++----------------
> >   1 file changed, 68 insertions(+), 28 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index 95d74ec..a64aeb2 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -24,7 +24,10 @@
> >   #include <kvm/arm_pmu.h>
> >   #include <kvm/arm_vgic.h>
> > +static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu, u64 select_idx);
> >   static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> > +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> > +
> >   /**
> >    * kvm_pmu_get_counter_value - get PMU counter value
> >    * @vcpu: The vcpu pointer
> > @@ -59,13 +62,15 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >   void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> >   {
> >   	u64 reg;
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >   	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> >   	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> >   	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> > -	/* Recreate the perf event to reflect the updated sample_period */
> > -	kvm_pmu_create_perf_event(vcpu, select_idx);
> > +	kvm_pmu_stop_counter(vcpu, pmc);
> > +	kvm_pmu_sync_counter_enable(vcpu, select_idx);
> >   }
> >   /**
> > @@ -83,6 +88,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> >   /**
> >    * kvm_pmu_stop_counter - stop PMU counter
> > + * @vcpu: The vcpu pointer
> >    * @pmc: The PMU counter pointer
> >    *
> >    * If this counter has been configured to monitor some event, release it here.
> > @@ -143,6 +149,24 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> >   }
> >   /**
> > + * kvm_pmu_enable_counter - create/enable a counter
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The counter index
> > + */
> > +static void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > +
> > +	if (!pmc->perf_event)
> > +		kvm_pmu_create_perf_event(vcpu, select_idx);
> > +
> > +	perf_event_enable(pmc->perf_event);
> > +	if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > +		kvm_debug("failed to enable perf event\n");
> > +}
> > +
> > +/**
> >    * kvm_pmu_enable_counter_mask - enable selected PMU counters
> >    * @vcpu: The vcpu pointer
> >    * @val: the value guest writes to PMCNTENSET register
> > @@ -152,8 +176,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> >   void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> >   {
> >   	int i;
> > -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > -	struct kvm_pmc *pmc;
> >   	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
> >   		return;
> > @@ -162,16 +184,39 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> >   		if (!(val & BIT(i)))
> >   			continue;
> > -		pmc = &pmu->pmc[i];
> > -		if (pmc->perf_event) {
> > -			perf_event_enable(pmc->perf_event);
> > -			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > -				kvm_debug("fail to enable perf event\n");
> > -		}
> > +		kvm_pmu_enable_counter(vcpu, i);
> >   	}
> >   }
> >   /**
> > + * kvm_pmu_sync_counter_enable - reenable a counter if it should be enabled
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The counter index
> > + */
> > +static void kvm_pmu_sync_counter_enable(struct kvm_vcpu *vcpu,
> > +					    u64 select_idx)
> > +{
> > +	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> > +
> > +	if (set & BIT(select_idx))
> > +		kvm_pmu_enable_counter_mask(vcpu, BIT(select_idx));
> 
> I think there is a problem here. We could be creating an event for a
> counter beyond what is supported by the CPU. i.e, we don't
> seem to validate that the mask we are creating is within the
> kvm_pmu_valid_counter_mask(). The other callers seem to verify this.
> I guess it may be better to add a check for this in the
> kvm_pmu_enable_counter_mask().

Actually I think this is OK. This function is only called by
kvm_pmu_set_counter_event_type and kvm_pmu_set_counter_value - both these
functions are called from arch/arm64/kvm/sys_regs.c which ensures that
pmu_counter_idx_valid is true (which is same as kvm_pmu_valid_counter_mask).

This does become a problem in the next patch when we add chained counters
however we then add the check against kvm_pmu_valid_counter_mask (see
kvm_pmu_enable_counter_mask).

> 
> minor nit: Feel free to ignore. If we move the check for PMCNTENSET_EL0 to
> pmu_enable_counter_mask() we could get rid of the above function. Anyways,
> we should only be enabling the counters set in PMCNTENSET_EL0.
> 

This does seem acceptable, however the next patch adds a
kvm_pmu_sync_counter_pair function, which does add some additional value. So
whilst kvm_pmu_sync_counter_enable may seem redundant here it is built upon
later.

> 
> > +}
> > +
> > +/**
> > + * kvm_pmu_disable_counter - disable selected PMU counter
> > + * @vcpu: The vcpu pointer
> > + * @pmc: The counter to disable
> > + */
> > +static void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 select_idx)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > +
> > +	if (pmc->perf_event)
> > +		perf_event_disable(pmc->perf_event);
> > +}
> > +
> > +/**
> >    * kvm_pmu_disable_counter_mask - disable selected PMU counters
> >    * @vcpu: The vcpu pointer
> >    * @val: the value guest writes to PMCNTENCLR register
> > @@ -181,8 +226,6 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> >   void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> >   {
> >   	int i;
> > -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > -	struct kvm_pmc *pmc;
> >   	if (!val)
> >   		return;
> > @@ -191,9 +234,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
> >   		if (!(val & BIT(i)))
> >   			continue;
> > -		pmc = &pmu->pmc[i];
> > -		if (pmc->perf_event)
> > -			perf_event_disable(pmc->perf_event);
> > +		kvm_pmu_disable_counter(vcpu, i);
> >   	}
> >   }
> > @@ -375,16 +416,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
> >   	}
> >   }
> > -static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> > -{
> > -	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
> > -	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(select_idx));
> > -}
> > -
> >   /**
> > - * kvm_pmu_create_perf_event - create a perf event for a counter
> > + * kvm_pmu_counter_create_enabled_perf_event - create a perf event for a counter
> 
> nit: Name hasn't changed. Also, please could update that, the events are always
> created disabled and they are only enabled lazily.

Thanks,

Andrew Murray

> 
> Reset looks fines.
> 
> Suzuki
