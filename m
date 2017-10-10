From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 14/20] KVM: arm/arm64: Avoid timer save/restore in vcpu
 entry/exit
Date: Tue, 10 Oct 2017 09:47:33 +0100
Message-ID: <87mv4zwfru.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
 <20170923004207.22356-15-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D271D49D65
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 04:47:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id V5JvtJxUs5W3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 04:47:03 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1EA249D53
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 04:47:03 -0400 (EDT)
In-Reply-To: <20170923004207.22356-15-cdall@linaro.org> (Christoffer Dall's
 message of "Sat, 23 Sep 2017 02:42:01 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Sep 23 2017 at  2:42:01 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> We don't need to save and restore the hardware timer state and examine
> if it generates interrupts on on every entry/exit to the guest.  The
> timer hardware is perfectly capable of telling us when it has expired
> by signaling interrupts.
>
> When taking a vtimer interrupt in the host, we don't want to mess with
> the timer configuration, we just want to forward the physical interrupt
> to the guest as a virtual interrupt.  We can use the split priority drop
> and deactivate feature of the GIC to do this, which leaves an EOI'ed
> interrupt active on the physical distributor, making sure we don't keep
> taking timer interrupts which would prevent the guest from running.  We
> can then forward the physical interrupt to the VM using the HW bit in
> the LR of the GIC VE, like we do already, which lets the guest directly

VE?

> deactivate both the physical and virtual timer simultaneously, allowing
> the timer hardware to exit the VM and generate a new physical interrupt
> when the timer output is again asserted later on.
>
> We do need to capture this state when migrating VCPUs between physical
> CPUs, however, which we use the vcpu put/load functions for, which are
> called through preempt notifiers whenever the thread is scheduled away
> from the CPU or called directly if we return from the ioctl to
> userspace.
>
> One caveat is that we cannot restore the timer state during
> kvm_timer_vcpu_load, because the flow of sleeping a VCPU is:
>
>   1. kvm_vcpu_block
>   2. kvm_timer_schedule
>   3. schedule
>   4. kvm_timer_vcpu_put (preempt notifier)
>   5. schedule (vcpu thread gets scheduled back)
>   6. kvm_timer_vcpu_load
>         <---- We restore the hardware state here, but the bg_timer
> 	      hrtimer may have scheduled a work function that also
> 	      changes the timer state here.
>   7. kvm_timer_unschedule
>         <---- We can restore the state here instead
>
> So, while we do need to restore the timer state in step (6) in all other
> cases than when we called kvm_vcpu_block(), we have to defer the restore
> to step (7) when coming back after kvm_vcpu_block().  Note that we
> cannot simply call cancel_work_sync() in step (6), because vcpu_load can
> be called from a preempt notifier.
>
> An added benefit beyond not having to read and write the timer sysregs
> on every entry and exit is that we no longer have to actively write the
> active state to the physical distributor, because we set the affinity of

I don't understand this thing about the affinity of the timer. It is a
PPI, so it cannot go anywhere else.

> the vtimer interrupt when loading the timer state, so that the interrupt
> automatically stays active after firing.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  include/kvm/arm_arch_timer.h |   9 +-
>  virt/kvm/arm/arch_timer.c    | 238 +++++++++++++++++++++++++++----------------
>  virt/kvm/arm/arm.c           |  19 +++-
>  virt/kvm/arm/hyp/timer-sr.c  |   8 +-
>  4 files changed, 174 insertions(+), 100 deletions(-)
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 16887c0..8e5ed54 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -31,8 +31,8 @@ struct arch_timer_context {
>  	/* Timer IRQ */
>  	struct kvm_irq_level		irq;
>  
> -	/* Active IRQ state caching */
> -	bool				active_cleared_last;
> +	/* Is the timer state loaded on the hardware timer */
> +	bool			loaded;

I think this little guy is pretty crucial to understand the flow, as
there is now two points where we save/restore the timer:
vcpu_load/vcpu_put and timer_schedule/timer_unschedule. Both can be
executed on the blocking path, and this is the predicate to find out if
there is actually something to do.

Would you mind adding a small comment to that effect?

>  
>  	/* Virtual offset */
>  	u64			cntvoff;
> @@ -80,10 +80,15 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
>  
>  u64 kvm_phys_timer_read(void);
>  
> +void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>  
>  void kvm_timer_init_vhe(void);
>  
>  #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
>  #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
> +
> +void enable_el1_phys_timer_access(void);
> +void disable_el1_phys_timer_access(void);
> +
>  #endif
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4275f8f..70110ea 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -46,10 +46,9 @@ static const struct kvm_irq_level default_vtimer_irq = {
>  	.level	= 1,
>  };
>  
> -void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> -{
> -	vcpu_vtimer(vcpu)->active_cleared_last = false;
> -}
> +static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
> +static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
> +				 struct arch_timer_context *timer_ctx);
>  
>  u64 kvm_phys_timer_read(void)
>  {
> @@ -74,17 +73,37 @@ static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
>  		cancel_work_sync(work);
>  }
>  
> -static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
> +static void kvm_vtimer_update_mask_user(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
>  	/*
> -	 * We disable the timer in the world switch and let it be
> -	 * handled by kvm_timer_sync_hwstate(). Getting a timer
> -	 * interrupt at this point is a sure sign of some major
> -	 * breakage.
> +	 * To prevent continuously exiting from the guest, we mask the
> +	 * physical interrupt when the virtual level is high, such that the
> +	 * guest can make forward progress.  Once we detect the output level
> +	 * being deasserted, we unmask the interrupt again so that we exit
> +	 * from the guest when the timer fires.

Maybe an additional comment indicating that this only makes sense when
we don't have an in-kernel GIC? I know this wasn't in the original code,
but I started asking myself all kind of questions until I realised what
this was for...

>  	 */
> -	pr_warn("Unexpected interrupt %d on vcpu %p\n", irq, vcpu);
> +	if (vtimer->irq.level)
> +		disable_percpu_irq(host_vtimer_irq);
> +	else
> +		enable_percpu_irq(host_vtimer_irq, 0);
> +}
> +
> +static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
> +{
> +	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +
> +	if (!vtimer->irq.level) {
> +		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> +		if (kvm_timer_irq_can_fire(vtimer))
> +			kvm_timer_update_irq(vcpu, true, vtimer);
> +	}
> +
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
> +		kvm_vtimer_update_mask_user(vcpu);
> +
>  	return IRQ_HANDLED;
>  }
>  
> @@ -220,7 +239,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  {
>  	int ret;
>  
> -	timer_ctx->active_cleared_last = false;
>  	timer_ctx->irq.level = new_level;
>  	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
>  				   timer_ctx->irq.level);
> @@ -276,10 +294,16 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu,
>  	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(timer_ctx));
>  }
>  
> -static void timer_save_state(struct kvm_vcpu *vcpu)
> +static void vtimer_save_state(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	unsigned long flags;
> +
> +	local_irq_save(flags);

Is that to avoid racing against the timer when doing a
vcpu_put/timer/schedule?

> +
> +	if (!vtimer->loaded)
> +		goto out;
>  
>  	if (timer->enabled) {
>  		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> @@ -288,6 +312,10 @@ static void timer_save_state(struct kvm_vcpu *vcpu)
>  
>  	/* Disable the virtual timer */
>  	write_sysreg_el0(0, cntv_ctl);
> +
> +	vtimer->loaded = false;
> +out:
> +	local_irq_restore(flags);
>  }
>  
>  /*
> @@ -303,6 +331,8 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  
>  	BUG_ON(bg_timer_is_armed(timer));
>  
> +	vtimer_save_state(vcpu);
> +
>  	/*
>  	 * No need to schedule a background timer if any guest timer has
>  	 * already expired, because kvm_vcpu_block will return before putting
> @@ -326,16 +356,26 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>  	soft_timer_start(&timer->bg_timer, kvm_timer_earliest_exp(vcpu));
>  }
>  
> -static void timer_restore_state(struct kvm_vcpu *vcpu)
> +static void vtimer_restore_state(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	if (vtimer->loaded)
> +		goto out;
>  
>  	if (timer->enabled) {
>  		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
>  		isb();
>  		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
>  	}
> +
> +	vtimer->loaded = true;
> +out:
> +	local_irq_restore(flags);
>  }
>  
>  void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
> @@ -344,6 +384,8 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>  
>  	soft_timer_cancel(&timer->bg_timer, &timer->expired);
>  	timer->armed = false;
> +
> +	vtimer_restore_state(vcpu);
>  }
>  
>  static void set_cntvoff(u64 cntvoff)
> @@ -353,61 +395,56 @@ static void set_cntvoff(u64 cntvoff)
>  	kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);
>  }
>  
> -static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
> +static void kvm_timer_vcpu_load_vgic(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  	bool phys_active;
>  	int ret;
>  
> -	/*
> -	* If we enter the guest with the virtual input level to the VGIC
> -	* asserted, then we have already told the VGIC what we need to, and
> -	* we don't need to exit from the guest until the guest deactivates
> -	* the already injected interrupt, so therefore we should set the
> -	* hardware active state to prevent unnecessary exits from the guest.
> -	*
> -	* Also, if we enter the guest with the virtual timer interrupt active,
> -	* then it must be active on the physical distributor, because we set
> -	* the HW bit and the guest must be able to deactivate the virtual and
> -	* physical interrupt at the same time.
> -	*
> -	* Conversely, if the virtual input level is deasserted and the virtual
> -	* interrupt is not active, then always clear the hardware active state
> -	* to ensure that hardware interrupts from the timer triggers a guest
> -	* exit.
> -	*/
> -	phys_active = vtimer->irq.level ||
> -			kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
> -
> -	/*
> -	 * We want to avoid hitting the (re)distributor as much as
> -	 * possible, as this is a potentially expensive MMIO access
> -	 * (not to mention locks in the irq layer), and a solution for
> -	 * this is to cache the "active" state in memory.
> -	 *
> -	 * Things to consider: we cannot cache an "active set" state,
> -	 * because the HW can change this behind our back (it becomes
> -	 * "clear" in the HW). We must then restrict the caching to
> -	 * the "clear" state.
> -	 *
> -	 * The cache is invalidated on:
> -	 * - vcpu put, indicating that the HW cannot be trusted to be
> -	 *   in a sane state on the next vcpu load,
> -	 * - any change in the interrupt state
> -	 *
> -	 * Usage conditions:
> -	 * - cached value is "active clear"
> -	 * - value to be programmed is "active clear"
> -	 */
> -	if (vtimer->active_cleared_last && !phys_active)
> -		return;
> -
> +	if (vtimer->irq.level || kvm_vgic_map_is_active(vcpu, vtimer->irq.irq))
> +		phys_active = true;
> +	else
> +		phys_active = false;

nit: this can be written as:

     phys_active = (vtimer->irq.level ||
     		    kvm_vgic_map_is_active(vcpu, vtimer->irq.irq));

Not that it matters in the slightest...

>  	ret = irq_set_irqchip_state(host_vtimer_irq,
>  				    IRQCHIP_STATE_ACTIVE,
>  				    phys_active);
>  	WARN_ON(ret);
> +}
> +
> +static void kvm_timer_vcpu_load_user(struct kvm_vcpu *vcpu)
> +{
> +	kvm_vtimer_update_mask_user(vcpu);
> +}
> +
> +void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +
> +	if (unlikely(!timer->enabled))
> +		return;
> +
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
> +		kvm_timer_vcpu_load_user(vcpu);
> +	else
> +		kvm_timer_vcpu_load_vgic(vcpu);
>  
> -	vtimer->active_cleared_last = !phys_active;
> +	set_cntvoff(vtimer->cntvoff);
> +
> +	/*
> +	 * If we armed a soft timer and potentially queued work, we have to
> +	 * cancel this, but cannot do it here, because canceling work can
> +	 * sleep and we can be in the middle of a preempt notifier call.
> +	 * Instead, when the timer has been armed, we know the return path
> +	 * from kvm_vcpu_block will call kvm_timer_unschedule, so we can defer
> +	 * restoring the state and canceling any soft timers and work items
> +	 * until then.
> +	 */
> +	if (!bg_timer_is_armed(timer))
> +		vtimer_restore_state(vcpu);
> +
> +	if (has_vhe())
> +		disable_el1_phys_timer_access();
>  }
>  
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -427,23 +464,6 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
>  	       ptimer->irq.level != plevel;
>  }
>  
> -static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
> -{
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -
> -	/*
> -	 * To prevent continuously exiting from the guest, we mask the
> -	 * physical interrupt such that the guest can make forward progress.
> -	 * Once we detect the output level being deasserted, we unmask the
> -	 * interrupt again so that we exit from the guest when the timer
> -	 * fires.
> -	*/
> -	if (vtimer->irq.level)
> -		disable_percpu_irq(host_vtimer_irq);
> -	else
> -		enable_percpu_irq(host_vtimer_irq, 0);
> -}
> -
>  /**
>   * kvm_timer_flush_hwstate - prepare timers before running the vcpu
>   * @vcpu: The vcpu pointer
> @@ -456,23 +476,55 @@ static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
>  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>  
>  	if (unlikely(!timer->enabled))
>  		return;
>  
> -	kvm_timer_update_state(vcpu);
> +	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
> +		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
>  
>  	/* Set the background timer for the physical timer emulation. */
>  	phys_timer_emulate(vcpu, vcpu_ptimer(vcpu));
> +}
>  
> -	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
> -		kvm_timer_flush_hwstate_user(vcpu);
> -	else
> -		kvm_timer_flush_hwstate_vgic(vcpu);
> +void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
> -	set_cntvoff(vtimer->cntvoff);
> -	timer_restore_state(vcpu);
> +	if (unlikely(!timer->enabled))
> +		return;
> +
> +	if (has_vhe())
> +		enable_el1_phys_timer_access();
> +
> +	vtimer_save_state(vcpu);
> +
> +	set_cntvoff(0);

