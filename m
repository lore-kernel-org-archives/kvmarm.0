From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v4 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Mon, 19 Sep 2016 19:39:12 +0200
Message-ID: <0960d2a7-6100-3212-c544-d5377df34d57@suse.de>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
 <1474283695-212421-3-git-send-email-agraf@suse.de> <57DFFAD3.3080009@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57DFFAD3.3080009@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, drjones@redhat.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 19.09.16 16:48, Marc Zyngier wrote:
> On 19/09/16 12:14, Alexander Graf wrote:
>> We have 2 modes for dealing with interrupts in the ARM world. We can either
>> handle them all using hardware acceleration through the vgic or we can emulate
>> a gic in user space and only drive CPU IRQ pins from there.
>>
>> Unfortunately, when driving IRQs from user space, we never tell user space
>> about timer events that may result in interrupt line state changes, so we
>> lose out on timer events if we run with user space gic emulation.
>>
>> This patch fixes that by routing vtimer expiration events to user space.
>> With this patch I can successfully run edk2 and Linux with user space gic
>> emulation.
>>
>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>
>> ---
>>
>> v1 -> v2:
>>
>>   - Add back curly brace that got lost
>>
>> v2 -> v3:
>>
>>   - Split into patch set
>>
>> v3 -> v4:
>>
>>   - Improve documentation
>> ---
>>  Documentation/virtual/kvm/api.txt |  30 ++++++++-
>>  arch/arm/include/asm/kvm_host.h   |   3 +
>>  arch/arm/kvm/arm.c                |  22 ++++---
>>  arch/arm64/include/asm/kvm_host.h |   3 +
>>  include/uapi/linux/kvm.h          |  14 +++++
>>  virt/kvm/arm/arch_timer.c         | 125 +++++++++++++++++++++++++++-----------
>>  6 files changed, 155 insertions(+), 42 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 23937e0..1c0bd86 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -3202,9 +3202,14 @@ struct kvm_run {
>>  	/* in */
>>  	__u8 request_interrupt_window;
>>  
>> -Request that KVM_RUN return when it becomes possible to inject external
>> +[x86] Request that KVM_RUN return when it becomes possible to inject external
>>  interrupts into the guest.  Useful in conjunction with KVM_INTERRUPT.
>>  
>> +[arm*] Bits set to 1 in here mask IRQ lines that would otherwise potentially
>> +trigger forever. These lines are available:
>> +
>> +    KVM_IRQWINDOW_VTIMER  -  Masks hw virtual timer irq while in guest
>> +
>>  	__u8 padding1[7];
>>  
>>  	/* out */
>> @@ -3519,6 +3524,18 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
>>  event/message pages and to enable/disable SynIC messages/events processing
>>  in userspace.
>>  
>> +		/* KVM_EXIT_ARM_TIMER */
>> +		struct {
>> +			__u8 timesource;
>> +		} arm_timer;
>> +
>> +Indicates that a timer triggered that user space needs to handle and
>> +potentially mask with vcpu->run->request_interrupt_window to allow the
>> +guest to proceed. This only happens for timers that got enabled through
>> +KVM_CAP_ARM_TIMER. The following time sources are available:
>> +
>> +    KVM_ARM_TIMER_VTIMER  - virtual cpu timer
>> +
>>  		/* Fix the size of the union. */
>>  		char padding[256];
>>  	};
>> @@ -3739,6 +3756,17 @@ Once this is done the KVM_REG_MIPS_VEC_* and KVM_REG_MIPS_MSA_* registers can be
>>  accessed, and the Config5.MSAEn bit is accessible via the KVM API and also from
>>  the guest.
>>  
>> +6.11 KVM_CAP_ARM_TIMER
>> +
>> +Architectures: arm, arm64
>> +Target: vcpu
>> +Parameters: args[0] contains a bitmap of timers to select (see 5.)
>> +
>> +This capability allows to route per-core timers into user space. When it's
>> +enabled and no in-kernel interrupt controller is in use, the timers selected
>> +by args[0] trigger KVM_EXIT_ARM_TIMER guest exits when they are pending,
>> +unless masked by vcpu->run->request_interrupt_window (see 5.).
>> +
>>  7. Capabilities that can be enabled on VMs
>>  ------------------------------------------
>>  
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index de338d9..77d1f73 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -180,6 +180,9 @@ struct kvm_vcpu_arch {
>>  
>>  	/* Detect first run of a vcpu */
>>  	bool has_run_once;
>> +
>> +	/* User space wants timer notifications */
>> +	bool user_space_arm_timers;
> 
> Please move this to the timer structure.

Sure.

> 
>>  };
>>  
>>  struct kvm_vm_stat {
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index c84b6ad..57bdb71 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -187,6 +187,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_PSCI_0_2:
>>  	case KVM_CAP_READONLY_MEM:
>>  	case KVM_CAP_MP_STATE:
>> +	case KVM_CAP_ARM_TIMER:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_COALESCED_MMIO:
>> @@ -474,13 +475,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>>  			return ret;
>>  	}
>>  
>> -	/*
>> -	 * Enable the arch timers only if we have an in-kernel VGIC
>> -	 * and it has been properly initialized, since we cannot handle
>> -	 * interrupts from the virtual timer with a userspace gic.
>> -	 */
>> -	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
>> -		ret = kvm_timer_enable(vcpu);
>> +	ret = kvm_timer_enable(vcpu);
>>  
>>  	return ret;
>>  }
>> @@ -601,6 +596,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  			run->exit_reason = KVM_EXIT_INTR;
>>  		}
>>  
>> +		if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
> 
> Since this is a very unlikely event (in the grand scheme of things), how
> about making this unlikely()?
> 
>> +			/* Tell user space about the pending vtimer */
>> +			ret = 0;
>> +			run->exit_reason = KVM_EXIT_ARM_TIMER;
>> +			run->arm_timer.timesource = KVM_ARM_TIMER_VTIMER;
>> +		}
> 
> More importantly: why does it have to be indirected by a
> make_request/check_request, and not be handled as part of the
> kvm_timer_sync() call? We do update the state there, and you could
> directly find out whether an exit is required.

