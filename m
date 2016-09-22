From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5] KVM: arm/arm64: Route vtimer events to user space
Date: Thu, 22 Sep 2016 23:28:31 +0200
Message-ID: <20160922212831.GD9101@cbox>
References: <1474548769-195643-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5321A49B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 17:19:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DBnRD+QleMkb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 17:19:15 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0720549B2E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 17:19:14 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id w84so277126704wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 14:28:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1474548769-195643-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Sep 22, 2016 at 02:52:49PM +0200, Alexander Graf wrote:
> We have 2 modes for dealing with interrupts in the ARM world. We can either
> handle them all using hardware acceleration through the vgic or we can emulate
> a gic in user space and only drive CPU IRQ pins from there.
> 
> Unfortunately, when driving IRQs from user space, we never tell user space
> about timer events that may result in interrupt line state changes, so we
> lose out on timer events if we run with user space gic emulation.
> 
> This patch fixes that by syncing user space's view of the vtimer irq line
> with the kvm view of that same line.
> 
> With this patch I can successfully run edk2 and Linux with user space gic
> emulation.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> 
> ---
> 
> v1 -> v2:
> 
>   - Add back curly brace that got lost
> 
> v2 -> v3:
> 
>   - Split into patch set
> 
> v3 -> v4:
> 
>   - Improve documentation
> 
> v4 -> v5:
> 
>   - Rewrite to use pending state sync in sregs (marc)
>   - Remove redundant checks of vgic_initialized()
>   - qemu tree to try this out: https://github.com/agraf/u-boot.git no-kvm-irqchip-for-v5

huh, qemu=u-boot?

> ---
>  Documentation/virtual/kvm/api.txt |  26 ++++++++
>  arch/arm/include/uapi/asm/kvm.h   |   3 +
>  arch/arm/kvm/arm.c                |  14 ++---
>  arch/arm64/include/uapi/asm/kvm.h |   3 +
>  include/kvm/arm_arch_timer.h      |   2 +-
>  include/uapi/linux/kvm.h          |   6 ++
>  virt/kvm/arm/arch_timer.c         | 129 ++++++++++++++++++++++++++------------
>  7 files changed, 134 insertions(+), 49 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 739db9a..8049327 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -3928,3 +3928,29 @@ In order to use SynIC, it has to be activated by setting this
>  capability via KVM_ENABLE_CAP ioctl on the vcpu fd. Note that this
>  will disable the use of APIC hardware virtualization even if supported
>  by the CPU, as it's incompatible with SynIC auto-EOI behavior.
> +
> +8.3 KVM_CAP_ARM_TIMER
> +
> +Architectures: arm, arm64
> +This capability, if KVM_CHECK_EXTENSION indicates that it is available and no
> +in-kernel interrupt controller is in use, means that that the kernel populates
> +the vcpu's run->s.regs.kernel_timer_pending field with timers that are currently
> +considered pending by kvm.

Be careful with the word 'pending' here.  I think this could be
misleading, because pending is a state in the GIC, but not really
something I can find specific to the timer.  It would be more
descriptive to say that the kernel maintained generic timer's output
signal is asserted.

> +
> +If active, it also allows user space to propagate its own pending state of timer
> +interrupt lines using run->s.regs.user_timer_pending. If those two fields
> +mismatch during CPU execution, kvm will exit to user space to give it a chance

I don't quite understand the semantics here.  The only entity that knows
what the level state of the output of the timer is, is the kernel, which
emulates the timer.  Userspace knows interrupt controller state, but if
it has a different view of the timer state than the kernel, it's because
the kernel failed to notify userspace of a change or userspace failed to
listen?

> +to update its own interrupt pending status. This usually involves triggering
> +an interrupt line on a user space emulated interrupt controller.

To me it feels like the semantics should be that userspace can always
derive the status of the timer and the level of the output signal from
the timer by simply looking at kvm_run structure.

The remaining two problems are:

(1) when should the kernel trigger exits to userspace?  Presumably on
any change in the timer's output level, because this change has to be
propagated to the userspace interrupt controller.

(2) the kernel needs to somehow mask the underlying hardware timer
interrupt signal when it's active, because otherwise the guest won't
proceed.  If we simply mask the hardware signal after telling userspace
the output signal is asserted and until the output signal ever becomes
deasserted, why do we need to listen to anything userspace has to say?


