Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5121F602
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 08:31:36 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8E041FB;
	Wed, 27 Sep 2023 01:32:13 -0700 (PDT)
Received: from [10.57.66.234] (unknown [10.57.66.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33E3A3F59C;
	Wed, 27 Sep 2023 01:31:34 -0700 (PDT)
Message-ID: <ded37ae0-e6c4-4bd4-8fc3-a9e2b2d3da77@arm.com>
Date: Wed, 27 Sep 2023 09:31:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/13] KVM: arm64: Add ARM64_HAS_LPA2 CPU capability
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
 <20230918065740.3670662-5-ryan.roberts@arm.com> <ZRPN8yOkfwiasLDl@linux.dev>
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZRPN8yOkfwiasLDl@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/09/2023 07:38, Oliver Upton wrote:
> Hi Ryan,
> 
> On Mon, Sep 18, 2023 at 07:57:31AM +0100, Ryan Roberts wrote:
> 
> [...]
> 
>> +static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
>> +{
>> +	u64 mmfr0;
>> +
>> +	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
>> +	return has_lpa2_at_stage1(mmfr0) && has_lpa2_at_stage2(mmfr0);
> 
> Should we only require consistency between stage-1 and stage-2 if KVM
> kvm_get_mode() != KVM_MODE_NONE? In case there are systems that have
> mismatched LPA2 support users can just disable KVM to use the feature.
> 

Yes, good idea. I'll add that in the next version.

Thanks for the review!
