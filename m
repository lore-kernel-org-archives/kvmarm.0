From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Thu, 28 Mar 2019 18:51:25 +0000
Message-ID: <9d929db6-2a24-b356-6c76-8f58341db4bc@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When pointer authentication is supported, a guest may wish to use it.
> This patch adds the necessary KVM infrastructure for this to work, with
> a semi-lazy context switch of the pointer auth state.
> 
> Pointer authentication feature is only enabled when VHE is built
> in the kernel and present in the CPU implementation so only VHE code
> paths are modified.
> 
> When we schedule a vcpu, we disable guest usage of pointer
> authentication instructions and accesses to the keys. While these are
> disabled, we avoid context-switching the keys. When we trap the guest
> trying to use pointer authentication functionality, we change to eagerly
> context-switching the keys, and enable the feature. The next time the
> vcpu is scheduled out/in, we start again. However the host key save is
> optimized and implemented inside ptrauth instruction/register access
> trap.
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
> This switch of key is done from guest enter/exit assembly as preperation
> for the upcoming in-kernel pointer authentication support. Hence, these
> key switching routines are not implemented in C code as they may cause
> pointer authentication key signing error in some situations.


> diff --git a/arch/arm64/include/asm/kvm_ptrauth_asm.h b/arch/arm64/include/asm/kvm_ptrauth_asm.h
> new file mode 100644
> index 0000000..97bb040
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_ptrauth_asm.h

> +.macro	ptrauth_save_state base, reg1, reg2
> +	mrs_s	\reg1, SYS_APIAKEYLO_EL1
> +	mrs_s	\reg2, SYS_APIAKEYHI_EL1
> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]

A nice-to-have:
Because you only use the 'LO' asm-offset definitions here, we have to just assume that the
'HI' ones are adjacent. Is it possible to add a BUILD_BUG() somewhere (probably in
asm-offsets.c) to check this? As its just an enum we'd expect the order to be arbitrary,
and asm-offsets to take care of any re-ordering... (struct randomisation may one day come
to enums!)


> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e2f0268..9f591ad 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -544,3 +544,17 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  
>  	return ret;
>  }
> +
> +/**
> + * kvm_arm_vcpu_ptrauth_setup_lazy - setup lazy ptrauth for vcpu schedule
> + *
> + * @vcpu: The VCPU pointer
> + *
> + * This function may be used to disable ptrauth and use it in a lazy context
> + * via traps.
> + */
> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_has_ptrauth(vcpu))
> +		kvm_arm_vcpu_ptrauth_disable(vcpu);
> +}

Can you check my reasoning here, to make sure I've understood this properly?!:

This clears the API/APK bits to enable the traps, if the system supports ptrauth, and if
Qemu requested it for this vcpu. If any of those things aren't true, the guest gets
HCR_GUEST_FLAGS, which also has the API/APK bits clear...

What this is doing is clearing the API/APK bits that may have been left set by a previous
run of a ptrauth-enabled vcpu.



> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f16a5f8..00f0639 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -128,6 +128,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	if (loaded)
>  		kvm_arch_vcpu_put(vcpu);
>
> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
> +		/* Verify that KVM startup matches the conditions for ptrauth */
> +		if (WARN_ON(!vcpu_has_ptrauth(vcpu)))
> +			return -EINVAL;
> +	}

Could this hunk go in the previous patch that added the vcpu definitions?
It would be good if the uapi defines, the documentation and this validation logic came as
one patch, it makes future archaeology easier!


Looks good!

Thanks,

James
