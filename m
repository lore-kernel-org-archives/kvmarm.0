From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 10/21] KVM: ARM64: Add access handler for PMEVCNTRn
 and PMCCNTR register
Date: Tue, 08 Dec 2015 16:30:12 +0000
Message-ID: <56670594.7010604@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com> <1449578860-15808-11-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449578860-15808-11-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 12:47, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMEVCNTRn or PMCCNTR is UNKNOWN, use
> reset_unknown for its reset handler. Add access handler which emulates
> writing and reading PMEVCNTRn or PMCCNTR register. When reading
> PMEVCNTRn or PMCCNTR, call perf_event_read_value to get the count value
> of the perf event.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 107 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c116a1b..f7a73b5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -525,6 +525,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		switch (r->reg) {
> +		case PMEVCNTR0_EL0 ... PMCCNTR_EL0: {

Same problem as previously mentioned.

> +			val = kvm_pmu_get_counter_value(vcpu,
> +							r->reg - PMEVCNTR0_EL0);
> +			vcpu_sys_reg(vcpu, r->reg) += (s64)p->regval - val;
> +			break;
> +		}
>  		case PMEVTYPER0_EL0 ... PMCCFILTR_EL0: {
>  			val = r->reg - PMEVTYPER0_EL0;
>  			kvm_pmu_set_counter_event_type(vcpu, p->regval, val);
> @@ -548,6 +554,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  		}
>  	} else {
>  		switch (r->reg) {
> +		case PMEVCNTR0_EL0 ... PMCCNTR_EL0: {
> +			val = kvm_pmu_get_counter_value(vcpu,
> +							r->reg - PMEVCNTR0_EL0);
> +			p->regval = val;
> +			break;
> +		}
>  		case PMCR_EL0: {
>  			/* PMCR.P & PMCR.C are RAZ */
>  			val = vcpu_sys_reg(vcpu, r->reg)
> @@ -579,6 +591,13 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
>  	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
>  
> +/* Macro to expand the PMEVCNTRn_EL0 register */
> +#define PMU_PMEVCNTR_EL0(n)						\
> +	/* PMEVCNTRn_EL0 */						\
> +	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
> +	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
> +	  access_pmu_regs, reset_unknown, (PMEVCNTR0_EL0 + n), }
> +
>  /* Macro to expand the PMEVTYPERn_EL0 register */
>  #define PMU_PMEVTYPER_EL0(n)						\
>  	/* PMEVTYPERn_EL0 */						\
> @@ -779,7 +798,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMCCNTR_EL0 },
>  	/* PMXEVTYPER_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
>  	  access_pmu_pmxevtyper },
> @@ -800,6 +819,38 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
>  	  NULL, reset_unknown, TPIDRRO_EL0 },
>  
> +	/* PMEVCNTRn_EL0 */
> +	PMU_PMEVCNTR_EL0(0),
> +	PMU_PMEVCNTR_EL0(1),
> +	PMU_PMEVCNTR_EL0(2),
> +	PMU_PMEVCNTR_EL0(3),
> +	PMU_PMEVCNTR_EL0(4),
> +	PMU_PMEVCNTR_EL0(5),
> +	PMU_PMEVCNTR_EL0(6),
> +	PMU_PMEVCNTR_EL0(7),
> +	PMU_PMEVCNTR_EL0(8),
> +	PMU_PMEVCNTR_EL0(9),
> +	PMU_PMEVCNTR_EL0(10),
> +	PMU_PMEVCNTR_EL0(11),
> +	PMU_PMEVCNTR_EL0(12),
> +	PMU_PMEVCNTR_EL0(13),
> +	PMU_PMEVCNTR_EL0(14),
> +	PMU_PMEVCNTR_EL0(15),
> +	PMU_PMEVCNTR_EL0(16),
> +	PMU_PMEVCNTR_EL0(17),
> +	PMU_PMEVCNTR_EL0(18),
> +	PMU_PMEVCNTR_EL0(19),
> +	PMU_PMEVCNTR_EL0(20),
> +	PMU_PMEVCNTR_EL0(21),
> +	PMU_PMEVCNTR_EL0(22),
> +	PMU_PMEVCNTR_EL0(23),
> +	PMU_PMEVCNTR_EL0(24),
> +	PMU_PMEVCNTR_EL0(25),
> +	PMU_PMEVCNTR_EL0(26),
> +	PMU_PMEVCNTR_EL0(27),
> +	PMU_PMEVCNTR_EL0(28),
> +	PMU_PMEVCNTR_EL0(29),
> +	PMU_PMEVCNTR_EL0(30),
>  	/* PMEVTYPERn_EL0 */
>  	PMU_PMEVTYPER_EL0(0),
>  	PMU_PMEVTYPER_EL0(1),
> @@ -1034,6 +1085,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		switch (r->reg) {
> +		case c14_PMEVCNTR0 ... c9_PMCCNTR: {
> +			val = kvm_pmu_get_counter_value(vcpu,
> +							r->reg - c14_PMEVCNTR0);
> +			vcpu_cp15(vcpu, r->reg) += (s64)p->regval - val;

OK, we do have an interesting problem here. On 32bit, the cycle counter
can be accessed both as a 32bit or a 64bit register (ARMv8 ARM G6.4.2).
Here, you're happily truncating it, without paying attention to the size
of the access.

Please have a look at the way we handle c2_TTBR0, that will give you an
idea of how to deal with it.

> +			break;
> +		}
>  		case c14_PMEVTYPER0 ... c14_PMCCFILTR: {
>  			val = r->reg - c14_PMEVTYPER0;
>  			kvm_pmu_set_counter_event_type(vcpu, p->regval, val);
> @@ -1057,6 +1114,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  		}
>  	} else {
>  		switch (r->reg) {
> +		case c14_PMEVCNTR0 ... c9_PMCCNTR: {
> +			val = kvm_pmu_get_counter_value(vcpu,
> +							r->reg - c14_PMEVCNTR0);
> +			p->regval = val;
> +			break;
> +		}

Same here.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
