From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 10/18] KVM: ARM64: Add reset and access handlers for
 PMCCNTR_EL0 register
Date: Fri, 17 Jul 2015 16:42:27 +0200
Message-ID: <20150717144227.GT14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-11-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7416A58C6A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 10:30:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDDln4-rkL1O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 10:30:14 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2765E58C62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 10:30:13 -0400 (EDT)
Received: by laem6 with SMTP id m6so62374126lae.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 07:42:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436149068-3784-11-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: shannon.zhao@linaro.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:40AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMCCNTR_EL0 is UNKNOWN, use reset_unknown for
> its reset handler. Add access handler which emulates writing and reading
> PMCCNTR_EL0 register.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2bcf1a0..29883df 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -375,6 +375,23 @@ static bool access_pmxevcntr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_pmccntr(struct kvm_vcpu *vcpu,
> +			   const struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	unsigned long val;
> +
> +	if (p->is_write) {
> +		val = *vcpu_reg(vcpu, p->Rt);
> +		kvm_pmu_set_counter_value(vcpu, 31, val);

magic number?  do we have some existing define we can use or can we add
one?

> +	} else {
> +		val = kvm_pmu_get_counter_value(vcpu, 31);
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +	}
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -590,7 +607,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmceid, reset_pmceid, PMCEID1_EL0, },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmccntr, reset_unknown, PMCCNTR_EL0 },
>  	/* PMXEVTYPER_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
>  	  access_pmxevtyper, reset_unknown, PMXEVTYPER_EL0 },
> -- 
> 2.1.0
> 
