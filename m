From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 06/21] KVM: ARM64: Add access handler for PMCEID0 and
 PMCEID1 register
Date: Thu, 28 Jan 2016 21:34:06 +0100
Message-ID: <20160128203406.GI16453@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-7-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453866709-20324-7-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 27, 2016 at 11:51:34AM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add access handler which gets host value of PMCEID0 or PMCEID1 when
> guest access these registers. Writing action to PMCEID0 or PMCEID1 is
> UNDEFINED.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fc60041..06257e2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -492,6 +492,27 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	u64 pmceid;
> +
> +	if (!kvm_arm_pmu_v3_ready(vcpu))
> +		return trap_raz_wi(vcpu, p, r);
> +
> +	if (p->is_write)
> +		return false;
> +
> +	if (!(p->Op2 & 1))
> +		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
> +	else
> +		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));

For migratibility concerns we may want to filter some of these events.
With that in mind the answer to my question in 4/21 is 'no'. Instead we
should pick an IMP,IDCODE,N,PMCEID0_EL0,PMCEID1_EL0 that we expect to
represent the least common denominator of all the platforms available
now, and then only expose that view to the guest. If we want to support
more events, and userspace requests it for the guest, then we can relax
the filtering (at the expense of migratibility), when the host has the
support.

I don't know what a reasonable first filter is. Maybe D5.10.6 "Required
events" is enough for the base?

> +
> +	p->regval = pmceid;
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -694,10 +715,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmselr, reset_unknown, PMSELR_EL0 },
>  	/* PMCEID0_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
> -	  trap_raz_wi },
> +	  access_pmceid },
>  	/* PMCEID1_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
> -	  trap_raz_wi },
> +	  access_pmceid },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
>  	  trap_raz_wi },
> @@ -943,8 +964,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
