From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v8 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 18 Dec 2018 19:51:21 +0100
Message-ID: <20181218185121.GE25383@e113682-lin.lund.arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-5-git-send-email-andrew.murray@arm.com>
 <20181218120226.GC25383@e113682-lin.lund.arm.com>
 <20181218132531.GF47018@e119886-lin.cambridge.arm.com>
 <20181218143833.GD25383@e113682-lin.lund.arm.com>
 <20181218162705.GG47018@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50BF64A2BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Dec 2018 13:51:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R8-hAiGW7V6v for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Dec 2018 13:51:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FB734A2BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Dec 2018 13:51:25 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181218162705.GG47018@e119886-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, joro@8bytes.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 18, 2018 at 04:27:05PM +0000, Andrew Murray wrote:
> On Tue, Dec 18, 2018 at 03:38:33PM +0100, Christoffer Dall wrote:
> > On Tue, Dec 18, 2018 at 01:25:32PM +0000, Andrew Murray wrote:
> > > On Tue, Dec 18, 2018 at 01:02:26PM +0100, Christoffer Dall wrote:
> > > > On Wed, Dec 12, 2018 at 10:29:32AM +0000, Andrew Murray wrote:
> > > > > Add support for the :G and :H attributes in perf by handling the
> > > > > exclude_host/exclude_guest event attributes.
> > > > > 
> > > > > We notify KVM of counters that we wish to be enabled or disabled on
> > > > > guest entry/exit and thus defer from starting or stopping :G events
> > > > > as per the events exclude_host attribute.
> > > > > 
> > > > > With both VHE and non-VHE we switch the counters between host/guest
> > > > > at EL2. We are able to eliminate counters counting host events on
> > > > > the boundaries of guest entry/exit when using :G by filtering out
> > > > > EL2 for exclude_host. However when using :H unless exclude_hv is set
> > > > > on non-VHE then there is a small blackout window at the guest
> > > > > entry/exit where host events are not captured.
> > > > > 
> > > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > > ---
> > > > >  arch/arm64/kernel/perf_event.c | 51 ++++++++++++++++++++++++++++++++++++------
> > > > >  1 file changed, 44 insertions(+), 7 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > > > > index de564ae..4a3c73d 100644
> > > > > --- a/arch/arm64/kernel/perf_event.c
> > > > > +++ b/arch/arm64/kernel/perf_event.c
> > > > > @@ -26,6 +26,7 @@
> > > > >  
> > > > >  #include <linux/acpi.h>
> > > > >  #include <linux/clocksource.h>
> > > > > +#include <linux/kvm_host.h>
> > > > >  #include <linux/of.h>
> > > > >  #include <linux/perf/arm_pmu.h>
> > > > >  #include <linux/platform_device.h>
> > > > > @@ -647,11 +648,26 @@ static inline int armv8pmu_enable_counter(int idx)
> > > > >  
> > > > >  static inline void armv8pmu_enable_event_counter(struct perf_event *event)
> > > > >  {
> > > > > +	struct perf_event_attr *attr = &event->attr;
> > > > >  	int idx = event->hw.idx;
> > > > > +	int flags = 0;
> > > > > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> > > > >  
> > > > > -	armv8pmu_enable_counter(idx);
> > > > >  	if (armv8pmu_event_is_chained(event))
> > > > > -		armv8pmu_enable_counter(idx - 1);
> > > > > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > > > > +
> > > > > +	if (!attr->exclude_host)
> > > > > +		flags |= KVM_PMU_EVENTS_HOST;
> > > > > +	if (!attr->exclude_guest)
> > > > > +		flags |= KVM_PMU_EVENTS_GUEST;
> > > > > +
> > > > > +	kvm_set_pmu_events(counter_bits, flags);
> > > > > +
> > > > > +	if (!attr->exclude_host) {
> > > > > +		armv8pmu_enable_counter(idx);
> > > > > +		if (armv8pmu_event_is_chained(event))
> > > > > +			armv8pmu_enable_counter(idx - 1);
> > > > > +	}
> > > > >  }
> > > > >  
> > > > >  static inline int armv8pmu_disable_counter(int idx)
> > > > > @@ -664,11 +680,20 @@ static inline int armv8pmu_disable_counter(int idx)
> > > > >  static inline void armv8pmu_disable_event_counter(struct perf_event *event)
> > > > >  {
> > > > >  	struct hw_perf_event *hwc = &event->hw;
> > > > > +	struct perf_event_attr *attr = &event->attr;
> > > > >  	int idx = hwc->idx;
> > > > > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> > > > >  
> > > > >  	if (armv8pmu_event_is_chained(event))
> > > > > -		armv8pmu_disable_counter(idx - 1);
> > > > > -	armv8pmu_disable_counter(idx);
> > > > > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > > > > +
> > > > > +	kvm_clr_pmu_events(counter_bits);
> > > > > +
> > > > > +	if (!attr->exclude_host) {
> > > > > +		if (armv8pmu_event_is_chained(event))
> > > > > +			armv8pmu_disable_counter(idx - 1);
> > > > > +		armv8pmu_disable_counter(idx);
> > > > > +	}
> > > > >  }
> > > > >  
> > > > >  static inline int armv8pmu_enable_intens(int idx)
> > > > > @@ -943,16 +968,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
> > > > >  	 * Therefore we ignore exclude_hv in this configuration, since
> > > > >  	 * there's no hypervisor to sample anyway. This is consistent
> > > > >  	 * with other architectures (x86 and Power).
> > > > > +	 *
> > > > > +	 * To eliminate counting host events on the boundaries of
> > > > > +	 * guest entry/exit we ensure EL2 is not included in hyp mode
> > > > > +	 * with !exclude_host.
> > > > >  	 */
> > > > >  	if (is_kernel_in_hyp_mode()) {
> > > > > -		if (!attr->exclude_kernel)
> > > > > +		if (!attr->exclude_kernel && !attr->exclude_host)
> > > > >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > > > >  	} else {
> > > > > -		if (attr->exclude_kernel)
> > > > > -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> > > > >  		if (!attr->exclude_hv)
> > > > >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > > > 
> > > > I'm not sure about the current use of exclude_hv here.  The comment says
> > > > it's consistent with other architectures, but I can't find an example to
> > > > confirm this, and I don't think we have a comparable thing to the split
> > > > of the hypervisor between EL1 and EL2 we have on non-VHE.
> > > > 
> > > > Joerg told me the semantics were designed to be:
> > > > 
> > > > 	exclude_hv: When running as a guest, stop counting events when
> > > > 		    the HV runs.
> > > 
> > > Can the definition of "guest" here refer to both type 1 and type 2
> > > hypervisor guests? Or do we assume type 1 only?
> > > 
> > 
> > A guest is a guest.  Linux can run as a guest under a hypervisor with a
> > type 1 or type 2 design, doesn't matter for this conversation.
> > 
> > > > 
> > > > 	exclude_host: When Linux runs as a HV itself, only count events
> > > > 	              while a guest is running.
> > > > 
> > > > 	exclude_guest: When Linux runs as a HV, only count events when
> > > > 	               running in host mode.
> > > > 
> > > > (But tools/perf/design.txt does not really confirm this).
> > > > 
> > > > On arm64 that would mean:
> > > > 
> > > > 	exclude_hv: As a host, no effect.
> > > > 		    As a guest, set the counter to include EL2 for a
> > > > 		    hypervisor to emulate.
> > 
> > [...]
> > 
> > > 
> > > Though more correctly we should count EL2 *and EL1* events whilst pinned
> > > to the KVM task and whilst running outside of the guest.  This then
> > > covers both !VHE and VHE and allows for fair comparasion between !VHE
> > > and VHE systems.
> > 
> > Yes, if the guest has cleared exclude_hv and if we can properly detect
> > that from the hypervisor.
> > 
> > > 
> > > This then gives us the unique benefit of the type 2 host being able to
> > > examine the hypervisor overhead of its individual guests.
> > 
> > Not sure I understand this part.
> 
> I got a bit confused here so ignore this. (I thought it would be useful to
> measure from the KVM host perspective, the host-only time of the KVM guest,
> which I incorrectly thought could also be the exclude_hv flag. Though I
> forgot that 'perf stat -e instructions:H kvmtask' from the host should be
> equivalent to 'perf stat -e instructions:h' from the guest.)
> 
> > 
> > > 
> > > The only issue here is that the type 2 host wouldn't be able to examine
> > > the HV overhead of all its guests across the system as you wouldn't be
> > > able to rely on the perf task pinning to distinguish between EL1 from
> > > host and EL1 from guests in a !VHE system. I'm not sure the best way
> > > to overcome this limitation.
> > 
> > Why can't you disable EL1 counting whilst running in the host, and
> > enable EL1 counting whilst running in the guest?
> 
> You can. (I was assuming you could use exclude_hv from KVM host to measure
> all the KVM guest overheads - but you would need to know which tasks are
> KVM tasks such that you can consider their EL1 time - again ignore this).
> 
> > 
> > > > 
> > > > 	exclude_host: As a guest, has no effect.
> > > > 		      Don't count EL1 host or EL2, but count EL1 guest
> > > > 		      by enabling EL1 counting at EL2 when entering a
> > > > 		      guest, and disabling EL1 counting when returning
> > > > 		      from a guest.
> > > > 
> > > > 	exclude_guest: As a guest, has no effect.  As a host, disable
> > > > 		       EL1 counting at EL2 when entering a guest.
> > > > 
> > > > Not sure if we break anything by changing the behavior on arm64 now, but
> > > > I really doubt that being able to exclude an arbitrary part (the one tha
> > > > happens to run in EL2 on non-VHE systems) is meaningful, and the fact
> > > > that behavior and semantics change depending on the version of the
> > > > underlying CPU is not great, if what you care about is understanding the
> > > > system's performance.
> > > 
> > > This is a bit strange. It's arbitary as it only represents a bit of the
> > > HV overhead - this is solved though by counting the whole overhead (EL1
> > > and EL2 instead (but only counting outside the guest and pinned to the
> > > guest tasks).
> > 
> > Not sure I understand your point here?
> 
> I was considering how we support exclude_hv from a KVM guest. If we count
> only EL2 for HV then we are not measuring the true overhead, we also need
> to include the EL1 time from the KVM host process when on !VHE.
> 
> 
> > 
> > > 
> > > > 
> > > > Thoughts?
> > > > 
> > > 
> > > Though if I've understood you correctly, you're suggesting that the only
> > > time we count EL2 is when exclude_hv is not set on the immediate guest
> > > of a type 1 hypervisor?
> > > 
> > No, I didn't say anything about a type 1 or type 2 hypervisor, and I
> > think that distinction is completely irrelevant to the discussion at
> > hand.  I also don't know what an immediate guest is -- is there any
> > other kind?
> 
> An immediate guest = the host's guest but not a guest-guest or further
> (Apologies if I'm making this up as I go along).
> 

I strongly recommend thinking about this in terms of a single
hypervisor, which can run a single layer of guests (no nested
virtualization) first.  Once we've figured out how to do that, we can
try to think about nested virt, and factor in PMU emulation among the
great many things that will break with nested virtualization.

> > 
> > I don't think exclude_hv, exclude_host, and exclude_guest are directly
> > tied to a single CPU mode.  The only 'modes' you need to consider for
> > Linux are 'guest' and 'host' when Linux can run VMs and, 'self' and
> > 'hypervisor' when Linux is a guest.
> > 
> > When Linux can run VMs, you count EL2 events when exclude_host is not
> > set.
> > 
> > (When Linux is a guest, and you set/clear exclude_hv, for this to work,
> > you need some way of informing your hypervisor that you want to know
> > about events happening in the hypervisor.  This could be a PV interface,
> > or maybe this can work by the guest setting/clearing the NSH bit in its
> > virtual PMU registers, which then amusingly can get translated into
> > actually counting in EL1/EL2 (non-VHE) or EL2 (VHE) by KVM's PMU
> > emulation code.  The method used is specific to the hypervisor used, but
> > not specific to whether the hypervisor is type-1 or type-2.)
> 
> This is what I had in mind. I think we're aligned despite nomenclature
> confusing me.
> 
> I think we need to:
> 
>  - Add support in KVM guests for exclude_hv.
> 
>  - Prevent !exclude_hv from returning a count when is is not a guest
>    on a !VHE kernel.
> 
> I'm not really clear how we implement the second point. We want to count
> EL2 (because that would represent a HV) but only when it is a guest. How
> does it know it's a guest? (Is it a guest when it's not a KVM host?).
> I'm struggling to see how we update the logic in armv8pmu_set_event_filter
> (whilst keeping in mind that we want it to write ARMV8_PMU_INCLUDE_EL2
> such that when it's a guest the KVM PMU emulation code can use that to
> know to do something different).
> 

If (!hyp_mode_is_available()) you are either running bare metal or as a
guest.  It should be benign to program the PMU to count EL2 in both
cases, as it should have no effect in the first case.  Alternatively we
could make it so that it only makes a difference if the DT/ACPI
describes the fact that you're a KVM guest.  I don't know the
implementation details of that.


Thanks,

    Christoffer
