From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 08/20] KVM: ARM64: Add access handler for event typer
 register
Date: Thu, 7 Jan 2016 19:11:26 +0800
Message-ID: <568E47DE.2060102@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-9-git-send-email-zhaoshenglong@huawei.com> <568E4607.6090308@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <568E4607.6090308@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/7 19:03, Marc Zyngier wrote:
> On 22/12/15 08:08, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > These kind of registers include PMEVTYPERn, PMCCFILTR and PMXEVTYPER
>> > which is mapped to PMEVTYPERn or PMCCFILTR.
>> > 
>> > The access handler translates all aarch32 register offsets to aarch64
>> > ones and uses vcpu_sys_reg() to access their values to avoid taking care
>> > of big endian.
>> > 
>> > When writing to these registers, create a perf_event for the selected
>> > event type.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 156 +++++++++++++++++++++++++++++++++++++++++++++-
>> >  1 file changed, 154 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index 2552db1..ed2939b 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -505,6 +505,70 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >  	return true;
>> >  }
>> >  
>> > +static inline bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
>> > +{
>> > +	u64 pmcr, val;
>> > +
>> > +	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
>> > +	val = (pmcr >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
>> > +	if (idx >= val && idx != ARMV8_CYCLE_IDX)
>> > +		return false;
>> > +
>> > +	return true;
>> > +}
>> > +
>> > +static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> > +			       const struct sys_reg_desc *r)
>> > +{
>> > +	u64 idx, reg;
>> > +
>> > +	if (r->CRn == 9) {
>> > +		/* PMXEVTYPER_EL0 */
>> > +		reg = 0;
> Is there any particular reason why you're not setting reg to PMSELR_EL0,
> since this is what you're using?
> 
>> > +	} else {
>> > +		if (!p->is_aarch32) {
>> > +			/* PMEVTYPERn_EL0 or PMCCFILTR_EL0 */
>> > +			reg = r->reg;
>> > +		} else {
>> > +			if (r->CRn == 14 && r->CRm == 15 && r->Op2 == 7) {
>> > +				reg = PMCCFILTR_EL0;
>> > +			} else {
>> > +				reg = ((r->CRm & 3) << 3) | (r->Op2 & 7);
>> > +				reg += PMEVTYPER0_EL0;
>> > +			}
>> > +		}
>> > +	}
>> > +
>> > +	switch (reg) {
>> > +	case PMEVTYPER0_EL0 ... PMEVTYPER30_EL0:
>> > +		idx = reg - PMEVTYPER0_EL0;
>> > +		if (!pmu_counter_idx_valid(vcpu, idx))
>> > +			return true;
>> > +		break;
>> > +	case PMCCFILTR_EL0:
>> > +		idx = ARMV8_CYCLE_IDX;
>> > +		break;
>> > +	default:
> This would allow this case to be more precise, and we could have the
> default case as a bug handler.
> 
Ah, you're right. Will fix this.

Thanks,
-- 
Shannon

