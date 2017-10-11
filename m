From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 09/20] KVM: arm/arm64: mask/unmask daif around VHE
 guests
Date: Wed, 11 Oct 2017 16:40:57 +0100
Message-ID: <59DE3B89.6090005@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>	<20171005191812.5678-10-james.morse@arm.com>
 <87lgkijbwk.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6CA149D56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 11:41:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ox1u3rRUZ+HL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Oct 2017 11:41:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33EE449D3A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Oct 2017 11:41:53 -0400 (EDT)
In-Reply-To: <87lgkijbwk.fsf@on-the-bus.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jonathan.Zhang@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 11/10/17 10:01, Marc Zyngier wrote:
> On Thu, Oct 05 2017 at  8:18:01 pm BST, James Morse <james.morse@arm.com> wrote:
>> Non-VHE systems take an exception to EL2 in order to world-switch into the
>> guest. When returning from the guest KVM implicitly restores the DAIF
>> flags when it returns to the kernel at EL1.
>>
>> With VHE none of this exception-level jumping happens, so KVMs
>> world-switch code is exposed to the host kernel's DAIF values, and KVM
>> spills the guest-exit DAIF values back into the host kernel.
>> On entry to a guest we have Debug and SError exceptions unmasked, KVM
>> has switched VBAR but isn't prepared to handle these. On guest exit
>> Debug exceptions are left disabled once we return to the host and will
>> stay this way until we enter user space.
>>
>> Add a helper to mask/unmask DAIF around VHE guests. The unmask can only
>> happen after the hosts VBAR value has been synchronised by the isb in
>> __vhe_hyp_call (via kvm_call_hyp()). Masking could be as late as
>> setting KVMs VBAR value, but is kept here for symmetry.


>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index b9f68e4add71..665529924b34 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -698,9 +698,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>  		 */
>>  		trace_kvm_entry(*vcpu_pc(vcpu));
>>  		guest_enter_irqoff();
>> +		if (has_vhe())
>> +			kvm_arm_vhe_guest_enter();
>>  
>>  		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>>  
>> +		if (has_vhe())
>> +			kvm_arm_vhe_guest_exit();
>>  		vcpu->mode = OUTSIDE_GUEST_MODE;
>>  		vcpu->stat.exits++;
>>  		/*

> Why is that masking limited to entering/exiting the guest? I would have
> though that it would have been put in the kvm_call_hyp helper, in order
> to cover all "HYP" accesses.

> Or is it that you've worked out that only
> the guest run actually requires this because none of the other HYP
> helpers are changing the flags?

That too... Christoffer made the case[0] that for VHE the existing 'hyp code'
shouldn't be considered as running in a 'special EL2 mode':
> The rationale being that in the long run we want to keep "jumping to
> hyp" the oddball legacy case, where everything else is just the
> kernel/hypervisor functionality.

This lets us take interrupts out of e.g. __kvm_tlb_flush_local_vmid().

These are the things kvm calls via kvm_call_hyp():
> __kvm_get_mdcr_el2
> __init_stage2_translation
> __kvm_tlb_flush_local_vmid
> __kvm_flush_vm_context
> __kvm_vcpu_run
> __kvm_tlb_flush_vmid
> __kvm_tlb_flush_vmid_ipa
> __vgic_v3_init_lrs
> __vgic_v3_get_ich_vtr_el2
> __vgic_v3_write_vmcr
> __vgic_v3_read_vmcr

These all read/write system-registers, but only __kvm_vcpu_run() manipulates the
flags due to taking an exception to exit the guest.

__kvm_vcpu_run() should also be masking exceptions when it changes VBAR.

Only __kvm_vcpu_run() needs wrapping like this, if any other helper touches the
debug registers or exception-routing I think it would need to do similar for VHE.

(__vgic_v3_get_ich_vtr_el2() is also preemptible, but all it does is read an id
register which looks safe to me...)


Thanks,

James

[0] https://www.spinics.net/lists/arm-kernel/msg603990.html
