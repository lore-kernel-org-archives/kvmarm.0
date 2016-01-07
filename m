From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 08/20] KVM: ARM64: Add access handler for event typer
 register
Date: Thu, 07 Jan 2016 13:01:38 +0000
Message-ID: <568E61B2.1030104@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-9-git-send-email-zhaoshenglong@huawei.com> <568E5572.5020806@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <568E5572.5020806@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 07/01/16 12:09, Shannon Zhao wrote:
> 
> 
> On 2015/12/22 16:08, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> These kind of registers include PMEVTYPERn, PMCCFILTR and PMXEVTYPER
>> which is mapped to PMEVTYPERn or PMCCFILTR.
>>
>> The access handler translates all aarch32 register offsets to aarch64
>> ones and uses vcpu_sys_reg() to access their values to avoid taking care
>> of big endian.
>>
>> When writing to these registers, create a perf_event for the selected
>> event type.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 156 +++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 154 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 2552db1..ed2939b 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -505,6 +505,70 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>>  	return true;
>>  }
>>  
>> +static inline bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
>> +{
>> +	u64 pmcr, val;
>> +
>> +	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
>> +	val = (pmcr >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
>> +	if (idx >= val && idx != ARMV8_CYCLE_IDX)
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> +			       const struct sys_reg_desc *r)
>> +{
>> +	u64 idx, reg;
>> +
>> +	if (r->CRn == 9) {
>> +		/* PMXEVTYPER_EL0 */
>> +		reg = 0;
>> +	} else {
>> +		if (!p->is_aarch32) {
>> +			/* PMEVTYPERn_EL0 or PMCCFILTR_EL0 */
>> +			reg = r->reg;
>> +		} else {
>> +			if (r->CRn == 14 && r->CRm == 15 && r->Op2 == 7) {
>> +				reg = PMCCFILTR_EL0;
>> +			} else {
>> +				reg = ((r->CRm & 3) << 3) | (r->Op2 & 7);
>> +				reg += PMEVTYPER0_EL0;
>> +			}
>> +		}
>> +	}
>> +
>> +	switch (reg) {
>> +	case PMEVTYPER0_EL0 ... PMEVTYPER30_EL0:
>> +		idx = reg - PMEVTYPER0_EL0;
>> +		if (!pmu_counter_idx_valid(vcpu, idx))
>> +			return true;
> Hi Marc,
> 
> Here should we return false to inject an UND since there is no
> PMEVTYPER(idx)_EL0? The ARMv8 spec says it should.

The spec says that the following behaviours are valid:
- Accesses to the register are UNDEFINED .
- Accesses to the register behave as RAZ/WI.
- Accesses to the register execute as a NOP .

Same for the counters. So you can either return true (act as a NOP), or
return false (UNDEF), and even zero r->regval on read and return true
(RAZ/WI).

This is entirely up to you. My personal preference is indeed to UNDEF,
but your current implementation is valid.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
