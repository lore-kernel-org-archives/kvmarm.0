From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v8 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 18 Dec 2018 13:25:32 +0000
Message-ID: <20181218132531.GF47018@e119886-lin.cambridge.arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-5-git-send-email-andrew.murray@arm.com>
 <20181218120226.GC25383@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A2784A2E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Dec 2018 08:25:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0TE3eQ7jso5D for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Dec 2018 08:25:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EE104A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Dec 2018 08:25:36 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181218120226.GC25383@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, joro@8bytes.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 18, 2018 at 01:02:26PM +0100, Christoffer Dall wrote:
> On Wed, Dec 12, 2018 at 10:29:32AM +0000, Andrew Murray wrote:
> > Add support for the :G and :H attributes in perf by handling the
> > exclude_host/exclude_guest event attributes.
> > 
> > We notify KVM of counters that we wish to be enabled or disabled on
> > guest entry/exit and thus defer from starting or stopping :G events
> > as per the events exclude_host attribute.
> > 
> > With both VHE and non-VHE we switch the counters between host/guest
> > at EL2. We are able to eliminate counters counting host events on
> > the boundaries of guest entry/exit when using :G by filtering out
> > EL2 for exclude_host. However when using :H unless exclude_hv is set
> > on non-VHE then there is a small blackout window at the guest
> > entry/exit where host events are not captured.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kernel/perf_event.c | 51 ++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 44 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index de564ae..4a3c73d 100644
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
> > @@ -647,11 +648,26 @@ static inline int armv8pmu_enable_counter(int idx)
> >  
> >  static inline void armv8pmu_enable_event_counter(struct perf_event *event)
> >  {
> > +	struct perf_event_attr *attr = &event->attr;
> >  	int idx = event->hw.idx;
> > +	int flags = 0;
> > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> >  
> > -	armv8pmu_enable_counter(idx);
> >  	if (armv8pmu_event_is_chained(event))
> > -		armv8pmu_enable_counter(idx - 1);
> > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > +
> > +	if (!attr->exclude_host)
> > +		flags |= KVM_PMU_EVENTS_HOST;
> > +	if (!attr->exclude_guest)
> > +		flags |= KVM_PMU_EVENTS_GUEST;
> > +
> > +	kvm_set_pmu_events(counter_bits, flags);
> > +
> > +	if (!attr->exclude_host) {
> > +		armv8pmu_enable_counter(idx);
> > +		if (armv8pmu_event_is_chained(event))
> > +			armv8pmu_enable_counter(idx - 1);
> > +	}
> >  }
> >  
> >  static inline int armv8pmu_disable_counter(int idx)
> > @@ -664,11 +680,20 @@ static inline int armv8pmu_disable_counter(int idx)
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
> > +	if (!attr->exclude_host) {
> > +		if (armv8pmu_event_is_chained(event))
> > +			armv8pmu_disable_counter(idx - 1);
> > +		armv8pmu_disable_counter(idx);
> > +	}
> >  }
> >  
> >  static inline int armv8pmu_enable_intens(int idx)
> > @@ -943,16 +968,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
> >  	 * Therefore we ignore exclude_hv in this configuration, since
> >  	 * there's no hypervisor to sample anyway. This is consistent
> >  	 * with other architectures (x86 and Power).
> > +	 *
> > +	 * To eliminate counting host events on the boundaries of
> > +	 * guest entry/exit we ensure EL2 is not included in hyp mode
> > +	 * with !exclude_host.
> >  	 */
> >  	if (is_kernel_in_hyp_mode()) {
> > -		if (!attr->exclude_kernel)
> > +		if (!attr->exclude_kernel && !attr->exclude_host)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> >  	} else {
> > -		if (attr->exclude_kernel)
> > -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> >  		if (!attr->exclude_hv)
> >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> 
> I'm not sure about the current use of exclude_hv here.  The comment says
> it's consistent with other architectures, but I can't find an example to
> confirm this, and I don't think we have a comparable thing to the split
> of the hypervisor between EL1 and EL2 we have on non-VHE.
> 
> Joerg told me the semantics were designed to be:
> 
> 	exclude_hv: When running as a guest, stop counting events when
> 		    the HV runs.

Can the definition of "guest" here refer to both type 1 and type 2
hypervisor guests? Or do we assume type 1 only?

> 
> 	exclude_host: When Linux runs as a HV itself, only count events
> 	              while a guest is running.
> 
> 	exclude_guest: When Linux runs as a HV, only count events when
> 	               running in host mode.
> 
> (But tools/perf/design.txt does not really confirm this).
> 
> On arm64 that would mean:
> 
> 	exclude_hv: As a host, no effect.
> 		    As a guest, set the counter to include EL2 for a
> 		    hypervisor to emulate.

If guest means either type 1 or type 2 guest, then we allow KVM guests
to understand their individual HV overhead. We can do this by counting
EL2 events whilst pinned to the KVM task.

Though more correctly we should count EL2 *and EL1* events whilst pinned
to the KVM task and whilst running outside of the guest. This then
covers both !VHE and VHE and allows for fair comparasion between !VHE
and VHE systems.

This then gives us the unique benefit of the type 2 host being able to
examine the hypervisor overhead of its individual guests.

The only issue here is that the type 2 host wouldn't be able to examine
the HV overhead of all its guests across the system as you wouldn't be
able to rely on the perf task pinning to distinguish between EL1 from
host and EL1 from guests in a !VHE system. I'm not sure the best way
to overcome this limitation.

> 
> 	exclude_host: As a guest, has no effect.
> 		      Don't count EL1 host or EL2, but count EL1 guest
> 		      by enabling EL1 counting at EL2 when entering a
> 		      guest, and disabling EL1 counting when returning
> 		      from a guest.
> 
> 	exclude_guest: As a guest, has no effect.  As a host, disable
> 		       EL1 counting at EL2 when entering a guest.
> 
> Not sure if we break anything by changing the behavior on arm64 now, but
> I really doubt that being able to exclude an arbitrary part (the one tha
> happens to run in EL2 on non-VHE systems) is meaningful, and the fact
> that behavior and semantics change depending on the version of the
> underlying CPU is not great, if what you care about is understanding the
> system's performance.

This is a bit strange. It's arbitary as it only represents a bit of the
HV overhead - this is solved though by counting the whole overhead (EL1
and EL2 instead (but only counting outside the guest and pinned to the
guest tasks).

> 
> Thoughts?
> 

Though if I've understood you correctly, you're suggesting that the only
time we count EL2 is when exclude_hv is not set on the immediate guest
of a type 1 hypervisor?

Thanks,

Andrew Murray

> 
> Thanks,
> 
>     Christoffer
