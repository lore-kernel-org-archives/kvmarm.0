From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 02/28] arm64: KVM: Hide unsupported AArch64 CPU
 features from guests
Date: Wed, 18 Oct 2017 15:20:26 +0200
Message-ID: <20171018132026.GE8900@cbox>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-3-git-send-email-Dave.Martin@arm.com>
 <20171017135145.GT1845@lvm>
 <d7b9fac4-1a71-d7be-822a-1898f133aa70@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-86015-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <d7b9fac4-1a71-d7be-822a-1898f133aa70@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 03:08:40PM +0100, Marc Zyngier wrote:
> On 17/10/17 14:51, Christoffer Dall wrote:
> > On Tue, Oct 10, 2017 at 07:38:19PM +0100, Dave Martin wrote:
> >> Currently, a guest kernel sees the true CPU feature registers
> >> (ID_*_EL1) when it reads them using MRS instructions.  This means
> >> that the guest will observe features that are present in the
> >> hardware but the host doesn't understand or doesn't provide support
> >> for.  A guest may legimitately try to use such a feature as per the
> >> architecture, but use of the feature may trap instead of working
> >> normally, triggering undef injection into the guest.
> >>
> >> This is not a problem for the host, but the guest may go wrong when
> >> running on newer hardware than the host knows about.
> >>
> >> This patch hides from guest VMs any AArch64-specific CPU features
> >> that the host doesn't support, by exposing to the guest the
> >> sanitised versions of the registers computed by the cpufeatures
> >> framework, instead of the true hardware registers.  To achieve
> >> this, HCR_EL2.TID3 is now set for AArch64 guests, and emulation
> >> code is added to KVM to report the sanitised versions of the
> >> affected registers in response to MRS and register reads from
> >> userspace.
> >>
> >> The affected registers are removed from invariant_sys_regs[] (since
> >> the invariant_sys_regs handling is no longer quite correct for
> >> them) and added to sys_reg_desgs[], with appropriate access(),
> >> get_user() and set_user() methods.  No runtime vcpu storage is
> >> allocated for the registers: instead, they are read on demand from
> >> the cpufeatures framework.  This may need modification in the
> >> future if there is a need for userspace to customise the features
> >> visible to the guest.
> >>
> >> Attempts by userspace to write the registers are handled similarly
> >> to the current invariant_sys_regs handling: writes are permitted,
> >> but only if they don't attempt to change the value.  This is
> >> sufficient to support VM snapshot/restore from userspace.
> >>
> >> Because of the additional registers, restoring a VM on an older
> >> kernel may not work unless userspace knows how to handle the extra
> >> VM registers exposed to the KVM user ABI by this patch.
> >>
> >> Under the principle of least damage, this patch makes no attempt to
> >> handle any of the other registers currently in
> >> invariant_sys_regs[], or to emulate registers for AArch32: however,
> >> these could be handled in a similar way in future, as necessary.
> >>
> >> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm64/include/asm/sysreg.h |   3 +
> >>  arch/arm64/kvm/hyp/switch.c     |   6 +
> >>  arch/arm64/kvm/sys_regs.c       | 282 +++++++++++++++++++++++++++++++++-------
> >>  3 files changed, 246 insertions(+), 45 deletions(-)
> >>
> >> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> >> index f707fed..480ecd6 100644
> >> --- a/arch/arm64/include/asm/sysreg.h
> >> +++ b/arch/arm64/include/asm/sysreg.h
> >> @@ -149,6 +149,9 @@
> >>  #define SYS_ID_AA64DFR0_EL1		sys_reg(3, 0, 0, 5, 0)
> >>  #define SYS_ID_AA64DFR1_EL1		sys_reg(3, 0, 0, 5, 1)
> >>  
> >> +#define SYS_ID_AA64AFR0_EL1		sys_reg(3, 0, 0, 5, 4)
> >> +#define SYS_ID_AA64AFR1_EL1		sys_reg(3, 0, 0, 5, 5)
> >> +
> >>  #define SYS_ID_AA64ISAR0_EL1		sys_reg(3, 0, 0, 6, 0)
> >>  #define SYS_ID_AA64ISAR1_EL1		sys_reg(3, 0, 0, 6, 1)
> >>  
> >> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >> index 945e79c..35a90b8 100644
> >> --- a/arch/arm64/kvm/hyp/switch.c
> >> +++ b/arch/arm64/kvm/hyp/switch.c
> >> @@ -81,11 +81,17 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >>  	 * it will cause an exception.
> >>  	 */
> >>  	val = vcpu->arch.hcr_el2;
> >> +
> >>  	if (!(val & HCR_RW) && system_supports_fpsimd()) {
> >>  		write_sysreg(1 << 30, fpexc32_el2);
> >>  		isb();
> >>  	}
> >> +
> >> +	if (val & HCR_RW) /* for AArch64 only: */
> >> +		val |= HCR_TID3; /* TID3: trap feature register accesses */
> >> +
> > 
> > Since we're setting this for all 64-bit VMs, can we not set this in
> > vcpu_reset_hcr instead?
> > 
> >>  	write_sysreg(val, hcr_el2);
> >> +
> >>  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
> >>  	write_sysreg(1 << 15, hstr_el2);
> >>  	/*
> >> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >> index 2e070d3..b1f7552 100644
> >> --- a/arch/arm64/kvm/sys_regs.c
> >> +++ b/arch/arm64/kvm/sys_regs.c
> >> @@ -892,6 +892,137 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
> >>  	return true;
> >>  }
> >>  
> >> +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> >> +static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> >> +{
> >> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> >> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> >> +
> >> +	return raz ? 0 : read_sanitised_ftr_reg(id);
> >> +}
> >> +
> >> +/* cpufeature ID register access trap handlers */
> >> +
> >> +static bool __access_id_reg(struct kvm_vcpu *vcpu,
> >> +			    struct sys_reg_params *p,
> >> +			    const struct sys_reg_desc *r,
> >> +			    bool raz)
> >> +{
> >> +	if (p->is_write)
> >> +		return write_to_read_only(vcpu, p, r);
> >> +
> >> +	p->regval = read_id_reg(r, raz);
> >> +	return true;
> >> +}
> >> +
> >> +static bool access_id_reg(struct kvm_vcpu *vcpu,
> >> +			  struct sys_reg_params *p,
> >> +			  const struct sys_reg_desc *r)
> >> +{
> >> +	return __access_id_reg(vcpu, p, r, false);
> >> +}
> >> +
> >> +static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> >> +			      struct sys_reg_params *p,
> >> +			      const struct sys_reg_desc *r)
> >> +{
> >> +	return __access_id_reg(vcpu, p, r, true);
> >> +}
> >> +
> >> +static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
> >> +static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
> >> +static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> >> +
> >> +/*
> >> + * cpufeature ID register user accessors
> >> + *
> >> + * For now, these registers are immutable for userspace, so no values
> >> + * are stored, and for set_id_reg() we don't allow the effective value
> >> + * to be changed.
> >> + */
> >> +static int __get_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> >> +			bool raz)
> >> +{
> >> +	const u64 id = sys_reg_to_index(rd);
> >> +	const u64 val = read_id_reg(rd, raz);
> >> +
> >> +	return reg_to_user(uaddr, &val, id);
> >> +}
> >> +
> >> +static int __set_id_reg(const struct sys_reg_desc *rd, void __user *uaddr,
> >> +			bool raz)
> >> +{
> >> +	const u64 id = sys_reg_to_index(rd);
> >> +	int err;
> >> +	u64 val;
> >> +
> >> +	err = reg_from_user(&val, uaddr, id);
> >> +	if (err)
> >> +		return err;
> >> +
> >> +	/* This is what we mean by invariant: you can't change it. */
> >> +	if (val != read_id_reg(rd, raz))
> >> +		return -EINVAL;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >> +		      const struct kvm_one_reg *reg, void __user *uaddr)
> >> +{
> >> +	return __get_id_reg(rd, uaddr, false);
> >> +}
> >> +
> >> +static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >> +		      const struct kvm_one_reg *reg, void __user *uaddr)
> >> +{
> >> +	return __set_id_reg(rd, uaddr, false);
> >> +}
> >> +
> >> +static int get_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >> +			  const struct kvm_one_reg *reg, void __user *uaddr)
> >> +{
> >> +	return __get_id_reg(rd, uaddr, true);
> >> +}
> >> +
> >> +static int set_raz_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >> +			  const struct kvm_one_reg *reg, void __user *uaddr)
> >> +{
> >> +	return __set_id_reg(rd, uaddr, true);
> >> +}
> >> +
> >> +/* sys_reg_desc initialiser for known cpufeature ID registers */
> >> +#define ID_SANITISED(name) {			\
> >> +	SYS_DESC(SYS_##name),			\
> >> +	.access	= access_id_reg,		\
> >> +	.get_user = get_id_reg,			\
> >> +	.set_user = set_id_reg,			\
> >> +}
> >> +
> >> +/*
> >> + * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
> >> + * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
> >> + * (1 <= crm < 8, 0 <= Op2 < 8).
> >> + */
> >> +#define ID_UNALLOCATED(crm, op2) {			\
> >> +	Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),	\
> >> +	.access = access_raz_id_reg,			\
> >> +	.get_user = get_raz_id_reg,			\
> >> +	.set_user = set_raz_id_reg,			\
> >> +}
> >> +
> >> +/*
> >> + * sys_reg_desc initialiser for known ID registers that we hide from guests.
> >> + * For now, these are exposed just like unallocated ID regs: they appear
> >> + * RAZ for the guest.
> >> + */
> > 
> > What is a hidden ID register as opposed to an unallocated one?
> 
> A hidden register is one where all the features have been removed (RAZ),
> making it similar to an unallocated one.
> 
> > Shouldn't one of them presumably cause an undefined exception in the
> > guest?
> 
> No, that'd be a violation of the architecture. The unallocated ID
> registers are required to be RAZ (see table D9-2 in D9.3.1), so that
> software can probe for feature without running the risk of getting an UNDEF.
> 
Then I'm not really sure why we need the two defines.  Is that just to
make it clear what the different rationales for dealing with various
registers in the same way are?

Thanks,
-Christoffer
