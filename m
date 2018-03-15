From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v6 20/26] arm64: KVM: Move BP hardening vectors into
 .hyp.text section
Date: Thu, 15 Mar 2018 15:42:44 +0100
Message-ID: <20180315144244.6iruyk6nhiciczs6@kamzik.brq.redhat.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-21-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180314165049.30105-21-marc.zyngier@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 14, 2018 at 04:50:43PM +0000, Marc Zyngier wrote:
> There is no reason why the BP hardening vectors shouldn't be part
> of the HYP text at compile time, rather than being mapped at runtime.
> 
> Also introduce a new config symbol that controls the compilation
> of bpi.S.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 4 +---
>  arch/arm64/kernel/Makefile       | 4 +---
>  arch/arm64/kernel/bpi.S          | 6 ++++++
>  arch/arm64/kvm/Kconfig           | 3 +++
>  4 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index bfb81e73da06..c2beb2d25170 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -380,9 +380,7 @@ static inline void *kvm_get_hyp_vector(void)
>  
>  static inline int kvm_map_vectors(void)
>  {
> -	return create_hyp_mappings(kvm_ksym_ref(__bp_harden_hyp_vecs_start),
> -				   kvm_ksym_ref(__bp_harden_hyp_vecs_end),
> -				   PAGE_HYP_EXEC);
> +	return 0;
>  }
>  
>  #else
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index b87541360f43..93bce17109a6 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -54,9 +54,7 @@ arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
>  arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
>  arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
>  
> -ifeq ($(CONFIG_KVM),y)
> -arm64-obj-$(CONFIG_HARDEN_BRANCH_PREDICTOR)	+= bpi.o
> -endif
> +arm64-obj-$(CONFIG_KVM_INDIRECT_VECTORS)+= bpi.o

I was about to say a space before the += would be nice, but I see the
operator actually lines up with the others this way.

>  
>  obj-y					+= $(arm64-obj-y) vdso/ probes/
>  obj-m					+= $(arm64-obj-m)
> diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
> index e5de33513b5d..447188e2a664 100644
> --- a/arch/arm64/kernel/bpi.S
> +++ b/arch/arm64/kernel/bpi.S
> @@ -48,6 +48,10 @@
>  	ventry \target + 0x780
>  .endm
>  
> +
> +	.text
> +	.pushsection	.hyp.text, "ax"
> +
>  	.align	11
>  ENTRY(__bp_harden_hyp_vecs_start)
>  	.rept 4
> @@ -55,6 +59,8 @@ ENTRY(__bp_harden_hyp_vecs_start)
>  	.endr
>  ENTRY(__bp_harden_hyp_vecs_end)
>  
> +	.popsection
> +
>  ENTRY(__qcom_hyp_sanitize_link_stack_start)
>  	stp     x29, x30, [sp, #-16]!
>  	.rept	16
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 2257dfcc44cc..bd8cc03d7522 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -57,6 +57,9 @@ config KVM_ARM_PMU
>  	  Adds support for a virtual Performance Monitoring Unit (PMU) in
>  	  virtual machines.
>  
> +config KVM_INDIRECT_VECTORS
> +       def_bool KVM && HARDEN_BRANCH_PREDICTOR
> +
>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> -- 
> 2.14.2
> 

Reviewed-by: Andrew Jones <drjones@redhat.com>
