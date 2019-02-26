From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 3/6] arm64/kvm: context-switch ptrauth registers
Date: Tue, 26 Feb 2019 18:31:38 +0000
Message-ID: <2a4ce6c4-23be-3da3-02ca-e492d2dab763@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5E64A379
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 13:31:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U3G52aqnsrLy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 13:31:43 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3934A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 13:31:42 -0500 (EST)
In-Reply-To: <1550568271-5319-4-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/02/2019 09:24, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When pointer authentication is supported, a guest may wish to use it.
> This patch adds the necessary KVM infrastructure for this to work, with
> a semi-lazy context switch of the pointer auth state.
> 
> Pointer authentication feature is only enabled when VHE is built
> in the kernel and present into CPU implementation so only VHE code
> paths are modified.

> When we schedule a vcpu, we disable guest usage of pointer
> authentication instructions and accesses to the keys. While these are
> disabled, we avoid context-switching the keys. When we trap the guest
> trying to use pointer authentication functionality, we change to eagerly
> context-switching the keys, and enable the feature. The next time the
> vcpu is scheduled out/in, we start again.

> However the host key registers
> are saved in vcpu load stage as they remain constant for each vcpu
> schedule.

(I think we can get away with doing this later ... with the hope of doing it never!)


> Pointer authentication consists of address authentication and generic
> authentication, and CPUs in a system might have varied support for
> either. Where support for either feature is not uniform, it is hidden
> from guests via ID register emulation, as a result of the cpufeature
> framework in the host.
> 
> Unfortunately, address authentication and generic authentication cannot
> be trapped separately, as the architecture provides a single EL2 trap
> covering both. If we wish to expose one without the other, we cannot
> prevent a (badly-written) guest from intermittently using a feature
> which is not uniformly supported (when scheduled on a physical CPU which
> supports the relevant feature). Hence, this patch expects both type of
> authentication to be present in a cpu.


> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2f1bb86..1bacf78 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -146,6 +146,18 @@ enum vcpu_sysreg {

> +static inline bool kvm_supports_ptrauth(void)
> +{
> +	return has_vhe() && system_supports_address_auth() &&
> +				system_supports_generic_auth();
> +}

Do we intend to support the implementation defined algorithm? I'd assumed not.

system_supports_address_auth() is defined as:
| static inline bool system_supports_address_auth(void)
| {
| 	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
| 		(cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH_ARCH) ||
| 		cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH_IMP_DEF));
| }


So we could return true from kvm_supports_ptrauth() even if we only support the imp-def
algorithm.

I think we should hide the imp-def ptrauth support as KVM hides all other imp-def
features. This lets us avoid trying to migrate values that have been signed with the
imp-def algorithm.

I'm worried that it could include some value that we can't migrate (e.g. the SoC serial
number). Does the ARM-ARM say this can't happen?

All I can find is D5.1.5 "Pointer authentication in AArch64 state" of DDI0487D.a which has
this clause for the imp-def algorithm:
| For a set of arguments passed to the function, must give the same result for all PEs
| that a thread of execution could migrate between.

... with KVM we've extended the scope of migration significantly.


Could we check the cpus_have_const_cap() values for the two architected algorithms directly?


> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 6e65cad..09e061a 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -153,6 +153,13 @@ bool __fpsimd_enabled(void);
>  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
>  void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
>  
> +void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
> +			       struct kvm_cpu_context *host_ctxt,
> +			       struct kvm_cpu_context *guest_ctxt);
> +void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> +			      struct kvm_cpu_context *guest_ctxt,
> +			      struct kvm_cpu_context *host_ctxt);


Why do you need the vcpu and the guest_ctxt?
Would it be possible for these to just take the vcpu, and to pull the host context from
the per-cpu variable?
This would avoid any future bugs where the ctxt's are the wrong way round, taking two is
unusual in KVM, but necessary here.

As you're calling these from asm you want the compiler to do as much of the type mangling
as possible.


> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 4e2fb87..5cac605 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -749,6 +749,7 @@ static const char *esr_class_str[] = {
>  	[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
>  	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
>  	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
> +	[ESR_ELx_EC_PAC]		= "Pointer authentication trap",
>  	[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
>  	[ESR_ELx_EC_ILL]		= "PSTATE.IL",
>  	[ESR_ELx_EC_SVC32]		= "SVC (AArch32)",

Is this needed? Or was it just missing from the parts already merged. (should it be a
separate patch for the arch code)

It looks like KVM only prints it from kvm_handle_unknown_ec(), which would never happen as
arm_exit_handlers[] has an entry for ESR_ELx_EC_PAC.

Is it true that the host could never take this trap either?, as it can only be taken when
HCR_EL2.TGE is clear.
(breadcrumbs from the ESR_ELx definition to "Trap to EL2 of EL0 accesses to Pointer
authentication instructions")


> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 675fdc1..b78cc15 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -64,6 +64,12 @@ ENTRY(__guest_enter)
>  
>  	add	x18, x0, #VCPU_CONTEXT
>  
> +#ifdef	CONFIG_ARM64_PTR_AUTH
> +	// Prepare parameter for __ptrauth_switch_to_guest(vcpu, host, guest).
> +	mov	x2, x18
> +	bl	__ptrauth_switch_to_guest
> +#endif

This calls back into C code with x18 clobbered... is that allowed?
x18 has this weird platform-register/temporary-register behaviour, that depends on the
compiler. The PCS[0] has a note that 'hand-coded assembler should avoid it entirely'!

Can we assume that compiler generated code is using it from something, and depends on that
value, which means we need to preserve or save/restore it when calling into C.


The upshot? Could you use one of the callee saved registers instead of x18, then move it
after your C call.


> @@ -118,6 +124,17 @@ ENTRY(__guest_exit)
>  
>  	get_host_ctxt	x2, x3
>  
> +#ifdef	CONFIG_ARM64_PTR_AUTH
> +	// Prepare parameter for __ptrauth_switch_to_host(vcpu, guest, host).
> +	// Save x0, x2 which are used later in callee saved registers.
> +	mov	x19, x0
> +	mov	x20, x2
> +	sub	x0, x1, #VCPU_CONTEXT

> +	ldr	x29, [x2, #CPU_XREG_OFFSET(29)]

Is this to make the stack-trace look plausible?


> +	bl	__ptrauth_switch_to_host
> +	mov	x0, x19
> +	mov	x2, x20
> +#endif

(ditching the host_ctxt would let you move this above get_host_ctxt and the need to
preserve its result)


> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> new file mode 100644
> index 0000000..528ee6e
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -0,0 +1,101 @@

> +static __always_inline bool __ptrauth_is_enabled(struct kvm_vcpu *vcpu)

This __always_inline still looks weird! You said it might be needed to make it function
pointer safe. If it is, could you add a comment explaining why.

(alternatives would be making it an #ifdef, disabling ptrauth for the whole file, or
annotating this function too)


> +#define __ptrauth_save_key(regs, key)						\
> +({										\
> +	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> +	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> +})
> +
> +static __always_inline void __ptrauth_save_state(struct kvm_cpu_context *ctxt)
> +{
> +	__ptrauth_save_key(ctxt->sys_regs, APIA);
> +	__ptrauth_save_key(ctxt->sys_regs, APIB);
> +	__ptrauth_save_key(ctxt->sys_regs, APDA);
> +	__ptrauth_save_key(ctxt->sys_regs, APDB);
> +	__ptrauth_save_key(ctxt->sys_regs, APGA);
> +}
> +
> +#define __ptrauth_restore_key(regs, key) 					\
> +({										\
> +	write_sysreg_s(regs[key ## KEYLO_EL1], SYS_ ## key ## KEYLO_EL1);	\
> +	write_sysreg_s(regs[key ## KEYHI_EL1], SYS_ ## key ## KEYHI_EL1);	\
> +})
> +
> +static __always_inline void __ptrauth_restore_state(struct kvm_cpu_context *ctxt)
> +{
> +	__ptrauth_restore_key(ctxt->sys_regs, APIA);
> +	__ptrauth_restore_key(ctxt->sys_regs, APIB);
> +	__ptrauth_restore_key(ctxt->sys_regs, APDA);
> +	__ptrauth_restore_key(ctxt->sys_regs, APDB);
> +	__ptrauth_restore_key(ctxt->sys_regs, APGA);

Are writes to these registers self synchronising? I'd assume not, as they come as a pair.

I think this means we need an isb() here to ensure that when restoring the host registers
the next host authentication attempt uses the key we wrote here? We don't need it for the
guest, so we could put it at the end of __ptrauth_switch_to_host().


> +/**
> + * This function changes the key so assign Pointer Authentication safe
> + * GCC attribute if protected by it.
> + */

... this comment is the reminder for 'once we have host kernel ptrauth support'? could we
add something to say that kernel support is when the attribute would be needed. Otherwise
it reads like we're waiting for GCC support.

(I assume LLVM has a similar attribute ... is it exactly the same?)


> +void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
> +				  struct kvm_cpu_context *host_ctxt,
> +				  struct kvm_cpu_context *guest_ctxt)
> +{

> +}

> +void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> +				 struct kvm_cpu_context *guest_ctxt,
> +				 struct kvm_cpu_context *host_ctxt)
> +{

> +}


Could you add NOKPROBE_SYMBOL(symbol_name) for these. This adds them to the kprobe
blacklist as they aren't part of the __hyp_text. (and don't need to be as its VHE only).
Without this, you can patch a software-breakpoint in here, which KVM won't handle as its
already switched VBAR for entry to the guest.

Details in 7d82602909ed ("KVM: arm64: Forbid kprobing of the VHE world-switch code")

(... this turned up in a kernel version later than you based on ...)


> +/**
> + * kvm_arm_vcpu_ptrauth_reset - resets ptrauth for vcpu schedule
> + *
> + * @vcpu: The VCPU pointer
> + *
> + * This function may be used to disable ptrauth and use it in a lazy context
> + * via traps. However host key registers are saved here as they dont change
> + * during host/guest switch.
> + */
> +void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *host_ctxt;
> +
> +	if (kvm_supports_ptrauth()) {
> +		kvm_arm_vcpu_ptrauth_disable(vcpu);
> +		host_ctxt = vcpu->arch.host_cpu_context;

> +		__ptrauth_save_state(host_ctxt);

Could you equally do this host-save in kvm_arm_vcpu_ptrauth_trap() before
kvm_arm_vcpu_ptrauth_enable()? This would avoid saving the keys if the guest never gets
the opportunity to change them. At the moment we do it on every vcpu_load().


As kvm_arm_vcpu_ptrauth_reset() isn't used as part of the world-switch, could we keep it
outside the 'hyp' directory? The Makefile for that directory expects to be building the
hyp text, so it disables KASAN, KCOV and friends.
kvm_arm_vcpu_ptrauth_reset() is safe for all of these, and its good for it to be covered
by this debug infrastructure. Could you move it to guest.c?


> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a6c9381..12529df 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c> @@ -1045,9 +1071,10 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>  					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
>  					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> -		if (val & ptrauth_mask)
> +		if (!kvm_supports_ptrauth()) {
>  			kvm_debug("ptrauth unsupported for guests, suppressing\n");
> -		val &= ~ptrauth_mask;
> +			val &= ~ptrauth_mask;
> +		}

This means that debug message gets printed even on systems that don't support ptrauth in
hardware. (val&ptrauth_mask) used to cut them out, now kvm_supports_ptrauth() fails if the
static keys are false, and we end up printing this message.
Now that KVM supports pointer-auth, I don't think the debug message is useful, can we
remove it? (it would now mean 'you didn't ask for ptrauth to be turned on')


Could we always mask out the imp-def bits?


This patch needs to be merged together with 4 & 5 so the user-abi is as it should be. This
means the check_present/restrictions thing needs sorting so they're ready together.


Thanks,

James


[0] http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055b/IHI0055B_aapcs64.pdf
