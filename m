From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v6 10/21] KVM: ARM64: Add access handler for PMEVCNTRn
 and PMCCNTR register
Date: Thu, 10 Dec 2015 19:36:35 +0800
Message-ID: <566963C3.40904@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-11-git-send-email-zhaoshenglong@huawei.com>
 <56670594.7010604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CAFC40FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2015 06:37:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jwJ91vjD35ww for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2015 06:37:24 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6E27407A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2015 06:37:23 -0500 (EST)
In-Reply-To: <56670594.7010604@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 2015/12/9 0:30, Marc Zyngier wrote:
> On 08/12/15 12:47, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > Since the reset value of PMEVCNTRn or PMCCNTR is UNKNOWN, use
>> > reset_unknown for its reset handler. Add access handler which emulates
>> > writing and reading PMEVCNTRn or PMCCNTR register. When reading
>> > PMEVCNTRn or PMCCNTR, call perf_event_read_value to get the count value
>> > of the perf event.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 107 +++++++++++++++++++++++++++++++++++++++++++++-
>> >  1 file changed, 105 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index c116a1b..f7a73b5 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -525,6 +525,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>> >  
>> >  	if (p->is_write) {
>> >  		switch (r->reg) {
>> > +		case PMEVCNTR0_EL0 ... PMCCNTR_EL0: {
> Same problem as previously mentioned.
> 
>> > +			val = kvm_pmu_get_counter_value(vcpu,
>> > +							r->reg - PMEVCNTR0_EL0);
>> > +			vcpu_sys_reg(vcpu, r->reg) += (s64)p->regval - val;
>> > +			break;
>> > +		}

If I use a handler to handle these accesses to PMEVCNTRn and PMCCNTR
like below. It converts the register offset c14_PMEVCNTRn and c9_PMCCNTR
to PMEVCNTRn_EL0 and PMCCNTR_EL0, uniformly uses vcpu_sys_reg and
doesn't need to take care the big endian. What do you think about this?

static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
                              struct sys_reg_params *p,
                              const struct sys_reg_desc *r)
{
        u64 idx, reg, val;

        if (p->is_aarch32)
                reg = r->reg / 2;
        else
                reg = r->reg;

        switch (reg) {
        case PMEVCNTR0_EL0 ... PMEVCNTR30_EL0: {
                idx = reg - PMEVCNTR0_EL0;
                break;
        }
        case PMCCNTR_EL0: {
                idx = ARMV8_CYCLE_IDX;
                break;
        }
        default:
                idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
                if (!pmu_counter_idx_valid(vcpu, idx))
                        return true;
                reg = (idx == ARMV8_CYCLE_IDX) ? PMCCNTR_EL0 :
PMEVCNTR0_EL0 + idx;
                break;
        }

        val = kvm_pmu_get_counter_value(vcpu, idx);
        if (p->is_write)
                vcpu_sys_reg(vcpu, reg) = (s64)p->regval - val;
        else
                p->regval = val;

        return true;
}

Thanks,
-- 
Shannon
