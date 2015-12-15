From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 15/19] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Tue, 15 Dec 2015 14:58:35 +0000
Message-ID: <56702A9B.6000802@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-16-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3DB4969A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 09:56:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1sb2OnZdi03c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 09:56:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 999AA411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 09:56:22 -0500 (EST)
In-Reply-To: <1450169379-12336-16-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> The reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown.
> 
> PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
> accessed from EL0. Add some check helpers to handle the access from EL0.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 124 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 119 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b2ccc25..bad3dfd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -452,12 +452,44 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, r->reg) = val;
>  }
>  
> +static inline bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & 0x1) || vcpu_mode_priv(vcpu));
> +}
> +
> +static inline bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & 0x3) || vcpu_mode_priv(vcpu));
> +}
> +
> +static inline bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & 0x5) || vcpu_mode_priv(vcpu));
> +}
> +
> +static inline bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +
> +	return !((reg & 0x9) || vcpu_mode_priv(vcpu));
> +}

Please add #defines for the PMUSERNR_EL0 bits.

> +
>  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
>  {
>  	u64 val;
> +	bool unaccessible = pmu_access_el0_disabled(vcpu);
>  
>  	if (p->is_write) {
> +		if (unaccessible)
> +			return ignore_write(vcpu, p);
> +

This is not how this is supposed to work. If EL0 is denied access to the
PMU, you must inject an exception into EL1 for it to handle the fault.
The code should reflect the flow described at D5.11.2 in the ARM ARM.

This whole patch needs to be revisited, I'm afraid.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
