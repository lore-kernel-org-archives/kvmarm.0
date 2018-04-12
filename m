From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v11 2/4] arm/arm64: KVM: Add KVM_GET/SET_VCPU_EVENTS
Date: Thu, 12 Apr 2018 23:11:42 +0800
Message-ID: <CAMj-D2DR2H+6CW5QtZmT0HRptD1hxruNtq=cRpxD7ytqzQij9w@mail.gmail.com>
References: <1523309796-36423-1-git-send-email-gengdongjiu@huawei.com>
 <1523309796-36423-3-git-send-email-gengdongjiu@huawei.com> <d1d1c262-41ae-1725-7ae0-16d63ac3d372@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d1d1c262-41ae-1725-7ae0-16d63ac3d372@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, cdall@kernel.org
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, devel@acpica.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, corbet@lwn.net, marc.zyngier@arm.com, catalin.marinas@arm.com, rjw@rjwysocki.net, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, zhengxiang9@huawei.com, bp@alien8.de, linux-arm-kernel@lists.infradead.org, huangshaoyu@huawei.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, lenb@kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,
  Thanks for the comments.

2018-04-10 22:15 GMT+08:00, James Morse <james.morse@arm.com>:
> Hi Dongjiu Geng,
>
> On 09/04/18 22:36, Dongjiu Geng wrote:
>> This new IOCTL exports user-invisible states related to SError.
>> Together with appropriate user space changes, it can inject
>> SError with specified syndrome to guest by setup kvm_vcpu_events
>> value.
>
>> Also it can support live migration.
>
> Could you explain what user-space is expected to do for this?
> (this is also relevant for snapshot-ing/suspending VMs)
Ok.

>
> It's probably worth noting that this solves an existing problem: KVM may
> make an
> SError pending, but user-space has no way to discover/migrate this.

if KVM make an SError pending, when user-space do migration, it get the
kvm_vcpu_events through KVM_GET_VCPU_EVENTS, then can find that pending status.
What are the things you're worried about?

