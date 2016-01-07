From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 09/20] KVM: ARM64: Add access handler for event counter
 register
Date: Thu, 07 Jan 2016 11:06:40 +0000
Message-ID: <568E46C0.5060507@arm.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-10-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-10-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 22/12/15 08:08, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> These kind of registers include PMEVCNTRn, PMCCNTR and PMXEVCNTR which
> is mapped to PMEVCNTRn.
> 
> The access handler translates all aarch32 register offsets to aarch64
> ones and uses vcpu_sys_reg() to access their values to avoid taking care
> of big endian.
> 
> When reading these registers, return the sum of register value and the
> value perf event counts.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 138 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 134 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ed2939b..1818947 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -569,6 +569,57 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
> +			      struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	u64 idx, reg, val;
> +
> +	if (!p->is_aarch32) {
> +		if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 2)
> +			/* PMXEVCNTR_EL0 */
> +			reg = 0;
> +		else
> +			/* PMEVCNTRn_EL0 or PMCCNTR_EL0 */
> +			reg = r->reg;
> +	} else {
> +		if (r->CRn == 9 && r->CRm == 13) {
> +			reg = (r->Op2 & 2) ? 0 : PMCCNTR_EL0;
> +		} else {
> +			reg = ((r->CRm & 3) << 3) | (r->Op2 & 7);
> +			reg += PMEVCNTR0_EL0;
> +		}
> +	}

Same remark about the use of 0 instead of PMSELR_EL0.

> +
> +	switch (reg) {
> +	case PMEVCNTR0_EL0 ... PMEVCNTR30_EL0:
> +		idx = reg - PMEVCNTR0_EL0;
> +		if (!pmu_counter_idx_valid(vcpu, idx))
> +			return true;
> +		break;
> +	case PMCCNTR_EL0:
> +		idx = ARMV8_CYCLE_IDX;
> +		break;
> +	default:
> +		/* PMXEVCNTR_EL0 */
> +		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
> +		if (!pmu_counter_idx_valid(vcpu, idx))
> +			return true;
> +
> +		reg = (idx == ARMV8_CYCLE_IDX) ? PMCCNTR_EL0
> +						 : PMEVCNTR0_EL0 + idx;
> +		break;
> +	}
> +
> +	val = kvm_pmu_get_counter_value(vcpu, idx);
> +	if (p->is_write)
> +		vcpu_sys_reg(vcpu, reg) += (s64)p->regval - val;
> +	else
> +		p->regval = val;
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -584,6 +635,13 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
>  	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
>  
> +/* Macro to expand the PMEVCNTRn_EL0 register */
> +#define PMU_PMEVCNTR_EL0(n)						\
> +	/* PMEVCNTRn_EL0 */						\
> +	{ Op0(0b11), Op1(0b011), CRn(0b1110),				\
> +	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
> +	  access_pmu_evcntr, reset_unknown, (PMEVCNTR0_EL0 + n), }
> +
>  /* Macro to expand the PMEVTYPERn_EL0 register */
>  #define PMU_PMEVTYPER_EL0(n)						\
>  	/* PMEVTYPERn_EL0 */						\
> @@ -784,13 +842,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmceid },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmu_evcntr, reset_unknown, PMCCNTR_EL0 },
>  	/* PMXEVTYPER_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
>  	  access_pmu_evtyper },
>  	/* PMXEVCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
> -	  trap_raz_wi },
> +	  access_pmu_evcntr },
>  	/* PMUSERENR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
>  	  trap_raz_wi },
> @@ -805,6 +863,38 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
> @@ -1033,6 +1123,13 @@ static const struct sys_reg_desc cp14_64_regs[] = {
>  	{ Op1( 0), CRm( 2), .access = trap_raz_wi },
>  };
>  
> +/* Macro to expand the PMEVCNTRn register */
> +#define PMU_PMEVCNTR(n)							\
> +	/* PMEVCNTRn */							\
> +	{ Op1(0), CRn(0b1110),						\
> +	  CRm((0b1000 | (((n) >> 3) & 0x3))), Op2(((n) & 0x7)),		\
> +	  access_pmu_evcntr }
> +
>  /* Macro to expand the PMEVTYPERn register */
>  #define PMU_PMEVTYPER(n)						\
>  	/* PMEVTYPERn */						\
> @@ -1075,9 +1172,9 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
> -	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
> -	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
> @@ -1092,6 +1189,38 @@ static const struct sys_reg_desc cp15_regs[] = {
>  
>  	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
>  
> +	/* PMEVCNTRn */
> +	PMU_PMEVCNTR(0),
> +	PMU_PMEVCNTR(1),
> +	PMU_PMEVCNTR(2),
> +	PMU_PMEVCNTR(3),
> +	PMU_PMEVCNTR(4),
> +	PMU_PMEVCNTR(5),
> +	PMU_PMEVCNTR(6),
> +	PMU_PMEVCNTR(7),
> +	PMU_PMEVCNTR(8),
> +	PMU_PMEVCNTR(9),
> +	PMU_PMEVCNTR(10),
> +	PMU_PMEVCNTR(11),
> +	PMU_PMEVCNTR(12),
> +	PMU_PMEVCNTR(13),
> +	PMU_PMEVCNTR(14),
> +	PMU_PMEVCNTR(15),
> +	PMU_PMEVCNTR(16),
> +	PMU_PMEVCNTR(17),
> +	PMU_PMEVCNTR(18),
> +	PMU_PMEVCNTR(19),
> +	PMU_PMEVCNTR(20),
> +	PMU_PMEVCNTR(21),
> +	PMU_PMEVCNTR(22),
> +	PMU_PMEVCNTR(23),
> +	PMU_PMEVCNTR(24),
> +	PMU_PMEVCNTR(25),
> +	PMU_PMEVCNTR(26),
> +	PMU_PMEVCNTR(27),
> +	PMU_PMEVCNTR(28),
> +	PMU_PMEVCNTR(29),
> +	PMU_PMEVCNTR(30),
>  	/* PMEVTYPERn */
>  	PMU_PMEVTYPER(0),
>  	PMU_PMEVTYPER(1),
> @@ -1130,6 +1259,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>  
>  static const struct sys_reg_desc cp15_64_regs[] = {
>  	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
> +	{ Op1( 0), CRn( 0), CRm( 9), Op2( 0), access_pmu_evcntr },
>  	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi },
>  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR1 },
>  };
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
