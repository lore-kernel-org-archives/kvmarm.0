From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: Add save/restore support for
 firmware workaround state
Date: Mon, 21 Jan 2019 17:04:05 +0000
Message-ID: <20190121170405.476b329d@donnerap.cambridge.arm.com>
References: <20190107120537.184252-1-andre.przywara@arm.com>
 <20190107120537.184252-2-andre.przywara@arm.com>
 <2b794331-cebe-92f1-7adc-58b041bbe1d6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6864F4A3A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:04:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wkkB351lbtsb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jan 2019 12:04:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 563914A387
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jan 2019 12:04:14 -0500 (EST)
In-Reply-To: <2b794331-cebe-92f1-7adc-58b041bbe1d6@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 7 Jan 2019 13:17:37 +0000
Steven Price <steven.price@arm.com> wrote:

Hi,

> On 07/01/2019 12:05, Andre Przywara wrote:
> > KVM implements the firmware interface for mitigating cache
> > speculation vulnerabilities. Guests may use this interface to
> > ensure mitigation is active.
> > If we want to migrate such a guest to a host with a different
> > support level for those workarounds, migration might need to fail,
> > to ensure that critical guests don't loose their protection.
> > 
> > Introduce a way for userland to save and restore the workarounds
> > state. On restoring we do checks that make sure we don't downgrade
> > our mitigation level.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_emulate.h   |  10 ++
> >  arch/arm/include/uapi/asm/kvm.h      |   9 ++
> >  arch/arm64/include/asm/kvm_emulate.h |  14 +++
> >  arch/arm64/include/uapi/asm/kvm.h    |   9 ++
> >  virt/kvm/arm/psci.c                  | 138
> > ++++++++++++++++++++++++++- 5 files changed, 178 insertions(+), 2
> > deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_emulate.h
> > b/arch/arm/include/asm/kvm_emulate.h index
> > 77121b713bef..2255c50debab 100644 ---
> > a/arch/arm/include/asm/kvm_emulate.h +++
> > b/arch/arm/include/asm/kvm_emulate.h @@ -275,6 +275,16 @@ static
> > inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> > return vcpu_cp15(vcpu, c0_MPIDR) & MPIDR_HWID_BITMASK; }
> >  
> > +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct
> > kvm_vcpu *vcpu) +{
> > +	return false;
> > +}
> > +
> > +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct
> > kvm_vcpu *vcpu,
> > +						      bool flag)
> > +{
> > +}
> > +
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> >  	*vcpu_cpsr(vcpu) |= PSR_E_BIT;
> > diff --git a/arch/arm/include/uapi/asm/kvm.h
> > b/arch/arm/include/uapi/asm/kvm.h index 4602464ebdfb..02c93b1d8f6d
> > 100644 --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -214,6 +214,15 @@ struct kvm_vcpu_events {
> >  #define KVM_REG_ARM_FW_REG(r)		(KVM_REG_ARM |
> > KVM_REG_SIZE_U64 | \ KVM_REG_ARM_FW | ((r) & 0xffff))
> >  #define KVM_REG_ARM_PSCI_VERSION	KVM_REG_ARM_FW_REG(0)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1
> > KVM_REG_ARM_FW_REG(1) +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0 +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1 +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK	0x3
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	4 
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h
> > b/arch/arm64/include/asm/kvm_emulate.h index
> > 506386a3edde..a44f07f68da4 100644 ---
> > a/arch/arm64/include/asm/kvm_emulate.h +++
> > b/arch/arm64/include/asm/kvm_emulate.h @@ -336,6 +336,20 @@ static
> > inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> > return vcpu_read_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK; }
> >  
> > +static inline bool kvm_arm_get_vcpu_workaround_2_flag(struct
> > kvm_vcpu *vcpu) +{
> > +	return vcpu->arch.workaround_flags &
> > VCPU_WORKAROUND_2_FLAG; +}
> > +
> > +static inline void kvm_arm_set_vcpu_workaround_2_flag(struct
> > kvm_vcpu *vcpu,
> > +						      bool flag)
> > +{
> > +	if (flag)
> > +		vcpu->arch.workaround_flags |=
> > VCPU_WORKAROUND_2_FLAG;
> > +	else
> > +		vcpu->arch.workaround_flags &=
> > ~VCPU_WORKAROUND_2_FLAG; +}
> > +
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> >  	if (vcpu_mode_is_32bit(vcpu)) {
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h
> > b/arch/arm64/include/uapi/asm/kvm.h index
> > 97c3478ee6e7..4a19ef199a99 100644 ---
> > a/arch/arm64/include/uapi/asm/kvm.h +++
> > b/arch/arm64/include/uapi/asm/kvm.h @@ -225,6 +225,15 @@ struct
> > kvm_vcpu_events { #define KVM_REG_ARM_FW_REG(r)
> > (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \ KVM_REG_ARM_FW | ((r) &
> > 0xffff)) #define KVM_REG_ARM_PSCI_VERSION
> > KVM_REG_ARM_FW_REG(0) +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1	KVM_REG_ARM_FW_REG(1)
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL	0
> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL	1  
> 
> I can't help feeling we need more than one bit to deal with all the
> possible states. The host can support/not-support the workaround (i.e
> the HVC) and the guest can be using/not using the workaround.

I don't think we care in the moment about the guest using it or not,
the current implementation is binary: Either the host offers the
workaround or not. We just pass this on to a KVM guest.

But it seems the workaround is *architected* to give three choices:
1) SMC call not implemented, meaning *either* not needed or just not
  implemented (old firmware).
2) SMC call implemented and required on that CPU.
3) SMC call implemented, but *not* required on that CPU.

