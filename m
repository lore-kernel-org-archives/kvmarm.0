From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 04/22] KVM: ARM64: Add reset and access handlers for
 PMCR_EL0 register
Date: Mon, 14 Sep 2015 13:11:37 +0100
Message-ID: <55F6B979.3010006@arm.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com> <1441961715-11688-5-git-send-email-zhaoshenglong@huawei.com> <55F2A7F7.4010801@arm.com> <55F63B87.4020205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55F63B87.4020205@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 14/09/15 04:14, Shannon Zhao wrote:
> 
> 
> On 2015/9/11 18:07, Marc Zyngier wrote:
>> On 11/09/15 09:54, Shannon Zhao wrote:
>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>
>>>> Add reset handler which gets host value of PMCR_EL0 and make writable
>>>> bits architecturally UNKNOWN. Add a common access handler for PMU
>>>> registers which emulates writing and reading register and add emulation
>>>> for PMCR.
>>>>
>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>> ---
>>>>  arch/arm64/kvm/sys_regs.c | 76 +++++++++++++++++++++++++++++++++++++++++++++--
>>>>  1 file changed, 74 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index c370b40..db1be44 100644
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
>>>> @@ -236,6 +237,48 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>>>  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>>>>  }
>>>>  
>>>> +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>>> +{
>>>> +	u32 pmcr;
>>>> +
>>>> +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
>>>> +	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN*/
>>>> +	if (!vcpu_mode_is_32bit(vcpu))
>>>> +		vcpu_sys_reg(vcpu, r->reg) = (pmcr & ~ARMV8_PMCR_MASK)
>>>> +					     | (ARMV8_PMCR_MASK & 0xdecafbad);
>>>> +	else
>>>> +		vcpu_cp15(vcpu, r->reg) = (pmcr & ~ARMV8_PMCR_MASK)
>>>> +					  | (ARMV8_PMCR_MASK & 0xdecafbad);
>> I have some concerns about blindly reusing the top bits of the host's
>> PMCR_EL0 register, specially when it comes to the PMCR_EL0.N. Given that
>> we're fully emulating the PMU, shouldn't we simply define how many
>> counters we're emulating?
>>
> 
> But how many counters should we define? And what does this definition
> based on? The only gist I think is the number of counters on host. And
> what's the reason to define less or more than PMCR_EL0.N? I didn't find
> one. So I choose to be consistent with host.

The problem is that choosing the host value may be just the wrong thing
once you migrate it. It is not a big deal, but it is worth keeping it in
mind. it should anyway be possible to size the PMU from userspace,
overriding the value you've selected at reset.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
