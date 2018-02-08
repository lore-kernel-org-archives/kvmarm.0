From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v1 09/16] kvm: arm/arm64: Delay stage2 page table
 allocation
Date: Thu, 8 Feb 2018 17:20:57 +0000
Message-ID: <53d91b79-67f3-c86f-8cda-d18939cfcaf8@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-10-suzuki.poulose@arm.com> <20180208110114.GL29286@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180208110114.GL29286@cbox>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/02/18 11:01, Christoffer Dall wrote:
> On Tue, Jan 09, 2018 at 07:04:04PM +0000, Suzuki K Poulose wrote:
>> We allocate the entry level page tables for stage2 when the
>> VM is created. This doesn't give us the flexibility of configuring
>> the physical address space size for a VM. In order to allow
>> the VM to choose the required size, we delay the allocation of
>> stage2 entry level tables until we really try to map something.
>>
>> This could be either when the VM creates a memory range or when
>> it tries to map a device memory. So we add in a hook to these
>> two places to make sure the tables are allocated. We use
>> kvm->slots_lock to serialize the allocation entry point, since
>> we add hooks to the arch specific call back with the mutex held.

...

>>   
>> -/**
>> - * kvm_phys_addr_ioremap - map a device range to guest IPA
>> - *
>> - * @kvm:	The KVM pointer
>> - * @guest_ipa:	The IPA at which to insert the mapping
>> - * @pa:		The physical address of the device
>> - * @size:	The size of the mapping
>> +/*
>> + * Finalise the stage2 page table layout. Must be called with kvm->slots_lock
>> + * held.
>>    */
>> -int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>> +static int __kvm_init_stage2_table(struct kvm *kvm)
>> +{
>> +	/* Double check if somebody has already allocated it */
> 
> dubious comment: Either leave it out or explain that we need to check
> again with the mutex held.
> 
>> +	if (likely(kvm->arch.pgd))
>> +		return 0;
>> +	return kvm_alloc_stage2_pgd(kvm);
>> +}
>> +
>> +static int kvm_init_stage2_table(struct kvm *kvm)
>> +{
>> +	int rc;
>> +
>> +	/*
>> +	 * Once allocated, the stage2 entry level tables are only
>> +	 * freed when the KVM instance is destroyed. So, if we see
>> +	 * something valid here, that guarantees that we have
>> +	 * done the one time allocation and it is something valid
>> +	 * and won't go away until the last reference to the KVM
>> +	 * is gone.
>> +	 */
> 
> Really not sure if this comment adds something beyond what's described
> by the code already?

Agreed. Will clean it up.

Thanks

Suzuki
