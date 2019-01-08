From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v8 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 8 Jan 2019 13:14:25 +0100
Message-ID: <20190108121425.GO10769@e113682-lin.lund.arm.com>
References: <1544610573-28446-1-git-send-email-andrew.murray@arm.com>
 <1544610573-28446-5-git-send-email-andrew.murray@arm.com>
 <20181218120226.GC25383@e113682-lin.lund.arm.com>
 <20190104153205.GA31479@edgewater-inn.cambridge.arm.com>
 <20190108101843.GH10769@e113682-lin.lund.arm.com>
 <20190108112512.GA56789@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 087044A44D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 07:14:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PDDoEV5pGAzr for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jan 2019 07:14:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2FE4A43F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 07:14:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190108112512.GA56789@e119886-lin.cambridge.arm.com>
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

On Tue, Jan 08, 2019 at 11:25:13AM +0000, Andrew Murray wrote:
> On Tue, Jan 08, 2019 at 11:18:43AM +0100, Christoffer Dall wrote:
> > On Fri, Jan 04, 2019 at 03:32:06PM +0000, Will Deacon wrote:
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
> > > 
> > > FWIW, that comment came from this thread:
> > > 
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2017-April/503908.html
> > > 
> > > That was painful enough at the time, so I'd /really/ prefer not to change
> > > the semantics of this again if we can avoid it.
> > 
> > The comment makes sense for the is_kernel_in_hyp_mode() case.
> > 
> > However, for the !is_kernel_in_hyp_mode() case I can't see the current
> > behavior of exclude_hv being similar in other architectures.
> > 
> > I don't think the current semantics of excluding EL2 on a non-VHE host
> > system makes much sense, and I doubt anyone is using that for something
> > meaningful.  I think changing behavior for excldue_hv to depend on
> > is_hyp_mode_available rather than is_kernel_in_hyp_mode is the right
> > thing to do which would also align the semantics with other
> > architectures and between VHE and non-VHE.
> 
> Just for clarity, see below for the proposed patch - this disallows EL2
> counting for !VHE when we have the capability to be a KVM host.
> 

That was not what I meant.  I think you want to count EL1 and EL2
together on a non-VHE host system.

What I had in mind was more
something like the following (completely untested, of course):

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index e213f8e867f6..37648bedf8b0 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -948,6 +948,11 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	if (is_kernel_in_hyp_mode()) {
 		if (!attr->exclude_kernel)
 			config_base |= ARMV8_PMU_INCLUDE_EL2;
+	} else if (is_hyp_mode_available()) {
+		if (attr->exclude_kernel)
+			config_base |= ARMV8_PMU_EXCLUDE_EL1;
+		else
+			config_base |= ARMV8_PMU_INCLUDE_EL2;
 	} else {
 		if (attr->exclude_kernel)
 			config_base |= ARMV8_PMU_EXCLUDE_EL1;


Thanks,

    Christoffer
