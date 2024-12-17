Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CDEC85260
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 04:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734410000; cv=none; b=atr7VXCnYDZoiaeJu9lxr3OhhrGgJE3xy4latWbABLVwwOYf+jxcUm4hsVyRUhR69JXckyP/nZ0AcyHA33jcVc4GiHMkaSUQWtqIDGoooH+c4bZdOPJ45OZgGi+YfWW8qb/E66IGBtma5NMIxbQWPlUiGl703Oo1AvpQ0s2xOKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734410000; c=relaxed/simple;
	bh=sd81yIlf0nBnARe0qAYmvCM77kaaeYj7T2eUfE939ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVr1DbvaP/RzA9xMwqT8paTrlR6w/SZdwKGCGj93MH6G6pA/F5jdSnbCyrq8OZkrv9l2Jv/eqxwEIUKSpZmUbZvo05XhgAWeHR8UTwunrydgijlndm8Ez/XmDzR3v+PmFgobxePt4S+7IayDhnTvMmqNQtofIcP9s8nYaFeiMV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E5411063;
	Mon, 16 Dec 2024 20:33:44 -0800 (PST)
Received: from [10.162.16.49] (a077893.blr.arm.com [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6F1E3F720;
	Mon, 16 Dec 2024 20:33:12 -0800 (PST)
Message-ID: <0b8a055f-eab9-4b44-baac-ad25756dbbfd@arm.com>
Date: Tue, 17 Dec 2024 10:03:10 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 18/46] arm64/sysreg: Add register fields for PMUACR_EL1
To: Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, ryan.roberts@arm.com,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-19-anshuman.khandual@arm.com>
 <20241216231505.GA601635-robh@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20241216231505.GA601635-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/17/24 04:45, Rob Herring wrote:
> On Tue, Dec 10, 2024 at 11:22:43AM +0530, Anshuman Khandual wrote:
>> This adds register fields for PMUACR_EL1 as per the definitions based
>> on DDI0601 2024-09.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/tools/sysreg | 37 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 37 insertions(+)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 214ad6da1dff..462adb8031ca 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -2349,6 +2349,43 @@ Res0	63:5
>>  Field	4:0	SEL
>>  EndSysreg
>>  
>> +Sysreg	PMUACR_EL1	3	0	9	14	4
> 
> I already added this and various other PMUv3.9 registers you've added 
> here in v6.12 and v6.13. So are you on an old base or the tool allows 
> multiple definitions? If the latter, that should be fixed.

This series is based on v6.13-rc1 and as you mentioned PMUACR_EL1 has
already been added into tools sysreg.

Sysreg  PMUACR_EL1      3       0       9       14      4
Res0    63:33
Field   32      F0
Field   31      C
Field   30:0    P
EndSysreg

Seems like the tool does allow multiple definitions for a single register.
The generated header (arch/arm64/include/generated/asm/sysreg-defs.h) does
include redundant blocks for the following.

#define REG_PMUACR_EL1                                  S3_0_C9_C14_4
#define SYS_PMUACR_EL1                                  sys_reg(3, 0, 9, 14, 4)
#define SYS_PMUACR_EL1_Op0                              3
#define SYS_PMUACR_EL1_Op1                              0
#define SYS_PMUACR_EL1_CRn                              9
#define SYS_PMUACR_EL1_CRm                              14
#define SYS_PMUACR_EL1_Op2                              4

#define PMUACR_EL1_C                                    GENMASK(31, 31)
#define PMUACR_EL1_C_MASK                               GENMASK(31, 31)
#define PMUACR_EL1_C_SHIFT                              31
#define PMUACR_EL1_C_WIDTH                              1

I am wondering how this did not cause any re-definition warning ?

> 
>> +Res0	63:33
>> +Field	32	FM
>> +Field	31	C
>> +Field	30	P30
>> +Field	29	P29
>> +Field	28	P28
>> +Field	27	P27
>> +Field	26	P26
>> +Field	25	P25
>> +Field	24	P24
>> +Field	23	P23
>> +Field	22	P22
>> +Field	21	P21
>> +Field	20	P20
>> +Field	19	P19
>> +Field	18	P18
>> +Field	17	P17
>> +Field	16	P16
>> +Field	15	P15
>> +Field	14	P14
>> +Field	13	P13
>> +Field	12	P12
>> +Field	11	P11
>> +Field	10	P10
>> +Field	9	P9
>> +Field	8	P8
>> +Field	7	P7
>> +Field	6	P6
>> +Field	5	P5
>> +Field	4	P4
>> +Field	3	P3
>> +Field	2	P2
>> +Field	1	P1
>> +Field	0	P0
> 
> We're never going to use Pnn defines. This is just useless bloat unless 
> we're aiming to top amd gpu defines LOC.

Okay, this patch was trying to be cautiously comprehensive. But anyways
PMUACR_EL1 has already been added and hence this is redundant now.
