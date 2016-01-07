From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 08/20] KVM: ARM64: Add access handler for event typer
 register
Date: Thu, 7 Jan 2016 20:09:22 +0800
Message-ID: <568E5572.5020806@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
 <1450771695-11948-9-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C806A41267
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 07:07:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zRSQB5RywR25 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2016 07:07:46 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1C3497F8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2016 07:07:44 -0500 (EST)
In-Reply-To: <1450771695-11948-9-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/12/22 16:08, Shannon Zhao wrote:
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
>  arch/arm64/kvm/sys_regs.c | 156 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 154 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2552db1..ed2939b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -505,6 +505,70 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
> +				reg = ((r->CRm & 3) << 3) | (r->Op2 & 7);
> +				reg += PMEVTYPER0_EL0;
> +			}
> +		}
> +	}
> +
> +	switch (reg) {
> +	case PMEVTYPER0_EL0 ... PMEVTYPER30_EL0:
> +		idx = reg - PMEVTYPER0_EL0;
> +		if (!pmu_counter_idx_valid(vcpu, idx))
> +			return true;
Hi Marc,

Here should we return false to inject an UND since there is no
PMEVTYPER(idx)_EL0? The ARMv8 spec says it should.

Thanks,
-- 
Shannon
