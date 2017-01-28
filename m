From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 4/7] ARM64: KVM: emulate accessing ID registers
Date: Sat, 28 Jan 2017 14:49:10 +0100
Message-ID: <20170128134910.puefhy54b3tmdco3@hawk.localdomain>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-5-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F508401A1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Jan 2017 08:49:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dXUOfBfKlkuc for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Jan 2017 08:49:02 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05B3B4019A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Jan 2017 08:49:01 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1484559214-2248-5-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: marc.zyngier@arm.com, qemu-arm@nongnu.org, wu.wubin@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 16, 2017 at 05:33:31PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 83 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 50 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7c5fa03..f613e29 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1480,71 +1480,84 @@ FUNCTION_INVARIANT(id_aa64mmfr1_el1)
>  FUNCTION_INVARIANT(clidr_el1)
>  FUNCTION_INVARIANT(aidr_el1)
>  
> +static bool access_id_reg(struct kvm_vcpu *vcpu,
> +			  struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	if (p->is_write) {
> +		vcpu_id_sys_reg(vcpu, r->reg) = p->regval;

Hmm, most/all id registers are write-ignore, right? If there
are some that are not, then they should get their own handler.

> +	} else {
> +		p->regval = vcpu_id_sys_reg(vcpu, r->reg);
> +	}
> +
> +	return true;
> +}
> +
>  static struct sys_reg_desc invariant_sys_regs[] = {
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
> -	  NULL, get_midr_el1, MIDR_EL1 },
> +	  access_id_reg, get_midr_el1, MIDR_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
> -	  NULL, get_revidr_el1, REVIDR_EL1 },
> +	  access_id_reg, get_revidr_el1, REVIDR_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
> -	  NULL, get_id_pfr0_el1, ID_PFR0_EL1 },
> +	  access_id_reg, get_id_pfr0_el1, ID_PFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
> -	  NULL, get_id_pfr1_el1, ID_PFR1_EL1 },
> +	  access_id_reg, get_id_pfr1_el1, ID_PFR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
> -	  NULL, get_id_dfr0_el1, ID_DFR0_EL1 },
> +	  access_id_reg, get_id_dfr0_el1, ID_DFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b011),
> -	  NULL, get_id_afr0_el1, ID_AFR0_EL1 },
> +	  access_id_reg, get_id_afr0_el1, ID_AFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b100),
> -	  NULL, get_id_mmfr0_el1, ID_MMFR0_EL1 },
> +	  access_id_reg, get_id_mmfr0_el1, ID_MMFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b101),
> -	  NULL, get_id_mmfr1_el1, ID_MMFR1_EL1 },
> +	  access_id_reg, get_id_mmfr1_el1, ID_MMFR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b110),
> -	  NULL, get_id_mmfr2_el1, ID_MMFR2_EL1 },
> +	  access_id_reg, get_id_mmfr2_el1, ID_MMFR2_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b111),
> -	  NULL, get_id_mmfr3_el1, ID_MMFR3_EL1 },
> +	  access_id_reg, get_id_mmfr3_el1, ID_MMFR3_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
> -	  NULL, get_id_isar0_el1, ID_ISAR0_EL1 },
> +	  access_id_reg, get_id_isar0_el1, ID_ISAR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b001),
> -	  NULL, get_id_isar1_el1, ID_ISAR1_EL1 },
> +	  access_id_reg, get_id_isar1_el1, ID_ISAR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
> -	  NULL, get_id_isar2_el1, ID_ISAR2_EL1 },
> +	  access_id_reg, get_id_isar2_el1, ID_ISAR2_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b011),
> -	  NULL, get_id_isar3_el1, ID_ISAR3_EL1 },
> +	  access_id_reg, get_id_isar3_el1, ID_ISAR3_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b100),
> -	  NULL, get_id_isar4_el1, ID_ISAR4_EL1 },
> +	  access_id_reg, get_id_isar4_el1, ID_ISAR4_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b101),
> -	  NULL, get_id_isar5_el1, ID_ISAR5_EL1 },
> +	  access_id_reg, get_id_isar5_el1, ID_ISAR5_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b000),
> -	  NULL, get_mvfr0_el1, MVFR0_EL1 },
> +	  access_id_reg, get_mvfr0_el1, MVFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b001),
> -	  NULL, get_mvfr1_el1, MVFR1_EL1 },
> +	  access_id_reg, get_mvfr1_el1, MVFR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b010),
> -	  NULL, get_mvfr2_el1, MVFR2_EL1 },
> +	  access_id_reg, get_mvfr2_el1, MVFR2_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0100), Op2(0b000),
> -	  NULL, get_id_aa64pfr0_el1, ID_AA64PFR0_EL1 },
> +	  access_id_reg, get_id_aa64pfr0_el1, ID_AA64PFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0100), Op2(0b001),
> -	  NULL, get_id_aa64pfr1_el1, ID_AA64PFR1_EL1 },
> +	  access_id_reg, get_id_aa64pfr1_el1, ID_AA64PFR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b000),
> -	  NULL, get_id_aa64dfr0_el1, ID_AA64DFR0_EL1 },
> +	  access_id_reg, get_id_aa64dfr0_el1, ID_AA64DFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b001),
> -	  NULL, get_id_aa64dfr1_el1, ID_AA64DFR1_EL1 },
> +	  access_id_reg, get_id_aa64dfr1_el1, ID_AA64DFR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b100),
> -	  NULL, get_id_aa64afr0_el1, ID_AA64AFR0_EL1 },
> +	  access_id_reg, get_id_aa64afr0_el1, ID_AA64AFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b101),
> -	  NULL, get_id_aa64afr1_el1, ID_AA64AFR1_EL1 },
> +	  access_id_reg, get_id_aa64afr1_el1, ID_AA64AFR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b000),
> -	  NULL, get_id_aa64isar0_el1, ID_AA64ISAR0_EL1 },
> +	  access_id_reg, get_id_aa64isar0_el1, ID_AA64ISAR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b001),
> -	  NULL, get_id_aa64isar1_el1, ID_AA64ISAR1_EL1 },
> +	  access_id_reg, get_id_aa64isar1_el1, ID_AA64ISAR1_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b000),
> -	  NULL, get_id_aa64mmfr0_el1, ID_AA64MMFR0_EL1 },
> +	  access_id_reg, get_id_aa64mmfr0_el1, ID_AA64MMFR0_EL1 },
>  	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b001),
> -	  NULL, get_id_aa64mmfr1_el1, ID_AA64MMFR1_EL1 },
> +	  access_id_reg, get_id_aa64mmfr1_el1, ID_AA64MMFR1_EL1 },
>  	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
> -	  NULL, get_clidr_el1, CLIDR_EL1 },
> +	  access_id_reg, get_clidr_el1, CLIDR_EL1 },
>  	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b111),
> -	  NULL, get_aidr_el1, AIDR_EL1 },
> +	  access_id_reg, get_aidr_el1, AIDR_EL1 },
>  	{ Op0(0b11), Op1(0b011), CRn(0b0000), CRm(0b0000), Op2(0b001),
> -	  NULL, get_ctr_el0, CTR_EL0 },
> +	  access_id_reg, get_ctr_el0, CTR_EL0 },
>  };
>  
>  /* Target specific emulation tables */
> @@ -1809,8 +1822,12 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>  
>  	/* Search target-specific then generic table. */
>  	r = find_reg(params, table, num);
> -	if (!r)
> +	if (!r) {
>  		r = find_reg(params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> +		if (!r)
> +			r = find_reg(params, invariant_sys_regs,
> +				     ARRAY_SIZE(invariant_sys_regs));
> +	}
>  
>  	if (likely(r)) {
>  		/*
> -- 
> 2.0.4
> 
> 
