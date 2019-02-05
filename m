From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 3/5] KVM: arm/arm64: re-create event when setting
 counter value
Date: Tue, 5 Feb 2019 12:27:04 +0000
Message-ID: <20190205122704.GB33475@e119886-lin.cambridge.arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-4-git-send-email-andrew.murray@arm.com>
 <00ead646-aec6-deff-2dc3-7cb0e253a57c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CD74A2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 07:27:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ND5h7O1ECEhi for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Feb 2019 07:27:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C634A214
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 07:27:07 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <00ead646-aec6-deff-2dc3-7cb0e253a57c@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 05, 2019 at 12:21:25PM +0000, Julien Thierry wrote:
> Hi Andrew,
> 
> On 04/02/2019 16:53, Andrew Murray wrote:
> > The perf event sample_period is currently set based upon the current
> > counter value, when PMXEVTYPER is written to and the perf event is created.
> > However the user may choose to write the type before the counter value in
> > which case sample_period will be set incorrectly. Let's instead decouple
> > event creation from PMXEVTYPER and (re)create the event in either
> > suitation.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  virt/kvm/arm/pmu.c | 40 +++++++++++++++++++++++++++++++---------
> >  1 file changed, 31 insertions(+), 9 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index 6e7c179..95d74ec 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -24,6 +24,7 @@
> >  #include <kvm/arm_pmu.h>
> >  #include <kvm/arm_vgic.h>
> >  
> > +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> >  /**
> >   * kvm_pmu_get_counter_value - get PMU counter value
> >   * @vcpu: The vcpu pointer
> > @@ -62,6 +63,9 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
> >  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> >  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> >  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> > +
> > +	/* Recreate the perf event to reflect the updated sample_period */
> > +	kvm_pmu_create_perf_event(vcpu, select_idx);
> >  }
> >  
> >  /**
> > @@ -378,23 +382,22 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
> >  }
> >  
> >  /**
> > - * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> > + * kvm_pmu_create_perf_event - create a perf event for a counter
> >   * @vcpu: The vcpu pointer
> > - * @data: The data guest writes to PMXEVTYPER_EL0
> > + * @data: Type of event as per PMXEVTYPER_EL0 format
> >   * @select_idx: The number of selected counter
> > - *
> > - * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> > - * event with given hardware event number. Here we call perf_event API to
> > - * emulate this action and create a kernel perf event for it.
> >   */
> > -void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> > -				    u64 select_idx)
> > +static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
> >  {
> >  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >  	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >  	struct perf_event *event;
> >  	struct perf_event_attr attr;
> > -	u64 eventsel, counter;
> > +	u64 eventsel, counter, reg, data;
> > +
> > +	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> > +	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> > +	data = __vcpu_sys_reg(vcpu, reg);
> >  
> >  	kvm_pmu_stop_counter(vcpu, pmc);
> >  	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
> > @@ -431,6 +434,25 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> >  	pmc->perf_event = event;
> >  }
> >  
> > +/**
> > + * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> > + * @vcpu: The vcpu pointer
> > + * @data: The data guest writes to PMXEVTYPER_EL0
> > + * @select_idx: The number of selected counter
> > + *
> > + * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> > + * event with given hardware event number. Here we call perf_event API to
> > + * emulate this action and create a kernel perf event for it.
> > + */
> > +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> > +				    u64 select_idx)
> > +{
> > +	u64 event_type = data & ARMV8_PMU_EVTYPE_MASK;
> > +> +	__vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + select_idx) = event_type;
> 
> I think there has been a wrong split. In the next patch you add the
> check for the cycle counter but I believe it should be already present here.
> 
> With that fixed:
> 
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Thanks for spotting this and for the review.

Thanks,

Andrew Murray

> 
> > +	kvm_pmu_create_perf_event(vcpu, select_idx);
> > +}
> > +
> >  bool kvm_arm_support_pmu_v3(void)
> >  {
> >  	/*
> > 
> 
> -- 
> Julien Thierry
