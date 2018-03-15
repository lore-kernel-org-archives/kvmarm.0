From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v10 3/5] arm/arm64: KVM: Introduce set and get per-vcpu
 event
Date: Thu, 15 Mar 2018 20:38:54 +0000
Message-ID: <5AAAD9DE.9030001@arm.com>
References: <1520093380-42577-1-git-send-email-gengdongjiu@huawei.com> <1520093380-42577-4-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520093380-42577-4-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dongjiu Geng,

On 03/03/18 16:09, Dongjiu Geng wrote:
> RAS Extension provides VSESR_EL2 register to specify
> virtual SError syndrome value, this patch adds a new
> IOCTL to export user-invisible states related to
> SError exceptions. User space can setup the
> kvm_vcpu_events to inject specified SError, also it
> can support live migration.

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 8a3d708..26ae151 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -819,11 +819,13 @@ struct kvm_clock_data {
>  
>  Capability: KVM_CAP_VCPU_EVENTS
>  Extended by: KVM_CAP_INTR_SHADOW
> -Architectures: x86
> +Architectures: x86, arm, arm64
>  Type: vm ioctl
>  Parameters: struct kvm_vcpu_event (out)
>  Returns: 0 on success, -1 on error
>  
> +X86:
> +
>  Gets currently pending exceptions, interrupts, and NMIs as well as related
>  states of the vcpu.
>  
> @@ -865,15 +867,29 @@ Only two fields are defined in the flags field:
>  - KVM_VCPUEVENT_VALID_SMM may be set in the flags field to signal that
>    smi contains a valid state.
>  
> +ARM, ARM64:
> +
> +Gets currently pending SError exceptions as well as related states of the vcpu.
> +
> +struct kvm_vcpu_events {
> +       struct {
> +               bool serror_pending;
> +               bool serror_has_esr;
> +               u64 serror_esr;
> +       } exception;
> +};

Don't put bool in an ABI struct. The encoding is up to the compiler.
The compiler will insert padding in this struct to make serror_esr naturally
aligned. Different compilers may do it differently. You'll see that the existing
struct kvm_vcpu_events has 'pad' fields to ensure each element in the struct is
naturally aligned.

serror_pending and serror_has_esr need to be in a flags field.

I thought the logic for re-using the CAP was so user-space could re-use
save/restore code to transfer whatever we put in here during migration. If the
struct is a different size the code has to be different anyway.
My understanding of Drew and Christoffer's comments was that we should re-use
the existing struct. (but now that I look at it, its not so clear).

(If we reuse the struct, we can put the esr in exception.error_code, if we can
get away with it: It would be good to union exception up with a u64, then use
that. This would let us transfer anything we need in those RES0 bits of the
64bit VSESR_EL2).


>  4.32 KVM_SET_VCPU_EVENTS
>  
>  Capability: KVM_CAP_VCPU_EVENTS
>  Extended by: KVM_CAP_INTR_SHADOW
> -Architectures: x86
> +Architectures: x86, arm, arm64
>  Type: vm ioctl
>  Parameters: struct kvm_vcpu_event (in)
>  Returns: 0 on success, -1 on error
>  
> +X86:
> +
>  Set pending exceptions, interrupts, and NMIs as well as related states of the
>  vcpu.
>  
> @@ -894,6 +910,12 @@ shall be written into the VCPU.
>  
>  KVM_VCPUEVENT_VALID_SMM can only be set if KVM_CAP_X86_SMM is available.
>  
> +ARM, ARM64:
> +
> +Set pending SError exceptions as well as related states of the vcpu.
> +
> +See KVM_GET_VCPU_EVENTS for the data structure.
> +
>  
>  4.33 KVM_GET_DEBUGREGS
>  

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9abbf30..32c0eae 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -39,6 +39,7 @@
>  #define __KVM_HAVE_GUEST_DEBUG
>  #define __KVM_HAVE_IRQ_LINE
>  #define __KVM_HAVE_READONLY_MEM
> +#define __KVM_HAVE_VCPU_EVENTS
>  
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>  
> @@ -153,6 +154,15 @@ struct kvm_sync_regs {
>  struct kvm_arch_memory_slot {
>  };
>  
> +/* for KVM_GET/SET_VCPU_EVENTS */
> +struct kvm_vcpu_events {
> +	struct {
> +		bool serror_pending;
> +		bool serror_has_esr;
> +		u64 serror_esr;
> +	} exception;
> +};
> +

>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
>  #define KVM_REG_ARM_COPROC_SHIFT	16
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5c7f657..62d49c2 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -277,6 +277,32 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>  	return -EINVAL;
>  }
>  
> +int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
> +			struct kvm_vcpu_events *events)
> +{
> +	events->exception.serror_pending = (vcpu_get_hcr(vcpu) & HCR_VSE);
> +	events->exception.serror_has_esr =
> +			cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
> +					(!!vcpu_get_vsesr(vcpu));
> +	events->exception.serror_esr = vcpu_get_vsesr(vcpu);
> +
> +	return 0;

Nothing checks the return value. Why is it here?

> +}
> +
> +int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> +			struct kvm_vcpu_events *events)
> +{
> +	bool injected = events->exception.serror_pending;
> +	bool has_esr = events->exception.serror_has_esr;

Could you validate 'events' describes something we support. What if
cpus_have_const_cap(ARM64_HAS_RAS_EXTN) is false, we still call kvm_set_sei_esr().

Please check any parts of the struct that should be zero, are zero. This lets us
add new features, and reject attempts to migrate them (instead of silently
ignoring them).


> +	if (injected && has_esr)
> +		kvm_set_sei_esr(vcpu, events->exception.serror_esr);
> +	else if (injected)
> +		kvm_inject_vabt(vcpu);
> +
> +	return 0;

Nothing checks the return value. Why is it here?


> +}
> +
>  int __attribute_const__ kvm_target_cpu(void)
>  {
>  	unsigned long implementor = read_cpuid_implementor();


> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 7e3941f..30c56e0 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1051,6 +1051,24 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			return -EFAULT;
>  		return kvm_arm_vcpu_has_attr(vcpu, &attr);
>  	}
> +	case KVM_GET_VCPU_EVENTS: {
> +		struct kvm_vcpu_events events;

Please initialise events to 0 so that padding transferred to user-space doesn't
contain kernel stack.


> +		kvm_arm_vcpu_get_events(vcpu, &events);
> +
> +		if (copy_to_user(argp, &events, sizeof(struct kvm_vcpu_events)))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +	case KVM_SET_VCPU_EVENTS: {
> +		struct kvm_vcpu_events events;
> +
> +		if (copy_from_user(&events, argp, sizeof(struct kvm_vcpu_events)))
> +			return -EFAULT;
> +
> +		return kvm_arm_vcpu_set_events(vcpu, &events);
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> 

Thanks,

James