> +
> +The fields run->s.regs.kernel_timer_pending and run->s.regs.user_timer_pending
> +are available independent of run->kvm_valid_regs or run->kvm_dirty_regs bits.
> +If no in-kernel interrupt controller is used and the capability exists, they
> +will always be available and used.
> +
> +Currently the following bits are defined for both bitmaps:
> +
> +    KVM_ARM_TIMER_VTIMER  -  virtual timer
> +
> +Future versions of kvm may implement additional timer events. These will get
> +indicated by additional KVM_CAP extensions.
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index a2b3eb3..caad81d 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -105,6 +105,9 @@ struct kvm_debug_exit_arch {
>  };
>  
>  struct kvm_sync_regs {
> +	/* Used with KVM_CAP_ARM_TIMER */
> +	u8 kernel_timer_pending;
> +	u8 user_timer_pending;
>  };
>  
>  struct kvm_arch_memory_slot {
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 75f130e..dc19221 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -187,6 +187,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PSCI_0_2:
>  	case KVM_CAP_READONLY_MEM:
>  	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_ARM_TIMER:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -474,13 +475,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  			return ret;
>  	}
>  
> -	/*
> -	 * Enable the arch timers only if we have an in-kernel VGIC
> -	 * and it has been properly initialized, since we cannot handle
> -	 * interrupts from the virtual timer with a userspace gic.
> -	 */
> -	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
> -		ret = kvm_timer_enable(vcpu);
> +	ret = kvm_timer_enable(vcpu);
>  
>  	return ret;
>  }
> @@ -588,7 +583,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		 */
>  		preempt_disable();
>  		kvm_pmu_flush_hwstate(vcpu);
> -		kvm_timer_flush_hwstate(vcpu);
> +		if (kvm_timer_flush_hwstate(vcpu)) {
> +			ret = -EINTR;
> +			run->exit_reason = KVM_EXIT_INTR;
> +		}
>  		kvm_vgic_flush_hwstate(vcpu);
>  
>  		local_irq_disable();
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 3051f86..9aac860 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -143,6 +143,9 @@ struct kvm_debug_exit_arch {
>  #define KVM_GUESTDBG_USE_HW		(1 << 17)
>  
>  struct kvm_sync_regs {
> +	/* Used with KVM_CAP_ARM_TIMER */
> +	u8 kernel_timer_pending;
> +	u8 user_timer_pending;
>  };
>  
>  struct kvm_arch_memory_slot {
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index dda39d8..8cd7240 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -63,7 +63,7 @@ void kvm_timer_init(struct kvm *kvm);
>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>  			 const struct kvm_irq_level *irq);
>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
> -void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
> +int kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 300ef25..1fc02d7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -870,6 +870,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_S390_USER_INSTR0 130
>  #define KVM_CAP_MSI_DEVID 131
>  #define KVM_CAP_PPC_HTM 132
> +#define KVM_CAP_ARM_TIMER 133
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1327,4 +1328,9 @@ struct kvm_assigned_msix_entry {
>  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
>  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
>  
> +/* Available with KVM_CAP_ARM_TIMER */
> +
> +/* Bits for run->s.regs.{user,kernel}_timer_pending */
> +#define KVM_ARM_TIMER_VTIMER		(1 << 0)
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4309b60..0c6fc38 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -166,21 +166,36 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
>  	return cval <= now;
>  }
>  
> +/*
> + * Synchronize the timer IRQ state with the interrupt controller.
> + */
>  static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>  {
>  	int ret;
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  
> -	BUG_ON(!vgic_initialized(vcpu->kvm));
> -
>  	timer->active_cleared_last = false;
>  	timer->irq.level = new_level;
> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, host_vtimer_irq,
>  				   timer->irq.level);
> -	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> -					 timer->irq.irq,
> -					 timer->irq.level);
> -	WARN_ON(ret);
> +
> +	if (irqchip_in_kernel(vcpu->kvm)) {
> +		BUG_ON(!vgic_initialized(vcpu->kvm));
> +
> +		/* Fire the timer in the VGIC */
> +		ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
> +						 timer->irq.irq,
> +						 timer->irq.level);
> +
> +		WARN_ON(ret);
> +	} else {
> +		struct kvm_sync_regs *regs = &vcpu->run->s.regs;
> +
> +		/* Populate the timer bitmap for user space */
> +		regs->kernel_timer_pending &= ~KVM_ARM_TIMER_VTIMER;
> +		if (new_level)
> +			regs->kernel_timer_pending |= KVM_ARM_TIMER_VTIMER;

I think if you got here, it means you have to exit to userspace to
update it of the new state.  If you don't want to propagate a return
value from here, I think you should just not do anything an then later
compare timer->irq.level with whatever was last written to
run->kernel_timer_pending (which should be named something else than
pending).

> +	}
>  }
>  
>  /*
> @@ -197,7 +212,8 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>  	 * because the guest would never see the interrupt.  Instead wait
>  	 * until we call this function from kvm_timer_flush_hwstate.
>  	 */
> -	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
> +	if ((irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm)) ||
> +	    !timer->enabled)
>  		return -ENODEV;
>  
>  	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
> @@ -248,15 +264,20 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>   *
>   * Check if the virtual timer has expired while we were running in the host,
>   * and inject an interrupt if that was the case.
> + *
> + * Returns:
> + *
> + *    0  - success
> + *    1  - need exit to user space

