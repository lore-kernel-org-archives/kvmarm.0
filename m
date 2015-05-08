From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 05/12] KVM: arm: introduce
 kvm_arm_init/setup/clear_debug
Date: Fri, 8 May 2015 13:52:24 +0200
Message-ID: <20150508115224.GE24744@cbox>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
 <1430929407-3487-6-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E74550D58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 07:43:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mkn4yeDTLOcH for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 May 2015 07:43:30 -0400 (EDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD2D450D5E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 May 2015 07:43:29 -0400 (EDT)
Received: by layy10 with SMTP id y10so50909744lay.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 May 2015 04:52:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1430929407-3487-6-git-send-email-alex.bennee@linaro.org>
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

On Wed, May 06, 2015 at 05:23:20PM +0100, Alex Benn=E9e wrote:
> This is a precursor for later patches which will need to do more to
> setup debug state before entering the hyp.S switch code. The existing
> functionality for setting mdcr_el2 has been moved out of hyp.S and now
> uses the value kept in vcpu->arch.mdcr_el2.
> =

> As the assembler used to previously mask and preserve MDCR_EL2.HPMN I've
> had to add a mechanism to save the value of mdcr_el2 as a per-cpu
> variable during the initialisation code. The kernel never sets this
> number so we are assuming the bootcode has set up the correct value
> here.
> =

> This also moves the conditional setting of the TDA bit from the hyp code
> into the C code which is currently used for the lazy debug register
> context switch code.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> =

> ---
> v3
>   - rename fns from arch->arm
>   - preserve MDCR_EL2.HPMN setting
>   - re-word some of the comments
>   - fix some minor grammar nits
>   - merge setting of mdcr_el2
>   - introduce trap_debug flag
>   - move setup/clear within the irq lock section
> =

>  create mode 100644 arch/arm64/kvm/debug.c
> =

> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_h=
ost.h
> index d71607c..746c0c69 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -236,4 +236,8 @@ static inline void kvm_arch_sync_events(struct kvm *k=
vm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  =

> +static inline void kvm_arm_init_debug(void) {}
> +static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> +
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 52a1d4d38..4a274e1 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -570,6 +570,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
>  			continue;
>  		}
>  =

> +		kvm_arm_setup_debug(vcpu);
> +
>  		/**************************************************************
>  		 * Enter the guest
>  		 */
> @@ -582,7 +584,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
>  		vcpu->mode =3D OUTSIDE_GUEST_MODE;
>  		kvm_guest_exit();
>  		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> -		/*
> +
> +		kvm_arm_clear_debug(vcpu);
> +
> +                /*
>  		 * We may have taken a host interrupt in HYP mode (ie
>  		 * while executing the guest). This interrupt is still
>  		 * pending, as we haven't serviced it yet!
> @@ -930,6 +935,8 @@ static void cpu_init_hyp_mode(void *dummy)
>  	vector_ptr =3D (unsigned long)__kvm_hyp_vector;
>  =

>  	__cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr);
> +
> +	kvm_arm_init_debug();
>  }
>  =

>  static int hyp_init_cpu_notify(struct notifier_block *self,
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index 4f7310f..d6b507e 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -137,6 +137,8 @@ extern char __restore_vgic_v2_state[];
>  extern char __save_vgic_v3_state[];
>  extern char __restore_vgic_v3_state[];
>  =

> +extern u32 __kvm_get_mdcr_el2(void);
> +
>  #endif
>  =

>  #endif /* __ARM_KVM_ASM_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index f0f58c9..7cb99b5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -103,6 +103,7 @@ struct kvm_vcpu_arch {
>  =

>  	/* HYP configuration */
>  	u64 hcr_el2;
> +	u32 mdcr_el2;
>  =

>  	/* Exception Information */
>  	struct kvm_vcpu_fault_info fault;
> @@ -250,4 +251,8 @@ static inline void kvm_arch_sync_events(struct kvm *k=
vm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  =

> +void kvm_arm_init_debug(void);
> +void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> +void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offs=
ets.c
> index da675cc..dfb25a2 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -117,6 +117,7 @@ int main(void)
>    DEFINE(VCPU_HPFAR_EL2,	offsetof(struct kvm_vcpu, arch.fault.hpfar_el2)=
);
>    DEFINE(VCPU_DEBUG_FLAGS,	offsetof(struct kvm_vcpu, arch.debug_flags));
>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
> +  DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
>    DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
>    DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_cont=
ext));
>    DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.c=
ntv_ctl));
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index d5904f8..90e3f39 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -17,7 +17,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(ARM)/psci.o $(ARM)/pe=
rf.o
>  =

