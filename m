From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 18/18] kvm: arm64: Allow tuning the physical address
 size for VM
Date: Tue, 18 Sep 2018 16:16:27 +0100
Message-ID: <218b64d5-741d-97ef-8aae-bc0a2ac3e56c@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
 <20180917104144.19188-19-suzuki.poulose@arm.com>
 <CAFEAcA8eWYkzwFYHyP49dasK-NDVbbm=6DbEFNNPq9ZAdUM7JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFEAcA8eWYkzwFYHyP49dasK-NDVbbm=6DbEFNNPq9ZAdUM7JQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@kernel.org>, Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Dave P Martin <dave.martin@arm.com>, julien.grall@arm.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

On 18/09/2018 02:55, Peter Maydell wrote:
> On 17 September 2018 at 11:41, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -122,6 +122,14 @@ the default trap & emulate implementation (which changes the virtual
>>   memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
>>   flag KVM_VM_MIPS_VZ.
>>
>> +To configure the physical address space size for a VM (IPA size) on arm64,
>> +check KVM_CAP_ARM_VM_PHYS_SHIFT (which returns the maximum limit for the
>> +IPA shift) and use KVM_VM_TYPE_ARM_PHYS_SHIFT(PHYS_SHIFT). Bits[7-0] of the
>> +machine type has been reserved for specifying the PHYS_SHIFT.
>> +The supported range is [32...IPA_LIMIT], where IPA_LIMIT could be
>> +identified by checking KVM_CAP_ARM_VM_PHYS_SHIFT. For backward compatibility
>> +a value of 0 selects 40bits.
>> +
> 
> Given this as the API documentation, I don't think I could figure out
> what I as a userspace user of it need to do without looking at the
> kernel code. Could I ask you to expand it so that it is a bit less
> terse and a bit more detailed? (For instance, what is a PHYS_SHIFT
> and why do I have to specify it rather than just telling the kernel
> I want a 48 bit guest address space?)

Thanks for the feedback.  I acknowledge that the documentation is not
quite clear for a userspace user. How about:

"To configure the physical address space size for a VM (IPA size) on arm64,
check KVM_CAP_ARM_VM_IPA_SIZE and use KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits)
as the argument to KVM_CREATE_VM, where IPA_Bits is the maximum width of
any physical address used by the VM. The IPA_Bits is encoded in Bits[7-0]
of the machine type, and must be one of { 0, 32, ... , Host_IPA_Limit },
where :
1) IPA_Bits = 0 implies 40bits IPA (for backward compatibility)
2) Host_IPA_Limit is the maximum limit for IPA_Bits on the host, which is
    dependent on the CPU capability and the host kernel configuration.
    This can be detected by checking the extension KVM_CAP_ARM_VM_IPA_SIZE
"

note: I have renamed the KVM_CAP_ARM_VM_PHYS_SHIFT => KVM_CAP_ARM_VM_IPA_SIZE
above and can update the code, if the latter is better.

Suzuki
