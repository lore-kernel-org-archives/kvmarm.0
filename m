Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F3F2264CA
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 05:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755583147; cv=none; b=LkaXmupchxwDB3sr4ldvQwiqNRlwjIcpzwz/Tbs/RN+GXQ+3gy0f4H0e5CEZhEYn31x8gvMuFZM4e05pSvo+577kOBF3xf29P/EpN5aw+4nUHF3Ku6khBYfrzzoksahHiTUjOGsbslvYAx6PpawDmv3vTs7alh9yaeyWI8jyzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755583147; c=relaxed/simple;
	bh=X89cjFgOmZ0Ln4Ar3QQwsWEIKQLCUrDZWW0dEUXjBac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXXtcdSlVaKCJD4jedz3SupQhOsahujOpHJxxBLMl4GCMzKaZ/DvZyfZXIVum6dvWT7xqF1+/A36g5Z5XIcvQhnV95xbab/YmuNtjEPJFkO1goo6KM6y74yCnBprEX6iKPsfW08uGrf+Pp7+TTqtKyh0lJF8MOQzklbvmH0JP+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A786F152B;
	Mon, 18 Aug 2025 22:58:49 -0700 (PDT)
Received: from [10.164.146.16] (J09HK2D2RT.blr.arm.com [10.164.146.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 913663F63F;
	Mon, 18 Aug 2025 22:58:54 -0700 (PDT)
Message-ID: <bea0e6b4-4b9e-45c7-b42a-fde93d627cba@arm.com>
Date: Tue, 19 Aug 2025 11:28:51 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] arm64/sysreg: Add TCR_EL2 register
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
 <20250818045759.672408-4-anshuman.khandual@arm.com>
 <87ldngmy9h.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <87ldngmy9h.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/08/25 9:13 PM, Marc Zyngier wrote:
> On Mon, 18 Aug 2025 05:57:58 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> Add TCR_EL2 register fields as per the latest ARM ARM DDI 0487 7.B in tools
> 
> 7.B??? My copy of the published ARM ARM has L.B as the version suffix.

Right, the version is L.B instead.
> 
> Also, if you got the registers from the ARM ARM, please stop doing
> so. This is terribly error prone, and likely to be incomplete, given
> that the ARM ARM lags about a year behind the published architecture.
> 
> You have the BSD-licensed MRS at your disposal, please make use of it.

I guess you are suggesting the latest layout from the XML. Sure will refer
the layout from the following description.

https://developer.arm.com/documentation/ddi0601/2025-06/AArch64-Registers/TCR-EL2--Translation-Control-Register--EL2-
> 
>> sysreg format and drop all the existing redundant macros from the header
>> (arch/arm64/include/asm/kvm_arm.h). While here also drop an explicit sysreg
>> definction SYS_TCR_EL2 from sysreg.h header.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oliver.upton@linux.dev>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h | 13 ----------
>>  arch/arm64/include/asm/sysreg.h  |  1 -
>>  arch/arm64/tools/sysreg          | 44 ++++++++++++++++++++++++++++++++
>>  3 files changed, 44 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 560d9cb63413..8994cddef182 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -107,19 +107,6 @@
>>  
>>  #define MPAMHCR_HOST_FLAGS	0
>>  
>> -/* TCR_EL2 Registers bits */
>> -#define TCR_EL2_DS		(1UL << 32)
>> -#define TCR_EL2_RES1		((1U << 31) | (1 << 23))
>> -#define TCR_EL2_HPD		(1 << 24)
>> -#define TCR_EL2_TBI		(1 << 20)
>> -#define TCR_EL2_PS_SHIFT	16
>> -#define TCR_EL2_PS_MASK		(7 << TCR_EL2_PS_SHIFT)
>> -#define TCR_EL2_PS_40B		(2 << TCR_EL2_PS_SHIFT)
>> -#define TCR_EL2_TG0_MASK	TCR_EL1_TG0_MASK
>> -#define TCR_EL2_SH0_MASK	TCR_EL1_SH0_MASK
>> -#define TCR_EL2_ORGN0_MASK	TCR_EL1_ORGN0_MASK
>> -#define TCR_EL2_IRGN0_MASK	TCR_EL1_IRGN0_MASK
>> -#define TCR_EL2_T0SZ_MASK	0x3f
>>  #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
>>  			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
>>  
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index ad5c901af229..112d5d0acb50 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -523,7 +523,6 @@
>>  
>>  #define SYS_TTBR0_EL2			sys_reg(3, 4, 2, 0, 0)
>>  #define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
>> -#define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
>>  #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
>>  #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
>>  
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 4bdae8bb11dc..d2b40105eb41 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -4812,6 +4812,50 @@ Sysreg	TCR_EL12        3	5	2	0	2
>>  Mapping	TCR_EL1
>>  EndSysreg
>>  
>> +Sysreg	TCR_EL2        3	4	2	0	2
>> +Res0	63:34
>> +Field	33	MTX
>> +Field	32	DS
>> +Res1	31
>> +Field	30	TCMA
>> +Field	29	TBID
>> +Field	28	HWU62
>> +Field	27	HWU61
>> +Field	26	HWU60
>> +Field	25	HWU59
>> +Field	24	HPD
>> +Res1	23
>> +Field	22	HD
>> +Field	21	HA
>> +Field	20	TBI
>> +Res0	19
>> +Field   18:16	PS
>> +UnsignedEnum	15:14	TG0
>> +	0b00	4K
>> +	0b01	64K
>> +	0b10	16K
>> +EndEnum
>> +UnsignedEnum	13:12	SH0
>> +	0b00	NONE
>> +	0b10	OUTER
>> +	0b11	INNER
>> +EndEnum
>> +UnsignedEnum	11:10	ORGN0
>> +	0b00	NC
>> +	0b01	WBWA
>> +	0b10	WT
>> +	0b11	WBnWA
>> +EndEnum
>> +UnsignedEnum	9:8	IRGN0
>> +	0b00	NC
>> +	0b01	WBWA
>> +	0b10	WT
>> +	0b11	WBnWA
>> +EndEnum
>> +Res0    7:6
>> +Field   5:0	T0SZ
>> +EndSysreg
> 
> This is only the E2H==0 version of TCR_EL2. IF you are going to
> describe this register in a useful manner, then add both formats so
> that we know what we are dealing with.

IIUC two different runtime layouts for TCR_EL2 is not possible to be
defined in current tools sysreg format. Also one layout is not just
a larger extension of the other - in which cases we could have just
defined the larger layout.

But curious do we have use cases for bits from the other layout now ?
