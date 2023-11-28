Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB474F614
	for <kvmarm@lists.linux.dev>; Tue, 28 Nov 2023 12:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3191C15;
	Tue, 28 Nov 2023 04:24:28 -0800 (PST)
Received: from [10.1.33.188] (XHFQ2J9959.cambridge.arm.com [10.1.33.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC7323F73F;
	Tue, 28 Nov 2023 04:23:39 -0800 (PST)
Message-ID: <b6a003e1-effd-46a4-9f4f-b686dc97517b@arm.com>
Date: Tue, 28 Nov 2023 12:23:38 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/12] KVM: arm64: Convert translation level parameter
 to s8
Content-Language: en-GB
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231127111737.1897081-1-ryan.roberts@arm.com>
 <20231127111737.1897081-9-ryan.roberts@arm.com>
 <CAMj1kXG-ry6UntNRgtOw-mTEadtNuvmKCy2-FFmYjvZqHmbS1Q@mail.gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAMj1kXG-ry6UntNRgtOw-mTEadtNuvmKCy2-FFmYjvZqHmbS1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/11/2023 10:49, Ard Biesheuvel wrote:
> On Mon, 27 Nov 2023 at 12:18, Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> With the introduction of FEAT_LPA2, the Arm ARM adds a new lel of
>> translation, level -1, so levels can now be in the range [-1;3]. 3 is
>> always the last level and the first level is determined based on the
>> number of VA bits in use.
>>
>> Convert level variables to use a signed type in preparation for
>> supporting this new level -1.
>>
>> Since the last level is always anchored at 3, and the first level varies
>> to suit the number of VA/IPA bits, take the opportunity to replace
>> KVM_PGTABLE_MAX_LEVELS with the 2 macros KVM_PGTABLE_FIRST_LEVEL and
>> KVM_PGTABLE_LAST_LEVEL. This removes the assumption from the code that
>> levels run from 0 to KVM_PGTABLE_MAX_LEVELS - 1, which will soon no
>> longer be true.
>>
>> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_emulate.h  |  2 +-
>>  arch/arm64/include/asm/kvm_pgtable.h  | 31 +++++++------
>>  arch/arm64/include/asm/kvm_pkvm.h     |  5 +-
>>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +--
>>  arch/arm64/kvm/hyp/nvhe/mm.c          |  4 +-
>>  arch/arm64/kvm/hyp/nvhe/setup.c       |  2 +-
>>  arch/arm64/kvm/hyp/pgtable.c          | 66 +++++++++++++++------------
>>  arch/arm64/kvm/mmu.c                  | 16 ++++---
>>  8 files changed, 71 insertions(+), 61 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 78a550537b67..13fd9dbf2d1d 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -409,7 +409,7 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
>>         return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
>>  }
>>
>> -static __always_inline u8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
>> +static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
>>  {
>>         return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
>>  }
> 
> This helper is currently only used for permission faults, which don't
> exist at level -1. Also, there is only a single caller of this helper,
> which uses the result only to infer the size covered by the block
> entry that describes the mapping.
> 
> So in my LPA2 series, I intend to remove this helper altogether, and
> just replace it with something along the lines of
> 
> static inline
> u64 kvm_vcpu_trap_get_perm_fault_granule(const struct kvm_vcpu *vcpu)
> {
>     unsigned long esr = kvm_vcpu_get_esr(vcpu);
> 
>     BUG_ON(!esr_is_permission_fault(esr));
>     return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(esr & ESR_ELx_FSC_LEVEL));
> }
> 
> to avoid having to reason about whether masking with ESR_ELx_FSC_LEVEL
> is appropriate for the fault type in question.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=arm64-lpa2-v6-combined&id=26c3425ec73ca751c45848f6f3f2d96e02cb4327
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=arm64-lpa2-v6-combined&id=d6a849d6b318e70bf2f80f9b18a933136520019a
> 

This would take me an afternoon to get educated enough to even be able to offer
an opinon. So I'll leave this to the bigger boys to discuss. :)


