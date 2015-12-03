From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] KVM: arm64: Correctly handle zero register in system
 register accesses
Date: Thu, 03 Dec 2015 10:49:26 +0000
Message-ID: <56601E36.5070700@arm.com>
References: <cover.1449136209.git.p.fedin@samsung.com>
 <fff7d3cedc4d6ac0c81b089a4b2d7a992c83fb80.1449136209.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC252498B8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 05:48:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VS3MLu+raFcj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 05:47:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B4A549723
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 05:47:57 -0500 (EST)
In-Reply-To: <fff7d3cedc4d6ac0c81b089a4b2d7a992c83fb80.1449136209.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Pavel,

On 03/12/15 09:58, Pavel Fedin wrote:
> System register accesses also use zero register for Rt == 31, and
> therefore using it will also result in getting SP value instead. This
> patch makes them also using new accessors, introduced by the previous
> patch.
> 
> Additionally, got rid of "massive hack" in kvm_handle_cp_64().

Looks good for a first drop - some comments below.

> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm64/kvm/sys_regs.c            | 79 ++++++++++++++++++++----------------
>  arch/arm64/kvm/sys_regs.h            |  4 +-
>  arch/arm64/kvm/sys_regs_generic_v8.c |  2 +-
>  3 files changed, 46 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 87a64e8..a667228 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -102,7 +102,7 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  
>  	BUG_ON(!p->is_write);
>  
> -	val = *vcpu_reg(vcpu, p->Rt);
> +	val = *p->val;

Why does it have to be a pointer? You could just have "val = p->val" if
you carried the actual value instead of a pointer to the stack variable
holding that value.