Now it seems at least on the host side we leave something on the table,
as we neither consider the per-CPU nature of this workaround nor case
3, in which case we do the SMC call needlessly.
This should be fixed, I guess, but as a separate issue.

> In particular I can imagine the following situation:
> 
> * Guest starts on a host (host A) without the workaround HVC (so
> configures not to use it). Assuming the host doesn't need the
> workaround the guest is therefore not vulnerable.

But we don't know this. Not implemented could also (more likely,
actually) mean: workaround not supported, thus vulnerable (old
firmware/kernel).

> * Migrated to a new host (host B) with the workaround HVC (this is
> accepted), the guest is potentially vulnerable.

... as it was before, where we didn't know for sure if the system was
safe.

> * Migration back to the original host (host A) is then rejected, even
> though the guest isn't using the HVC.

Again, we can't be sure, so denying migration is on the safe side.
 
> I can see two options here:
> 
> * Reject the migration to host B as the guest may be vulnerable after
> the migration. I.e. the workaround availability cannot change (either
> way) during a migration
> 
> * Store an extra bit of information which is whether a particular
> guest has the HVC exposed to it. Ideally the HVC handling for the
> workaround would also get disabled when running on a host which
> supports the HVC but was migrated from a host which doesn't. This
> prevents problems with a guest which is e.g. migrated during boot and
> may do feature detection after the migration.
> 
> Since this is a new ABI it would be good to get the register values
> sorted even if we don't have a complete implementation of it.

I agree to that part: this userland interface should be as good as
possible. So I think as a separate issue we should upgrade both the
host side and the guest part of the workaround to deal with all three
cases, but should indeed create the interface in a forward compatible
way.

I will look into extending the register to use two bits to accommodate
all three cases.

