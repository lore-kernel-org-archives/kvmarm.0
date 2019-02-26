From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Tue, 26 Feb 2019 13:44:59 +0100
Message-ID: <20190226124459.GB551@e113682-lin.lund.arm.com>
References: <1547482308-29839-1-git-send-email-andrew.murray@arm.com>
 <1547482308-29839-5-git-send-email-andrew.murray@arm.com>
 <20190218215307.GA28113@e113682-lin.lund.arm.com>
 <20190220161539.GA2055@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 774F44A2E5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:45:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z8xn5YTL6Ehj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:45:02 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B1EA4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:45:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190220161539.GA2055@e119886-lin.cambridge.arm.com>
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

On Wed, Feb 20, 2019 at 04:15:40PM +0000, Andrew Murray wrote:
> On Mon, Feb 18, 2019 at 10:53:07PM +0100, Christoffer Dall wrote:
> > On Mon, Jan 14, 2019 at 04:11:47PM +0000, Andrew Murray wrote:
> > > Add support for the :G and :H attributes in perf by handling the
> > > exclude_host/exclude_guest event attributes.
> > > 
> > > We notify KVM of counters that we wish to be enabled or disabled on
> > > guest entry/exit and thus defer from starting or stopping :G events
> > > as per the events exclude_host attribute.
> > > 
> > > With both VHE and non-VHE we switch the counters between host/guest
> > > at EL2. We are able to eliminate counters counting host events on
> > > the boundaries of guest entry/exit when using :G by filtering out
> > > EL2 for exclude_host. However when using :H unless exclude_hv is set
> > > on non-VHE then there is a small blackout window at the guest
> > > entry/exit where host events are not captured.
> > > 
> > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > ---
> > >  arch/arm64/kernel/perf_event.c | 53 ++++++++++++++++++++++++++++++++++++------
> > >  1 file changed, 46 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> > > index 1c71796..21c6831 100644
> > > --- a/arch/arm64/kernel/perf_event.c
> > > +++ b/arch/arm64/kernel/perf_event.c
> > > @@ -26,6 +26,7 @@
> > >  
> > >  #include <linux/acpi.h>
> > >  #include <linux/clocksource.h>
> > > +#include <linux/kvm_host.h>
> > >  #include <linux/of.h>
> > >  #include <linux/perf/arm_pmu.h>
> > >  #include <linux/platform_device.h>
> > > @@ -528,11 +529,27 @@ static inline int armv8pmu_enable_counter(int idx)
> > >  
> > >  static inline void armv8pmu_enable_event_counter(struct perf_event *event)
> > >  {
> > > +	struct perf_event_attr *attr = &event->attr;
> > >  	int idx = event->hw.idx;
> > > +	int flags = 0;
> > > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> > >  
> > > -	armv8pmu_enable_counter(idx);
> > >  	if (armv8pmu_event_is_chained(event))
> > > -		armv8pmu_enable_counter(idx - 1);
> > > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > > +
> > > +	if (!attr->exclude_host)
> > > +		flags |= KVM_PMU_EVENTS_HOST;
> > > +	if (!attr->exclude_guest)
> > > +		flags |= KVM_PMU_EVENTS_GUEST;
> > > +
> > > +	kvm_set_pmu_events(counter_bits, flags);
> > > +
> > > +	/* We rely on the hypervisor switch code to enable guest counters */
> > > +	if (!attr->exclude_host) {
> > > +		armv8pmu_enable_counter(idx);
> > > +		if (armv8pmu_event_is_chained(event))
> > > +			armv8pmu_enable_counter(idx - 1);
> > > +	}
> > >  }
> > >  
> > >  static inline int armv8pmu_disable_counter(int idx)
> > > @@ -545,11 +562,21 @@ static inline int armv8pmu_disable_counter(int idx)
> > >  static inline void armv8pmu_disable_event_counter(struct perf_event *event)
> > >  {
> > >  	struct hw_perf_event *hwc = &event->hw;
> > > +	struct perf_event_attr *attr = &event->attr;
> > >  	int idx = hwc->idx;
> > > +	u32 counter_bits = BIT(ARMV8_IDX_TO_COUNTER(idx));
> > >  
> > >  	if (armv8pmu_event_is_chained(event))
> > > -		armv8pmu_disable_counter(idx - 1);
> > > -	armv8pmu_disable_counter(idx);
> > > +		counter_bits |= BIT(ARMV8_IDX_TO_COUNTER(idx - 1));
> > > +
> > > +	kvm_clr_pmu_events(counter_bits);
> > > +
> > > +	/* We rely on the hypervisor switch code to disable guest counters */
> > > +	if (!attr->exclude_host) {
> > > +		if (armv8pmu_event_is_chained(event))
> > > +			armv8pmu_disable_counter(idx - 1);
> > > +		armv8pmu_disable_counter(idx);
> > > +	}
> > >  }
> > >  
> > >  static inline int armv8pmu_enable_intens(int idx)
> > > @@ -824,16 +851,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
> > >  	 * Therefore we ignore exclude_hv in this configuration, since
> > >  	 * there's no hypervisor to sample anyway. This is consistent
> > >  	 * with other architectures (x86 and Power).
> > > +	 *
> > > +	 * To eliminate counting host events on the boundaries of
> > 					   ^comma
> > 
> > > +	 * guest entry/exit we ensure EL2 is not included in hyp mode
> > 			   ^comma (or rework sentence)
> > 
> > What do you mean by "EL2 is not included in hyp mode" ??
> 
> This attempts to explain the addition of '!attr->exclude_host' when
> is_kernel_in_hyp_mode is true below.