I can try - it seemed like it could easily become quite racy because we
call kvm_timer_sync_hwstate() at multiple places.

> 
>> +
>>  		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
>>  			vcpu->arch.power_off || vcpu->arch.pause) {
>>  			local_irq_enable();
>> @@ -887,6 +889,12 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>>  		return -EINVAL;
>>  
>>  	switch (cap->cap) {
>> +	case KVM_CAP_ARM_TIMER:
>> +		r = 0;
>> +		if (cap->args[0] != KVM_ARM_TIMER_VTIMER)
>> +			return -EINVAL;
>> +		vcpu->arch.user_space_arm_timers = true;
>> +		break;
>>  	default:
>>  		r = -EINVAL;
>>  		break;
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 3eda975..3d01481 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -270,6 +270,9 @@ struct kvm_vcpu_arch {
>>  
>>  	/* Detect first run of a vcpu */
>>  	bool has_run_once;
>> +
>> +	/* User space wants timer notifications */
>> +	bool user_space_arm_timers;
>>  };
>>  
>>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 300ef25..00f4948 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -205,6 +205,7 @@ struct kvm_hyperv_exit {
>>  #define KVM_EXIT_S390_STSI        25
>>  #define KVM_EXIT_IOAPIC_EOI       26
>>  #define KVM_EXIT_HYPERV           27
>> +#define KVM_EXIT_ARM_TIMER        28
>>  
>>  /* For KVM_EXIT_INTERNAL_ERROR */
>>  /* Emulate instruction failed. */
>> @@ -361,6 +362,10 @@ struct kvm_run {
>>  		} eoi;
>>  		/* KVM_EXIT_HYPERV */
>>  		struct kvm_hyperv_exit hyperv;
>> +		/* KVM_EXIT_ARM_TIMER */
>> +		struct {
>> +			__u8 timesource;
>> +		} arm_timer;
>>  		/* Fix the size of the union. */
>>  		char padding[256];
>>  	};
>> @@ -870,6 +875,7 @@ struct kvm_ppc_smmu_info {
>>  #define KVM_CAP_S390_USER_INSTR0 130
>>  #define KVM_CAP_MSI_DEVID 131
>>  #define KVM_CAP_PPC_HTM 132
>> +#define KVM_CAP_ARM_TIMER 133
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> @@ -1327,4 +1333,12 @@ struct kvm_assigned_msix_entry {
>>  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
>>  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
>>  
>> +/* Available with KVM_CAP_ARM_TIMER */
>> +
>> +/* Bits for run->request_interrupt_window */
>> +#define KVM_IRQWINDOW_VTIMER		(1 << 0)
>> +
>> +/* Bits for run->arm_timer.timesource */
>> +#define KVM_ARM_TIMER_VTIMER		(1 << 0)
>> +
>>  #endif /* __LINUX_KVM_H */
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index 4309b60..cbbb50dd 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -170,16 +170,45 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>>  {
>>  	int ret;
>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> +	struct kvm_run *run = vcpu->run;
>>  
>> -	BUG_ON(!vgic_initialized(vcpu->kvm));
>> +	BUG_ON(irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm));
>>  
>>  	timer->active_cleared_last = false;
>>  	timer->irq.level = new_level;
>> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
>> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, host_vtimer_irq,
>>  				   timer->irq.level);
>> -	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
>> -					 timer->irq.irq,
>> -					 timer->irq.level);
>> +
>> +	if (irqchip_in_kernel(vcpu->kvm) && vgic_initialized(vcpu->kvm)) {
> 
> Given how many times you repeat this idiom in this patch, you should
> have a single condition that encapsulate it once and for all.

Sure.

> 
>> +		/* Fire the timer in the VGIC */
>> +
>> +		ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
>> +						 timer->irq.irq,
>> +						 timer->irq.level);
>> +	} else if (!vcpu->arch.user_space_arm_timers) {
>> +		/* User space has not activated timer use */
>> +		ret = 0;
>> +	} else {
>> +		/*
>> +		 * Set PENDING_TIMER so that user space can handle the event if
>> +		 *
>> +		 *   1) Level is high
>> +		 *   2) The vtimer is not suppressed by user space
>> +		 *   3) We are not in the timer trigger exit path
>> +		 */
>> +		if (new_level &&
>> +		    !(run->request_interrupt_window & KVM_IRQWINDOW_VTIMER) &&
>> +		    (run->exit_reason != KVM_EXIT_ARM_TIMER)) {
>> +			/* KVM_REQ_PENDING_TIMER means vtimer triggered */
>> +			kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
>> +		}
>> +
>> +		/* Force a new level high check on next entry */
>> +		timer->irq.level = 0;
> 
> I think this could become a bit more simple if you follow the flow I
> mentioned earlier involving kvm_timer_sync(). Also, I only see how you
> flag the line as being high, but not how you lower it. Care to explain
> that flow?

We convert the level triggered timer into an edge up event (kvm exit).
It's then up to user space to poll for the down event. Usually that will
happen when the guest fiddles with the interrupt controller (eoi, enable
line, etc).

Can you think of a different option? We could maybe verify 2 kvm_run
elements on guest entry and just see if they're identical: user space
"active" line and arch timer "IMASK" bit. If not, exit to user space and
let it update its state?

That should at least get rid of any chance for spurious interrupts.

> 
>> +
>> +		ret = 0;
>> +	}
>> +
>>  	WARN_ON(ret);
>>  }
>>  
>> @@ -197,7 +226,8 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>>  	 * because the guest would never see the interrupt.  Instead wait
>>  	 * until we call this function from kvm_timer_flush_hwstate.
>>  	 */
>> -	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
>> +	if ((irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm)) ||
>> +	    !timer->enabled)
>>  		return -ENODEV;
>>  
>>  	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
>> @@ -275,35 +305,57 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
>>  	* to ensure that hardware interrupts from the timer triggers a guest
>>  	* exit.
>>  	*/
>> -	phys_active = timer->irq.level ||
>> -			kvm_vgic_map_is_active(vcpu, timer->irq.irq);
>> -
>> -	/*
>> -	 * We want to avoid hitting the (re)distributor as much as
>> -	 * possible, as this is a potentially expensive MMIO access
>> -	 * (not to mention locks in the irq layer), and a solution for
>> -	 * this is to cache the "active" state in memory.
>> -	 *
>> -	 * Things to consider: we cannot cache an "active set" state,
>> -	 * because the HW can change this behind our back (it becomes
>> -	 * "clear" in the HW). We must then restrict the caching to
>> -	 * the "clear" state.
>> -	 *
>> -	 * The cache is invalidated on:
>> -	 * - vcpu put, indicating that the HW cannot be trusted to be
>> -	 *   in a sane state on the next vcpu load,
>> -	 * - any change in the interrupt state
>> -	 *
>> -	 * Usage conditions:
>> -	 * - cached value is "active clear"
>> -	 * - value to be programmed is "active clear"
>> -	 */
>> -	if (timer->active_cleared_last && !phys_active)
>> -		return;
>> +	if (irqchip_in_kernel(vcpu->kvm) && vgic_initialized(vcpu->kvm)) {
>> +		phys_active = timer->irq.level ||
>> +				kvm_vgic_map_is_active(vcpu, timer->irq.irq);
>> +
>> +		/*
>> +		 * We want to avoid hitting the (re)distributor as much as
>> +		 * possible, as this is a potentially expensive MMIO access
>> +		 * (not to mention locks in the irq layer), and a solution for
>> +		 * this is to cache the "active" state in memory.
>> +		 *
>> +		 * Things to consider: we cannot cache an "active set" state,
>> +		 * because the HW can change this behind our back (it becomes
>> +		 * "clear" in the HW). We must then restrict the caching to
>> +		 * the "clear" state.
>> +		 *
>> +		 * The cache is invalidated on:
>> +		 * - vcpu put, indicating that the HW cannot be trusted to be
>> +		 *   in a sane state on the next vcpu load,
>> +		 * - any change in the interrupt state
>> +		 *
>> +		 * Usage conditions:
>> +		 * - cached value is "active clear"
>> +		 * - value to be programmed is "active clear"
>> +		 */
>> +		if (timer->active_cleared_last && !phys_active)
>> +			return;
>> +
>> +		ret = irq_set_irqchip_state(host_vtimer_irq,
>> +					    IRQCHIP_STATE_ACTIVE,
>> +					    phys_active);
>> +	} else {
>> +		/* User space tells us whether the timer is in active mode */
>> +		phys_active = vcpu->run->request_interrupt_window &
>> +			      KVM_IRQWINDOW_VTIMER;
> 
> No, this just says "mask the interrupt". It doesn't say anything about
> the state of the timer. More importantly: you sample the shared page.
> What guarantees that the information there is preserved? Is userspace
> writing that bit each time the vcpu thread re-enters the kernel with
> this interrupt being in flight?

The bit is owned by user space, so it has to guarantee that it stays.
It's the way the kvm_run struct rolls :).

> 
>> +
>> +		/* However if the line is high, we exit anyway, so we want
>> +		 * to keep the IRQ masked */
>> +		phys_active = phys_active || timer->irq.level;
> 
> Why would you force the interrupt to be masked as soon as the timer is
> firing? If userspace hasn't masked it, I don't think you should paper
> over it.

This is to make sure that when we hit the second call to
kvm_timer_sync_hwstate() in the exit path, we ignore it. We always set
timer->irq.level = 0 in kvm_timer_update_irq.

> 
>> +
>> +		/*
>> +		 * So we can just explicitly mask or unmask the IRQ, gaining
>> +		 * more compatibility with oddball irq controllers.
>> +		 */
>> +		if (phys_active)
>> +			disable_percpu_irq(host_vtimer_irq);
>> +		else
>> +			enable_percpu_irq(host_vtimer_irq, 0);
> 
> Since you are now targeting random irqchips (as opposed to a GIC
> specifically), what guarantees that the timer is a per-cpu IRQ?

This is the host interrupt controller - and we're already using percpu
irqs on it :). Also as it happens the RPi has them percpu (anything else
wouldn't make sense...).


Alex
