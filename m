From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v1 15/16] kvm: arm64: Allow configuring physical address
 space size
Date: Thu, 15 Mar 2018 11:06:09 +0000
Message-ID: <b4cfa88c-a630-23bc-18f2-42400042ce4f@arm.com>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-16-suzuki.poulose@arm.com> <20180208111414.GM29286@cbox>
 <31e5bf40-4fcb-934e-6036-ff2670f793df@arm.com> <20180209081606.GC7339@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180209081606.GC7339@cbox>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/02/18 08:16, Christoffer Dall wrote:
> On Thu, Feb 08, 2018 at 05:53:17PM +0000, Suzuki K Poulose wrote:
>> On 08/02/18 11:14, Christoffer Dall wrote:
>>> On Tue, Jan 09, 2018 at 07:04:10PM +0000, Suzuki K Poulose wrote:
>>>> Allow the guests to choose a larger physical address space size.
>>>> The default and minimum size is 40bits. A guest can change this
>>>> right after the VM creation, but before the stage2 entry page
>>>> tables are allocated (i.e, before it registers a memory range
>>>> or maps a device address). The size is restricted to the maximum
>>>> supported by the host. Also, the guest can only increase the PA size,
>>> >from the existing value, as reducing it could break the devices which
>>>> may have verified their physical address for validity and may do a
>>>> lazy mapping(e.g, VGIC).
>>>>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Christoffer Dall <cdall@linaro.org>
>>>> Cc: Peter Maydell <peter.maydell@linaro.org>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

>>>> +
>>>> +4.109 KVM_ARM_SET_PHYS_SHIFT
>>>> +
>>>> +Capability: KVM_CAP_ARM_CONFIG_PHYS_SHIFT
>>>> +Architectures: arm64
>>>> +Type: vm ioctl
>>>> +Parameters: __u32 (in)
>>>> +Returns: 0 on success, a negative value on error
>>>> +
>>>> +This ioctl is used to set the maximum physical address size for
>>>> +the VM. The value is Log2(Maximum_Physical_Address). The value can only
>>>> +be increased from the existing setting. The value cannot be changed
>>>> +after the stage-2 page tables are allocated and will return an error.
>>>> +
>>>
>>> Is there a way for userspace to discover what the underlying hardware
>>> can actually support, beyond trial-and-error on this ioctl?
>>
>> Unfortunately, there is none. We don't expose ID_AA64MMFR0 via mrs emulation.
>>
> 
> We should probably think about that.  Perhaps it could be tied to the
> return value of KVM_CAP_ARM_CONFIG_PHYS_SHIFT ?

See below.

>>>
>>> Have you considered making this capability a generic capability and
>>> encoding this in the 'type' argument to KVM_CREATE_VM?  This would
>>> significantly simplify all the above and would allow you to drop patch 8
>>> and 9 I think.
>>>> No. I will take a look.

We could add a KVM dev capability hooked to the kvm_arch_dev_ioctl() for ARM
to give out the maximum supported physical shift. And then the user could request
the physical shift via the type argument (of course, encoded to allow future uses)
to KVM_CREATE_VM.

Cheers
Suzuki
