Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DE17E
	for <kvmarm@lists.linux.dev>; Thu, 13 Apr 2023 08:27:34 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52634D75;
	Thu, 13 Apr 2023 01:28:18 -0700 (PDT)
Received: from [10.57.68.113] (unknown [10.57.68.113])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CDB43F6C4;
	Thu, 13 Apr 2023 01:27:32 -0700 (PDT)
Message-ID: <eed7f71a-17db-0b9a-760d-7d76f054f709@arm.com>
Date: Thu, 13 Apr 2023 09:27:31 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2 06/12] KVM: arm64: Use LPA2 page-tables for hyp stage1
 if HW supports it
Content-Language: en-US
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
 <20230306195438.1557851-7-ryan.roberts@arm.com> <ZDblAddFaCSwl/bf@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZDblAddFaCSwl/bf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/04/2023 18:06, Catalin Marinas wrote:
> On Mon, Mar 06, 2023 at 07:54:32PM +0000, Ryan Roberts wrote:
>> Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
>> page size we are using, always use LPA2-style page-tables for hyp stage
>> 1, regardless of the IPA or PA size requirements. When in use we can now
>> support up to 52-bit IPA and PA sizes.
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/kvm/arm.c         | 2 ++
>>  arch/arm64/kvm/hyp/pgtable.c | 3 ++-
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 3bd732eaf087..bef73c484162 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1548,6 +1548,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
>>  	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
>>  	tcr &= ~TCR_T0SZ_MASK;
>>  	tcr |= TCR_T0SZ(hyp_va_bits);
>> +	if (system_supports_lpa2())
>> +		tcr |= TCR_EL2_DS;
>>  	params->tcr_el2 = tcr;
>>  
>>  	params->pgd_pa = kvm_mmu_get_httbr();
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index 414a5dbf233d..bb481d6c7f2d 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -379,7 +379,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>>  	}
>>  
>>  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
>> -	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>> +	if (!system_supports_lpa2())
>> +		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>>  	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
>>  	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
>>  	*ptep = attr;
> 
> Isn't LPA2 at stage 1 more involved than just not setting the SH field?
> Does kvm_phys_to_pte() need changing as well?

Yes, the kvm_pgtable library was changed in the previous commit to handle LPA2
correctly. kvm_phys_to_pte() is one such modification.

> 
> If that's not strictly needed for stage 2, I'd rather keep the two
> stages separate and add the stage 1 hyp together with Ard's series for
> LPA2 at stage 1.
> 
The problem is that KVM uses the same kvm_pgtable library to manage the hyp
stage1 and guest stage2 page tables. My original approach was to pass around a
per-pgtable flag that indicated the pgtable format and the library would do the
right thing based on that flag. But the preference at round 1 was to do away
with that and use a static key to simplify and speed things up. The consequence
is that all users of the library must use the same format, so that ties hyp s1
and guest s2 changes together.

