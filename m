Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A135B1D2BF
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 08:21:48 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7BF9139F;
	Tue, 23 May 2023 01:22:32 -0700 (PDT)
Received: from [10.162.42.7] (unknown [10.162.42.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF07C3F762;
	Tue, 23 May 2023 01:21:44 -0700 (PDT)
Message-ID: <e92b10d3-27bb-e326-e7f2-d6095b756fac@arm.com>
Date: Tue, 23 May 2023 13:51:41 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/5] arm64/sysreg: Convert OSLAR_EL1 to automatic
 generation
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20230419-arm64-syreg-gen-v1-0-936cd769cb9e@kernel.org>
 <20230419-arm64-syreg-gen-v1-5-936cd769cb9e@kernel.org>
 <ZGx1jT4nQ9HEVWSE@linux.dev>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ZGx1jT4nQ9HEVWSE@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/23 13:43, Oliver Upton wrote:
> On Mon, May 22, 2023 at 05:22:44PM +0100, Mark Brown wrote:
>> Convert OSLAR_EL1 to automatic generation as per DDI0601 2023-03. No
>> functional change.
>>
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> ---
>>  arch/arm64/include/asm/sysreg.h | 3 ---
>>  arch/arm64/tools/sysreg         | 5 +++++
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 09de958e79ed..3b51e532caa9 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -140,9 +140,6 @@
>>  #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
>>  #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
>>  
>> -#define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
>> -#define OSLAR_EL1_OSLK			BIT(0)
>> -
>>  #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
>>  #define OSLSR_EL1_OSLM_MASK		(BIT(3) | BIT(0))
>>  #define OSLSR_EL1_OSLM_NI		0
> 
> Should the OSLSR_EL1 definitions be rolled over to the generated scheme
> as well?

Agreed, was about to ask the same question :) Any reason it got skipped ?

> 
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index a5ae0e19fc9f..84df0b7feb45 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -83,6 +83,11 @@ Res0	5:1
>>  Field	0	SS
>>  EndSysreg
>>  
>> +Sysreg	OSLAR_EL1	2	0	1	0	4
>> +Res0	63:1
>> +Field	0	OSLK
>> +EndSysreg
>> +
>>  Sysreg ID_PFR0_EL1	3	0	0	1	0
>>  Res0	63:32
>>  UnsignedEnum	31:28	RAS
>>
>> -- 
>> 2.30.2
>>
> 
