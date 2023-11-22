Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410FF20DC9
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F82F1595;
	Wed, 22 Nov 2023 05:48:38 -0800 (PST)
Received: from [10.57.71.201] (unknown [10.57.71.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9E283F7A6;
	Wed, 22 Nov 2023 05:47:49 -0800 (PST)
Message-ID: <d69be407-1f16-4909-b89c-4b7736ee5bd1@arm.com>
Date: Wed, 22 Nov 2023 13:47:49 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/12] KVM: selftests: arm64: Determine max ipa size
 per-page size
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
 <20231116142931.1675485-12-ryan.roberts@arm.com> <ZV0-bmqsCM8o_gli@linux.dev>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZV0-bmqsCM8o_gli@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/11/2023 23:34, Oliver Upton wrote:
> On Thu, Nov 16, 2023 at 02:29:30PM +0000, Ryan Roberts wrote:
> 
> [...]
> 
>> @@ -518,9 +530,14 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
>>  	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
>>  	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
>>  
>> -	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val) != 0xf;
>> -	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val) == 0;
>> -	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val) != 0;
>> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val);
>> +	*ipa4k = max_ipa_for_page_size(ipa, gran, 0xf, 1);
>> +
>> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val);
>> +	*ipa64k = max_ipa_for_page_size(ipa, gran, 0xf, 0);
>> +
>> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val);
>> +	*ipa16k = max_ipa_for_page_size(ipa, gran, 0, 2);
> 
> Oh, also: we have the generated system register definitions available in
> KVM selftests at this point. It'd be a good idea to move away from
> 'magic' values and use the enumerations instead.
> 

OK will do!
