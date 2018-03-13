From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 22/23] arm64: KVM: Allow mapping of vectors outside of
 the RAM region
Date: Tue, 13 Mar 2018 10:30:12 +0000
Message-ID: <c795eca8-7a4f-b209-608d-1428c6dbda33@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-23-marc.zyngier@arm.com>
 <20180308175412.rd63nkceqjg2yrcv@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180308175412.rd63nkceqjg2yrcv@kamzik.brq.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andrew Jones <drjones@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Drew,

On 08/03/18 17:54, Andrew Jones wrote:
> On Thu, Mar 01, 2018 at 03:55:37PM +0000, Marc Zyngier wrote:
>> We're now ready to map our vectors in weird and wonderful locations.
>> On enabling ARM64_HARDEN_EL2_VECTORS, a vector slots gets allocated
>> if this hasn't been already done via ARM64_HARDEN_BRANCH_PREDICTOR
>> and gets mapped outside of the normal RAM region, next to the
>> idmap.
>>
>> That way, being able to obtain VBAR_EL2 doesn't reveal the mapping
>> of the rest of the hypervisor code.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  Documentation/arm64/memory.txt   |  3 +-
>>  arch/arm64/Kconfig               | 16 ++++++++
>>  arch/arm64/include/asm/kvm_mmu.h | 81 ++++++++++++++++++++++++++++++++++------
>>  arch/arm64/include/asm/mmu.h     |  5 ++-
>>  arch/arm64/kernel/Makefile       |  4 +-
>>  arch/arm64/kvm/va_layout.c       |  3 ++
>>  6 files changed, 96 insertions(+), 16 deletions(-)
>>
>> diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
>> index c58cc5dbe667..c5dab30d3389 100644
>> --- a/Documentation/arm64/memory.txt
>> +++ b/Documentation/arm64/memory.txt
>> @@ -90,7 +90,8 @@ When using KVM without the Virtualization Host Extensions, the
>>  hypervisor maps kernel pages in EL2 at a fixed (and potentially
>>  random) offset from the linear mapping. See the kern_hyp_va macro and
>>  kvm_update_va_mask function for more details. MMIO devices such as
>> -GICv2 gets mapped next to the HYP idmap page.
>> +GICv2 gets mapped next to the HYP idmap page, as do vectors when
>> +ARM64_HARDEN_EL2_VECTORS is selected for particular CPUs.
>>  
>>  When using KVM with the Virtualization Host Extensions, no additional
>>  mappings are created, since the host kernel runs directly in EL2.
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 7381eeb7ef8e..e6be4393aaad 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -904,6 +904,22 @@ config HARDEN_BRANCH_PREDICTOR
>>  
>>  	  If unsure, say Y.
>>  
>> +config HARDEN_EL2_VECTORS
>> +	bool "Harden EL2 vector mapping against system register leak" if EXPERT
>> +	default y
>> +	help
>> +	  Speculation attacks against some high-performance processors can
>> +	  be used to leak privileged information such as the vector base
>> +	  register, resulting in a potential defeat of the EL2 layout
>> +	  randomization.
>> +
>> +	  This config option will map the vectors to a fixed location,
>> +	  independent of the EL2 code mapping, so that revealing VBAR_EL2
>> +	  to an attacker does no give away any extra information. This
>> +	  only gets enabled on affected CPUs.
>> +
>> +	  If unsure, say Y.
>> +
>>  menuconfig ARMV8_DEPRECATED
>>  	bool "Emulate deprecated/obsolete ARMv8 instructions"
>>  	depends on COMPAT
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 3da9e5aea936..433d13d0c271 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -360,33 +360,90 @@ static inline unsigned int kvm_get_vmid_bits(void)
>>  	return (cpuid_feature_extract_unsigned_field(reg, ID_AA64MMFR1_VMIDBITS_SHIFT) == 2) ? 16 : 8;
>>  }
>>  
>> -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>> +#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
>> +     defined(CONFIG_HARDEN_EL2_VECTORS))
>> +/*
>> + * EL2 vectors can be mapped and rerouted in a number of ways,
>> + * depending on the kernel configuration and CPU present:
>> + *
>> + * - If the CPU has the ARM64_HARDEN_BRANCH_PREDICTOR cap, the
>> + *   hardening sequence is placed in one of the vector slots, which is
>> + *   executed before jumping to the real vectors.
>> + *
>> + * - If the CPU has both the ARM64_HARDEN_EL2_VECTORS and BP
>> + *   hardening, the slot containing the hardening sequence is mapped
>> + *   next to the idmap page, and executed before jumping to the real
>> + *   vectors.
>> + *
>> + * - If the CPU only has ARM64_HARDEN_EL2_VECTORS, then an empty slot
>> + *   is selected, mapped next to the idmap page, and executed before
>> + *   jumping to the real vectors.
>> + *
>> + * Note that ARM64_HARDEN_EL2_VECTORS is somewhat incompatible with
>> + * VHE, as we don't have hypervisor-specific mappings. If the system
>> + * is VHE and yet selects this capability, it will be ignored.
>> + */
>>  #include <asm/mmu.h>
>>  
>> +extern void *__kvm_bp_vect_base;
>> +extern int __kvm_harden_el2_vector_slot;
>> +
>>  static inline void *kvm_get_hyp_vector(void)
>>  {
>>  	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
>> -	void *vect = kvm_ksym_ref(__kvm_hyp_vector);
>> +	int slot = -1;
>> +
>> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn)
>> +		slot = data->hyp_vectors_slot;
>> +
>> +	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS) &&
>> +	    !has_vhe() && slot == -1)
>> +		slot = __kvm_harden_el2_vector_slot;
>>  
>> -	if (data->fn) {
>> -		vect = __bp_harden_hyp_vecs_start +
>> -		       data->hyp_vectors_slot * SZ_2K;
>> +	if (slot != -1) {
>> +		void *vect;
>>  
>>  		if (!has_vhe())
>> -			vect = lm_alias(vect);
>> +			vect = __kvm_bp_vect_base;
>> +		else
>> +			vect = __bp_harden_hyp_vecs_start;
>> +		vect += slot * SZ_2K;
>> +
>> +		return vect;
>>  	}
>>  
>> -	vect = kern_hyp_va(vect);
>> -	return vect;
>> +	return kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
>>  }
> 
> I had trouble reading the above function. How about something like?
> (Assuming I got the logic right.)
> 
>  static inline void *kvm_get_hyp_vector(void)
>  {
>         struct bp_hardening_data *data = arm64_get_bp_hardening_data();
>         void *vect = kern_hyp_va(kvm_ksym_ref(__kvm_hyp_vector));
>         int slot = -1;
> 
>         if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
>                 vect = __bp_harden_hyp_vecs_start;
>                 slot = data->hyp_vectors_slot;
>         }
> 
>         if (!has_vhe() && cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
>                 vect = __kvm_bp_vect_base;
>                 if (slot == -1)
>                         slot = __kvm_harden_el2_vector_slot;
>         }
> 
>         if (slot != -1)
>                 vect += slot * SZ_2K;
> 
>         return vect;
>  }

