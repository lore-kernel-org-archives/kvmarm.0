From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH 04/18] KVM: ARM64: Add reset and access handlers for
 PMCR_EL0 register
Date: Fri, 17 Jul 2015 16:45:44 +0800
Message-ID: <55A8C0B8.1000101@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-5-git-send-email-shannon.zhao@linaro.org>
 <20150716195534.GD14024@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7C7358BB6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 04:33:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YCo9IyZGuXXe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 04:33:57 -0400 (EDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
 [209.85.220.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C44DB58BB5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 04:33:56 -0400 (EDT)
Received: by padck2 with SMTP id ck2so57208460pad.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 01:45:52 -0700 (PDT)
In-Reply-To: <20150716195534.GD14024@cbox>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/7/17 3:55, Christoffer Dall wrote:
> On Mon, Jul 06, 2015 at 10:17:34AM +0800, shannon.zhao@linaro.org wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> Add reset handler which gets host value of PMCR_EL0 and make writable
>> bits architecturally UNKNOWN. Add access handler which emulates
>> writing and reading PMCR_EL0 register.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 41 ++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 40 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index c370b40..152ee17 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -33,6 +33,7 @@
>>  #include <asm/kvm_emulate.h>
>>  #include <asm/kvm_host.h>
>>  #include <asm/kvm_mmu.h>
>> +#include <asm/pmu.h>
>>  
>>  #include <trace/events/kvm.h>
>>  
>> @@ -236,6 +237,44 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>>  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>>  }
>>  
>> +static void reset_pmcr_el0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> +{
>> +	u32 pmcr;
>> +
>> +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
>> +	vcpu_sys_reg(vcpu, PMCR_EL0) = (pmcr & ~ARMV8_PMCR_MASK)
>> +				       | (ARMV8_PMCR_MASK & 0xdecafbad);
> 
> You could add a comment that this resets to UNKNOWN as to not make
> people confused about the pseudo-random hex value.
> 
Ok.

> Have we thought about whether we want to tell the guest that it has the
> same PMU as available on the real hardware, or does the virtualization
> layer suggest to us that we should adjust this somehow?
> 
I guess here the number of PMU counters is what we can adjust, right?
Are we worried about that the host will run out of counters when guest
and host register lots of events?
The PMU of cortex-a57 has 6 counters. IIUC, if one of the guest vcpu
process registers 6 events and some host process register 6 events too,
these events will be monitored in real hardware PMU counter when the
related process runs on the cpu. And when other processes are scheduled
to run, it will switch the contexts of PMU counters.

> 
>> +}
>> +
>> +/* PMCR_EL0 accessor. Only called as long as MDCR_EL2.TPMCR is set. */
>> +static bool access_pmcr(struct kvm_vcpu *vcpu,
>> +			const struct sys_reg_params *p,
>> +			const struct sys_reg_desc *r)
>> +{
>> +	unsigned long val;
>> +
>> +	if (p->is_write) {
>> +		/* Only update writeable bits of PMCR */
>> +		if (!p->is_aarch32)
>> +			val = vcpu_sys_reg(vcpu, r->reg);
>> +		else
>> +			val = vcpu_cp15(vcpu, r->reg);
> 
> don't you need to add this function as the handler in the cp15_regs
> array as well?
> 
Sorry, I'm not very clear about this. Will look at the codes and
understand the use of cp15_regs.

>> +		val &= ~ARMV8_PMCR_MASK;
>> +		val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
>> +		if (!p->is_aarch32)
>> +			vcpu_sys_reg(vcpu, r->reg) = val;
>> +		else
>> +			vcpu_cp15(vcpu, r->reg) = val;
>> +	} else {
>> +		if (!p->is_aarch32)
>> +			*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
>> +		else
>> +			*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>>  	/* DBGBVRn_EL1 */						\
>> @@ -427,7 +466,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>  
>>  	/* PMCR_EL0 */
>>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
>> -	  trap_raz_wi },
>> +	  access_pmcr, reset_pmcr_el0, PMCR_EL0, },
>>  	/* PMCNTENSET_EL0 */
>>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
>>  	  trap_raz_wi },
>> -- 
>> 2.1.0
>>
> Thanks,
> -Christoffer
> 

-- 
Shannon
