From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH 04/18] KVM: ARM64: Add reset and access handlers for PMCR_EL0
 register
Date: Tue, 21 Jul 2015 09:16:57 +0800
Message-ID: <55AD9D89.7010502@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org> <1436149068-3784-5-git-send-email-shannon.zhao@linaro.org> <20150716195534.GD14024@cbox> <55A8C0B8.1000101@linaro.org> <20150717102133.GN14024@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150717102133.GN14024@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/7/17 18:21, Christoffer Dall wrote:
> On Fri, Jul 17, 2015 at 04:45:44PM +0800, Shannon Zhao wrote:
>>
>>
>> On 2015/7/17 3:55, Christoffer Dall wrote:
>>> On Mon, Jul 06, 2015 at 10:17:34AM +0800, shannon.zhao@linaro.org wrote:
>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>
>>>> Add reset handler which gets host value of PMCR_EL0 and make writable
>>>> bits architecturally UNKNOWN. Add access handler which emulates
>>>> writing and reading PMCR_EL0 register.
>>>>
>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>> ---
>>>>  arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 40 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index c370b40..152ee17 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -33,6 +33,7 @@
>>>>  #include <asm/kvm_emulate.h>
>>>>  #include <asm/kvm_host.h>
>>>>  #include <asm/kvm_mmu.h>
>>>> +#include <asm/pmu.h>
>>>>  
>>>>  #include <trace/events/kvm.h>
>>>>  
>>>> @@ -236,6 +237,44 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>>>  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>>>>  }
>>>>  
>>>> +static void reset_pmcr_el0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>>> +{
>>>> +	u32 pmcr;
>>>> +
>>>> +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
>>>> +	vcpu_sys_reg(vcpu, PMCR_EL0) = (pmcr & ~ARMV8_PMCR_MASK)
>>>> +				       | (ARMV8_PMCR_MASK & 0xdecafbad);
>>>
>>> You could add a comment that this resets to UNKNOWN as to not make
>>> people confused about the pseudo-random hex value.
>>>
>> Ok.
>>
>>> Have we thought about whether we want to tell the guest that it has the
>>> same PMU as available on the real hardware, or does the virtualization
>>> layer suggest to us that we should adjust this somehow?
>>>
>> I guess here the number of PMU counters is what we can adjust, right?
>> Are we worried about that the host will run out of counters when guest
>> and host register lots of events?
> 
> that's what I wonder; if perf itself reserves a counter for example,
> then we'll at best be able to measure with N-1 counters for the guest (N
> being the number of counters on the physical CPU), so why tell the guest
> we have N counters?
> 

I'm not sure whether perf itself reserves one counter. Here I just pass
the hardware information to guest.

> Of course, we can never even be guaranteed to have N-1 counters
> avaialable either, so maybe the sane choice is just to tell the guest
> what kind of hardware we have, and then fiddle the best we can with the
> remaining counters?  After all, correct functionality of the guest
> doesn't depend on this, it's a best-effort kind of thing...
> 
> Thoughts?
> 
>> The PMU of cortex-a57 has 6 counters. IIUC, if one of the guest vcpu
>> process registers 6 events and some host process register 6 events too,
>> these events will be monitored in real hardware PMU counter when the
>> related process runs on the cpu. And when other processes are scheduled
>> to run, it will switch the contexts of PMU counters.
> 
> That depends on the way the counters are used by perf I think.  What if
> you have system wide events?  What if the KVM (vcpu) process itself is
> being monitored for some events?
> 

Not sure what will happen when the number of monitored events is greater
than counters. I guess the perf layer may balance the events?

>>
>>>
>>>> +}
>>>> +
>>>> +/* PMCR_EL0 accessor. Only called as long as MDCR_EL2.TPMCR is set. */
>>>> +static bool access_pmcr(struct kvm_vcpu *vcpu,
>>>> +			const struct sys_reg_params *p,
>>>> +			const struct sys_reg_desc *r)
>>>> +{
>>>> +	unsigned long val;
>>>> +
>>>> +	if (p->is_write) {
>>>> +		/* Only update writeable bits of PMCR */
>>>> +		if (!p->is_aarch32)
>>>> +			val = vcpu_sys_reg(vcpu, r->reg);
>>>> +		else
>>>> +			val = vcpu_cp15(vcpu, r->reg);
>>>
>>> don't you need to add this function as the handler in the cp15_regs
>>> array as well?
>>>
>> Sorry, I'm not very clear about this. Will look at the codes and
>> understand the use of cp15_regs.
>>
> 
> I think the point is that you cannot use the same value of r->reg to
> index into both arrays, so the cp15 index must be passed from the
> cp15_regs array first.
> 
> Thanks,
> -Christoffer
> 

-- 
Shannon
