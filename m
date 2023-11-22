Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790F93B7B4
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B04601595;
	Wed, 22 Nov 2023 05:42:23 -0800 (PST)
Received: from [10.57.71.201] (unknown [10.57.71.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D1D03F7A6;
	Wed, 22 Nov 2023 05:41:34 -0800 (PST)
Message-ID: <c89e4132-fedd-440d-8971-5e42969fc1e9@arm.com>
Date: Wed, 22 Nov 2023 13:41:33 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/12] KVM: arm64: Use LPA2 page-tables for stage2 and
 hyp stage1
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
 <20231116142931.1675485-8-ryan.roberts@arm.com> <ZV0Uaoi-qBjX3j5i@linux.dev>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZV0Uaoi-qBjX3j5i@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/11/2023 20:34, Oliver Upton wrote:
> On Thu, Nov 16, 2023 at 02:29:26PM +0000, Ryan Roberts wrote:
>> Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
>> page size we are using, always use LPA2-style page-tables for stage 2
>> and hyp stage 1 (assuming an nvhe hyp), regardless of the VMM-requested
>> IPA size or HW-implemented PA size. When in use we can now support up to
>> 52-bit IPA and PA sizes.
>>
>> We use the previously created cpu feature to track whether LPA2 is
>> supported for deciding whether to use the LPA2 or classic pte format.
>>
>> Note that FEAT_LPA2 brings support for bigger block mappings (512GB with
>> 4KB, 64GB with 16KB). We explicitly don't enable these in the library
>> because stage2_apply_range() works on batch sizes of the largest used
>> block mapping, and increasing the size of the batch would lead to soft
>> lockups. See commit 5994bc9e05c2 ("KVM: arm64: Limit
>> stage2_apply_range() batch size to largest block").
>>
>> With the addition of LPA2 support in the hypervisor, the PA size
>> supported by the HW must be capped with a runtime decision, rather than
>> simply using a compile-time decision based on PA_BITS. For example, on a
>> system that advertises 52 bit PA but does not support FEAT_LPA2, A 4KB
>> or 16KB kernel compiled with LPA2 support must still limit the PA size
>> to 48 bits.
>>
>> Therefore, move the insertion of the PS field into TCR_EL2 out of
>> __kvm_hyp_init assembly code and instead do it in cpu_prepare_hyp_mode()
>> where the rest of TCR_EL2 is prepared. This allows us to figure out PS
>> with kvm_get_parange(), which has the appropriate logic to ensure the
>> above requirement. (and the PS field of VTCR_EL2 is already populated
>> this way).
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_mmu.h     |  2 +-
>>  arch/arm64/include/asm/kvm_pgtable.h | 47 +++++++++++++++++++++-------
>>  arch/arm64/kvm/arm.c                 |  5 +++
>>  arch/arm64/kvm/hyp/nvhe/hyp-init.S   |  4 ---
>>  arch/arm64/kvm/hyp/pgtable.c         | 15 +++++++--
>>  5 files changed, 54 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index 31e8d7faed65..f4e4fcb35afc 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -340,7 +340,7 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>>  	return container_of(mmu->arch, struct kvm, arch);
>>  }
>>  
>> -#define kvm_lpa2_is_enabled()		false
>> +#define kvm_lpa2_is_enabled()		system_supports_lpa2()
> 
> Can we use this predicate consistently throughout the KVM code? Looks
> like the rest of this diff is using system_supports_lpa2() directly.

My thinking was that system_supports_lpa2() is an input to KVM's policy to
decide if it is going to use LPA2 (currently that policy is very simple - if the
system supports it, then KVM uses it - but it doesn't have to be that way), and
kvm_lpa2_is_enabled() is how KVM exports its policy decision, so one is an input
and the other is an output.

It's a lightly held opinion though - I'll make the change if you insist? :)


