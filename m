From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 3/4] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Mon, 3 Dec 2018 15:04:14 +0000
Message-ID: <20181203150413.GA27232@arm.com>
References: <1542885950-23816-1-git-send-email-andrew.murray@arm.com>
 <1542885950-23816-4-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB7394A200
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 10:03:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GCVslgqLC01k for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 10:03:55 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28E8B4A1DE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 10:03:55 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1542885950-23816-4-git-send-email-andrew.murray@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On Thu, Nov 22, 2018 at 11:25:49AM +0000, Andrew Murray wrote:
> Add support for the :G and :H attributes in perf by handling the
> exclude_host/exclude_guest event attributes.
> 
> We notify KVM of counters that we wish to be enabled or disabled on
> guest entry/exit and thus defer from starting or stopping :G events
> as per the events exclude_host attribute.
> 
> With both VHE and non-VHE we switch the counters between host/guest
> at EL2. We are able to eliminate counters counting host events on
> the boundaries of guest entry/exit when using :G by filtering out
> EL2 for exclude_host. However when using :H unless exclude_hv is set
> on non-VHE then there is a small blackout window at the guest
> entry/exit where host events are not captured.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kernel/perf_event.c | 52 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 45 insertions(+), 7 deletions(-)

I've got a cold at the moment, so it could just be that, but I struggled to
follow the logic in this patch. Comments below.

> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index de564ae..e0619ba 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -26,6 +26,7 @@
>  
>  #include <linux/acpi.h>
>  #include <linux/clocksource.h>
> +#include <linux/kvm_host.h>
>  #include <linux/of.h>
>  #include <linux/perf/arm_pmu.h>
>  #include <linux/platform_device.h>
> @@ -647,11 +648,23 @@ static inline int armv8pmu_enable_counter(int idx)
>  
>  static inline void armv8pmu_enable_event_counter(struct perf_event *event)
>  {
> +	struct perf_event_attr *attr = &event->attr;
>  	int idx = event->hw.idx;
> +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
>  
> -	armv8pmu_enable_counter(idx);
>  	if (armv8pmu_event_is_chained(event))
> -		armv8pmu_enable_counter(idx - 1);
> +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> +
> +	if (attr->exclude_host)
> +		kvm_clr_set_guest_pmu_events(0, counter_bits);
> +	if (attr->exclude_guest)
> +		kvm_clr_set_host_pmu_events(0, counter_bits);

Hmm, so if I have both exclude_host and exclude_guest set then we'll set
the counter in both events_host_only and events_guest_only, which is weird
and probably not what you want.

I think I'd find it easier to understand if you dropped the "only" suffix on
the kvm masks, and you actually made the logic positive so that an event
that counts in both host and guest has its bit set in both of the masks.

> +
> +	if (!attr->exclude_host) {
> +		armv8pmu_enable_counter(idx);
> +		if (armv8pmu_event_is_chained(event))
> +			armv8pmu_enable_counter(idx - 1);
> +	}
>  }
>  
>  static inline int armv8pmu_disable_counter(int idx)
> @@ -664,11 +677,23 @@ static inline int armv8pmu_disable_counter(int idx)
>  static inline void armv8pmu_disable_event_counter(struct perf_event *event)
>  {
>  	struct hw_perf_event *hwc = &event->hw;
> +	struct perf_event_attr *attr = &event->attr;
>  	int idx = hwc->idx;
> +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
>  
>  	if (armv8pmu_event_is_chained(event))
> -		armv8pmu_disable_counter(idx - 1);
> -	armv8pmu_disable_counter(idx);
> +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> +
> +	if (attr->exclude_host)
> +		kvm_clr_set_guest_pmu_events(counter_bits, 0);
> +	if (attr->exclude_guest)
> +		kvm_clr_set_host_pmu_events(counter_bits, 0);
> +
> +	if (!attr->exclude_host) {
> +		if (armv8pmu_event_is_chained(event))
> +			armv8pmu_disable_counter(idx - 1);
> +		armv8pmu_disable_counter(idx);
> +	}

It looks like you're relying on the perf_event_attr remaining unchanged
between the enable/disable calls for a given event. However, I'm not
convinced that's the case -- have you checked that e.g.
PERF_EVENT_IOC_MODIFY_ATTRIBUTES can't rewrite the thing behind your
back?

>  }
>  
>  static inline int armv8pmu_enable_intens(int idx)
> @@ -943,16 +968,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  	 * Therefore we ignore exclude_hv in this configuration, since
>  	 * there's no hypervisor to sample anyway. This is consistent
>  	 * with other architectures (x86 and Power).
> +	 *
> +	 * To eliminate counting host events on the boundaries of
> +	 * guest entry/exit we ensure EL2 is not included in hyp mode
> +	 * with !exclude_host.
>  	 */
>  	if (is_kernel_in_hyp_mode()) {
> -		if (!attr->exclude_kernel)
> +		if (!attr->exclude_kernel && !attr->exclude_host)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;

Do you know what perf passes by default here? I'm worried that we're
introducing a user-visible change to existing programs by changing this
check.

>  	} else {
> -		if (attr->exclude_kernel)
> -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
>  		if (!attr->exclude_hv)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;
>  	}
> +
> +	/*
> +	 * Filter out !VHE kernels and guest kernels
> +	 */
> +	if (attr->exclude_kernel)
> +		config_base |= ARMV8_PMU_EXCLUDE_EL1;

Why have you moved this hunk?

Will
