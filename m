From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] arm/arm64: KVM: Perform local TLB invalidation when
 multiplexing vcpus on a single CPU
Date: Tue, 25 Oct 2016 11:20:13 +0100
Message-ID: <6849e197-f029-0ab9-7e76-d01c21d8432e@arm.com>
References: <1477323088-18768-1-git-send-email-marc.zyngier@arm.com>
 <20161024161656.GM15620@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161024161656.GM15620@leverpostej>
Sender: kvm-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On 24/10/16 17:16, Mark Rutland wrote:
> Hi Marc,
> 
> On Mon, Oct 24, 2016 at 04:31:28PM +0100, Marc Zyngier wrote:
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
> 
> It might be worth noting that this could also lead to TLB conflicts and
> other such fun usually associated with missing TLB maintenance,
> depending on the two mappings (or the intermediate stages thereof).
> 
>> The solution to this is to keep a per-VM map of which vcpu ran last
>> on each given physical CPU, and invalidate local TLBs when switching
>> to a different vcpu from the same VM.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> Modulo my comment on preemptiblity of kvm_arch_sched_in, everything
> below is a nit. Assuming that's not preemptible, this looks right to me.
> 
> FWIW, with or without the other comments considered:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> 
>> ---
>>  arch/arm/include/asm/kvm_host.h   |  5 +++++
>>  arch/arm/include/asm/kvm_hyp.h    |  1 +
>>  arch/arm/kvm/arm.c                | 35 ++++++++++++++++++++++++++++++++++-
>>  arch/arm/kvm/hyp/switch.c         |  9 +++++++++
>>  arch/arm64/include/asm/kvm_host.h |  6 +++++-
>>  arch/arm64/kvm/hyp/switch.c       |  8 ++++++++
>>  6 files changed, 62 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 2d19e02..035e744 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -57,6 +57,8 @@ struct kvm_arch {
>>  	/* VTTBR value associated with below pgd and vmid */
>>  	u64    vttbr;
>>  
>> +	int __percpu *last_vcpu_ran;
>> +
>>  	/* Timer */
>>  	struct arch_timer_kvm	timer;
>>  
>> @@ -174,6 +176,9 @@ struct kvm_vcpu_arch {
>>  	/* vcpu power-off state */
>>  	bool power_off;
>>  
>> +	/* TLBI required */
>> +	bool requires_tlbi;
> 
> A bit of a nit, but it's not clear which class of TLBI is required, or
> why. It's probably worth a comment (and perhaps a bikeshed), like:
> 
> 	/*
> 	 * Local TLBs potentially contain conflicting entries from
> 	 * another vCPU within this VMID. All entries for this VMID must
> 	 * be invalidated from (local) TLBs before we run this vCPU.
> 	 */
> 	bool tlb_vmid_stale;

Yup, looks good.

> 
> [...]
> 
>> +void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +	int *last_ran;
>> +
>> +	last_ran = per_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran, cpu);
>> +
>> +	/*
>> +	 * If we're very unlucky and get preempted before having ran
>> +	 * this vcpu for real, we'll end-up in a situation where any
>> +	 * vcpu that gets scheduled will perform an invalidation (this
>> +	 * vcpu explicitely requires it, and all the others will have
>> +	 * a different vcpu_id).
>> +	 */
> 
> Nit: s/explicitely/explicitly/
> 
> To bikeshed a little further, perhaps:
> 
> 	/*
> 	 * We might get preempted before the vCPU actually runs, but
> 	 * this is fine. Our TLBI stays pending until we actually make
> 	 * it to __activate_vm, so we won't miss a TLBI. If another vCPU
> 	 * gets scheduled, it will see our vcpu_id in last_ran, and pend
> 	 * a TLBI for itself.
> 	 */

Looks good too. I'll incorporate this into v2.

> 
>> +	if (*last_ran != vcpu->vcpu_id) {
>> +		if (*last_ran != -1)
>> +			vcpu->arch.requires_tlbi = true;
>> +
>> +		*last_ran = vcpu->vcpu_id;
>> +	}
>> +}
> 
> I take it this function is run in some non-preemptible context; if so,
> this looks correct to me.
> 
> If this is preemptible, then this looks racy.

This function is called from a preempt notifier, which itself isn't
preemptible.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
