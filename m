From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Correctly handle zero register in
 system register accesses
Date: Fri, 04 Dec 2015 11:21:45 +0000
Message-ID: <56617749.2040009@arm.com>
References: <cover.1449224338.git.p.fedin@samsung.com> <aa4c4e970d2eaa725a026a1477d0cfe3e1bf7858.1449224339.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <aa4c4e970d2eaa725a026a1477d0cfe3e1bf7858.1449224339.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On 04/12/15 10:25, Pavel Fedin wrote:
> System register accesses also use zero register for Rt == 31, and
> therefore using it will also result in getting SP value instead. This
> patch makes them also using new accessors, introduced by the previous
> patch. Since register value is no longer directly associated with storage
> inside vCPU context structure, we introduce a dedicated storage for it in
> struct sys_reg_params.
> 
> This refactor also gets rid of "massive hack" in kvm_handle_cp_64().
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm64/kvm/sys_regs.c            | 88 ++++++++++++++++++------------------
>  arch/arm64/kvm/sys_regs.h            |  4 +-
>  arch/arm64/kvm/sys_regs_generic_v8.c |  2 +-
>  3 files changed, 46 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e5f024e..7c9cd64 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -97,18 +97,17 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	unsigned long val;
>  	bool was_enabled = vcpu_has_cache_enabled(vcpu);
>  
>  	BUG_ON(!p->is_write);
>  
> -	val = *vcpu_reg(vcpu, p->Rt);
>  	if (!p->is_aarch32) {
> -		vcpu_sys_reg(vcpu, r->reg) = val;
> +		vcpu_sys_reg(vcpu, r->reg) = p->regval;
>  	} else {
>  		if (!p->is_32bit)
> -			vcpu_cp15_64_high(vcpu, r->reg) = val >> 32;
> -		vcpu_cp15_64_low(vcpu, r->reg) = val & 0xffffffffUL;
> +			vcpu_cp15_64_high(vcpu, r->reg) =
> +				upper_32_bits(p->regval);

nit: please keep the assignment on one line. My terminal expands way
beyond 80 chars, and the checkpatch police doesn't intimidate me! ;-)

> +		vcpu_cp15_64_low(vcpu, r->reg) = lower_32_bits(p->regval);
>  	}
>  
>  	kvm_toggle_cache(vcpu, was_enabled);
> @@ -125,13 +124,10 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
>  			   struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
>  {
> -	u64 val;
> -
>  	if (!p->is_write)
>  		return read_from_write_only(vcpu, p);
>  
> -	val = *vcpu_reg(vcpu, p->Rt);
> -	vgic_v3_dispatch_sgi(vcpu, val);
> +	vgic_v3_dispatch_sgi(vcpu, p->regval);
>  
>  	return true;
>  }
> @@ -153,7 +149,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = (1 << 3);
> +		p->regval = (1 << 3);
>  		return true;
>  	}
>  }
> @@ -167,7 +163,7 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
>  	} else {
>  		u32 val;
>  		asm volatile("mrs %0, dbgauthstatus_el1" : "=r" (val));
> -		*vcpu_reg(vcpu, p->Rt) = val;
> +		p->regval = val;
>  		return true;
>  	}
>  }
> @@ -204,13 +200,13 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_desc *r)
>  {
>  	if (p->is_write) {
> -		vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
> +		vcpu_sys_reg(vcpu, r->reg) = p->regval;
>  		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
> +		p->regval = vcpu_sys_reg(vcpu, r->reg);
>  	}
>  
> -	trace_trap_reg(__func__, r->reg, p->is_write, *vcpu_reg(vcpu, p->Rt));
> +	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
>  
>  	return true;
>  }
> @@ -228,7 +224,7 @@ static inline void reg_to_dbg(struct kvm_vcpu *vcpu,
>  			      struct sys_reg_params *p,
>  			      u64 *dbg_reg)
>  {
> -	u64 val = *vcpu_reg(vcpu, p->Rt);
> +	u64 val = p->regval;
>  
>  	if (p->is_32bit) {
>  		val &= 0xffffffffUL;
> @@ -243,12 +239,9 @@ static inline void dbg_to_reg(struct kvm_vcpu *vcpu,
>  			      struct sys_reg_params *p,
>  			      u64 *dbg_reg)
>  {
> -	u64 val = *dbg_reg;
> -
> +	p->regval = *dbg_reg;
>  	if (p->is_32bit)
> -		val &= 0xffffffffUL;
> -
> -	*vcpu_reg(vcpu, p->Rt) = val;
> +		p->regval &= 0xffffffffUL;
>  }
>  
>  static inline bool trap_bvr(struct kvm_vcpu *vcpu,
> @@ -697,10 +690,10 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  		u64 pfr = read_system_reg(SYS_ID_AA64PFR0_EL1);
>  		u32 el3 = !!cpuid_feature_extract_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
> -		*vcpu_reg(vcpu, p->Rt) = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> -					  (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
> -					  (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20) |
> -					  (6 << 16) | (el3 << 14) | (el3 << 12));
> +		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> +			     (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
> +			     (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20)
> +			     | (6 << 16) | (el3 << 14) | (el3 << 12));
>  		return true;
>  	}
>  }
> @@ -710,10 +703,10 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
>  			 const struct sys_reg_desc *r)
>  {
>  	if (p->is_write) {
> -		vcpu_cp14(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
> +		vcpu_cp14(vcpu, r->reg) = p->regval;
>  		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = vcpu_cp14(vcpu, r->reg);
> +		p->regval = vcpu_cp14(vcpu, r->reg);
>  	}
>  
>  	return true;
> @@ -740,12 +733,12 @@ static inline bool trap_xvr(struct kvm_vcpu *vcpu,
>  		u64 val = *dbg_reg;
>  
>  		val &= 0xffffffffUL;
> -		val |= *vcpu_reg(vcpu, p->Rt) << 32;
> +		val |= p->regval << 32;
>  		*dbg_reg = val;
>  
>  		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
>  	} else {
> -		*vcpu_reg(vcpu, p->Rt) = *dbg_reg >> 32;
> +		p->regval = *dbg_reg >> 32;
>  	}
>  
>  	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
> @@ -1062,12 +1055,12 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>  {
>  	struct sys_reg_params params;
>  	u32 hsr = kvm_vcpu_get_hsr(vcpu);
> +	int Rt = (hsr >> 5) & 0xf;
>  	int Rt2 = (hsr >> 10) & 0xf;
>  
>  	params.is_aarch32 = true;
>  	params.is_32bit = false;
>  	params.CRm = (hsr >> 1) & 0xf;
> -	params.Rt = (hsr >> 5) & 0xf;
>  	params.is_write = ((hsr & 1) == 0);
>  
>  	params.Op0 = 0;
> @@ -1076,15 +1069,12 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
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
> +		params.regval = vcpu_get_reg(vcpu, Rt) & 0xffffffff;
> +		params.regval |= vcpu_get_reg(vcpu, Rt2) << 32;
>  	}
>  
>  	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
> @@ -1095,11 +1085,10 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>  	unhandled_cp_access(vcpu, &params);
>  
>  out:
> -	/* Do the opposite hack for the read side */
> +	/* Split up the value between registers for the read side */
>  	if (!params.is_write) {
> -		u64 val = *vcpu_reg(vcpu, params.Rt);
> -		val >>= 32;
> -		*vcpu_reg(vcpu, Rt2) = val;
> +		vcpu_set_reg(vcpu, Rt, lower_32_bits(params.regval));
> +		vcpu_set_reg(vcpu, Rt2, upper_32_bits(params.regval));
>  	}
>  
>  	return 1;
> @@ -1118,21 +1107,24 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
>  {
>  	struct sys_reg_params params;
>  	u32 hsr = kvm_vcpu_get_hsr(vcpu);
> +	int Rt  = (hsr >> 5) & 0xf;
>  
>  	params.is_aarch32 = true;
>  	params.is_32bit = true;
>  	params.CRm = (hsr >> 1) & 0xf;
> -	params.Rt  = (hsr >> 5) & 0xf;
> +	params.regval = vcpu_get_reg(vcpu, Rt);
>  	params.is_write = ((hsr & 1) == 0);
>  	params.CRn = (hsr >> 10) & 0xf;
>  	params.Op0 = 0;
>  	params.Op1 = (hsr >> 14) & 0x7;
>  	params.Op2 = (hsr >> 17) & 0x7;
>  
> -	if (!emulate_cp(vcpu, &params, target_specific, nr_specific))
> -		return 1;
> -	if (!emulate_cp(vcpu, &params, global, nr_global))
> +	if (!emulate_cp(vcpu, &params, target_specific, nr_specific) ||
> +	    !emulate_cp(vcpu, &params, global, nr_global)) {
> +		if (!params.is_write)
> +			vcpu_set_reg(vcpu, Rt, params.regval);
>  		return 1;
> +	}
>  
>  	unhandled_cp_access(vcpu, &params);
>  	return 1;
> @@ -1230,6 +1222,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
>  	struct sys_reg_params params;
>  	unsigned long esr = kvm_vcpu_get_hsr(vcpu);
> +	int Rt = (esr >> 5) & 0x1f;
> +	int ret;
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> @@ -1240,10 +1234,14 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	params.CRn = (esr >> 10) & 0xf;
>  	params.CRm = (esr >> 1) & 0xf;
>  	params.Op2 = (esr >> 17) & 0x7;
> -	params.Rt = (esr >> 5) & 0x1f;
> +	params.regval = vcpu_get_reg(vcpu, Rt);
>  	params.is_write = !(esr & 1);
>  
> -	return emulate_sys_reg(vcpu, &params);
> +	ret = emulate_sys_reg(vcpu, &params);
> +
> +	if (!params.is_write)
> +		vcpu_set_reg(vcpu, Rt, params.regval);
> +	return ret;
>  }
>  
>  /******************************************************************************
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 6c251ab..86ed945 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -28,7 +28,7 @@ struct sys_reg_params {
>  	u8	CRn;
>  	u8	CRm;
>  	u8	Op2;
> -	u8	Rt;
> +	u64	regval;
>  	bool	is_write;
>  	bool	is_aarch32;
>  	bool	is_32bit;	/* Only valid if is_aarch32 is true */
> @@ -79,7 +79,7 @@ static inline bool ignore_write(struct kvm_vcpu *vcpu,
>  static inline bool read_zero(struct kvm_vcpu *vcpu,
>  			     struct sys_reg_params *p)
>  {
> -	*vcpu_reg(vcpu, p->Rt) = 0;
> +	p->regval = 0;
>  	return true;
>  }
>  
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> index ccd3e35..ed90578 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -37,7 +37,7 @@ static bool access_actlr(struct kvm_vcpu *vcpu,
>  	if (p->is_write)
>  		return ignore_write(vcpu, p);
>  
> -	*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, ACTLR_EL1);
> +	p->regval = vcpu_sys_reg(vcpu, ACTLR_EL1);
>  	return true;
>  }
>  
> 

Aside from the above nit, this looks good to me:

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
