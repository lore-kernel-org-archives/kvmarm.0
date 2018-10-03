From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v8 1/9] KVM: arm/arm64: Ensure only THP is candidate for adjustment
Date: Wed, 03 Oct 2018 11:59:10 +0100
Message-ID: <87tvm3i9dt.fsf@e105922-lin.cambridge.arm.com>
References: <20181001155443.23032-1-punit.agrawal@arm.com>
        <20181001155443.23032-2-punit.agrawal@arm.com>
        <0809a9d0-d256-c23a-c3cc-0b2be33aecff@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <0809a9d0-d256-c23a-c3cc-0b2be33aecff@arm.com> (Marc Zyngier's
        message of "Wed, 3 Oct 2018 11:50:38 +0100")
Sender: stable-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, will.deacon@arm.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Marc Zyngier <marc.zyngier@arm.com> writes:

> On 01/10/18 16:54, Punit Agrawal wrote:
>> PageTransCompoundMap() returns true for hugetlbfs and THP
>> hugepages. This behaviour incorrectly leads to stage 2 faults for
>> unsupported hugepage sizes (e.g., 64K hugepage with 4K pages) to be
>> treated as THP faults.
>>
>> Tighten the check to filter out hugetlbfs pages. This also leads to
>> consistently mapping all unsupported hugepage sizes as PTE level
>> entries at stage 2.
>>
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Reviewed-by: Suzuki Poulose <suzuki.poulose@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: stable@vger.kernel.org # v4.13+
>
> FWIW, I've cherry-picked that single patch from the series and queued
> it for 4.20.

Thanks for picking up the fix.