>
>
>> diff --git a/Documentation/virtual/kvm/api.txt
>> b/Documentation/virtual/kvm/api.txt
>> index 8a3d708..45719b4 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -819,11 +819,13 @@ struct kvm_clock_data {
>>
>>  Capability: KVM_CAP_VCPU_EVENTS
>>  Extended by: KVM_CAP_INTR_SHADOW
>> -Architectures: x86
>> +Architectures: x86, arm, arm64
>>  Type: vm ioctl
>>  Parameters: struct kvm_vcpu_event (out)
>>  Returns: 0 on success, -1 on error
>>
>> +X86:
>> +
>>  Gets currently pending exceptions, interrupts, and NMIs as well as
>> related
>>  states of the vcpu.
>>
>> @@ -865,15 +867,31 @@ Only two fields are defined in the flags field:
>>  - KVM_VCPUEVENT_VALID_SMM may be set in the flags field to signal that
>>    smi contains a valid state.
>>
>> +ARM, ARM64:
>> +
>> +Gets currently pending SError exceptions as well as related states of the
>> vcpu.
>> +
>> +struct kvm_vcpu_events {
>> +	struct {
>> +		__u8 serror_pending;
>> +		__u8 serror_has_esr;
>> +		/* Align it to 4 bytes */
>> +		__u8 pad[2];
>> +		__u64 serror_esr;
>> +	} exception;
>> +};
>> +
>
> I'm not convinced we should change this struct from the layout/size x86 has.
> Its
> confusing for the documentation, is this API call really the same on all
> architectures?
>
> What if we want to add some future interrupt, NMI or related state? We've
> found
> ourselves needing to add this API, it seems odd to remove its other uses on
> x86.
> We can't put them back in the future.
>
> Having a different layout would force user-space to ifdef/duplicate any
> code
> that accesses this between architectures.
 In x86 and arm64 user space code, the handling logic of
KVM_GET/SET_VCPU_EVENTS is in different ARCH folder,  maybe it is not
necessary to share the handling code in the user space.

>
>
>
> The compiler will want that __u64 to be naturally aligned to 8-bytes, so
> your
> 4-byte padding still causes some secret compiler-padding to be inserted.
> Different versions of the compiler may put it in different places.
>
>
>>  4.32 KVM_SET_VCPU_EVENTS
>>
>>  Capability: KVM_CAP_VCPU_EVENTS
>>  Extended by: KVM_CAP_INTR_SHADOW
>> -Architectures: x86
>> +Architectures: x86, arm, arm64
>>  Type: vm ioctl
>>  Parameters: struct kvm_vcpu_event (in)
>>  Returns: 0 on success, -1 on error
>>
>> +X86:
>> +
>>  Set pending exceptions, interrupts, and NMIs as well as related states of
>> the
>>  vcpu.
>>
>> @@ -894,6 +912,12 @@ shall be written into the VCPU.
>>
>>  KVM_VCPUEVENT_VALID_SMM can only be set if KVM_CAP_X86_SMM is available.
>>
>> +ARM, ARM64:
>> +
>> +Set pending SError exceptions as well as related states of the vcpu.
>> +
>> +See KVM_GET_VCPU_EVENTS for the data structure.
>> +
>>
>>  4.33 KVM_GET_DEBUGREGS
>>
>
>
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h
>> b/arch/arm64/include/uapi/asm/kvm.h
>> index 9abbf30..855cc9a 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -39,6 +39,7 @@
>>  #define __KVM_HAVE_GUEST_DEBUG
>>  #define __KVM_HAVE_IRQ_LINE
>>  #define __KVM_HAVE_READONLY_MEM
>> +#define __KVM_HAVE_VCPU_EVENTS
>>
>>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>>
>> @@ -153,6 +154,17 @@ struct kvm_sync_regs {
>>  struct kvm_arch_memory_slot {
>>  };
>>
>> +/* for KVM_GET/SET_VCPU_EVENTS */
>> +struct kvm_vcpu_events {
>> +	struct {
>> +		__u8 serror_pending;
>> +		__u8 serror_has_esr;
>
>> +		/* Align it to 4 bytes */
>> +		__u8 pad[2];
>
> (padding noted above)
>
>
>> +		__u64 serror_esr;
>> +	} exception;
>> +};
>> +
>>  /* If you need to interpret the index values, here is the key: */
>>  #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
>>  #define KVM_REG_ARM_COPROC_SHIFT	16
>
>
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> index 5c7f657..42e1222 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -277,6 +277,37 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu
>> *vcpu,
>>  	return -EINVAL;
>>  }
>>
>> +int kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
>> +			struct kvm_vcpu_events *events)
>> +{
>> +	events->exception.serror_pending = (vcpu_get_hcr(vcpu) & HCR_VSE);
>> +	events->exception.serror_has_esr =
>> +			cpus_have_const_cap(ARM64_HAS_RAS_EXTN) &&
>> +					(!!vcpu_get_vsesr(vcpu));
>
>> +	events->exception.serror_esr = vcpu_get_vsesr(vcpu);
>
> This will return a stale ESR even if nothing is pending. On systems without
> the
> RAS extensions it will return 'ESR_ELx_ISV' if kvm_inject_vabt() has ever
> been
> called for this CPU.
>
> Could we hide this behind (pending && has_esr), setting it to 0 otherwise.
> This
> is just to avoid exposing the stale value.
Exactly, it is indeed.

>
>
>> +
>> +	return 0;
>> +}
>
>> +int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>> +			struct kvm_vcpu_events *events)
>> +{
>> +	bool injected = events->exception.serror_pending;
>> +	bool has_esr = events->exception.serror_has_esr;
>> +
>> +	if (injected && has_esr) {
>> +		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
>> +			return -EINVAL;
>> +
>> +		kvm_set_sei_esr(vcpu, events->exception.serror_esr);
>> +
>> +	} else if (injected) {
>> +		kvm_inject_vabt(vcpu);
>
> Nit: looks like 'injected' is misnamed.

"injected" change to "pending"?

>
>
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  int __attribute_const__ kvm_target_cpu(void)
>>  {
>>  	unsigned long implementor = read_cpuid_implementor();
>
>
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 38c8a64..20e919a 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -82,6 +82,7 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm,
>> long ext)
>>  		break;
>>  	case KVM_CAP_SET_GUEST_DEBUG:
>>  	case KVM_CAP_VCPU_ATTRIBUTES:
>> +	case KVM_CAP_VCPU_EVENTS:
>>  		r = 1;
>>  		break;
>>  	default:
>
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 7e3941f..945655d 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1051,6 +1051,27 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  			return -EFAULT;
>>  		return kvm_arm_vcpu_has_attr(vcpu, &attr);
>>  	}
>> +	case KVM_GET_VCPU_EVENTS: {
>> +		struct kvm_vcpu_events events;
>> +
>> +		memset(&events, 0, sizeof(struct kvm_vcpu_events));
>
> sizeof(events) is the normal style here, it means if someone changes
> event's
> type we don't get any surprises...

Ok, thanks

>
>
>> +		if (kvm_arm_vcpu_get_events(vcpu, &events))
>> +			return -EINVAL;
>> +
>> +		if (copy_to_user(argp, &events, sizeof(struct kvm_vcpu_events)))
>
> sizeof(events)
thanks

>
>
>> +			return -EFAULT;
>> +
>> +		return 0;
>> +	}
>> +	case KVM_SET_VCPU_EVENTS: {
>> +		struct kvm_vcpu_events events;
>> +
>> +		if (copy_from_user(&events, argp,
>> +				sizeof(struct kvm_vcpu_events)))
>> +			return -EFAULT;
>> +
>> +		return kvm_arm_vcpu_set_events(vcpu, &events);
>> +	}
>>  	default:
>>  		return -EINVAL;
>>  	}
>>
>
> Despite KVM_CAP_VCPU_EVENTS not being advertised on 32bit, any attempt to
> call
> it will still end up in here, but will always fail as the {g,s}et_events()
> calls
> always return -EINVAL. I don't think this will cause us any problems.
What are the things you're worried about?

>
>
> Thanks,
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>
