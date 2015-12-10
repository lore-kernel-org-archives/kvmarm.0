From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/21] KVM: ARM64: Add access handler for PMEVCNTRn
 and PMCCNTR register
Date: Thu, 10 Dec 2015 12:07:28 +0000
Message-ID: <56696B00.6090909@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com> <1449578860-15808-11-git-send-email-zhaoshenglong@huawei.com> <56670594.7010604@arm.com> <566963C3.40904@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <566963C3.40904@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shannon,

On 10/12/15 11:36, Shannon Zhao wrote:
> Hi Marc,
> 
> On 2015/12/9 0:30, Marc Zyngier wrote:
>> On 08/12/15 12:47, Shannon Zhao wrote:
>>>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>>>
>>>> Since the reset value of PMEVCNTRn or PMCCNTR is UNKNOWN, use
>>>> reset_unknown for its reset handler. Add access handler which emulates
>>>> writing and reading PMEVCNTRn or PMCCNTR register. When reading
>>>> PMEVCNTRn or PMCCNTR, call perf_event_read_value to get the count value
>>>> of the perf event.
>>>>
>>>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>>>> ---
>>>>  arch/arm64/kvm/sys_regs.c | 107 +++++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 105 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>> index c116a1b..f7a73b5 100644
>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>> @@ -525,6 +525,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>>>>  
>>>>  	if (p->is_write) {
>>>>  		switch (r->reg) {
>>>> +		case PMEVCNTR0_EL0 ... PMCCNTR_EL0: {
>> Same problem as previously mentioned.
>>
>>>> +			val = kvm_pmu_get_counter_value(vcpu,
>>>> +							r->reg - PMEVCNTR0_EL0);
>>>> +			vcpu_sys_reg(vcpu, r->reg) += (s64)p->regval - val;
>>>> +			break;
>>>> +		}
> 
> If I use a handler to handle these accesses to PMEVCNTRn and PMCCNTR
> like below. It converts the register offset c14_PMEVCNTRn and c9_PMCCNTR
> to PMEVCNTRn_EL0 and PMCCNTR_EL0, uniformly uses vcpu_sys_reg and
> doesn't need to take care the big endian. What do you think about this?
> 
> static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
>                               struct sys_reg_params *p,
>                               const struct sys_reg_desc *r)
> {
>         u64 idx, reg, val;
> 
>         if (p->is_aarch32)
>                 reg = r->reg / 2;

I'd prefer it if you actually decoded the reg itself. Something like:

	if (p->is_aarch32) {
		if (r->CRn == 9 && r->CRm == 13)
			reg = (r->Op2 & 1) ? 0 : PMCCNTR_EL0;
		if (r->CRn == 14 && (r->CRm & 0xc) == 8) {
			reg = ((r->CRm & 3) << 2) & (r->Op2 & 7);
			reg += PMEVCNTR0_EL0;
		} else {
			BUG();
		}
	} else {
		....
	}

And then you can get rid of the c14_PMVCNTR* and c9_PMCCNTR macros.
The only slightly ugly thing is this 0 value to represent PMXEVTYPER,
but that's what we already have with your "default" clause below.

>         else
>                 reg = r->reg;
> 
>         switch (reg) {
>         case PMEVCNTR0_EL0 ... PMEVCNTR30_EL0: {
>                 idx = reg - PMEVCNTR0_EL0;
>                 break;
>         }
>         case PMCCNTR_EL0: {
>                 idx = ARMV8_CYCLE_IDX;
>                 break;
>         }
>         default:
>                 idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
>                 if (!pmu_counter_idx_valid(vcpu, idx))
>                         return true;
>                 reg = (idx == ARMV8_CYCLE_IDX) ? PMCCNTR_EL0 :
> PMEVCNTR0_EL0 + idx;
>                 break;
>         }
> 
>         val = kvm_pmu_get_counter_value(vcpu, idx);
>         if (p->is_write)
>                 vcpu_sys_reg(vcpu, reg) = (s64)p->regval - val;

Maybe I don't have my head screwed in the right way, but as long as
we're only using u64 quantities, why do we need this s64 cast?

>         else
>                 p->regval = val;
> 
>         return true;
> }

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
