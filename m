From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 13/23] KVM: arm64/sve: Context switch the SVE
 registers
Date: Mon, 19 Nov 2018 17:03:03 +0000
Message-ID: <20181119170303.GX3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-14-git-send-email-Dave.Martin@arm.com>
 <87sgzxhvny.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 171AB4A30A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 12:03:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sKLzXErAndxt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Nov 2018 12:03:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 865DF4A2BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Nov 2018 12:03:08 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87sgzxhvny.fsf@linaro.org>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 19, 2018 at 04:36:01PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > In order to give each vcpu its own view of the SVE registers, this
> > patch adds context storage via a new sve_state pointer in struct
> > vcpu_arch.  An additional member sve_max_vl is also added for each
> > vcpu, to determine the maximum vector length visible to the guest
> > and thus the value to be configured in ZCR_EL2.LEN while the is
> > active.  This also determines the layout and size of the storage in
> > sve_state, which is read and written by the same backend functions
> > that are used for context-switching the SVE state for host tasks.
> >
> > On SVE-enabled vcpus, SVE access traps are now handled by switching
> > in the vcpu's SVE context and disabling the trap before returning
> > to the guest.  On other vcpus, the trap is not handled and an exit
> > back to the host occurs, where the handle_sve() fallback path
> > reflects an undefined instruction exception back to the guest,
> > consistently with the behaviour of non-SVE-capable hardware (as was
> > done unconditionally prior to this patch).
> >
> > No SVE handling is added on non-VHE-only paths, since VHE is an
> > architectural and Kconfig prerequisite of SVE.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>

[...]

> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 085ed06..9941349 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c

[...]

> > @@ -380,6 +398,26 @@ static bool __hyp_text __hyp_switch_fpsimd(struct =
kvm_vcpu *vcpu)
> >  	return true;
> >  }
> >
> > +static inline bool __hyp_text __hyp_trap_is_fpsimd(struct kvm_vcpu *vc=
pu,
> > +						   bool guest_has_sve)
> > +{
> > +
> > +	u8 trap_class;
> > +
> > +	if (!system_supports_fpsimd())
> > +		return false;
> > +
> > +	trap_class =3D kvm_vcpu_trap_get_class(vcpu);
> > +
> > +	if (trap_class =3D=3D ESR_ELx_EC_FP_ASIMD)
> > +		return true;
> > +
> > +	if_sve (guest_has_sve && trap_class =3D=3D ESR_ELx_EC_SVE)
> > +		return true;
> =

> Do we really need to check the guest has SVE before believing what the
> hardware is telling us? According to the ARM ARM:
> =

> For ESR_ELx_EC_FP_ASIMD
> =

>   Excludes exceptions resulting from CPACR_EL1 when the value of HCR_EL2.=
TGE is
>   1, or because SVE or Advanced SIMD and floating-point are not implement=
ed. These
>   are reported with EC value 0b000000
> =

> But also for ESR_ELx_EC_SVE
> =

>   Access to SVE functionality trapped as a result of CPACR_EL1.ZEN,
>   CPTR_EL2.ZEN, CPTR_EL2.TZ, or CPTR_EL3.EZ, that is not reported using EC
>   0b000000. This EC is defined only if SVE is implemented
> =

> Given I got confused maybe we need a comment for clarity?

This is not about not trusting the value ESR_ELx_EC_SVE on older
hardware: in effect it is retrospectively reserved for this purpose on
all older arch versions, so there is no ambiguity about what it means.
It should never be observed on hardware that doesn't have SVE.

Rather, how we handle this trap differs depending on whether the guest
is SVE-enabled or not.  If not, then this trap is handled by the generic
fallback path for unhandled guest traps, so we don't check for this
particular EC value explicitly in that case.

>   /* Catch guests without SVE enabled running on SVE capable hardware */

I might write something like:

	/*
	 * For sve-enmabled guests only, handle SVE access via FPSIMD
	 * context handling code.
	 */

Does that make sense?  I may have misunderstood your concern here.

[...]

> > @@ -387,6 +425,8 @@ static bool __hyp_text __hyp_switch_fpsimd(struct k=
vm_vcpu *vcpu)
> >   */
> >  static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *ex=
it_code)
> >  {
> > +	bool guest_has_sve;
> > +
> >  	if (ARM_EXCEPTION_CODE(*exit_code) !=3D ARM_EXCEPTION_IRQ)
> >  		vcpu->arch.fault.esr_el2 =3D read_sysreg_el2(esr);
> >
> > @@ -404,10 +444,11 @@ static bool __hyp_text fixup_guest_exit(struct kv=
m_vcpu *vcpu, u64 *exit_code)
> >  	 * and restore the guest context lazily.
> >  	 * If FP/SIMD is not implemented, handle the trap and inject an
> >  	 * undefined instruction exception to the guest.
> > +	 * Similarly for trapped SVE accesses.
> >  	 */
> > -	if (system_supports_fpsimd() &&
> > -	    kvm_vcpu_trap_get_class(vcpu) =3D=3D ESR_ELx_EC_FP_ASIMD)
> > -		return __hyp_switch_fpsimd(vcpu);
> > +	guest_has_sve =3D vcpu_has_sve(vcpu);
> =

> I'm not sure if it's worth fishing this out here given you are already
> passing vcpu down the chain.

I wanted to discourage GCC from recomputing this.  If you're in a
position to do so, can you look at the disassembly with/without this
factored out and see whether it makes a difference?

> =

> > +	if (__hyp_trap_is_fpsimd(vcpu, guest_has_sve))
> > +		return __hyp_switch_fpsimd(vcpu, guest_has_sve);
> >
> >  	if (!__populate_fault_info(vcpu))
> >  		return true;
> =

> Otherwise:
> =

> Reviewed-by: Alex Benn=E9e <alex.bennee@linaro.org>

Thanks
---Dave
