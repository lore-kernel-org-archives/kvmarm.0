From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH v2 2/3] KVM: arm64: Convert lazy FPSIMD context switch
 trap to C
Date: Fri, 6 Apr 2018 16:25:57 +0100
Message-ID: <5da0c912-8adb-db89-08b1-fb557b461678@arm.com>
References: <1523026864-15413-1-git-send-email-Dave.Martin@arm.com>
 <1523026864-15413-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1523026864-15413-3-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 06/04/18 16:01, Dave Martin wrote:
> To make the lazy FPSIMD context switch trap code easier to hack on,
> this patch converts it to C.
> 
> This is not amazingly efficient, but the trap should typically only
> be taken once per host context switch.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> ---
> 
> Since RFCv1:
> 
>  * Fix indentation to be consistent with the rest of the file.
>  * Add missing ! to write back to sp with attempting to push regs.
> ---
>  arch/arm64/kvm/hyp/entry.S  | 57 +++++++++++++++++----------------------------
>  arch/arm64/kvm/hyp/switch.c | 24 +++++++++++++++++++
>  2 files changed, 46 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index fdd1068..47c6a78 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -176,41 +176,28 @@ ENTRY(__fpsimd_guest_restore)
>  	// x1: vcpu
>  	// x2-x29,lr: vcpu regs
>  	// vcpu x0-x1 on the stack
> -	stp	x2, x3, [sp, #-16]!
> -	stp	x4, lr, [sp, #-16]!
> -
> -alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> -	mrs	x2, cptr_el2
> -	bic	x2, x2, #CPTR_EL2_TFP
> -	msr	cptr_el2, x2
> -alternative_else
> -	mrs	x2, cpacr_el1
> -	orr	x2, x2, #CPACR_EL1_FPEN
> -	msr	cpacr_el1, x2
> -alternative_endif
> -	isb
> -
> -	mov	x3, x1
> -
> -	ldr	x0, [x3, #VCPU_HOST_CONTEXT]
> -	kern_hyp_va x0
> -	add	x0, x0, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> -	bl	__fpsimd_save_state
> -
> -	add	x2, x3, #VCPU_CONTEXT
> -	add	x0, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
> -	bl	__fpsimd_restore_state
> -
> -	// Skip restoring fpexc32 for AArch64 guests
> -	mrs	x1, hcr_el2
> -	tbnz	x1, #HCR_RW_SHIFT, 1f
> -	ldr	x4, [x3, #VCPU_FPEXC32_EL2]
> -	msr	fpexc32_el2, x4
> -1:
> -	ldp	x4, lr, [sp], #16
> -	ldp	x2, x3, [sp], #16
> -	ldp	x0, x1, [sp], #16
> -
> +	stp	x2, x3, [sp, #-144]!
> +	stp	x4, x5, [sp, #16]
> +	stp	x6, x7, [sp, #32]
> +	stp	x8, x9, [sp, #48]
> +	stp	x10, x11, [sp, #64]
> +	stp	x12, x13, [sp, #80]
> +	stp	x14, x15, [sp, #96]
> +	stp	x16, x17, [sp, #112]
> +	stp	x18, lr, [sp, #128]
> +
> +	bl	__hyp_switch_fpsimd
> +
> +	ldp	x4, x5, [sp, #16]
> +	ldp	x6, x7, [sp, #32]
> +	ldp	x8, x9, [sp, #48]
> +	ldp	x10, x11, [sp, #64]
> +	ldp	x12, x13, [sp, #80]
> +	ldp	x14, x15, [sp, #96]
> +	ldp	x16, x17, [sp, #112]
> +	ldp	x18, lr, [sp, #128]
> +	ldp	x0, x1, [sp, #144]
> +	ldp	x2, x3, [sp], #160

I can't say I'm overly thrilled with adding another save/restore 
sequence. How about treating it like a real guest exit instead? Granted, 
there is a bit more overhead to it, but as you pointed out above, this 
should be pretty rare...

Something like this?

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f6648a3e4152..3c388f5c394f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -27,6 +27,7 @@
 #define ARM_EXCEPTION_IRQ	  0
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
+#define ARM_EXCEPTION_FP	  3
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index bffece27b5c1..e32dd00410f8 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -129,11 +129,12 @@ el1_trap:
 	 */
 alternative_if_not ARM64_HAS_NO_FPSIMD
 	cmp	x0, #ESR_ELx_EC_FP_ASIMD
-	b.eq	__fpsimd_guest_restore
+	mov	x0, #ARM_EXCEPTION_FP
+	b.eq	1f
 alternative_else_nop_endif
 
 	mov	x0, #ARM_EXCEPTION_TRAP
-	b	__guest_exit
+1:	b	__guest_exit
 
 el1_irq:
 	get_vcpu_ptr	x1, x0
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d9645236e474..50b98ac39480 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -325,6 +325,10 @@ static bool __hyp_text __skip_instr(struct kvm_vcpu *vcpu)
  */
 static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	if (ARM_EXCEPTION_CODE(*exit_code) == ARM_EXCEPTION_FP) {
+		__hyp_switch_fpsim(read_sysreg_el2(esr), vcpu);
+		return true;
+	}
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(esr);
 

>  	eret
>  ENDPROC(__fpsimd_guest_restore)
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 870f4b1..8605e04 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -440,6 +440,30 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  	return exit_code;
>  }
>  
> +void __hyp_text __hyp_switch_fpsimd(u64 esr __always_unused,
> +				    struct kvm_vcpu *vcpu)
> +{
> +	kvm_cpu_context_t *host_ctxt;
> +
> +	if (has_vhe())
> +		write_sysreg(read_sysreg(cpacr_el1) | CPACR_EL1_FPEN,
> +			     cpacr_el1);
> +	else
> +		write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP,
> +			     cptr_el2);
> +
> +	isb();
> +
> +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> +	__fpsimd_save_state(&host_ctxt->gp_regs.fp_regs);
> +	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
> +
> +	/* Skip restoring fpexc32 for AArch64 guests */
> +	if (!(read_sysreg(hcr_el2) & HCR_RW))
> +		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
> +			     fpexc32_el2);
> +}
> +
>  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
>  
>  static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
