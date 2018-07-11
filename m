From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v5 2/7] KVM: arm/arm64: Introduce helpers to manupulate page table entries
Date: Wed, 11 Jul 2018 17:10:51 +0100
Message-ID: <87va9loir8.fsf@e105922-lin.cambridge.arm.com>
References: <20180709143835.28971-1-punit.agrawal@arm.com>
        <20180709144124.29164-1-punit.agrawal@arm.com>
        <20180709144124.29164-2-punit.agrawal@arm.com>
        <691fcde0-b0a2-d258-ac99-49c6c4794247@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <691fcde0-b0a2-d258-ac99-49c6c4794247@arm.com> (Suzuki
        K. Poulose's message of "Wed, 11 Jul 2018 14:00:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Suzuki K Poulose <Suzuki.Poulose@arm.com> writes:

> On 09/07/18 15:41, Punit Agrawal wrote:
>> Introduce helpers to abstract architectural handling of the conversion
>> of pfn to page table entries and marking a PMD page table entry as a
>> block entry.
>>
>> The helpers are introduced in preparation for supporting PUD hugepages
>> at stage 2 - which are supported on arm64 but do not exist on arm.
>>
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Other than the query on Patch 7 I've incorporated all your suggestions
locally.

Thanks a lot for reviewing the patches.

Punit

ps: Just noticed the typo (manupulate) in the subject. I've fixed it up
locally.