> > +#define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2
> > KVM_REG_ARM_FW_REG(2) +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK	0x3 +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL	0 +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL	1 +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED	2 +#define
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED	4 
> >  /* Device Control API: ARM VGIC */
> >  #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> > index 9b73d3ad918a..4c671908ef62 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -445,12 +445,18 @@ int kvm_hvc_call_handler(struct kvm_vcpu
> > *vcpu) 
> >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> >  {
> > -	return 1;		/* PSCI version */
> > +	return 3;		/* PSCI version and two
> > workaround registers */ }
> >  
> >  int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user
> > *uindices) {
> > -	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices))
> > +	if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
> > +		return -EFAULT;
> > +
> > +	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
> > uindices++))
> > +		return -EFAULT;
> > +
> > +	if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > uindices++)) return -EFAULT;
> >  
> >  	return 0;
> > @@ -469,6 +475,45 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu,
> > const struct kvm_one_reg *reg) return 0;
> >  	}
> >  
> > +	if (reg->id == KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1) {
> > +		void __user *uaddr = (void __user
> > *)(long)reg->addr;
> > +		u64 val = 0;
> > +
> > +		if (kvm_arm_harden_branch_predictor())
> > +			val =
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL; +
> > +		if (copy_to_user(uaddr, &val,
> > KVM_REG_SIZE(reg->id)))
> > +			return -EFAULT;
> > +
> > +		return 0;
> > +	}
> > +
> > +	if (reg->id == KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2) {
> > +		void __user *uaddr = (void __user
> > *)(long)reg->addr;
> > +		u64 val =
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL; +
> > +		switch (kvm_arm_have_ssbd()) {
> > +		case KVM_SSBD_FORCE_DISABLE:
> > +		case KVM_SSBD_UNKNOWN:
> > +			break;
> > +		case KVM_SSBD_KERNEL:
> > +			val |=
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL;
> > +			break;
> > +		case KVM_SSBD_FORCE_ENABLE:
> > +		case KVM_SSBD_MITIGATED:
> > +			val |=
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED;
> > +			break;
> > +		}
> > +
> > +		if (kvm_arm_get_vcpu_workaround_2_flag(vcpu))
> > +			val |=
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED; +
> > +		if (copy_to_user(uaddr, &val,
> > KVM_REG_SIZE(reg->id)))
> > +			return -EFAULT;
> > +
> > +		return 0;
> > +	}
> > +
> >  	return -EINVAL;
> >  }
> >  
> > @@ -499,5 +544,94 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu,
> > const struct kvm_one_reg *reg) }
> >  	}
> >  
> > +	if (reg->id == KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1) {
> > +		void __user *uaddr = (void __user
> > *)(long)reg->addr;
> > +		u64 val;
> > +
> > +		if (copy_from_user(&val, uaddr,
> > KVM_REG_SIZE(reg->id)))
> > +			return -EFAULT;
> > +
> > +		/* Make sure we support WORKAROUND_1 if userland
> > asks for it. */
> > +		if ((val &
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL) &&
> > +		    !kvm_arm_harden_branch_predictor())
> > +			return -EINVAL;
> > +
> > +		/* Any other bit is reserved. */
> > +		if (val &
> > ~KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL)
> > +			return -EINVAL;
> > +
> > +		return 0;
> > +	}
> > +
> > +	if (reg->id == KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2) {
> > +		void __user *uaddr = (void __user
> > *)(long)reg->addr;
> > +		unsigned int wa_state;
> > +		bool wa_flag;
> > +		u64 val;
> > +
> > +		if (copy_from_user(&val, uaddr,
> > KVM_REG_SIZE(reg->id)))
> > +			return -EFAULT;
> > +
> > +		/* Reject any unknown bits. */
> > +		if (val &
> > ~(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK|
> > +
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
> > +			return -EINVAL;
> > +
> > +		/*
> > +		 * The value passed from userland has to be
> > compatible with
> > +		 * our own workaround status. We also have to
> > consider the
> > +		 * requested per-VCPU state for some combinations:
> > +		 *
> > --------------+-----------+-----------------+---------------
> > +		 * \ user value  |           |                 |
> > +		 *  ------------ | SSBD_NONE |   SSBD_KERNEL   |
> > SSBD_ALWAYS
> > +		 *  this kernel \|           |                 |
> > +		 *
> > --------------+-----------+-----------------+---------------
> > +		 * UNKNOWN       |     OK    |   -EINVAL       |
> > -EINVAL
> > +		 * FORCE_DISABLE |           |                 |
> > +		 *
> > --------------+-----------+-----------------+---------------
> > +		 * KERNEL        |     OK    | copy VCPU state |
> > set VCPU state
> > +		 *
> > --------------+-----------+-----------------+---------------
> > +		 * FORCE_ENABLE  |     OK    |      OK
> > |      OK
> > +		 * MITIGATED     |           |                 |
> > +		 *
> > --------------+-----------+-----------------+---------------
> > +		 */
> > +
> > +		wa_state = val &
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK;
> > +		switch (wa_state) {
> > +		case
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
> > +			/* We can always support no mitigation
> > (1st column). */
> > +			return 0;
> > +		case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
> > +		case
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED:
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +
> > +		switch (kvm_arm_have_ssbd()) {
> > +		case KVM_SSBD_UNKNOWN:
> > +		case KVM_SSBD_FORCE_DISABLE:
> > +		default:
> > +			/* ... but some mitigation was requested
> > (1st line). */
> > +			return -EINVAL;
> > +		case KVM_SSBD_FORCE_ENABLE:
> > +		case KVM_SSBD_MITIGATED:
> > +			/* Always-on is always compatible (3rd
> > line). */
> > +			return 0;
> > +		case KVM_SSBD_KERNEL:		/* 2nd line */
> > +			wa_flag = val;
> > +			wa_flag |=
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_MASK; +
> > +			/* Force on when always-on is requested. */
> > +			if (wa_state ==
> > KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED)
> > +				wa_flag = true;
> > +			break;
> > +		}
> > +
> > +		kvm_arm_set_vcpu_workaround_2_flag(vcpu,
> > wa_flag);  
> 
> Since this line is only reached in the KVM_SSBD_KERNEL case I think it
> should be moved up. I'd personally find the code easier to follow if
> the default/UNKNOWN/FORCE_DISABLE case is the one that drops out and
> all the others have a "return 0". It took me a while to be sure that
> wa_flag wasn't used uninitialised here!

I will check, I think I tried this as well, but it was more messy
somewhere else.

Cheers,
Andre.

> 
> Steve
> 
> > +
> > +		return 0;
> > +	}
> > +
> >  	return -EINVAL;
> >  }
> >   
> 