this is opposite to all other exit-related APIs we have.  Why not just
return -EINTR?

>   */
> -void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
> +int kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>  	bool phys_active;
>  	int ret;
>  
>  	if (kvm_timer_update_state(vcpu))
> -		return;
> +		return 0;
>  
>  	/*
>  	* If we enter the guest with the virtual input level to the VGIC
> @@ -275,38 +296,61 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>  	* to ensure that hardware interrupts from the timer triggers a guest
>  	* exit.
>  	*/
> -	phys_active = timer->irq.level ||
> -			kvm_vgic_map_is_active(vcpu, timer->irq.irq);
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
> -	if (timer->active_cleared_last && !phys_active)
> -		return;
> -
> -	ret = irq_set_irqchip_state(host_vtimer_irq,
> -				    IRQCHIP_STATE_ACTIVE,
> -				    phys_active);
> -	WARN_ON(ret);
> +	if (irqchip_in_kernel(vcpu->kvm)) {
> +		phys_active = timer->irq.level ||
> +				kvm_vgic_map_is_active(vcpu, timer->irq.irq);
> +
> +		/*
> +		 * We want to avoid hitting the (re)distributor as much as
> +		 * possible, as this is a potentially expensive MMIO access
> +		 * (not to mention locks in the irq layer), and a solution for
> +		 * this is to cache the "active" state in memory.
> +		 *
> +		 * Things to consider: we cannot cache an "active set" state,
> +		 * because the HW can change this behind our back (it becomes
> +		 * "clear" in the HW). We must then restrict the caching to
> +		 * the "clear" state.
> +		 *
> +		 * The cache is invalidated on:
> +		 * - vcpu put, indicating that the HW cannot be trusted to be
> +		 *   in a sane state on the next vcpu load,
> +		 * - any change in the interrupt state
> +		 *
> +		 * Usage conditions:
> +		 * - cached value is "active clear"
> +		 * - value to be programmed is "active clear"
> +		 */
> +		if (timer->active_cleared_last && !phys_active)
> +			return 0;
> +
> +		ret = irq_set_irqchip_state(host_vtimer_irq,
> +					    IRQCHIP_STATE_ACTIVE,
> +					    phys_active);
> +		WARN_ON(ret);
> +	} else {
> +		struct kvm_sync_regs *regs = &vcpu->run->s.regs;
> +
> +		/*
> +		 * User space handles timer events, so we need to check whether
> +		 * its view of the world is in sync with ours.
> +		 */
> +		if (regs->kernel_timer_pending != regs->user_timer_pending) {
> +			/* Return to user space */
> +			return 1;
> +		}

Maybe I'm misunderstanding and user_timer_pending is just a cached
verison of what you said last, but as I said above, I think you can just
compare timer->irq.level with the last value the kvm_run struct, and if
something changed, you have to exit.

> +
> +		/*
> +		 * As long as user space is aware that the timer is pending,
> +		 * we do not need to get new host timer events.
> +		 */

yes, correct, but I don't think this concept was clearly reflected in
your API text above.

> +		if (timer->irq.level)
> +			disable_percpu_irq(host_vtimer_irq);
> +		else
> +			enable_percpu_irq(host_vtimer_irq, 0);
> +	}

could we move these two blocks into their own functions instead?  That
would also give nice names to the huge chunk of complicated
functionality, e.g. flush_timer_state_to_user() and
flush_timer_state_to_vgic().

>  
>  	timer->active_cleared_last = !phys_active;
> +	return 0;
>  }
>  
>  /**
> @@ -479,6 +523,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	if (timer->enabled)
>  		return 0;
>  
> +	/* No need to route physical IRQs when we don't use the vgic */
> +	if (!irqchip_in_kernel(vcpu->kvm))
> +		goto no_vgic;
> +
>  	/*
>  	 * Find the physical IRQ number corresponding to the host_vtimer_irq
>  	 */
> @@ -502,6 +550,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		return ret;
>  
> +no_vgic:
>  
>  	/*
>  	 * There is a potential race here between VCPUs starting for the first
> -- 
> 1.8.5.6
> 

Thanks,
-Christoffer