Yes, this looks much more palatable than my initial approach. I'll use that.

> 
>>  
>> +/*  This is only called on a !VHE system */
>>  static inline int kvm_map_vectors(void)
>>  {
>> -	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
>> -				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
>> -				   PAGE_HYP_EXEC);
>> -}
>> +	phys_addr_t vect_pa = virt_to_phys(__bp_harden_hyp_vecs_start);
>> +	unsigned long size = __bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start;
> 
> nit: We only use these expressions once, so could probably do away with
> the variables. Or the variables could be tucked into the block they're
> used in below.
> 
>> +
>> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
> 
> Moving the create_hyp_mappings() under this cap check looks like a fix
> that could be posted separately?

We could. Not sure that's a big deal though.

> 
>> +		int ret;
>> +
>> +		ret = create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
>> +					  kvm_ksym_ref(__bp_harden_hyp_vecs_end),
>> +					  PAGE_HYP_EXEC);
>> +
>> +		if (ret)
>> +			return ret;
>> +
>> +		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs_start);
>> +		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
>> +	}
>> +
>> +	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
>> +		__kvm_harden_el2_vector_slot = atomic_inc_return(&arm64_el2_vector_last_slot);
> 
> If I understood the logic in the above function correctly, then we won't
> be using this slot when we have the ARM64_HARDEN_BRANCH_PREDICTOR cap.
> Should we even bother allocating it when we don't intend to use it?

You could be on a system with a mix of affected and non-affected CPUs,
and the capability only tells you that at least one of the CPUs is
affected. For the non affected CPUs, we won't have a slot (since there
is no workaround to provide), unless we actually allocated one.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
