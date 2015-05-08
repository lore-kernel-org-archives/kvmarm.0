From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 10/12] KVM: arm64: trap nested debug register access
Date: Fri, 8 May 2015 18:46:49 +0200
Message-ID: <20150508164649.GK24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430989647-22501-3-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E591350E98
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 12:37:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ho+V0yXhzAFx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 12:37:54 -0400 (EDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
 [209.85.215.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A837150E8F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 12:37:54 -0400 (EDT)
Received: by layy10 with SMTP id y10so56674291lay.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 May 2015 09:46:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430989647-22501-3-git-send-email-alex.bennee@linaro.org>
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

On Thu, May 07, 2015 at 10:07:13AM +0100, Alex Benn=E9e wrote:
> When we are using the hardware registers for guest debug we need to deal
> with the guests access to them. There is already a mechanism for dealing
> with these accesses so we build on top of that.
> =

>   - any access to mdscr_el1 is now stored in the mirror location
>   - access to DBG[WB][CV]R continues to go to guest's context
> =

> There is one register (MDCCINT_EL1) which guest debug doesn't care about
> so this behaves as before.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v3
>   - re-factor for better flow and fall through.
>   - much simpler with debug_ptr (use the guest area as before)
>   - tweak shadow fn to avoid multi-line if
> =

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index a44fb32..7aa3b3a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -132,7 +132,13 @@ struct kvm_vcpu_arch {
>  	 * here.
>  	 */
>  =

> -	/* Guest registers we preserve during guest debugging */
> +	/*
> +	 * Guest registers we preserve during guest debugging.
> +	 *
> +	 * These shadow registers are updated by the kvm_handle_sys_reg
> +	 * trap handler if the guest accesses or updates them while we
> +	 * are using guest debug.
> +	 */
>  	struct {
>  		u32	pstate;
>  		u32	mdscr_el1;
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 1ab63dd..dc8bca8 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -50,8 +50,7 @@ static void restore_guest_debug_regs(struct kvm_vcpu *v=
cpu)
>  {
>  	*vcpu_cpsr(vcpu) |=3D
>  		(vcpu->arch.guest_debug_state.pstate & SPSR_DEBUG_MASK);
> -	vcpu_sys_reg(vcpu, MDSCR_EL1) |=3D
> -		(vcpu->arch.guest_debug_state.mdscr_el1 & MDSCR_EL1_DEBUG_MASK);
> +	vcpu_sys_reg(vcpu, MDSCR_EL1) =3D vcpu->arch.guest_debug_state.mdscr_el=
1;
>  }
>  =

>  /**
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c370b40..95f422f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -196,11 +196,40 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu =
*vcpu,
>   * - If the dirty bit is set, save guest registers, restore host
>   *   registers and clear the dirty bit. This ensure that the host can
>   *   now use the debug registers.
> + *
> + * We also use this mechanism to set-up the debug registers for guest

s/set-up/set up/

> + * debugging. If this is the case we want to ensure the guest sees

If this is the case, (comma)

> + * the right versions of the registers - even if they are not going to
> + * be effective while guest debug is using HW debug.
> + *
>   */
> +
> +static bool shadow_debug_reg(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_params *p,
> +			     const struct sys_reg_desc *r)
> +{
> +	/* MDSCR_EL1 */
> +	if (r->reg =3D=3D MDSCR_EL1) {
> +		u32 *shadow_mdscr_el1 =3D &vcpu->arch.guest_debug_state.mdscr_el1;
> +
> +		if (p->is_write)
> +			*shadow_mdscr_el1 =3D *vcpu_reg(vcpu, p->Rt);
> +		else
> +			*vcpu_reg(vcpu, p->Rt) =3D *shadow_mdscr_el1;
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> +	if (vcpu->guest_debug && shadow_debug_reg(vcpu, p, r))
> +		return true;
> +

so do we also have a MDSCR_EL1 in sys_regs and one in guest_debug_state
now?

If yes, what are the differences between the two?

>  	if (p->is_write) {
>  		vcpu_sys_reg(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
>  		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> -- =

> 2.3.5
> =

Thanks,
-Christoffer
