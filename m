Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535235225
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 08:37:33 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7D96DA7;
	Wed, 27 Sep 2023 01:38:10 -0700 (PDT)
Received: from [10.57.66.234] (unknown [10.57.66.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 359043F59C;
	Wed, 27 Sep 2023 01:37:31 -0700 (PDT)
Message-ID: <c1ea3931-615d-42cf-8bb8-a3b1e6a8ce46@arm.com>
Date: Wed, 27 Sep 2023 09:37:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/13] KVM: arm64: Insert PS field at TCR_EL2 assembly
 time
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 James Morse <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
 <20230918065740.3670662-9-ryan.roberts@arm.com> <ZRPXpa1USIzbDHqR@linux.dev>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZRPXpa1USIzbDHqR@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/09/2023 08:20, Oliver Upton wrote:
> 'Assembly' is overloaded in this context, I had to reread the shortlog
> to make sense of it. Maybe:
> 
>   KVM: arm64: Prepare TCR_EL2.PS in cpu_prepare_hyp_mode()

Yep, will fix it in the next version.

> 
> On Mon, Sep 18, 2023 at 07:57:35AM +0100, Ryan Roberts wrote:
> 
> [...]
> 
>>  	tcr &= ~TCR_T0SZ_MASK;
>>  	tcr |= TCR_T0SZ(hyp_va_bits);
>> +	tcr |= kvm_get_parange(mmfr0) << TCR_EL2_PS_SHIFT;
> 
> nit: FIELD_PREP() is slightly more defensive than shifting an unmasked
> value.
> 

Yep, good idea, will fix it in the next version.


Do let me know if you have any other comments across the series; If I don't hear
anything further, I'll aim to get a new version with your proposed changes
posted sometime next week.

Thanks,
Ryan