>  	if (!p->is_aarch32) {
>  		vcpu_sys_reg(vcpu, r->reg) = val;
>  	} else {
> @@ -125,13 +125,10 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
>  			   const struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
>  {
> -	u64 val;
> -
>  	if (!p->is_write)
>  		return read_from_write_only(vcpu, p);
>  
> -	val = *vcpu_reg(vcpu, p->Rt);
> -	vgic_v3_dispatch_sgi(vcpu, val);
> +	vgic_v3_dispatch_sgi(vcpu, *p->val);
>  
>  	return true;
>  }
> @@ -153,7 +150,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = (1 << 3);
> +		*p->val = (1 << 3);
>  		return true;
>  	}
>  }
> @@ -167,7 +164,7 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
>  	} else {
>  		u32 val;
>  		asm volatile("mrs %0, dbgauthstatus_el1" : "=r" (val));
> -		*vcpu_reg(vcpu, p->Rt) = val;
> +		*p->val = val;
>  		return true;
>  	}
>  }
> @@ -204,13 +201,13 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_desc *r)
>  {
>  	if (p->is_write) {
> -		vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
> +		vcpu_sys_reg(vcpu, r->reg) = *p->val;
>  		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
> +		*p->val = vcpu_sys_reg(vcpu, r->reg);
>  	}
>  
> -	trace_trap_reg(__func__, r->reg, p->is_write, *vcpu_reg(vcpu, p->Rt));
> +	trace_trap_reg(__func__, r->reg, p->is_write, *p->val);
>  
>  	return true;
>  }
> @@ -228,7 +225,7 @@ static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
>  			      const struct sys_reg_params *p,
>  			      u64 *dbg_reg)
>  {
> -	u64 val = *vcpu_reg(vcpu, p->Rt);
> +	u64 val = *p->val;
>  
>  	if (p->is_32bit) {
>  		val &= 0xffffffffUL;
> @@ -248,7 +245,7 @@ static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
>  	if (p->is_32bit)
>  		val &= 0xffffffffUL;
>  
> -	*vcpu_reg(vcpu, p->Rt) = val;
> +	*p->val = val;
>  }
>  
>  static inline bool trap_bvr(struct kvm_vcpu *vcpu,
> @@ -697,10 +694,10 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  		u64 pfr = read_system_reg(SYS_ID_AA64PFR0_EL1);
>  		u32 el3 = !!cpuid_feature_extract_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
> -		*vcpu_reg(vcpu, p->Rt) = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> -					  (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
> -					  (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20) |
> -					  (6 << 16) | (el3 << 14) | (el3 << 12));
> +		*p->val = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> +			   (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
> +			   (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20) |
> +			   (6 << 16) | (el3 << 14) | (el3 << 12));
>  		return true;
>  	}
>  }
> @@ -710,10 +707,10 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
>  			 const struct sys_reg_desc *r)
>  {
>  	if (p->is_write) {
> -		vcpu_cp14(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
> +		vcpu_cp14(vcpu, r->reg) = *p->val;
>  		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = vcpu_cp14(vcpu, r->reg);
> +		*p->val = vcpu_cp14(vcpu, r->reg);
>  	}
>  
>  	return true;
> @@ -740,12 +737,12 @@ static inline bool trap_xvr(struct kvm_vcpu *vcpu,
>  		u64 val = *dbg_reg;
>  
>  		val &= 0xffffffffUL;
> -		val |= *vcpu_reg(vcpu, p->Rt) << 32;
> +		val |= *p->val << 32;
>  		*dbg_reg = val;
>  
>  		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = *dbg_reg >> 32;
> +		*p->val = *dbg_reg >> 32;
>  	}
>  
>  	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
> @@ -1062,12 +1059,14 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>  {
>  	struct sys_reg_params params;
>  	u32 hsr = kvm_vcpu_get_hsr(vcpu);
> +	int Rt = (hsr >> 5) & 0xf;
>  	int Rt2 = (hsr >> 10) & 0xf;
> +	unsigned long val;
>  
>  	params.is_aarch32 = true;
>  	params.is_32bit = false;
>  	params.CRm = (hsr >> 1) & 0xf;
> -	params.Rt = (hsr >> 5) & 0xf;
> +	params.val = &val;
>  	params.is_write = ((hsr & 1) == 0);
>  
>  	params.Op0 = 0;
> @@ -1076,15 +1075,12 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>  	params.CRn = 0;
>  
>  	/*
> -	 * Massive hack here. Store Rt2 in the top 32bits so we only
> -	 * have one register to deal with. As we use the same trap
> +	 * Make a 64-bit value out of Rt and Rt2. As we use the same trap
>  	 * backends between AArch32 and AArch64, we get away with it.
>  	 */
>  	if (params.is_write) {
> -		u64 val = *vcpu_reg(vcpu, params.Rt);
> -		val &= 0xffffffff;
> -		val |= *vcpu_reg(vcpu, Rt2) << 32;
> -		*vcpu_reg(vcpu, params.Rt) = val;
> +		val = vcpu_get_reg(vcpu, Rt) & 0xffffffff;
> +		val |= vcpu_get_reg(vcpu, Rt2) << 32;
>  	}
>  
>  	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
> @@ -1095,11 +1091,10 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>  	unhandled_cp_access(vcpu, &params);
>  
>  out:
> -	/* Do the opposite hack for the read side */
> +	/* Split up the value between registers for the read side */
>  	if (!params.is_write) {
> -		u64 val = *vcpu_reg(vcpu, params.Rt);
> -		val >>= 32;
> -		*vcpu_reg(vcpu, Rt2) = val;
> +		vcpu_set_reg(vcpu, Rt, val & 0xffffffff);
> +		vcpu_set_reg(vcpu, Rt, val >> 32);

Can you use higher_32bit/lower_32bit since you're touching that code?

>  	}
>  
>  	return 1;
> @@ -1118,21 +1113,27 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
>  {
>  	struct sys_reg_params params;
>  	u32 hsr = kvm_vcpu_get_hsr(vcpu);
> +	int Rt  = (hsr >> 5) & 0xf;
> +	unsigned long val = vcpu_get_reg(vcpu, Rt);
>  
>  	params.is_aarch32 = true;
>  	params.is_32bit = true;
>  	params.CRm = (hsr >> 1) & 0xf;
> -	params.Rt  = (hsr >> 5) & 0xf;
> +	params.val = &val;
>  	params.is_write = ((hsr & 1) == 0);
>  	params.CRn = (hsr >> 10) & 0xf;
>  	params.Op0 = 0;
>  	params.Op1 = (hsr >> 14) & 0x7;
>  	params.Op2 = (hsr >> 17) & 0x7;
>  
> -	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
> +	if (!emulate_cp(vcpu, &params, target_specific, nr_specific)) {
> +		vcpu_set_reg(vcpu, Rt, val);
>  		return 1;
> -	if (!emulate_cp(vcpu, &params, global, nr_global))
> +	}
> +	if (!emulate_cp(vcpu, &params, global, nr_global)) {
> +		vcpu_set_reg(vcpu, Rt, val);
>  		return 1;
> +	}

I'm not sure I'm 100% confident to do a writeback to the register if
that was a sysreg read.

Could you write it like this instead:
	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
	    !emulate_cp(vcpu, &params, global, nr_global)) {
		if (!params.is_write)
			vcpu_set_reg(vcpu, Rt, val);
		return 1;
	}
>  
>  	unhandled_cp_access(vcpu, &params);
>  	return 1;
> @@ -1230,6 +1231,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	struct sys_reg_params params;
>  	unsigned long esr = kvm_vcpu_get_hsr(vcpu);
> +	int Rt = (esr >> 5) & 0x1f;
> +	unsigned long val = vcpu_get_reg(vcpu, Rt);
> +	int ret;
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> @@ -1240,10 +1244,13 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.CRn = (esr >> 10) & 0xf;
>  	params.CRm = (esr >> 1) & 0xf;
>  	params.Op2 = (esr >> 17) & 0x7;
> -	params.Rt = (esr >> 5) & 0x1f;
> +	params.val = &val;
>  	params.is_write = !(esr & 1);
>  
> -	return emulate_sys_reg(vcpu, &params);
> +	ret = emulate_sys_reg(vcpu, &params);
> +
> +	vcpu_set_reg(vcpu, Rt, val);

Same here. Clobbering the source register on a write feels unsafe.

> +	return ret;
>  }
>  
>  /******************************************************************************
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index eaa324e..3267518 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -28,7 +28,7 @@ struct sys_reg_params {
>  	u8	CRn;
>  	u8	CRm;
>  	u8	Op2;
> -	u8	Rt;
> +	u_long	*val;

This definitely should be a u64. I'd also prefer something like regval,
which is slightly more precise. And make it a direct variable, not a
pointer.

>  	bool	is_write;
>  	bool	is_aarch32;
>  	bool	is_32bit;	/* Only valid if is_aarch32 is true */
> @@ -79,7 +79,7 @@ static inline bool ignore_write(struct kvm_vcpu *vcpu,
>  static inline bool read_zero(struct kvm_vcpu *vcpu,
>  			     const struct sys_reg_params *p)
>  {
> -	*vcpu_reg(vcpu, p->Rt) = 0;
> +	*p->val = 0;
>  	return true;
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> index 1e45768..c805576 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -37,7 +37,7 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
>  	if (p->is_write)
>  		return ignore_write(vcpu, p);
>  
> -	*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, ACTLR_EL1);
> +	*p->val = vcpu_sys_reg(vcpu, ACTLR_EL1);
>  	return true;
>  }
>  
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
