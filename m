From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 22/23] arm64: KVM: Allow mapping of vectors outside
 of the RAM region
Date: Wed, 14 Mar 2018 11:40:59 +0000
Message-ID: <5AA90A4B.2020900@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-23-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180301155538.26860-23-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 01/03/18 15:55, Marc Zyngier wrote:
> We're now ready to map our vectors in weird and wonderful locations.
> On enabling ARM64_HARDEN_EL2_VECTORS, a vector slots gets allocated
> if this hasn't been already done via ARM64_HARDEN_BRANCH_PREDICTOR
> and gets mapped outside of the normal RAM region, next to the
> idmap.
> 
> That way, being able to obtain VBAR_EL2 doesn't reveal the mapping
> of the rest of the hypervisor code.

> diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
> index c58cc5dbe667..c5dab30d3389 100644
> --- a/Documentation/arm64/memory.txt
> +++ b/Documentation/arm64/memory.txt
> @@ -90,7 +90,8 @@ When using KVM without the Virtualization Host Extensions, the
>  hypervisor maps kernel pages in EL2 at a fixed (and potentially
>  random) offset from the linear mapping. See the kern_hyp_va macro and
>  kvm_update_va_mask function for more details. MMIO devices such as
> -GICv2 gets mapped next to the HYP idmap page.
> +GICv2 gets mapped next to the HYP idmap page, as do vectors when
> +ARM64_HARDEN_EL2_VECTORS is selected for particular CPUs.
>  
>  When using KVM with the Virtualization Host Extensions, no additional
>  mappings are created, since the host kernel runs directly in EL2.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 3da9e5aea936..433d13d0c271 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -360,33 +360,90 @@ static inline unsigned int kvm_get_vmid_bits(void)
>  	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
>  }
>  
> -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> +#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
> +     defined(CONFIG_HARDEN_EL2_VECTORS))
> +/*
> + * EL2 vectors can be mapped and rerouted in a number of ways,
> + * depending on the kernel configuration and CPU present:
> + *
> + * - If the CPU has the ARM64_HARDEN_BRANCH_PREDICTOR cap, the
> + *   hardening sequence is placed in one of the vector slots, which is
> + *   executed before jumping to the real vectors.
> + *
> + * - If the CPU has both the ARM64_HARDEN_EL2_VECTORS and BP
> + *   hardening, the slot containing the hardening sequence is mapped
> + *   next to the idmap page, and executed before jumping to the real
> + *   vectors.
> + *
> + * - If the CPU only has ARM64_HARDEN_EL2_VECTORS, then an empty slot
> + *   is selected, mapped next to the idmap page, and executed before
> + *   jumping to the real vectors.

> + * Note that ARM64_HARDEN_EL2_VECTORS is somewhat incompatible with
> + * VHE, as we don't have hypervisor-specific mappings. If the system
> + * is VHE and yet selects this capability, it will be ignored.

Silently? This isn't a problem as the CPUs you enable this for don't have VHE.
Is it worth a warning? If we did ever need to support it, we can pull the same
trick the arch code uses, using a fixmap entry for the vectors.


> + */
>  #include <asm/mmu.h>
>  
> +extern void *__kvm_bp_vect_base;
> +extern int __kvm_harden_el2_vector_slot;
> +
>  static inline void *kvm_get_hyp_vector(void)
>  {
>  	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
> -	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
> +	int slot = -1;
> +
> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn)
> +		slot = data->hyp_vectors_slot;
> +
> +	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS) &&
> +	    !has_vhe() && slot == -1)
> +		slot = __kvm_harden_el2_vector_slot;
>  
> -	if (data->fn) {
> -		vect = __bp_harden_hyp_vecs_start +
> -		       data->hyp_vectors_slot * SZ_2K;
> +	if (slot != -1) {
> +		void *vect;
>  
>  		if (!has_vhe())
> -			vect = lm_alias(vect);
> +			vect = __kvm_bp_vect_base;
> +		else
> +			vect = __bp_harden_hyp_vecs_start;
> +		vect += slot * SZ_2K;
> +
> +		return vect;
>  	}
>  
> -	vect = kern_hyp_va(vect);
> -	return vect;
> +	return kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
>  }
>  
> +/*  This is only called on a !VHE system */
>  static inline int kvm_map_vectors(void)
>  {
> -	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
> -				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
> -				   PAGE_HYP_EXEC);
> -}
> +	phys_addr_t vect_pa = virt_to_phys(__bp_harden_hyp_vecs_start);
> +	unsigned long size = __bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start;
> +
> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
> +		int ret;
> +
> +		ret = create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
> +					  kvm_ksym_ref(__bp_harden_hyp_vecs_end),
> +					  PAGE_HYP_EXEC);

We don't have to do this for the regular vectors, as they are part of the
__hyp_text. How come these aren't?

The existing Makefile depends on KVM to build these. How come it isn't under
arch/arm64/kvm?


> +		if (ret)
> +			return ret;
> +
> +		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs_start);
> +		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
> +	}
> +
> +	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
> +		__kvm_harden_el2_vector_slot = atomic_inc_return(&arm64_el2_vector_last_slot);
> +		BUG_ON(__kvm_harden_el2_vector_slot >= BP_HARDEN_EL2_SLOTS);
> +		return create_hyp_exec_mappings(vect_pa, size,
> +						&__kvm_bp_vect_base);
> +	}
>  
> +	return 0;
> +}
>  #else
>  static inline void *kvm_get_hyp_vector(void)
>  {

> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index b87541360f43..e7fc471c91a6 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -54,8 +54,8 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
>  arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>  arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
>  
> -ifeq ($(CONFIG_KVM),y)
> -arm64-obj-$(CONFIG_HARDEN_BRANCH_PREDICTOR)	+= bpi.o
> +ifneq ($(filter y,$(CONFIG_HARDEN_BRANCH_PREDICTOR) $(CONFIG_HARDEN_EL2_VECTORS)),)
> +arm64-obj-$(CONFIG_KVM)			+= bpi.o
>  endif

Isn't Kconfig 'select'ing a hidden-option the usual way this is done?


Thanks,

James
