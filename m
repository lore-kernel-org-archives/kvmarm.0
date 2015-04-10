From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH] arm64: KVM: remove fpsimd save/restore from the world
 switch
Date: Fri, 10 Apr 2015 10:41:17 +0200
Message-ID: <55278CAD.70302@redhat.com>
References: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1428598439-5217-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 09/04/2015 18:53, Marc Zyngier wrote:
> The world switch spends quite some time dealing with the FP/SIMD
> registers, as the state is quite sizeable (32 128bit registers,
> plus some crumbs on the side). We save/restore them on each
> entry/exit, so that both the host and the guest always see
> the state they expect.
> 
> But let's face it: the host kernel doesn't care. It is the host
> userspace that actually cares about FP. An obvious improvement is
> to remove the save/restore from the world switch, and only perform
> it when we're about to enter/exit the guest (by plugging it into
> vcpu_load/vcpu_put).

Good idea!  Does ARM have a way to do "lazy" save/restore?  On x86 we
know if the FP/SIMD state was in use on the host, and we can force an
exit the first time the guest uses the FP/SIMD.

On ARM, it wouldn't be a problem to handle this kind of exit straight in
EL2 (similar to the hack Ard used when playing with memory attributes).

Paolo

 The effect is pretty spectacular when running
> hackbench (which is the only benchmark worth looking at):
> 
> Without this patch:
> 
> 	Running with 50*40 (== 2000) tasks.
> 	Time: 36.756
> 	Running with 50*40 (== 2000) tasks.
> 	Time: 36.679
> 	Running with 50*40 (== 2000) tasks.
> 	Time: 36.699
> 
> With this patch:
> 
> 	Running with 50*40 (== 2000) tasks.
> 	Time: 30.947
> 	Running with 50*40 (== 2000) tasks.
> 	Time: 30.868
> 	Running with 50*40 (== 2000) tasks.
> 	Time: 30.961
> 
> This is on a HiKey board (8*A53), with a 4 vcpu guest.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  3 +++
>  arch/arm/kvm/arm.c                |  2 ++
>  arch/arm64/include/asm/kvm_asm.h  |  4 ++++
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/kvm/Makefile           |  1 +
>  arch/arm64/kvm/fpsimd.S           | 39 ++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/handle_fpsimd.c    | 42 +++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp.S              | 27 -------------------------
>  8 files changed, 94 insertions(+), 27 deletions(-)
>  create mode 100644 arch/arm64/kvm/fpsimd.S
>  create mode 100644 arch/arm64/kvm/handle_fpsimd.c
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index d71607c..65cf1d1 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -226,6 +226,9 @@ static inline void vgic_arch_setup(const struct vgic_params *vgic)
>  int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
> +static inline void kvm_fpsimd_flush_hwstate(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_fpsimd_sync_hwstate(struct kvm_vcpu *vcpu) {}
> +
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 6f53645..ff1213c 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -287,6 +287,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	vcpu->cpu = cpu;
>  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
>  
> +	kvm_fpsimd_flush_hwstate(vcpu);
>  	kvm_arm_set_running_vcpu(vcpu);
>  }
>  
> @@ -299,6 +300,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	 */
>  	vcpu->cpu = -1;
>  
> +	kvm_fpsimd_sync_hwstate(vcpu);
>  	kvm_arm_set_running_vcpu(NULL);
>  }
>  
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 4f7310f..eafb0c3 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -137,6 +137,10 @@ extern char __restore_vgic_v2_state[];
>  extern char __save_vgic_v3_state[];
>  extern char __restore_vgic_v3_state[];
>  
> +struct kvm_cpu_context;
> +extern void __kvm_save_fpsimd(struct kvm_cpu_context *);
> +extern void __kvm_restore_fpsimd(struct kvm_cpu_context *);
> +
>  #endif
>  
>  #endif /* __ARM_KVM_ASM_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f0f58c9..2b968e5 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -201,6 +201,9 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
> +void kvm_fpsimd_flush_hwstate(struct kvm_vcpu *vcpu);
> +void kvm_fpsimd_sync_hwstate(struct kvm_vcpu *vcpu);
> +
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
>  
>  static inline void __cpu_init_hyp_mode(phys_addr_t boot_pgd_ptr,
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index d5904f8..6d9c2b7 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -18,6 +18,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o reset.o sys_regs.o sys_regs_generic_v8.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += fpsimd.o handle_fpsimd.o
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
> diff --git a/arch/arm64/kvm/fpsimd.S b/arch/arm64/kvm/fpsimd.S
> new file mode 100644
> index 0000000..458a1a7
> --- /dev/null
> +++ b/arch/arm64/kvm/fpsimd.S
> @@ -0,0 +1,39 @@
> +/*
> + * Copyright (C) 2012,2013 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
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
> +#include <linux/linkage.h>
> +
> +#include <asm/asm-offsets.h>
> +#include <asm/fpsimdmacros.h>
> +
> +#define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
> +
> +ENTRY(__kvm_save_fpsimd)
> +	// x0: cpu context address
> +	// x1, x2: tmp regs
> +	add	x1, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> +	fpsimd_save x1, 2
> +	ret
> +END(__kvm_save_fpsimd)
> +
> +ENTRY(__kvm_restore_fpsimd)
> +	// x0: cpu context address
> +	// x1, x2: tmp regs
> +	add	x1, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> +	fpsimd_restore x1, 2
> +	ret
> +END(__kvm_restore_fpsimd)
> diff --git a/arch/arm64/kvm/handle_fpsimd.c b/arch/arm64/kvm/handle_fpsimd.c
> new file mode 100644
> index 0000000..3d34cc9
> --- /dev/null
> +++ b/arch/arm64/kvm/handle_fpsimd.c
> @@ -0,0 +1,42 @@
> +/*
> + * Copyright (C) 2015 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
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
> +void kvm_fpsimd_flush_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	__kvm_save_fpsimd(vcpu->arch.host_cpu_context);
> +	__kvm_restore_fpsimd(&vcpu->arch.ctxt);
> +
> +	local_irq_restore(flags);
> +}
> +
> +void kvm_fpsimd_sync_hwstate(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	__kvm_save_fpsimd(&vcpu->arch.ctxt);
> +	__kvm_restore_fpsimd(vcpu->arch.host_cpu_context);
> +
> +	local_irq_restore(flags);
> +}
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index 5befd01..425c1ad 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -21,7 +21,6 @@
>  #include <asm/assembler.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/esr.h>
> -#include <asm/fpsimdmacros.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> @@ -102,20 +101,6 @@
>  	restore_common_regs
>  .endm
>  
> -.macro save_fpsimd
> -	// x2: cpu context address
> -	// x3, x4: tmp regs
> -	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> -	fpsimd_save x3, 4
> -.endm
> -
> -.macro restore_fpsimd
> -	// x2: cpu context address
> -	// x3, x4: tmp regs
> -	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> -	fpsimd_restore x3, 4
> -.endm
> -
>  .macro save_guest_regs
>  	// x0 is the vcpu address
>  	// x1 is the return code, do not corrupt!
> @@ -904,14 +889,6 @@ __restore_debug:
>  	restore_debug
>  	ret
>  
> -__save_fpsimd:
> -	save_fpsimd
> -	ret
> -
> -__restore_fpsimd:
> -	restore_fpsimd
> -	ret
> -
>  /*
>   * u64 __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>   *
> @@ -932,7 +909,6 @@ ENTRY(__kvm_vcpu_run)
>  	kern_hyp_va x2
>  
>  	save_host_regs
> -	bl __save_fpsimd
>  	bl __save_sysregs
>  
>  	compute_debug_state 1f
> @@ -948,7 +924,6 @@ ENTRY(__kvm_vcpu_run)
>  	add	x2, x0, #VCPU_CONTEXT
>  
>  	bl __restore_sysregs
> -	bl __restore_fpsimd
>  
>  	skip_debug_state x3, 1f
>  	bl	__restore_debug
> @@ -967,7 +942,6 @@ __kvm_vcpu_return:
>  	add	x2, x0, #VCPU_CONTEXT
>  
>  	save_guest_regs
> -	bl __save_fpsimd
>  	bl __save_sysregs
>  
>  	skip_debug_state x3, 1f
> @@ -986,7 +960,6 @@ __kvm_vcpu_return:
>  	kern_hyp_va x2
>  
>  	bl __restore_sysregs
> -	bl __restore_fpsimd
>  
>  	skip_debug_state x3, 1f
>  	// Clear the dirty flag for the next run, as all the state has
> 
