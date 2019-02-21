From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v6 3/6] arm64/kvm: context-switch ptrauth registers
Date: Thu, 21 Feb 2019 12:29:42 +0000
Message-ID: <20190221122942.GC33673@lakrids.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550568271-5319-4-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 19, 2019 at 02:54:28PM +0530, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When pointer authentication is supported, a guest may wish to use it.
> This patch adds the necessary KVM infrastructure for this to work, with
> a semi-lazy context switch of the pointer auth state.
> 
> Pointer authentication feature is only enabled when VHE is built
> in the kernel and present into CPU implementation so only VHE code
> paths are modified.

Nit: s/into/in the/

> 
> When we schedule a vcpu, we disable guest usage of pointer
> authentication instructions and accesses to the keys. While these are
> disabled, we avoid context-switching the keys. When we trap the guest
> trying to use pointer authentication functionality, we change to eagerly
> context-switching the keys, and enable the feature. The next time the
> vcpu is scheduled out/in, we start again. However the host key registers
> are saved in vcpu load stage as they remain constant for each vcpu
> schedule.
> 
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
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> [Only VHE, key switch from from assembly, kvm_supports_ptrauth
> checks, save host key in vcpu_load]

Hmm, why do we need to do the key switch in assembly, given it's not
used in-kernel right now?

Is that in preparation for in-kernel pointer auth usage? If so, please
call that out in the commit message.

[...]

> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 4e2fb87..5cac605 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -749,6 +749,7 @@ static const char *esr_class_str[] = {
>  	[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
>  	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
>  	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
> +	[ESR_ELx_EC_PAC]		= "Pointer authentication trap",

For consistency with the other strings, can we please make this "PAC"?

[...]

> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 82d1904..17cec99 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += switch.o
>  obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
>  obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>  obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
> +obj-$(CONFIG_KVM_ARM_HOST) += ptrauth-sr.o

Huh, so we're actually doing the switch in C code...

>  # KVM code is run at a different exception code with a different map, so
>  # compiler instrumentation that inserts callbacks or checks into the code may
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

... and conditionally *calling* that switch code from assembly ...

> +
>  	// Restore guest regs x0-x17
>  	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
>  	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
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
> +	bl	__ptrauth_switch_to_host
> +	mov	x0, x19
> +	mov	x2, x20
> +#endif

... which adds a load of boilerplate for no immediate gain.

Do we really need to do this in assembly today?

Thanks,
Mark.
