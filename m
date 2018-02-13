From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64/kvm: Prohibit guest LOR accesses
Date: Tue, 13 Feb 2018 11:27:42 +0100
Message-ID: <20180213102742.GG23189@cbox>
References: <20180212111424.39248-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E11E540478
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Feb 2018 05:21:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3t1+IH+A3kW0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Feb 2018 05:21:29 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C4F9C4038F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Feb 2018 05:21:29 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id v123so15093866wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Feb 2018 02:27:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180212111424.39248-1-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mark,

On Mon, Feb 12, 2018 at 11:14:24AM +0000, Mark Rutland wrote:
> We don't currently limit guest accesses to the LOR registers, which we
> neither virtualize nor context-switch. As such, guests are provided with
> unusable information/controls, and are not isolated from each other (or
> the host).
> 
> To prevent these issues, we can trap register accesses and present the
> illusion that no LORegions are implemented.

Shouldn't we then also hide this from the ID register similar to what we
do for SVE at the moment, using something like this (untested):

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a828a209716f..b7ee414aee67 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1064,6 +1064,12 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 				    task_pid_nr(current));
 
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
+	} else if (id == SYS_ID_AA64MMFR1_EL) {
+		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
+			pr_err_once("kvm [%i]: LORegions unsupported for guests, suppressing\n",
+				    task_pid_nr(current));
+
+		val &= ~(0xfUL << ID_AA64MMFR1_LOR_SHIFT);
 	}
 
 	return val;

> Per ARM DDI 0487B.a, in this
> case all fields in LORID_EL1 will contain zero, and:
> 
> * LORC_EL1  is RW, RES0 (D7.2.65 "Configurations" & "Accessibility")
> * LOREA_EL1 is RW, RES0 (D7.2.66 "Configurations" & "Accessibility")
> * LORN_EL1  is RW, RES0 (D7.2.68 "Configurations" & "Accessibility")
> * LORSA_EL1 is RW, RES0 (D7.2.69 "Configurations" & "Accessibility")
> 
> Note that LORID_EL1 itself is RO per D7.2.67.
> 
> As noted in D7.2.67, when no LORegions are implemented, LoadLOAcquire
> and StoreLORelease must behave as LoadAcquire and StoreRelease
> respectively. We can ensure this by clearing LORC_EL1.EN when a CPU's
> EL2 is first initialized, as the host kernel will not modify this.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_arm.h |  4 +++-
>  arch/arm64/include/asm/sysreg.h  |  6 ++++++
>  arch/arm64/kernel/head.S         |  7 +++++++
>  arch/arm64/kvm/sys_regs.c        | 17 +++++++++++++++++
>  4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b0c84171e6a3..1b438c334463 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -25,6 +25,7 @@
>  /* Hyp Configuration Register (HCR) bits */
>  #define HCR_TEA		(UL(1) << 37)
>  #define HCR_TERR	(UL(1) << 36)
> +#define HCR_TLOR	(UL(1) << 35)
>  #define HCR_E2H		(UL(1) << 34)
>  #define HCR_ID		(UL(1) << 33)
>  #define HCR_CD		(UL(1) << 32)
> @@ -64,6 +65,7 @@
>  
>  /*
>   * The bits we set in HCR:
> + * TLOR:	Trap LORegion register accesses
>   * RW:		64bit by default, can be overridden for 32bit VMs
>   * TAC:		Trap ACTLR
>   * TSC:		Trap SMC
> @@ -81,7 +83,7 @@
>   */
>  #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
>  			 HCR_TVM | HCR_BSU_IS | HCR_FB | HCR_TAC | \
> -			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
> +			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR)
>  #define HCR_VIRT_EXCP_MASK (HCR_VSE | HCR_VI | HCR_VF)
>  #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 0e1960c59197..69a99856461c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -288,6 +288,12 @@
>  #define SYS_MAIR_EL1			sys_reg(3, 0, 10, 2, 0)
>  #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
>  
> +#define SYS_LORSA_EL1			sys_reg(3, 0, 10, 4, 0)
> +#define SYS_LOREA_EL1			sys_reg(3, 0, 10, 4, 1)
> +#define SYS_LORN_EL1			sys_reg(3, 0, 10, 4, 2)
> +#define SYS_LORC_EL1			sys_reg(3, 0, 10, 4, 3)
> +#define SYS_LORID_EL1			sys_reg(3, 0, 10, 4, 7)
> +
>  #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
>  #define SYS_DISR_EL1			sys_reg(3, 0, 12, 1, 1)
>  
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 2b6b8b24e5ab..b0853069702f 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -577,6 +577,13 @@ set_hcr:
>  7:
>  	msr	mdcr_el2, x3			// Configure debug traps
>  
> +	/* LORegions */
> +	mrs	x1, id_aa64mmfr1_el1
> +	ubfx	x0, x1, #ID_AA64MMFR1_LOR_SHIFT, 4
> +	cbz	x0, 1f
> +	msr_s	SYS_LORC_EL1, xzr
> +1:
> +
>  	/* Stage-2 translation */
>  	msr	vttbr_el2, xzr
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 50a43c7b97ca..67b10b7a07bf 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -175,6 +175,17 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  		return read_zero(vcpu, p);
>  }
>  
> +static bool trap_raz_ro(struct kvm_vcpu *vcpu,
> +			struct sys_reg_params *p,
> +			const struct sys_reg_desc *r)
> +{
> +	if (!p->is_write)
> +		return read_zero(vcpu, p);
> +
> +	kvm_inject_undefined(vcpu);
> +	return false;
> +}
> +

I'm a little unclear if this is stricly the right thing to do.  I can't
seem to find anything specific about writes to this register (which has
some text about RW fields but only specifies it can be *read* with an
MRS instruction), so it seems to me that this should either be
trap_raz_wi(), or call write_to_read_only() if we expect a write to
undef at EL1 rather than trap to EL2.  On the other hand, if the
architecture is unclear, then we're at least enforcing one
interpretation here I suppose.

>  static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  			   struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
> @@ -1178,6 +1189,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
>  	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
>  
> +	{ SYS_DESC(SYS_LORSA_EL1), trap_raz_wi },
> +	{ SYS_DESC(SYS_LOREA_EL1), trap_raz_wi },
> +	{ SYS_DESC(SYS_LORN_EL1), trap_raz_wi },
> +	{ SYS_DESC(SYS_LORC_EL1), trap_raz_wi },
> +	{ SYS_DESC(SYS_LORID_EL1), trap_raz_ro },
> +
>  	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
>  	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
>  
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