Can this be moved into vtimer_save_state()? And thinking of it, why
don't we reset cntvoff in kvm_timer_schedule() as well? 

> +}
> +
> +static void unmask_vtimer_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> +
> +	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
> +		kvm_vtimer_update_mask_user(vcpu);
> +		return;
> +	}
> +
> +	/*
> +	 * If the guest disabled the timer without acking the interrupt, then
> +	 * we must make sure the physical and virtual active states are in
> +	 * sync by deactivating the physical interrupt, because otherwise we
> +	 * wouldn't see the next timer interrupt in the host.
> +	 */
> +	if (!kvm_vgic_map_is_active(vcpu, vtimer->irq.irq)) {
> +		int ret;
> +		ret = irq_set_irqchip_state(host_vtimer_irq,
> +					    IRQCHIP_STATE_ACTIVE,
> +					    false);
> +		WARN_ON(ret);
> +	}
>  }
>  
>  /**
> @@ -485,6 +537,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>  
>  	/*
>  	 * This is to cancel the background timer for the physical timer
> @@ -492,14 +545,19 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>  	 */
>  	soft_timer_cancel(&timer->phys_timer, NULL);
>  
> -	timer_save_state(vcpu);
> -	set_cntvoff(0);
> -
>  	/*
> -	 * The guest could have modified the timer registers or the timer
> -	 * could have expired, update the timer state.
> +	 * If we entered the guest with the vtimer output asserted we have to
> +	 * check if the guest has modified the timer so that we should lower
> +	 * the line at this point.
>  	 */
> -	kvm_timer_update_state(vcpu);
> +	if (vtimer->irq.level) {
> +		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
> +		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
> +		if (!kvm_timer_should_fire(vtimer)) {
> +			kvm_timer_update_irq(vcpu, false, vtimer);
> +			unmask_vtimer_irq(vcpu);
> +		}
> +	}
>  }
>  
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 27db222..132d39a 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -354,18 +354,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
>  
>  	kvm_arm_set_running_vcpu(vcpu);
> -
>  	kvm_vgic_load(vcpu);
> +	kvm_timer_vcpu_load(vcpu);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +	kvm_timer_vcpu_put(vcpu);
>  	kvm_vgic_put(vcpu);
>  
>  	vcpu->cpu = -1;
>  
>  	kvm_arm_set_running_vcpu(NULL);
> -	kvm_timer_vcpu_put(vcpu);
>  }
>  
>  static void vcpu_power_off(struct kvm_vcpu *vcpu)
> @@ -710,16 +710,27 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		kvm_arm_clear_debug(vcpu);
>  
>  		/*
> -		 * We must sync the PMU and timer state before the vgic state so
> +		 * We must sync the PMU state before the vgic state so
>  		 * that the vgic can properly sample the updated state of the
>  		 * interrupt line.
>  		 */
>  		kvm_pmu_sync_hwstate(vcpu);
> -		kvm_timer_sync_hwstate(vcpu);
>  
> +		/*
> +		 * Sync the vgic state before syncing the timer state because
> +		 * the timer code needs to know if the virtual timer
> +		 * interrupts are active.
> +		 */
>  		kvm_vgic_sync_hwstate(vcpu);
>  
>  		/*
> +		 * Sync the timer hardware state before enabling interrupts as
> +		 * we don't want vtimer interrupts to race with syncing the
> +		 * timer virtual interrupt state.
> +		 */
> +		kvm_timer_sync_hwstate(vcpu);
> +
> +		/*
>  		 * We may have taken a host interrupt in HYP mode (ie
>  		 * while executing the guest). This interrupt is still
>  		 * pending, as we haven't serviced it yet!
> diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> index a6c3b10..f398616 100644
> --- a/virt/kvm/arm/hyp/timer-sr.c
> +++ b/virt/kvm/arm/hyp/timer-sr.c
> @@ -27,7 +27,7 @@ void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
>  	write_sysreg(cntvoff, cntvoff_el2);
>  }
>  
> -void __hyp_text enable_phys_timer(void)
> +void __hyp_text enable_el1_phys_timer_access(void)
>  {
>  	u64 val;
>  
> @@ -37,7 +37,7 @@ void __hyp_text enable_phys_timer(void)
>  	write_sysreg(val, cnthctl_el2);
>  }
>  
> -void __hyp_text disable_phys_timer(void)
> +void __hyp_text disable_el1_phys_timer_access(void)
>  {
>  	u64 val;
>  
> @@ -58,11 +58,11 @@ void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
>  	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
>  	 */
>  	if (!has_vhe())
> -		enable_phys_timer();
> +		enable_el1_phys_timer_access();
>  }
>  
>  void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
>  {
>  	if (!has_vhe())
> -		disable_phys_timer();
> +		disable_el1_phys_timer_access();
>  }

It'd be nice to move this renaming to the patch that introduce these two
functions.

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
