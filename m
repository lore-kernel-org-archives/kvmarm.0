From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 10/20] kvm: arm64: Dynamic configuration of VTTBR mask
Date: Wed, 4 Jul 2018 09:29:06 +0100
Message-ID: <1696a35f-9cd5-d807-f2e9-41d9f19d919a@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-11-git-send-email-suzuki.poulose@arm.com>
 <e0c8dc62-42e8-ee24-5519-e19b2739160b@redhat.com>
 <a6fa912a-b2ff-ac1e-0120-b2f7eabb6f7f@arm.com>
 <3192c7dc-4127-ec97-6ba3-262fa3ff6243@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3192c7dc-4127-ec97-6ba3-262fa3ff6243@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: cdall@kernel.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, julien.grall@arm.com, james.morse@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 07/04/2018 09:24 AM, Auger Eric wrote:
>>>> + *
>>>> + * We have a magic formula for the Magic_N below.
>>>> + *
>>>> + *  Magic_N(PAGE_SIZE, Entry_Level) = 64 - ((PAGE_SHIFT - 3) *
>>>> Number of levels)
>>
>> [0] ^^^
>>
>>
>>
>>>> + *
>>>> + * where number of levels = (4 - Entry_Level).
>>
>> ^^^ Doesn't this help make it clear ? Using the expansion makes it a bit
>> more
>> unreadable below.
> 
> I just wanted to mention the tables you refer (D4-23 and D4-25) give
> Magic_N for a larger scope as they deal with any lookup level while we
> only care about the entry level for BADDR. So I was a little bit
> confused when reading the explanation but that's not a big deal.

Ah, ok. I will try to clarify it.

Cheers
Suzuki
