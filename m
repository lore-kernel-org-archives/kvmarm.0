From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 10/14] KVM: arm64: Save host SVE context as appropriate
Date: Tue, 8 May 2018 11:38:05 +0100
Message-ID: <0c616c43-3bff-1c93-0463-fae1c53c0e51@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
 <1525449935-31424-11-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525449935-31424-11-git-send-email-Dave.Martin@arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/18 17:05, Dave Martin wrote:
> This patch adds SVE context saving to the hyp FPSIMD context switch
> path.  This means that it is no longer necessary to save the host
> SVE state in advance of entering the guest, when in use.
> 
> In order to avoid adding pointless complexity to the code, VHE is
> assumed if SVE is in use.  VHE is an architectural prerequisite for
> SVE, so there is no good reason to turn CONFIG_ARM64_VHE off in
> kernels that support both SVE and KVM.
> 
> Historically, software models exist that can expose the
> architecturally invalid configuration of SVE without VHE, so if
> this situation is detected this patch warns and refuses to create a
> VM.  Doing this check at VM creation time avoids race issues
> between KVM and SVE initialisation.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>  arch/arm64/Kconfig          |  7 +++++++
>  arch/arm64/kvm/fpsimd.c     |  1 -
>  arch/arm64/kvm/hyp/switch.c | 21 +++++++++++++++++++--
>  virt/kvm/arm/arm.c          | 18 ++++++++++++++++++
>  4 files changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index eb2cf49..b0d3820 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1130,6 +1130,7 @@ endmenu
>  config ARM64_SVE
>  	bool "ARM Scalable Vector Extension support"
>  	default y
> +	depends on !KVM || ARM64_VHE

In that case, should we consider making ARM64_VHE "default y" as well,
as KVM is "default y" too?

Otherwise, I fear we end-up regressing existing configurations. Also,
you still have to check for the configuration at run time, so I'm not
immediately getting the point of this particular change.

>  	help
>  	  The Scalable Vector Extension (SVE) is an extension to the AArch64
>  	  execution state which complements and extends the SIMD functionality
> @@ -1155,6 +1156,12 @@ config ARM64_SVE
>  	  booting the kernel.  If unsure and you are not observing these
>  	  symptoms, you should assume that it is safe to say Y.
>  
> +	  CPUs that support SVE are architecturally required to support the
> +	  Virtualization Host Extensions (VHE), so the kernel makes no
> +	  provision for supporting SVE alongside KVM without VHE enabled.
> +	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to support
> +	  KVM in the same kernel image.
> +
>  config ARM64_MODULE_PLTS
>  	bool
>  	select HAVE_MOD_ARCH_SPECIFIC
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index bbc6889..91ad01f 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -59,7 +59,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>   */
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  {
> -	BUG_ON(system_supports_sve());
>  	BUG_ON(!current->mm);
>  
>  	vcpu->arch.fp_enabled = false;
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 10f55d3..8009126 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -21,12 +21,14 @@
>  
>  #include <kvm/arm_psci.h>
>  
> +#include <asm/cpufeature.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/fpsimd.h>
>  #include <asm/debug-monitors.h>
> +#include <asm/processor.h>
>  #include <asm/thread_info.h>
>  
>  static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
> @@ -328,6 +330,8 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
>  void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  				    struct kvm_vcpu *vcpu)
>  {
> +	struct user_fpsimd_state *host_fpsimd = vcpu->arch.host_fpsimd_state;
> +
>  	if (has_vhe())
>  		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
>  			     cpacr_el1);
> @@ -337,8 +341,21 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  
>  	isb();
>  
> -	if (vcpu->arch.host_fpsimd_state) {
> -		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> +	if (host_fpsimd) {
> +		/*
> +		 * In the SVE case, VHE is assumed: it is enforced by
> +		 * Kconfig and kvm_arch_init_vm().
> +		 */
> +		if (system_supports_sve() && vcpu->arch.host_sve_in_use) {
> +			struct thread_struct *thread = container_of(
> +				host_fpsimd,
> +				struct thread_struct, uw.fpsimd_state);
> +
> +			sve_save_state(sve_pffr(thread), &host_fpsimd->fpsr);
> +		} else {
> +			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> +		}
> +
>  		vcpu->arch.host_fpsimd_state = NULL;
>  	}
>  
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 6cf499b..a7be7bf 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -16,6 +16,7 @@
>   * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
>   */
>  
> +#include <linux/bug.h>
>  #include <linux/cpu_pm.h>
>  #include <linux/errno.h>
>  #include <linux/err.h>
> @@ -41,6 +42,7 @@
>  #include <asm/mman.h>
>  #include <asm/tlbflush.h>
>  #include <asm/cacheflush.h>
> +#include <asm/cpufeature.h>
>  #include <asm/virt.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> @@ -120,6 +122,22 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	if (type)
>  		return -EINVAL;
>  
> +	/*
> +	 * VHE is a prerequisite for SVE in the Arm architecture, and
> +	 * Kconfig ensures that if system_supports_sve() here then
> +	 * CONFIG_ARM64_VHE is enabled, so if VHE support wasn't already
> +	 * detected and enabled, the CPU is architecturally
> +	 * noncompliant.
> +	 *
> +	 * Just in case this mismatch is seen, detect it, warn and give
> +	 * up.  Supporting this forbidden configuration in Hyp would be
> +	 * pointless.
> +	 */
> +	if (system_supports_sve() && !has_vhe()) {
> +		kvm_pr_unimpl("Cannot create VMs on SVE system without VHE.  Broken cpu?");
> +		return -ENXIO;
> +	}

You might as well fail the boot KVM initialization altogether, and not
wait for a VM to be created.

But I'm more concerned with the fact that we're now have a configuration
that drops functionalities on the floor, one way or another.

> +
>  	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
>  	if (!kvm->arch.last_vcpu_ran)
>  		return -ENOMEM;
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
