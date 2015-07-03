From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v7 08/11] KVM: arm64: introduce vcpu->arch.debug_ptr
Date: Fri, 3 Jul 2015 23:46:47 +0200
Message-ID: <20150703214647.GD10878@cbox>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
 <1435775343-20034-9-git-send-email-alex.bennee@linaro.org>
 <20150702183440.GK11332@cbox>
 <87mvzdsoer.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvzdsoer.fsf@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Richard Weinberger <richard@nod.at>, Andre Przywara <andre.przywara@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 03, 2015 at 08:14:52AM +0100, Alex Benn=E9e wrote:
>=20
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>=20
> > On Wed, Jul 01, 2015 at 07:29:00PM +0100, Alex Benn=E9e wrote:
> >> This introduces a level of indirection for the debug registers. In=
stead
> >> of using the sys_regs[] directly we store registers in a structure=
 in
> >> the vcpu. The new kvm_arm_reset_debug_ptr() sets the debug ptr to =
the
> >> guest context.
> >>=20
> >> This also entails updating the sys_regs code to access this new
> >> structure. New access function have been added for each set of deb=
ug
> >> registers. The generic functions are still used for the few regist=
ers
> >> stored in the main context.
> >>=20
> >> New access function pointers have been added to the sys_reg_desc
> >> structure to support the GET/SET_ONE_REG ioctl operations.
> >
> > Why is this needed?
>=20
> Previously I had a hacky:
>=20
> 	if (r->access =3D=3D trap_debug64)
> 		return debug_get64(vcpu, r, reg, uaddr);
>=20
> Which used the same offset information. Now we have a cleaner:
>=20
> 	if (r->set)
> 		return (r->set)(vcpu, r, reg, uaddr);
>=20
> Which accesses the structure directly, as the trap functions do:
>=20
> 	__u64 *r =3D &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
> 	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> 		return -EFAULT;
> 	return 0;

I get it now, had to take another look at sys_regs.c.

I think this commit message needs a littel tweaking saying "Because we
no longer give the sys_regs offset for the sys_reg_desc->reg field, but
instead the index into a debug-specific struct, the generic user-space
access code no longer works, and we are therefore forced to add specifi=
c
user_set/get functions for these registers."

At least it was hard for me to understand the rationale without this,
and I think it would be good to have for someone doing git blame later.

>=20
> <snip>
> >> +#if 0
> >> +static int debug_set64(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *rd,
> >> +		const struct kvm_one_reg *reg, void __user *uaddr)
> >> +{
> >> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + =
rd->reg);
> >> +	if (copy_from_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> >> +		return -EFAULT;
> >> +	return 0;
> >> +}
> >> +
> >> +static int debug_get64(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *rd,
> >> +	const struct kvm_one_reg *reg, void __user *uaddr)
> >> +{
> >> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + =
rd->reg);
> >> +	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) !=3D 0)
> >> +		return -EFAULT;
> >> +	return 0;
> >> +}
> >> +#endif
> >> +
> >
> > what is this ifdef'ed block of code doing here?
>=20
> Oops. Yeah looks like I missed removing that after I finished the
> re-factor. These where the old get/set functions I used.
>=20
> >
> >>  int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct k=
vm_one_reg *reg)
> >>  {
> >>  	const struct sys_reg_desc *r;
> >> @@ -1303,6 +1530,9 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu =
*vcpu, const struct kvm_one_reg *reg
> >>  	if (!r)
> >>  		return get_invariant_sys_reg(reg->id, uaddr);
> >> =20
> >> +	if (r->get)
> >> +		return (r->get)(vcpu, r, reg, uaddr);
> >> +
> >>  	return reg_to_user(uaddr, &vcpu_sys_reg(vcpu, r->reg), reg->id);
> >>  }
> >> =20
> >> @@ -1321,6 +1551,9 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu =
*vcpu, const struct kvm_one_reg *reg
> >>  	if (!r)
> >>  		return set_invariant_sys_reg(reg->id, uaddr);
> >> =20
> >> +	if (r->set)
> >> +		return (r->set)(vcpu, r, reg, uaddr);
> >> +
> >>  	return reg_from_user(&vcpu_sys_reg(vcpu, r->reg), uaddr, reg->id=
);
> >>  }
> >> =20
> >> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> >> index d411e25..9265e7d 100644
> >> --- a/arch/arm64/kvm/sys_regs.h
> >> +++ b/arch/arm64/kvm/sys_regs.h
> >> @@ -55,6 +55,12 @@ struct sys_reg_desc {
> >> =20
> >>  	/* Value (usually reset value) */
> >>  	u64 val;
> >> +
> >> +	/* Get/Set functions, fallback if NULL */
> >
> > Is this only meant for usersapce access or when should one use thes=
e?
>=20
> Yes for GET/SET
>=20
ok, see other mail for potential rename to get_user / set_user if you
like the idea.

Thanks,
-Christoffer
