From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 09/12] KVM: arm64: introduce vcpu->arch.debug_ptr
Date: Thu, 25 Jun 2015 09:46:16 +0200
Message-ID: <20150625074616.GA28244@cbox>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
 <1434716630-18260-10-git-send-email-alex.bennee@linaro.org>
 <20150624114236.GB22785@cbox> <87r3p0xpqc.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4952456F6B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 03:35:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HN-d070GxceZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2015 03:35:19 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D835E56F6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 03:35:18 -0400 (EDT)
Received: by lbbpo10 with SMTP id po10so40173425lbb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2015 00:46:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <87r3p0xpqc.fsf@linaro.org>
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
Cc: kvm@vger.kernel.org, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>, Gleb Natapov <gleb@kernel.org>, zhichao.huang@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, bp@suse.de, marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, r65777@freescale.com, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 25, 2015 at 07:32:27AM +0100, Alex Benn=E9e wrote:
> =

> Christoffer Dall <christoffer.dall@linaro.org> writes:
> =

> > On Fri, Jun 19, 2015 at 01:23:47PM +0100, Alex Benn=E9e wrote:
> >> This introduces a level of indirection for the debug registers. Instead
> >> of using the sys_regs[] directly we store registers in a structure in
> >> the vcpu. As we are no longer tied to the layout of the sys_regs[] we
> >> can make the copies size appropriate for control and value registers.
> >> =

> >> This also entails updating the sys_regs code to access this new
> >> structure. Instead of passing a register index we now pass an offset
> >> into the kvm_guest_debug_arch structure.
> >> =

> >> We also need to ensure the GET/SET_ONE_REG ioctl operations store the
> >> registers in their correct location.
> >> =

> >> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> >> =

> >> ---
> >> v6:
> >>   - fix up some ws issues
> >>   - correct clobber info
> >>   - re-word commentary in kvm_host.h
> >>   - fix endian access issues for aarch32 fields
> >>   - revert all KVM_GET/SET_ONE_REG to 64bit (also see ABI update)
> >> ---
> <snip>
> >>  =

> >> +/* Used when AArch32 kernels trap to mapped debug registers */
> >> +static inline bool trap_debug32(struct kvm_vcpu *vcpu,
> >> +				const struct sys_reg_params *p,
> >> +				const struct sys_reg_desc *rd)
> >> +{
> >> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->=
reg);
> >
> > This still looks like something that's asking for BE trouble.  Why not
> > access the register as a __u64 as it is and then only special-case it
> > somehow for the XVR thingy...  Perhaps a separate function, see below.
> >
> >> +	if (p->is_write) {
> >> +		*r =3D *vcpu_reg(vcpu, p->Rt);
> >> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> >> +	} else {
> >> +		*vcpu_reg(vcpu, p->Rt) =3D *r;
> >> +	}
> >> +
> >> +	return true;
> >> +}
> >> +
> >> +static inline bool trap_debug64(struct kvm_vcpu *vcpu,
> >> +				const struct sys_reg_params *p,
> >> +				const struct sys_reg_desc *rd)
> >> +{
> >> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->=
reg);
> >> +	if (p->is_write) {
> >> +		*r =3D *vcpu_reg(vcpu, p->Rt);
> >> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> >> +	} else {
> >> +		*vcpu_reg(vcpu, p->Rt) =3D *r;
> >> +	}
> >> +
> >> +	return true;
> >> +}
> >> +
> >> +static inline void reset_debug64(struct kvm_vcpu *vcpu, const struct =
sys_reg_desc *rd)
> >> +{
> >> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd->=
reg);
> >> +	*r =3D rd->val;
> >> +}
> >> +
> >>  static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_r=
eg_desc *r)
> >>  {
> >>  	u64 amair;
> >> @@ -240,16 +277,20 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, c=
onst struct sys_reg_desc *r)
> >>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
> >>  	/* DBGBVRn_EL1 */						\
> >>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b100),	\
> >> -	  trap_debug_regs, reset_val, (DBGBVR0_EL1 + (n)), 0 },		\
> >> +	  trap_debug64, reset_debug64,					\
> >> +	  offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)]), 0 },	\
> >>  	/* DBGBCRn_EL1 */						\
> >>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b101),	\
> >> -	  trap_debug_regs, reset_val, (DBGBCR0_EL1 + (n)), 0 },		\
> >> +	  trap_debug64, reset_debug64,					\
> >> +	  offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]), 0},	\
> >>  	/* DBGWVRn_EL1 */						\
> >>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b110),	\
> >> -	  trap_debug_regs, reset_val, (DBGWVR0_EL1 + (n)), 0 },		\
> >> +	  trap_debug64, reset_debug64,					\
> >> +	  offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)]), 0 },	\
> >>  	/* DBGWCRn_EL1 */						\
> >>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
> >> -	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
> >> +	  trap_debug64, reset_debug64,					\
> >> +	  offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]), 0}
> >>  =

