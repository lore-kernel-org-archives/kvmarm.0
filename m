From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v12 4/8] arm64: arm_pmu: Add !VHE support for
 exclude_host/exclude_guest attributes
Date: Thu, 4 Apr 2019 20:48:44 +0100
Message-ID: <20190404194843.GR53702@e119886-lin.cambridge.arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
 <20190328103731.27264-5-andrew.murray@arm.com>
 <20190404163400.GA28903@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B0374A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 15:48:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oA9dG7un61UN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Apr 2019 15:48:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03BFB4A319
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Apr 2019 15:48:46 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20190404163400.GA28903@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 04, 2019 at 05:34:00PM +0100, Will Deacon wrote:
> On Thu, Mar 28, 2019 at 10:37:27AM +0000, Andrew Murray wrote:
> > Add support for the :G and :H attributes in perf by handling the
> > exclude_host/exclude_guest event attributes.
> > 
> > We notify KVM of counters that we wish to be enabled or disabled on
> > guest entry/exit and thus defer from starting or stopping events based
> > on their event attributes.
> > 
> > With !VHE we switch the counters between host/guest at EL2. We are able
> > to eliminate counters counting host events on the boundaries of guest
> > entry/exit when using :G by filtering out EL2 for exclude_host. When
> > using !exclude_hv there is a small blackout window at the guest
> > entry/exit where host events are not captured.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kernel/perf_event.c | 43 ++++++++++++++++++++++++++++------
> >  1 file changed, 36 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index cccf4fc86d67..6bb28aaf5aea 100644
> > --- a/arch/arm64/kernel/perf_event.c
> > +++ b/arch/arm64/kernel/perf_event.c
> > @@ -26,6 +26,7 @@
> >  
> >  #include <linux/acpi.h>
> >  #include <linux/clocksource.h>
> > +#include <linux/kvm_host.h>
> >  #include <linux/of.h>
> >  #include <linux/perf/arm_pmu.h>
> >  #include <linux/platform_device.h>
> > @@ -528,11 +529,21 @@ static inline int armv8pmu_enable_counter(int idx)
> >  
> >  static inline void armv8pmu_enable_event_counter(struct perf_event *event)
> >  {
> > +	struct perf_event_attr *attr = &event->attr;
> >  	int idx = event->hw.idx;
> > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> >  
> > -	armv8pmu_enable_counter(idx);
> >  	if (armv8pmu_event_is_chained(event))
> > -		armv8pmu_enable_counter(idx - 1);
> > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > +
> > +	kvm_set_pmu_events(counter_bits, attr);
> > +
> > +	/* We rely on the hypervisor switch code to enable guest counters */
> > +	if (!kvm_pmu_counter_deferred(attr)) {
> > +		armv8pmu_enable_counter(idx);
> > +		if (armv8pmu_event_is_chained(event))
> > +			armv8pmu_enable_counter(idx - 1);
> > +	}
> >  }
> >  
> >  static inline int armv8pmu_disable_counter(int idx)
> > @@ -545,11 +556,21 @@ static inline int armv8pmu_disable_counter(int idx)
> >  static inline void armv8pmu_disable_event_counter(struct perf_event *event)
> >  {
> >  	struct hw_perf_event *hwc = &event->hw;
> > +	struct perf_event_attr *attr = &event->attr;
> >  	int idx = hwc->idx;
> > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> >  
> >  	if (armv8pmu_event_is_chained(event))
> > -		armv8pmu_disable_counter(idx - 1);
> > -	armv8pmu_disable_counter(idx);
> > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > +
> > +	kvm_clr_pmu_events(counter_bits);
> > +
> > +	/* We rely on the hypervisor switch code to disable guest counters */
> > +	if (!kvm_pmu_counter_deferred(attr)) {
> > +		if (armv8pmu_event_is_chained(event))
> > +			armv8pmu_disable_counter(idx - 1);
> > +		armv8pmu_disable_counter(idx);
> > +	}
> >  }
> >  
> >  static inline int armv8pmu_enable_intens(int idx)
> > @@ -829,11 +850,16 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
> >  		if (!attr->exclude_kernel)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> >  	} else {
> > -		if (attr->exclude_kernel)
> > -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> > -		if (!attr->exclude_hv)
> > +		if (!attr->exclude_hv && !attr->exclude_host)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> 
> FWIW, that doesn't align with my personal view of what the host is, but
> I'm not going to argue if Marc and Christoffer are happy with it.

Ideally armv8pmu_set_event_filter needs no knowledge of exclude_guest
and exclude_host as we leave the config_base alone and instead rely on
turning the counters on/off at guest entry/exit...

The addition of "&& !attr->exclude_host" here (!VHE) and likewise for VHE in
"arm64: KVM: Enable VHE support for :G/:H perf event modifiers" (in case
you missed it) is to eliminate counters counting host events on the boundaries
of guest entry/exit when counting for guest_only (:G). Thus this is really
an optimisation for more accurate counting.

Consider the case where a user wants to record guest events only - we switch
over to the guest counters at EL2 on world-switch (both VHE and !VHE host) -
now there is a small period of time between when we start the guest counters
and when we actually jump into the guest. This period of time in the host
shouldn't be counted - therefore so long as exclude_host is set we can filter
EL2 to remove these unwanted counts.

Therefore the above hunks likely won't describe what our view of the host is.

> 
> Anyway, thanks for persevering with this:

It's fun even though it hurts my head every time each time I come back to this.

> 
> Acked-by: Will Deacon <will.deacon@arm.com>

Thanks,

Andrew Murray

> 
> Will
