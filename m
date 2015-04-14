From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 09/10] KVM: arm64: trap nested debug register access
Date: Tue, 14 Apr 2015 12:30:09 +0200
Message-ID: <20150414103009.GX6186@cbox>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
 <1427814488-28467-10-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61ED84D017
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:22:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lMpJ5elv-unR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2015 06:22:14 -0400 (EDT)
Received: from mail-la0-f43.google.com (mail-la0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EFF54D016
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 06:22:13 -0400 (EDT)
Received: by lagv1 with SMTP id v1so4191371lag.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2015 03:30:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1427814488-28467-10-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, zhichao.huang@linaro.org, r65777@freescale.com, pbonzini@redhat.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Mar 31, 2015 at 04:08:07PM +0100, Alex Benn=E9e wrote:
> When we are using the hardware registers for guest debug we need to deal
> with the guests access to them. There is already a mechanism for dealing
> with these accesses so we build on top of that.
> =

>   - mdscr_el1_bits is renamed as we save the whole register
>   - any access to mdscr_el1 is now stored in the mirror location
>   - if we are using HW assisted debug we do the same with DBG[WB][CV]R
> =

> There is one register (MDCCINT_EL1) which guest debug doesn't care about
> so this behaves as before.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index 2c359c9..3d32d45 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -122,10 +122,13 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
>  =

> -	/* Registers pre any guest debug manipulations */
> +	/* Registers before any guest debug manipulations. These
> +	 * shadow registers are updated by the kvm_handle_sys_reg
> +	 * trap handler if the guest accesses or updates them
> +	 */
>  	struct {
>  		u32	pstate_ss_bit;
> -		u32	mdscr_el1_bits;
> +		u32	mdscr_el1;
>  =

>  		struct kvm_guest_debug_arch debug_regs;
>  	} debug_saved_regs;
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 3b368f3..638c111 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -55,8 +55,6 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);
>  =

> -	trace_kvm_arch_setup_debug_reg32("MDCR_EL2", vcpu->arch.mdcr_el2);
> -
>  	/*
>  	 * If we are not treating debug registers are dirty we need
>  	 * to trap if the guest starts accessing them.
> @@ -71,8 +69,10 @@ void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
>  		/* Save pstate/mdscr */
>  		vcpu_debug_saved_reg(vcpu, pstate_ss_bit) =3D
>  			*vcpu_cpsr(vcpu) & DBG_SPSR_SS;
> -		vcpu_debug_saved_reg(vcpu, mdscr_el1_bits) =3D
> -			vcpu_sys_reg(vcpu, MDSCR_EL1) & MDSCR_EL1_DEBUG_BITS;
> +
> +		vcpu_debug_saved_reg(vcpu, mdscr_el1) =3D
> +			vcpu_sys_reg(vcpu, MDSCR_EL1);
> +

you can avoid this churn in the patches by following Drew's advice to a
previous patch.

