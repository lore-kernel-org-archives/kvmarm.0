From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 08/21] KVM: ARM64: Add reset and access handlers for
 PMXEVTYPER register
Date: Mon, 30 Nov 2015 18:12:47 +0000
Message-ID: <20151130181247.55649fc7@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
	<1446186123-11548-9-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446186123-11548-9-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 30 Oct 2015 14:21:50 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

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
>  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index cb82b15..4e606ea 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -491,6 +491,17 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		switch (r->reg) {
> +		case PMXEVTYPER_EL0: {
> +			val = vcpu_sys_reg(vcpu, PMSELR_EL0);
> +			kvm_pmu_set_counter_event_type(vcpu,
> +						       *vcpu_reg(vcpu, p->Rt),
> +						       val);

You are blindingly truncating 64bit values to u32. Is that intentional?

> +			vcpu_sys_reg(vcpu, PMXEVTYPER_EL0) =
> +							 *vcpu_reg(vcpu, p->Rt);
> +			vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + val) =
> +							 *vcpu_reg(vcpu, p->Rt);

Please do not break assignments like this, it makes the code
unreadable. I don't care what the 80-character police says... ;-)

> +			break;
> +		}
>  		case PMCR_EL0: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_sys_reg(vcpu, r->reg);
> @@ -735,7 +746,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  trap_raz_wi },
>  	/* PMXEVTYPER_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
>  	/* PMXEVCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b010),
>  	  trap_raz_wi },
> @@ -951,6 +962,16 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		switch (r->reg) {
> +		case c9_PMXEVTYPER: {
> +			val = vcpu_cp15(vcpu, c9_PMSELR);
> +			kvm_pmu_set_counter_event_type(vcpu,
> +						       *vcpu_reg(vcpu, p->Rt),
> +						       val);
> +			vcpu_cp15(vcpu, c9_PMXEVTYPER) = *vcpu_reg(vcpu, p->Rt);
> +			vcpu_cp15(vcpu, c14_PMEVTYPER0 + val) =
> +							 *vcpu_reg(vcpu, p->Rt);
> +			break;
> +		}
>  		case c9_PMCR: {
>  			/* Only update writeable bits of PMCR */
>  			val = vcpu_cp15(vcpu, r->reg);
> @@ -1024,7 +1045,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
>  	  reset_pmceid, c9_PMCEID1 },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
> +	  reset_unknown_cp15, c9_PMXEVTYPER },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
