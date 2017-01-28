From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 2/7] ARM64: KVM: Add reset handlers for all ID
 registers
Date: Sat, 28 Jan 2017 13:36:53 +0100
Message-ID: <20170128123653.4s4azvxyfiqlc64f@hawk.localdomain>
References: <1484559214-2248-1-git-send-email-zhaoshenglong@huawei.com>
 <1484559214-2248-3-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE2564095B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Jan 2017 07:36:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nwEF8fi25ChR for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 Jan 2017 07:36:44 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB4C840838
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 Jan 2017 07:36:44 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1484559214-2248-3-git-send-email-zhaoshenglong@huawei.com>
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

On Mon, Jan 16, 2017 at 05:33:29PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Move invariant_sys_regs before emulate_sys_reg so that it can be used
> later.

This patch says it's adding reset handlers, but it's not, because the
handlers were already there. This patch is adding register indices,
which, at this point, appear to still be unused. The patch also adds new
registers to the table without mentioning that in the commit message.
The new registers should be added with a separate patch first, providing
justification in its commit message. The code movement called out in the
commit message is fine, but yet to serve a purpose, so I guess I'll just
have to stay tuned.

drew

> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 193 ++++++++++++++++++++++++++++------------------
>  1 file changed, 116 insertions(+), 77 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 87e7e66..bf71eb4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1432,6 +1432,122 @@ static const struct sys_reg_desc cp15_64_regs[] = {
>  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR1 },
>  };
>  
> +/*
> + * These are the invariant sys_reg registers: we let the guest see the
> + * host versions of these, so they're part of the guest state.
> + *
> + * A future CPU may provide a mechanism to present different values to
> + * the guest, or a future kvm may trap them.
> + */
> +
> +#define FUNCTION_INVARIANT(reg)						\
> +	static void get_##reg(struct kvm_vcpu *v,			\
> +			      const struct sys_reg_desc *r)		\
> +	{								\
> +		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
> +	}
> +
> +FUNCTION_INVARIANT(midr_el1)
> +FUNCTION_INVARIANT(ctr_el0)
> +FUNCTION_INVARIANT(revidr_el1)
> +FUNCTION_INVARIANT(id_pfr0_el1)
> +FUNCTION_INVARIANT(id_pfr1_el1)
> +FUNCTION_INVARIANT(id_dfr0_el1)
> +FUNCTION_INVARIANT(id_afr0_el1)
> +FUNCTION_INVARIANT(id_mmfr0_el1)
> +FUNCTION_INVARIANT(id_mmfr1_el1)
> +FUNCTION_INVARIANT(id_mmfr2_el1)
> +FUNCTION_INVARIANT(id_mmfr3_el1)
> +FUNCTION_INVARIANT(id_isar0_el1)
> +FUNCTION_INVARIANT(id_isar1_el1)
> +FUNCTION_INVARIANT(id_isar2_el1)
> +FUNCTION_INVARIANT(id_isar3_el1)
> +FUNCTION_INVARIANT(id_isar4_el1)
> +FUNCTION_INVARIANT(id_isar5_el1)
> +FUNCTION_INVARIANT(mvfr0_el1)
> +FUNCTION_INVARIANT(mvfr1_el1)
> +FUNCTION_INVARIANT(mvfr2_el1)
> +FUNCTION_INVARIANT(id_aa64pfr0_el1)
> +FUNCTION_INVARIANT(id_aa64pfr1_el1)
> +FUNCTION_INVARIANT(id_aa64dfr0_el1)
> +FUNCTION_INVARIANT(id_aa64dfr1_el1)
> +FUNCTION_INVARIANT(id_aa64afr0_el1)
> +FUNCTION_INVARIANT(id_aa64afr1_el1)
> +FUNCTION_INVARIANT(id_aa64isar0_el1)
> +FUNCTION_INVARIANT(id_aa64isar1_el1)
> +FUNCTION_INVARIANT(id_aa64mmfr0_el1)
> +FUNCTION_INVARIANT(id_aa64mmfr1_el1)
> +FUNCTION_INVARIANT(clidr_el1)
> +FUNCTION_INVARIANT(aidr_el1)
> +
> +/* ->val is filled in by kvm_sys_reg_table_init() */
> +static struct sys_reg_desc invariant_sys_regs[] = {
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
> +	  NULL, get_midr_el1, MIDR_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
> +	  NULL, get_revidr_el1, REVIDR_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
> +	  NULL, get_id_pfr0_el1, ID_PFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
> +	  NULL, get_id_pfr1_el1, ID_PFR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
> +	  NULL, get_id_dfr0_el1, ID_DFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b011),
> +	  NULL, get_id_afr0_el1, ID_AFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b100),
> +	  NULL, get_id_mmfr0_el1, ID_MMFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b101),
> +	  NULL, get_id_mmfr1_el1, ID_MMFR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b110),
> +	  NULL, get_id_mmfr2_el1, ID_MMFR2_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b111),
> +	  NULL, get_id_mmfr3_el1, ID_MMFR3_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
> +	  NULL, get_id_isar0_el1, ID_ISAR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b001),
> +	  NULL, get_id_isar1_el1, ID_ISAR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
> +	  NULL, get_id_isar2_el1, ID_ISAR2_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b011),
> +	  NULL, get_id_isar3_el1, ID_ISAR3_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b100),
> +	  NULL, get_id_isar4_el1, ID_ISAR4_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b101),
> +	  NULL, get_id_isar5_el1, ID_ISAR5_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b000),
> +	  NULL, get_mvfr0_el1, MVFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b001),
> +	  NULL, get_mvfr1_el1, MVFR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0011), Op2(0b010),
> +	  NULL, get_mvfr2_el1, MVFR2_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0100), Op2(0b000),
> +	  NULL, get_id_aa64pfr0_el1, ID_AA64PFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0100), Op2(0b001),
> +	  NULL, get_id_aa64pfr1_el1, ID_AA64PFR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b000),
> +	  NULL, get_id_aa64dfr0_el1, ID_AA64DFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b001),
> +	  NULL, get_id_aa64dfr1_el1, ID_AA64DFR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b100),
> +	  NULL, get_id_aa64afr0_el1, ID_AA64AFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0101), Op2(0b101),
> +	  NULL, get_id_aa64afr1_el1, ID_AA64AFR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b000),
> +	  NULL, get_id_aa64isar0_el1, ID_AA64ISAR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0110), Op2(0b001),
> +	  NULL, get_id_aa64isar1_el1, ID_AA64ISAR1_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b000),
> +	  NULL, get_id_aa64mmfr0_el1, ID_AA64MMFR0_EL1 },
> +	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0111), Op2(0b001),
> +	  NULL, get_id_aa64mmfr1_el1, ID_AA64MMFR1_EL1 },
> +	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
> +	  NULL, get_clidr_el1, CLIDR_EL1 },
> +	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b111),
> +	  NULL, get_aidr_el1, AIDR_EL1 },
> +	{ Op0(0b11), Op1(0b011), CRn(0b0000), CRm(0b0000), Op2(0b001),
> +	  NULL, get_ctr_el0, CTR_EL0 },
> +};
> +
>  /* Target specific emulation tables */
>  static struct kvm_sys_reg_target_table *target_tables[KVM_ARM_NUM_TARGETS];
>  
> @@ -1822,83 +1938,6 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> -/*
> - * These are the invariant sys_reg registers: we let the guest see the
> - * host versions of these, so they're part of the guest state.
> - *
> - * A future CPU may provide a mechanism to present different values to
> - * the guest, or a future kvm may trap them.
> - */
> -
> -#define FUNCTION_INVARIANT(reg)						\
> -	static void get_##reg(struct kvm_vcpu *v,			\
> -			      const struct sys_reg_desc *r)		\
> -	{								\
> -		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
> -	}
> -
> -FUNCTION_INVARIANT(midr_el1)
> -FUNCTION_INVARIANT(ctr_el0)
> -FUNCTION_INVARIANT(revidr_el1)
> -FUNCTION_INVARIANT(id_pfr0_el1)
> -FUNCTION_INVARIANT(id_pfr1_el1)
> -FUNCTION_INVARIANT(id_dfr0_el1)
> -FUNCTION_INVARIANT(id_afr0_el1)
> -FUNCTION_INVARIANT(id_mmfr0_el1)
> -FUNCTION_INVARIANT(id_mmfr1_el1)
> -FUNCTION_INVARIANT(id_mmfr2_el1)
> -FUNCTION_INVARIANT(id_mmfr3_el1)
> -FUNCTION_INVARIANT(id_isar0_el1)
> -FUNCTION_INVARIANT(id_isar1_el1)
> -FUNCTION_INVARIANT(id_isar2_el1)
> -FUNCTION_INVARIANT(id_isar3_el1)
> -FUNCTION_INVARIANT(id_isar4_el1)
> -FUNCTION_INVARIANT(id_isar5_el1)
> -FUNCTION_INVARIANT(clidr_el1)
> -FUNCTION_INVARIANT(aidr_el1)
> -
> -/* ->val is filled in by kvm_sys_reg_table_init() */
> -static struct sys_reg_desc invariant_sys_regs[] = {
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
> -	  NULL, get_midr_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
> -	  NULL, get_revidr_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
> -	  NULL, get_id_pfr0_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b001),
> -	  NULL, get_id_pfr1_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b010),
> -	  NULL, get_id_dfr0_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b011),
> -	  NULL, get_id_afr0_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b100),
> -	  NULL, get_id_mmfr0_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b101),
> -	  NULL, get_id_mmfr1_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b110),
> -	  NULL, get_id_mmfr2_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b111),
> -	  NULL, get_id_mmfr3_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b000),
> -	  NULL, get_id_isar0_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b001),
> -	  NULL, get_id_isar1_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b010),
> -	  NULL, get_id_isar2_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b011),
> -	  NULL, get_id_isar3_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b100),
> -	  NULL, get_id_isar4_el1 },
> -	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0010), Op2(0b101),
> -	  NULL, get_id_isar5_el1 },
> -	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b001),
> -	  NULL, get_clidr_el1 },
> -	{ Op0(0b11), Op1(0b001), CRn(0b0000), CRm(0b0000), Op2(0b111),
> -	  NULL, get_aidr_el1 },
> -	{ Op0(0b11), Op1(0b011), CRn(0b0000), CRm(0b0000), Op2(0b001),
> -	  NULL, get_ctr_el0 },
> -};
> -
>  static int reg_from_user(u64 *val, const void __user *uaddr, u64 id)
>  {
>  	if (copy_from_user(val, uaddr, KVM_REG_SIZE(id)) != 0)
> -- 
> 2.0.4
> 
> 
