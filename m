From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Mon, 18 Feb 2019 22:53:07 +0100
Message-ID: <20190218215307.GA28113@e113682-lin.lund.arm.com>
References: <1547482308-29839-1-git-send-email-andrew.murray@arm.com>
 <1547482308-29839-5-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7F649E3E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 16:53:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ECDGBfUjS8ng for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 16:53:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11DE840A52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 16:53:11 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1547482308-29839-5-git-send-email-andrew.murray@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 14, 2019 at 04:11:47PM +0000, Andrew Murray wrote:
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
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kernel/perf_event.c | 53 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 1c71796..21c6831 100644
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
> @@ -528,11 +529,27 @@ static inline int armv8pmu_enable_counter(int idx)
>  
>  static inline void armv8pmu_enable_event_counter(struct perf_event *event)
>  {
> +	struct perf_event_attr *attr = &event->attr;
>  	int idx = event->hw.idx;
> +	int flags = 0;
> +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
>  
> -	armv8pmu_enable_counter(idx);
>  	if (armv8pmu_event_is_chained(event))
> -		armv8pmu_enable_counter(idx - 1);
> +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> +
> +	if (!attr->exclude_host)
> +		flags |= KVM_PMU_EVENTS_HOST;
> +	if (!attr->exclude_guest)
> +		flags |= KVM_PMU_EVENTS_GUEST;
> +
> +	kvm_set_pmu_events(counter_bits, flags);
> +
> +	/* We rely on the hypervisor switch code to enable guest counters */
> +	if (!attr->exclude_host) {
> +		armv8pmu_enable_counter(idx);
> +		if (armv8pmu_event_is_chained(event))
> +			armv8pmu_enable_counter(idx - 1);
> +	}
>  }
>  
>  static inline int armv8pmu_disable_counter(int idx)
> @@ -545,11 +562,21 @@ static inline int armv8pmu_disable_counter(int idx)
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
> +	kvm_clr_pmu_events(counter_bits);
> +
> +	/* We rely on the hypervisor switch code to disable guest counters */
> +	if (!attr->exclude_host) {
> +		if (armv8pmu_event_is_chained(event))
> +			armv8pmu_disable_counter(idx - 1);
> +		armv8pmu_disable_counter(idx);
> +	}
>  }
>  
>  static inline int armv8pmu_enable_intens(int idx)
> @@ -824,16 +851,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  	 * Therefore we ignore exclude_hv in this configuration, since
>  	 * there's no hypervisor to sample anyway. This is consistent
>  	 * with other architectures (x86 and Power).
> +	 *
> +	 * To eliminate counting host events on the boundaries of
					   ^comma

> +	 * guest entry/exit we ensure EL2 is not included in hyp mode
			   ^comma (or rework sentence)

What do you mean by "EL2 is not included in hyp mode" ??

> +	 * with !exclude_host.
>  	 */
>  	if (is_kernel_in_hyp_mode()) {
> -		if (!attr->exclude_kernel)
> +		if (!attr->exclude_kernel && !attr->exclude_host)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;
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
> +

Let me see if I get this right:

	exclude_user:	VHE: Don't count EL0
			Non-VHE: Don't count EL0

	exclude_kernel: VHE: Don't count EL2 and don't count EL1
			Non-VHE: Don't count EL1

	exclude_hv:	VHE: No effect
			Non-VHE: Don't count EL2

	exclude_host:	VHE: Don't count EL2 + enable/disable on guest entry/exit
			Non-VHE: disable on guest entry/disable on guest entry/exit

And the logic I extract is that _user applies across both guest and
host, as does _kernel (regardless of the mode the kernel on the current
system runs in, might be only EL1, might be EL1 and EL2), and _hv is
specific to non-VHE systems to measure events in a specific piece of KVM
code that runs at EL2.

As I expressed before, that doesn't seem to be the intent behind the
exclude_hv flag, but I'm not sure how other architectures actually
implement things today, and even if it's a curiosity of the Arm
architecture and has value to non-VHE hypervisor hackers, and we don't
really have to care about uniformity with the other architectures, then
fine.

It has taken me a while to make sense of this code change, so I really
wish we can find a suitable place to document the semantics clearly for
perf users on arm64.

Now, another thing comes to mind:  Do we really need to enable and
disable anything on a VHE system on entry/exit to/from a guest?  Can we
instead do the following:

	exclude_host:	Disable EL2 counting
		     	Disable EL0 counting
		     	Enable EL0 counting on vcpu_load
		     	  (unless exclude_user is also set)
		     	Disable EL0 counting on vcpu_put

	exclude_guest:	Disable EL1 counting
		      	Disable EL0 counting on vcpu_load
		      	Enable EL0 counting on vcpu_put
			  (unless exclude_user is also set)

If that works, we can avoid the overhead in the critical path on VHE
systems and actually have slightly more accurate counting, leaving the
entry/exit operations to be specific to non-VHE.


Thanks,

    Christoffer
