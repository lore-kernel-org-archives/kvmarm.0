From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 22/23] arm64: KVM: Allow mapping of vectors outside
 of the RAM region
Date: Fri, 09 Mar 2018 18:59:16 +0000
Message-ID: <5AA2D984.5030901@arm.com>
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

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 3da9e5aea936..433d13d0c271 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h

[..]

>  
> +/*  This is only called on a !VHE system */
>  static inline int kvm_map_vectors(void)
>  {
> -	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
> -				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
> -				   PAGE_HYP_EXEC);
> -}
> +	phys_addr_t vect_pa = virt_to_phys(__bp_harden_hyp_vecs_start);

__pa_symbol()?

A gift from CONFIG_DEBUG_VIRTUAL:

[    3.479878] kvm [1]: 8-bit VMID
[    3.500761] ------------[ cut here ]------------
[    3.505608] virt_to_phys used for non-linear address: 000000006fa7ae39
(__bp_harden_hyp_vecs_start+0x0/0x2000)
[    3.515907] WARNING: CPU: 3 PID: 1 at ../arch/arm64/mm/physaddr.c:15
__virt_to_phys+0x48/0x68
[    3.524614] Modules linked in:
[    3.527782] CPU: 3 PID: 1 Comm: swapper/0 Not tainted
4.16.0-rc4-00024-gf6f4460e41ba-dirty #9396
[    3.536751] Hardware name: ARM Juno development board (r1) (DT)
[    3.542806] pstate: 80400005 (Nzcv daif +PAN -UAO)
[    3.547716] pc : __virt_to_phys+0x48/0x68
[    3.551832] lr : __virt_to_phys+0x48/0x68

[    3.641447] Call trace:
[    3.643975]  __virt_to_phys+0x48/0x68
[    3.647739]  kvm_arch_init+0x2fc/0x734
[    3.651589]  kvm_init+0x28/0x2b0
[    3.654910]  arm_init+0x1c/0x24
[    3.658143]  do_one_initcall+0x38/0x11c
[    3.662083]  kernel_init_freeable+0x1e0/0x27c
[    3.666552]  kernel_init+0x10/0xfc
[    3.670049]  ret_from_fork+0x10/0x18
[    3.673731] ---[ end trace d4ef061e4bf05fc6 ]---
[    3.678870] kvm [1]: vgic-v2@2c04f000
[    3.683424] kvm [1]: vgic interrupt IRQ1
[    3.687675] kvm [1]: virtual timer IRQ5
[    3.692375] kvm [1]: Hyp mode initialized successfully
[    3.718640] Initialise system trusted keyrings



> +	unsigned long size = __bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start;
> +
> +	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
> +		int ret;
> +
> +		ret = create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
> +					  kvm_ksym_ref(__bp_harden_hyp_vecs_end),
> +					  PAGE_HYP_EXEC);
> +
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


Thanks,

James
