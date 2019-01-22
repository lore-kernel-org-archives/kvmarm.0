From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v4 13/25] KVM: arm64/sve: System register context switch
 and access support
Date: Tue, 22 Jan 2019 16:27:53 +0000
Message-ID: <20190122162752.GI3578@e103592.cambridge.arm.com>
References: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
 <1547757219-19439-14-git-send-email-Dave.Martin@arm.com>
 <3d6da606-d7ae-5232-8317-4c550370b469@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8667E4A3A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 11:27:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jtLRQXSLF+Mu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jan 2019 11:27:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 209814A397
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jan 2019 11:27:58 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <3d6da606-d7ae-5232-8317-4c550370b469@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 18, 2019 at 04:42:07PM +0000, Marc Zyngier wrote:
> On 17/01/2019 20:33, Dave Martin wrote:
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

[...]

> > diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> > index 1cf4f02..5ff2d90 100644
> > --- a/arch/arm64/kvm/fpsimd.c
> > +++ b/arch/arm64/kvm/fpsimd.c
> > @@ -103,6 +103,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
> >  void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> >  {
> >  	unsigned long flags;
> > +	bool host_has_sve = system_supports_sve();
> > +	bool guest_has_sve = vcpu_has_sve(vcpu);
> >  
> >  	local_irq_save(flags);
> >  
> > @@ -110,7 +112,11 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
> >  		/* Clean guest FP state to memory and invalidate cpu view */
> >  		fpsimd_save();
> >  		fpsimd_flush_cpu_state();
> > -	} else if (system_supports_sve()) {
> > +
> > +		if (guest_has_sve)
> > +			vcpu->arch.ctxt.sys_regs[ZCR_EL1] =
> > +				read_sysreg_s(SYS_ZCR_EL12);
> 
> nit: Please keep assignments on a single line.

My antipathy for long lines got the better of me here.

If I can come up with a non-ridiculous way of shortening this line I'll
do that, otherwise I'm can join these lines and live with it.

> 
> > +	} else if (host_has_sve) {
> >  		/*
> >  		 * The FPSIMD/SVE state in the CPU has not been touched, and we
> >  		 * have SVE (and VHE): CPACR_EL1 (alias CPTR_EL2) has been

[...]

> >  /*
> >   * cpufeature ID register user accessors
> >   *
> > @@ -1278,7 +1374,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> >  	ID_SANITISED(ID_AA64PFR1_EL1),
> >  	ID_UNALLOCATED(4,2),
> >  	ID_UNALLOCATED(4,3),
> > +#ifdef CONFIG_ARM64_SVE
> > +	{ SYS_DESC(SYS_ID_AA64ZFR0_EL1), access_id_aa64zfr0_el1, .get_user = get_id_aa64zfr0_el1, .set_user = set_id_aa64zfr0_el1, .check_present = sve_check_present },
> > +#else
> >  	ID_UNALLOCATED(4,4),
> > +#endif
> 
> Can't we always have this code present and fallback to the "unallocated"
> behaviour at runtime?

This may actually be preferable, since "check_present()" sounds like it
ought to be used to check whether the register is present for all
purposes, whereas right now it's only called to check whether to
enumerate the register in KVM_GET_REG_LIST.  This behaviour may confuse
us later on...

There may have been some difficulty with this, but if so I can't
remember what.  I'll take a look.

[...]

Cheers
---Dave
