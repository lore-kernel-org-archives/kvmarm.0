Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E601423C6
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 08:35:18 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F6A51FB;
	Wed, 27 Sep 2023 01:35:56 -0700 (PDT)
Received: from [10.57.66.234] (unknown [10.57.66.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE4873F59C;
	Wed, 27 Sep 2023 01:35:16 -0700 (PDT)
Message-ID: <03c70886-9d48-42c9-b397-650b030f930a@arm.com>
Date: Wed, 27 Sep 2023 09:35:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] KVM: arm64: Use LPA2 page-tables for stage2 if
 HW supports it
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
 <20230918065740.3670662-7-ryan.roberts@arm.com> <ZRPTfptM8Ee0RVSm@linux.dev>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZRPTfptM8Ee0RVSm@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/09/2023 08:02, Oliver Upton wrote:
> On Mon, Sep 18, 2023 at 07:57:33AM +0100, Ryan Roberts wrote:
> 
> [...]
> 
>>  static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
>>  {
>> -	u64 pa = pte & KVM_PTE_ADDR_MASK;
>> -
>> -	if (PAGE_SHIFT == 16)
>> -		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
>> +	u64 pa;
>> +
>> +	if (system_supports_lpa2()) {
>> +		pa = pte & KVM_PTE_ADDR_MASK_LPA2;
>> +		pa |= FIELD_GET(KVM_PTE_ADDR_51_50_LPA2, pte) << 50;
>> +	} else {
>> +		pa = pte & KVM_PTE_ADDR_MASK;
>> +		if (PAGE_SHIFT == 16)
>> +			pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
>> +	}
>>  
>>  	return pa;
>>  }
>>  
>>  static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
>>  {
>> -	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
>> -
>> -	if (PAGE_SHIFT == 16) {
>> -		pa &= GENMASK(51, 48);
>> -		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
>> +	kvm_pte_t pte;
>> +
>> +	if (system_supports_lpa2()) {
>> +		pte = pa & KVM_PTE_ADDR_MASK_LPA2;
>> +		pa &= GENMASK(51, 50);
>> +		pte |= FIELD_PREP(KVM_PTE_ADDR_51_50_LPA2, pa >> 50);
>> +	} else {
>> +		pte = pa & KVM_PTE_ADDR_MASK;
>> +		if (PAGE_SHIFT == 16) {
>> +			pa &= GENMASK(51, 48);
>> +			pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
>> +		}
>>  	}
> 
> These accessors are common between stage-1 and stage-2 walks... Aren't
> bits [9:8] of the descriptor still being used to encode shareability for
> hyp stage-1 at this point?

Yes, that's correct. I split the commits just to be able to see what changes are
in respect of which stage, although as you point out, this part is actually shared.

> 
> You may as well squash the subsequent patch (LPA2 format for S1) into this
> one such that the change is atomic.
> 

OK, I'll squash them in the next version.

