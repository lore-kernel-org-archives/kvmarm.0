From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH 3/4] KVM: arm/arm64: lazily create perf events on enable
Date: Mon, 28 Jan 2019 14:28:38 +0000
Message-ID: <20190128142838.GB16627@e119886-lin.cambridge.arm.com>
References: <1548154197-5470-1-git-send-email-andrew.murray@arm.com>
 <1548154197-5470-4-git-send-email-andrew.murray@arm.com>
 <82bb5635-0bca-8326-03e1-084792dd939d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35A974A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 09:28:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LHgRwzO2rqh8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Jan 2019 09:28:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C00D14A2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Jan 2019 09:28:41 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <82bb5635-0bca-8326-03e1-084792dd939d@arm.com>
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

On Tue, Jan 22, 2019 at 10:12:22PM +0000, Suzuki K Poulose wrote:
> Hi Andrew,
> 
> On 01/22/2019 10:49 AM, Andrew Murray wrote:
> > To prevent re-creating perf events everytime the counter registers
> > are changed, let's instead lazily create the event when the event
> > is first enabled and destroy it when it changes.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> 
> 
> > ---
> >   virt/kvm/arm/pmu.c | 114 ++++++++++++++++++++++++++++++++++++-----------------
> >   1 file changed, 78 insertions(+), 36 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index 4464899..1921ca9 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -24,8 +24,11 @@
> >   #include <kvm/arm_pmu.h>
> >   #include <kvm/arm_vgic.h>
> > -static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 data,
> > -				      u64 select_idx);
> > +static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu, u64 pair);
> 
> I find the approach good. However the function names are a bit odd and
> it makes the code read a bit difficult.

Thanks - the odd naming probably came about as I started with a patch that
added chained PMU support and worked backward to split it into smaller patches
that each made individual sense. The _single suffix was the counterpart of
_pair.

> 
> I think we could :
> 
> 1) Rename the existing
>  kvm_pmu_{enable/disable}_counter => kvm_pmu_{enable/disable}_[mask or
> counters ]
> as they operate on a set of counters (as a mask) instead of a single
> counter.
> And then you may be able to drop "_single" from
> kvm_pmu_{enable/disable}_counter"_single() functions below, which makes
> better sense for what they do.

Thanks for this suggestion. I like this.

> 
> > +static void kvm_pmu_counter_create_enabled_perf_event(struct kvm_vcpu *vcpu,
> > +						      u64 select_idx);
> 
> Could we simply keep kvm_pmu_counter_create_event() and add a comment above
> the function explaining that the events are enabled as they are
> created lazily ?

OK.

> 
> > +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> > +
> >   /**
> >    * kvm_pmu_get_counter_value - get PMU counter value
> >    * @vcpu: The vcpu pointer
> > @@ -59,18 +62,16 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> >    */
> >   void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> >   {
> > -	u64 reg, data;
> > +	u64 reg;
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >   	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> >   	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> >   	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> > -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> > -	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> > -	data = __vcpu_sys_reg(vcpu, reg + select_idx);
> > -
> > -	/* Recreate the perf event to reflect the updated sample_period */
> > -	kvm_pmu_create_perf_event(vcpu, data, select_idx);
> > +	kvm_pmu_stop_counter(vcpu, pmc);
> > +	kvm_pmu_reenable_enabled_single(vcpu, select_idx);
> >   }
> >   /**
> > @@ -88,6 +89,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
> >   /**
> >    * kvm_pmu_stop_counter - stop PMU counter
> > + * @vcpu: The vcpu pointer
> >    * @pmc: The PMU counter pointer
> >    *
> >    * If this counter has been configured to monitor some event, release it here.
> > @@ -150,6 +152,25 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> >   }
> >   /**
> > + * kvm_pmu_enable_counter_single - create/enable a unpaired counter
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The counter index
> > + */
> > +static void kvm_pmu_enable_counter_single(struct kvm_vcpu *vcpu, u64 select_idx)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > +
> > +	if (!pmc->perf_event) {
> > +		kvm_pmu_counter_create_enabled_perf_event(vcpu, select_idx);
> > +	} else if (pmc->perf_event) {
> > +		perf_event_enable(pmc->perf_event);
> > +		if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > +			kvm_debug("fail to enable perf event\n");
> 
> nit: failed
> 
> > +	}
> > +}
> > +
> > +/**
> >    * kvm_pmu_enable_counter - enable selected PMU counter
> 
> nit: This is a bit misleading. We could be enabling a set of counters.
> Please could we update the comment.

No problem.

> 
> >    * @vcpu: The vcpu pointer
> >    * @val: the value guest writes to PMCNTENSET register
> > @@ -159,8 +180,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> >   void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
> >   {
> >   	int i;
> > -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > -	struct kvm_pmc *pmc;
> >   	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
> >   		return;
> > @@ -169,16 +188,44 @@ void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
> >   		if (!(val & BIT(i)))
> >   			continue;
> > -		pmc = &pmu->pmc[i];
> > -		if (pmc->perf_event) {
> > -			perf_event_enable(pmc->perf_event);
> > -			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> > -				kvm_debug("fail to enable perf event\n");
> > -		}
> > +		kvm_pmu_enable_counter_single(vcpu, i);
> >   	}
> >   }
> >   /**
> > + * kvm_pmu_reenable_enabled_single - reenable a counter if it should be enabled
> > + * @vcpu: The vcpu pointer
> > + * @select_idx: The counter index
> > + */
> > +static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu,
> > +					    u64 select_idx)
> > +{
> > +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> > +	u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> > +
> > +	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> > +		return;
> > +
> > +	if (set & BIT(select_idx))
> > +		kvm_pmu_enable_counter_single(vcpu, select_idx);
> 
> Could we not reuse kvm_pmu_enable_counter() here :
> 	i.e,
> static inline void kvm_pmu_reenable_counter(struct kvm_vcpu *vcpu, u64
> 						select_idx)
> {
> 	kvm_pmu_enable_counter(vcpu, BIT(select_idx));
> }
> 

Not quite - when we call kvm_pmu_reenable_enabled_single the individual
counter may or may not be enabled. We only want to recreate the perf event
if it was previously enabled.

But we can do better, e.g.

static void kvm_pmu_reenable_enabled_single(struct kvm_vcpu *vcpu,
                                            u64 select_idx)
{
        u64 set = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);

        if (set & BIT(select_idx))
                kvm_pmu_enable_counter_mask(vcpu, BIT(select_idx));
}

(The kvm_pmu_valid_counter_mask also wasn't needed here, but is needed
later when we may attempt to enable a counter that we don't have).

> > +}
> > +
> > +/**
> > + * kvm_pmu_disable_counter - disable selected PMU counter
> 
> Stale comment
> 
> > + * @vcpu: The vcpu pointer
> > + * @pmc: The counter to dissable
> 
> nit: s/dissable/disable/
> 
> > + */
> > +static void kvm_pmu_disable_counter_single(struct kvm_vcpu *vcpu,
> > +					   u64 select_idx)
> > +{
> > +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> > +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> > +
> > +	if (pmc->perf_event)
> > +		perf_event_disable(pmc->perf_event);
> > +}
> > +
> > +/**
> >    * kvm_pmu_disable_counter - disable selected PMU counter
> 
> While you are at this, please could you make the comment a bit more
> clear. i.e, we disable a set of PMU counters not a single one.

Yes sure.

Thanks for the review.

Andrew Murray

> 
> Suzuki