Ahh, so you meant to say "EL2 is not included when the kernel runs
entirely in hyp mode", however, ...

> 
> We have no need to count EL2 when counting any guest events - by adding
> this hunk we can eliminate counting host events in the small period of
> time in the switch code between enabling the counter and entering the
> guest.
> 
> Perhaps I should rephrase it to "To eliminate counting host events on
> the boundaries of guest entry/exit, we ensure EL2 is not included when
> counting guest events in hyp mode." ?
> 

... I don't think that really helps.  This comment is trying to
translate code flow into English, which is generally a bad idea.  As I
read the code, what this does is disabling counting at EL2 when
is_kernel_in_hyp_mode() is true, which means you won't count in general
in the host kernel, nor in the world-switch in KVM, which makes sense.

I recommend you drop the comment, and instead focus on explaining the
overall semantics of the flags somewhere (perhaps my write-up below can
be useful in that regard).

> > 
> > > +	 * with !exclude_host.
> > >  	 */
> > >  	if (is_kernel_in_hyp_mode()) {
> > > -		if (!attr->exclude_kernel)
> > > +		if (!attr->exclude_kernel && !attr->exclude_host)
> > >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > >  	} else {
> > > -		if (attr->exclude_kernel)
> > > -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> > >  		if (!attr->exclude_hv)
> > >  			config_base |= ARMV8_PMU_INCLUDE_EL2;
> > >  	}
> > > +
> > > +	/*
> > > +	 * Filter out !VHE kernels and guest kernels
> > > +	 */
> > > +	if (attr->exclude_kernel)
> > > +		config_base |= ARMV8_PMU_EXCLUDE_EL1;
> > > +
> > 
> > Let me see if I get this right:
> > 
> > 	exclude_user:	VHE: Don't count EL0
> > 			Non-VHE: Don't count EL0
> > 
> > 	exclude_kernel: VHE: Don't count EL2 and don't count EL1
> > 			Non-VHE: Don't count EL1
> > 
> > 	exclude_hv:	VHE: No effect
> > 			Non-VHE: Don't count EL2
> > 
> > 	exclude_host:	VHE: Don't count EL2 + enable/disable on guest entry/exit
> > 			Non-VHE: disable on guest entry/disable on guest entry/exit
> > 
> > And the logic I extract is that _user applies across both guest and
> > host, as does _kernel (regardless of the mode the kernel on the current
> > system runs in, might be only EL1, might be EL1 and EL2), and _hv is
> > specific to non-VHE systems to measure events in a specific piece of KVM
> > code that runs at EL2.
> > 
> > As I expressed before, that doesn't seem to be the intent behind the
> > exclude_hv flag, but I'm not sure how other architectures actually
> > implement things today, and even if it's a curiosity of the Arm
> > architecture and has value to non-VHE hypervisor hackers, and we don't
> > really have to care about uniformity with the other architectures, then
> > fine.
> > 
> > It has taken me a while to make sense of this code change, so I really
> > wish we can find a suitable place to document the semantics clearly for
> > perf users on arm64.
> > 
> > Now, another thing comes to mind:  Do we really need to enable and
> > disable anything on a VHE system on entry/exit to/from a guest?  Can we
> > instead do the following:
> > 
> > 	exclude_host:	Disable EL2 counting
> > 		     	Disable EL0 counting
> > 		     	Enable EL0 counting on vcpu_load
> > 		     	  (unless exclude_user is also set)
> > 		     	Disable EL0 counting on vcpu_put
> > 
> > 	exclude_guest:	Disable EL1 counting
> > 		      	Disable EL0 counting on vcpu_load
> > 		      	Enable EL0 counting on vcpu_put
> > 			  (unless exclude_user is also set)
> > 
> > If that works, we can avoid the overhead in the critical path on VHE
> > systems and actually have slightly more accurate counting, leaving the
> > entry/exit operations to be specific to non-VHE.
> 
> This all makes sense.
> 
> At present on VHE, for host only events, there is a small blackout window
> at the guest entry/exit - this is where we turn off/on host counting before
> entering/exiting the guest. (This blackout window also exists on !VHE unless
> exclude_hv is set).
> 
> To mitigate against this the PMU switching code was brought as close to the
> guest entry/exit as possible - but as you point out at this point in
> kvm_arch_vcpu_ioctl_run we're running without interrupts/preemption and so
> on the critical path. I believe we add about 11 instructions when there are
> no PMU counters enabled and about 23 when they are enabled. I suppose it
> would be possible to use static keys to reduce the overhead when counters
> are not enabled...
> 
> Your suggestion provides an optimal solution, however it adds some
> complexity - here is a rough attempt at implementing it...
> 
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index cbfe3d1..bc548e6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -482,10 +482,23 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
>  {
>         return kvm_arch_vcpu_run_map_fp(vcpu);
>  }
> -static inline void kvm_set_pmu_events(u32 set, int flags)
> +static inline bool kvm_pmu_switch_events(struct perf_event_attr *attr)
> +{
> +       if (!has_vhe())
> +               return true;
> +
> +       if (attr->exclude_user)
> +               return false;
> +
> +       return (attr->exclude_host ^ attr->exclude_guest);
> +}
> +static inline void kvm_set_pmu_events(u32 set, int flags, struct perf_event_attr *attr)
>  {
>         struct kvm_host_data *ctx = this_cpu_ptr(&kvm_host_data);
>  
> +       if (!kvm_pmu_switch_events(attr))
> +               return;
> +
>         if (flags & KVM_PMU_EVENTS_HOST)
>                 ctx->pmu_events.events_host |= set;
>         if (flags & KVM_PMU_EVENTS_GUEST)
> @@ -499,6 +512,7 @@ static inline void kvm_clr_pmu_events(u32 clr)
>         ctx->pmu_events.events_guest &= ~clr;
>  }
>  #else
> +static inline bool kvm_pmu_switch_events() { return false; }
>  static inline void kvm_set_pmu_events(u32 set, int flags) {}
>  static inline void kvm_clr_pmu_events(u32 clr) {}
>  #endif
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 21c6831..dae6691 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -542,10 +542,10 @@ static inline void armv8pmu_enable_event_counter(struct perf_event *event)
>         if (!attr->exclude_guest)
>                 flags |= KVM_PMU_EVENTS_GUEST;
>  
> -       kvm_set_pmu_events(counter_bits, flags);
> +       kvm_set_pmu_events(counter_bits, flags, attr);
>  
>         /* We rely on the hypervisor switch code to enable guest counters */
> -       if (!attr->exclude_host) {
> +       if (has_vhe() || !attr->exclude_host) {
>                 armv8pmu_enable_counter(idx);
>                 if (armv8pmu_event_is_chained(event))
>                         armv8pmu_enable_counter(idx - 1);
> @@ -572,7 +572,7 @@ static inline void armv8pmu_disable_event_counter(struct perf_event *event)
>         kvm_clr_pmu_events(counter_bits);
>  
>         /* We rely on the hypervisor switch code to disable guest counters */
> -       if (!attr->exclude_host) {
> +       if (has_vhe() || !attr->exclude_host) {
>                 if (armv8pmu_event_is_chained(event))
>                         armv8pmu_disable_counter(idx - 1);
>                 armv8pmu_disable_counter(idx);
> @@ -859,6 +859,10 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>         if (is_kernel_in_hyp_mode()) {
>                 if (!attr->exclude_kernel && !attr->exclude_host)
>                         config_base |= ARMV8_PMU_INCLUDE_EL2;
> +               if (attr->exclude_guest)
> +                       config_base |= ARMV8_PMU_EXCLUDE_EL1;
> +               if (attr->exclude_host)
> +                       config_base |= ARMV8_PMU_EXCLUDE_EL0;
>         } else {
>                 if (!attr->exclude_hv)
>                         config_base |= ARMV8_PMU_INCLUDE_EL2;
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 9018fb3..722cd7a 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -512,15 +512,12 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_cpu_context *host_ctxt;
>         struct kvm_cpu_context *guest_ctxt;
> -       bool pmu_switch_needed;
>         u64 exit_code;
>  
>         host_ctxt = vcpu->arch.host_cpu_context;
>         host_ctxt->__hyp_running_vcpu = vcpu;
>         guest_ctxt = &vcpu->arch.ctxt;
>  
> -       pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
> -
>         sysreg_save_host_state_vhe(host_ctxt);
>  
>         /*
> @@ -562,9 +559,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>         __debug_switch_to_host(vcpu);
>  
> -       if (pmu_switch_needed)
> -               __pmu_switch_to_host(host_ctxt);
> -
>         return exit_code;
>  }
>  
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 89acb7f..34d94ba 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -360,6 +360,42 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>         return kvm_vgic_vcpu_init(vcpu);
>  }
>  
> +static void kvm_vcpu_pmu_switch(struct kvm_vcpu *vcpu, bool guest)
> +{
> +       u32 typer, counter;
> +       struct kvm_cpu_context *host_ctxt;
> +       struct kvm_host_data *host;
> +       unsigned long events_guest, events_host;
> +
> +       host_ctxt = vcpu->arch.host_cpu_context;
> +       host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +       events_guest = host->pmu_events.events_guest;
> +       events_host = host->pmu_events.events_host;
> +
> +       if (!has_vhe())
> +               return;
> +
> +       for_each_set_bit(counter, &events_guest, 32) {
> +               write_sysreg(counter, pmselr_el0);
> +               isb();
> +               if (guest)
> +                       typer = read_sysreg(pmxevtyper_el0) & ~BIT(30);
> +               else
> +                       typer = read_sysreg(pmxevtyper_el0) | BIT(30);
> +               write_sysreg(typer, pmxevtyper_el0);
> +       }
> +
> +       for_each_set_bit(counter, &events_host, 32) {
> +               write_sysreg(counter, pmselr_el0);
> +               isb();
> +               if (guest)
> +                       typer = read_sysreg(pmxevtyper_el0) | BIT(30);
> +               else
> +                       typer = read_sysreg(pmxevtyper_el0) & ~BIT(30);
> +               write_sysreg(typer, pmxevtyper_el0);
> +       }
> +}
> +
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>         int *last_ran;
> @@ -385,6 +421,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         kvm_timer_vcpu_load(vcpu);
>         kvm_vcpu_load_sysregs(vcpu);
>         kvm_arch_vcpu_load_fp(vcpu);
> +       kvm_vcpu_pmu_switch(vcpu, true);
>  
>         if (single_task_running())
>                 vcpu_clear_wfe_traps(vcpu);
> @@ -398,6 +435,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>         kvm_vcpu_put_sysregs(vcpu);
>         kvm_timer_vcpu_put(vcpu);
>         kvm_vgic_put(vcpu);
> +       kvm_vcpu_pmu_switch(vcpu, false);
>  
>         vcpu->cpu = -1;
>  
> 
> Do you think this is worth developing further?
> 

Yes, I think it's worth going to fairly great lengths to keep the
critical path on VHE systems lean, and I suspect if we take the easy way
to add functionality first, it will only be harder to factor things out
later.

I'd like to see some (tested) version of this patch if possible.


Thanks,

    Christoffer
