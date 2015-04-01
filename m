From: David Hildenbrand <dahi@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 05/10] KVM: arm: introduce
 kvm_arch_setup/clear_debug()
Date: Wed, 1 Apr 2015 18:28:55 +0200
Message-ID: <20150401182855.4650b14a@thinkpad-w530>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
	<1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427814488-28467-6-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org, jan.kiszka@siemens.com, r65777@freescale.com, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

> This is a precursor for later patches which will need to do more to
> setup debug state before entering the hyp.S switch code. The existing
> functionality for setting mdcr_el2 has been moved out of hyp.S and no=
w
> uses the value kept in vcpu->arch.mdcr_el2.
>=20
> This also moves the conditional setting of the TDA bit from the hyp c=
ode
> into the C code.
>=20
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>=20
>  create mode 100644 arch/arm64/kvm/debug.c
>=20
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/k=
vm_host.h
> index 41008cd..8c01c97 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -242,5 +242,7 @@ static inline void kvm_arch_hardware_unsetup(void=
) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)=
 {}
> +static inline void kvm_arch_setup_debug(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arch_clear_debug(struct kvm_vcpu *vcpu) {}

Do you really want to call these functions "kvm_arch.." although they a=
re not
defined for other arch and not triggered by common code?

kvm_setup ... or kvm_arm_setup...

>=20
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 445933d..7ea8b0e 100644
> --- a/arch/arm/kvm/arm.c
[...]
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_host.h>
> +
> +/**
> + * kvm_arch_setup_debug - set-up debug related stuff
> + *
> + * @vcpu:	the vcpu pointer
> + *
> + * This is called before each entry in to the hypervisor to setup an=
y
> + * debug related registers. Currently this just ensures we will trap
> + * access to:
> + *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> + *  - Debug ROM Address (MDCR_EL2_TDRA)
> + *  - Power down debug registers (MDCR_EL2_TDOSA)
> + *
> + * Additionally the hypervisor lazily saves/restores the debug
> + * register state. If it is not currently doing so (arch.debug_flags=
)
> + * then we also need to ensure we trap if the guest messes with them
> + * so we know we need to save them.
> + */
> +
> +void kvm_arch_setup_debug(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM | MDCR_EL2_TPMCR);
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TDRA | MDCR_EL2_TDOSA);

I'd put that into a single assignment.

> +
> +	if (!vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;
> +
> +}
> +
> +void kvm_arch_clear_debug(struct kvm_vcpu *vcpu)
> +{
> +	/* Nothing to do yet */

Wonder if that would be the right place to clear MDCR_EL2_TDA unconditi=
onally?
But see my comment below.

> +}
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 5befd01..be92bfe1 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -768,17 +768,8 @@
>  	mov	x2, #(1 << 15)	// Trap CP15 Cr=3D15
>  	msr	hstr_el2, x2
>=20
> -	mrs	x2, mdcr_el2
> -	and	x2, x2, #MDCR_EL2_HPMN_MASK
> -	orr	x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
> -	orr	x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
> -
> -	// Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap
> -	// if not dirty.
> -	ldr	x3, [x0, #VCPU_DEBUG_FLAGS]
> -	tbnz	x3, #KVM_ARM64_DEBUG_DIRTY_SHIFT, 1f
> -	orr	x2, x2,  #MDCR_EL2_TDA
> -1:

*neither an assembler nor arm expert*
The existing code always cleared all bits except MDCR_EL2_HPMN_MASK. So=
 they
remained set.

We would now always overwrite these bits with the values from=20
vcpu->arch.mdcr_el2, is that okay?

> +	// Monitor Debug Config - see kvm_arch_setup_debug()
> +	ldr	x2, [x0, #VCPU_MDCR_EL2]
>  	msr	mdcr_el2, x2
>  .endm
>=20



David