>  		/*
>  		 * Single Step (ARM ARM D2.12.3 The software step state
>  		 * machine)
> @@ -161,9 +161,8 @@ void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
>  		*vcpu_cpsr(vcpu) &=3D ~DBG_SPSR_SS;
>  		*vcpu_cpsr(vcpu) |=3D vcpu_debug_saved_reg(vcpu, pstate_ss_bit);
>  =

> -		vcpu_sys_reg(vcpu, MDSCR_EL1) &=3D ~MDSCR_EL1_DEBUG_BITS;
> -		vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> -			vcpu_debug_saved_reg(vcpu, mdscr_el1_bits);
> +		vcpu_sys_reg(vcpu, MDSCR_EL1) =3D
> +			vcpu_debug_saved_reg(vcpu, mdscr_el1);
>  =

>  		/*
>  		 * If we were using HW debug we need to restore the
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index be9b188..d43d7d1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -208,39 +208,61 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> -	if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> -		struct kvm_guest_debug_arch *saved;
> -		__u64 *val;
> -
> -		saved =3D &vcpu_debug_saved_reg(vcpu, debug_regs);
> -
> -		if (r->reg >=3D DBGBCR0_EL1 && r->reg <=3D DBGBCR15_EL1)
> -			val =3D &saved->dbg_bcr[r->reg - DBGBCR0_EL1];
> -		else if (r->reg >=3D DBGBVR0_EL1 && r->reg <=3D DBGBVR15_EL1)
> -			val =3D &saved->dbg_bvr[r->reg - DBGBVR0_EL1];
> -		else if (r->reg >=3D DBGWCR0_EL1 && r->reg <=3D DBGWCR15_EL1)
> -			val =3D &saved->dbg_wcr[r->reg - DBGWCR0_EL1];
> -		else if (r->reg >=3D DBGWVR0_EL1 && r->reg <=3D DBGWVR15_EL1)
> -			val =3D &saved->dbg_wvr[r->reg - DBGWVR0_EL1];
> -		else {
> -			kvm_err("Bad register index %d\n", r->reg);
> -			return false;
> +	if (vcpu->guest_debug) {
> +
> +		/* MDSCR_EL1 */
> +		if (r->reg =3D=3D MDSCR_EL1) {
> +			if (p->is_write)
> +				vcpu_debug_saved_reg(vcpu, mdscr_el1) =3D
> +					*vcpu_reg(vcpu, p->Rt);
> +			else
> +				*vcpu_reg(vcpu, p->Rt) =3D
> +					vcpu_debug_saved_reg(vcpu, mdscr_el1);
> +
> +			return true;
>  		}
>  =

> -		if (p->is_write)
> -			*val =3D *vcpu_reg(vcpu, p->Rt);
> -		else
> -			*vcpu_reg(vcpu, p->Rt) =3D *val;
> +		/* MDCCINT_EL1 */
> +		if (r->reg =3D=3D MDCCINT_EL1)
> +			goto old;
> +
> +		/* We only shadow DBG* if guest being debugged */
> +		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) {
> +			struct kvm_guest_debug_arch *saved;
> +			__u64 *val;
> +
> +			saved =3D &vcpu_debug_saved_reg(vcpu, debug_regs);
> +
> +			if (r->reg >=3D DBGBCR0_EL1 && r->reg <=3D DBGBCR15_EL1)
> +				val =3D &saved->dbg_bcr[r->reg - DBGBCR0_EL1];
> +			else if (r->reg >=3D DBGBVR0_EL1 && r->reg <=3D DBGBVR15_EL1)
> +				val =3D &saved->dbg_bvr[r->reg - DBGBVR0_EL1];
> +			else if (r->reg >=3D DBGWCR0_EL1 && r->reg <=3D DBGWCR15_EL1)
> +				val =3D &saved->dbg_wcr[r->reg - DBGWCR0_EL1];
> +			else if (r->reg >=3D DBGWVR0_EL1 && r->reg <=3D DBGWVR15_EL1)
> +				val =3D &saved->dbg_wvr[r->reg - DBGWVR0_EL1];
> +			else {
> +				kvm_err("Bad register index %d\n", r->reg);
> +				return false;
> +			}
>  =

> -	} else {
> -		if (p->is_write) {
> -			vcpu_sys_reg(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
> -			vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> -		} else {
> -			*vcpu_reg(vcpu, p->Rt) =3D vcpu_sys_reg(vcpu, r->reg);
> +			if (p->is_write)
> +				*val =3D *vcpu_reg(vcpu, p->Rt);
> +			else
> +				*vcpu_reg(vcpu, p->Rt) =3D *val;
> +
> +			return true;
>  		}
>  	}
>  =

> +old:
> +	if (p->is_write) {
> +		vcpu_sys_reg(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> +	} else {
> +		*vcpu_reg(vcpu, p->Rt) =3D vcpu_sys_reg(vcpu, r->reg);
> +	}
> +

I really think this points to a problem with the design; the emulate
function should just emulate writes/reads to some state without this
complexity.  If there's some reason not to do this, you should put that
in the commit text.

>  	return true;
>  }
>  =

> -- =

> 2.3.4
> =


Thanks,
-Christoffer
