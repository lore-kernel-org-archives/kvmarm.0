From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] arm/arm64: KVM: Perform local TLB invalidation when
 multiplexing vcpus on a single CPU
Date: Tue, 01 Nov 2016 16:39:29 +0000
Message-ID: <86ins7kvcu.fsf@arm.com>
References: <1477650470-19104-1-git-send-email-marc.zyngier@arm.com>
 <20161101090408.GA13677@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6480B40288
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 12:39:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H42onznZFJVJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Nov 2016 12:39:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5B6B40286
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Nov 2016 12:39:26 -0400 (EDT)
In-Reply-To: <20161101090408.GA13677@cbox> (Christoffer Dall's message of
 "Tue, 1 Nov 2016 10:04:08 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

[messed up my initial reply, resending]

On Tue, Nov 01 2016 at 09:04:08 AM, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> On Fri, Oct 28, 2016 at 11:27:50AM +0100, Marc Zyngier wrote:
>> Architecturally, TLBs are private to the (physical) CPU they're
>> associated with. But when multiple vcpus from the same VM are
>> being multiplexed on the same CPU, the TLBs are not private
>> to the vcpus (and are actually shared across the VMID).
>> 
>> Let's consider the following scenario:
>> 
>> - vcpu-0 maps PA to VA
>> - vcpu-1 maps PA' to VA
>> 
>> If run on the same physical CPU, vcpu-1 can hit TLB entries generated
>> by vcpu-0 accesses, and access the wrong physical page.
>> 
>> The solution to this is to keep a per-VM map of which vcpu ran last
>> on each given physical CPU, and invalidate local TLBs when switching
>> to a different vcpu from the same VM.
>> 
>> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>> Fixed comments, added Mark's RB.
>> 
>>  arch/arm/include/asm/kvm_host.h   | 11 ++++++++++-
>>  arch/arm/include/asm/kvm_hyp.h    |  1 +
>>  arch/arm/kvm/arm.c                | 35 ++++++++++++++++++++++++++++++++++-
>>  arch/arm/kvm/hyp/switch.c         |  9 +++++++++
>>  arch/arm64/include/asm/kvm_host.h | 11 ++++++++++-
>>  arch/arm64/kvm/hyp/switch.c       |  8 ++++++++
>>  6 files changed, 72 insertions(+), 3 deletions(-)
>> 

[...]

>> @@ -310,6 +322,27 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>>  	return 0;
>>  }
>>  
>> +void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>> +{
>
> why is calling this from here sufficient?
>
> You only get a notification from preempt notifiers if you were preempted
> while running (or rather while the vcpu was loaded).  I think this
> needs

Arghh. I completely miss-read the code when writing that patch.

> to go in kvm_arch_vcpu_load, but be aware that the vcpu_load gets called
> for other vcpu ioctls and doesn't necessarily imply that the vcpu will
> actually run, which is also the case for the sched_in notification, btw.
> The worst that will happen in that case is a bit of extra TLB
> invalidation, so sticking with kvm_arch_vcpu_load is probably fine.

Indeed. I don't mind the extra invalidation, as long as it is rare
enough. Another possibility would be to do this test on the entry path,
once preemption is disabled.

>
>> +	int *last_ran;
>> +
>> +	last_ran = per_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran, cpu);
>> +
>> +	/*
>> +	 * We might get preempted before the vCPU actually runs, but
>> +	 * this is fine. Our TLBI stays pending until we actually make
>> +	 * it to __activate_vm, so we won't miss a TLBI. If another
>> +	 * vCPU gets scheduled, it will see our vcpu_id in last_ran,
>> +	 * and pend a TLBI for itself.
>> +	 */
>> +	if (*last_ran != vcpu->vcpu_id) {
>> +		if (*last_ran != -1)
>> +			vcpu->arch.tlb_vmid_stale = true;
>> +
>> +		*last_ran = vcpu->vcpu_id;
>> +	}
>> +}
>> +
>>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>  {
>>  	vcpu->cpu = cpu;
>> diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
>> index 92678b7..a411762 100644
>> --- a/arch/arm/kvm/hyp/switch.c
>> +++ b/arch/arm/kvm/hyp/switch.c
>> @@ -75,6 +75,15 @@ static void __hyp_text __activate_vm(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>>  	write_sysreg(kvm->arch.vttbr, VTTBR);
>> +	if (vcpu->arch.tlb_vmid_stale) {
>> +		/* Force vttbr to be written */
>> +		isb();
>> +		/* Local invalidate only for this VMID */
>> +		write_sysreg(0, TLBIALL);
>> +		dsb(nsh);
>> +		vcpu->arch.tlb_vmid_stale = false;
>> +	}
>> +
>
> why not call this directly when you notice it via kvm_call_hyp as
> opposed to adding another conditional in the critical path?

Because the cost of a hypercall is very likely to be a lot higher than
that of testing a variable. Not to mention that at this point we're
absolutely sure that we're going to run the guest, while the hook in
vcpu_load is only probabilistic.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
