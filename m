From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 08/19] KVM: ARM64: Add access handler for event typer
 register
Date: Tue, 15 Dec 2015 13:43:10 +0000
Message-ID: <567018EE.6000605@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com> <1450169379-12336-9-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-9-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> These kind of registers include PMEVTYPERn, PMCCFILTR and PMXEVTYPER
> which is mapped to PMEVTYPERn or PMCCFILTR.
> 
> The access handler translates all aarch32 register offsets to aarch64
> ones and uses vcpu_sys_reg() to access their values to avoid taking care
> of big endian.
> 
> When writing to these registers, create a perf_event for the selected
> event type.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 154 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 152 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e043224..c52ff15 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -504,6 +504,68 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static inline bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
> +{
> +	u64 pmcr, val;
> +
> +	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
> +	val = (pmcr >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
> +	if (idx >= val && idx != ARMV8_CYCLE_IDX)
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			       const struct sys_reg_desc *r)
> +{
> +	u64 idx, reg;
> +
> +	if (r->CRn == 9) {
> +		/* PMXEVTYPER_EL0 */
> +		reg = 0;
> +	} else {
> +		if (!p->is_aarch32) {
> +			/* PMEVTYPERn_EL0 or PMCCFILTR_EL0 */
> +			reg = r->reg;
> +		} else {
> +			if (r->CRn == 14 && r->CRm == 15 && r->Op2 == 7) {
> +				reg = PMCCFILTR_EL0;
> +			} else {
> +				reg = ((r->CRm & 3) << 3) & (r->Op2 & 7);

Shouldn't that be "((r->CRm & 3) << 3) | (r->Op2 & 7)"? Otherwise reg is
always 0.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
