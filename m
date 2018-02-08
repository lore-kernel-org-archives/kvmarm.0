From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v1 15/16] kvm: arm64: Allow configuring physical address
 space size
Date: Thu, 8 Feb 2018 17:53:17 +0000
Message-ID: <31e5bf40-4fcb-934e-6036-ff2670f793df@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-16-suzuki.poulose@arm.com> <20180208111414.GM29286@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180208111414.GM29286@cbox>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/02/18 11:14, Christoffer Dall wrote:
> On Tue, Jan 09, 2018 at 07:04:10PM +0000, Suzuki K Poulose wrote:
>> Allow the guests to choose a larger physical address space size.
>> The default and minimum size is 40bits. A guest can change this
>> right after the VM creation, but before the stage2 entry page
>> tables are allocated (i.e, before it registers a memory range
>> or maps a device address). The size is restricted to the maximum
>> supported by the host. Also, the guest can only increase the PA size,
>> from the existing value, as reducing it could break the devices which
>> may have verified their physical address for validity and may do a
>> lazy mapping(e.g, VGIC).
>>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <cdall@linaro.org>
>> Cc: Peter Maydell <peter.maydell@linaro.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   Documentation/virtual/kvm/api.txt | 27 ++++++++++++++++++++++++++
>>   arch/arm/include/asm/kvm_host.h   |  7 +++++++
>>   arch/arm64/include/asm/kvm_host.h |  1 +
>>   arch/arm64/include/asm/kvm_mmu.h  | 41 ++++++++++++++++++++++++++++++---------
>>   arch/arm64/kvm/reset.c            | 28 ++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h          |  4 ++++
>>   virt/kvm/arm/arm.c                |  2 +-
>>   7 files changed, 100 insertions(+), 10 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 57d3ee9e4bde..a203faf768c4 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -3403,6 +3403,33 @@ invalid, if invalid pages are written to (e.g. after the end of memory)
>>   or if no page table is present for the addresses (e.g. when using
>>   hugepages).
>>   
>> +4.109 KVM_ARM_GET_PHYS_SHIFT
>> +
>> +Capability: KVM_CAP_ARM_CONFIG_PHYS_SHIFT
>> +Architectures: arm64
>> +Type: vm ioctl
>> +Parameters: __u32 (out)
>> +Returns: 0 on success, a negative value on error
>> +
>> +This ioctl is used to get the current maximum physical address size for
>> +the VM. The value is Log2(Maximum_Physical_Address). This is neither the
>> + amount of physical memory assigned to the VM nor the maximum physical address
>> +that a real CPU on the host can handle. Rather, this is the upper limit of the
>> +guest physical address that can be used by the VM.
> 
> What is the point of this?  Presumably if userspace has set the size, it
> already knows the size?

This can help the userspace know, what the "default" limit is. As such I am
not particular about keeping this around.

> 
>> +
>> +4.109 KVM_ARM_SET_PHYS_SHIFT
>> +
>> +Capability: KVM_CAP_ARM_CONFIG_PHYS_SHIFT
>> +Architectures: arm64
>> +Type: vm ioctl
>> +Parameters: __u32 (in)
>> +Returns: 0 on success, a negative value on error
>> +
>> +This ioctl is used to set the maximum physical address size for
>> +the VM. The value is Log2(Maximum_Physical_Address). The value can only
>> +be increased from the existing setting. The value cannot be changed
>> +after the stage-2 page tables are allocated and will return an error.
>> +
> 
> Is there a way for userspace to discover what the underlying hardware
> can actually support, beyond trial-and-error on this ioctl?

Unfortunately, there is none. We don't expose ID_AA64MMFR0 via mrs emulation.

>> +static inline int kvm_reconfig_stage2(struct kvm *kvm, u32 phys_shift)
>> +{
>> +	int rc = 0;
>> +	unsigned int pa_max, parange;
>> +
>> +	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 7;
>> +	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
>> +	/* Raise it to 40bits for backward compatibility */
>> +	pa_max = (pa_max < 40) ? 40 : pa_max;
>> +	/* Make sure the size is supported/available */
>> +	if (phys_shift > PHYS_MASK_SHIFT || phys_shift > pa_max)
>> +		return -EINVAL;
>> +	/*
>> +	 * The stage2 PGD is dependent on the settings we initialise here
>> +	 * and should be allocated only after this step. We cannot allow
>> +	 * down sizing the IPA size as there could be devices or memory
>> +	 * regions, that depend on the previous size.
>> +	 */
>> +	mutex_lock(&kvm->slots_lock);
>> +	if (kvm->arch.pgd || phys_shift < kvm->arch.phys_shift) {
>> +		rc = -EPERM;
>> +	} else if (phys_shift > kvm->arch.phys_shift) {
>> +		kvm->arch.phys_shift = phys_shift;
>> +		kvm->arch.s2_levels = stage2_pt_levels(kvm->arch.phys_shift);
>> +		kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
>> +					 TCR_T0SZ(kvm->arch.phys_shift);
>> +	}
> 
> I think you can rework the above to make it more obvious what's going on
> in this way:
> 
> 	rc = -EPERM;
> 	if (kvm->arch.pgd || phys_shift < kvm->arch.phys_shift)
> 		goto out_unlock;
> 
> 	rc = 0;
> 	if (phys_shift == kvm->arch.phys_shift)
> 		goto out_unlock;
> 
> 	kvm->arch.phys_shift = phys_shift;
> 	kvm->arch.s2_levels = stage2_pt_levels(kvm->arch.phys_shift);
> 	kvm->arch.vtcr_private = VTCR_EL2_SL0(kvm->arch.s2_levels) |
> 				 TCR_T0SZ(kvm->arch.phys_shift);
> 
> out_unlock:
> 

Sure.



>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1136,7 +1136,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>>   		return 0;
>>   	}
>>   	default:
>> -		return -EINVAL;
>> +		return kvm_arch_dev_vm_ioctl(kvm, ioctl, arg);
>>   	}
>>   }
>>   
>> -- 
>> 2.13.6
>>
> 
> Have you considered making this capability a generic capability and
> encoding this in the 'type' argument to KVM_CREATE_VM?  This would
> significantly simplify all the above and would allow you to drop patch 8
> and 9 I think.

No. I will take a look. Btw, there were patches flying around to support
"userspace" requesting specific values for ID feature registers. But even that
doesn't help with the detection part. May be that is another way to configure
the size, but not sure about the current status of that work.

Cheers
Suzuki
