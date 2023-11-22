Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611ED24A0B
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C22F1595;
	Wed, 22 Nov 2023 05:38:07 -0800 (PST)
Received: from [10.57.71.201] (unknown [10.57.71.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C808B3F7A6;
	Wed, 22 Nov 2023 05:37:18 -0800 (PST)
Message-ID: <b5c68b7f-868f-400c-b5de-3daea95e3224@arm.com>
Date: Wed, 22 Nov 2023 13:37:16 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm
 s2
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
 <ZV0_YSm07-5SXdcz@linux.dev>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZV0_YSm07-5SXdcz@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/11/2023 23:38, Oliver Upton wrote:
> Hi Ryan,
> 
> On Thu, Nov 16, 2023 at 02:29:19PM +0000, Ryan Roberts wrote:
>> Additionally, when running page_fault_test, when run on FVP against v6.7-rc1 and
>> newer, I'm seeing RCU stalls. I'm confident that this is not an issue introduced
>> by this series because it reproduces without my patches.
> 
> Oh, that's interesting. Can you gather any additional details, like what
> test case in page_fault_test trips the RCU stalls?

I don't know off the top of my head. I'll switch back to this next week and do
the changes you requested and retest with some extra logging turned on.
Hopefully that will turn up some more info that I can pass along.

> 
>> Anshuman Khandual (1):
>>   arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]
>>
>> Ryan Roberts (11):
>>   arm64/mm: Modify range-based tlbi to decrement scale
>>   arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
>>   arm64/mm: Update tlb invalidation routines for FEAT_LPA2
>>   arm64: Add ARM64_HAS_LPA2 CPU capability
>>   KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
>>   KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
>>   KVM: arm64: Convert translation level parameter to s8
>>   KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
>>   KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
>>   KVM: selftests: arm64: Determine max ipa size per-page size
>>   KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes
> 
> Besides the nitpicks I left on the series, LGTM.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks!

