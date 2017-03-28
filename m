From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 1/9] arm64: KVM: PMU: Refactor pmu_*_el0_disabled
Date: Tue, 28 Mar 2017 14:46:23 +0200
Message-ID: <20170328124623.GJ31156@cbox>
References: <20170327160345.12402-1-marc.zyngier@arm.com>
 <20170327160345.12402-2-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9364F40A14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:44:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uszqFnj+OlWZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 08:44:27 -0400 (EDT)
Received: from mail-wr0-f178.google.com (mail-wr0-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C340C40992
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 08:44:27 -0400 (EDT)
Received: by mail-wr0-f178.google.com with SMTP id w11so85534692wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 05:46:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170327160345.12402-2-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 27, 2017 at 05:03:37PM +0100, Marc Zyngier wrote:
> There is a lot of duplication in the pmu_*_el0_disabled helpers,
> and as we're going to modify them shortly, let's move all the
> common stuff in a single function.
> 
> No functionnal change.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0e26f8c2b56f..7e1d673304d5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -460,35 +460,32 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>  }
>  
> -static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
> +static bool check_disabled(struct kvm_vcpu *vcpu, u64 flags)
>  {
>  	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +	bool cond = (reg & flags) || vcpu_mode_priv(vcpu);

nit: I would call this variable 'enabled' and then return !enabled to
make it clear what's going on.

(If you agree, I can fix this up when applying along with the typo and
rename pointed out by Suzuki).

>  
> -	return !((reg & ARMV8_PMU_USERENR_EN) || vcpu_mode_priv(vcpu));
> +	return !cond;
>  }
>  
> -static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
> +static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
>  {
> -	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> +	return check_disabled(vcpu, ARMV8_PMU_USERENR_EN);
> +}
>  
> -	return !((reg & (ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN))
> -		 || vcpu_mode_priv(vcpu));
> +static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
> +{
> +	return check_disabled(vcpu, ARMV8_PMU_USERENR_SW | ARMV8_PMU_USERENR_EN);
>  }
>  
>  static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
>  {
> -	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> -
> -	return !((reg & (ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN))
> -		 || vcpu_mode_priv(vcpu));
> +	return check_disabled(vcpu, ARMV8_PMU_USERENR_CR | ARMV8_PMU_USERENR_EN);
>  }
>  
>  static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
>  {
> -	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> -
> -	return !((reg & (ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN))
> -		 || vcpu_mode_priv(vcpu));
> +	return check_disabled(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
>  }
>  
>  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -- 
> 2.11.0
> 

Otherwise:

Reviewed-by: Christoffer Dall <cdall@linaro.org>
