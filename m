From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 13/17] kvm: arm/arm64: Allow tuning the physical
 address size for VM
Date: Wed, 25 Apr 2018 17:22:33 +0100
Message-ID: <ff0cf970-fd2e-faf7-42cd-5b097158276b@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
 <1522156531-28348-14-git-send-email-suzuki.poulose@arm.com>
 <81e98b32-8c13-3688-209f-2d51b2237748@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <81e98b32-8c13-3688-209f-2d51b2237748@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, ard.biesheuvel@linaro.org, cdall@kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 25/04/18 17:10, Julien Grall wrote:
> Hi Suzuki,
> 
> On 27/03/18 14:15, Suzuki K Poulose wrote:
>> Allow specifying the physical address size for a new VM via
>> the kvm_type argument for KVM_CREATE_VM ioctl. This allows
>> us to finalise the stage2 page table format as early as possible
>> and hence perform the right checks on the memory slots without
>> complication. The size is encoded as Log2(PA_Siz) in the bits[7:0]
> 
> s/PA_Siz/PA_Size/.
> 

>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -740,6 +740,16 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_S390_SIE_PAGE_OFFSET 1
>>   /*
>> + * On arm/arm64, machine type can be used to request the physical
>> + * address size for the VM. Bits [7-0] have been reserved for the
>> + * PA size shift (i.e, log2(PA-Size)). For backward compatibility,
> 
> I would s/PA-Size/PA_Size/ to avoid the impression that it is a substraction.
> 

Agree.

>> + * value 0 implies the default IPA size, which is 40bits.
>> + */
>> +#define KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK    0xff
>> +#define KVM_VM_TYPE_ARM_PHYS_SHIFT(x)        \
>> +    ((x) & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK)
>> +
>> +/*
>>    * ioctls for /dev/kvm fds:
>>    */
>>   #define KVM_GET_API_VERSION       _IO(KVMIO,   0x00)
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 53bb05c..13eb66f 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -110,6 +110,25 @@ void kvm_arch_check_processor_compat(void *rtn)
>>   }
>> +static int kvm_arch_config_vm(struct kvm *kvm, unsigned long type)
>> +{
>> +    u32 ipa_shift = (u32)type & KVM_VM_TYPE_ARM_PHYS_SHIFT_MASK;
> 
> How about using KVM_VM_TYPE_ARM_PHYS_SHIFT(type) directly here?

Thanks for that, I have this already fixed in for v3.

>>   /**
>>    * kvm_arch_init_vm - initializes a VM data structure
>>    * @kvm:    pointer to the KVM struct
>> @@ -118,8 +137,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   {
>>       int ret, cpu;
>> -    if (type)
>> -        return -EINVAL;
>> +    ret = kvm_arch_config_vm(kvm, type);
>> +    if (ret)
>> +        return ret;
>>       kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
>>       if (!kvm->arch.last_vcpu_ran)
>>
> 
> Cheers,

Thanks for the review.

Cheers.
