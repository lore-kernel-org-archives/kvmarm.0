From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v8 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Wed, 12 Dec 2018 14:38:23 +0000
Message-ID: <20181212143823.GA48249@e119886-lin.cambridge.arm.com>
References: <1544610573-28446-5-git-send-email-andrew.murray@arm.com>
 <f370a0fe-4a91-7e14-a7a5-aba25d0e7e52@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5005A4A1DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 09:38:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SQ5EQi1ztoeD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Dec 2018 09:38:27 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 168814A1DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Dec 2018 09:38:27 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <f370a0fe-4a91-7e14-a7a5-aba25d0e7e52@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 12, 2018 at 10:55:33AM +0000, Suzuki K Poulose wrote:
> 
> 
> On 12/12/2018 10:29, Andrew Murray wrote:
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
> >   arch/arm64/kernel/perf_event.c | 51 ++++++++++++++++++++++++++++++++++++------
> >   1 file changed, 44 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > index de564ae..4a3c73d 100644
> > --- a/arch/arm64/kernel/perf_event.c
> > +++ b/arch/arm64/kernel/perf_event.c
> > @@ -26,6 +26,7 @@
> >   #include <linux/acpi.h>
> >   #include <linux/clocksource.h>
> > +#include <linux/kvm_host.h>
> >   #include <linux/of.h>
> >   #include <linux/perf/arm_pmu.h>
> >   #include <linux/platform_device.h>
> > @@ -647,11 +648,26 @@ static inline int armv8pmu_enable_counter(int idx)
> >   static inline void armv8pmu_enable_event_counter(struct perf_event *event)
> >   {
> > +	struct perf_event_attr *attr = &event->attr;
> >   	int idx = event->hw.idx;
> > +	int flags = 0;
> > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> > -	armv8pmu_enable_counter(idx);
> >   	if (armv8pmu_event_is_chained(event))
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
> >   }
> >   static inline int armv8pmu_disable_counter(int idx)
> > @@ -664,11 +680,20 @@ static inline int armv8pmu_disable_counter(int idx)
> >   static inline void armv8pmu_disable_event_counter(struct perf_event *event)
> >   {
> >   	struct hw_perf_event *hwc = &event->hw;
> > +	struct perf_event_attr *attr = &event->attr;
> >   	int idx = hwc->idx;
> > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> >   	if (armv8pmu_event_is_chained(event))
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
> 
> It may be helpful to add in a comment why we do this only for !exclude_host.
> 
> Either way,

No problem, I'll add the comments.

> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
