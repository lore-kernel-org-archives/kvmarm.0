From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v6 09/12] KVM: arm64: introduce vcpu->arch.debug_ptr
Date: Thu, 25 Jun 2015 07:32:27 +0100
Message-ID: <87r3p0xpqc.fsf@linaro.org>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org> <1434716630-18260-10-git-send-email-alex.bennee@linaro.org> <20150624114236.GB22785@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150624114236.GB22785@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Andre Przywara <andre.przywara@arm.com>, Richard Weinberger <richard@nod.at>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Fri, Jun 19, 2015 at 01:23:47PM +0100, Alex Benn=C3=A9e wrote:
>> This introduces a level of indirection for the debug registers. Inst=
ead
>> of using the sys_regs[] directly we store registers in a structure i=
n
>> the vcpu. As we are no longer tied to the layout of the sys_regs[] w=
e
>> can make the copies size appropriate for control and value registers=
=2E
>>=20
>> This also entails updating the sys_regs code to access this new
>> structure. Instead of passing a register index we now pass an offset
>> into the kvm_guest_debug_arch structure.
>>=20
>> We also need to ensure the GET/SET_ONE_REG ioctl operations store th=
e
>> registers in their correct location.
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>=20
>> ---
>> v6:
>>   - fix up some ws issues
>>   - correct clobber info
>>   - re-word commentary in kvm_host.h
>>   - fix endian access issues for aarch32 fields
>>   - revert all KVM_GET/SET_ONE_REG to 64bit (also see ABI update)
>> ---
<snip>
>> =20
>> +/* Used when AArch32 kernels trap to mapped debug registers */
>> +static inline bool trap_debug32(struct kvm_vcpu *vcpu,
>> +				const struct sys_reg_params *p,
>> +				const struct sys_reg_desc *rd)
>> +{
>> +	__u32 *r =3D (__u32 *) ((void * )&vcpu->arch.vcpu_debug_state + rd=
->reg);
>
> This still looks like something that's asking for BE trouble.  Why no=
t
> access the register as a __u64 as it is and then only special-case it
> somehow for the XVR thingy...  Perhaps a separate function, see below=
=2E
>
>> +	if (p->is_write) {
>> +		*r =3D *vcpu_reg(vcpu, p->Rt);
>> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>> +	} else {
>> +		*vcpu_reg(vcpu, p->Rt) =3D *r;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static inline bool trap_debug64(struct kvm_vcpu *vcpu,
>> +				const struct sys_reg_params *p,
>> +				const struct sys_reg_desc *rd)
>> +{
>> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd=
->reg);
>> +	if (p->is_write) {
>> +		*r =3D *vcpu_reg(vcpu, p->Rt);
>> +		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>> +	} else {
>> +		*vcpu_reg(vcpu, p->Rt) =3D *r;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +static inline void reset_debug64(struct kvm_vcpu *vcpu, const struc=
t sys_reg_desc *rd)
>> +{
>> +	__u64 *r =3D (__u64 *) ((void * )&vcpu->arch.vcpu_debug_state + rd=
->reg);
>> +	*r =3D rd->val;
>> +}
>> +
>>  static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys=
_reg_desc *r)
>>  {
>>  	u64 amair;
>> @@ -240,16 +277,20 @@ static void reset_mpidr(struct kvm_vcpu *vcpu,=
 const struct sys_reg_desc *r)
>>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>>  	/* DBGBVRn_EL1 */						\
>>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b100),	\
>> -	  trap_debug_regs, reset_val, (DBGBVR0_EL1 + (n)), 0 },		\
>> +	  trap_debug64, reset_debug64,					\
>> +	  offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)]), 0 },	\
>>  	/* DBGBCRn_EL1 */						\
>>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b101),	\
>> -	  trap_debug_regs, reset_val, (DBGBCR0_EL1 + (n)), 0 },		\
>> +	  trap_debug64, reset_debug64,					\
>> +	  offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]), 0},	\
>>  	/* DBGWVRn_EL1 */						\
>>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b110),	\
>> -	  trap_debug_regs, reset_val, (DBGWVR0_EL1 + (n)), 0 },		\
>> +	  trap_debug64, reset_debug64,					\
>> +	  offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)]), 0 },	\
>>  	/* DBGWCRn_EL1 */						\
>>  	{ Op0(0b10), Op1(0b000), CRn(0b0000), CRm((n)), Op2(0b111),	\
>> -	  trap_debug_regs, reset_val, (DBGWCR0_EL1 + (n)), 0 }
>> +	  trap_debug64, reset_debug64,					\
>> +	  offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]), 0}
>> =20
>>  /*
>>   * Architected system registers.
>> @@ -502,42 +543,51 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>>  	}
>>  }
>> =20
>> -static bool trap_debug32(struct kvm_vcpu *vcpu,
>> -			 const struct sys_reg_params *p,
>> -			 const struct sys_reg_desc *r)
>> -{
>> -	if (p->is_write) {
>> -		vcpu_cp14(vcpu, r->reg) =3D *vcpu_reg(vcpu, p->Rt);
>> -		vcpu->arch.debug_flags |=3D KVM_ARM64_DEBUG_DIRTY;
>> -	} else {
>> -		*vcpu_reg(vcpu, p->Rt) =3D vcpu_cp14(vcpu, r->reg);
>> -	}
>> -
>> -	return true;
>> -}
>> +/* AArch32 debug register mappings
>> + *
>> + * AArch32 DBGBVRn is mapped to DBGBVRn_EL1[31:0]
>> + * AArch32 DBGBXVRn is mapped to DBGBVRn_EL1[63:32]
>> + *
>> + * All control registers and watchpoint value registers are mapped =
to
>> + * the lower 32 bits of their AArch64 equivalents.
>> + *
>> + * We also need to ensure we deal with endian differences when
>> + * mapping a partial AArch64 register.
>> + */
>> =20
>> -#define DBG_BCR_BVR_WCR_WVR(n)					\
>> -	/* DBGBVRn */						\
>> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,	\
>> -	  NULL, (cp14_DBGBVR0 + (n) * 2) },			\
>> -	/* DBGBCRn */						\
>> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,	\
>> -	  NULL, (cp14_DBGBCR0 + (n) * 2) },			\
>> -	/* DBGWVRn */						\
>> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,	\
>> -	  NULL, (cp14_DBGWVR0 + (n) * 2) },			\
>> -	/* DBGWCRn */						\
>> -	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,	\
>> -	  NULL, (cp14_DBGWCR0 + (n) * 2) }
>> -
>> -#define DBGBXVR(n)						\
>> -	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_debug32,	\
>> -	  NULL, cp14_DBGBXVR0 + n * 2 }
>> +#ifdef CONFIG_CPU_BIG_ENDIAN
>> +#define DBG_AA32_LOW_OFFSET	sizeof(__u32)
>> +#define DBG_AA32_HIGH_OFFSET	0
>> +#else
>> +#define DBG_AA32_LOW_OFFSET	0
>> +#define DBG_AA32_HIGH_OFFSET	sizeof(__u32)
>> +#endif
>> +
>> +#define DBG_BCR_BVR_WCR_WVR(n)						\
>> +	/* DBGBVRn */							\
>> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_debug32,		\
>> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bvr[(n)])	\
>> +	  + DBG_AA32_LOW_OFFSET },					\
>> +	/* DBGBCRn */							\
>> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_debug32,		\
>> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_bcr[(n)]) },	\
>
> why doesn't this need + DBG_AA32_LOW_OFFSET?

It didn't before as it was a 32bit register, but of course last version
I moved it back to 64 bit and failed to catch that. Thanks!

>
>> +	/* DBGWVRn */							\
>> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_debug32,		\
>> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wvr[(n)])	\
>> +	  + DBG_AA32_LOW_OFFSET },					\
>> +	/* DBGWCRn */							\
>> +	{ Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_debug32,		\
>> +	  NULL, offsetof(struct kvm_guest_debug_arch, dbg_wcr[(n)]) }
>
> ditto ?
>
> I find this quite hard to read and adding this offset on the separate
> line doesn't seem to help.
>
> Perhaps you should just bite the bullet and have separate accessor
> functions for the wvr/wcr/bcr/bvr arrays and just pass the register
> number.

I suspect it would be cleaner reading for the cost of more boilerplate
code. Should I share the access functions between Aarch64/Aarch32 modes
as well?


>
> Thanks,
> -Christoffer

--=20
Alex Benn=C3=A9e
