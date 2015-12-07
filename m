From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 08/21] KVM: ARM64: Add reset and access handlers for
 PMXEVTYPER register
Date: Mon, 07 Dec 2015 13:38:02 +0000
Message-ID: <56658BBA.4040600@arm.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com> <1449123091-20252-9-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449123091-20252-9-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 03/12/15 06:11, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMXEVTYPER is UNKNOWN, use reset_unknown or
> reset_unknown_cp15 for its reset handler. Add access handler which
> emulates writing and reading PMXEVTYPER register. When writing to
> PMXEVTYPER, call kvm_pmu_set_counter_event_type to create a perf_event
> for the selected event type.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b0a8d88..6967a49 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -473,6 +473,17 @@ static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, r->reg) = pmceid;
>  }
>  
> +static bool pmu_counter_idx_valid(u64 pmcr, u64 idx)
> +{
> +	u64 val;
> +
> +	val = (pmcr >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
> +	if (idx >= val && idx != ARMV8_COUNTER_MASK)
> +		return false;
> +
> +	return true;
> +}
> +
>  /* PMU registers accessor. */
>  static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_params *p,
> @@ -482,6 +493,20 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		switch (r->reg) {
> +		case PMXEVTYPER_EL0: {
> +			u64 idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
> +				  & ARMV8_COUNTER_MASK;
> +
> +			if (!pmu_counter_idx_valid(vcpu_sys_reg(vcpu, PMCR_EL0),
> +						   idx))
> +				break;
> +
> +			val = *vcpu_reg(vcpu, p->Rt);
> +			kvm_pmu_set_counter_event_type(vcpu, val, idx);
> +			vcpu_sys_reg(vcpu, PMXEVTYPER_EL0) = val;
> +			vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx) = val;

I'm really confused by this. PMXEVTYPER is not really a register, but
level of indirection between PMEVTYPERn_EL0 and PMCCFILTER_EL0
(depending on PMSELR_EL0.SEL). On its own, it doesn't exist.

Here, you are making PMXEVTYPER_EL0 an actual register, storing the same
value twice (and not handling PMCCFILTER_EL0). It definitely feels
wrong. You should be able to trap it and propagate the access to the
right register, without duplicating the state.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
