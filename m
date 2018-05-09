From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 11/15] KVM: arm64: Save host SVE context as appropriate
Date: Wed, 9 May 2018 09:50:26 +0100
Message-ID: <606acf08-5af7-8045-221d-73737e730c3c@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-12-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1525797900-5548-12-git-send-email-Dave.Martin@arm.com>
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

On 08/05/18 17:44, Dave Martin wrote:
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

I don't think the commit log now reflects the code, since we bail out at
init time and disable KVM altogether.

> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> 
> ---
> 
> Changes since v5:
> 
> Requested by Marc Zyngier:
> 
>  * Migrate to flag bits in vcpu_arch.flags instead of adding bools in
>    vcpu_arch.
> 
>  * Move system_supports_sve() && !has_vhe() sanity check to
>    kvm_arch_init() instead of doing it each time a VM is created.
>    cpufeatures initialisation should be complete by the time any
>    before module_init() call runs.
> ---
>  arch/arm64/Kconfig          |  7 +++++++
>  arch/arm64/kvm/fpsimd.c     |  1 -
>  arch/arm64/kvm/hyp/switch.c | 22 ++++++++++++++++++++--
>  virt/kvm/arm/arm.c          | 18 ++++++++++++++++++
>  4 files changed, 45 insertions(+), 3 deletions(-)
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
> index 7059275..4c47b55 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -60,7 +60,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>   */
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  {
> -	BUG_ON(system_supports_sve());
>  	BUG_ON(!current->mm);
>  
>  	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_HOST_SVE_IN_USE);
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 75c3b65..6826f2d 100644
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
> @@ -337,8 +341,22 @@ void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
>  
>  	isb();
>  
> -	if (vcpu->arch.host_fpsimd_state) {
> -		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
> +	if (host_fpsimd) {
> +		/*
> +		 * In the SVE case, VHE is assumed: it is enforced by
> +		 * Kconfig and kvm_arch_init_vm().

Nit: this is now kvm_arch_init().

> +		 */
> +		if (system_supports_sve() &&
> +		    (vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE)) {
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
> index bee226c..379e8a9 100644
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
> @@ -1582,6 +1584,22 @@ int kvm_arch_init(void *opaque)
>  		}
>  	}
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
> +		kvm_pr_unimpl("SVE system without VHE unsupported.  Broken cpu?");
> +		return -ENODEV;
> +	}
> +
>  	err = init_common_resources();
>  	if (err)
>  		return err;
> 

Otherwise:

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
