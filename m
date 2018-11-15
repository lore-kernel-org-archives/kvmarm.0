From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: arm64/sve: System register context
 switch and access support
Date: Thu, 15 Nov 2018 17:59:11 +0000
Message-ID: <20181115175911.GR3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-13-git-send-email-Dave.Martin@arm.com>
 <87efbmcn4o.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C243D4A334
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 12:59:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8cziHK2b-h+K for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 12:59:16 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61C314A324
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 12:59:16 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <87efbmcn4o.fsf@linaro.org>
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

On Thu, Nov 15, 2018 at 04:37:59PM +0000, Alex Benn=E9e wrote:
> =

> Dave Martin <Dave.Martin@arm.com> writes:
> =

> > This patch adds the necessary support for context switching ZCR_EL1
> > for each vcpu.
> >
> > ZCR_EL1 is trapped alongside the FPSIMD/SVE registers, so it makes
> > sense for it to be handled as part of the guest FPSIMD/SVE context
> > for context switch purposes instead of handling it as a general
> > system register.  This means that it can be switched in lazily at
> > the appropriate time.  No effort is made to track host context for
> > this register, since SVE requires VHE: thus the hosts's value for
> > this register lives permanently in ZCR_EL2 and does not alias the
> > guest's value at any time.
> >
> > The Hyp switch and fpsimd context handling code is extended
> > appropriately.
> >
> > Accessors are added in sys_regs.c to expose the SVE system
> > registers and ID register fields.  Because these need to be
> > conditionally visible based on the guest configuration, they are
> > implemented separately for now rather than by use of the generic
> > system register helpers.  This may be abstracted better later on
> > when/if there are more features requiring this model.
> >
> > ID_AA64ZFR0_EL1 is RO-RAZ for MRS/MSR when SVE is disabled for the
> > guest, but for compatibility with non-SVE aware KVM implementations
> > the register should not be enumerated at all for KVM_GET_REG_LIST
> > in this case.  For consistency we also reject ioctl access to the
> > register.  This ensures that a non-SVE-enabled guest looks the same
> > to userspace, irrespective of whether the kernel KVM implementation
> > supports SVE.
> >
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >
> > Changes since RFCv1:
> >
> >  * The conditional visibility logic in sys_regs.c has been
> >    simplified.
> >
> >  * The guest's ZCR_EL1 is now treated as part of the FPSIMD/SVE state
> >    for switching purposes.  Any access to this register before it is
> >    switched in generates an SVE trap, so we have a change to switch it
> >    along with the vector registers.
> >
> >    Because SVE is only available with VHE there is no need ever to
> >    restore the host's version of this register (which instead lives
> >    permanently in ZCR_EL2).
> > ---
> >  arch/arm64/include/asm/kvm_host.h |   1 +
> >  arch/arm64/include/asm/sysreg.h   |   3 ++
> >  arch/arm64/kvm/fpsimd.c           |   9 +++-
> >  arch/arm64/kvm/hyp/switch.c       |   4 ++
> >  arch/arm64/kvm/sys_regs.c         | 111 ++++++++++++++++++++++++++++++=
++++++--
> >  5 files changed, 123 insertions(+), 5 deletions(-)

[...]

> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 55654cb..29e5585 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -102,6 +102,9 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
> >  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long flags;
> > +	bool host_has_sve =3D system_supports_sve();
> > +	bool guest_has_sve =3D
> > +		host_has_sve && (vcpu->arch.flags &
> > KVM_ARM64_FP_ENABLED);
> =

> erm... didn't you create a KVM_ARM64_GUEST_HAS_SVE and vcpu_has_sve() for=
 this?

Hmmm, I think this should indeed say KVM_ARM64_GUEST_HAS_SVE.
(Otherwise it would be redundant with the if() conditions that follow.)

I'll use vcpu_has_sve() if possible.  There may have been some reason
why I didn't use it here, but I'd need to go over the code again.

> >
> >  	local_irq_save(flags);
> >
> > @@ -109,7 +112,11 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> >  		/* Clean guest FP state to memory and invalidate cpu view */
> >  		fpsimd_save();
> >  		fpsimd_flush_cpu_state();
> > -	} else if (system_supports_sve()) {
> > +
> > +		if (guest_has_sve)
> > +			vcpu->arch.ctxt.sys_regs[ZCR_EL1] =3D
> > +				read_sysreg_s(SYS_ZCR_EL12);
> > +	} else if (host_has_sve) {
> >  		/*
> >  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> >  		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been

[...]

> > @@ -1270,7 +1366,11 @@ static const struct sys_reg_desc sys_reg_descs[]=
 =3D {
> >  	ID_SANITISED(ID_AA64PFR1_EL1),
> >  	ID_UNALLOCATED(4,2),
> >  	ID_UNALLOCATED(4,3),
> > +#ifdef CONFIG_ARM64_SVE
> > +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user =
=3D get_id_aa64zfr0_el1, .set_user =3D set_id_aa64zfr0_el1, .check_present =
=3D sve_check_present },
> > +#else
> >  	ID_UNALLOCATED(4,4),
> > +#endif
> >  	ID_UNALLOCATED(4,5),
> >  	ID_UNALLOCATED(4,6),
> >  	ID_UNALLOCATED(4,7),
> > @@ -1307,6 +1407,9 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >
> >  	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C=
50078 },
> >  	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> > +#ifdef CONFIG_ARM64_SVE
> > +	{ SYS_DESC(SYS_ZCR_EL1), access_zcr_el1, reset_unknown, ZCR_EL1, ~0xf=
UL, .get_user =3D get_zcr_el1, .set_user =3D set_zcr_el1, .check_present =
=3D sve_check_present },
> > +#endif
> >  	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
> >  	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
> >  	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
> =

> Overlong lines.

Fair point, but I'll defer to the maintainers on this.  sys_regs.c
already has overlong lines to some extent (for a suitable definition of
"overlong") but there seems to be a preference of keeping to one entry
per line in these tables.

I'm happy to wrap these or not, as people prefer.

Cheers
---Dave
