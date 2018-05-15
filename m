From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Add support for PUD hugepages at stage 2
Date: Tue, 15 May 2018 18:12:58 +0100
Message-ID: <87bmdg3krp.fsf@e105922-lin.cambridge.arm.com>
References: <20180501102659.13188-1-punit.agrawal@arm.com>
        <20180501102659.13188-5-punit.agrawal@arm.com>
        <20180515165620.37l2epyno3vdcisu@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180515165620.37l2epyno3vdcisu@armageddon.cambridge.arm.com>
        (Catalin Marinas's message of "Tue, 15 May 2018 17:56:21 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com, marc.zyngier@arm.com, Will Deacon <will.deacon@arm.com>, christoffer.dall@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Tue, May 01, 2018 at 11:26:59AM +0100, Punit Agrawal wrote:
>> KVM currently supports PMD hugepages at stage 2. Extend the stage 2
>> fault handling to add support for PUD hugepages.
>> 
>> Addition of pud hugepage support enables additional hugepage
>> sizes (e.g., 1G with 4K granule) which can be useful on cores that
>> support mapping larger block sizes in the TLB entries.
>> 
>> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_mmu.h         | 19 ++++++++++++
>>  arch/arm64/include/asm/kvm_mmu.h       | 15 ++++++++++
>>  arch/arm64/include/asm/pgtable-hwdef.h |  4 +++
>>  arch/arm64/include/asm/pgtable.h       |  2 ++
>>  virt/kvm/arm/mmu.c                     | 40 ++++++++++++++++++++++++--
>>  5 files changed, 77 insertions(+), 3 deletions(-)
>
> Since this patch touches a couple of core arm64 files:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks Catalin.

I've posted a v3 with minor changes yesterday[0]. Can you comment there?
Or maybe Marc can apply the tag while merging the patches.

[0] https://lkml.org/lkml/2018/5/14/912
