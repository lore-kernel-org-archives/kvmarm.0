From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 12/55] KVM: arm64: Handle EL2 register access traps
Date: Wed, 22 Feb 2017 12:30:22 +0100
Message-ID: <20170222113022.GG26976@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-13-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483943091-1364-13-git-send-email-jintack@cs.columbia.edu>
Sender: kvm-owner@vger.kernel.org
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 09, 2017 at 01:24:08AM -0500, Jintack Lim wrote:
> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
> addition, executing following instructions in EL1 will trap to EL2 -

the following:

So these instructions trap:
 - tlbi
 - at
 - eret
 - mrs/msr accessgin sp_el1

And they would previously undef at EL1, but now trap to EL2?

> tlbi and at instructions which are undefined when exectued in EL1, eret
> instruction, msr/mrs instructions to access SP_EL1.

this is a bit confusing to read.

> 
> This patch handles traps due to accessing EL2 registers in EL1.  The
> host hypervisor keeps EL2 register values in memory, and will use them
> to emulate the behavior that the guest hypervisor expects from the
> hardware.
> 
> Subsequent patches will handle other kinds of traps.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> ---
>  arch/arm64/kvm/sys_regs.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.h |   7 +++
>  2 files changed, 126 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7cef94f..4158f2f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -873,6 +873,18 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool trap_el2_reg(struct kvm_vcpu *vcpu,
> +			 struct sys_reg_params *p,
> +			 const struct sys_reg_desc *r)
> +{
> +	if (!p->is_write)
> +		p->regval = vcpu_el2_reg(vcpu, r->reg);
> +	else
> +		vcpu_el2_reg(vcpu, r->reg) = p->regval;
> +
> +	return true;
> +}
> +
>  /*
>   * Architected system registers.
>   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -1163,15 +1175,122 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b1111), Op2(0b111),
>  	  access_pmu_evtyper, reset_val, PMCCFILTR_EL0, 0 },
>  
> +	/* VPIDR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0000), CRm(0b0000), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, VPIDR_EL2, 0 },
> +	/* VMPIDR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0000), CRm(0b0000), Op2(0b101),
> +	  trap_el2_reg, reset_el2_val, VMPIDR_EL2, 0 },
> +
> +	/* SCTLR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0000), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, SCTLR_EL2, 0 },
> +	/* ACTLR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0000), Op2(0b001),
> +	  trap_el2_reg, reset_el2_val, ACTLR_EL2, 0 },
> +	/* HCR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0001), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, HCR_EL2, 0 },
> +	/* MDCR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0001), Op2(0b001),
> +	  trap_el2_reg, reset_el2_val, MDCR_EL2, 0 },
> +	/* CPTR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0001), Op2(0b010),
> +	  trap_el2_reg, reset_el2_val, CPTR_EL2, 0 },
> +	/* HSTR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0001), Op2(0b011),
> +	  trap_el2_reg, reset_el2_val, HSTR_EL2, 0 },
> +	/* HACR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0001), CRm(0b0001), Op2(0b111),
> +	  trap_el2_reg, reset_el2_val, HACR_EL2, 0 },
> +
> +	/* TTBR0_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0010), CRm(0b0000), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, TTBR0_EL2, 0 },
> +	/* TCR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0010), CRm(0b0000), Op2(0b010),
> +	  trap_el2_reg, reset_el2_val, TCR_EL2, 0 },
> +	/* VTTBR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0010), CRm(0b0001), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, VTTBR_EL2, 0 },
> +	/* VTCR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0010), CRm(0b0001), Op2(0b010),
> +	  trap_el2_reg, reset_el2_val, VTCR_EL2, 0 },
> +
>  	/* DACR32_EL2 */
>  	{ Op0(0b11), Op1(0b100), CRn(0b0011), CRm(0b0000), Op2(0b000),
>  	  NULL, reset_unknown, DACR32_EL2 },
> +
> +	/* SPSR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0100), CRm(0b0000), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, SPSR_EL2, 0 },
> +	/* ELR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0100), CRm(0b0000), Op2(0b001),
> +	  trap_el2_reg, reset_el2_val, ELR_EL2, 0 },
> +	/* SP_EL1 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0100), CRm(0b0001), Op2(0b000),
> +	  trap_el2_reg },
> +
>  	/* IFSR32_EL2 */
>  	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0000), Op2(0b001),
>  	  NULL, reset_unknown, IFSR32_EL2 },
> +	/* AFSR0_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0001), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, AFSR0_EL2, 0 },
> +	/* AFSR1_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0001), Op2(0b001),
> +	  trap_el2_reg, reset_el2_val, AFSR1_EL2, 0 },
> +	/* ESR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0010), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, ESR_EL2, 0 },
>  	/* FPEXC32_EL2 */
>  	{ Op0(0b11), Op1(0b100), CRn(0b0101), CRm(0b0011), Op2(0b000),
>  	  NULL, reset_val, FPEXC32_EL2, 0x70 },
> +
> +	/* FAR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0110), CRm(0b0000), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, FAR_EL2, 0 },
> +	/* HPFAR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b0110), CRm(0b0000), Op2(0b100),
> +	  trap_el2_reg, reset_el2_val, HPFAR_EL2, 0 },
> +
> +	/* MAIR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1010), CRm(0b0010), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, MAIR_EL2, 0 },
> +	/* AMAIR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1010), CRm(0b0011), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, AMAIR_EL2, 0 },
> +
> +	/* VBAR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1100), CRm(0b0000), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, VBAR_EL2, 0 },
> +	/* RVBAR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1100), CRm(0b0000), Op2(0b001),
> +	  trap_el2_reg, reset_el2_val, RVBAR_EL2, 0 },
> +	/* RMR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1100), CRm(0b0000), Op2(0b010),
> +	  trap_el2_reg, reset_el2_val, RMR_EL2, 0 },
> +
> +	/* TPIDR_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1101), CRm(0b0000), Op2(0b010),
> +	  trap_el2_reg, reset_el2_val, TPIDR_EL2, 0 },
> +
> +	/* CNTVOFF_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1110), CRm(0b0000), Op2(0b011),
> +	  trap_el2_reg, reset_el2_val, CNTVOFF_EL2, 0 },
> +	/* CNTHCTL_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1110), CRm(0b0001), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, CNTHCTL_EL2, 0 },
> +	/* CNTHP_TVAL_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1110), CRm(0b0010), Op2(0b000),
> +	  trap_el2_reg, reset_el2_val, CNTHP_TVAL_EL2, 0 },
> +	/* CNTHP_CTL_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1110), CRm(0b0010), Op2(0b001),
> +	  trap_el2_reg, reset_el2_val, CNTHP_CTL_EL2, 0 },
> +	/* CNTHP_CVAL_EL2 */
> +	{ Op0(0b11), Op1(0b100), CRn(0b1110), CRm(0b0010), Op2(0b010),
> +	  trap_el2_reg, reset_el2_val, CNTHP_CVAL_EL2, 0 },
> +
>  };
>  
>  static bool trap_dbgidr(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index dbbb01c..181290f 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -117,6 +117,13 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
>  	vcpu_sys_reg(vcpu, r->reg) = r->val;
>  }
>  
> +static inline void reset_el2_val(struct kvm_vcpu *vcpu,
> +				 const struct sys_reg_desc *r)
> +{
> +	BUG_ON(r->reg >= NR_EL2_REGS);
> +	vcpu_el2_reg(vcpu, r->reg) = r->val;
> +}
> +
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>  			      const struct sys_reg_desc *i2)
>  {
> -- 
> 1.9.1
> 
> 