> >>  /*
> >>   * Architected system registers.
> >> @@ -502,42 +543,51 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
> >>  	}
> >>  }
> >>  =

> >> -static bool trap_debug32(struct kvm_vcpu *vcpu,
> >> -			 const struct sys_reg_params *p,
> >> -			 const struct sys_reg_desc *r)
> >> -{
> >> -	if (p->is_write) {
> >> -		vcpu_cp14(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
> >> -		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
> >> -	} else {
> >> -		*vcpu_reg(vcpu, p->Rt) =3D vcpu_cp14(vcpu, r->reg);
> >> -	}
> >> -
> >> -	return true;
> >> -}
> >> +/* AArch32 debug register mappings
> >> + *
> >> + * AArch32 DBGBVRn is mapped to DBGBVRn_EL1[31:0]
> >> + * AArch32 DBGBXVRn is mapped to DBGBVRn_EL1[63:32]
> >> + *
> >> + * All control registers and watchpoint value registers are mapped to
> >> + * the lower 32 bits of their AArch64 equivalents.
> >> + *
> >> + * We also need to ensure we deal with endian differences when
> >> + * mapping a partial AArch64 register.
> >> + */
> >>  =

> >> -#define DBG_BCR_BVR_WCR_WVR(n)					\
> >> -	/* DBGBVRn */						\
> >> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,	\
> >> -	  NULL, (cp14_DBGBVR0 + (n) * 2) },			\
> >> -	/* DBGBCRn */						\
> >> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,	\
> >> -	  NULL, (cp14_DBGBCR0 + (n) * 2) },			\
> >> -	/* DBGWVRn */						\
> >> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,	\
> >> -	  NULL, (cp14_DBGWVR0 + (n) * 2) },			\
> >> -	/* DBGWCRn */						\
> >> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,	\
> >> -	  NULL, (cp14_DBGWCR0 + (n) * 2) }
> >> -
> >> -#define DBGBXVR(n)						\
> >> -	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_debug32,	\
> >> -	  NULL, cp14_DBGBXVR0 + n * 2 }
> >> +#ifdef CONFIG_CPU_BIG_ENDIAN
> >> +#define DBG_AA32_LOW_OFFSET	sizeof(__u32)
> >> +#define DBG_AA32_HIGH_OFFSET	0
> >> +#else
> >> +#define DBG_AA32_LOW_OFFSET	0
> >> +#define DBG_AA32_HIGH_OFFSET	sizeof(__u32)
> >> +#endif
> >> +
> >> +#define DBG_BCR_BVR_WCR_WVR(n)						\
> >> +	/* DBGBVRn */							\
> >> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,		\
> >> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)])	\
> >> +	  + DBG_AA32_LOW_OFFSET },					\
> >> +	/* DBGBCRn */							\
> >> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,		\
> >> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]) },	\
> >
> > why doesn't this need + DBG_AA32_LOW_OFFSET?
> =

> It didn't before as it was a 32bit register, but of course last version
> I moved it back to 64 bit and failed to catch that. Thanks!
> =

> >
> >> +	/* DBGWVRn */							\
> >> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,		\
> >> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)])	\
> >> +	  + DBG_AA32_LOW_OFFSET },					\
> >> +	/* DBGWCRn */							\
> >> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,		\
> >> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]) }
> >
> > ditto ?
> >
> > I find this quite hard to read and adding this offset on the separate
> > line doesn't seem to help.
> >
> > Perhaps you should just bite the bullet and have separate accessor
> > functions for the wvr/wcr/bcr/bvr arrays and just pass the register
> > number.
> =

> I suspect it would be cleaner reading for the cost of more boilerplate
> code. Should I share the access functions between Aarch64/Aarch32 modes
> as well?
> =

Not sure I understand the question.

My concern with this code is that a lot of logic happens in these array
initialization macro lines, and you have to follow through the type of
the struct and go look in a different place in the file to understand
how this is really used.  So yes, better to add a bit more boilerplate
code but have it be clear how things work and keep the BE stuff in the
function.

You will see when you write it up, but you may be able to do something
like:

static bool trap_debug32(...)
{
}

static bool trap_dbg_wvr(...)
{
	... do special stuff ...
	trap_debug32(with_special_stuff);
}

but not sure if there's a benefit or not, at least that way the related
functionality will be more closely associated, but again, you'll see
when you write it up.

-Christoffer

-Christoffer
