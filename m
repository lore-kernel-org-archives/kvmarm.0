From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v4 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Tue, 20 Sep 2016 16:31:05 +0200
Message-ID: <57E14829.3060406@suse.de>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
 <1474283695-212421-3-git-send-email-agraf@suse.de> <57DFFAD3.3080009@arm.com>
 <0960d2a7-6100-3212-c544-d5377df34d57@suse.de> <57E0FF95.7040305@arm.com>
 <580a8a26-ca8f-a08a-a9da-d19d1a595cb6@suse.de> <57E103E8.7040506@arm.com>
 <57E109CF.8030705@suse.de> <57E10F37.3030002@arm.com>
 <57E12A02.7020907@suse.de> <57E12D98.6080008@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DB8249B32
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2016 10:22:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QpfSXDCapS3Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2016 10:22:05 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 01E11410D7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2016 10:22:04 -0400 (EDT)
In-Reply-To: <57E12D98.6080008@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 09/20/2016 02:37 PM, Marc Zyngier wrote:
> On 20/09/16 13:22, Alexander Graf wrote:
>> On 09/20/2016 12:28 PM, Marc Zyngier wrote:
>>> On 20/09/16 11:05, Alexander Graf wrote:
>>>> On 09/20/2016 11:39 AM, Marc Zyngier wrote:
>>>>> On 20/09/16 10:26, Alexander Graf wrote:
>>>>>> On 20.09.16 11:21, Marc Zyngier wrote:
>>>>>>> On 19/09/16 18:39, Alexander Graf wrote:
>>>>>>>> On 19.09.16 16:48, Marc Zyngier wrote:
>>>>>>>>> On 19/09/16 12:14, Alexander Graf wrote:
>>>>>>>>>> We have 2 modes for dealing with interrupts in the ARM world. We can either
>>>>>>>>>> handle them all using hardware acceleration through the vgic or we can emulate
>>>>>>>>>> a gic in user space and only drive CPU IRQ pins from there.
>>>>>>>>>>
>>>>>>>>>> Unfortunately, when driving IRQs from user space, we never tell user space
>>>>>>>>>> about timer events that may result in interrupt line state changes, so we
>>>>>>>>>> lose out on timer events if we run with user space gic emulation.
>>>>>>>>>>
>>>>>>>>>> This patch fixes that by routing vtimer expiration events to user space.
>>>>>>>>>> With this patch I can successfully run edk2 and Linux with user space gic
>>>>>>>>>> emulation.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Alexander Graf <agraf@suse.de>
>>>>>>>>>>
>>>>>>>>>> ---
>>>>>>>>>>
>>>>>>>>>> v1 -> v2:
>>>>>>>>>>
>>>>>>>>>>      - Add back curly brace that got lost
>>>>>>>>>>
>>>>>>>>>> v2 -> v3:
>>>>>>>>>>
>>>>>>>>>>      - Split into patch set
>>>>>>>>>>
>>>>>>>>>> v3 -> v4:
>>>>>>>>>>
>>>>>>>>>>      - Improve documentation
>>>>>>>>>> ---
>>>>>>>>>>     Documentation/virtual/kvm/api.txt |  30 ++++++++-
>>>>>>>>>>     arch/arm/include/asm/kvm_host.h   |   3 +
>>>>>>>>>>     arch/arm/kvm/arm.c                |  22 ++++---
>>>>>>>>>>     arch/arm64/include/asm/kvm_host.h |   3 +
>>>>>>>>>>     include/uapi/linux/kvm.h          |  14 +++++
>>>>>>>>>>     virt/kvm/arm/arch_timer.c         | 125 +++++++++++++++++++++++++++-----------
>>>>>>>>>>     6 files changed, 155 insertions(+), 42 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>>>>>>>>> index 23937e0..1c0bd86 100644
>>>>>>>>>> --- a/Documentation/virtual/kvm/api.txt
>>>>>>>>>> +++ b/Documentation/virtual/kvm/api.txt
>>>>>>>>>> @@ -3202,9 +3202,14 @@ struct kvm_run {
>>>>>>>>>>     	/* in */
>>>>>>>>>>     	__u8 request_interrupt_window;
>>>>>>>>>>     
>>>>>>>>>> -Request that KVM_RUN return when it becomes possible to inject external
>>>>>>>>>> +[x86] Request that KVM_RUN return when it becomes possible to inject external
>>>>>>>>>>     interrupts into the guest.  Useful in conjunction with KVM_INTERRUPT.
>>>>>>>>>>     
>>>>>>>>>> +[arm*] Bits set to 1 in here mask IRQ lines that would otherwise potentially
>>>>>>>>>> +trigger forever. These lines are available:
>>>>>>>>>> +
>>>>>>>>>> +    KVM_IRQWINDOW_VTIMER  -  Masks hw virtual timer irq while in guest
>>>>>>>>>> +
>>>>>>>>>>     	__u8 padding1[7];
>>>>>>>>>>     
>>>>>>>>>>     	/* out */
>>>>>>>>>> @@ -3519,6 +3524,18 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
>>>>>>>>>>     event/message pages and to enable/disable SynIC messages/events processing
>>>>>>>>>>     in userspace.
>>>>>>>>>>     
>>>>>>>>>> +		/* KVM_EXIT_ARM_TIMER */
>>>>>>>>>> +		struct {
>>>>>>>>>> +			__u8 timesource;
>>>>>>>>>> +		} arm_timer;
>>>>>>>>>> +
>>>>>>>>>> +Indicates that a timer triggered that user space needs to handle and
>>>>>>>>>> +potentially mask with vcpu->run->request_interrupt_window to allow the
>>>>>>>>>> +guest to proceed. This only happens for timers that got enabled through
>>>>>>>>>> +KVM_CAP_ARM_TIMER. The following time sources are available:
>>>>>>>>>> +
>>>>>>>>>> +    KVM_ARM_TIMER_VTIMER  - virtual cpu timer
>>>>>>>>>> +
>>>>>>>>>>     		/* Fix the size of the union. */
>>>>>>>>>>     		char padding[256];
>>>>>>>>>>     	};
>>>>>>>>>> @@ -3739,6 +3756,17 @@ Once this is done the KVM_REG_MIPS_VEC_* and KVM_REG_MIPS_MSA_* registers can be
>>>>>>>>>>     accessed, and the Config5.MSAEn bit is accessible via the KVM API and also from
>>>>>>>>>>     the guest.
>>>>>>>>>>     
>>>>>>>>>> +6.11 KVM_CAP_ARM_TIMER
>>>>>>>>>> +
>>>>>>>>>> +Architectures: arm, arm64
>>>>>>>>>> +Target: vcpu
>>>>>>>>>> +Parameters: args[0] contains a bitmap of timers to select (see 5.)
>>>>>>>>>> +
>>>>>>>>>> +This capability allows to route per-core timers into user space. When it's
>>>>>>>>>> +enabled and no in-kernel interrupt controller is in use, the timers selected
>>>>>>>>>> +by args[0] trigger KVM_EXIT_ARM_TIMER guest exits when they are pending,
>>>>>>>>>> +unless masked by vcpu->run->request_interrupt_window (see 5.).
>>>>>>>>>> +
>>>>>>>>>>     7. Capabilities that can be enabled on VMs
>>>>>>>>>>     ------------------------------------------
>>>>>>>>>>     
>>>>>>>>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>>>>>>>>> index de338d9..77d1f73 100644
>>>>>>>>>> --- a/arch/arm/include/asm/kvm_host.h
>>>>>>>>>> +++ b/arch/arm/include/asm/kvm_host.h
>>>>>>>>>> @@ -180,6 +180,9 @@ struct kvm_vcpu_arch {
>>>>>>>>>>     
>>>>>>>>>>     	/* Detect first run of a vcpu */
>>>>>>>>>>     	bool has_run_once;
>>>>>>>>>> +
>>>>>>>>>> +	/* User space wants timer notifications */
>>>>>>>>>> +	bool user_space_arm_timers;
>>>>>>>>> Please move this to the timer structure.
>>>>>>>> Sure.
>>>>>>>>
>>>>>>>>>>     };
>>>>>>>>>>     
>>>>>>>>>>     struct kvm_vm_stat {
>>>>>>>>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>>>>>>>>> index c84b6ad..57bdb71 100644
>>>>>>>>>> --- a/arch/arm/kvm/arm.c
>>>>>>>>>> +++ b/arch/arm/kvm/arm.c
>>>>>>>>>> @@ -187,6 +187,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>>>>>>     	case KVM_CAP_ARM_PSCI_0_2:
>>>>>>>>>>     	case KVM_CAP_READONLY_MEM:
>>>>>>>>>>     	case KVM_CAP_MP_STATE:
>>>>>>>>>> +	case KVM_CAP_ARM_TIMER:
>>>>>>>>>>     		r = 1;
>>>>>>>>>>     		break;
>>>>>>>>>>     	case KVM_CAP_COALESCED_MMIO:
>>>>>>>>>> @@ -474,13 +475,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>>>>>>>>>>     			return ret;
>>>>>>>>>>     	}
>>>>>>>>>>     
>>>>>>>>>> -	/*
>>>>>>>>>> -	 * Enable the arch timers only if we have an in-kernel VGIC
>>>>>>>>>> -	 * and it has been properly initialized, since we cannot handle
>>>>>>>>>> -	 * interrupts from the virtual timer with a userspace gic.
>>>>>>>>>> -	 */
>>>>>>>>>> -	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
>>>>>>>>>> -		ret = kvm_timer_enable(vcpu);
>>>>>>>>>> +	ret = kvm_timer_enable(vcpu);
>>>>>>>>>>     
>>>>>>>>>>     	return ret;
>>>>>>>>>>     }
>>>>>>>>>> @@ -601,6 +596,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>>>>>>>>     			run->exit_reason = KVM_EXIT_INTR;
>>>>>>>>>>     		}
>>>>>>>>>>     
>>>>>>>>>> +		if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
>>>>>>>>> Since this is a very unlikely event (in the grand scheme of things), how
>>>>>>>>> about making this unlikely()?
>>>>>>>>>
>>>>>>>>>> +			/* Tell user space about the pending vtimer */
>>>>>>>>>> +			ret = 0;
>>>>>>>>>> +			run->exit_reason = KVM_EXIT_ARM_TIMER;
>>>>>>>>>> +			run->arm_timer.timesource = KVM_ARM_TIMER_VTIMER;
>>>>>>>>>> +		}
>>>>>>>>> More importantly: why does it have to be indirected by a
>>>>>>>>> make_request/check_request, and not be handled as part of the
>>>>>>>>> kvm_timer_sync() call? We do update the state there, and you could
>>>>>>>>> directly find out whether an exit is required.
>>>>>>>> I can try - it seemed like it could easily become quite racy because we
>>>>>>>> call kvm_timer_sync_hwstate() at multiple places.
>>>>>>> It shouldn't. We only do it at exactly two locations (depending whether
>>>>>>> we've entered the guest or not).
>>>>>>>
>>>>>>> Also, take the following scenario:
>>>>>>> (1) guest programs the timer to expire at time T
>>>>>>> (2) guest performs an MMIO access which traps
>>>>>>> (3) during the world switch, the timer expires and we mark the timer
>>>>>>> interrupt as pending
>>>>>>> (4) we exit to handle the MMIO, no sign of the timer being pending
>>>>>>>
>>>>>>> Is the timer event lost? Or simply delayed? I think this indicates that
>>>>>>> the timer state should always be signalled to userspace, no matter what
>>>>>>> the exit reason is.
>>>>>> That's basically what I'm trying to get running right now, yes. I pushed
>>>>>> the interrupt pending status field into the kvm_sync_regs struct and
>>>>>> check it on every exit in user space - to make sure we catch pending
>>>>>> state changes before mmio reads.
>>>>>>
>>>>>> On top of that we also need a force exit event when the state changes,
>>>>>> in case there's no other event pending. Furthermore we probably want to
>>>>>> indicate the user space status of the pending bit into the kernel to not
>>>>>> exit too often.
>>>>> All you need is to do is to stash the line state in the run structure.
>>>> That's what I do now, yes. The sync_regs struct is basically an arch
>>>> specific add-on to the run structure, so we don't modify padding /
>>>> alignment with the change.
>>>>
>>>>> You shouldn't need any other information. And you trigger the exit on
>>>>> "timer line high + timer line unmasked" in order to inject the
>>>>> interrupt. Which is basically what the vgic does. It would greatly help
>>>>> if you adopted a similar behaviour.
>>>> We also need to know "timer line low + timer line masked", as otherwise
>>>> we might get spurious interrupts in the guest, no?
>>> Yes. Though you can't really know about this one, and you'll have to
>>> wait until the next natural exit to find out. As long as the spurious is
>> We can provoke a special exit for it, no?
> How? The guest decides to disable its timer. That doesn't trigger any
> exit whatsoever. You'll have to wait until the next exit from the guest
> to notice it.

