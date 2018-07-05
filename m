From: Julien Grall <julien.grall@arm.com>
Subject: Re: [kvmtool test PATCH 22/24] kvmtool: arm64: Add support for guest
 physical address size
Date: Thu, 5 Jul 2018 13:47:26 +0100
Message-ID: <ca05f552-d0d7-b5b8-954b-7254e8c1e529@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-23-git-send-email-suzuki.poulose@arm.com>
 <20180704140943.GF4828@arm.com>
 <8c9bb3cd-f673-17f3-656f-66b7e14fc73c@arm.com>
 <20180704155231.GP4828@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704155231.GP4828@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,

On 04/07/18 16:52, Will Deacon wrote:
> On Wed, Jul 04, 2018 at 04:00:11PM +0100, Julien Grall wrote:
>> On 04/07/18 15:09, Will Deacon wrote:
>>> On Fri, Jun 29, 2018 at 12:15:42PM +0100, Suzuki K Poulose wrote:
>>>> Add an option to specify the physical address size used by this
>>>> VM.
>>>>
>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>> ---
>>>>   arm/aarch64/include/kvm/kvm-config-arch.h | 5 ++++-
>>>>   arm/include/arm-common/kvm-config-arch.h  | 1 +
>>>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
>>>> index 04be43d..dabd22c 100644
>>>> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
>>>> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
>>>> @@ -8,7 +8,10 @@
>>>>   			"Create PMUv3 device"),				\
>>>>   	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>>>>   			"Specify random seed for Kernel Address Space "	\
>>>> -			"Layout Randomization (KASLR)"),
>>>> +			"Layout Randomization (KASLR)"),		\
>>>> +	OPT_INTEGER('\0', "phys-shift", &(cfg)->phys_shift,		\
>>>> +			"Specify maximum physical address size (not "	\
>>>> +			"the amount of memory)"),
>>>
>>> Given that this is a shift value, I think the help message could be more
>>> informative. Something like:
>>>
>>> 	"Specify maximum number of bits in a guest physical address"
>>>
>>> I think I'd actually leave out any mention of memory, because this does
>>> actually have an effect on the amount of addressable memory in a way that I
>>> don't think we want to describe in half of a usage message line :)
>> Is there any particular reasons to expose this option to the user?
>>
>> I have recently sent a series to allow the user to specify the position
>> of the RAM [1]. With that series in mind, I think the user would not really
>> need to specify the maximum physical shift. Instead we could automatically
>> find it.
> 
> Marc makes a good point that it doesn't help for MMIO regions, so I'm trying
> to understand whether we can do something differently there and avoid
> sacrificing the type parameter.

I am not sure to understand this. kvmtools knows the memory layout 
(including MMIOs) of the guest, so couldn't it guess the maximum 
physical shift for that?

Cheers,

-- 
Julien Grall