>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D emulate.o inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D hyp.o hyp-init.o handle_exit.o
> -kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o reset.o sys_regs.o sys_regs_gene=
ric_v8.o
> +kvm-$(CONFIG_KVM_ARM_HOST) +=3D guest.o debug.o reset.o sys_regs.o sys_r=
egs_generic_v8.o
>  =

>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(KVM)/arm/vgic.o
>  kvm-$(CONFIG_KVM_ARM_HOST) +=3D $(KVM)/arm/vgic-v2.o
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> new file mode 100644
> index 0000000..b1f8731
> --- /dev/null
> +++ b/arch/arm64/kvm/debug.c
> @@ -0,0 +1,83 @@
> +/*
> + * Debug and Guest Debug support
> + *
> + * Copyright (C) 2015 - Linaro Ltd
> + * Author: Alex Benn=E9e <alex.bennee@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_arm.h>
> +
> +static DEFINE_PER_CPU(u32, mdcr_el2);
> +
> +/**
> + * kvm_arm_init_debug - grab what we need for debug
> + *
> + * Currently the sole task of this function is to retrieve the initial
> + * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
> + * presumably been set-up by some knowledgeable bootcode.
> + *
> + * It is called once per-cpu during CPU hyp initialisation.
> + */
> +
> +void kvm_arm_init_debug(void)
> +{
> +	__this_cpu_write(mdcr_el2, kvm_call_hyp(__kvm_get_mdcr_el2));
> +}
> +
> +
> +/**
> + * kvm_arm_setup_debug - set up debug related stuff
> + *
> + * @vcpu:	the vcpu pointer
> + *
> + * This is called before each entry into the hypervisor to setup any
> + * debug related registers. Currently this just ensures we will trap
> + * access to:
> + *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
> + *  - Debug ROM Address (MDCR_EL2_TDRA)
> + *  - Power down debug registers (MDCR_EL2_TDOSA)

TDOSA traps more than the DBGPRCR_EL1 register, so "OS-related
registers" is probably what you want here.

> + *
> + * Additionally, KVM only traps guest accesses to the debug registers if
> + * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
> + * flag on vcpu->arch.debug_flags).  Since the guest must not interfere
> + * with the hardware state when debugging the guest, we must ensure that
> + * trapping is enabled whenever we are debugging the guest using the
> + * debug registers.
> + */
> +
> +void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> +{
> +	bool trap_debug =3D !(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY);
> +
> +	vcpu->arch.mdcr_el2 =3D __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> +	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM |
> +				MDCR_EL2_TPMCR |
> +				MDCR_EL2_TDRA |
> +				MDCR_EL2_TDOSA);
> +
> +	/* Trap on access to debug registers? */
> +	if (trap_debug)
> +		vcpu->arch.mdcr_el2 |=3D MDCR_EL2_TDA;
> +	else
> +		vcpu->arch.mdcr_el2 &=3D ~MDCR_EL2_TDA;

the else-clause shouldn't be necessary as you've just initialized the
register with the HPMN_MASK.

> +
> +}
> +
> +void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
> +{
> +	/* Nothing to do yet */
> +}
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 5befd01..15159aa 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -768,17 +768,8 @@
>  	mov	x2, #(1 << 15)	// Trap CP15 Cr=3D15
>  	msr	hstr_el2, x2
>  =

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
> +	// Monitor Debug Config - see kvm_arch_setup_debug()

kvm_arm_setup_debug() ?

> +	ldr	x2, [x0, #VCPU_MDCR_EL2]
>  	msr	mdcr_el2, x2
>  .endm
>  =

> @@ -1295,4 +1286,10 @@ ENTRY(__kvm_hyp_vector)
>  	ventry	el1_error_invalid		// Error 32-bit EL1
>  ENDPROC(__kvm_hyp_vector)
>  =

> +
> +ENTRY(__kvm_get_mdcr_el2)
> +	mrs	x0, mdcr_el2
> +	ret
> +ENDPROC(__kvm_get_mdcr_el2)
> +
>  	.popsection
> -- =

> 2.3.5
> =


Thanks,
-Christoffer