Before we inject a timer interrupt, we can check whether the pending 
semantics of user space / kernel space match. If they don't match, we 
can exit before we inject the interrupt and allow user space to disable 
the pending state again.

>
>>> "spurious in the GIC sense" (hence returning 0x3ff) and not a spurious
>>> timer interrupt being presented, you're fine.
>> Imagine
>>
>>     * guest configures timer to fire
>>     * kvm exits to user space because lines mismatch now
> I suppose you mean timer fired + physical interrupt for the virtual enabled?

In this scheme, I would simply say "user space thinks it's pending" == 
"host vtimer irq is masked". So because user space thinks that no timer 
is pending and the guest managed to trigger a vtimer irq on the host, 
the guest exited on a physical vtimer irq. Kvm then checks whether the 
timer expired and sets the vcpu timer pending status to 1. User space 
status is still 0, so kvm exits to user space to update the status.

>
>>     * user space sets gic line up, setting vcpu irq line high
>>     * guest runs, handles IRQ, calls EOI with IRQs disabled on the core
> Same thing: you mean physical interrupt for the virtual timer disabled?
> or something else?

I mean the guest sets pstate.I = 0.

>
>>     * user space handles EOI, but still leaves the vcpu line high
> If there is another pending interrupt, sure. Otherwise, that's a bug.

Why is that a bug? The line really is still pending at this point.

>
>>     * guest runs, sets cval, enables IRQs on the core
> What is that interrupt? Please name things, because that's very confusing.

The guest sets pstate.I=1.

>
>>     * kvm injects a timer interrupt into the guest
> Why? Has the timer fired?

cntv.ctl.imask = 0 here, but user space doesn't know that yet. So the 
"pending" state is still active.

>
>> At this point, the pending state from user space is bogus, as the line
>> really isn't pending anymore. However, when the guest asks the GIC at
>> that point what interrupt is pending, the line down state will have
>> populated into user space before the mmio request gets processed. So you
>> will see a 0x3ff return I guess.
>>
>> Is that reasonable?
> I'm sorry, but you need to put names on things and precisely describe
> the various events. because from the above script, I can derive twenty
> different scenarios...

I'm sure one of them has to be racy? :)

(in fact, there are probably more than what I came up with that really 
are...)

Alex
