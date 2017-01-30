From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v2 05/10] KVM: arm/arm64: Initialize the emulated EL1
 physical timer
Date: Mon, 30 Jan 2017 17:44:20 +0000
Message-ID: <57b57b31-b8ad-f5c8-a1fc-4cde9a564dd2@arm.com>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
 <1485479100-4966-6-git-send-email-jintack@cs.columbia.edu>
 <86wpde83xn.fsf@arm.com> <20170130145816.GC16459@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170130145816.GC16459@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Jintack Lim <jintack@cs.columbia.edu>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/17 14:58, Christoffer Dall wrote:
> On Sun, Jan 29, 2017 at 12:07:48PM +0000, Marc Zyngier wrote:
>> On Fri, Jan 27 2017 at 01:04:55 AM, Jintack Lim <jintack@cs.columbia.edu> wrote:
>>> Initialize the emulated EL1 physical timer with the default irq number.
>>>
>>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>>> ---
>>>  arch/arm/kvm/reset.c         | 9 ++++++++-
>>>  arch/arm64/kvm/reset.c       | 9 ++++++++-
>>>  include/kvm/arm_arch_timer.h | 3 ++-
>>>  virt/kvm/arm/arch_timer.c    | 9 +++++++--
>>>  4 files changed, 25 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
>>> index 4b5e802..1da8b2d 100644
>>> --- a/arch/arm/kvm/reset.c
>>> +++ b/arch/arm/kvm/reset.c
>>> @@ -37,6 +37,11 @@
>>>  	.usr_regs.ARM_cpsr = SVC_MODE | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT,
>>>  };
>>>  
>>> +static const struct kvm_irq_level cortexa_ptimer_irq = {
>>> +	{ .irq = 30 },
>>> +	.level = 1,
>>> +};
>>
>> At some point, we'll have to make that discoverable/configurable. Maybe
>> the time for a discoverable arch timer has come (see below).
>>
>>> +
>>>  static const struct kvm_irq_level cortexa_vtimer_irq = {
>>>  	{ .irq = 27 },
>>>  	.level = 1,
>>> @@ -58,6 +63,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct kvm_regs *reset_regs;
>>>  	const struct kvm_irq_level *cpu_vtimer_irq;
>>> +	const struct kvm_irq_level *cpu_ptimer_irq;
>>>  
>>>  	switch (vcpu->arch.target) {
>>>  	case KVM_ARM_TARGET_CORTEX_A7:
>>> @@ -65,6 +71,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  		reset_regs = &cortexa_regs_reset;
>>>  		vcpu->arch.midr = read_cpuid_id();
>>>  		cpu_vtimer_irq = &cortexa_vtimer_irq;
>>> +		cpu_ptimer_irq = &cortexa_ptimer_irq;
>>>  		break;
>>>  	default:
>>>  		return -ENODEV;
>>> @@ -77,5 +84,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  	kvm_reset_coprocs(vcpu);
>>>  
>>>  	/* Reset arch_timer context */
>>> -	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
>>> +	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
>>>  }
>>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>>> index e95d4f6..d9e9697 100644
>>> --- a/arch/arm64/kvm/reset.c
>>> +++ b/arch/arm64/kvm/reset.c
>>> @@ -46,6 +46,11 @@
>>>  			COMPAT_PSR_I_BIT | COMPAT_PSR_F_BIT),
>>>  };
>>>  
>>> +static const struct kvm_irq_level default_ptimer_irq = {
>>> +	.irq	= 30,
>>> +	.level	= 1,
>>> +};
>>> +
>>>  static const struct kvm_irq_level default_vtimer_irq = {
>>>  	.irq	= 27,
>>>  	.level	= 1,
>>> @@ -104,6 +109,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>>>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  {
>>>  	const struct kvm_irq_level *cpu_vtimer_irq;
>>> +	const struct kvm_irq_level *cpu_ptimer_irq;
>>>  	const struct kvm_regs *cpu_reset;
>>>  
>>>  	switch (vcpu->arch.target) {
>>> @@ -117,6 +123,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  		}
>>>  
>>>  		cpu_vtimer_irq = &default_vtimer_irq;
>>> +		cpu_ptimer_irq = &default_ptimer_irq;
>>>  		break;
>>>  	}
>>>  
>>> @@ -130,5 +137,5 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>>  	kvm_pmu_vcpu_reset(vcpu);
>>>  
>>>  	/* Reset timer */
>>> -	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq);
>>> +	return kvm_timer_vcpu_reset(vcpu, cpu_vtimer_irq, cpu_ptimer_irq);
>>>  }
>>> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
>>> index 69f648b..a364593 100644
>>> --- a/include/kvm/arm_arch_timer.h
>>> +++ b/include/kvm/arm_arch_timer.h
>>> @@ -59,7 +59,8 @@ struct arch_timer_cpu {
>>>  int kvm_timer_enable(struct kvm_vcpu *vcpu);
>>>  void kvm_timer_init(struct kvm *kvm);
>>>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>> -			 const struct kvm_irq_level *irq);
>>> +			 const struct kvm_irq_level *virt_irq,
>>> +			 const struct kvm_irq_level *phys_irq);
>>>  void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
>>>  void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
>>>  void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index f72005a..0f6e935 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -329,9 +329,11 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
>>>  }
>>>  
>>>  int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>> -			 const struct kvm_irq_level *irq)
>>> +			 const struct kvm_irq_level *virt_irq,
>>> +			 const struct kvm_irq_level *phys_irq)
>>>  {
>>>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>>> +	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>>>  
>>>  	/*
>>>  	 * The vcpu timer irq number cannot be determined in
>>> @@ -339,7 +341,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>>  	 * kvm_vcpu_set_target(). To handle this, we determine
>>>  	 * vcpu timer irq number when the vcpu is reset.
>>>  	 */
>>> -	vtimer->irq.irq = irq->irq;
>>> +	vtimer->irq.irq = virt_irq->irq;
>>> +	ptimer->irq.irq = phys_irq->irq;
>>>  
>>>  	/*
>>>  	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
>>> @@ -348,6 +351,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
>>>  	 * the ARMv7 architecture.
>>>  	 */
>>>  	vtimer->cnt_ctl = 0;
>>> +	ptimer->cnt_ctl = 0;
>>>  	kvm_timer_update_state(vcpu);
>>>  
>>>  	return 0;
>>> @@ -369,6 +373,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>>  
>>>  	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
>>> +	vcpu_ptimer(vcpu)->cntvoff = 0;
>>
>> This is quite contentious, IMHO. Do we really want to expose the delta
>> between the virtual and physical counters? That's a clear indication to
>> the guest that it is virtualized. I"m not sure it matters, but I think
>> we should at least make a conscious choice, and maybe give the
>> opportunity to userspace to select the desired behaviour.
>>
> 
> So my understanding of the architecture is that you should always have
> two timer/counter pairs available at EL1.  They may be synchronized, and
> they may not.  If you want an accurate reading of wall clock time, look
> at the physical counter, and that can generally be expected to be fast,
> precise, and syncrhonized (on working hardware, of course).
> 
> Now, there can be a constant or potentially monotonically increasing
> offset between the physial and virtual counters, which may mean you're
> running under a hypervisor or (in the first case) that firmware
> programmed or neglected to program cntvoff.  I don't think it's an
> inherent problem to expose that difference to a guest, and I think it's
> more important that reading the physical counter is fast and doesn't
> trap.
> 
> The question is which contract we can have with a guest OS, and which
> legacy we have to keep supporting (Linux, UEFI, ?).
> 
> Probably Linux should keep relying on the virtual counter/timer only,
> unless something is advertised in DT/ACPI, about it being able to use
> the physical timer/counter pair, even when booted at EL1.  We could
> explore the opportunities to build on that to let the guest figure
> out stolen time by reading the two counters and by programming the
> proper timer depending on the desired semantics (i.e. virtual or
> physical time).
> 
> In terms of this patch, I actually think it's fine, but we may need to
> build something more on top later.  It is possible, though, that I'm
> entirely missing the point about Linux timekeeping infrastructure and
> that my reading of the architecture is bogus.
> 
> What do you think?

I don't disagree with any of this (hopefully I was clearer in my reply
to the cover letter). Wventually, we'll have to support an offset-able
physical counter to support nested virtualization, but this can come at
a later time.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
