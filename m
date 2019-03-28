From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v7 9/10] KVM: arm64: docs: document KVM support of pointer
 authentication
Date: Thu, 28 Mar 2019 15:43:07 +0530
Message-ID: <82d60b1e-d08b-a8f8-457a-c9ead0378e0e@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-10-git-send-email-amit.kachhap@arm.com>
 <23e4a9d4-e9e1-2c1f-32ce-e7fd96080437@arm.com>
 <20190327104428.GV3567@e103592.cambridge.arm.com>
 <bdd480a4-44b3-7ddf-44f5-5b55e6251ced@arm.com>
 <20190327135058.GW3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327135058.GW3567@e103592.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Dave,

On 3/27/19 7:20 PM, Dave Martin wrote:
> On Wed, Mar 27, 2019 at 05:19:28PM +0530, Amit Daniel Kachhap wrote:
>> Hi,
>>
>> On 3/27/19 4:14 PM, Dave Martin wrote:
>>> On Mon, Mar 25, 2019 at 08:05:49PM +0000, Kristina Martsenko wrote:
>>>> On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
>>>>> This adds sections for KVM API extension for pointer authentication.
>>>>> A brief description about usage of pointer authentication for KVM guests
>>>>> is added in the arm64 documentations.
>>>>>
>>>>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>>
>>>> I think it makes sense to also update the Kconfig symbol description for
>>>> CONFIG_ARM64_PTR_AUTH, since it currently only mentions userspace
>>>> support, but now the option also enables KVM guest support.
>>>>
>>>> It's also worth mentioning that CONFIG_ARM64_VHE=y is required for guest
>>>> support.
>>>
>>> Is it worth making this dependency explicit in Kconfig?
>> Currently there is discrepancy that userspace supports ptrauth in both
>> nVHE/VHE mode and KVM guest only in VHE mode. I suppose adding explicit
>> dependency flag here makes both of them similar.
> 
> Looking at the history, for SVE this Kconfig restriction has always been
> present.  Since ptrauth initially upstreamed without an equivalent
> restriction in Kconfig, adding it now could be seen as a regression.
ok it makes sense to keep it this way.
> 
> So, maybe it's not worth it here.
> 
> You could add a separate option, say
> 
> config ARM64_PTR_AUTH_KVM
> 	bool "Pointer authentication support for KVM guests"
> 	default y
> 	depends on ARM64_PTR_AUTH && ARM64_VHE && KVM
> 
> ...but that may be overkill.
I was thinking for adding some details for this in virtualization 
section in Documentation/arm64/pointer-authentication.txt along with 
brief comment in arch/arm64/Kconfig.

Thanks,
Amit D
> 
> Cheers,
> ---Dave
> 
