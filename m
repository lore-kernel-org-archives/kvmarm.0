From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3 19/20] kvm: arm64: Allow IPA size supported by the
 system
Date: Mon, 2 Jul 2018 14:54:36 +0100
Message-ID: <72472fe5-69a2-9272-c0ef-d0b981ee0446@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-20-git-send-email-suzuki.poulose@arm.com>
 <8dcb10d8-d0ff-feb9-4ca8-38d7eeb5e6ce@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8dcb10d8-d0ff-feb9-4ca8-38d7eeb5e6ce@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

On 02/07/18 14:50, Marc Zyngier wrote:
> On 29/06/18 12:15, Suzuki K Poulose wrote:
>> So far we have restricted the IPA size of the VM to the default
>> value (40bits). Now that we can manage the IPA size per VM and
>> support dynamic stage2 page tables, allow VMs to have larger IPA.
>> This is done by setting the IPA limit to the one supported by
>> the hardware and kernel. This patch also moves the check for
>> the default IPA size support to kvm_get_ipa_limit().
>>
>> Since the stage2 page table code is dependent on the stage1
>> page table, we always ensure that :
>>
>>    Number of Levels at Stage1 >= Number of Levels at Stage2
>>
>> So we limit the IPA to make sure that the above condition
>> is satisfied. This will affect the following combinations
>> of VA_BITS and IPA for different page sizes.
>>
>>    39bit VA, 4K  - IPA > 43 (Upto 48)
>>    36bit VA, 16K - IPA > 40 (Upto 48)
>>    42bit VA, 64K - IPA > 46 (Upto 52)
> 
> I'm not sure I get it. Are these the IPA sizes that we forbid based on
> the host VA size and page size configuration?

Yes, thats right.

> If so, can you rewrite
> this as:
> 
>     host configuration | unsupported IPA range
>     39bit VA, 4k       | [44, 48]
>     36bit VA, 16K      | [41, 48]
>     42bit VA, 64k      | [47, 52]
> 
> and say that all the other combinations are supported?

Sure, that looks much better. Thanks

Suzuki
